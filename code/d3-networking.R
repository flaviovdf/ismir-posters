library(networkD3)
library(tidyr)
library(dplyr, warn.conflicts = F)

create_nodesdf = function(ztoz_df){
  #' Creates df with nodes info for networkD3
  nodesdf = data_frame(id = ztoz$X)
  nodesdf$index = 0:(NROW(nodesdf)-1)
  nodesdf$group = 1
  return(nodesdf)
}

create_linksdf = function(ztoz, nodes){
  #' Creates a data frame with links based on node index as 
  #' required by networkD3
  zzl = gather(ztoz, X, prob) 
  names(zzl) = c("from", "to", "prob")
  
  zzlf = zzl %>% 
    filter(prob > 1 / 40, from != to) %>% 
    mutate(from = as.character(from), to = as.character(to))
  
  zzlf = left_join(zzlf, nodes, by = c("from" = "id")) %>% 
    left_join(nodes, by = c("to" = "id"))
  links = zzlf %>% 
    select(index.x, index.y, prob) %>% 
    rename(source = index.x, target = index.y, value = prob)
  return(links)
}

ztoz <-read.delim("../data/poster-jazz-trajs/ZtoZMatColToRow.dat",
                  stringsAsFactors = FALSE)
nodes = create_nodesdf(ztoz)
ztozl = create_linksdf(ztoz, nodes)

forceNetwork(Links = links, Nodes = nodes, Source = "source",
             Target = "target", Value = "value", NodeID = "id", 
             Group = "group", opacity = 0.8, zoom = TRUE)