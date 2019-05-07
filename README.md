
<!-- README.md is generated from README.Rmd. Please edit that file -->

# yenpathy

[![Travis build
status](https://travis-ci.org/ecohealthalliance/yenpathy.svg?branch=master)](https://travis-ci.org/ecohealthalliance/yenpathy)
[![Codecov test
coverage](https://codecov.io/gh/ecohealthalliance/yenpathy/branch/master/graph/badge.svg)](https://codecov.io/gh/ecohealthalliance/yenpathy?branch=master)

## Overview

yenpathy is an R package to quickly find k shortest paths through a
weighted graph. There are already comprehensive network analysis
packages in R, notably [igraph](http://igraph.org/r/) and its
tidyverse-compatible interface
[tidygraph](https://github.com/thomasp85/tidygraph), but these lack the
ability to find *k* shortest paths through a network. (iGraph can find
*all* shortest paths, but on very large graphs this is intractible.)

yenpathy provides the function `k_shortest_paths()`, which returns *k*
shortest paths between two nodes in a graph, specified as a data frame
containing a list of edges with start nodes, end nodes, and optional
weights.

## Installation

Install yenpathy from GitHub with
[devtools](https://github.com/hadley/devtools):

``` r
library(devtools)
install_github("ecohealthalliance/yenpathy")
```

## Usage

Pass `k_shortest_paths()` a data frame (`graph_df`) with rows
representing the edges of a graph. The first and second columns
represent the start and end nodes, and the optional third column
contains a numeric vector of edge weights. You must also provide a
`start_vertex` and `end_vertex`, which each specify a node as it is
referenced in `graph_df`. Nodes can be represented as integer or
character vectors.

``` r
library(yenpathy)

small_graph <- data.frame(
  start = c(1, 4, 5, 1, 1, 8, 1, 2, 7, 3),
  end = c(4, 5, 6, 6, 8, 6, 2, 7, 3, 6),
  weight = c(1, 1, 1, 5, 1.5, 2, 1, 0.5, 0.5, 0.5)
)

k_shortest_paths(small_graph, start_vertex = 1, end_vertex = 6)
#> [[1]]
#> [1] 1 2 7 3 6
```

The function will return a list containing up to `k` (by default 1)
vectors representing paths through the graph.

``` r
k_shortest_paths(small_graph,
                 start_vertex = 1, end_vertex = 6, k = 4)
#> [[1]]
#> [1] 1 2 7 3 6
#> 
#> [[2]]
#> [1] 1 4 5 6
#> 
#> [[3]]
#> [1] 1 8 6
#> 
#> [[4]]
#> [1] 1 6
```

You can also pass an `edge_penalty`, a number which is added to all of
the edge weights. This can be used to penalize paths consisting of more
edges.

``` r
k_shortest_paths(small_graph,
                 start_vertex = 1,
                 end_vertex = 6,
                 k = 4,
                 edge_penalty = 1)
#> [[1]]
#> [1] 1 8 6
#> 
#> [[2]]
#> [1] 1 6
#> 
#> [[3]]
#> [1] 1 4 5 6
#> 
#> [[4]]
#> [1] 1 2 7 3 6
```

## Implementation

The package wraps a C++ implementation of [Yen’s
algorithm](https://en.wikipedia.org/wiki/Yen%27s_algorithm). The
original C++ version is available on GitHub at
[yan-qi/k-shortest-paths-cpp-version](https://github.com/yan-qi/k-shortest-paths-cpp-version),
and was written by [Yan Qi](https://github.com/yan-qi). The version used
by yenpathy is modified to work with variables passed from R.

## Contributing

This project is released with a [Contributor Code of
Conduct](https://github.com/ecohealthalliance/yenpathy/blob/master/CONDUCT.md).
By participating in this project, you agree to abide by its terms.

Feel free to submit feedback, bug reports, or feature suggestions
[here](https://github.com/ecohealthalliance/yenpathy/issues), or to
submit fixes as pull requests.
