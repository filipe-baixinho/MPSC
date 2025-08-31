#packages
using JLD,Plots,DelimitedFiles,Statistics,Optimization,OptimizationBBO,Distributed

#functions
include("functions.jl")

	#file information
#number of iterations
iter = 1000
#maximum time for optimization
mtime = 300
#date
date = "11_07_2025_"

	#external data
#load graphic labels
all_labels = Vector{Any}(undef,1)
all_labels[1] = vec(readdlm("vector_pol_rq.txt",','))

#vector of empirical probabilities
p_pol_rq = [4,2,31,79,4,3]
probabilities = [p_pol_rq]

#contexts
contexts = ["pol_rq_"]


	#file generation details
#name of folder
folder = date * "null_diagonals_results/"
#initial probabilities
probability = "no_zeros_"
#duration
duration = string(mtime) * "s_"


	#main loop
multiple_batch_generator(all_labels,contexts,probabilities)
