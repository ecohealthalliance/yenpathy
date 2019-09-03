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
#'   order, for start node, end node, and weight or cost. May also be an iGraph
#'   or tidygraph object.
#' @param start_vertex The number or name of the starting vertex.
#' @param end_vertex The number or name of the path's ending vertex.
#' @param k The maximum number of paths to find, default 1.
#' @param from,to,weights columns of the the start node, end node, and weight
#'   of edges in `graph_df`. May be integer or character.
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
k_shortest_paths <- function(graph_df, start_vertex, end_vertex, k = 1,
                             from = 1, to = 2, weights = "weight",
                             edge_penalty = 0,
                             verbose = getOption("yenpathy.verbose", FALSE)) {
  # Handle iGraph and tidygraph objects.
  if (inherits(graph_df, "igraph")) {
    if (!requireNamespace("igraph")) {
      stop("The igraph package is required to process this object")
    }
    graph_df <- igraph::as_data_frame(graph_df)
  }
  from <- col_number_to_name(from, graph_df)
  to <- col_number_to_name(to, graph_df)
  weights <- col_number_to_name(weights, graph_df)



  # Handle unweighted graphs with only source and sink columns.
  if (is.null(graph_df[[weights]])) graph_df[[weights]] <- 1

  # Check column types
  if (!inherits(graph_df[[weights]], c("numeric", "integer"))) {
    stop("Weight column must be numeric or integer")
  }

  # Refuse to handle graphs stored as factors
  if (any(vapply(graph_df[c(from, to)], is.factor, logical(1)))) {
    stop("Please use character or integer vectors for your node columns")
  }

  # Check for missing values and throw errors, so we don't crash once we're in C++.
  NAs <- vapply(graph_df, function(x) sum(is.na(x)), integer(1))
  if (NAs[from] + NAs[to] > 0) stop("NA values are present in node columns")
  if (NAs[weights] > 0) warning("NA values are present in edge weights, and are omitted from the graph")

  nodes <- sort(unique(
    c(graph_df[[from]], graph_df[[to]])
  ))

  # If the graph we have received uses characters for its nodes, we convert them
  # to integers, using factor labels and levels to hash the original values of
  # the graph. We replace the character versions of arguments with integer
  # versions.
  if (class(nodes) == "character") {
    nodes_fact <- as.factor(nodes)
    node_labels <- labels(nodes_fact)
    node_levels <- levels(nodes_fact)

    graph_df[, from] <- as.numeric(factor(graph_df[, from], levels = node_levels))
    graph_df[, to] <- as.numeric(factor(graph_df[, to], levels = node_levels))

    start_vertex <- as.numeric(factor(start_vertex, levels = node_levels))
    end_vertex <- as.numeric(factor(end_vertex, levels = node_levels))
  }

  graph_df[, weights] <- graph_df[, weights]  + edge_penalty

  graph_df <- graph_df[, c(from, to, weights)]

  vertex_num <- length(unique(nodes))

  result <- .k_shortest_paths_Cpp(graph_df, start_vertex, end_vertex, k,
                                  vertex_num, verbose)

  # If our original graph had character nodes, we replace our numeric nodes with
  # their original character names.
  if (class(nodes) == "character") {
    result <- lapply(result, function(.x) {
      as.character(factor(.x, levels = node_labels, labels = node_levels))
    })
  }

  result
}

col_number_to_name <- function(x, df) {
  if (is.numeric(x)) {
    return(names(df)[x])
  } else if (is.character(x)) {
    return(x)
  } else {
    stop("Column specification must be integer or character")
  }
}
