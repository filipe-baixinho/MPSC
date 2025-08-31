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
all_labels[1] = vec(readdlm("vector_wh_rq.txt",','))

#vector of empirical probabilities
p_wh_rq = [1,14,27,3,4,3,1,68,2]
probabilities = [p_wh_rq]

#contexts
contexts = ["wh_rq_"]


	#file generation details
#name of folder
folder = date * "null_diagonals_results/"
#initial probabilities
probability = "no_zeros_"
#duration
duration = string(mtime) * "s_"


	#main loop
multiple_batch_generator(all_labels,contexts,probabilities)
