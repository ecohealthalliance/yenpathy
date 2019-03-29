#' Return k shortest paths through a weighted graph.
#'
#' This function constructs a graph in C++ and uses Yen's Algorithm to find
#' shortest paths through the graph, starting and ending at specified nodes.
#'
#' Your graph's nodes can be integers or characters. If they're character
#' vectors, the function creates an integer version behind the scenes, but gives
#' you back a list of character vectors paths.
#'
#' @param graph_df A data frame representing the graph's edges, with columns, in
#'   order, for start node, end node, and weight or cost.
#' @param start_vertex The number or name of the starting vertex.
#' @param end_vertex The number or name of the path's ending vertex.
#' @param k The maximum number of paths to find, default 1.
#' @param edge_penalty A constant to be added to each edge, if you wish to
#'   penalize routes with many edges.
#' @param verbose Be more verbose.
#'
#' @return A list of vectors representing paths through the network, ordered
#'   from shortest to longest.
#'
#' @examples
#' my_graph <- data.frame(source = c(1, 4, 5, 1, 1, 8, 1, 2, 7, 3),
#'                        sink = c(4, 5, 6, 6, 8, 6, 2, 7, 3, 6),
#'                        weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5))
#' k_shortest_paths(graph_df = my_graph, start_vertex = 1, end_vertex = 6, k = 4)
#' k_shortest_paths(graph_df = my_graph, start_vertex = 1, end_vertex = 6, k = 4, edge_penalty = 2)
#'
#' @export
#'
#' @import dplyr purrr
#' @importFrom magrittr %>% %<>%
k_shortest_paths <- function(graph_df, start_vertex, end_vertex, k = 1,
                             edge_penalty = 0,
                             verbose = getOption("yenpathy.verbose", interactive())) {
    # Check for missing values and throw errors, so we don't crash once we're in C++.
  NAs <- sapply(graph_df, function(x) sum(is.na(x)))
  if (NAs[1] + NAs[2] > 0) stop("NA values are present in node columns")
  if (NAs[3] > 0) warning("NA values are present in edge weights, and are omitted from the graph")

  nodes <- c(graph_df[[1]], graph_df[[2]]) %>%
    unique() %>%
    sort()

  if (ncol(graph_df) == 2) graph_df <- cbind(graph_df, 1)

  # If the graph we have received uses characters for its nodes, we convert them
  # to integers, using factor labels and levels to hash the original values of
  # the graph. We replace the character versions of arguments with integer
  # versions.
  if (class(nodes) == "character") {
    nodes_fact <- as.factor(nodes)
    nodes_num <- as.integer(nodes_fact)
    node_labels <- labels(nodes_fact)
    node_levels <- levels(nodes_fact)

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

  # If our original graph had character nodes, we replace our numeric nodes with
  # their original character names.
  if (class(nodes) == "character") {
    result %<>%
      map(~as.character(factor(.x, levels = node_labels, labels = node_levels)))
  }

  result
}
