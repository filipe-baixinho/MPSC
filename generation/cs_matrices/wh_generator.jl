#packages
using JLD,Plots,DelimitedFiles,Statistics,Optimization,OptimizationBBO,Distributed,Random

Random.seed!(1234)

#functions
include("functions.jl")
#calculations
#include("intermediate_calculations.jl")

	#file information
#number of iterations
iter = 1000
#maximum time for optimization
mtime = 300
#date
date = "19_08_2025_"


	#data
#unconditional probabilties
p_pol = [0,3,1,0,4,3,6,6,0,128,0,1,81,9,0,3,0,0,0,0,0,0,0,0]
p_wh = [0,2,6,15,0,2,29,54,0,28,0,9,5,0,2,68,0,3,0,3,0,0,0,20]

#probabilities
r = intersect(p_wh,p_pol)

#tuple of empirical probabilities
probabilities = [r]


#contexts
contexts = ["wh_pol_"]


	#file generation details
#name of folder
folder = date * "double_results/"
#initial probabilities
probability = "no_zeros_"
#duration
duration = string(mtime) * "s_"


	#main loop
multiple_batch_generator(contexts,probabilities)
