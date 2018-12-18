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
    components new AMReceiverC(AM_BLINKTORADIO);
    components CarC;

    App.Boot->MainC;
    App.AMControl->ActiveMessageC;
    App.Receive->AMReceiverC;
    App.Car->CarC.Car;
}
