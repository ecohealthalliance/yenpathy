---
title: 'yenpathy: An R Package to Quickly Find K Shortest Paths Through a Weighted Graph'
tags:
  - R
  - graphs
  - graph algorithms
  - network analysis
  - k shortest paths
authors:
  - name: Toph Allen
    orcid: 0000-0003-4580-091X
    affiliation: 1
  - name: Noam Ross
    orcid: 0000-0002-2136-0000
    affiliation: 1
affiliations:
 - name: EcoHealth Alliance, New York, NY, USA
   index: 1
citation_author: Allen and Ross
date: 2019-09-02
year: 2019
bibliography: paper.bib
output: rticles::joss_article #requires noamross/rticles@joss
csl: apa.csl
journal: JOSS
---

Finding the shortest paths through a network is a task important to many problems,
from transportation routing to social network analysis.  **yenpathy** provides
a method to find the _k_ shortest paths through a network using Yen's Algorithm
[@Yen_1971], previously not available in the R Langauge [@R].  **yenpathy**
works with stand-alone edge lists or with objects from the **igraph** [@igraph]
and **tidygraph** [@tidygraph] packages.


