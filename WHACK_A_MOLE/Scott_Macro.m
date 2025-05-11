;************************************************************
playv_1   macro       vaddr0, vaddr1, vaddr2, vaddr3, vaddr4, pcm_flag_1	
local   @@@Initial_Isnt_PCM_mode_1,@@@Set_PlayV_Flag_1
        
        StopV
        											
        MOVRA   pcm_flag_1
        MOVAR	R@VDataFormat

        MOVIA	0x0
        MOVAR	R@PauseV
        MOVAR	R@PlayVFlag
              						
        MOVRA   vaddr0                   ;load voice lab
        MOVAR   R@Vpr0Temp
        MOVRA   vaddr1
        MOVAR   R@Vpr1Temp
        MOVRA   vaddr2
        MOVAR   R@Vpr2Temp
        MOVRA   vaddr3
        MOVAR   R@Vpr3Temp
        MOVRA   vaddr4
        MOVAR   R@Vpr4Temp
        										
        MOVRA   PERI2                     
        ORI	    0x08					 	 
        MOVAR   PERI2		             ;Enable PWM output
	               	        
        MOVRA	R@VDataFormat      
        SAEQI   0x01
        JMP    	@@@Initial_Isnt_PCM_mode_1
        						
        M@VSDPCM_Initial
        JMP	@@@Set_PlayV_Flag_1
        
@@@Initial_Isnt_PCM_mode_1:        
         				        		
        M@VSD_Initial	
        
@@@Set_PlayV_Flag_1:        
        
        MOVRA   R@PlayVFlag         	 ;set play flag
        ORI    	0x1
        MOVAR   R@PlayVFlag  
			        
endm

;************************************************************   
playv_2   macro       v_lable, pcm_flag_2	
local   @@@Initial_Isnt_PCM_mode_2,@@@Set_PlayV_Flag_2
        
        StopV
        											
        MOVIA   pcm_flag_2
        MOVAR	R@VDataFormat

        MOVIA	0x0
        MOVAR	R@PauseV
        MOVAR	R@PlayVFlag
              						
        MOVIA   low0 v_lable             ;load voice lab
        MOVAR   R@Vpr0Temp
        MOVIA   low1 v_lable
        MOVAR   R@Vpr1Temp
        MOVIA   mid0 v_lable
        MOVAR   R@Vpr2Temp
        MOVIA   mid1 v_lable
        MOVAR   R@Vpr3Temp
        MOVIA   high0 v_lable
        MOVAR   R@Vpr4Temp
        										
        MOVRA   PERI2                     
        ORI	    0x08					 	 
        MOVAR   PERI2		             ;Enable PWM output
	               	        
        MOVRA	R@VDataFormat      
        SAEQI   0x01
        JMP    	@@@Initial_Isnt_PCM_mode_2
        						
        M@VSDPCM_Initial
        JMP	@@@Set_PlayV_Flag_2
        
@@@Initial_Isnt_PCM_mode_2:        
         				        		
        M@VSD_Initial	
        
@@@Set_PlayV_Flag_2:        
        
        MOVRA   R@PlayVFlag         	 ;set play flag
        ORI    	0x1
        MOVAR   R@PlayVFlag  
			        
endm

;************************************************************
   
JZ      MACRO       RAM, VALUE, LABLE             
LOCAL   @@@EQUAL, @@@NOT_EQUAL, @@@JZ_END

        MOVRA       RAM
        MOVAR       TMP5
        MOVIA       VALUE
        XOR         TMP5
        SAEQI       0X00
        JMP         @@@NOT_EQUAL
        
;----------------------------------------------------
        
@@@EQUAL:

        MOVIA       0X01
        MOVAR       ZERO_FLAG
        JMP         LABLE
        
;----------------------------------------------------

@@@NOT_EQUAL:
    
        MOVIA       0X00
        MOVAR       ZERO_FLAG
        
;----------------------------------------------------

@@@JZ_END:
                              
ENDM

;************************************************************ 
JNZ     MACRO       RAM, VALUE, LABLE
LOCAL   @@@EQUAL, @@@NOT_EQUAL, @@@JNZ_END 

        MOVRA       RAM
        MOVAR       TMP5
        MOVIA       VALUE
        XOR         TMP5
        SANEI       0X00
        JMP         @@@EQUAL 
        
;---------------------------------------------------- 
        
@@@NOT_EQUAL: 

        MOVIA       0X00 
        MOVAR       ZERO_FLAG
        JMP         LABLE
        
;----------------------------------------------------
        
@@@EQUAL:
        
        MOVIA       0X01 
        MOVAR       ZERO_FLAG 
        
;----------------------------------------------------

@@@JNZ_END:
        
ENDM

;************************************************************ 
JC      MACRO       LABLE
LOCAL   @@@CARRY_OCCUR, @@@JC_END

        MOVRA       STATUS
        SAEQI       #1000B
        JMP         @@@JC_END
        
;----------------------------------------------------
        
@@@CARRY_OCCUR:

        JMP         LABLE
        
;----------------------------------------------------

@@@JC_END:

ENDM 

;************************************************************ 
JNC     MACRO       LABLE
LOCAL   @@@CARRY_NOT_OCCUR, @@@JNC_END

        MOVRA       STATUS
        SANEI       #1000B
        JMP         @@@JNC_END
        
;----------------------------------------------------
        
@@@CARRY_NOT_OCCUR:

        JMP         LABLE 
        
;----------------------------------------------------

@@@JNC_END:

ENDM

;************************************************************
JB      MACRO       RAM, VALUE, LABLE 
LOCAL   @@@IF_BIT_HIGH, @@@JB_END

        MOVRA       RAM
        MOVAR       TMP5
        MOVIA       VALUE
        AND         TMP5            
        SANEI       0X00
        JMP         @@@JB_END                              

;----------------------------------------------------

@@@IF_BIT_HIGH:

        JMP         LABLE

;----------------------------------------------------

@@@JB_END:

ENDM

;************************************************************ 
JNB     MACRO       RAM, VALUE, LABLE
LOCAL   @@@IF_BIT_LOW, @@@JNB_END

        MOVRA       RAM
        MOVAR       TMP5
        MOVIA       VALUE
        AND         TMP5            
        SAEQI       0X00
        JMP         @@@JNB_END

;----------------------------------------------------

@@@IF_BIT_LOW:

        JMP         LABLE

;----------------------------------------------------

@@@JNB_END:

ENDM   