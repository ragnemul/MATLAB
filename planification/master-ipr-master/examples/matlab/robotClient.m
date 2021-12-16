LoadYarp;  % yarp.matlab.LoadYarp

robotClient = yarp.Port;
robotClient.open('/matlab/ecroSim/rpc:c');
yarp.Network.connect('/matlab/ecroSim/rpc:c','/ecroSim/rpc:s');


disp 'moveForward(4.3)'
b = yarp.Bottle;
b.addVocab( yarp.Vocab.encode('movf') );
b.addDouble(3.0);
robotClient.write(b);

disp 'delay(4.5)'
pause(4.5);

disp 'turnLeft(100.0)'
b.clear();
b.addVocab( yarp.Vocab.encode('trnl') );
b.addDouble(100.0);
robotClient.write(b);

disp 'delay(2.0)'
pause(2.0);

disp 'moveForward(1.2)'
b.clear();
b.addVocab( yarp.Vocab.encode('movf') );
b.addDouble(1.2);
robotClient.write(b);

disp 'delay(1.5)'
pause(1.5);

disp 'turnLeft(-25.0)'
b.clear();
b.addVocab( yarp.Vocab.encode('trnl') );
b.addDouble(-25.0);
robotClient.write(b);

disp 'delay(1.0)'
pause(1.0);

disp 'stopMovement()'
b.clear();
b.addVocab( yarp.Vocab.encode('stpm') );
robotClient.write(b);

robotClient.close();
