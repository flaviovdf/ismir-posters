library(shiny)
library(networkD3)
library(readr)
library(dplyr, warn.conflicts = F)
source("environments-lib.R")
source("d3-networking.R")

# TODO : highlight collaborators who "moved"

########
# Init #
########
ztoz <-read.delim("ZtoZMatColToRow.dat",
                  stringsAsFactors = FALSE)
prob_ztoa = read_delim("SummaryMachineReadableNew.dat", delim = "\t") %>% 
  create_pztoa()

nodes = make_nodesdf(ztoz)
links = make_linksdf(ztoz, nodes, 1/20)

#nodes[nodes$index %in% c(5, 13, 28),]$group = 2

nodes = left_join(nodes, get_environment_labels(), 
                  by = c("index" = "topic"))
nodes$label = sprintf("%s (%s)", nodes$label, nodes$id)

##################
# Server logic   #
##################
shinyServer(function(input, output) {
  
  output$z_network <- renderForceNetwork({
    fn = forceNetwork(
      Links = links,
      Nodes = nodes,
      Source = "source",
      Target = "target",
      Value = "value",
      NodeID = "label",
      Group = "group",
      opacity = 0.8,
      fontFamily = "sans-serif",
      fontSize = 21,
      zoom = TRUE)
    fn
  })
})
