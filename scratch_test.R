document()
library(tictoc)

seventhirty <- read.table("inst/data-raw/730.tsv", sep = "\t")

tic()
shortest_path(start_vertex = 1, end_vertex = 715, vertex_num = 730, graph_df = seventhirty)
toc()

tic()
k_shortest_paths(start_vertex = 1, end_vertex = 715, k = 1000, vertex_num = 730, graph_df = seventhirty)
toc()
