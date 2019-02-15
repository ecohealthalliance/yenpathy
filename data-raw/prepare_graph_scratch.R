load_all()
library(magrittr)
library(purrr)

graph_int.original <- data.frame(
  source = c(1, 4, 5, 1, 1, 8, 1, 2, 7, 3),
  sink = c(4, 5, 6, 6, 8, 6, 2, 7, 3, 6),
  weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5)
)
graph_int <- data.frame(
  source = c(6, 1, 8, 6, 6, 3, 6, 4, 5, 7),
  sink = c(1, 8, 2, 2, 3, 2, 4, 5, 7, 2),
  weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5)
)
result_int <- k_shortest_paths(graph_df = graph_int, start_vertex = 6, end_vertex = 2, k = 4, edge_penalty = 2)

graph_char <- data.frame(source = c("JFK", "ATL", "MKE", "JFK", "JFK", "CLT", "JFK", "EWR", "GSP", "LGA"),
                         sink = c("ATL", "MKE", "AVL", "AVL", "CLT", "AVL", "EWR", "GSP", "LGA", "AVL"),
                         weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5),
                         stringsAsFactors = FALSE)

graph_df <- graph_char

start_vertex <- graph_df[[1]][1]
end_vertex <- graph_df[[2]][3]
k <- 4
edge_penalty <- 2
verbose <- getOption("yenpathy.verbose",interactive())

nodes <- c(graph_df[[1]], graph_df[[2]]) %>%
  unique() %>%
  sort()

if (class(nodes) == "character") {
  nodes_fact <- as.factor(nodes)
  nodes_num <- as.integer(nodes_fact)
  node_labels <- labels(nodes_fact)
  node_levels <- levels(nodes_fact)

  # graph_df[[1]] <- as.numeric(factor(graph_df[[1]], levels = node_levels))
  # graph_df[[2]] <- as.numeric(factor(graph_df[[2]], levels = node_levels))

  graph_df %<>%
    mutate_at(1:2, ~ as.numeric(factor(., levels = node_levels)))

  start_vertex <- as.numeric(factor(start_vertex, levels = node_levels))
  end_vertex <- as.numeric(factor(end_vertex, levels = node_levels))
}

graph_df %<>% mutate_at(3, ~ . + edge_penalty)
vertex_num <- n_distinct(nodes)

result <- .Call(`_yenpathy_k_shortest_paths_Cpp`,
    graph_df, start_vertex, end_vertex, k,
    vertex_num, verbose)

if (class(nodes) == "character") {
  result %<>%
    map(factor, levels = labels(nodes_fact), labels = levels(nodes_fact)) %>%
    map(as.character)
}

result
