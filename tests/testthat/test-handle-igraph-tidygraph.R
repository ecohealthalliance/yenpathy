context("test igraph and tidygraph objects")
library(yenpathy)
library(igraph)
library(tidygraph)

options(yenpathy.verbose = FALSE)

x_df <- data.frame(
  source = c("JFK", "ATL", "MKE", "JFK", "JFK", "CLT", "JFK", "EWR", "GSP", "LGA"),
  sink = c("ATL", "MKE", "AVL", "AVL", "CLT", "AVL", "EWR", "GSP", "LGA", "AVL"),
  weight = c(1, 1, 1.5, 5, 1.5, 2.5, 1.5, 0.5, 0.5, 0.5),
  stringsAsFactors = FALSE
)
start_node <- x_df[[1]][1]
end_node <- x_df[[2]][3]

x_igraph <- graph_from_data_frame(x_df)
x_tidygraph <- as_tbl_graph(x_igraph)

paths_df <- k_shortest_paths(x_df, start_node, end_node)

test_that("igraph object returns correct paths", {
  paths_igraph <- k_shortest_paths(x_igraph, start_node, end_node)
  expect_length(paths_igraph, 1)
  expect_equal(paths_igraph[[1]], c("JFK", "EWR", "GSP", "LGA", "AVL"))
  expect_equal(paths_igraph, paths_df)
})

test_that("tidygraph object returns correct paths", {
  paths_tidygraph <- k_shortest_paths(x_tidygraph, start_node, end_node)
  expect_length(paths_tidygraph, 1)
  expect_equal(paths_tidygraph[[1]], c("JFK", "EWR", "GSP", "LGA", "AVL"))
  expect_equal(paths_tidygraph, paths_df)
})
