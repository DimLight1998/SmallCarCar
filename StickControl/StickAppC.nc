#include <Msp430Adc12.h>

configuration StickAppC
{
    provides interface Read<uint16_t> as ReadStickX;
    provides interface Read<uint16_t> as ReadStickY;
}

implementation
{
    components StickC;
    components new AdcReadClientC() as ClientX;
    components new AdcReadClientC() as ClientY;

    ReadStickX = ClientX.Read;
    ReadStickY = ClientY.Read;

    ClientX.AdcConfigure->StickC.ConfigureX;
    ClientY.AdcConfigure->StickC.ConfigureY;
}