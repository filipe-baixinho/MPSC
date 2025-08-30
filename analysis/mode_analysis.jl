using JLD,Statistics,DelimitedFiles, CairoMakie, RCall

#include("../old/parameter_estimates.jl")

#input_ids
filenames = ["" for i in 1:8]
filenames[1] = "data/pol_isq.jld"
filenames[2] = "data/pol_rq.jld"
filenames[3] = "data/wh_isq.jld"
filenames[4] = "data/wh_rq.jld"
filenames[5] = "data/wh_pol.jld"
filenames[6] = "data/pol_wh.jld"
filenames[7] = "data/rq_isq.jld"
filenames[8] = "data/isq_rq.jld"

#level = 0.05
#threshold = 0.15


function f2(v,level,threshold)
	q = quantile(v, [level, 1-level])
	d = q[2] - q[1]
	return d < threshold ? true : false
end

function filter_indices(level,threshold)
	#initiate storing array for indices
	x = [[] for i in 1:length(filenames)]
	#calculate indices for all matrices
        for i in 1:length(filenames)
                #load vector with all values for each cell
                vf = load(filenames[i])["all_cells"]
		#initiate boolean vector to store condition outputs
		t = [false for i in 1:length(vf)]
		#run condition for each cell
		for n in 1:length(vf)
			t[n] = f2(vf[n],level,threshold)
		end
		#store the list of boolean outputs in the general storage
		x[i] = t
	end	
	#return indices storing array
	return x
end


function wrapper_sum(level,threshold)
	x = filter_indices(level,threshold)
	sum([sum(y) for y in x])
end


cell_filter = filter_indices(level,threshold)

for i in 1:length(cell_filter)
	cell_filter[i] = findall(x -> x == true, cell_filter[i])
end
