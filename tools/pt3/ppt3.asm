; =======================================================================================
; Vortex Tracker II v1.0 PT3 player for 6502
; ORIC 1/ATMOS (6502) version
; ScalexTrixx (A.C) - (c)2018
;
; Translated and adapted from ZX Spectrum Player Code (z80)  
; by S.V.Bulba (with Ivan Roshin for some parts/algorithm)
; https://bulba.untergrund.net/main_e.htm (c)2004,2007 
;
Revision = "0" 
; =======================================================================================
; REV 0: 
; ======
; rev 0.34 (WK/TS)  - correction / 1.773 (288=x256+0x32 -> 289=x256+x32+x01)
;                   => file_end = $8E68
;
; rev 0.33 (WK)     - optimizations: PTDECOD
;                   => file_end = $8E53
;
; rev 0.32 (WK)     - optimizations: PLAY
;                   => file_end = $8F43
;
; rev 0.31 (WK)     - optimizations: CHREGS
;                   => file_end = $8FC4
;
; rev 0.30 (WK)     - New base "full working" version for optimizations
;                   - optimizations: zp variables / CHECKLP / INIT (ALL)
;                   => file_end = $9027
;
; --------------------------------
; WK: working / TS: test version |
; =======================================================================================
; TODO:
; - LDA ($AC),Y -> LDA ($AC,X)
; - NOISE Register opt (/2 ?)
; - déplacer / 1.773 avant CHREGS (cf CPC version) => vraiment utile ?!
; - dans PD_LOOP: vérifier si des JMP relatifs sont possibles
; - fix .bbs address
; - check zero pages addresses
; =======================================================================================
;
;	ORG $8000
;
; -------------------------------------
.zero

	*= $50
    
    SETUP   .dsb 1      ; set bit0 to 1, if you want to play without looping
	                    ; bit7 is set each time, when loop point is passed

    ; "registers" Z80
    ; A = A
    ; F = flags
    
    z80_A   .dsb 1      ; save A
    z80_C   .dsb 1
    z80_B   .dsb 1
    z80_E   .dsb 1
    z80_D   .dsb 1
    z80_L   .dsb 1
    z80_H   .dsb 1
    z80_IX  .dsb 2
    z80_AP  .dsb 1      ; save A'

    ; temp variable used during play
    val1    .dsb 2
    val2    .dsb 2
    val3    .dsb 2
    val4    .dsb 2

    TA1 = val1
    TA2 = val1+1
    TB1 = val2
    TB2 = val2+1
    TC1 = val3
    TC2 = val3+1
    TB3 = val4
    TC3 = val4+1
; =====================================
; module PT3 address
MDLADDR = $2000
; =====================================
.text

; START = $8000
; START+00 : INIT
; START+10 : PLAY
; START+13 : MUTE

START
	LDA #<MDLADDR                           ; Z80_L, Z80_H <- MDLADDR                                        
        STA z80_L
        LDA #>MDLADDR
        STA z80_H
        BNE INIT            ; always                                
        JMP PLAY                                                    
        JMP MUTE                                                    
     
CrPsPtr	.word 0 ; current position in PT3 module

;Identifier
	hbb.asc "=VTII PT3 Player r.",Revision,"="

CHECKLP
	                                                
        LDA SETUP                                                   
        ORA #%10000000                                              
        STA SETUP
	    LDA #%00000001                                                                                               
        BIT SETUP
        BNE s1                                                      
	    RTS
s1	    PLA                                                         
        PLA       ; dépile 2 fois puisque RTS shunté
	    INC DelyCnt                                                                                                                                    
        INC ANtSkCn                                                 
MUTE	                                                            
        LDA #00                                                     
        STA z80_H                                                   
	    STA z80_L                                                   
	    STA AYREGS+AmplA                                            
	    STA AYREGS+AmplB                                            
        STA AYREGS+AmplC
	    JMP ROUT                                              

INIT

        LDA z80_L                                                   
        STA MODADDR+1
        STA MDADDR2+1
        STA z80_IX
        PHA
        LDA z80_H
        STA MODADDR+7
        STA MDADDR2+7
        STA z80_IX+1
        PHA
        LDA #<100                                                   
        STA z80_E
        LDA #00
        STA z80_D
        TAY
	    CLC                                                         
        LDA z80_E
        ADC z80_L
        STA z80_L
        LDA z80_H
        ADC #00
        STA z80_H
        LDA (z80_L),Y                                               
	    STA Delay+1                                                                                                         
        LDA z80_E
        ADC z80_L
        STA z80_L
        STA CrPsPtr                                                 
        LDA z80_H
        ADC #00
        STA z80_H    
        STA CrPsPtr+1
	    LDY #102               
        LDA (z80_IX),Y
        STA z80_E
	    CLC                                                         
        ADC z80_L
        STA z80_L
        LDA z80_H
        ADC #00
        STA z80_H       
	    INC z80_L                                                   
        BNE s2
        INC z80_H
s2	    LDA z80_L                                                   
        STA LPosPtr+1
        LDA z80_H
        STA LPosPtr+5
	    PLA                                                         
        STA z80_D
        PLA
        STA z80_E
	    LDY #103               
        LDA (z80_IX),Y
	    CLC                                                         
        ADC z80_E
        STA PatsPtr+1   
        LDY #104                  
        LDA (z80_IX),Y
        ADC z80_D
        STA PatsPtr+8
        LDA #<169                                                   
        CLC                                                         
        ADC z80_E
        STA OrnPtrs+1   
        LDA #00
        ADC z80_D
        STA OrnPtrs+8
        LDA #<105                                                   
        CLC                                                         
        ADC z80_E
        STA SamPtrs+1
        LDA #00
        ;INIT zeroes from VARS to VAR0END-1 (area < $80)           
        LDY #(VAR0END-VARS-1)
LOOP_LDIR 
        STA VARS,Y
        DEY         ; (carry not modified)
        BPL LOOP_LDIR
        ; A = #00  
        ADC z80_D
        STA SamPtrs+8                                        
        LDA SETUP                                                   
        AND #%01111111
        STA SETUP
        
	    LDA #<T1_
        STA z80_E
        LDA #>T1_
        STA z80_D
        LDA #$01                                   
	    STA DelyCnt                                                                                                  
        STA ANtSkCn
        STA BNtSkCn
        STA CNtSkCn
        LDA #$F0
	    STA AVolume                                                 
	    STA BVolume                                                 
	    STA CVolume                                                 
        
	    LDA #<EMPTYSAMORN                                           
        STA z80_L
        STA AdInPtA+1
        STA AOrnPtr
        STA BOrnPtr
        STA COrnPtr
        STA ASamPtr
        STA BSamPtr
        STA CSamPtr
        LDA #>EMPTYSAMORN
        STA z80_H
	    STA AdInPtA+5                                               
	    STA AOrnPtr+1                                               
	    STA BOrnPtr+1                                               
	    STA COrnPtr+1                                               
	    STA ASamPtr+1                                               
	    STA BSamPtr+1                                               
	    STA CSamPtr+1                                               
	    			                                                
        
	    LDY #13                    
        LDA (z80_IX),Y
        SEC                                                         
        SBC #$30        ; ascii value - 30 = version number (1-7)
	    BCC L20         ; inverse (pour SUB aussi)                  
	    CMP #10                                                     
	    BCC L21         ; < 10                                      
L20	    
        LDA #6          ; version par defaut si incorrect           
L21	    
        STA Version+1                                               
	    PHA             ; save version nb
        CMP #4          ; version 4 ?                               
        BCC s7b         ; < 4 (inverse carry)
        CLC
        BCC s8b         ; always
