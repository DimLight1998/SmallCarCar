#ifndef SMALLCARCAR_COMMON_H
#define SMALLCARCAR_COMMON_H

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