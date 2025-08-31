#attempt to functionalize code
	
	#functions

#normalize vector
function normalize(p::Vector{Int64})
	p = p ./ sum(p)
	return p
end

#null_diagonal
function null_diagonal(a::Vector{Float64},nstrat::Int64)

	#reshape vector as matrix
	a = reshape(a,(nstrat,nstrat))
	#transform every diagonal cell in 0
	setindex!.(Ref(a),0.0,1:nstrat,1:nstrat)
	#reshape back into vector
	a = reshape(a,nstrat*nstrat)

end

#objective function
function g(a::Vector{Float64},p::Vector{Float64})

	# wrap vector a into a 24x24 matrix A
	A = reshape(a, (nstrat, nstrat))
	#define c locally as the dot product of vector a[n,:] and p
	local c
	c = [sum(A[n,:] .* p) for n in 1:length(p)]
	#objective function
	sqrt(
	sum([(p[n] - (c[n]^-1/sum(c.^-1)))^2
	for n in 1:length(p)])/length(p))

end

#optimization function
function optimizer(nstrat::Int64,mtime::Int64)

	#generate initial guess values for c^-> = [c1,c2,...,cn]
	a0 = rand(nstrat*nstrat)
	#make matrix diagonals null
	null_diagonal(a0,nstrat)
	#call objective function
	f = OptimizationFunction(g)
	#define optimization problem
	prob = OptimizationProblem(f, a0, p, lb = lower, ub = upper)
	#generate solution
	global sol = solve(prob, BBO_adaptive_de_rand_1_bin_radiuslimited(), maxtime = mtime)
	#optimized values as a matrix
	global opt = reshape(sol.u, (nstrat, nstrat))
	#return
	return sol,opt

end

#first loop: generate matrices and store them in bigger matrix m
function matrix_generator(nstrat::Int64,mtime::Int64,iter::Int64,labels::Vector,context::String)

	#initialize first vector: containing all matrices
	global m = [zeros(nstrat*nstrat) for i in 1:iter]
	data_id = folder * probability * duration * context
	#generation loop

		for i in 1:iter
			try
				begin
		println("iteration number: " * string(i) *" is running...")
	        #generate data for polar_iclude("matrix_generator_no_zeroes_wh_isq.jl")
		optimizer(nstrat,mtime)
		#create data file name
	        d_title = data_id * string(i) * ".jld"
		#convert results into storable types
	        retcode = string(sol.retcode)
	        stats = string(sol.stats)
		#export data
	        save(d_title, "matrix",opt,"sol",sol.u,"retcode",retcode,"stats",stats,"objective_value",sol.objective)
		#store matrix in session matrix
	        m[i] = copy(sol.u)
                #plot
	        graph = heatmap(labels,labels,opt,xticks=(1:nstrat,labels),yticks=(1:nstrat,labels),xrotation = 45)
	        #save plot
	        g_title = data_id * string(i) * ".png"
	        savefig(graph,g_title)
				end
			catch e
				println(e)
	
			end
		end

	return m

end


#second loop and third loop: store each i entry of each matrix within one of the vectors
function matrix_sd_calculator(m::Vector{Vector{Float64}})

	#initialize second vector: containing all values for each entry of the matrix
	v = [zeros(iter) for i in 1:nstrat*nstrat]
	#initialize third vector: containing all standard deviations
	s = zeros(nstrat*nstrat)	
	#contained in the large array of vectors v
	for n in 1:nstrat*nstrat
	        for i in 1:iter
	                v[n][i] = m[i][n]
	        end
	end
	#fourth loop: calculate standard deviations and store them in vector s
	for n in 1:nstrat*nstrat
	        s[n] = std(v[n])
	end
	#plot distribution of standard deviations
	graph2 = plot(s)
	graph3 = histogram(s)
	#reshape sd vector into a matrix
	s = reshape(s,(nstrat,nstrat))
	#plot heatmap of standard deviations
	graph4 = heatmap(s)
	#export all figures
	savefig(graph2,folder * context * duration * "standard_deviation_plot.png")
	savefig(graph3,folder * context * duration * "standard_deviation_hist.png")
	savefig(graph4,folder * context * duration * "standard_deviation_heat.png")
	#export overall results of the matrix comparisons
	save(folder * context * duration * "sd_results.jld","all_matrix",m,"all_sds",s)	
end

#wrapper function
function batch_generator(context)
	time0 = time()
	println("\n" * context * "batch status: INITIALIZED\n")
	matrix_generator(nstrat,mtime,iter,labels,context)
	matrix_sd_calculator(m)
	delta = time() - time0
	println("\n" * context * "batch status: FINISHED")
	println("Runtime: $delta seconds")
end


#iterator function
function multiple_batch_generator(all_labels,contexts,probabilities)
	for i in 1:length(contexts)
		global context = contexts[i]
		global labels = all_labels[i]
		global p = probabilities[i]
		p = normalize(p)
		#number of strategies, lengths, lower and upper boundaries
		global nstrat = length(p)
		#lower boundary
		global lower = zeros(nstrat*nstrat)
		#upper boundary
		global upper = ones(nstrat*nstrat)
		#make diagonals null
		upper = null_diagonal(upper,nstrat)
		batch_generator(context)
	end
end