s7b     SEC
s8b     LDY #99                 
        LDA (z80_IX),Y  
        ROL             ; carry !                                   
	    AND #7          ; clear all bit except 0-1-2                
        TAX             ; save A
;NoteTableCreator (c) Ivan Roshin
;A - NoteTableNumber*2+VersionForNoteTable
;(xx1b - 3.xx..3.4r, xx0b - 3.4x..3.6x..VTII1.0)

     	LDA #<NT_DATA											    
     	STA z80_L
     	LDA #>NT_DATA
     	STA z80_H
     	LDA z80_E													
     	STA z80_C
     	LDA z80_D
     	STA z80_B
     	LDA #00
        TAY           ; LDY #00	        
     	STA z80_D
     	TXA           ; restore A									
     	ASL															
     	STA z80_E													
     	CLC                                                         
        ADC z80_L
        STA z80_L
        LDA z80_D
        ADC z80_H
        STA z80_H													
     	LDA (z80_L),Y												
     	STA z80_E
     	INC z80_L                                                   
        BNE s9b
        INC z80_H
s9b 
		LSR z80_E											    				     				
		BCS sb		; si c = 0 => $EA (NOP) / si c = 1 => $18 (CLC)
sa  	LDA #$EA 	; -> $EA (NOP)
        BNE sb1		; always	
sb		LDA #$18	; -> $18 (CLC) 									
sb1	    STA L3		            									
		LDA z80_E													
		LDX z80_L
		STA z80_L
		STX z80_E
		LDA z80_D
		LDX z80_H
		STA z80_H
		STX z80_D
		CLC                                                         
    	LDA z80_C
    	ADC z80_L
    	STA z80_L
    	LDA z80_B
    	ADC z80_H
    	STA z80_H

	    LDA (z80_E),Y												
	    CLC                                                         
        ADC #<T_
	    STA z80_C
        PHA                                                   
        ADC #>T_                                                    
	    SEC                                                         
        SBC z80_C
        STA z80_B                                                   												
	    PHA

	    LDA #<NT_											
	    STA z80_E
	    PHA															
	    LDA #>NT_
	    STA z80_D
	    PHA
	
	    LDA #12														
	    STA z80_B
L1	    
        LDA z80_C													
	    PHA
	    LDA z80_B
	    PHA
	    LDA (z80_L),Y												
	    STA z80_C
	    INC z80_L                                                   
        BNE sc
        INC z80_H
sc     
	    LDA z80_L												    
	    PHA
	    LDA z80_H
	    PHA
	    LDA (z80_L),Y												
	    STA z80_B
        
	    LDA z80_E       												
	    STA z80_L
        PHA
	    LDA z80_D
	    STA z80_H
        PHA
	    LDA #<23		    										
	    STA z80_E
	    LDA #>23
	    STA z80_D
	    LDA #8														
	    STA z80_IX+1
        
L2	    
        LSR z80_B													
	    ROR z80_C													
L3	    
	    .byt $AC			; CLC ($18) or NOP ($EA)
	    LDA z80_C													
	    ADC #00  		    								    	
	    STA (z80_L),Y												
	    INC z80_L                                                   
        BNE sd
        INC z80_H
sd      
        LDA z80_B													
	    ADC #00 													
	    STA (z80_L),Y												
	    CLC                                                         
        LDA z80_E
        ADC z80_L
        STA z80_L
        LDA z80_D
        ADC z80_H
        STA z80_H
	    DEC z80_IX+1											    
	    BNE L2														
        
	    PLA															
	    STA z80_D
	    PLA         
        ADC #02     
        STA z80_E   
        BCC sf      
        INC z80_D 

sf     
	    PLA												    	    
	    STA z80_H
	    PLA
	    STA z80_L
	    INC z80_L                                                   
        BNE sg
        INC z80_H
sg     
	    PLA												    	    
	    STA z80_B
	    PLA
	    STA z80_C
	    DEC z80_B													
	    BEQ sg1
        JMP L1
sg1        
	    PLA															
	    STA z80_H
	    PLA
	    STA z80_L
	    PLA															
	    STA z80_D
	    PLA
	    STA z80_E
        								
	    CMP #<TCOLD_1		        								
        BNE CORR_1													
	    LDA #$FD													
	    STA NT_+$2E									 				

CORR_1	
        CLC                                                         
        LDA (z80_E),Y																										
	    BEQ TC_EXIT													
	    ROR															
	    PHP			    ; save carry														
	    ASL															
	    STA z80_C													
	    CLC                                                         
        ADC z80_L
        STA z80_L
        LDA z80_B
        ADC z80_H
        STA z80_H                                
	    PLP             ; restore carry (du ROR)	                
	    BCC CORR_2                                                  
	    LDA (z80_L),Y												
	    SEC															
	    SBC #$02
	    STA (z80_L),Y
	
CORR_2	
        LDA (z80_L),Y												
	    CLC			
	    ADC #$01
	    STA (z80_L),Y
        SEC   		                                                
	    LDA z80_L                                                   
	    SBC z80_C
	    STA z80_L
	    LDA z80_H
	    SBC z80_B
	    STA z80_H
	    INC z80_E                                                   
        BNE sh
        INC z80_D
sh     
	    JMP CORR_1												    

TC_EXIT
	    PLA			; restore version number						

;VolTableCreator (c) Ivan Roshin
;A - VersionForVolumeTable (0..4 - 3.xx..3.4x;
;5.. - 3.5x..3.6x..VTII1.0)

	    CMP #5		; version 										
	    LDA #<$11                                                   
	    STA z80_L
        LDA #>$11													
	    STA z80_H													
	    STA z80_D                                                   
	    STA z80_E													
	    LDA #$2A	; ($2A = ROL A)								    
	    BCS M1		; CP -> carry inverse (CP 5)					
	    DEC z80_L													
	    LDA z80_L													
	    STA z80_E
	    LDA #$EA	; ($EA = NOP)			    					
M1          
        STA M2														
	    LDA #<(VT_+16)												
	    STA z80_IX
	    LDA #>(VT_+16)
	    STA z80_IX+1
	    LDA #$10													
	    STA z80_C

INITV2  
        CLC
        LDA z80_L													
	    PHA
        ADC z80_E
        STA z80_E
	    LDA z80_H
	    PHA
        ADC z80_D
        STA z80_D
	    
        LDA #00														
	    STA z80_L
	    STA z80_H
        CLC
INITV1  
        LDA z80_L													
M2          
        .byt $AC	    ; $EA (nop) ou $2A (ROL)
	    LDA z80_H													
	    ADC #00			; + carry                                  	
	    STA (z80_IX),Y												
	    INC z80_IX                                                  
        BNE si
        INC z80_IX+1
si     
	    CLC                                                         
        LDA z80_E
        ADC z80_L
        STA z80_L
        LDA z80_D
        ADC z80_H
        STA z80_H
	    INC z80_C												    
	    LDA z80_C													
	    AND #15														
        CLC         ; carry cleared by AND
	    BNE INITV1													
        
	    PLA															
	    STA z80_H
	    PLA
	    STA z80_L
	    LDA z80_E													
	    CMP #$77													
	    BNE M3														
	    INC z80_E													
M3      
        CLC                                                         
        LDA z80_C																								
	    BNE	INITV2													
        
	    JMP ROUT													
; ==============================================================================================
; Pattern Decoder
PD_OrSm	
        LDY #Env_En     										    
	    LDA #00
	    STA (z80_IX),Y
	    JSR SETORN													
	    LDY #00					; LDA ($AC,X)									
	    LDA (z80_C),Y
	    INC z80_C                                                   
        BNE sj
        INC z80_B
sj     
	    LSR 													    
        BCC sj1
        ORA #$80
