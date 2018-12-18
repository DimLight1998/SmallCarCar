configuration ButtonAppC
{
    provides interface Button;
}

implementation
{
    components ButtonC;
    components HplMsp430GeneralIOC as IOC;

    ButtonC.ButtonA->IOC.Port60;
    ButtonC.ButtonB->IOC.Port21;
    ButtonC.ButtonC->IOC.Port61;
    ButtonC.ButtonD->IOC.Port23;
    ButtonC.ButtonE->IOC.Port62;
    ButtonC.ButtonF->IOC.Port26;

    Button = ButtonC;
}