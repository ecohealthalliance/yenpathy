context("return correct paths")
library(yenpathy)
options(yenpathy.verbose = FALSE)

unweighted_graph <- data.frame(
  source = c(6, 1, 8, 6, 6, 3, 6, 4, 5, 7),
  sink = c(1, 8, 2, 2, 3, 2, 4, 5, 7, 2)
)

weighted_graph <- data.frame(
  source = c(6, 1, 8, 6, 6, 3, 6, 4, 5, 7),
  sink = c(1, 8, 2, 2, 3, 2, 4, 5, 7, 2),
  weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5)
)

start_node <- unweighted_graph[[1]][1]
end_node <- unweighted_graph[[2]][3]

test_that("shortest unweighted path is found", {
  paths <- k_shortest_paths(unweighted_graph, start_node, end_node)
  expect_length(paths, 1)
  expect_equal(paths[[1]], c(6, 2))
})

test_that("shortest weighted path is found", {
  paths <- k_shortest_paths(weighted_graph, start_node, end_node)
  expect_length(paths, 1)
  expect_equal(paths[[1]], c(6, 4, 5, 7, 2))
})

test_that("correct number of paths are returned", {
  paths <- map(1:5, ~k_shortest_paths(weighted_graph, start_node, end_node, .x))
  expect_equal(map_int(paths, length), c(1, 2, 3, 4, 4))
})

test_that("edge penalty correctly changes returned paths", {
  paths <- k_shortest_paths(weighted_graph, start_node, end_node, edge_penalty = 1)
  expect_equal(paths[[1]], c(6, 3, 2))
})

test_that("disconnected graphs returns an empty list", {
  disconnected_graph <- data.frame(
    source = c(6, 1, 8, 6, 6, 3, 6, 4, 5, 7, 9),
    sink = c(1, 8, 2, 2, 3, 2, 4, 5, 7, 2, 10),
    weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5, 1)
  )

  expect_equal(k_shortest_paths(disconnected_graph, 1, 10), list())
})