sj1     
PD_SAM	
        ASL 											    		
PD_SAM_	
        STA z80_E													
SamPtrs		
	    LDA #$AC				
        CLC
        ADC z80_E
	    STA z80_L
	    LDA #$AC
        ADC #00
	    STA z80_H

        LDY #00
	    LDA (z80_L),Y
MODADDR		
	    ADC #$AC												
	    TAX             ; save
	    INY                                                         
	    LDA (z80_L),Y
        ADC #$AC								    			

	    LDY #SamPtr+1         										
	    STA (z80_IX),Y
	    DEY															
	    TXA         
	    STA (z80_IX),Y
	    JMP PD_LOOP													

PD_VOL	
        ASL															
        ADC #00
	    ASL															
        ADC #00
	    ASL															
        ADC #00
	    ASL															
        ADC #00
	    LDY #Volume         										
	    STA (z80_IX),Y
        JMP PD_LP2													
	
PD_EOff	
        LDY #Env_En		    	        							
	    STA (z80_IX),Y
	    LDY #PsInOr   			    					    		
	    STA (z80_IX),Y
	    JMP PD_LP2													

PD_SorE	
        SEC															
	    SBC #01
        STA z80_A
	    BNE PD_ENV													
	    LDY #00			        ; LDA ($AC,X)												
	    LDA (z80_C),Y
	    INC z80_C                                                   
        BNE sl
        INC z80_B
sl     
	    LDY #NNtSkp    		        								
	    STA (z80_IX),Y
        JMP PD_LP2													

PD_ENV	
        JSR SETENV													
	    JMP PD_LP2													

PD_ORN	
        JSR SETORN													
	    JMP PD_LOOP													

PD_ESAM	
        LDY #Env_En	             									
	    STA (z80_IX),Y
	    LDY #PsInOr	    		        							
	    STA (z80_IX),Y
	    LDA z80_A           
        BEQ sm														
	    JSR SETENV
sm	    LDY #00			    ; LDA ($AC,X)												
	    LDA (z80_C),Y
	    INC z80_C                                                   
        BNE sn
        INC z80_B
sn     
        JMP PD_SAM_								     			    

PTDECOD 
        LDY #Note   							    				
	    LDA (z80_IX),Y
	    STA PrNote+1												
	    LDY #CrTnSl    		    						    		
	    LDA (z80_IX),Y                                              
	    STA PrSlide+1												
        INY 
	    LDA (z80_IX),Y											
	    STA PrSlide+8

PD_LOOP	
        LDA #$10													
	    STA z80_E
	
PD_LP2	
        LDY #00			    ; LDA ($AC,X)												
	    LDA (z80_C),Y
	    INC z80_C                                                   
        BNE so
        INC z80_B
so
	    CLC															
	    ADC #$10
	    BCC so1
        STA z80_A            
        JMP PD_OrSm
so1     ADC #$20                                                    
	    BNE so11													
        JMP PD_FIN
so11	BCC so2													    
        JMP PD_SAM
so2	    ADC #$10                                                    
	    BEQ PD_REL													
	    BCC so3 													
        JMP PD_VOL
so3	    ADC #$10                                                    
	    BNE so4										    			
        JMP PD_EOff
so4	    BCC	so5												    	
	    JMP PD_SorE
so5     ADC #96                                                     
	    BCS PD_NOTE													
	    ADC #$10                                                    
	    BCC so6
        STA z80_A												    	
        JMP PD_ORN													
so6	    ADC #$20                                                    
	    BCS PD_NOIS													 														
	    ADC #$10                                                    
        BCC so7
        STA z80_A												    	
        JMP PD_ESAM
so7	    ASL															
	    STA z80_E
        CLC                                                   
        ADC #<(SPCCOMS+$FF20)							        
        STA z80_L
	    LDA #>(SPCCOMS+$FF20)
        ADC #00
	    STA z80_H
        ; on doit inverser le PUSH car l'adresse sera utilisée après RTS
        LDY #01	
	    LDA (z80_L),Y												
	    PHA             ; push D
	    DEY                                                         
	    LDA (z80_L),Y										        
	    PHA             ; push E
	    JMP PD_LOOP													

PD_NOIS									
        STA Ns_Base                                                 
	    JMP PD_LP2													

PD_REL	
        LDY #Flags   								    			
	    LDA (z80_IX),Y
	    AND #%11111110
	    STA (z80_IX),Y
	    JMP PD_RES													
	
PD_NOTE	
        LDY #Note    	 				    						
	    STA (z80_IX),Y	
	    LDY #Flags      											
	    LDA (z80_IX),Y
	    ORA #%00000001
	    STA (z80_IX),Y
	    													
PD_RES												
        LDA #00	
        STA z80_L
	    STA z80_H
	    LDY #11
bres
	    STA (z80_IX),y          
	    DEY
        BPL bres
PD_FIN	
	    LDY #NNtSkp     						    				
	    LDA (z80_IX),Y
	    LDY #NtSkCn     		    								
	    STA (z80_IX),Y
	    RTS 														

C_PORTM
	    LDY #Flags  												
	    LDA (z80_IX),Y
	    AND #%11111011
	    STA (z80_IX),Y
	    LDY #00			    ; LDA ($AC,X)												
	    LDA (z80_C),Y
        LDY #TnSlDl     				    			    		
	    STA (z80_IX),Y
        LDY #TSlCnt	        			    						
	    STA (z80_IX),Y

        CLC
        LDA z80_C
        ADC #03
        STA z80_C
        BCC st
        INC z80_B
st     
	    LDA #<NT_			; OPT										
	    STA z80_E
	    LDA #>NT_           ; OPT
	    STA z80_D
	    LDY #Note	        										
	    LDA (z80_IX),Y
	    LDY #SlToNt         										
	    STA (z80_IX),Y
	    ASL																																																				
	    CLC                                                         
        ADC z80_E           ; OPT
        STA z80_L
        LDA z80_D           ; OPT
        ADC #00           
        STA z80_H
        LDY #00	
	    LDA (z80_L),Y 												
	    PHA	
	    INY                                                         
	    LDA (z80_L),Y 												
	    PHA
PrNote	
        LDA #$3E													
	    LDY #Note   					    						
	    STA (z80_IX),Y
	    ASL																																			
	    CLC                                                         
        ADC z80_E           ; OPT
        STA z80_L
        LDA z80_D           ; OPT
        ADC #00
        STA z80_H
	    LDY #00
        LDA (z80_L),Y												
	    STA z80_E
	    INY                                                         
	    LDA (z80_L),Y											    
	    STA z80_D
	    LDY #TnDelt 
        PLA															
	    STA z80_H
	    PLA       
	    SEC                                                                                                       
        SBC z80_E
        STA z80_L
        STA (z80_IX),y
        LDA z80_H
        SBC z80_D
        STA z80_H 
        INY                                                         
        STA (z80_IX),y
	    LDY #CrTnSl                                                 
        LDA (z80_IX),y
        STA z80_E
	    INY                                                         
        LDA (z80_IX),y
        STA z80_D
Version
	    LDA #$3E                                                    
	    CMP #6                                                      
	    BCC OLDPRTM     ; < 6
        LDY #CrTnSl                                       
PrSlide	
        LDA #$AC                                                    
        STA z80_E
        STA (z80_IX),Y
        INY
        LDA #$AC
        STA z80_D
        STA (z80_IX),Y
	                                                  
OLDPRTM	
        LDY #00                                                     
        LDA (z80_C),y
        INY                                                                                                                        
        STA z80_AP                                                  
	    LDA (z80_C),Y                                               
	    STA z80_A
        LDA z80_C
        CLC
        ADC #02
        STA z80_C
        BCC sw
        INC z80_B
