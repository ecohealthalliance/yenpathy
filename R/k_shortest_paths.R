#' Return k shortest paths through a weighted graph.
#'
#' This function constructs a graph in C++ and uses Yen's Algorithm to find shortest paths through the graph, starting and ending at specified nodes.
#'
#' @param graph_df A data frame representing the graph's edges. The first column should be an integer of starting vertices; the second should be an integer of ending vertices, and the third should be a numeric representing the weight or cost of that edge.
#' @param start_vertex The number of the path's starting vertex.
#' @param end_vertex The number of the path's ending vertex.
#' @param k The maximum number of paths to find, default 1.
#' @param edge_penalty A constant to be added to each edge, if you wish to penalize routes with many edges.
#' @param verbose Be more verbose.
#'
#' @return A list of numeric vectors representing paths through the network, ordered from shortest to longest.
#'
#' @examples
#' my_graph <- data.frame(source = c(1, 4, 5, 1, 1, 8, 1, 2, 7, 3),
#'                        sink = c(4, 5, 6, 6, 8, 6, 2, 7, 3, 6),
#'                        weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5))
#' k_shortest_paths(start_vertex = 1, end_vertex = 6, k = 4, vertex_num = 8, graph_df = my_graph)
#' k_shortest_paths(start_vertex = 1, end_vertex = 6, k = 4, vertex_num = 8, graph_df = my_graph, edge_penalty = 2)
#'
#' @export
#'
#' @import dplyr
k_shortest_paths <- function(graph_df, start_vertex, end_vertex, k = 1,
                             edge_penalty = 0,
                             verbose = getOption("yenpathy.verbose",interactive())) {
  graph_df <- mutate_at(graph_df, 3, ~. + edge_penalty)
  vertex_num <- n_distinct(c(graph_df[, 1], graph_df[, 2]))
  .Call(`_yenpathy_k_shortest_paths_Cpp`,
        graph_df, start_vertex, end_vertex, k,
        vertex_num, verbose)
}
