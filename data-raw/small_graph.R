library(yenpathy)

options(yenpathy.verbose = FALSE)

small_graph <- data.frame(
  start = c(1, 4, 5, 1, 1, 8, 1, 2, 7, 3),
  end = c(4, 5, 6, 6, 8, 6, 2, 7, 3, 6),
  weight = c(1, 1, 1.5, 5, 1.5, 2, 1, 0.5, 0.5, 0.5)
)

shortest_path(small_graph,
              start_vertex = 1, end_vertex = 6)

k_shortest_paths(small_graph,
                 start_vertex = 1, end_vertex = 6, k = 10)

k_shortest_paths(small_graph,
                 start_vertex = 1, end_vertex = 6, k = 10, edge_penalty = 0)