
import math
import matplotlib.pyplot as plt
from scipy import signal
import numpy as np


# format :  AIFF 
# ========
#  {'PCM_S8': 'Signed 8 bit PCM', 'PCM_16': 'Signed 16 bit PCM', 'PCM_24': 'Signed 24 bit PCM', 'PCM_32': 'Signed 32 bit PCM', 'PCM_U8': 'Unsigned 8 bit PCM', 'FLOAT': '32 bit float', 'DOUBLE': '64 bit float', 'ULAW': 'U-Law', 'ALAW': 'A-Law', 'IMA_ADPCM': 'IMA ADPCM', 'GSM610': 'GSM 6.10', 'DWVW_12': '12 bit DWVW', 'DWVW_16': '16 bit DWVW', 'DWVW_24': '24 bit DWVW'}
# format :  AU 
# ========
#  {'PCM_S8': 'Signed 8 bit PCM', 'PCM_16': 'Signed 16 bit PCM', 'PCM_24': 'Signed 24 bit PCM', 'PCM_32': 'Signed 32 bit PCM', 'FLOAT': '32 bit float', 'DOUBLE': '64 bit float', 'ULAW': 'U-Law', 'ALAW': 'A-Law', 'G721_32': '32kbs G721 ADPCM', 'G723_24': '24kbs G723 ADPCM'}
# format :  AVR 
# ========
#  {'PCM_S8': 'Signed 8 bit PCM', 'PCM_16': 'Signed 16 bit PCM', 'PCM_U8': 'Unsigned 8 bit PCM'}
# format :  CAF 
# ========
#  {'PCM_S8': 'Signed 8 bit PCM', 'PCM_16': 'Signed 16 bit PCM', 'PCM_24': 'Signed 24 bit PCM', 'PCM_32': 'Signed 32 bit PCM', 'FLOAT': '32 bit float', 'DOUBLE': '64 bit float', 'ULAW': 'U-Law', 'ALAW': 'A-Law', 'ALAC_16': '16 bit ALAC', 'ALAC_20': '20 bit ALAC', 'ALAC_24': '24 bit ALAC', 'ALAC_32': '32 bit ALAC'}
# format :  FLAC 
# ========
#  {'PCM_S8': 'Signed 8 bit PCM', 'PCM_16': 'Signed 16 bit PCM', 'PCM_24': 'Signed 24 bit PCM'}
# format :  HTK 
# ========
#  {'PCM_16': 'Signed 16 bit PCM'}
# format :  SVX 
# ========
#  {'PCM_S8': 'Signed 8 bit PCM', 'PCM_16': 'Signed 16 bit PCM'}
# format :  MAT4 
# ========
#  {'PCM_16': 'Signed 16 bit PCM', 'PCM_32': 'Signed 32 bit PCM', 'FLOAT': '32 bit float', 'DOUBLE': '64 bit float'}
# format :  MAT5 
# ========
#  {'PCM_16': 'Signed 16 bit PCM', 'PCM_32': 'Signed 32 bit PCM', 'PCM_U8': 'Unsigned 8 bit PCM', 'FLOAT': '32 bit float', 'DOUBLE': '64 bit float'}
# format :  MPC2K 
# ========
#  {'PCM_16': 'Signed 16 bit PCM'}
# format :  OGG 
# ========
#  {'VORBIS': 'Vorbis'}
# format :  PAF 
# ========
#  {'PCM_S8': 'Signed 8 bit PCM', 'PCM_16': 'Signed 16 bit PCM', 'PCM_24': 'Signed 24 bit PCM'}
# format :  PVF 
# ========
#  {'PCM_S8': 'Signed 8 bit PCM', 'PCM_16': 'Signed 16 bit PCM', 'PCM_32': 'Signed 32 bit PCM'}
# format :  RAW 
# ========
#  {'PCM_S8': 'Signed 8 bit PCM', 'PCM_16': 'Signed 16 bit PCM', 'PCM_24': 'Signed 24 bit PCM', 'PCM_32': 'Signed 32 bit PCM', 'PCM_U8': 'Unsigned 8 bit PCM', 'FLOAT': '32 bit float', 'DOUBLE': '64 bit float', 'ULAW': 'U-Law', 'ALAW': 'A-Law', 'GSM610': 'GSM 6.10', 'DWVW_12': '12 bit DWVW', 'DWVW_16': '16 bit DWVW', 'DWVW_24': '24 bit DWVW', 'VOX_ADPCM': 'VOX ADPCM'}
# format :  RF64 
# ========
#  {'PCM_16': 'Signed 16 bit PCM', 'PCM_24': 'Signed 24 bit PCM', 'PCM_32': 'Signed 32 bit PCM', 'PCM_U8': 'Unsigned 8 bit PCM', 'FLOAT': '32 bit float', 'DOUBLE': '64 bit float', 'ULAW': 'U-Law', 'ALAW': 'A-Law'}
# format :  SD2 
# ========
#  {'PCM_S8': 'Signed 8 bit PCM', 'PCM_16': 'Signed 16 bit PCM', 'PCM_24': 'Signed 24 bit PCM', 'PCM_32': 'Signed 32 bit PCM'}
# format :  SDS 
# ========
#  {'PCM_S8': 'Signed 8 bit PCM', 'PCM_16': 'Signed 16 bit PCM', 'PCM_24': 'Signed 24 bit PCM'}
# format :  IRCAM 
# ========
#  {'PCM_16': 'Signed 16 bit PCM', 'PCM_32': 'Signed 32 bit PCM', 'FLOAT': '32 bit float', 'ULAW': 'U-Law', 'ALAW': 'A-Law'}
# format :  VOC 
# ========
#  {'PCM_16': 'Signed 16 bit PCM', 'PCM_U8': 'Unsigned 8 bit PCM', 'ULAW': 'U-Law', 'ALAW': 'A-Law'}
# format :  W64 
# ========
#  {'PCM_16': 'Signed 16 bit PCM', 'PCM_24': 'Signed 24 bit PCM', 'PCM_32': 'Signed 32 bit PCM', 'PCM_U8': 'Unsigned 8 bit PCM', 'FLOAT': '32 bit float', 'DOUBLE': '64 bit float', 'ULAW': 'U-Law', 'ALAW': 'A-Law', 'IMA_ADPCM': 'IMA ADPCM', 'MS_ADPCM': 'Microsoft ADPCM', 'GSM610': 'GSM 6.10'}
# format :  WAV 
# ========
#  {'PCM_16': 'Signed 16 bit PCM', 'PCM_24': 'Signed 24 bit PCM', 'PCM_32': 'Signed 32 bit PCM', 'PCM_U8': 'Unsigned 8 bit PCM', 'FLOAT': '32 bit float', 'DOUBLE': '64 bit float', 'ULAW': 'U-Law', 'ALAW': 'A-Law', 'IMA_ADPCM': 'IMA ADPCM', 'MS_ADPCM': 'Microsoft ADPCM', 'GSM610': 'GSM 6.10', 'G721_32': '32kbs G721 ADPCM'}
# format :  NIST 
# ========
#  {'PCM_S8': 'Signed 8 bit PCM', 'PCM_16': 'Signed 16 bit PCM', 'PCM_24': 'Signed 24 bit PCM', 'PCM_32': 'Signed 32 bit PCM', 'ULAW': 'U-Law', 'ALAW': 'A-Law'}
# format :  WAVEX 
# ========
#  {'PCM_16': 'Signed 16 bit PCM', 'PCM_24': 'Signed 24 bit PCM', 'PCM_32': 'Signed 32 bit PCM', 'PCM_U8': 'Unsigned 8 bit PCM', 'FLOAT': '32 bit float', 'DOUBLE': '64 bit float', 'ULAW': 'U-Law', 'ALAW': 'A-Law'}
# format :  WVE 
# ========
#  {'ALAW': 'A-Law'}
# format :  XI 
# ========
#  {'DPCM_16': '16 bit DPCM', 'DPCM_8': '8 bit DPCM'}


