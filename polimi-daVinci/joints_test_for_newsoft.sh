rostopic pub /SUJ/PSM1/move_jp sensor_msgs/JointState "header:
  seq: 0
  stamp: {secs: 0, nsecs: 0}
  frame_id: ''
name: ['']
position: [0.768,-0.418879,-1.378810,-0.331613,-0.942478,0.191986]
velocity: [0]
effort: [0]" & rostopic pub /SUJ/PSM2/move_jp sensor_msgs/JointState "header:
  seq: 0
  stamp: {secs: 0, nsecs: 0}
  frame_id: ''
name: ['']
position: [0.733,0.436332,1.614430,-0.139626,0.872665,-0.017453]
velocity: [0] 
effort: [0]" & rostopic pub /SUJ/ECM/move_jp sensor_msgs/JointState "header:
  seq: 0
  stamp: {secs: 0, nsecs: 0}
  frame_id: ''
name: ['']
position: [1.41,0.0,-0.017453,3.132866,0.0,0.0]
effort: [0]" &

