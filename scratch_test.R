n_verts <- 6

graph <- data.frame(starts = c(0, 1, 1, 4, 4, 4, 4, 0, 1, 2, 3),
                    ends = c(1, 3, 2, 0, 1, 2, 3, 5, 5, 5, 5),
                    weights = c(1, 1, 1, 2, 2, 1, 1, 1, 2, 2, 1))

shortest_path(3, 5, n_verts, graph)

library(tictoc)

seventhirty <- read.table("inst/data-raw/730.tsv", sep = "\t")

tic()
shortest_path(start_vertex = 1, end_vertex = 715, vertex_num = 730, graph_df = seventhirty)
toc()

tic()
k_shortest_paths(start_vertex = 1, end_vertex = 715, k = 10, vertex_num = 730, graph_df = seventhirty)
toc()