def main():
    print ("coucou")
    plt.figure(1)

    t = np.linspace(0, 1, 200, endpoint=False)
    freq = 2
    sqsig = signal.square(2 * np.pi * freq * t)

    plt.title("signal carré")
    plt.plot(sqsig)
    plt.show()

    phi1 = np.pi # 0 # 
    phi2 = 0 # np.pi # 
    phi3 = np.pi # 0 # 
    phi4 = 0 # np.pi  # 

    fond = np.sin(2 * np.pi * freq *  t)
    harm1 = (1/3)*np.sin(2 * np.pi * (freq*3) *  t + phi1)
    harm2 = (1/5)*np.sin(2 * np.pi * (freq*5) *  t + phi2)
    harm3 = (1/7)*np.sin(2 * np.pi * (freq*7) *  t + phi3)
    harm4 = (1/9)*np.sin(2 * np.pi * (freq*9) *  t + phi4)

    fig, axs = plt.subplots(5)

    axs[0].plot(fond, label='fondamentale', color='black', linestyle='dashed', linewidth = 2) 
    axs[0].set_title('fondamentale')
             # marker='o', markerfacecolor='blue', markersize=10) 
    axs[1].plot(harm1, label='harmonique 1',color='red', linestyle='dashed', linewidth = 2) 
             # marker='o', markerfacecolor='green', markersize=10) 
    axs[1].set_title('harmonique 1')
    #plt.legend()
    axs[2].plot(harm2, label='harmonique 2', color='blue', linewidth = 2) 
    axs[2].set_title('harmonique 2')
    #plt.legend()
    axs[3].plot(harm3, label='harmonique 3', color='yellow', linewidth = 2) 
    axs[3].set_title('harmonique 3')
    #plt.legend()
    axs[4].plot(harm4, label='harmonique 4', color='green', linewidth = 2) 
    axs[4].set_title('harmonique 4')
    #plt.legend()
    for ax in axs.flat:
        ax.label_outer()
    plt.show()
    # plt.plot(yi, label='harmonique 5', color='grey', linewidth = 2, markersize=10) 

    rebuiltsquare = fond+harm1+harm2+harm3+harm4

    hist, bin_edges = np.histogram(rebuiltsquare)

    plt.title("signal carré reconstitué")
    plt.plot(rebuiltsquare)
    plt.show()

    plt.hist(rebuiltsquare)
    plt.title("Histogramme des échantillons")
    plt.show()

if __name__ == '__main__':
    main()

