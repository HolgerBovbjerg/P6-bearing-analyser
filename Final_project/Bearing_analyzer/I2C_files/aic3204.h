#ifndef AIC3204_H_
#define AIC3204_H_


// System addresses
#define AIC3204_I2C_ADDR 0x18 // i2c address of AIC3204 module

#define XmitL 0x10 	// register address of
#define XmitR 0x20	// 
#define RcvR 0x08	// 
#define RcvL 0x04	// 

// Function prototypes
extern void aic3204_init(void);
extern void aic3204_hardware_init(void);
extern void aic3204_codec_read(Int16* left_input, Int16* right_input);
extern void aic3204_codec_read_MONO(Int16* left_input, Int16* right_input, Int16 currentEntry);
extern void aic3204_codec_write(Int16 left_input, Int16 right_input);
extern void aic3204_disable(void);

extern Int16 AIC3204_rset( Uint16 regnum, Uint16 regval);

extern unsigned long set_sampling_frequency_and_gain(unsigned long SamplingFrequency, unsigned int ADCgain);

#endif /*AIC3204_H_*/
