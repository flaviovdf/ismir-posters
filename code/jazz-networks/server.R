library(shiny)
library(networkD3)
library(reshape2)
library(readr)
library(dplyr, warn.conflicts = F)
source("../d3-networking.R")

ztoz <-read.delim("../../data/poster-jazz-trajs/ZtoZMatColToRow.dat",
                  stringsAsFactors = FALSE)
summaries <- read_delim("../../data/poster-jazz-trajs/SummaryMachineReadable.dat", 
                        delim = "\t")

prob_ztoa = create_probabilitiesdf(summaries)
nodes = make_nodesdf(ztoz)
links = make_linksdf(ztoz, nodes)

nodes[nodes$index %in% c(5, 13, 28),]$group = 2

##################
# Server logic   #
##################
shinyServer(function(input, output) {
  
  output$z_network <- renderForceNetwork({
    forceNetwork(Links = links, Nodes = nodes, Source = "source",
                 Target = "target", Value = "value", NodeID = "id", 
                 Group = "group", opacity = 0.8, zoom = TRUE)
  })
  
})
