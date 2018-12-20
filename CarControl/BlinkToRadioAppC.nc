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
    components LedsC;
    components new TimerMilliC() as Timer0;
    components new HamamatsuS1087ParC() as LightSensor;

    App.Boot->MainC;
    App.AMControl->ActiveMessageC;
    App.Receive->AMReceiverC;
    App.Car->CarC.Car;
    App.Leds->LedsC;
    App.Timer0->Timer0;
    App.ReadLight->LightSensor;
}
