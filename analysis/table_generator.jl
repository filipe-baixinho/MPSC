using JLD,Statistics,DelimitedFiles,CairoMakie, PrettyTables

level = 0.05
threshold = 0.15

include("mode_analysis.jl")

#output_ids
ids = ["" for i in 1:8]
ids[1] = "pol_isq_"
ids[2] = "pol_rq_"
ids[3] = "wh_isq_"
ids[4] = "wh_rq_"
ids[5] = "wh_pol_"
ids[6] = "pol_wh_"
ids[7] = "rq_isq_"
ids[8] = "isq_rq_"


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


#loop for all contexts in the folder
for i in 1:length(filenames)

		#get median matrix		
	#load vector with all values for each cell
	vf = load(filenames[i])["all_cells"]

#	print("\n running loop: " * string(i))

	v_median = median.(vf)
		
		#filter out cells
	for c in 1:length(v_median)
#		println(v_median)
		if c ∉ cell_filter[i]
			v_median[c] = -0.1
		end

	end

	int_v = filter(x->x > 0.0,v_median)	
#	println(int_v)
	nstrat = Int64(sqrt(length(v_median)))
	#transform loaded vector into a matrix
	m_median = reshape(v_median,(nstrat,nstrat))
#	@show m_median
	#transform diagonals into -0.1
#        setindex!.(Ref(m_median),-0.1,1:nstrat,1:nstrat)
	m_median = replace(m_median, -0.1 => "")
	pretty_table(m_median, backend = Val(:markdown))
	

end
