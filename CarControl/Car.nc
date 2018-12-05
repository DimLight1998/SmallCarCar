interface Car
{
    command error_t Angle1(uint16_t value);
    command error_t Angle2(uint16_t value);
    command error_t Angle3(uint16_t value);
    command error_t Forward(uint16_t value);
    command error_t Back(uint16_t value);
    command error_t Left(uint16_t value);
    command error_t Right(uint16_t value);
    command error_t Pause();

    event void SendDone(error_t state, uint16_t data);
}
