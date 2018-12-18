#include <Msp430Adc12.h>

configuration StickC
{
    provides interface Read<uint16_t> as ReadStickX;
    provides interface Read<uint16_t> as ReadStickY;
}

implementation
{
    components StickP;
    components new AdcReadClientC() as ClientX;
    components new AdcReadClientC() as ClientY;

    ReadStickX = ClientX.Read;
    ReadStickY = ClientY.Read;

    ClientX.AdcConfigure->StickP.ConfigureX;
    ClientY.AdcConfigure->StickP.ConfigureY;
}