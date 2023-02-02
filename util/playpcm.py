import matplotlib.pyplot as plt
import numpy as np

# from pcm import table_1 as tab1
# from pcm import table_2 as tab2
# from pcm import table_3 as tab3
from pcm import PSG_Sample_Table1 as tab1
from pcm import PSG_Sample_Table2 as tab2
from pcm import PSG_Sample_Table3 as tab3
from samples import WelcomeSample as sample



def main():
    print ("coucou")
    plt.figure(1)
    plt.title("tables from msx replay software")
    signal_part1 = np.fromiter(tab1, "Int8")
    signal_part2 = np.fromiter(tab2, "Int8")
    signal_part3 = np.fromiter(tab3, "Int8")
    sample_signal = sample
    comp_part1 = np.exp2(-((15-signal_part1)/2))
    comp_part2 = np.exp2(-((15-signal_part2)/2))
    comp_part3 = np.exp2(-((15-signal_part3)/2))
    signal  = comp_part1 + comp_part2 + comp_part3 # signal_part1 + signal_part2 + signal_part3
    plt.plot(signal)
    plt.show()

if __name__ == '__main__':
    main()
