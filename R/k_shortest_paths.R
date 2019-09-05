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
#' @param from The number or name of the starting vertex.
#' @param to The number or name of the ending vertex.
#' @param k The maximum number of paths to find, default 1.
#' @param col_from,col_to,col_weights columns of the the start node, end node, and weight
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
#'                        weight = c(1, 1, 1.5, 5, 1.5, 2.5, 1.5, 0.5, 0.5, 0.5))
#' k_shortest_paths(graph_df = my_graph, from = 1, to = 6, k = 4)
#' k_shortest_paths(graph_df = my_graph, from = 1, to = 6, k = 4, edge_penalty = 2)
#'
#' @export
#'
k_shortest_paths <- function(graph_df, from, to, k = 1,
                             col_from = 1, col_to = 2, col_weights = "weight",
                             edge_penalty = 0,
                             verbose = getOption("yenpathy.verbose", FALSE)) {
  # Handle iGraph and tidygraph objects.
  if (inherits(graph_df, "igraph")) {
    if (!requireNamespace("igraph")) {
      stop("The igraph package is required to process this object")
    }
    graph_df <- igraph::as_data_frame(graph_df)
  }
  col_from <- col_number_to_name(col_from, graph_df)
  col_to <- col_number_to_name(col_to, graph_df)
  col_weights <- col_number_to_name(col_weights, graph_df)



  # Handle unweighted graphs with only source and sink columns.
  if (is.null(graph_df[[col_weights]])) graph_df[[col_weights]] <- 1

  # Check column types
  if (!inherits(graph_df[[col_weights]], c("numeric", "integer"))) {
    stop("Weight column must be numeric or integer")
  }

  # Refuse to handle graphs stored as factors
  if (any(vapply(graph_df[c(col_from, col_to)], is.factor, logical(1)))) {
    stop("Please use character or integer vectors for your node columns")
  }

  # Check for missing values and throw errors, so we don't crash once we're in C++.
  NAs <- vapply(graph_df, function(x) sum(is.na(x)), integer(1))
  if (NAs[col_from] + NAs[col_to] > 0) stop("NA values are present in node columns")
  if (NAs[col_weights] > 0) warning("NA values are present in edge weights; NA-weighted edges are omitted from the graph")

  nodes <- sort(unique(
    c(graph_df[[col_from]], graph_df[[col_to]])
  ))

  # If the graph we have received uses characters for its nodes, we convert them
  # to integers, using factor labels and levels to hash the original values of
  # the graph. We replace the character versions of arguments with integer
  # versions.
  if (class(nodes) == "character") {
    nodes_fact <- as.factor(nodes)
    node_labels <- labels(nodes_fact)
    node_levels <- levels(nodes_fact)

    graph_df[, col_from] <- as.numeric(factor(graph_df[, col_from], levels = node_levels))
    graph_df[, col_to] <- as.numeric(factor(graph_df[, col_to], levels = node_levels))

    from <- as.numeric(factor(from, levels = node_levels))
    to <- as.numeric(factor(to, levels = node_levels))
  }

  graph_df[, col_weights] <- graph_df[, col_weights]  + edge_penalty

  graph_df <- graph_df[, c(col_from, col_to, col_weights)]

  vertex_num <- length(unique(nodes))

  result <- .k_shortest_paths_Cpp(graph_df, from, to, k,
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
