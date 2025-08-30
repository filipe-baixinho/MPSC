using JLD,Statistics,DelimitedFiles,CairoMakie

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


#titles
titles = ["" for i in 1:8]                                                                    
titles[1] = "Median Coefficient Matrix: Pol-ISQ system"
titles[2] = "Median Coefficient Matrix: Pol-RQ system"
titles[3] = "Median Coefficient Matrix: Wh-ISQ system"
titles[4] = "Median Coefficient Matrix: Wh-RQ system"
titles[5] = "Median Coefficient Matrix: WhQ-PolQ system"
titles[6] = "Median Coefficient Matrix: PolQ-WhQ system"
titles[7] = "Median Coefficient Matrix: RQ-ISQ system"
titles[8] = "Median Coefficient Matrix: ISQ-RQ system"


#ylabels
ylabels = ["" for i in 1:8]                                                                    
ylabels[1] = "penalty-recipient strategy from Pol-ISQ system"
ylabels[2] = "penalty-recipient strategy from Pol-RQ system"
ylabels[3] = "penalty-recipient strategy from Wh-ISQ system"
ylabels[4] = "penalty-recipient strategy from Wh-RQ system"
ylabels[5] = "penalty-recipient strategy from WhQ system"
ylabels[6] = "penalty-recipient strategy from PolQ system"
ylabels[7] = "penalty-recipient strategy from RQ system"
ylabels[8] = "penalty-recipient strategy from ISQ system"


#xlabels
xlabels = ["" for i in 1:8]
xlabels[1] = "penalty-giver strategy from Pol-ISQ system



	index || 1:\t H* H-^H%\t\t\t\t	2:\t H* L-H%\t\t\t\t	3:\t L+H* H-^H%\t\t\t\t	 4:\t L+H* L-H%\t\t\t\t	
5:\t L+H* L-%\t\t\t\t	6:\t L* H-^H%\t\t\t\t	7:\t L* L-%\t\t\t\t	8:\t L*+H H-%\t\t\t\t	9:\t L*+H H-^H%\t\t\t\t"  
	

xlabels[2] = "penalty-giver strategy from Pol-RQ system



	index	|| 2:\t L+H* L-%\t\t\t\t	3:\t L* H-^H%\t\t\t\t	4:\t L*+H H-%\t\t\t\t"  
	


xlabels[3] = "penalty-giver strategy from Wh-ISQ system



	index || 2:\t H* L-H%\t\t\t\t	3:\t H* L-%\t\t\t\t	5:\t L+H* L-H%\t\t\t\t	6:\t L+H* L-%\t\t\t\t	
7:\t L* H-^H%\t\t\t\t	8:\t L* L-%\t\t\t\t	10: L*+H L-H%\t\t\t\t	12:\t H+L* L-%\t\t\t\t	13:\t H+!H* L-%\t\t\t\t	"  
	


xlabels[4] = "penalty-giver strategy from Wh-RQ system



	index || 1: H* L-H%\t\t\t\t	2: H* L-%\t\t\t\t	3: L+H* L-%\t\t\t\t	7: L*+H L-H%\t\t\t\t	8: L*+H L-%\t\t\t\t"  
	

xlabels[5] = "penalty-giver strategy from PolQ system



	index || 1: H* H-^H%\t\t\t\t	3: L+H* H-^H%\t\t\t\t	5: L+H* L-%\t\t\t\t	6: L* H-^H%\t\t\t\t	8: L*+H H-%\t\t\t\t	
	9: L*+H L-%\t\t\t\t"  
	


xlabels[6] = "penalty-giver strategy from WhQ system



	index || 2: H* L-H%\t\t\t\t	4: L+H* L-H%\t\t\t\t	5: L+H* L-%\t\t\t\t	6:  L* H-^H%\t\t\t\t	7: L* L-%\t\t\t\t	
	8: L*+H H-%\t\t\t\t	9: L*+H L-%\t\t\t\t"  
	



xlabels[7] = "penalty-giver strategy from ISQ system



	 
index || 2: H* L-H%\t\t\t\t	3: L+H* L-%\t\t\t\t	4: L* H-^H%\t\t\t\t	6: L*+H H-%\t\t\t\t	8: L*+H L-H%\t\t\t\t"  
	


xlabels[8] = "penalty-giver strategy from RQ system



index || 2: H* L-H%\t\t\t\t	3: L+H* L-%\t\t\t\t	4: L* H-^H%\t\t\t\t	6: L*+H H-%\t\t\t\t	8: L*+H L-H%\t\t\t\t"  
	



