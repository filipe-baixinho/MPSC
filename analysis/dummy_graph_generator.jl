using JLD,Statistics,DelimitedFiles,CairoMakie

level = 0.05
threshold = 0.15

include("mode_analysis.jl")

#output_ids
ids = ["" for i in 1:2]
ids[1] = "ws_dummy_"
ids[2] = "cs_dummy_"

#titles
titles = ["" for i in 1:2]
titles[1] = "Dummy Within-System Coefficient Matrix"
titles[2] = "Dummy Cross-System Coefficient Matrix"

#input_ids
filenames = ["" for i in 1:2]

#dummy_matrices

m = [
	[-0.1 1.0 1.0 1.0; 
	0.01 -0.1 0.01 0.01; 
	0.01 0.01 -0.1 1.0; 
	1.0 -0.1 0.01 -0.1]

 for i in 1:2]

m[1] = [-0.1 1.0 1.0 1.0;
       0.01 -0.1 0.01 0.01;
       0.01 0.01 -0.1 1.0;
       1.0 -0.1 0.01 -0.1]


m[2] = [-0.1 1.0 1.0 0.01;
       -0.1 1.0 0.01 0.01;
       -0.1 1.0 0.01 1.0;
       -0.1 1-0 0.01 0.01]

#ylabels
ylabels = ["" for i in 1:2]
ylabels[1] = "penalty-recipient strategy from dummy system"
ylabels[2] = "penalty-recipient strategy from dummy system"

#labels
labels = ["" for i in 1:2]
labels[1] = "penalty-giver strategy from dummy system


	index || 1:\t Strategy #1\t\t\t\t	2:\t Strategy #2\t\t\t\t	3:\t Strategy#3\t\t\t\t	4:\t Strategy #4\t\t\t\t"  
	

labels[2] = "penalty-giver strategy from dummy system


	index || 1:\t Strategy #1\t\t\t\t	2:\t Strategy #2\t\t\t\t	3:\t Strategy#3\t\t\t\t	4:\t Strategy #4\t\t\t\t"  
	

#loop for all contexts in the folder
for i in 1:length(filenames)

		#get median matrix		
	#load vector with all values for each cell
	m_median = m[i]
	nstrat = round(Int,sqrt(length(m[i])))
	
	#filter x ticks
	x_t = [[] for t in 1:nstrat]
	x_ticks = [false for a in 1:nstrat]
	for n in 1:nstrat
		for a in m_median[n,:]
			a > 0.0 ? x_t[n] = vcat(x_t[n],true) : x_t[n] = vcat(x_t[n],false)
		end
		sum(x_t[n]) > 0 ? x_ticks[n] = true : x_ticks[n] = false
	end			
	yticks_filter = findall(x -> x == true,x_ticks)

	#filter y ticks
	y_t = [[] for t in 1:nstrat]
	y_ticks = [false for a in 1:nstrat]
	for n in 1:nstrat
		for a in m_median[:,n]
			a > 0.0 ? y_t[n] = vcat(y_t[n],true) : y_t[n] = vcat(y_t[n],false)
		end
		sum(y_t[n]) > 0 ? y_ticks[n] = true : y_ticks[n] = false
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


	joint_limits = (0,1)

println("\n"* string(length(xticks_filter)))	

	set_theme!(theme_latexfonts())
	f = Figure(size = (1100,1000))
	ax1 = Axis(f[1, 1], 
		title = titles[i],
		titlesize = 40,
		titlefont = :regular,
		titlegap = 100.0,
		xlabel = labels[i],
		xlabelsize = 25,
		ylabel = ylabels[i],
		ylabelsize = 25,
		xticks = (1:nstrat,xticks_s),
		yticks = (1:nstrat,yticks_s),
		yreversed = true,
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
		m[i]',
		colorrange = joint_limits,
		lowclip =:transparent,
		colormap =:managua10,
		)

	Colorbar(f[:,end+1],hm,
		size = 20,
		ticks = [0,0.05,0.1,0.9,0.95,1.0])


	f

        number = 3

        hlines!(number,
		linestyle =(:dot,:dense),
		color = :mediumpurple4,
		linewidth = 9,
		label = "dummy text")
        vlines!(number,
		linestyle =(:dot,:dense),
		linewidth = 9,
		color = :mediumpurple4)

	
	resize_to_layout!(f)
	
	graph_title = "dummy_matrices/" * ids[i] * "median_matrix.pdf" 
	save(graph_title,f)

end