sw
	    LDA z80_A                                                   
	    BEQ NOSIG                                                   
	    LDA z80_E													
	    LDX z80_L
	    STA z80_L
	    STX z80_E
	    LDA z80_D
	    LDX z80_H
	    STA z80_H
	    STX z80_D
NOSIG	
        SEC                            
        LDA z80_L
        SBC z80_E
        STA z80_L
        LDA z80_H
        SBC z80_D
        STA z80_H
	    BPL SET_STP                                                 
	    LDA z80_A                                                   
        EOR #$FF                                                    
        LDX z80_AP                                                  
        STA z80_AP
        TXA
	    EOR #$FF                                                    
        CLC             
        ADC #01                                                
        TAX                                                         
        LDA z80_AP
        STX z80_AP
        STA z80_A
SET_STP	
        LDY #(TSlStp+1)                                             
        LDA z80_A
        STA (z80_IX),Y                                              
        TAX                                                         
        LDA z80_AP
        STX z80_AP
        STA z80_A
	    DEY                       
        STA (z80_IX),y
        LDY #COnOff                                                 
        LDA #00
        STA (z80_IX),Y
	    RTS                                                         

C_GLISS	
        LDY #Flags       											
	    LDA (z80_IX),Y
	    ORA #%00000100
	    STA (z80_IX),Y
	    LDY #00                 ; LDA ($AC,X)	                                    
        LDA (z80_C),y
        STA z80_A
        INC z80_C                                                   
        BNE sy
        INC z80_B
sy     
	    LDY #TnSlDl                                                 
        STA (z80_IX),Y
	    CLC                                                         
        LDA z80_A                                                   
	    BNE GL36                                                    
	    LDA Version+1                                               
	    CMP #7                                                      
	    BCS sz                                                      
        LDA #00         ; si A < 7  , A = 0 ($FF+1)                 
        BEQ saa
sz      LDA #01         ; si A >= 7 , A = 1 ($00+1)
saa	    
GL36	
        LDY #TSlCnt                                                 
	    STA (z80_IX),Y                                              
        LDY #00                                                     
        LDA (z80_C),Y
        STA z80_AP
        INY
        LDA (z80_C),y
        STA z80_A
        CLC
        LDA z80_C
        ADC #02
        STA z80_C                                                   
        BCC sac
        INC z80_B
sac     
	    JMP SET_STP                                                 

C_SMPOS	
        LDY #00                  ; LDA ($AC,X)	                                   
        LDA (z80_C),y
        INC z80_C                                                   
        BNE sad
        INC z80_B
sad     
	    LDY #PsInSm                                                 
        STA (z80_IX),Y
	    RTS                                                         

C_ORPOS	
        LDY #00                 ; LDA ($AC,X)	                                              
        LDA (z80_C),y
        INC z80_C                                                   
        BNE sae
        INC z80_B
sae     
	    LDY #PsInOr                                                 
        STA (z80_IX),Y
	    RTS                                                         
    
C_VIBRT	
        LDY #00                 ; LDA ($AC,X)	                                             
        LDA (z80_C),y
        INC z80_C                                                   
        BNE saf
        INC z80_B
saf     
	    LDY #OnOffD                                                 
        STA (z80_IX),Y
        LDY #COnOff                                                 
        STA (z80_IX),Y
	    LDY #00                 ; LDA ($AC,X)	                                          
        LDA (z80_C),y
        INC z80_C                                                   
        BNE sag
        INC z80_B
sag     LDY #OffOnD                                                 
        STA (z80_IX),Y
        LDA #00                                                     
        LDY #TSlCnt                                                 
        STA (z80_IX),Y
	    LDY #CrTnSl                                                 
        STA (z80_IX),Y
	    INY                                                         
        STA (z80_IX),Y
	    RTS                                                         

C_ENGLS	
        LDY #00                                                     
        LDA (z80_C),y
        STA Env_Del+1                                               
	    STA CurEDel
        INY
        LDA (z80_C),y
        STA z80_L                                                   
        STA ESldAdd+1
        INY
        LDA (z80_C),y
        STA z80_H                                                   
	    STA ESldAdd+9
        CLC
        LDA z80_C 
        ADC #03
        STA z80_C
        BCC sah
        INC z80_B
sah	                                                   
	    RTS                                                              

C_DELAY	
        LDY #00                 ; LDA ($AC,X)	                                         
        LDA (z80_C),y
        INC z80_C                                                   
        BNE sak
        INC z80_B
sak
	    STA Delay+1                                                 
	    RTS                                                         

SETENV	
        LDY #Env_En                                                 
        LDA z80_E
        STA (z80_IX),y
        LDA z80_A                ; OPT (inverser et mettre STA AYREGS+EnvTP au début)                                   
        STA AYREGS+EnvTp
	    LDY #00                                                     
        LDA (z80_C),y           
	    STA z80_H                                                   
        STA EnvBase+1                                               
	    INY                                                     
        LDA (z80_C),y
	    STA z80_L                                                   
	    STA EnvBase
        LDA z80_C
        CLC
        ADC #02
        STA z80_C
        BCC sam
        INC z80_B                                                 
sam	    LDA #00                                                     
	    LDY #PsInOr                                                 
        STA (z80_IX),Y
	    STA CurEDel                                                 
	    STA z80_H                                                   
        STA CurESld+1                                               
	    STA z80_L                                                   
        STA z80_A
	    STA CurESld                                                 
C_NOP	
        RTS                                                         

SETORN	
        LDA z80_A
        ASL                                                         
	    STA z80_E                                                   
	    LDA #00             ; OPT (inutile ?)                                             
        STA z80_D
	    LDY #PsInOr                                                 
        STA (z80_IX),Y
OrnPtrs
	    LDA #$AC           
        CLC
        ADC z80_E                                           
        STA z80_L
        LDA #$AC
        ADC #00
        STA z80_H
	    LDY #00                                                     
        LDA (z80_L),y
MDADDR2
	    ADC #$AC
        TAX             ; save
	    INY                                                         
	    LDA (z80_L),Y
        ADC #$AC                                               
	    
	    LDY #OrnPtr+1                                                 
        STA (z80_IX),y
        DEY
	    TXA                                                   
        STA (z80_IX),y
	    RTS                                                              

;ALL 16 ADDRESSES TO PROTECT FROM BROKEN PT3 MODULES
SPCCOMS 
        .word C_NOP-1
	    .word C_GLISS-1
	    .word C_PORTM-1
	    .word C_SMPOS-1
	    .word C_ORPOS-1
	    .word C_VIBRT-1
	    .word C_NOP-1
	    .word C_NOP-1
	    .word C_ENGLS-1
	    .word C_DELAY-1
	    .word C_NOP-1
	    .word C_NOP-1
	    .word C_NOP-1
	    .word C_NOP-1
	    .word C_NOP-1
	    .word C_NOP-1
; ==============================================================================================
CHREGS	
        LDA #00                                                  
	    STA z80_A       ; save
        STA Ampl                                                 
	    LDA z80_L                                            
        STA val3                                                 
        LDA z80_H
        STA val3+1
        LDY #Flags                                               
        LDA #%00000001
        STA val1
        LDA (z80_IX),y
        BIT val1
	    BNE saq
        JMP CH_EXIT                                              
