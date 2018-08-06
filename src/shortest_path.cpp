/************************************************************************/
/* $Id: MainP.cpp 65 2010-09-08 06:48:36Z yan.qi.asu $                                                                 */
/************************************************************************/

#include <limits>
#include <set>
#include <map>
#include <queue>
#include <string>
#include <vector>
#include <fstream>
#include <iostream>
#include <algorithm>
#include "GraphElements.h"
#include "Graph.h"
#include "DijkstraShortestPathAlg.h"
#include "YenTopKShortestPathsAlg.h"
#include <Rcpp.h>

// [[Rcpp::plugins("cpp11")]]

using namespace std;


// Roxygen comments go here
// [[Rcpp::export(name = ".shortest_path_Cpp")]]
Rcpp::CharacterVector shortest_path_Cpp(Rcpp::IntegerVector start_vertex,
                                    Rcpp::IntegerVector end_vertex,
                                    Rcpp::IntegerVector vertex_num,
                                    Rcpp::DataFrame graph_df)
{
	int start_vertex_ = Rcpp::as<int>(start_vertex);
	int end_vertex_ = Rcpp::as<int>(end_vertex);

	// Printing input
	Rcpp::Rcout << "Route Start:" << start_vertex << std::endl;
	Rcpp::Rcout << "Route End: " << end_vertex << std::endl;

	Graph* my_graph = new Graph(vertex_num, graph_df);
	DijkstraShortestPathAlg shortest_path_alg(my_graph);
	BasePath* result = shortest_path_alg.get_shortest_path(my_graph->get_vertex(start_vertex_),
	                                                      my_graph->get_vertex(end_vertex_));


	// Printing the result in various ways
	result->PrintOut(Rcpp::Rcout);
	Rcpp::Rcout << "Shortest Path: " << result->PathString() << std::endl;

	return(Rcpp::wrap(result->PathString()));
}

