
#define NOTE_C_NATURAL_0    0
#define NOTE_C_SHARP_0      1
#define NOTE_D_NATURAL_0    2
#define NOTE_D_SHARP_0      3
#define NOTE_E_NATURAL_0    4
#define NOTE_F_NATURAL_0    5
#define NOTE_F_SHARP_0      6
#define NOTE_G_NATURAL_0    7
#define NOTE_G_SHARP_0      8
#define NOTE_A_NATURAL_0    9
#define NOTE_A_SHARP_0      10
#define NOTE_B_NATURAL_0    11

// "ToneAFine",
#define R0 0 
// "ToneACoarse",
#define R1 1 
// "ToneBFine",
#define R2 2 
// "ToneBCoarse",
#define R3 3 
// "ToneCFine",
#define R4 4 
// "ToneCCoarse",
#define R5 5 
// "NoiseGenerator",
#define R6 6 
// # "Mixer",
#define R7 7 
// "AmplitudeA",
#define R10 8 
// "AmplitudeB",
#define R11 9 
// "AmplitudeC",
#define R12 10 
// "EnvelopeFine",
#define R13 11 
// "EnvelopeCoarse",
#define R14 12
// "EnvelopeShapeCycle",
#define R15 13


// cadences = [
//     [0, 5, 1, 4], # Anatole = I VI II V
//     [0, 3, 4, 4], #
//     [0, 3, 0, 4], #
//     [0, 3, 4, 3], #
//     [0, 3, 4, 0], #
//     [0, 5, 3, 4], # 
//     [5, 1, 4, 0], # 
//     ]
// chords = [
//     [0, 2, 4],
//     [1, 3, 5],
//     [2, 4, 6],
//     [3, 5, 0],
//     [4, 6, 1],
//     [5, 0, 2],
//     [6, 1, 3],
//     ]
// scales = {
//     "C" : ['C', 'D', 'E', 'F', 'G', 'A', 'B'],
//     "G" : ['G', 'A', 'B', 'C', 'D', 'E', 'F#'],
//     "D" : ['D', 'E', 'F#', 'G', 'A', 'B', 'C#'],
//     "A" : ['A', 'B', 'C#', 'D', 'E', 'F#', 'G#'],
//     "E" : ['E', 'F#', 'G#', 'A', 'B', 'C#', 'D#'],
//     "B" : ['B', 'C#', 'D#', 'E', 'F#', 'G#', 'A'],
//     "F" : ['F', 'G', 'A', 'A#', 'C', 'D', 'E']
//     }

// notefrequency = {
//     "C":    261.23,
//     "C#":   277.18,
//     "D":     293.66,
//     "D#":    311.13 ,
//     "E":     329.63,
//     "F":     349.23,
//     "F#":     369.99,
//     "G":     392.00,
//     "G#":     415.30,
//     "A":     440.00,
//     "A#":     466.16,
//     "B":     493.88,
//     }

    // def freq2register(self, frequency_in_Hz):
    //     TP=int(1000000/(16*frequency_in_Hz))
    //     return [TP//256, TP%256]

// unsigned char cadences[7][4]= [
//     [0, 5, 1, 4], // # Anatole = I VI II V
//     [0, 3, 4, 4], // #
//     [0, 3, 0, 4], // #
//     [0, 3, 4, 3], // #
//     [0, 3, 4, 0], // #
//     [0, 5, 3, 4], // # 
//     [5, 1, 4, 0], // # 
//     ];


