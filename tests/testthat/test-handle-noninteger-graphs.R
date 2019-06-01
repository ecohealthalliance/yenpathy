context("handle noninteger graphs")
library(yenpathy)
library(purrr)
options(yenpathy.verbose = FALSE)

graph_int <- data.frame(
  source = c(6, 1, 8, 6, 6, 3, 6, 4, 5, 7),
  sink = c(1, 8, 2, 2, 3, 2, 4, 5, 7, 2),
  weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5)
)
start_int <- graph_int[[1]][1]
end_int <- graph_int[[2]][3]

graph_char <- data.frame(
  source = c("JFK", "ATL", "MKE", "JFK", "JFK", "CLT", "JFK", "EWR", "GSP", "LGA"),
  sink = c("ATL", "MKE", "AVL", "AVL", "CLT", "AVL", "EWR", "GSP", "LGA", "AVL"),
  weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5),
  stringsAsFactors = FALSE
)
start_char <- graph_char[[1]][1]
end_char <- graph_char[[2]][3]

test_that("character graphs return character paths", {
  paths <- k_shortest_paths(graph_char, start_char, end_char, k = 4)
  expect_equal(map_lgl(paths, inherits, "character"), rep(TRUE, 4))
})

test_that("equivalent results are found for integer and character graphs", {
  result_int <- k_shortest_paths(graph_int, start_int, end_int, k = 4, edge_penalty = 2)
  int_nodes <- c(graph_int$source, graph_int$sink)
  node_pos_int <- map_depth(result_int, 1, ~ match(.x, int_nodes))

  result_char <- k_shortest_paths(graph_char, start_char, end_char, k = 4, edge_penalty = 2)
  char_nodes <- c(graph_char$source, graph_char$sink)
  node_pos_char <- map_depth(result_char, 1, ~ match(.x, char_nodes))

  expect_equal(node_pos_char, node_pos_int)
})

test_that("NA values in node columns throw an error", {
  graph_na <- graph_int
  graph_na[1, 1] <- NA
  expect_error(k_shortest_paths(graph_na, start_int, end_int))

  graph_na <- graph_int
  graph_na[1, 2] <- NA
  expect_error(k_shortest_paths(graph_na, start_int, end_int))
})

test_that("NA values in weights gives a warning", {
  graph_na <- graph_int
  graph_na[1, 3] <- NA
  expect_warning(k_shortest_paths(graph_na, start_int, end_int))
})

test_that("Incorrect weight types throws an error", {
  graph_na <- graph_int
  graph_na[, 3] <- as.character(graph_na[, 3])
  expect_error(k_shortest_paths(graph_na, start_int, end_int))
})

test_that("factor representations of nodes throw an error", {
  graph_fct <- data.frame(
    source = c("JFK", "ATL", "MKE", "JFK", "JFK", "CLT", "JFK", "EWR", "GSP", "LGA"),
    sink = c("ATL", "MKE", "AVL", "AVL", "CLT", "AVL", "EWR", "GSP", "LGA", "AVL"),
    weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5),
    stringsAsFactors = TRUE
  )
  start_fct <- graph_fct[[1]][1]
  end_fct <- graph_fct[[2]][3]

  expect_error(k_shortest_paths(graph_fct, start_fct, end_fct))
})
