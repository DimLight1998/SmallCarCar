#include "../common.h"
#include <Timer.h>
#include "printf.h"

module BlinkToRadioC
{
    uses interface Boot;
    uses interface Leds;
    uses interface Timer<TMilli> as Timer0;
    uses interface Packet;
    uses interface AMPacket;
    uses interface AMSend;
    uses interface SplitControl as AMControl;
    uses interface Button;
    uses interface Read<uint16_t> as ReadStickX;
    uses interface Read<uint16_t> as ReadStickY;
}

implementation
{
    message_t pkt;
    bool busy = FALSE;
    StickStatusMsg* ssMsg = NULL;

    uint16_t joyStickX;
    uint16_t joyStickY;
    uint16_t buttonADown;
    uint16_t buttonBDown;
    uint16_t buttonCDown;
    uint16_t buttonDDown;
    uint16_t buttonEDown;
    uint16_t buttonFDown;

    event void Boot.booted()
    {
        call AMControl.start();
        call Button.begin();
    }

    event void AMControl.startDone(error_t err)
    {
        if (err == SUCCESS) {
            call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
        } else {
            call AMControl.start();
        }
    }

    event void Timer0.fired()
    {
        if (!busy) {
            ssMsg = (StickStatusMsg*)(call Packet.getPayload(&pkt, sizeof(StickStatusMsg)));
            if (ssMsg == NULL) {
                return;
            }

            busy = TRUE;
            call Button.getButtonA();
        }
    }

    event void AMSend.sendDone(message_t * msg, error_t err)
    {
        if (&pkt == msg) {
            busy = FALSE;
        }
    }

    void SendMessage()
    {
        uint8_t ledMask = 0;
        ssMsg->JoyStickX = 0;
        ssMsg->JoyStickY = 0;
        ssMsg->ButtonADown = buttonADown;
        ssMsg->ButtonBDown = buttonBDown;
        ssMsg->ButtonCDown = buttonCDown;
        ssMsg->ButtonDDown = buttonDDown;
        ssMsg->ButtonEDown = buttonEDown;
        ssMsg->ButtonFDown = buttonFDown;

        printf("%u %u %u %u %u %u\n", buttonADown, buttonBDown, buttonCDown, buttonDDown, buttonEDown, buttonFDown);
        printfflush();

        if (joyStickX > 0x600 && joyStickX < 0xA00 && joyStickY > 0x600 && joyStickY < 0x800) {
            // almost center of the joystick, do nothing
        } else if (joyStickX < 0x600 && joyStickY > joyStickX && joyStickY + joyStickX < 0x1000) {
            ssMsg->JoyStickX = 1;
            ledMask |= LEDS_LED0;
        } else if (joyStickX > 0xA00 && joyStickX > joyStickY && joyStickY + joyStickX > 0x1000) {
            ssMsg->JoyStickX = 2;
            ledMask |= LEDS_LED0;
        } else if (joyStickY < 0x600 && joyStickX > joyStickY && joyStickX + joyStickY < 0x1000) {
            ssMsg->JoyStickY = 1;
            ledMask |= LEDS_LED1;
        } else if (joyStickY > 0xA00 && joyStickY > joyStickX && joyStickX + joyStickY > 0x1000) {
            ssMsg->JoyStickY = 2;
            ledMask |= LEDS_LED1;
        }

        if((buttonADown ^ buttonBDown) || (buttonCDown ^ buttonDDown) || (buttonEDown ^ buttonFDown)) {
            ledMask |= LEDS_LED2;
        }

        call Leds.set(ledMask);

        call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(StickStatusMsg));
    }

    event void Button.getButtonADone(bool High)
    {
        buttonADown = High ? 1 : 0;
        call Button.getButtonB();
    }

    event void Button.getButtonBDone(bool High)
    {
        buttonBDown = High ? 1 : 0;
        call Button.getButtonC();
    }

    event void Button.getButtonCDone(bool High)
    {
        buttonCDown = High ? 1 : 0;
        call Button.getButtonD();
    }

    event void Button.getButtonDDone(bool High)
    {
        buttonDDown = High ? 1 : 0;
        call Button.getButtonE();
    }

    event void Button.getButtonEDone(bool High)
    {
        buttonEDown = High ? 1 : 0;
        call Button.getButtonF();
    }

    event void Button.getButtonFDone(bool High)
    {
        buttonFDown = High ? 1 : 0;
        call ReadStickX.read();
    }

    event void ReadStickX.readDone(error_t err, uint16_t val)
    {
        if (err == SUCCESS) {
            joyStickX = val;
            call ReadStickY.read();
        } else {
            call ReadStickX.read();
        }
    }

    event void ReadStickY.readDone(error_t err, uint16_t val)
    {
        if (err == SUCCESS) {
            joyStickY = val;

            SendMessage();
        } else {
            call ReadStickX.read();
        }
    }

    event void AMControl.stopDone(error_t err) {
     // nothing
    }

    event void Button.have_begun() {
        // nothing
    }
}
