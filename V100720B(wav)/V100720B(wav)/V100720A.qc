[Option]
ICBody = NY5B045A
Client = V100720A
Voltage = 4.5V
Voice Output = PWM
PWM CURRENT = LARGE

[Voice File]
V0 = s40.wav  /PCM
V1 = Stop.wav  /PCM
V2 = Error.wav  /PCM
V3 = LevelOk.wav  /PCM
V4 = LV01a.wav  /PCM
V5 = LV01b.wav  /PCM
V6 = LV01c.wav  /PCM
V7 = LV03a.wav  /PCM
V8 = LV03b.wav  /PCM
V9 = LV03c.wav  /PCM
V10 = Over.wav  /PCM
V11 = ready.wav  /PCM
V12 = Right.wav  /PCM


[Envelope File]

[Music File]

[Instrument]

[I/O Pin]
;     Input Pin
;                 NO.   1     2     3     4     5     6     7     8     9     10    11    12    13    
;                 Name  PA0   PA1   PA2   PA3   PB0   PB1   PB2   PB3   PC0   PC1   PC2   PC3   PD0   
;                 Key   TR1   TR2   TR3   TR4   TR5   TR6   TR7   TR8   TR9   TR10  TR11  TR12  TR13  

;     Output Pin 
;                 NO.   1     2     
;                 Name  PD1   PD2   

Direct = 13
Input_mode = [ P P P P P P P P P P P P P ]
Output_mode = [ N:L:BL N:L:BL ]
Input_Pull_High_R = W                                            ; Pull-High resistor = 850K Ohm

[Input State]
;        PA0      PA1      PA2      PA3      PB0      PB1      PB2      PB3      PC0      PC1      
;        PC2      PC3      PD0      

st0:     X        X        X        X        X        X        X        X        X        X        
         X        X        X        

st1:     TR1      TR2      TR3      TR4      TR5      TR6      TR7      TR8      TR9      TR10     
         TR11     TR12     TR13     

[Output State]

[WaveMark]

[MelodyMark]

[Note On]

[IR Receive]

[RFC]

[Symbol]

[Table]

[ASM]

[Subroutine]

[Path]
PowerOn: stop,st1,delay(0.2),end
TR1: playv(ch0,$v0,6k),end
TR2: playv(ch0,$v1,6k),end
TR3: playv(ch0,$v2,6k),end
TR4: playv(ch0,$v3,6k),end
TR5: playv(ch0,$v4,6k),end
TR6: playv(ch0,$v5,6k),end
TR7: playv(ch0,$v6,6k),end
TR8: playv(ch0,$v7,6k),end
TR9: playv(ch0,$v8,6k),end
TR10: playv(ch0,$v9,6k),end
TR11: playv(ch0,$v10,6k),end
TR12: playv(ch0,$v11,6k),end
TR13: playv(ch0,$v12,6k),end



[Background1]

[Background2]

