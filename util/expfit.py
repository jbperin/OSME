import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

def mexp(x, a, b, c):
    return a * np.exp(-b * x) + c

def msqrt(x, a, b, c):
    return a * np.sqrt(b * x) + c

def msqrts(x, a, b):
    return a * np.sqrt(b * x)

def msqrts(x, a, b):
    return a * np.sqrt(b * x)

def mlog(x, a, b, c):
    return a * np.log(b * x) + c

def mlog2(x, a, b, c):
    return a * np.log2(b * x) + c

x = np.array([ 15, 30, 45])
y = np.array([  0.9, 1.3, 1.58])

popt, pcov = curve_fit(msqrts, x, y)

print (popt, pcov)

plt.figure()
plt.plot(x, y, 'ko', label="Original Noised Data")
plt.plot(x, msqrts(x, *popt), 'r-', label="Fitted Curve")
plt.legend()
plt.show()
