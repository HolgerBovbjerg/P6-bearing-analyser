#ifndef MMA8451_H_
#define MMA8451_H_

#endif /*MMA8451_H_*/

void inits();
void MMAbegin();
void MMAread();
void requestFromArduino(Int16 flag);
void rpmReadI2C(Int16 *rpmdata);
void fft_create_datapoint_array(Int16 *real_array, Uint16 fft_length, Int16 *fft_pointer);
Int16 RMS(Int16 *data, Int16 length);


void codecRead(Int16 *real, Int16 sampleLength);
Int16 peakDetect(Int16 *data,Int16 *peakArray, Int16 length, Int16 limit);
void printErrorMessages(Int32 expBits, Int32 fractionBits, Int16 rms, Int16 HZ, Int16 peakF, Int16 crestEx, Int16 crestFra, Int16 maxV);
void calculate_abs(Int16 real, Int16 imag, Int32 *absolute_ptr, Int16 current_entry);
Int32 peaksPerRev(Int16 peaks, Int16 rpm);
void EVERYTHING();


/*
#define MMA8451_REG_OUT_X_MSB     0x01
#define MMA8451_REG_SYSMOD        0x0B
#define MMA8451_REG_WHOAMI        0x0D
#define MMA8451_REG_XYZ_DATA_CFG  0x0E
#define MMA8451_REG_PL_STATUS     0x10
#define MMA8451_REG_PL_CFG        0x11
#define MMA8451_REG_CTRL_REG1     0x2A
#define MMA8451_REG_CTRL_REG2     0x2B
#define MMA8451_REG_CTRL_REG4     0x2D
#define MMA8451_REG_CTRL_REG5     0x2E
*/
