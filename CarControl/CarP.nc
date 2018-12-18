module CarP @safe()
{
    provides interface Car;
    uses interface HplMsp430Usart;
    uses interface Resource;
}

implementation
{
    uint8_t newestCommand[8] = {
        0x01, 0x02,
        0x00, 0x00, 0x00,
        0xff, 0xff, 0x00
    };
    msp430_uart_union_config_t config = {
        {
            utxe : 1,
            urxe : 1,
            ubr : UBR_1MHZ_115200,
            umctl : UMCTL_1MHZ_115200,
            ssel : 0x02,
            pena : 0,
            pev : 0,
            spb : 0,
            clen : 1,
            listen : 0,
            mm : 0,
            ckpl : 0,
            urxse : 0,
            urxeie : 0,
            urxwie : 0,
            utxe : 1,
            urxe : 1
        }
    };
    bool isSending = FALSE;
    int i;

    error_t SendBytes(uint8_t byte2, uint8_t byte3, uint8_t byte4)
    {
        if (isSending) {
            // return in advance to avoid newestCommand be modified
            return EBUSY;
        } else {
            isSending = TRUE;
        }

        newestCommand[2] = byte2;
        newestCommand[3] = byte3;
        newestCommand[4] = byte4;
        call Resource.request();
        return SUCCESS;
    }

    command error_t Car.Angle1(uint16_t value)
    {
        return SendBytes(0x01, value >> 8, value & 0xff);
    }

    command error_t Car.Angle2(uint16_t value)
    {
        return SendBytes(0x07, value >> 8, value & 0xff);
    }

    command error_t Car.Angle3(uint16_t value)
    {
        return SendBytes(0x08, value >> 8, value & 0xff);
    }

    command error_t Car.Forward(uint16_t value)
    {
        return SendBytes(0x02, value >> 8, value & 0xff);
    }

    command error_t Car.Back(uint16_t value)
    {
        return SendBytes(0x03, value >> 8, value & 0xff);
    }

    command error_t Car.Left(uint16_t value)
    {
        return SendBytes(0x04, value >> 8, value & 0xff);
    }

    command error_t Car.Right(uint16_t value)
    {
        return SendBytes(0x05, value >> 8, value & 0xff);
    }

    command error_t Car.Pause()
    {
        return SendBytes(0x06, 0x00, 0x00);
    }

    event void Resource.granted()
    {
        call HplMsp430Usart.setModeUart(&config);
        call HplMsp430Usart.enableUart();
        atomic {
            U0CTL &= ~SYNC;
        }

        for (i = 0; i < 8; i++) {
            while (!(call HplMsp430Usart.isTxEmpty())) {
            }
            call HplMsp430Usart.tx(newestCommand[i]);
            while (!(call HplMsp430Usart.isTxEmpty())) {
            }
        }

        call Resource.release();
        isSending = FALSE;
        signal Car.SendDone(SUCCESS, 0);
    }
}
