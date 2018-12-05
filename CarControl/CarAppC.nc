configuration CarAppC
{
}

implementation
{
    components CarC;
    components HplMsp430UsartOC;
    components Msp430UartOC;
    components HplMsp430GeneralIOC;

    CarC.HplMsp430Usart -> HplMsp430UsartOC;
    CarC.HplMsp430UsartInterrupts -> HplMsp430UsartOC;
    CarC.Resource -> Msp430UartOC;
    CarC.HplMsp430GeneralIO -> HplMsp430GeneralIOC;
}