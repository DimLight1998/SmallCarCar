configuration CarAppC
{
    provides interface Car;
}

implementation
{
    components CarC;
    components HplMsp430Usart0C;
    components Msp430Uart0C;

    Car = CarC.Car;

    CarC.HplMsp430Usart->HplMsp430Usart0C.HplMsp430Usart;
    CarC.Resource->Msp430UartOC.Resource;
}