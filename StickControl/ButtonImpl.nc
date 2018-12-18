module ButtonImpl
{
    provides interface Button;

    uses interface HplMsp430GeneralIO as ButtonA;
    uses interface HplMsp430GeneralIO as ButtonB;
    uses interface HplMsp430GeneralIO as ButtonC;
    uses interface HplMsp430GeneralIO as ButtonD;
    uses interface HplMsp430GeneralIO as ButtonE;
    uses interface HplMsp430GeneralIO as ButtonF;
}

implementation
{
    command void Button.begin()
    {
        call ButtonA.clr();
        call ButtonB.clr();
        call ButtonC.clr();
        call ButtonD.clr();
        call ButtonE.clr();
        call ButtonF.clr();

        call ButtonA.makeInput();
        call ButtonB.makeInput();
        call ButtonC.makeInput();
        call ButtonD.makeInput();
        call ButtonE.makeInput();
        call ButtonF.makeInput();

        signal Button.have_begun();
    }

    command void Button.getButtonA()
    {
        signal Button.getButtonADone(call ButtonA.get());
    }
    command void Button.getButtonB()
    {
        signal Button.getButtonBDone(call ButtonB.get());
    }
    command void Button.getButtonC()
    {
        signal Button.getButtonCDone(call ButtonC.get());
    }
    command void Button.getButtonD()
    {
        signal Button.getButtonDDone(call ButtonD.get());
    }
    command void Button.getButtonE()
    {
        signal Button.getButtonEDone(call ButtonE.get());
    }
    command void Button.getButtonF()
    {
        signal Button.getButtonFDone(call ButtonF.get());
    }
}