configuration ButtonC
{
    provides interface Button;
}

implementation
{
    components ButtonP;
    components HplMsp430GeneralIOC as IOC;

    ButtonP.ButtonA->IOC.Port60;
    ButtonP.ButtonB->IOC.Port21;
    ButtonP.ButtonC->IOC.Port61;
    ButtonP.ButtonD->IOC.Port23;
    ButtonP.ButtonE->IOC.Port62;
    ButtonP.ButtonF->IOC.Port26;

    Button = ButtonP;
}