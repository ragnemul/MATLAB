#! /usr/bin/env python

import yarp
import asrob_yarp_devices

yarp.Network.init()

if not yarp.Network.checkNetwork():
    print "[error] Please try running yarp server"
    quit()

robotOptions = yarp.Property()
robotOptions.put('device','RobotClient')
robotOptions.put('name','/ecroSim')
robotDevice = yarp.PolyDriver(robotOptions)  # calls open -> connects

robot = asrob_yarp_devices.viewIRobotManager(robotDevice)  # view the actual interface

print "moveForward(4.3)"
robot.moveForward(4.3)

print "delay(4.5)"
yarp.Time.delay(4.5)  # delay in [seconds]

print "robot.turnLeft(100.0)"
robot.turnLeft(100.0)

print "delay(2.0)"
yarp.Time.delay(2.0)  # delay in [seconds]

print "moveForward(1.2)"
robot.moveForward(1.2)

print "delay(1.5)"
yarp.Time.delay(1.5)  # delay in [seconds]

print "robot.turnLeft(-25.0)"
robot.turnLeft(-25.0)

print "delay(1.0)"
yarp.Time.delay(1.0)  # delay in [seconds]

print "stopMovement()"
robot.stopMovement()

robotDevice.close()
