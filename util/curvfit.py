import numpy
from numpy import arange
#from pandas import read_csv
from scipy.optimize import curve_fit
from matplotlib import pyplot
import math

# define the true objective function
def objective(x, a, f):
        return math.sqrt(15*x)*a + f
	#return (a * x) + f
 
# load the dataset
#url = 'https://raw.githubusercontent.com/jbrownlee/Datasets/master/longley.csv'
#dataframe = read_csv(url, header=None)
y = [ 0.0, 0.9, 1.3, 1.58]
x = [ 0, 1, 2, 3]
data = numpy.array([[ 0.0, 0.9, 1.3, 1.58], [ 0, 1, 2, 3]])
print (x,y)
#data = dataframe.values
# choose the input and output variables
#x, y = data[:, 4], data[:, -1]
# curve fit
popt, _ = curve_fit(objective, x, y)
# summarize the parameter values
a, f = popt
# plot input vs output
pyplot.scatter(x, y)
# define a sequence of inputs between the smallest and largest known inputs
x_line = arange(min(x), max(x), 1)
# calculate the output for the range
y_line = objective(x_line, a, f)
# create a line plot for the mapping function
pyplot.plot(x_line, y_line, '--', color='red')
pyplot.show()
