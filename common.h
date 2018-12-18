#ifndef SMALLCARCAR_COMMON_H
#define SMALLCARCAR_COMMON_H

enum
{
    AM_BLINKTORADIO = 6,
    TIMER_RERIOD_MILLI = 100,

    STICK_STOP_THRES = 0, // TODO

};

typedef nx_struct StickStatusMsg {
    nx_uint8_t JoyStickX;
    nx_uint8_t JoyStickY;
    nx_uint8_t ButtonADown;
    nx_uint8_t ButtonBDown;
    nx_uint8_t ButtonCDown;
    nx_uint8_t ButtonDDown;
    nx_uint8_t ButtonEDown;
    nx_uint8_t ButtonFDown;
} StickStatusMsg;

#endif