#include <yarp/os/all.h>
#include <yarp/dev/all.h>

#include "IRobotManager.hpp" // we need this to work with the RobotClient device

int main(int argc, char *argv[])
{
    yarp::os::Network yarp;

    if (!yarp::os::Network::checkNetwork())
    {
        printf("Please start a yarp name server first\n");
        return 1;
    }

    yarp::os::Property robotOptions;
    robotOptions.put("device", "RobotClient"); // our device (a dynamically loaded library)
    robotOptions.put("name", "/ecroSim"); // remote port through which we'll talk to the server

    yarp::dev::PolyDriver robotDevice;
    if ( ! robotDevice.open(robotOptions) )
    {
        printf("Device not available.\n");
        robotDevice.close();
        return 1;
    }

    asrob::IRobotManager *robot;

    if ( ! robotDevice.view(robot) )
    {
        printf("[error] Problems acquiring interface\n");
        robotDevice.close();
        return 1;
    }
    printf("[success] acquired motor interface\n");

    printf("moveForward(4.3)\n");
    robot->moveForward(4.3);

    printf("delay(4.5)\n");
    yarp::os::Time::delay(4.5);  // delay in [seconds]

    printf("robot.turnLeft(100.0)\n");
    robot->turnLeft(100.0);

    printf("delay(2.0)\n");
    yarp::os::Time::delay(2.0);  // delay in [seconds]

    printf("moveForward(1.2)\n");
    robot->moveForward(1.2);

    printf("delay(1.5)\n");
    yarp::os::Time::delay(1.5);  // delay in [seconds]

    printf("robot.turnLeft(-25.0)\n");
    robot->turnLeft(-25.0);

    printf("delay(1.0)\n");
    yarp::os::Time::delay(1.0);  // delay in [seconds]

    printf("stopMovement()\n");
    robot->stopMovement();

    robotDevice.close();

    return 0;
}
