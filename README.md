# yenpathy

Yenpathy is an R package to quickly find k shortest paths through a graph using a version of [Yen's algorithm](https://en.wikipedia.org/wiki/Yen%27s_algorithm).

The package is a wrapper for a slightly modified version of the C++ implementation in https://github.com/yan-qi/k-shortest-paths-cpp-version, by *[@yan-qi](https://github.com/yan-qi)*. (I didn't write anything other than the Rcpp and R functions to wrap the algorithm.)

The package is designed to be lightweight. There are already comprehensive solutions to working with graph data in R, including [igraph](http://igraph.org/r/) and its tidyverse-compatible interface [tidygraph](https://github.com/thomasp85/tidygraph). However, iGraph lacks a k-shortest-paths function — it can find the shortest path, and can find all simple paths, but on very large graphs the latter isn't reasonable to run.

Yenpathy requires a data frame with rows representing graph edges. The first and second columns should contain integers representing nodes, and the third column should contain a numeric vector of edge weights.

The two functions, `shortest_path()` and `k_shortest_paths()`, also accept an argument `edge_penalty`, a numeric which is added to all weights before the graph is passed to the C++ functions. This is so that a penalty can be added to routes which include many edges.

The functions return an integer vector and a list of integer vectors respectively, representing sequences of nodes through the network. In the case of `k_shortest_paths()`, the list is ordered by shortness. The calculated weight is not returned, as it can be quickly computed in R if need be; however, if the `verbose` option is enabled (which it is by default in interactive R sessions), the computed weight/cost of a route is printed as the algorithm runs.

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

shortest_path(small_graph,
              start_vertex = 1, end_vertex = 6)

k_shortest_paths(small_graph,
                 start_vertex = 1, end_vertex = 6, k = 10)

k_shortest_paths(small_graph,
                 start_vertex = 1, end_vertex = 6, k = 10, edge_penalty = 0)
```
