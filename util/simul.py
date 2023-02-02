import numpy as np
import scipy.signal as sig
import matplotlib.pyplot as plt


R2 = 4700
R3 = 470 
R4 = 1000 # 1kOhm
C5 = 10e-9

print(R4*(R2+R3) / (R2+R3+R4))

b = [R2*R3*R4*C5, R4*(R2+R3)]
a = [R3*(R2+R4)*C5,R2+R3+R4]

def main():
    print ("coucou")
    H_1 = sig.lti(b, a)

    print (H_1)
    [t_ind, r_ind] = H_1.step()

    plt.plot(t_ind, r_ind, label="Réponse Indicielle")
    plt.xlabel("Temps (s)")
    plt.legend()
    plt.show()

    [w, r_w] = H_1.freqresp()
    module = np.abs(r_w)
    argument = 180*np.angle(r_w)/np.pi

    plt.loglog(w, module)
    plt.grid()
    plt.ylabel("Module")
    plt.xlabel("Pulsation (rad/s)")


    plt.figure()
    plt.semilogx(w,argument)
    plt.grid()
    plt.ylabel("Argument (deg)")
    plt.xlabel("Pulsation (rad/s)")
    plt.show()
    # plt.figure(1)
    # plt.title("tables from msx replay software")
    # signal_part1 = np.fromiter(tab1, "Int8")
    # signal_part2 = np.fromiter(tab2, "Int8")
    # signal_part3 = np.fromiter(tab3, "Int8")
    # sample_signal = sample
    # comp_part1 = np.exp2(-((15-signal_part1)/2))
    # comp_part2 = np.exp2(-((15-signal_part2)/2))
    # comp_part3 = np.exp2(-((15-signal_part3)/2))
    # signal  = comp_part1 + comp_part2 + comp_part3 # signal_part1 + signal_part2 + signal_part3
    # plt.plot(signal)
    # plt.show()

if __name__ == '__main__':
    main()

