module CarC @safe()
{
    uses interface Car;
    uses interface HplMsp430Usart;
    uses interface HplMsp430UsartInterrupts;
    uses interface Resource;
    uses interface HplMsp430GeneralIO;
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
            utxe: 1,
            urxe: 1,
            ubr: UBR_1MHZ_115200,
            umctl: UMCTL_1MHZ_115200,
            ssel: 0x02,
            pena: 0,
            pev: 0,
            spb: 0,
            clen: 1,
            listen: 0,
            mm: 0,
            ckpl: 0,
            urxse: 0,
            urxeie: 0,
            urxwie: 0,
            utxe: 1,
            urxe: 1
        }
    };

    command error_t Car.Angle(uint16_t value)
    {

    }

    command error_t Car.Angle_Senc(uint16_t value)
    {

    }

    command error_t Car.Angle_Third(uint16_t value)
    {

    }

    command error_t Car.Forward(uint16_t value)
    {
        newestCommand[2] = 0x02;
        newestCommand[3] = 0x02;
        newestCommand[4] = 0x00;
        call Resource.request();
        return SUCCESS;
    }

    command error_t Car.Back(uint16_t value)
    {
        newestCommand[2] = 0x03;
        newestCommand[3] = 0x02;
        newestCommand[4] = 0x00;
        call Resource.request();
        return SUCCESS;
    }

    command error_t Car.Left(uint16_t value)
    {
        newestCommand[2] = 0x04;
        newestCommand[3] = 0x02;
        newestCommand[4] = 0x00;
        call Resource.request();
        return SUCCESS;
    }

    command error_t Car.Right(uint16_t value)
    {
        newestCommand[2] = 0x05;
        newestCommand[3] = 0x02;
        newestCommand[4] = 0x00;
        call Resource.request();
        return SUCCESS;
    }

    command error_t Car.QuiryReader(uint16_t value)
    {

    }

    command error_t Car.Pause(uint16_t value)
    {
        newestCommand[2] = 0x06;
        newestCommand[3] = 0x00;
        newestCommand[4] = 0x00;
        call Resource.request();
        return SUCCESS;
    }

    command error_t Car.InitMaxSpeed(uint16_t value)
    {

    }

    command error_t Car.InitMinSpeed(uint16_t value)
    {

    }

    command error_t Car.InitLeftServo(uint16_t value)
    {

    }

    command error_t Car.InitRightServo(uint16_t value)
    {

    }

    command error_t Car.InitMiddleServo(uint16_t value)
    {

    }
    
    event void Car.readDone(error_t state, uint16_t data)
    {

    }

    event void Resource.granted()
    {
        HplMsp430Usart.setModeUart(&config);
        HplMsp430Usart.enableUart();

        int i = 0;
        for(i = 0; i < 8; i++)
        {
            HplMsp430Usart.tx(newestCommand[i]);
            while(!HplMsp430Usart.isTxEmpty())
            {
            }
        }

        Resource.release();
    }
}
