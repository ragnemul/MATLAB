#! /usr/bin/env python

import yarp
import asrob_yarp_devices

class Robot:
    def __init__(self):
        yarp.Network.init()
        
        if yarp.Network.checkNetwork() != True:
            print "[error] Please try running yarp server"
            quit()

        robotOptions = yarp.Property()
        robotOptions.put('device','RobotClient')
        robotOptions.put('name','/ecroSim')
        self.robotDevice = yarp.PolyDriver(robotOptions)  # calls open -> connects

        self.motors = asrob_yarp_devices.viewIRobotManager(self.robotDevice)  # view the actual interface

