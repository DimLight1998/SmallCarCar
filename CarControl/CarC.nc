configuration CarC
{
    provides interface Car;
}

implementation
{
    components CarImpl;
    components HplMsp430Usart0C;
    components new Msp430Uart0C();

    Car = CarImpl.Car;

    CarImpl.HplMsp430Usart->HplMsp430Usart0C.HplMsp430Usart;
    CarImpl.Resource->Msp430Uart0C.Resource;
}