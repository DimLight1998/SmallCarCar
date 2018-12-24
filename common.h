#ifndef SMALLCARCAR_COMMON_H
#define SMALLCARCAR_COMMON_H

enum
{
    AM_BLINKTORADIO = 6,
    TIMER_PERIOD_MILLI = 100,
    TIMER_DANCE = 1000,
    DARK_THRES = 10,
    BRIGHT_THRES = 500
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