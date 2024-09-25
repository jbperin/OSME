#define NB_INT_PER_MINUTE 6000


typedef void(*fun_ptr)(void);

unsigned char tmp_kernel_fraction    = 0;
unsigned char tmp_kernel_beat        = 0;
unsigned char tmp_kernel_cs          = 0;
unsigned char tmp_kernel_s           = 0;
unsigned char tmp_kernel_tempo       = 100;
unsigned char tmp_first              = 1; // True
signed int tmp_kernel_bfpm         = 1200; //100*12; // self.kernel_tempo * 12
signed int tmp_kernel_tempo_err   = NB_INT_PER_MINUTE;
unsigned char tmp_FlipFlop50hz       = 0;
fun_ptr fraction_callback       = 0; // NULL;
fun_ptr beat_callback           = 0; // NULL;
fun_ptr t50hz_callback          = 0; // NULL;
void fraction();
void beat();
void it50Hz();
void it25Hz();
void task_1Hz();

void simuSetTempo (unsigned char tempo_bpm){
    tmp_kernel_tempo = tempo_bpm;
    tmp_kernel_bfpm = tempo_bpm * 12;
}
void pulse (){
    if (tmp_first) {
        fraction();
        beat();
        tmp_first = 0;
    }
    tmp_kernel_tempo_err -= tmp_kernel_bfpm;
    if (2*tmp_kernel_tempo_err < tmp_kernel_bfpm){
        tmp_kernel_tempo_err += NB_INT_PER_MINUTE;
        fraction();
    }
}

void pulse100ms(){
    pulse();
    tmp_kernel_cs += 1;
    if(tmp_kernel_cs == 100){
        tmp_kernel_cs = 0;
        task_1Hz();
        it50Hz();
        it25Hz();
    } else {
        tmp_FlipFlop50hz = (tmp_FlipFlop50hz + 1)%2;
        if (tmp_FlipFlop50hz != 0){
            it50Hz();
            it25Hz();
        }else {
            if (tmp_kernel_cs % 4 == 0){
                it25Hz();
            }
        }
    }
}

void init() {
    tmp_kernel_fraction    = 0;
    tmp_kernel_beat        = 0;
    tmp_kernel_cs          = 0;
    tmp_kernel_s           = 0;
    tmp_kernel_tempo       = 100;
    tmp_first              = 1; // True
    tmp_kernel_bfpm        = 1200; //100*12; // self.kernel_tempo * 12
    tmp_kernel_tempo_err   = NB_INT_PER_MINUTE; //# NB_INT_PER_MINUTE
    tmp_FlipFlop50hz       = 0;

}
void beat() {
    if (beat_callback != 0){ beat_callback();}
    tmp_kernel_beat        += 1;
}

void fraction() {
    if (fraction_callback != 0){ fraction_callback();}
    tmp_kernel_fraction     += 1;
    if (tmp_kernel_fraction == 12){
        tmp_kernel_fraction = 0;
        beat();
    }
}
void it50Hz(){if (t50hz_callback != 0){ t50hz_callback();}}
void it25Hz(){;}
void task_1Hz(){;}

unsigned char curr_frame[14];

void initCurrentFrame(){
    curr_frame[R0]      = (unsigned char) 0; // "ToneAFine",
    curr_frame[R1]      = 0; // "ToneACoarse",
    curr_frame[R2]      = 0; // "ToneBFine",
    curr_frame[R3]      = 0; // "ToneBCoarse",
    curr_frame[R4]      = 0; // "ToneCFine",
    curr_frame[R5]      = 0; // "ToneCCoarse",
    curr_frame[R6]      = 0; // "NoiseGenerator",
    curr_frame[R7]      = (unsigned char)0x3E; // "Mixer",
    curr_frame[R10]     = 0;// "AmplitudeA",
    curr_frame[R11]     = 0;// "AmplitudeB",
    curr_frame[R12]     = 0; // "AmplitudeC",
    curr_frame[R13]     = 0; // "EnvelopeFine",
    curr_frame[R14]     = 0;// "EnvelopeCoarse",
    curr_frame[R15]     = 0;// "EnvelopeShapeCycle",
}
