# MPSC
This repository contains the files used for generating and analysing the data used in my MA thesis "Modeling Prosodic Strategy Competition" as well as the resulting data itself.

# Introduction
The main computational aim of this thesis was to model competition in prosodic systems through the use of matrices of coefficients. These matrices were obtained for each system by defining an optimization problem and solving it with the Differential Evolution optimization algorithm.

# Folder structure
The repository is divided in three main folders: generation/,results/ and analysis/. Because plots are generated together with the analysis, they're also located in the analysis folder.

# Data generation files
The generation files are divided in two groups: CS and WS matrices. These two folders contain the files that were used to generate the final data. The WS matrices folder contains four additional .txt files, because at the time we generated those matrices, we still hadn't abandoned the generation of interim plots for each optimization. For these plots, we wanted to provide labels and hence the .txt files. This was later abandoned for CS matrices.

# Results
In the Results folder there are two .zip files containing the individual data for each of the final 1000 optimizations that was run for each optimization problem. One .zip file corresponds to the data for CS matrices, and the other to WS matrices. Each optimization is summarized in a .JLD file that can be loaded with the JLD package load() function. 

To do that, call the function like this: load(directory)["key"]. Key should be replaced with one of the following: 

- "matrix", to get the optimization solution in matrix shape;
- "sol" for the same in vector shape, "retcode" for information on whether that particular optimization converged;
- "stats" for general information about the optimization (e.g. number of iterations, steps, etc.);
- "objective_value" for the objective value of that optimization.

Since these data are specific to each single optimization, they're mostly useful to check on particular optimization behavior.

# Analysis folder
## Data
For the actual data analysis and plot generation, another data file was generated for each optimization problem. These files group all the information of the whole batch of optimizations. Using these it's easier to summarize group statistics like the medians or the credible intervals. These are all stored in the data/ folder and can be also be called with the load() function (of the JLD package), with the following keys: 

- "all_matrix" for getting a vector containing all the 1000 unsummarized matrices;
- "all_cells" for getting a vector containing all the 1000 values per cell.

The last of these keys is the one that leads to the vectors that were used to compute the median matrices and credible intervals.  

## Analysis/Plotting Scripts
The analysis folder also contains the scripts used to process the data, which are the same files we used to generate the plots: graph_generator.jl, dummy_graph_generator.jl, mode_analysis.jl and table_generator.jl. The first file is the one used to generate the main plots of the thesis (for CS matrices, the line of code that converts diagonals into -0.1 must be commented out manually). The summary statistics are also computed in the first file. The second file was used to generate dummy matrices that were used to introduce the reader to the interpretation of these matrices. The third file is used by the plot generation files to calculate credible intervals. Finally, table_generator.jl was the file used to generate the original markdown tables in nummerical_matrices.md (the row numbering was later added manually). 

## Plots
All plots that were used in the thesis and seven extra ones (the distributions of median coefficients for seven systems) can be found in one of three folders contained in the analysis folder: median_matrices/, filtered_cell_distributions/ and dummy_matrices/.

# General Disclaimer
The code that is shared here is an instance of what is known as 'researcher code'. The sole purpose of sharing it is to make the procedure reproducible and more transparent for other researchers. That being said, the original folder and file structure was not exactly the one presented here, because the relevant files probably amount to less than 5% of all the files and folders that were generated through this project. Practically speaking, this could mean that the directories used in the files no longer make sense. Each script only uses directories to load data files at the very beginning, so, before using the scripts, the user is recommended to check these directories, to avoid unnecessary error messages. 
