#include "../common.h"
#include <Timer.h>

configuration BlinkToRadioAppC
{
}

implementation
{
    components MainC;
    components BlinkToRadioC as App;
    components ActiveMessageC;
    components new AMSenderC(AM_BLINKTORADIO);    
    components new AMReceiverC(AM_BLINKTORADIO);
    components CarC;

    App.Boot->MainC;
    App.Packet->AMSenderC;
    App.AMPacket->AMSenderC;
    App.AMControl->ActiveMessageC;
    App.AMSend->AMSenderC;
    App.Receive->AMReceiverC;
    App.Car->CarC.Car;
}
