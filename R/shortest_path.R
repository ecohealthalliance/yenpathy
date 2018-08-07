#' Return k shortest paths through a weighted graph.
#'
#' This function constructs a graph in C++ and uses Dijkstra's Algorithm to find shortest path through the graph, starting and ending at specified nodes.
#'
#' @param graph_df A data frame representing the graph's edges. The first column should be an integer of starting vertices; the second should be an integer of ending vertices, and the third should be a numeric representing the weight or cost of that edge.
#' @param start_vertex The number of the path's starting vertex.
#' @param end_vertex The number of the path's ending vertex.
#' @param edge_penalty A constant to be added to each edge, if you wish to penalize routes with many edges.
#' @param verbose Be more verbose.
#'
#' @return A numeric vector representing path through the network.
#'
#' @examples
#' my_graph <- data.frame(source = c(1, 4, 5, 1, 1, 8, 1, 2, 7, 3),
#'                        sink = c(4, 5, 6, 6, 8, 6, 2, 7, 3, 6),
#'                        weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5))
#' shortest_path(start_vertex = 1, end_vertex = 6, vertex_num = 8, graph_df = my_graph)
#' shortest_path(start_vertex = 1, end_vertex = 6, vertex_num = 8, graph_df = my_graph, edge_penalty = 2)
#'
#' @export
#'
#' @import dplyr
shortest_path <- function(graph_df, start_vertex, end_vertex,
                          edge_penalty = 0,
                          verbose = getOption("yenpathy.verbose",interactive())) {
  graph_df <- mutate_at(graph_df, 3, ~. + edge_penalty)
  vertex_num <- n_distinct(c(graph_df[, 1], graph_df[, 2]))
  .Call(`_yenpathy_shortest_path_Cpp`,
        graph_df, start_vertex, end_vertex,
        vertex_num, verbose)
}
