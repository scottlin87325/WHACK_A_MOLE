;----play macro instruction----
;macro name(playv)    
;voice_lab : Play a voice label filename
;SR_set    : SampleRate 
;voice_vol : Voice volume (Max volume:0xf, Min volume:0x0)
;Pcm_Flag  : Pcm Flag(Pcm decode:0x01,Other Algorithm decode:0x0)
;------------------------

;************************************************************
InitialVoiceRam         macro
        				    		
        MOVIA   0x0 
        MOVAR   TREG0
        MOVAR   TREG1
        MOVAR   TREG2
        MOVAR   TREG3
        MOVAR   TREG4  
        
        MOVAR   R@Vpr0Temp
        MOVAR   R@Vpr1Temp
        MOVAR   R@Vpr2Temp
        MOVAR   R@Vpr3Temp
        MOVAR   R@Vpr4Temp  
        
        MOVAR	R@PlayVFlag
        MOVAR   R@PauseV  
        MOVAR	R@VDataFormat
        
endm
       
       
;************************************************************
playv   macro   voice_lab,SR_set,Voice_Vol,Pcm_Flag	
local   @@@Initial_Isnt_PCM_mode,@@@Set_PlayV_Flag
		
        StopV
        											
        MOVIA   low0 Pcm_Flag
        MOVAR	R@VDataFormat

        MOVIA	0x0
        MOVAR	R@PauseV
        MOVAR	R@PlayVFlag
              						
        MOVIA   low0 voice_lab          ;load voice lab
        MOVAR   R@Vpr0Temp
        MOVIA   low1 voice_lab
        MOVAR   R@Vpr1Temp
        MOVIA   mid0 voice_lab
        MOVAR   R@Vpr2Temp
        MOVIA   mid1 voice_lab
        MOVAR   R@Vpr3Temp
        MOVIA   high0 voice_lab
        MOVAR   R@Vpr4Temp

        MOVRA   PERI
        ANDI    B'1110' 									
        MOVAR   PERI		             ;INTon=0
        
        MOVIA   low0 SR_set              ;set sample rate
        MOVAR   TREG0
        MOVIA   low1 SR_set
        MOVAR   TREG1
        MOVIA   mid0 SR_set
        MOVAR   TREG2
        
        WRTMR												

        MOVRA   PERI 			        
        ORI	    0x01										
        MOVAR   PERI		             ;INTon=1
        
        MOVIA   low0 Voice_Vol
        MOVAR	VOL											

        MOVRA   PERI2
        ORI	    0x08						 
        MOVAR   PERI2		             ;Enable PWM output
	               	        
        MOVRA	R@VDataFormat      
        SAEQI   0x01
        JMP    	@@@Initial_Isnt_PCM_mode
        						
        M@VSDPCM_Initial
        JMP	@@@Set_PlayV_Flag
        
@@@Initial_Isnt_PCM_mode:        
         				        		
        M@VSD_Initial	
        
@@@Set_PlayV_Flag:        
        
        MOVRA   R@PlayVFlag         	;set play flag
        ORI    	0x1
        MOVAR   R@PlayVFlag  
			        
endm


;************************************************************
PauseV  macro        
Local   @@@Pause_Voice_Ret

        MOVRA   R@PlayVFlag
        SAB1    B'0001'   
        JMP     @@@Pause_Voice_Ret         

        MOVRA   R@PauseV
        SAEQI   0x0   
        JMP     @@@Pause_Voice_Ret  
        								;in software decode	
        MOVIA	0x01
        MOVAR	R@PauseV

        @@@ramp_to_0x200_s

@@@Pause_Voice_Ret:
endm

;************************************************************
ResumeV  macro
Local   @@@Resume_Voice_Ret   

        MOVRA   R@PlayVFlag
        SAB1    B'0001'   
        JMP     @@@Resume_Voice_Ret         
   
        MOVRA   R@PauseV
        SAEQI   0x01   
        JMP     @@@Resume_Voice_Ret  
			
		@@@ramp_to_PauseVLoc_s
        	
        MOVIA	0x0
        MOVAR	R@PauseV

@@@Resume_Voice_Ret:
endm


;************************************************************
StopV  macro    
Local   @@@Stop_Voice_Ret   
	  
        MOVRA   R@PlayVFlag
        SAB1    B'0001'   
        JMP     @@@Stop_Voice_Ret         
        
        MOVIA	0x0
        MOVAR	R@PauseV
        MOVAR	R@PlayVFlag		
				
        @@@ramp_to_0x200_s        	

@@@Stop_Voice_Ret:
endm
      
                    
;************************************************************
@@@ramp_to_0x200_s		Macro
Local   @@@ramp_to_0x200_delay,@@@Ramp_to_0x200_INC_DEC,@@@ramp_to_0x200_DEC,@@@ramp_to_0x200_INC,@@@ramp_to_0x200_s_back   
		MOVRA	R@DACTemp0
		MOVAR	TREG0   
		MOVRA	R@DACTemp1
		MOVAR	TREG1           
		MOVRA	R@DACTemp2 
		ANDI	0x3
		MOVAR	R@DACTemp2             
		MOVAR	TREG2            					;Read DAC to TREG0~2  
		MOVIA	0x0
		MOVAR	R@MainVar0
@@@ramp_to_0x200_delay:     
		CLRWDT	
		ADD1  	R@MainVar0 
		MOVRA 	R@MainVar0      
		SAEQI 	0x2       
		JMP   	@@@ramp_to_0x200_delay
		MOVIA 	0x0       
		MOVAR 	R@MainVar0
		WRDAC 	
		MOVRA 	TREG0
		SAEQI 	0x0
		JMP   	@@@Ramp_to_0x200_INC_DEC
		MOVRA 	TREG1
		SAEQI 	0x0
		JMP   	@@@Ramp_to_0x200_INC_DEC
		MOVRA 	TREG2
		SANEI 	0x2
		JMP   	@@@ramp_to_0x200_s_back
