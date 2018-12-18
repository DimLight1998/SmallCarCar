#include <Timer.h>
#include "../common.h"

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
    StickStatusMsg *ssMsg = NULL;

    nx_uint8_t joyStickX;
    nx_uint8_t joyStickY;
    nx_uint8_t buttonADown;
    nx_uint8_t buttonBDown;
    nx_uint8_t buttonCDown;
    nx_uint8_t buttonDDown;
    nx_uint8_t buttonEDown;
    nx_uint8_t buttonFDown;

    event void Boot.booted()
    {
        call AMControl.start();
    }

    event void AMControl.startDone(error_t err)
    {
        if (err == SUCCESS)
        {
            call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
        }
        else
        {
            call AMControl.start();
        }
    }

    event void Timer0.fired()
    {
        if (!busy)
        {
            ssMsg = (StickStatusMsg *)(call Packet.getPayload(&pkt, sizeof(StickStatusMsg)));
            if (ssMsg == NULL)
            {
                return;
            }

            busy = TRUE;
            call Button.getButtonA();
        }
    }

    event void AMSend.sendDone(message_t * msg, error_t err)
    {
        if (&pkt == msg)
        {
            busy = FALSE;
        }
    }

    void SendMessage()
    {
        ssMsg -> JoyStickX = joyStickX;
        ssMsg -> JoyStickY = joyStickY;
        ssMsg -> ButtonADown = buttonADown;
        ssMsg -> ButtonBDown = buttonBDown;
        ssMsg -> ButtonCDown = buttonCDown;
        ssMsg -> ButtonDDown = buttonDDown;
        ssMsg -> ButtonEDown = buttonEDown;
        ssMsg -> ButtonFDown = buttonFDown;

        call AMSend.send(AM_BROADCAST_ADDR, ssMsg, sizeof(StickStatusMsg));
    }

    event void getButtonADone(bool High)
    {
        buttonADown = High ? 1 : 0;
        call Button.getButtonB();
    }

    event void getButtonBDone(bool High)
    {
        buttonBDown = High ? 1 : 0;
        call Button.getButtonC();
    }

    event void getButtonCDone(bool High)
    {
        buttonCDown = High ? 1 : 0;
        call Button.getButtonD();
    }

    event void getButtonDDone(bool High)
    {
        buttonDDown = High ? 1 : 0;
        call Button.getButtonE();
    }

    event void getButtonEDone(bool High)
    {
        buttonEDown = High ? 1 : 0;
        call Button.getButtonF();
    }

    event void getButtonFDone(bool High)
    {
        buttonFDown = High ? 1 : 0;
        call ReadStickX.read();
    }

    event void ReadStickX.readDone(error_t err, uint16_t val)
    {
        if (err == SUCCESS)
        {
            joyStickX = val;
            call ReadStickY.read();
        }
        else
        {
            call ReadStickX.read();
        }
    }

    event void ReadStickY.readDone(error_t err, uint16_t val)
    {
        if (err == SUCCESS)
        {
            joyStickY = val;

            call SendMessage();
        }
        else
        {
            call ReadStickX.read();
        }
    }
}
