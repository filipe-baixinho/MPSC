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
p_rq = [0,0,1,14,4,0,0,29,0,34,0,4,82,4,1,71,0,0,0,0,0,0,0,2]
p_isq = [0,5,6,1,0,5,35,31,0,122,0,6,4,5,1,0,0,3,0,3,0,0,0,18]

#probabilities
r = intersect(p_isq,p_rq)

#tuple of empirical probabilities
probabilities = [r]


#contexts
contexts = ["isq_rq_"]


	#file generation details
#name of folder
folder = date * "double_results/"
#initial probabilities
probability = "no_zeros_"
#duration
duration = string(mtime) * "s_"


	#main loop
multiple_batch_generator(contexts,probabilities)
