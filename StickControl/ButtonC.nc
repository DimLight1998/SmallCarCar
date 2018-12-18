configuration ButtonC
{
    provides interface Button;
}

implementation
{
    components ButtonImpl;
    components HplMsp430GeneralIOC as IOC;

    ButtonImpl.ButtonA->IOC.Port60;
    ButtonImpl.ButtonB->IOC.Port21;
    ButtonImpl.ButtonC->IOC.Port61;
    ButtonImpl.ButtonD->IOC.Port23;
    ButtonImpl.ButtonE->IOC.Port62;
    ButtonImpl.ButtonF->IOC.Port26;

    Button = ButtonImpl;
}