#attempt to functionalize code
	
	#functions

function get_filter(p1::Vector{Float64},p2::Vector{Float64})
	global filter1
	#find 0s in vector 1
	filter_p1 = findall(x -> x == 0.0,p1)
	#find 0s in vector 2
	filter_p2 = findall(x -> x == 0.0,p2)
	#concatenate
	filter = [filter_p1;filter_p2]
	#reduce vector to unique values by converting to set
	filter = Set(filter)
	#convert set back to vector and order
	filter = sort(collect(filter))
end

function intersect(p1::Vector{Int64},p2::Vector{Int64})
	p1 = normalize(p1)
	p2 = normalize(p2)
	filter = get_filter(p1,p2)
	p1 = deleteat!(p1,filter)
	p2 = deleteat!(p2,filter)

	return p1,p2
end


#=
function merge(p1::Vector{Float64},p2::Vector{Float64},filter)

	#filter initial probability vectors
	p1_f = deleteat!(p1,filter)
	p2_f = deleteat!(p2,filter)
	#generate matrix of products of filtered probabilities
	#initialize vector
	C = zeros(length(p1_f)^2)
	#reshape as matrix
	C = reshape(C,(length(p1_f),length(p1_f)))
	#calculate conditional probabilities in each row
	for i in 1:length(p1_f)
	        C[i,:] = p1_f[i] .* p2_f
	end
	#reshape back into vector
	C = reshape(C,length(p1_f)^2)
	return C
end
=#

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
function g(a::Vector{Float64},r)

	p = r[1]
	q = r[2]
	# wrap vector a into a 24x24 matrix A
	A = reshape(a, (nstrat, nstrat))
	#define c locally as the dot product of vector a[n,:] and p
	local c
	c = [sum(A[n,:] .* q) for n in 1:nstrat]
	#objective function
	sqrt(
	sum([(p[n] - (c[n]^-1/sum(c.^-1)))^2
	for n in 1:nstrat])/nstrat)

end

#optimization function
function optimizer(nstrat::Int64,mtime::Int64)

	#generate initial guess values for c^-> = [c1,c2,...,cn]
	a0 = rand(nstrat^2)
	#make matrix diagonals null
	null_diagonal(a0,nstrat)
	#call objective function
	f = OptimizationFunction(g)
	#define optimization problem
	prob = OptimizationProblem(f, a0, r, lb = lower, ub = upper)
	#generate solution
	global sol = solve(prob, BBO_adaptive_de_rand_1_bin_radiuslimited(), maxtime = mtime)
	#optimized values as a matrix
	global opt = reshape(sol.u, (nstrat, nstrat))
	#return
	return sol,opt

end

#first loop: generate matrices and store them in bigger matrix m
function matrix_generator(nstrat::Int64,mtime::Int64,iter::Int64,context::String)

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
#	        graph = heatmap(labels,labels,opt,xticks=(1:nstrat,labels),yticks=(1:nstrat,labels),xrotation = 45)
#	        graph = heatmap(opt)
	        #save plot
#	        g_title = data_id * string(i) * ".png"
#	        savefig(graph,g_title)
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
	#export overall results of the matrix comparisons
	save(folder * context * duration * "sd_results.jld","all_matrix",m,"all_sds",s,"all_cells",v)	
end

#wrapper function
function batch_generator(context)
	time0 = time()
	println("\n" * context * "batch status: INITIALIZED\n")
	matrix_generator(nstrat,mtime,iter,context)
	matrix_sd_calculator(m)
	delta = time() - time0
	println("\n" * context * "batch status: FINISHED")
	println("Runtime: $delta seconds")
end


#iterator function
function multiple_batch_generator(contexts,probabilities)
	for i in 1:length(contexts)
		global context = contexts[i]
		global r = probabilities[i]
		#number of strategies, lengths, lower and upper boundaries
		global nstrat = length(r[1])
		#lower boundary
		global lower = zeros(nstrat*nstrat)
		#upper boundary
		global upper = ones(nstrat*nstrat)
		#make diagonals null
		upper = null_diagonal(upper,nstrat)
		batch_generator(context)
	end
end
