
unsigned char    eucl1_steps;
unsigned char    eucl1_pulses;
unsigned char    eucl1_offset;
unsigned char    eucl1_bucket;
unsigned char    eucl1_first; // True

void initEuclid1(unsigned char steps, unsigned char pulses, unsigned char offset){
    eucl1_steps = steps;
    eucl1_pulses = pulses;
    eucl1_offset = offset;
    eucl1_bucket = 0;
    eucl1_first = 1 ; // True
}
unsigned char pulseEuclid1 (){
    if (eucl1_first){
        eucl1_first = 0;
        return 1;
    }
    eucl1_bucket = eucl1_bucket + eucl1_steps;
    if (eucl1_bucket >= eucl1_pulses){
        eucl1_bucket = eucl1_bucket - eucl1_pulses;
        return 1;
    } else {
        return 0;
    }
}  