saq     	
                                                                 
	    LDY #OrnPtr                                              
        LDA (z80_IX),Y
        STA z80_L
        STA val1            ; save L
        INY                                                      
        LDA (z80_IX),Y
        STA z80_H
        STA val1+1          ; save H
	                                                             
        LDY #00
        LDA (z80_L),Y                                            
        STA z80_E
        INY
        LDA (z80_L),Y
        STA z80_D
	    LDY #PsInOr                                              
        LDA (z80_IX),Y
	    STA z80_L                                                
        STA z80_A                                        
	    CLC
        LDA val1
        ADC z80_L
        STA z80_L
        LDA val1+1
        ADC #00                
        STA z80_H                                               
        LDA z80_L
        ADC #02
        STA z80_L
        LDA z80_H
        ADC #00
        STA z80_H
        LDA z80_A                                                
        ADC #01
        CMP z80_D                                                
	    BCC CH_ORPS                                              
	    CLC
        LDA z80_E                                                
CH_ORPS	
        LDY #PsInOr                                              
        STA (z80_IX),Y
	    LDY #Note                                                
        LDA (z80_IX),Y
	    LDY #00                                                  
        ADC (z80_L),Y       ; ADC ($AC,X)	
	    BPL CH_NTP                                               
	    LDA #00                                                  
CH_NTP	
        CMP #96                                                  
	    BCC CH_NOK                                               
	    LDA #95                                                  
CH_NOK	
        ASL                                                      
        STA z80_AP                                               
	    LDY #SamPtr                                              
        LDA (z80_IX),Y
        STA z80_L
	    STA val1            ; save L
        INY                                                      
        LDA (z80_IX),Y
        STA z80_H
        STA val1+1          ; save H
	    LDY #00
        LDA (z80_L),Y                                            
        STA z80_E   
        INY
        LDA (z80_L),Y
        STA z80_D   

	    LDY #PsInSm                                              
        LDA (z80_IX),Y
	    STA z80_B                                                
	    ASL                                                      
	    ASL                                                      
	    STA z80_L                                                                                           
        CLC
        ADC val1
        STA z80_L
        LDA val1+1
        ADC #00
        STA z80_H                                                     
        LDA z80_L
        ADC #02
        STA z80_L
        LDA z80_H
        ADC #00
        STA z80_H

	    LDA z80_B                                                                                                      
        ADC #01
	    CMP z80_D                                                
	    BCC CH_SMPS                                              
	    LDA z80_E                                                
CH_SMPS	
        LDY #PsInSm                                              
        STA (z80_IX),Y
        LDY #00
        LDA (z80_L),Y                                            
        STA z80_C
        INY
        LDA (z80_L),Y
        STA z80_B

        LDY #TnAcc                                               
        LDA (z80_IX),Y
        STA z80_E
        INY
        LDA (z80_IX),Y
	    STA z80_D                                                
	    CLC                                                      
        LDY #02
        LDA (z80_L),Y                                            
        ADC z80_E
        TAX
        INY
        LDA (z80_L),Y
        ADC z80_D
        STA z80_H
        STA z80_D
        TXA
        STA z80_L
        STA z80_E

        LDA #%01000000                                           
        BIT z80_B
	    BEQ CH_NOAC                                              
	    LDY #TnAcc                                               
        LDA z80_L
        STA (z80_IX),Y
	    INY                                                      
        LDA z80_H
        STA (z80_IX),Y
CH_NOAC 												             
        LDA z80_AP                                               
        STA z80_A                                                
        STA z80_L                                                
        CLC
        LDA #<NT_
        ADC z80_L
        STA z80_L
        LDA #>NT_
        ADC #00
        STA z80_H
        LDY #00
        LDA (z80_L),Y                                            
        ADC z80_E
        TAX
        INY
        LDA (z80_L),Y
        ADC z80_D                                               
        STA z80_H
        TXA
        STA z80_L
        CLC
	    LDY #CrTnSl                                              
        LDA (z80_IX),Y
        STA z80_E
        ADC z80_L
        STA z80_L
	    STA val3
        INY                                                      
        LDA (z80_IX),Y
        STA z80_D
        ADC z80_H
        STA z80_H
        STA val3+1
;CSP_	    
	   
        LDA #00                                                  
	    LDY #TSlCnt                                              
        ORA (z80_IX),Y
	    STA z80_A
        BNE saq1                                                 
        JMP CH_AMP
saq1	LDA (z80_IX),Y                                           
        SEC
        SBC #01
        STA (z80_IX),Y
	    BNE CH_AMP                                               
	    LDY #TnSlDl                                              
        LDA (z80_IX),Y
        LDY #TSlCnt                                              
        STA (z80_IX),Y
	    CLC
        LDY #TSlStp                                              
        LDA (z80_IX),Y
        ADC z80_E
        STA z80_L
	    INY                                                      
        LDA (z80_IX),Y
        ADC z80_D
        STA z80_H 
	    STA z80_A       ; save                                   
	    LDY #CrTnSl+1                                              
        STA (z80_IX),Y
        DEY                                                
        LDA z80_L
        STA (z80_IX),Y
	    LDA #%00000100                                           
        STA val1
        LDY #Flags
        LDA (z80_IX),Y
        BIT val1
	    BNE CH_AMP  	                                         
	    LDY #TnDelt                                              
        LDA (z80_IX),Y
        STA z80_E
	    INY                                                      
        LDA (z80_IX),Y
        STA z80_D
	    LDA z80_A                                                
	    BEQ CH_STPP                                              
	    LDA z80_E												
		LDX z80_L
		STA z80_L
		STX z80_E
		LDA z80_D
		LDX z80_H
		STA z80_H
		STX z80_D
CH_STPP
        SEC           ; carry = 0 becoze And A                   
        LDA z80_L
        SBC z80_E
        STA z80_L
        LDA z80_H
        SBC z80_D
        STA z80_H
        BMI CH_AMP                                               
	    LDY #SlToNt                                              
        LDA (z80_IX),Y
	    LDY #Note                                                
        STA (z80_IX),Y
	    LDA #00                                                  
	    LDY #TSlCnt                                              
        STA (z80_IX),Y
	    LDY #CrTnSl                                              
        STA (z80_IX),Y
        INY                                                      
        STA (z80_IX),Y

CH_AMP	
        LDY #CrAmSl                                              
        LDA (z80_IX),Y
	    STA z80_A       ; save
        LDA #%10000000                                           
        BIT z80_C
	    BEQ CH_NOAM                                              
	    LDA #%01000000                                           
        BIT z80_C
	    BEQ CH_AMIN                                              
	    LDA z80_A                                                
        CMP #15
	    BEQ CH_NOAM                                              
	    CLC                                                      
        ADC #01
	    JMP CH_SVAM                                              
CH_AMIN	
        LDA z80_A                                                
        CMP #$F1            ; -15
	    BEQ CH_NOAM                                              
	    SEC                                                      
        SBC #01
CH_SVAM	
        LDY #CrAmSl                                              
        STA (z80_IX),Y
        STA z80_A
CH_NOAM	
        LDA z80_A
        STA z80_L                                                
	    LDA z80_B                                                
	    AND #15                                                  
	    CLC                                                      
        ADC z80_L
	    BPL CH_APOS                                              
	    LDA #00                                                  
CH_APOS	
        CMP #16                                                  
	    BCC CH_VOL                                               
	    LDA #15                                                  
CH_VOL	
        LDY #Volume                                              
        ORA (z80_IX),Y
	    STA z80_L
        CLC                                                
	    LDA #<VT_                                                
        STA z80_E
        ADC z80_L
        STA z80_L
        LDA #>VT_
        STA z80_D
        ADC #00
        STA z80_H
	    LDY #00                                                  
        LDA (z80_L),Y       ; LDA ($AC,X)	
        STA z80_A       ; save
CH_ENV	
        LDA #%00000001                                           
        BIT z80_C
	    BNE CH_NOEN                                              
	    LDY #Env_En                                              
        LDA z80_A
        ORA (z80_IX),Y
        STA z80_A

