#include "../common.h"
#include <Timer.h>

module BlinkToRadioC
{
    uses interface Boot;
    uses interface Receive;
    uses interface SplitControl as AMControl;
    uses interface Car;
    uses interface Leds;
    uses interface Timer<TMilli> as Timer0;
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
    uint16_t TimerCount = 0;

    event void Boot.booted() { call AMControl.start(); }

    event void AMControl.startDone(error_t err)
    {
        if (err != SUCCESS) {
            call AMControl.start();
        } else {
            call Timer0.startPeriodic(TIMER_DANCE);
        }
    }

    event void Timer0.fired() {
        if(TimerCount==0) {
            call Car.Forward(500);
            call Leds.set(1);
        } else if(TimerCount==1) {
            call Car.Back(500);
            call Leds.set(2);
        } else if(TimerCount==2) {
            call Car.Left(500);
            call Leds.set(3);
        } else if(TimerCount==3) {
            call Car.Right(500);
            call Leds.set(4);
        } else if(TimerCount==4) {
            call Car.Pause();
        } else if(TimerCount==5) {
            call Car.Angle1(AngleMin);
            call Leds.set(5);
        } else if(TimerCount==6) {
            call Car.Angle1(AngleMax);
        } else if(TimerCount==7) {
            call Car.Angle1(InitAngle1);
        } else if(TimerCount==8) {
            call Car.Angle2(AngleMin);
            call Leds.set(6);
        } else if(TimerCount==9) {
            call Car.Angle2(AngleMax);
        } else if(TimerCount==10) {
            call Car.Angle2(InitAngle2);
        } else if(TimerCount==11) {
            call Car.Angle3(AngleMin);
            call Leds.set(7);
        } else if(TimerCount==12) {
            call Car.Angle3(AngleMax);
        } else if(TimerCount==13) {
            call Car.Angle3(InitAngle3);
        }

        TimerCount++;
    }

    event message_t* Receive.receive(message_t * msg, void* payload, uint8_t len)
    {
        if(TimerCount<=13) {
          return msg;
        }
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

            uint8_t ledMask = 0;

            // is this a reset command ?
            if (buttonADown && buttonBDown && buttonCDown) {
                call Car.Pause();
                call Car.Angle1(InitAngle1);
                call Car.Angle2(InitAngle2);
                call Car.Angle3(InitAngle3);

                return msg;
            }

            // decode joyStick for movement status
            if (joyStickX == 1) {
                call Car.Left(500);
                ledMask |= LEDS_LED0;
            } else if (joyStickX == 2) {
                call Car.Right(500);
                ledMask |= LEDS_LED0;
            } else if (joyStickY == 1) {
                call Car.Forward(500);
                ledMask |= LEDS_LED1;
            } else if (joyStickY == 2) {
                call Car.Back(500);
                ledMask |= LEDS_LED1;
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
                ledMask |= LEDS_LED2;
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
                ledMask |= LEDS_LED2;
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
                ledMask |= LEDS_LED2;
            }
            call Leds.set(ledMask);
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