unsigned int notePeriodFine [] = {
119,12,167,71,237,152,71,252,180,112,49,244,188,134,83,36,246,204,164,126,90,56,24,250,222,195,170,146,123,102,82,63,45,28,12,253,239,225,213,201,190,179,169,159,150,142,134,127,119,113,106,100,95,89,84,80,75,71,67,63,60,56,53,50,47,45,42,40,38,36,34,32,30,28,27,25,24,22,21,20,19,18,17,16
};
unsigned int notePeriodCoarse [] = {
7,7,6,6,5,5,5,4,4,4,4,3,3,3,3,3,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
};
unsigned char chords [7][3] = {
    {0, 2, 4},
    {1, 3, 5},
    {2, 4, 6},
    {3, 5, 0},
    {4, 6, 1},
    {5, 0, 2},
    {6, 1, 3}
};
unsigned char scales[12][7] = {
//     "C" : ['C', 'D', 'E', 'F', 'G', 'A', 'B'],
// NOTE_C_NATURAL_0    0
{NOTE_C_NATURAL_0, NOTE_D_NATURAL_0, NOTE_E_NATURAL_0, NOTE_F_NATURAL_0, NOTE_G_NATURAL_0, NOTE_A_NATURAL_0, NOTE_B_NATURAL_0},
// NOTE_C_SHARP_0      1
{NOTE_C_SHARP_0, NOTE_D_SHARP_0, NOTE_F_NATURAL_0, NOTE_F_SHARP_0, NOTE_G_SHARP_0, NOTE_A_SHARP_0, NOTE_C_NATURAL_0},
// NOTE_D_NATURAL_0    2
{NOTE_D_NATURAL_0, NOTE_E_NATURAL_0, NOTE_F_SHARP_0, NOTE_G_NATURAL_0, NOTE_A_NATURAL_0, NOTE_B_NATURAL_0, NOTE_C_SHARP_0},
// NOTE_D_SHARP_0      3
{NOTE_D_SHARP_0, NOTE_F_NATURAL_0, NOTE_G_NATURAL_0, NOTE_G_SHARP_0, NOTE_A_SHARP_0, NOTE_C_NATURAL_0, NOTE_D_NATURAL_0},
// NOTE_E_NATURAL_0    4
{NOTE_E_NATURAL_0, NOTE_F_SHARP_0, NOTE_G_SHARP_0, NOTE_A_NATURAL_0, NOTE_B_NATURAL_0, NOTE_C_SHARP_0, NOTE_D_SHARP_0}, 
// NOTE_F_NATURAL_0    5
{NOTE_F_NATURAL_0, NOTE_G_NATURAL_0, NOTE_A_NATURAL_0, NOTE_A_SHARP_0, NOTE_C_NATURAL_0, NOTE_D_NATURAL_0, NOTE_E_NATURAL_0}, 
// NOTE_F_SHARP_0      6
{NOTE_F_SHARP_0, NOTE_G_SHARP_0, NOTE_A_SHARP_0, NOTE_B_NATURAL_0, NOTE_C_SHARP_0, NOTE_D_SHARP_0, NOTE_F_NATURAL_0}, 
// NOTE_G_NATURAL_0    7
{NOTE_G_NATURAL_0, NOTE_A_NATURAL_0, NOTE_B_NATURAL_0, NOTE_C_NATURAL_0, NOTE_D_NATURAL_0, NOTE_E_NATURAL_0, NOTE_F_SHARP_0}, 
// NOTE_G_SHARP_0      8
{NOTE_G_SHARP_0, NOTE_A_SHARP_0, NOTE_C_NATURAL_0, NOTE_C_SHARP_0, NOTE_D_SHARP_0, NOTE_F_NATURAL_0, NOTE_G_NATURAL_0}, 
// NOTE_A_NATURAL_0    9
{NOTE_A_NATURAL_0, NOTE_B_NATURAL_0, NOTE_C_SHARP_0, NOTE_D_NATURAL_0, NOTE_E_NATURAL_0, NOTE_F_SHARP_0, NOTE_G_SHARP_0}, 
// NOTE_A_SHARP_0      10
{NOTE_A_SHARP_0, NOTE_C_NATURAL_0, NOTE_D_NATURAL_0, NOTE_D_SHARP_0, NOTE_F_NATURAL_0, NOTE_G_NATURAL_0, NOTE_A_NATURAL_0}, 
// NOTE_B_NATURAL_0    11
{NOTE_B_NATURAL_0, NOTE_C_SHARP_0, NOTE_D_SHARP_0, NOTE_E_NATURAL_0, NOTE_F_SHARP_0, NOTE_G_SHARP_0, NOTE_A_NATURAL_0}

//     "G" : ['G', 'A', 'B', 'C', 'D', 'E', 'F#'],
//     "D" : ['D', 'E', 'F#', 'G', 'A', 'B', 'C#'],
//     "A" : ['A', 'B', 'C#', 'D', 'E', 'F#', 'G#'],
//     "E" : ['E', 'F#', 'G#', 'A', 'B', 'C#', 'D#'],
//     "B" : ['B', 'C#', 'D#', 'E', 'F#', 'G#', 'A'],
//     "F" : ['F', 'G', 'A', 'A#', 'C', 'D', 'E']
};

unsigned char theCadence [] = {0, 5, 1, 4}; // , # Anatole = I VI II V