CH_NOEN	
        LDA z80_A
        STA Ampl                                                 
        LDA z80_C                                                
        STA z80_A
        LDA #%10000000                                           
        BIT z80_B
	    BEQ NO_ENSL                                              
        LDA z80_A
        ROL                                                      
	    ROL                                                      
	    CMP #$80                                                 
        ROR
	    CMP #$80                                                 
        ROR
	    CMP #$80                                                 
        ROR
	    LDY #CrEnSl                                              
        CLC
        ADC (z80_IX),Y
        STA z80_A
        LDA #%00100000                                           
        BIT z80_B
	    BEQ NO_ENAC                                              
	    LDY #CrEnSl                                              
        LDA z80_A
        STA (z80_IX),Y
NO_ENAC	
        LDA #<(AddToEn+1)       ; OPT ?                                    
        STA z80_L
        LDA #>(AddToEn+1)
        STA z80_H
        LDA z80_A
        LDY #00                                                  
		                                                         
        CLC
        ADC (z80_L),Y           ; OPT ?
        STA (z80_L),Y                                            
	    JMP CH_MIX                                               
NO_ENSL 
        LDA z80_A
        ROR                                                      
	    LDY #CrNsSl                                              
        CLC
        ADC (z80_IX),Y
	    STA AddToNs                                              
        STA z80_A       ; save
	    LDA #%00100000                                           
        BIT z80_B
	    BEQ CH_MIX                                               
	    LDY #CrNsSl                                              
        LDA z80_A
        STA (z80_IX),Y
CH_MIX	
        LDA z80_B                                                
	    ROR                                                      
	    AND #$48                                                 
        STA z80_A
CH_EXIT	
        LDA #<(AYREGS+Mixer)                                     
        STA z80_L
        LDA #>(AYREGS+Mixer)
        STA z80_H
	    LDA z80_A
        LDY #00                                                  
        ORA (z80_L),Y       ; ORA ($AC,X)	
	    LSR                                                      
        BCC saq2
        ORA #$80
saq2	STA (z80_L),Y                                            
	    LDA val3+1                                               
        STA z80_H
        LDA val3 
        STA z80_L
	    LDA #00                                                  
	    LDY #COnOff                                              
        ORA (z80_IX),Y
	    STA z80_A       ; save
        BNE sas                                                  
        RTS
sas 	LDY #COnOff                                              
        LDA (z80_IX),Y
        SEC
        SBC #01
        STA (z80_IX),Y
	    BEQ sat                                                  
        RTS
sat 	LDY #Flags                                               
        LDA z80_A
        EOR (z80_IX),Y                                           
        STA (z80_IX),Y                                           
	    ROR                                                      
	    LDY #OnOffD                                              
        LDA (z80_IX),Y
	    BCS CH_ONDL                                              
	    LDY #OffOnD                                              
        LDA (z80_IX),Y
CH_ONDL	
        LDY #COnOff                                              
        STA (z80_IX),Y
        RTS                                                         
; ==============================================================================================
PLAY    
        LDA #00                                                  
	    STA AddToEn+1                                            
	    STA AYREGS+Mixer                                         
	    LDA #$FF                                                 
	    STA AYREGS+EnvTp                                         
	    DEC DelyCnt                                              
	    BEQ sat1                                                 
        JMP PL2
sat1	DEC ANtSkCn                                              
	    BEQ sat2                                                 
        JMP PL1B
AdInPtA
sat2	LDA #01                                                  
        STA z80_C
        LDA #01
        STA z80_B
	    LDY #00                                                                                                      
        LDA (z80_C),Y       ; LDA ($AC,X)	                                      
	    BEQ sat3            ; test 0                                                
        JMP PL1A
sat3	STA z80_D                                                
	    STA Ns_Base                                              
	    LDA CrPsPtr                                              
        STA z80_L
        LDA CrPsPtr+1
        STA z80_H
	    INC z80_L                                                
        BNE sar
        INC z80_H
sar                                                     
        LDA (z80_L),y                                            
	    CLC                                                      
        ADC #01
        STA z80_A
        BNE PLNLP                                                
	    JSR CHECKLP                                              
LPosPtr
	    LDA #$AC                                                 
        STA z80_L
        LDA #$AC
        STA z80_H
	    LDY #00                 ; OPT ?                                           
        LDA (z80_L),y       ; LDA ($AC,X)	                                     
	    CLC                                                      
        ADC #01
        STA z80_A           ; save
PLNLP	
        LDA z80_L                                                
        STA CrPsPtr
        LDA z80_H
        STA CrPsPtr+1
	    LDA z80_A                                                
        SEC
        SBC #01
	    ASL                                                      
	    STA z80_E                                                
        STA z80_A
	    ROL z80_D                                                
PatsPtr
	    LDA #$AC
        CLC
        ADC z80_E                                                  
        STA z80_L
        LDA #$AC
        ADC z80_D
        STA z80_H
	    
	    LDA MODADDR+1                                            
        STA z80_E
        LDA MODADDR+7
        STA z80_D
                       	                                                             
	    LDY #00                 ; OPT ?
        LDA (z80_L),Y           ; LDA ($AC,X)	                                 
        CLC                                                      
        ADC z80_E               ; OPT (ADC MODADDR+1)
        STA z80_C
        INY
        LDA (z80_L),Y
        ADC z80_D               ; OPT (ADC MODADDR+7)
        STA z80_B   
        INY
        LDA (z80_L),Y                                            
        CLC                     ; OPT ?
        ADC z80_E               ; IDEM...
        STA AdInPtB+1   
        INY
        LDA (z80_L),Y
        ADC z80_D
        STA AdInPtB+5     
        INY
        LDA (z80_L),Y                                            
        CLC
        ADC z80_E               ; IDEM
        STA AdInPtC+1   
        INY
        LDA (z80_L),Y
        ADC z80_D
        STA AdInPtC+5
                                                 
PSP_	

PL1A	
        LDA #<ChanA                                              
        STA z80_IX
        LDA #>ChanA
        STA z80_IX+1
	    JSR PTDECOD                                              
	    LDA z80_C                                                
        STA AdInPtA+1
        LDA z80_B
        STA AdInPtA+5

PL1B	
        DEC BNtSkCn                                              
	    BNE PL1C                                                 
	    LDA #<ChanB                                              
        STA z80_IX
        LDA #>ChanB
        STA z80_IX+1
AdInPtB
	    LDA #01                                                  
        STA z80_C
        LDA #01
        STA z80_B
	    JSR PTDECOD                                              
	    LDA z80_C                                                
        STA AdInPtB+1
        LDA z80_B
        STA AdInPtB+5

PL1C	
        DEC CNtSkCn                                              
	    BNE PL1D                                                 
	    LDA #<ChanC                                              
        STA z80_IX
        LDA #>ChanC
        STA z80_IX+1
AdInPtC
	    LDA #01                                                  
        STA z80_C
        LDA #01
        STA z80_B
	    JSR PTDECOD                                              
	    LDA z80_C                                                
        STA AdInPtC+1
        LDA z80_B
        STA AdInPtC+5

Delay
PL1D	
        LDA #$3E                                                 
	    STA DelyCnt                                              

