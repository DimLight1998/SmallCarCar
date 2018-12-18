#include "../common.h"
#include <Timer.h>

module BlinkToRadioC
{
    uses interface Boot;
    uses interface Receive;
    uses interface SplitControl as AMControl;
    uses interface Car;
}

implementation
{
    uint16_t Angle1 = 3400;
    uint16_t Angle2 = 3400;
    uint16_t Angle3 = 3400;

    uint16_t InitAngle1 = 3400;
    uint16_t InitAngle2 = 3400;
    uint16_t InitAngle3 = 3400;

    uint16_t AngleDelta = 100;

    uint16_t AngleMax = 5000;
    uint16_t AngleMin = 1800;

    event void Boot.booted() { call AMControl.start(); }

    event void AMControl.startDone(error_t err)
    {
        if (err != SUCCESS) {
            call AMControl.start();
        }
    }

    event message_t* Receive.receive(message_t * msg, void* payload, uint8_t len)
    {
        if (len == sizeof(StickStatusMsg)) {
            StickStatusMsg* ssMsg = (StickStatusMsg*)payload;

            // decode the message
            uint8_t joyStickX = ssMsg->JoyStickX;
            uint8_t joyStickY = ssMsg->JoyStickY;
            uint8_t buttonADown = ssMsg->ButtonADown;
            uint8_t buttonBDown = ssMsg->ButtonBDown;
            uint8_t buttonCDown = ssMsg->ButtonCDown;
            uint8_t buttonDDown = ssMsg->ButtonDDown;
            uint8_t buttonEDown = ssMsg->ButtonEDown;
            uint8_t buttonFDown = ssMsg->ButtonFDown;

            // is this a reset command ?
            if (buttonADown && buttonBDown && buttonCDown) {
                call Car.Pause();
                call Car.Angle1(InitAngle1);
                call Car.Angle2(InitAngle2);
                call Car.Angle3(InitAngle3);

                return msg;
            }

            // decode joyStick for movement status
            if (joyStickX > 0x600 && joyStickX < 0xA00 && joyStickY > 0x600 && joyStickY < 0x800) {
                // almost center of the joystick, do nothing
                call Car.Pause();
            } else if (joyStickX < 0x600 && joyStickY > joyStickX && joyStickY + joyStickX < 0x1000) {
                call Car.Forward(500);
            } else if (joyStickX > 0xA00 && joyStickX > joyStickY && joyStickY + joyStickX > 0x1000) {
                call Car.Back(500);
            } else if (joyStickY < 0x600 && joyStickX > joyStickY && joyStickX + joyStickY < 0x1000) {
                call Car.Left(500);
            } else if (joyStickY > 0xA00 && joyStickY > joyStickX && joyStickX + joyStickY > 0x1000) {
                call Car.Right(500);
            } else {
                // other cases, fallback to pause
                call Car.Pause();
            }

            // decode buttons for rotation status
            if (buttonADown ^ buttonBDown) {
                if (buttonADown) {
                    Angle1 = Angle1 + AngleDelta;
                } else {
                    Angle1 = Angle1 - AngleDelta;
                }

                Angle1 = Angle1 > AngleMax ? Angle1 : AngleMax;
                Angle1 = Angle1 < AngleMin ? Angle1 : AngleMin;
                call Car.Angle1(Angle1);
            }
            if (buttonCDown ^ buttonDDown) {
                if (buttonCDown) {
                    Angle2 = Angle2 + AngleDelta;
                } else {
                    Angle2 = Angle2 - AngleDelta;
                }

                Angle2 = Angle2 > AngleMax ? Angle2 : AngleMax;
                Angle2 = Angle2 < AngleMin ? Angle2 : AngleMin;
                call Car.Angle2(Angle2);
            }
            if (buttonEDown ^ buttonFDown) {
                if (buttonEDown) {
                    Angle3 = Angle3 + AngleDelta;
                } else {
                    Angle3 = Angle3 - AngleDelta;
                }

                Angle3 = Angle3 > AngleMax ? Angle3 : AngleMax;
                Angle3 = Angle3 < AngleMin ? Angle3 : AngleMin;
                call Car.Angle3(Angle3);
            }
        }
        return msg;
    }

    
    event void Car.SendDone(error_t state, uint16_t data)
    {
        // nothing
    }

 event void AMControl.stopDone(error_t err){
     // nothing
 }
}
