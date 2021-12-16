from RobotPy import Robot
from time import sleep

robot = Robot()
robot.motors.moveForward(5)

sleep(5) # delay in [seconds]

robot.motors.stopMovement()
