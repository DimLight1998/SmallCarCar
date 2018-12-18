#include <Msp430Adc12.h>

configuration StickC
{
    provides interface Read<uint16_t> as ReadStickX;
    provides interface Read<uint16_t> as ReadStickY;
}

implementation
{
    components StickImpl;
    components new AdcReadClientC() as ClientX;
    components new AdcReadClientC() as ClientY;

    ReadStickX = ClientX.Read;
    ReadStickY = ClientY.Read;

    ClientX.AdcConfigure->StickImpl.ConfigureX;
    ClientY.AdcConfigure->StickImpl.ConfigureY;
}