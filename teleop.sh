#!/bin/bash

SESSION_NAME="teleop"

# Kill existing session if it exists
tmux has-session -t "$SESSION_NAME" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "Session '$SESSION_NAME' exists. Killing it..."
    tmux kill-session -t "$SESSION_NAME"
fi

# Create a new detached tmux session
tmux new-session -d -s "$SESSION_NAME" -n main

# Right pane (roscore)
tmux split-pane -h 'roscore; bash'

# Bottom-right: close relays + feedback based on output
tmux split-pane -v 'cd ~/catkin_ws; source devel/setup.bash; \
OUTPUT=$(qlacommand -c close-relays 2>&1); \
echo "$OUTPUT"; \
if echo "$OUTPUT" | grep -q "Executing command \"close-relays\" on 11 nodes"; then \
  echo -e "\e[32mSAFETY RELAYS CLOSED -- OK\e[0m"; \
else \
  echo -e "\e[31mCOULD NOT CLOSE SAFETY RELAYS -- PLUG AND UNPLUG FIREWIRE CABLE\e[0m"; \
fi; \
bash'

# Split another pane and launch gst-launch-1.0 device 1 on DP-2 (X=3840)
tmux split-pane -v 'gst-launch-1.0 -v \
  decklinkvideosrc device-number=1 ! tee name=t \
  t. ! queue ! videoconvert ! autovideosink \
  t. ! queue ! videoconvert ! autovideosink
 & \
   PID=$!; sleep 1; \
   WIN_ID=$(xdotool search --name "gst-launch-1.0" | tail -n 1); \
   if [ -n "$WIN_ID" ]; then \
     xdotool windowmove $WIN_ID 3840 0; \
     xdotool windowsize $WIN_ID 1024 768; \
   fi; \
   wait $PID; bash'
# Split pane and launch gst-launch-1.0 device 0
tmux split-pane -v 'gst-launch-1.0 decklinkvideosrc device-number=0 ! videoconvert ! autovideosink & \
   PID=$!; sleep 1; \
   WIN_ID=$(xdotool search --name "gst-launch-1.0" | head -n 1); \
   if [ -n "$WIN_ID" ]; then \
     xdotool windowmove $WIN_ID 4864 0; \
     xdotool windowsize $WIN_ID 1024 768; \
   fi; \
   wait $PID; bash' 


# Left-top pane: run dVRK console
tmux select-pane -t "$SESSION_NAME":0.0
tmux split-pane -v 'sleep 1; cd ~/catkin_ws/src/cisst-saw/sawIntuitiveResearchKit/share/polimi-daVinci; \
rosrun dvrk_robot dvrk_system -j system-SUJ-ECM-MTMR-PSM1-MTML-PSM2-Teleop.json; bash'

# Attach to the session
tmux attach-session -t "$SESSION_NAME"