PL2	
        LDA #<ChanA                                              
        STA z80_IX
        LDA #>ChanA
        STA z80_IX+1
	    LDA AYREGS+TonA                                          
        STA z80_L
        LDA AYREGS+TonA+1
        STA z80_H
	    JSR CHREGS                                               
	    LDA z80_L                                                
        STA AYREGS+TonA
        LDA z80_H
        STA AYREGS+TonA+1
	    LDA Ampl                                                 
	    STA AYREGS+AmplA                                         
	
        LDA #<ChanB                                              
        STA z80_IX
        LDA #>ChanB
        STA z80_IX+1
	    LDA AYREGS+TonB                                          
        STA z80_L
        LDA AYREGS+TonB+1
        STA z80_H
	    JSR CHREGS                                               
	    LDA z80_L                                                
        STA AYREGS+TonB
        LDA z80_H
        STA AYREGS+TonB+1
	    LDA Ampl                                                 
	    STA AYREGS+AmplB                                         
	    
        LDA #<ChanC                                              
        STA z80_IX
        LDA #>ChanC
        STA z80_IX+1
	    LDA AYREGS+TonC                                          
        STA z80_L
        LDA AYREGS+TonC+1
        STA z80_H
	    JSR CHREGS                                               
	    LDA z80_L                                                
        STA AYREGS+TonC
        LDA z80_H
        STA AYREGS+TonC+1

	    LDA Ns_Base_AddToNs                                      
        STA z80_L
        LDA Ns_Base_AddToNs+1
        STA z80_H                                              
	    CLC                                                      
        ADC z80_L
	    STA AYREGS+Noise                                         

AddToEn
	    LDA #$3E                                                 
	    STA z80_E                                                
	    ASL                                                      
	    BCC sau                                                  
        LDA #$FF
        BNE sau1      ; always
sau     LDA #00
sau1	STA z80_D                                                
        LDA EnvBase+1
        STA z80_H           ; OPT ?
        LDA EnvBase                                              
        STA z80_L           ; OPT ?
	    CLC                                                      
        ADC z80_E
        STA z80_L
        LDA z80_D
        ADC z80_H           ; OPT ?
        STA z80_H 
        LDA CurESld+1
        STA z80_D
        LDA CurESld                                              
        STA z80_E
	    CLC                                                      
        ADC z80_L
        STA AYREGS+Env                                           
        LDA z80_D
        ADC z80_H
	    STA AYREGS+Env+1                                         

        LDA #00                                                  
        ORA CurEDel         ; OPT ?                                       
	    BEQ ROUT                                                 
	    DEC CurEDel                                              
	    BNE ROUT                                                 
Env_Del
	    LDA #$3E                                                 
	    STA CurEDel                                              
ESldAdd
	    LDA #$AC                                                 
        CLC
        ADC z80_E       
        STA CurESld
        LDA #$AC
        ADC z80_D
	    STA CurESld+1                                             
; ==============================================================================================
; ORIC 1/ATMOS VIA addresses:
VIA_PCR = $30C
VIA_ORA = $30F
ROUT
        LDX AYREGS+1    ; hi ToneA
        LDA AYREGS+0    ; lo ToneA
        JSR FIX16BITS
        
        LDA #00             
        STA VIA_ORA     ; register number
        LDA #$FF        ; fct: SET PSG REG#
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        STY VIA_ORA
        LDA #$FD        ; fct: WRITE DATA
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDA #01             
        STA VIA_ORA     ; register number
        LDA #$FF        ; fct: SET PSG REG#
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        STX VIA_ORA
        LDA #$FD        ; fct: WRITE DATA
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR
        
        LDX AYREGS+3    ; hi ToneA
        LDA AYREGS+2    ; lo ToneA
        JSR FIX16BITS 

        LDA #02             
        STA VIA_ORA     ; register number
        LDA #$FF        ; fct: SET PSG REG#
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        STY VIA_ORA
        LDA #$FD        ; fct: WRITE DATA
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDA #03             
        STA VIA_ORA     ; register number
        LDA #$FF        ; fct: SET PSG REG#
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        STX VIA_ORA
        LDA #$FD        ; fct: WRITE DATA
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDX AYREGS+5    ; hi ToneA
        LDA AYREGS+4    ; lo ToneA
        JSR FIX16BITS 

        LDA #04             
        STA VIA_ORA     ; register number
        LDA #$FF        ; fct: SET PSG REG#
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        STY VIA_ORA
        LDA #$FD        ; fct: WRITE DATA
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDA #05             
        STA VIA_ORA     ; register number
        LDA #$FF        ; fct: SET PSG REG#
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        STX VIA_ORA
        LDA #$FD        ; fct: WRITE DATA
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDA #06             
        STA VIA_ORA     ; register number
        LDA #$FF        ; fct: SET PSG REG#
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDA AYREGS+6    ; data
        ;JSR FIX8BITS
        LSR             ; /2 
        STA VIA_ORA
        LDA #$FD        ; fct: WRITE DATA
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDA #07             
        STA VIA_ORA     ; register number
        LDA #$FF        ; fct: SET PSG REG#
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDA AYREGS+7    ; data
        STA VIA_ORA
        LDA #$FD        ; fct: WRITE DATA
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDA #08             
        STA VIA_ORA     ; register number
        LDA #$FF        ; fct: SET PSG REG#
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDA AYREGS+8    ; data
        STA VIA_ORA
        LDA #$FD        ; fct: WRITE DATA
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDA #09             
        STA VIA_ORA     ; register number
        LDA #$FF        ; fct: SET PSG REG#
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDA AYREGS+9    ; data
        STA VIA_ORA
        LDA #$FD        ; fct: WRITE DATA
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDA #10             
        STA VIA_ORA     ; register number
        LDA #$FF        ; fct: SET PSG REG#
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDA AYREGS+10   ; data
        STA VIA_ORA
        LDA #$FD        ; fct: WRITE DATA
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDX AYREGS+12   ; hi Env
        LDA AYREGS+11   ; lo Env
        JSR FIX16BITS 

        LDA #11             
        STA VIA_ORA     ; register number
        LDA #$FF        ; fct: SET PSG REG#
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        STY VIA_ORA
        LDA #$FD        ; fct: WRITE DATA
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        LDA #12             
        STA VIA_ORA     ; register number
        LDA #$FF        ; fct: SET PSG REG#
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        STX VIA_ORA
        LDA #$FD        ; fct: WRITE DATA
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR

        ; shunte R13 si $FF (Y=13) => plus généralement >=$80
        LDA AYREGS+13
        BPL OUT_S
        RTS
OUT_S   LDY #13
        STY VIA_ORA     ; 
        LDY #$FF        ; fct: SET PSG REG#
        STY VIA_PCR
        LDY #$DD        ; fct: INACTIVE
        STY VIA_PCR

        STA VIA_ORA     ; a = data
        LDA #$FD        ; fct: WRITE DATA
        STA VIA_PCR
        LDA #$DD        ; fct: INACTIVE
        STA VIA_PCR
        RTS
; -------------------------------------
FIX16BITS       ; INT(256*2*1000/1773) = 289 = 256 + 32 + 1
                ; IN:  register A is low byte
                ;      register X is high byte
                ; OUT: register Y is low byte
                ;      register X is high byte

        ; x256
        STX TA1
        STA TB1
        STX TB2
        STA TC2
        STX TB3
        STA TC3
        LDA #00
        STA TA2
        
        ; x32
        ASL TC2
        ROL TB2
        ROL TA2
        ASL TC2
        ROL TB2
        ROL TA2
        ASL TC2
        ROL TB2
        ROL TA2
        ASL TC2
        ROL TB2
        ROL TA2
        ASL TC2
        ROL TB2
        ROL TA2
        
        ; x32 + x01
        CLC
        LDA TC3
        ADC TC2
        ; STA TC2
        LDA TB3
        ADC TB2
        STA TB2
        LDA TA2
        ADC #00
        STA TA2

        ; + x256 
        CLC         
        LDA TB2
        ADC TB1
        TAY         ; STA TB1
        LDA TA2
        ADC TA1
        ; STA TA1

        ; / 2 (16bits)
        LSR         ; LSR TA1
        TAX         ; LDX TA1
        TYA         ; LDA TB1     
        ROR         ; ROR TB1
        TAY         ; LDY TB1
        RTS 

