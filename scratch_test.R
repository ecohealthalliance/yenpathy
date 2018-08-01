n_verts <- 6

graph <- data.frame(starts = c(0, 1, 1, 4, 4, 4, 4, 0, 1, 2, 3),
                    ends = c(1, 3, 2, 0, 1, 2, 3, 5, 5, 5, 5),
                    weights = c(1, 1, 1, 2, 2, 1, 1, 1, 2, 2, 1))

shortest_path(3, 4, n_verts, graph)