#loop for all contexts in the folder
for i in 1:length(filenames)

		#get median matrix		
	#load vector with all values for each cell
	vf = load(filenames[i])["all_cells"]

	print("\n running loop: " * string(i))

	v_median = median.(vf)
		
		#filter out cells
	for c in 1:length(v_median)
#		println(v_median)
		if c ∉ cell_filter[i]
			v_median[c] = -0.1
		end

	end
	int_v = filter(x->x > 0.0,v_median)	
	println(int_v)
	nstrat = Int64(sqrt(length(v_median)))
	#transform loaded vector into a matrix
	m_median = reshape(v_median,(nstrat,nstrat))
#	@show m_median
	#transform diagonals into -0.1 !!! TURN OFF FOR CS MATRICES !!!
#        setindex!.(Ref(m_median),-0.1,1:nstrat,1:nstrat)

		#plot

	#define colormap limits
	joint_limits = (0, 1)
	#print lines of matrix
	borders = 1:nstrat

	#filter x ticks
	x_t = [[] for t in 1:nstrat]
	x_ticks = [false for a in 1:nstrat]
	for n in 1:nstrat
		for a in m_median[n,:]
			a > 0.0 ? x_t[n] = vcat(x_t[n],true) : x_t[n] = vcat(x_t[n],false)
		end
#		println(sum(x_t[n]))
		sum(x_t[n]) > 0 ? x_ticks[n] = true : x_ticks[n] = false
#		println(ticks[n])
	end			
	yticks_filter = findall(x -> x == true,x_ticks)

	#filter y ticks
	y_t = [[] for t in 1:nstrat]
	y_ticks = [false for a in 1:nstrat]
	for n in 1:nstrat
		for a in m_median[:,n]
			a > 0.0 ? y_t[n] = vcat(y_t[n],true) : y_t[n] = vcat(y_t[n],false)
		end
#		println(sum(y_t[n]))
		sum(y_t[n]) > 0 ? y_ticks[n] = true : y_ticks[n] = false
#		println(ticks[n])
	end			
	xticks_filter = findall(x -> x == true,y_ticks)

	xticks_s = ["" for i in 1:nstrat]
	yticks_s = ["" for i in 1:nstrat]

	for i in 1:nstrat
           if i in xticks_filter
		 xticks_s[i] = string(i)
           end
	end


	for i in 1:nstrat
           if i in yticks_filter 
		yticks_s[i] = string(i)
           end
	end

		#index labels

println("\n"* string(length(xticks_filter)))	

	set_theme!(theme_latexfonts())
	f = Figure(size = (1100,1000))
#	set_theme!(theme_dark())
	ax1 = Axis(f[1, 1], 
		title = titles[i],
#		titlealign = :left,
		titlesize = 40,
		titlefont = :regular,
		titlegap = 100.0,
		xlabel = xlabels[i],
		xlabelsize = 25,
		ylabel = ylabels[i],
		ylabelsize = 25,
		xticks = (1:nstrat,xticks_s),
		yticks = (1:nstrat,yticks_s),
		yreversed = true,
#		xticklabelrotation = -π/3.5,
#		yticklabelrotation = π/3.5,
#		xticklabelrotation = 0.78,
#		xaxisposition = :top,
		xlabelpadding = 30,
		ylabelpadding = 30,
		aspect = DataAspect(),
		xticksvisible = false,
		yticksvisible = false,
		xticklabelsize = 25,
		yticklabelsize = 25		
	)
	
	hidespines!(ax1)

	hm = heatmap!(ax1,
		m_median',
		colorrange = joint_limits,
		lowclip =:transparent,
		colormap =:managua10,
		)

	Colorbar(f[:,end+1],hm,
		size = 20,
		ticks = [0,0.05,0.1,0.9,0.95,1.0])


	f

	resize_to_layout!(f)
	
	graph_title = "median_matrices/" * ids[i] * "median_matrix.pdf" 
	save(graph_title,f)

		#plot distributions of v_median
	#y axis
	y = zeros(length(int_v))
	#new figure
	g2 = Figure(size = (1000,200))
	#new axis
	ax2 = Axis(g2[1,1],
		title = "",		
		titlesize = 30,
		titlefont = :regular,
		titlegap = 50.0,
		yticks = y,
		xlabel = "estimated value",
		xlabelsize = 20,
		xlabelpadding = 20,
		xticks = 0:0.1:1,
		xticksvisible = false
		)
	scatter!(ax2,int_v,y,
		alpha=0.2,
		color = :black,
		markersize = 10)

	hideydecorations!(ax2)
	hidespines!(ax2)
	graph_title_2 = "filtered_cell_distributions/filtered_cells_" *  ids[i] * "distribution.pdf"
	save(graph_title_2,g2)

end
