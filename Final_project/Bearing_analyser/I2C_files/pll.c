#include<stdio.h>
#include "csl_pll.h"
#include "csl_general.h"
#include "csl_pllAux.h"
#include "pll.h"

PLL_Obj pllObj;
PLL_Config pllCfg1;

PLL_Handle hPll;

#if ((defined(CHIP_5505)) || (defined(CHIP_5515)) || (defined(CHIP_C5505_C5515)) )

PLL_Config pllCfg_1MHz      = {0x8895, 0x8000, 0x0806, 0x0247};
PLL_Config pllCfg_2MHz      = {0x8895, 0x8000, 0x0806, 0x0223};
PLL_Config pllCfg_12MHz     = {0x8895, 0x8000, 0x0806, 0x0205};
PLL_Config pllCfg_12p288MHz = {0x8173, 0x8000, 0x0806, 0x0000};
PLL_Config pllCfg_40MHz     = {0x8E4A, 0x8000, 0x0806, 0x0202};
PLL_Config pllCfg_60MHz     = {0x8724, 0x8000, 0x0806, 0x0000};
PLL_Config pllCfg_75MHz     = {0x88ED, 0x8000, 0x0806, 0x0000};
PLL_Config pllCfg_98MHz     = {0x8BAB, 0x8000, 0x0806, 0x0000};
PLL_Config pllCfg_100MHz    = {0x8BE8, 0x8000, 0x0806, 0x0000};
PLL_Config pllCfg_120MHz    = {0x8E4A, 0x8000, 0x0806, 0x0000};

#else    

// Order of registers is PLL_CNTRL1, PLL_CNTRL_2, PLL_CNTRL3, PLL_CNTRL_4

PLL_Config pllCfg_1MHz      = {0x82DB, 0x0000, 0x0806, 0x0208};
PLL_Config pllCfg_2MHz      = {0x82DB, 0x0000, 0x0806, 0x0202};
PLL_Config pllCfg_12MHz     = {0x82EB, 0x8000, 0x0806, 0x0200};
PLL_Config pllCfg_12p288MHz = {0x82ED, 0x8000, 0x0806, 0x0200};
PLL_Config pllCfg_40MHz     = {0x8262, 0x8000, 0x0806, 0x0300};
PLL_Config pllCfg_60MHz     = {0x81C8, 0xB000, 0x0806, 0x0000};
PLL_Config pllCfg_75MHz     = {0x823B, 0x9000, 0x0806, 0x0000};
PLL_Config pllCfg_98MHz     = {0x82ED, 0x8000, 0x0806, 0x0000}; 
PLL_Config pllCfg_100MHz    = {0x82FA, 0x8000, 0x0806, 0x0000};
PLL_Config pllCfg_120MHz    = {0x8392, 0xA000, 0x0806, 0x0000};

#endif

PLL_Config *pConfigInfo;

#define CSL_TEST_FAILED         (1)
#define CSL_TEST_PASSED         (0)

int pll_frequency_setup(unsigned int frequency)
{
    CSL_Status status;

    status = PLL_init(&pllObj, CSL_PLL_INST_0);
    if(CSL_SOK != status)
    {
       printf("PLL init failed \n");
       return (status);
    }

	hPll = (PLL_Handle)(&pllObj);

	PLL_reset(hPll);

   /* Configure the PLL for different frequencies */

   if ( frequency == 1)
    {
      pConfigInfo = &pllCfg_1MHz;
      printf("\nLL frequency 1 MHz\n");
    }
   else if ( frequency == 2)
    {
      pConfigInfo = &pllCfg_2MHz;
      printf("\nPLL frequency 2 MHz\n");     
    } 
   else if ( frequency == 12)
    {
      pConfigInfo = &pllCfg_12MHz; 
      printf("\nPLL frequency 12 MHz\n");        
    }
   else if ( frequency == 40)
    {
      pConfigInfo = &pllCfg_40MHz;
      printf("\nPLL frequency 40 MHz\n");     
    } 
   else if ( frequency == 60)
    {
      pConfigInfo = &pllCfg_60MHz; 
      printf("\nPLL frequency 60 MHz\n");        
    }
   else if ( frequency == 75)
    {
      pConfigInfo = &pllCfg_75MHz;
      printf("\nPLL frequency 75 MHz\n");     
    } 
   else if ( frequency == 98)
    {
      pConfigInfo = &pllCfg_98MHz; 
      printf("\nPLL frequency 98 MHz\n");        
    }  
   else if ( frequency == 120)
   {
      pConfigInfo = &pllCfg_120MHz;
      printf("\nPLL frequency 120 MHz\n");        
   }
   else 
   {
      pConfigInfo = &pllCfg_100MHz;
      printf("\nPLL frequency 100 MHz\n");        
   }

   status = PLL_config (hPll, pConfigInfo);
   if(CSL_SOK != status)
   {
       printf("PLL config failed\n");
       return(status);
   }

	status = PLL_getConfig(hPll, &pllCfg1);
    if(status != CSL_SOK)
	{
	    printf("TEST FAILED: PLL get config... Failed.\n");
		printf ("Reason: PLL_getConfig failed. [status = 0x%x].\n", status);
		return(status);
	}

    printf("REGISTER --- CONFIG VALUES\n");

    printf("PLL_CNTRL1   %04x --- %04x\n",pllCfg1.PLLCNTL1,hPll->pllConfig->PLLCNTL1);
    printf("PLL_CNTRL2   %04x --- %04x Test Lock Mon will get set after PLL is up\n",
                                pllCfg1.PLLCNTL2,hPll->pllConfig->PLLCNTL2);
    printf("PLL_CNTRL3   %04x --- %04x\n",pllCfg1.PLLINCNTL,hPll->pllConfig->PLLINCNTL);
    printf("PLL_CNTRL4   %04x --- %04x\n",pllCfg1.PLLOUTCNTL,hPll->pllConfig->PLLOUTCNTL);

   status = PLL_bypass(hPll);
   if(CSL_SOK != status)
   {
       printf("PLL bypass failed:%d\n",CSL_ESYS_BADHANDLE);
       return(status);
   }

   status = PLL_enable(hPll);
   if(CSL_SOK != status)
   {
       printf("PLL enable failed:%d\n",CSL_ESYS_BADHANDLE);
       return(status);
   }

   return(CSL_TEST_PASSED);
}