; =============================================================================
NT_DATA	
        .byt (T_NEW_0-T1_)*2
	    .byt TCNEW_0-T_
	    .byt (T_OLD_0-T1_)*2+1
	    .byt TCOLD_0-T_
	    .byt (T_NEW_1-T1_)*2+1
	    .byt TCNEW_1-T_
	    .byt (T_OLD_1-T1_)*2+1
	    .byt TCOLD_1-T_
	    .byt (T_NEW_2-T1_)*2
	    .byt TCNEW_2-T_
	    .byt (T_OLD_2-T1_)*2
	    .byt TCOLD_2-T_
	    .byt (T_NEW_3-T1_)*2
	    .byt TCNEW_3-T_
	    .byt (T_OLD_3-T1_)*2
	    .byt TCOLD_3-T_

T_

TCOLD_0	.byt $00+1,$04+1,$08+1,$0A+1,$0C+1,$0E+1,$12+1,$14+1
	    .byt $18+1,$24+1,$3C+1,0
TCOLD_1	.byt $5C+1,0
TCOLD_2	.byt $30+1,$36+1,$4C+1,$52+1,$5E+1,$70+1,$82,$8C,$9C
	    .byt $9E,$A0,$A6,$A8,$AA,$AC,$AE,$AE,0
TCNEW_3	.byt $56+1
TCOLD_3	.byt $1E+1,$22+1,$24+1,$28+1,$2C+1,$2E+1,$32+1,$BE+1,0
TCNEW_0	.byt $1C+1,$20+1,$22+1,$26+1,$2A+1,$2C+1,$30+1,$54+1
	    .byt $BC+1,$BE+1,0
TCNEW_1 = TCOLD_1
TCNEW_2	.byt $1A+1,$20+1,$24+1,$28+1,$2A+1,$3A+1,$4C+1,$5E+1
	    .byt $BA+1,$BC+1,$BE+1,0

EMPTYSAMORN = *-1
	    .byt 1,0,$90 ;delete #90 if you don't need default sample

;first 12 values of tone tables

T1_ 	
        .word $1DF0
        .word $1C20
        .word $1AC0
        .word $1900
        .word $17B0
        .word $1650
        .word $1510
        .word $13E0

        .word $12C0
        .word $11C0
        .word $10B0
        .word $0FC0
        .word $1A7C
        .word $1900
        .word $1798
        .word $1644

        .word $1504
        .word $13D8
        .word $12B8
        .word $11AC
        .word $10B0
        .word $0FC0
        .word $0EDC
        .word $0E08

        .word $19B4
        .word $1844
        .word $16E6
        .word $159E
        .word $1466
        .word $1342
        .word $122E
        .word $1128

        .word $1032
        .word $0F48
        .word $0E6E
        .word $0D9E
        .word $0CDA
        .word $1A20
        .word $18AA
        .word $1748

        .word $15F8
        .word $14BE
        .word $1394
        .word $127A
        .word $1170
        .word $1076
        .word $0F8A
        .word $0EAA

        .word $0DD8

T_OLD_1	= T1_
T_OLD_2	= T_OLD_1+24
T_OLD_3	= T_OLD_2+24
T_OLD_0	= T_OLD_3+2
T_NEW_0	= T_OLD_0
T_NEW_1	= T_OLD_1
T_NEW_2	= T_NEW_0+24
T_NEW_3	= T_OLD_3

FILE_END =*
; ===========================

.bss        ; uninitialized data stuff

;vars from here can be stripped
;you can move VARS to any other address

VARS
;ChannelsVars

; STRUCT "CHP"
PsInOr	= 0
PsInSm	= 1
CrAmSl  = 2
CrNsSl	= 3
CrEnSl	= 4
TSlCnt	= 5
CrTnSl	= 6
TnAcc	= 8
COnOff	= 10
OnOffD	= 11
OffOnD	= 12
OrnPtr	= 13
SamPtr	= 15
NNtSkp	= 17
Note	= 18
SlToNt	= 19
Env_En	= 20
Flags	= 21
TnSlDl	= 22
TSlStp	= 23
TnDelt	= 25
NtSkCn	= 27
Volume	= 28
; end STRUCT

; CHANNEL A
ChanA	
;reset group
APsInOr	.byt 0
APsInSm	.byt 0
ACrAmSl	.byt 0
ACrNsSl	.byt 0
ACrEnSl	.byt 0
ATSlCnt	.byt 0
ACrTnSl	.word 0
ATnAcc	.word 0
ACOnOff	.byt 0
;reset group

AOnOffD	.byt 0

AOffOnD	.byt 0
AOrnPtr	.word 0
ASamPtr	.word 0
ANNtSkp	.byt 0
ANote	.byt 0
ASlToNt	.byt 0
AEnv_En	.byt 0
AFlags	.byt 0
 ;Enabled - 0,SimpleGliss - 2
ATnSlDl	.byt 0
ATSlStp	.word 0
ATnDelt	.word 0
ANtSkCn	.byt 0
AVolume	.byt 0
	
; CHANNEL B
ChanB
;reset group
BPsInOr	.byt 0
BPsInSm	.byt 0
BCrAmSl	.byt 0
BCrNsSl	.byt 0
BCrEnSl	.byt 0
BTSlCnt	.byt 0
BCrTnSl	.word 0
BTnAcc	.word 0
BCOnOff	.byt 0
;reset group

BOnOffD	.byt 0

BOffOnD	.byt 0
BOrnPtr	.word 0
BSamPtr	.word 0
BNNtSkp	.byt 0
BNote	.byt 0
BSlToNt	.byt 0
BEnv_En	.byt 0
BFlags	.byt 0
 ;Enabled - 0,SimpleGliss - 2
BTnSlDl	.byt 0
BTSlStp	.word 0
BTnDelt	.word 0
BNtSkCn	.byt 0
BVolume	.byt 0

; CHANNEL C
ChanC
;reset group
CPsInOr	.byt 0
CPsInSm	.byt 0
CCrAmSl	.byt 0
CCrNsSl	.byt 0
CCrEnSl	.byt 0
CTSlCnt	.byt 0
CCrTnSl	.word 0
CTnAcc	.word 0
CCOnOff	.byt 0
;reset group

COnOffD	.byt 0

COffOnD	.byt 0
COrnPtr	.word 0
CSamPtr	.word 0
CNNtSkp	.byt 0
CNote	.byt 0
CSlToNt	.byt 0
CEnv_En	.byt 0
CFlags	.byt 0
 ;Enabled - 0,SimpleGliss - 2
CTnSlDl	.byt 0
CTSlStp	.word 0
CTnDelt	.word 0
CNtSkCn	.byt 0
CVolume	.byt 0

; ------------

;GlobalVars
DelyCnt	.byt 0
CurESld	.word 0
CurEDel	.byt 0
Ns_Base_AddToNs
Ns_Base	.byt 0
AddToNs	.byt 0

; ===========================
AYREGS ; AY registers

TonA	= 0
TonB	= 2
TonC	= 4
Noise	= 6
Mixer	= 7
AmplA	= 8
AmplB	= 9
AmplC	= 10
Env	    = 11
EnvTp	= 13
; ---

Ampl	= AYREGS+AmplC
; ===========================
VT_	.dsb 256 ;CreatedVolumeTableAddress

EnvBase	= VT_+14
VAR0END	= VT_+16 ;INIT zeroes from VARS to VAR0END-1

; ===========================
NT_	.dsb 192 ;CreatedNoteTableAddress

VARS_END = *
