interface Button
{
    command void begin();
    command void getButtonA();
    command void getButtonB();
    command void getButtonC();
    command void getButtonD();
    command void getButtonE();
    command void getButtonF();

    event void have_begun();
    event void getButtonADone(bool High);
    event void getButtonBDone(bool High);
    event void getButtonCDone(bool High);
    event void getButtonDDone(bool High);
    event void getButtonEDone(bool High);
    event void getButtonFDone(bool High);
}