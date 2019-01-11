options(stringsAsFactors = FALSE)

load_all()

graph_int <- data.frame(source = c(1, 4, 5, 1, 1, 8, 1, 2, 7, 3),
                      sink = c(4, 5, 6, 6, 8, 6, 2, 7, 3, 6),
                      weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5))
k_shortest_paths(graph_df = graph_int, start_vertex = 1, end_vertex = 6, k = 4)
k_shortest_paths(graph_df = graph_int, start_vertex = 1, end_vertex = 6, k = 4, edge_penalty = 2)

graph_char <- data.frame(source = c("JFK", "ATL", "MKE", "JFK", "JFK", "CLT", "JFK", "EWR", "GSP", "LGA"),
                         sink = c("ATL", "MKE", "AVL", "AVL", "CLT", "AVL", "EWR", "GSP", "LGA", "AVL"),
                         weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5))


my_graph = graph_char
all_verts <- c(my_graph[[1]], my_graph[[2]]) %>%
  unique() %>%
  sort()
verts_factor <- as.factor(all_verts)
vert_levels <- levels(verts_factor)

start_vert <- verts_factor[verts_factor == "JFK"] %>% as.numeric
end_vert <- verts_factor[verts_factor == "AVL"] %>% as.numeric
