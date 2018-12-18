#include <Timer.h>
#include "BlinkToRadio.h"

configuration BlinkToRadioAppC
{
}

implementation
{
    components MainC;
    components BlinkToRadioC as App;
    components new TimerMilliC() as Timer0;
    components ActiveMessageC;
    components new AMSenderC(AM_BLINKTORADIO);
    components ButtonC;
    components StickC;

    App.Boot -> MainC;
    App.Timer0 -> Timer0;
    App.Packet -> AMSenderC;
    App.AMPacket -> AMSenderC;
    App.AMControl -> ActiveMessageC;
    App.AMSend -> AMSenderC;
    App.Button -> ButtonC.Button;
    App.ReadStickX -> StickC.ReadStickX;
    App.ReadStickY -> StickC.ReadStickY;
}
