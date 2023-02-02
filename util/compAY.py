import math
import matplotlib.pyplot as plt

#pow(2,(X-15)/2)+pow(2,(Y-15)/2)
#def tensionV (E): return 1/math.sqrt(2**(15-E))
def tensionV (E): return 2**((E-15)/2)

def commandeEnveloppe (Consigne, Volume):
    if Consigne == 0 : return 0
    return max(0,Volume + 2*math.log2(Consigne))

x = range(16)

tabCompens = [[round(commandeEnveloppe (C/15.0, v)) for C in x] for v in x]



def Affiche (Volume):
    
    y = [tensionV(c) for c in tabCompens[Volume]]  
    yn = [tensionV(c) for c in x]
    print (yn)
    yi = [c*(tensionV(Volume))/15.0 for c in x] 
    ye = [(y[i] - yi[i])/(i+1) for i in range (len(y))]
      
    plt.plot(x, y, label='avec pre-compensation', color='black', linestyle='dashed', linewidth = 2, 
             marker='o', markerfacecolor='blue', markersize=10) 
    plt.plot(x, yn, label='sans pre-compensation',color='black', linestyle='dashed', linewidth = 2, 
             marker='o', markerfacecolor='green', markersize=10) 
    plt.plot(x, yi, label='linéarisation idéale', color='yellow', linewidth = 2, markersize=10) 

      

    plt.xlabel("Consigne d'enveloppe C (en quinzième du Volume)") 
    plt.ylabel('Tension V en sortie du convertisseur (en Volt)') 
    plt.title('Effet de la linéarisation (Volume = %d, vmax = %0.2f V)'%(Volume, tensionV(Volume)) )
    plt.legend()

    plt.show() 
    plt.plot(x, ye, label='erreur de linéarisation', color='red', linewidth = 2,  marker='o', markerfacecolor='green', markersize=10) 
    plt.title('Erreur de niveau  (Volume = %d, vmax = %0.2f V)'%(Volume, tensionV(Volume)) )
    #plt.plot (ye)
    plt.show() 
    
Affiche (15)


