load_all()

graph_int <- data.frame(
  source = c(6, 1, 8, 6, 6, 3, 6, 4, 5, 7),
  sink = c(1, 8, 2, 2, 3, 2, 4, 5, 7, 2),
  weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5)
)

graph_char <- data.frame(source = c("JFK", "ATL", "MKE", "JFK", "JFK", "CLT", "JFK", "EWR", "GSP", "LGA"),
                         sink = c("ATL", "MKE", "AVL", "AVL", "CLT", "AVL", "EWR", "GSP", "LGA", "AVL"),
                         weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5),
                         stringsAsFactors = FALSE)

start_int <- graph_int[[1]][1]
end_int <- graph_int[[2]][3]
result_int <- k_shortest_paths(graph_int, start_int, end_int, k = 4, edge_penalty = 2)

start_char <- graph_char[[1]][1]
end_char <- graph_char[[2]][3]
result_char <- k_shortest_paths(graph_char, start_char, end_char, k = 4, edge_penalty = 2)
