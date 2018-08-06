library(tictoc)

document()

seventhirty <- read.table("inst/data-raw/730.tsv", sep = "\t")

tic()
shortest_path(start_vertex = 1, end_vertex = 715, vertex_num = 730, graph_df = seventhirty)
toc()

tic()
k_shortest_paths(start_vertex = 1, end_vertex = 715, k = 1000, vertex_num = 730, graph_df = seventhirty)
toc()

library(tictoc)
document()
penalty_test <- read.csv("inst/data-raw/penalty-test.csv")

shortest_path(start_vertex = 1, end_vertex = 6, vertex_num = 8, graph_df = penalty_test)

k_shortest_paths(start_vertex = 1, end_vertex = 6, k = 4, vertex_num = 8, graph_df = penalty_test)

# Testing constant penalty
penalty_test_2 <- penalty_test %>%
  mutate(weight = weight + 2)

shortest_path(start_vertex = 1, end_vertex = 6, vertex_num = 8, graph_df = penalty_test)
k_shortest_paths(start_vertex = 1, end_vertex = 6, k = 4, vertex_num = 8, graph_df = penalty_test)
k_shortest_paths(start_vertex = 1, end_vertex = 6, k = 4, vertex_num = 8, graph_df = penalty_test, edge_penalty = 2)
