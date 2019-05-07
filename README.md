# yenpathy

[![Travis build status](https://travis-ci.org/ecohealthalliance/yenpathy.svg?branch=master)](https://travis-ci.org/ecohealthalliance/yenpathy)
[![Codecov test coverage](https://codecov.io/gh/ecohealthalliance/yenpathy/branch/master/graph/badge.svg)](https://codecov.io/gh/ecohealthalliance/yenpathy?branch=master)

Yenpathy is an R package to quickly find k shortest paths through a graph using a version of [Yen's algorithm](https://en.wikipedia.org/wiki/Yen%27s_algorithm).

The package is a wrapper for a slightly modified version of the C++ implementation in https://github.com/yan-qi/k-shortest-paths-cpp-version, by [@yan-qi](https://github.com/yan-qi). (I didn't write anything other than the Rcpp and R functions to wrap the algorithm.)

The package is designed to be lightweight. There are already comprehensive solutions to working with graph data in R, including [igraph](http://igraph.org/r/) and its tidyverse-compatible interface [tidygraph](https://github.com/thomasp85/tidygraph). However, iGraph lacks a k-shortest-paths function — it can find the shortest path, and can find all simple paths, but on very large graphs the latter isn't reasonable to run. As such, Yenpathy contains one user-facing function, `k_shortest_paths()`, to find — you guessed it — k shortest paths between two specified nodes in a graph.

The function `k_shortest_paths()` requires a data frame with rows representing graph edges. The first and second columns should be integer or character vectors representing nodes, and the third column should contain a numeric vector of edge weights. You also need to provide a starting and ending node using the same names as the data frame. The function will find one path unless you pass it an argument `k` specifying the maximum number of paths you want. It also accepts an argument `edge_penalty`, a number which is added uniformly to all edge weights before the graph is passed to the C++ functions. This can be used to penalize routes which use use many edges.

The function returns a list of integer or character vectors, matching the names of your initial data frame, representing sequences of nodes through the network. The list is ordered from smallest to largest weight, after adding any `edge_penalty`. The weight, penalized or otherwise, is not returned. However, if the `verbose` option is enabled (which it is by default in interactive R sessions), the computed weight/cost of a route will be printed as the algorithm runs.

Here's a brief example of how it works:

```r
install_github("ecohealthalliance/yenpathy")

library(yenpathy)

options(yenpathy.verbose = FALSE)

small_graph <- data.frame(
  start = c(1, 4, 5, 1, 1, 8, 1, 2, 7, 3),
  end = c(4, 5, 6, 6, 8, 6, 2, 7, 3, 6),
  weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5)
)

k_shortest_paths(small_graph,
                 start_vertex = 1, end_vertex = 6)

# [1] 1 2 7 3 6

k_shortest_paths(small_graph,
                 start_vertex = 1, end_vertex = 6, k = 10)

# [[1]]
# [1] 1 2 7 3 6
# 
# [[2]]
# [1] 1 4 5 6
# 
# [[3]]
# [1] 1 8 6
# 
# [[4]]
# [1] 1 6

k_shortest_paths(small_graph,
                 start_vertex = 1, end_vertex = 6, k = 10, edge_penalty = 0)

# [[1]]
# [1] 1 2 7 3 6
# 
# [[2]]
# [1] 1 4 5 6
# 
# [[3]]
# [1] 1 8 6
# 
# [[4]]
# [1] 1 6
```

## Contributing

This project is released with a [Contributor Code of Conduct](https://github.com/ecohealthalliance/yenpathy/blob/master/CONDUCT.md). By participating in this project, you agree to abide by its terms.

Feel free to submit feedback, bug reports, or feature suggestions [here](https://github.com/ecohealthalliance/yenpathy/issues), or to submit fixes as pull requests.