@@@Ramp_to_0x200_INC_DEC:            
		MOVRA	TREG2
		SAB1 	0x2
		JMP  	@@@ramp_to_0x200_INC
@@@ramp_to_0x200_DEC:                                                                                                                        
		MOVRA	treg0      
		DECA 	
		MOVAR	TREG0
		SAEQI	0xf
		JMP  	@@@ramp_to_0x200_delay
		MOVRA	treg1      
		DECA 	
		MOVAR	TREG1
		SAEQI	0xf
		JMP  	@@@ramp_to_0x200_delay
		MOVRA	treg2      
		DECA 	
		MOVAR	TREG2
		JMP  	@@@ramp_to_0x200_delay        
@@@ramp_to_0x200_INC:            
		ADD1	treg0      
		ADC0	treg1      
		ADC0	treg2                    
		JMP 	@@@ramp_to_0x200_delay  
  ;---------------------------------------       
@@@ramp_to_0x200_s_back:      
endm
		
		
		                            
;************************************************************
@@@ramp_to_PauseVLoc_s		Macro
Local		@@@ramp_to_PauseVLoc_delay,@@@ramp_to_PauseVLoc_delay_A,@@@DACTemp2_Comp_TREG2,@@@DACTemp1_Comp_TREG1,@@@DACTemp0_Comp_TREG0,@@@DACTemp_Morethan_TREG,@@@DACTemp_lessthan_TREG,@@@ramp_to_PauseVLoc_s_back		
    ;---------------------------------------
		MOVIA   0x0  
        MOVAR	TREG0   
		MOVAR	TREG1     
		MOVIA	0x02 
		MOVAR	TREG2                           ;Read DAC to TREG0~2     
		MOVIA	0x0
		MOVAR	R@MainVar0                  
@@@ramp_to_PauseVLoc_delay:     
		MOVIA	0x0       
		MOVAR	R@MainVar0
@@@ramp_to_PauseVLoc_delay_A:
		CLRWDT     
		ADD1  R@MainVar0 
		MOVRA R@MainVar0      
		SAEQI 0x2       
		JMP   @@@ramp_to_PauseVLoc_delay_A
		
		WRDAC   
		        			
		MOVRA	TREG2
		XOR		R@DACTemp2
		SAEQI	0x0										
		JMP		@@@DACTemp2_Comp_TREG2
		        			
		MOVRA	TREG1
		XOR		R@DACTemp1
		SAEQI	0x0										
		JMP		@@@DACTemp1_Comp_TREG1    				        			
		
		MOVRA	TREG0
		XOR		R@DACTemp0
		SAEQI	0x0										
		JMP		@@@DACTemp0_Comp_TREG0    				        	
		JMP		@@@ramp_to_PauseVLoc_s_back
      				        			    				        			
    				        			
@@@DACTemp2_Comp_TREG2:    				        			
		MOVIA  0xf
		INCA                     					;clear B flag  
		
		MOVRA	 TREG2
		SBC		 R@DACTemp2							;A,C<=A-Wn-B
		MOVRA	 STATUS				
		SAB1	 0x08							
		JMP		 @@@DACTemp_Morethan_TREG			;C=0 R@DACTemp2 > TREG2
		JMP		 @@@DACTemp_lessthan_TREG			;C=1 R@DACTemp2 < TREG2
						
@@@DACTemp1_Comp_TREG1:
		MOVIA  0xf
		INCA                     					;clear B flag  
		      		
		MOVRA	TREG1
		SBC		R@DACTemp1							;A,C<=A-Wn-B
		MOVRA	STATUS				
		SAB1	0x08							
		JMP		@@@DACTemp_Morethan_TREG			;C=0 R@DACTemp1 > TREG1
		JMP		@@@DACTemp_lessthan_TREG			;C=1 R@DACTemp1 < TREG1
						
@@@DACTemp0_Comp_TREG0:
		MOVIA 0xf
		INCA                     					;clear B flag                  				      
		      		
		MOVRA	TREG0
		SBC		R@DACTemp0							;A,C<=A-Wn-B
		MOVRA	STATUS				
		SAB1	0x08							
		JMP		@@@DACTemp_Morethan_TREG			;C=0 R@DACTemp0 > TREG0
		JMP		@@@DACTemp_lessthan_TREG			;C=1 R@DACTemp0 < TREG0
               
@@@DACTemp_Morethan_TREG:                           ;DACTemp > DAC
		ADD1  TREG0      
		ADC0  TREG1      
		ADC0  TREG2                    
		JMP   @@@ramp_to_PauseVLoc_delay                               
@@@DACTemp_lessthan_TREG:                           ;DACTemp < DAC                                                                                       
		MOVRA TREG0      
		DECA
		MOVAR TREG0
		SAEQI 0xf
		JMP   @@@ramp_to_PauseVLoc_delay
		MOVRA TREG1      
		DECA
		MOVAR TREG1
		SAEQI 0xf
		JMP   @@@ramp_to_PauseVLoc_delay
		MOVRA TREG2      
		DECA
		MOVAR TREG2
		JMP   @@@ramp_to_PauseVLoc_delay        
  ;---------------------------------------       
@@@ramp_to_PauseVLoc_s_back:          
endm
		

;************************************************************
DAOSET  macro    
       	MOVIA	0x0   
        MOVAR   TREG0
        MOVAR   TREG1
       	movia	0x02   
        MOVAR   TREG2
        
        WRDAC				
                           
endm

		
