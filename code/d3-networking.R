
make_nodesdf = function(ztoz_df){
  #' Creates df with nodes info for networkD3
  nodesdf = data_frame(id = ztoz$X)
  nodesdf$index = 0:(NROW(nodesdf)-1)
  nodesdf$group = 1
  return(nodesdf)
}

make_linksdf = function(ztoz, nodesdf, threshold = 1/40){
  #' Creates a data frame with links based on node index as 
  #' required by networkD3
  library(dplyr, warn.conflicts = F)
  library(tidyr)
  zzl = gather(ztoz, X, prob) 
  names(zzl) = c("from", "to", "prob")
  
  zzlf = zzl %>% 
    filter(prob > threshold, from != to) %>% 
    mutate(from = as.character(from), to = as.character(to))
  
  zzlf = left_join(zzlf, nodesdf, by = c("from" = "id")) %>% 
    left_join(nodesdf, by = c("to" = "id"))
  links = zzlf %>% 
    select(index.x, index.y, prob) %>% 
    rename(source = index.x, target = index.y, value = prob)
  return(links)
}

create_probabilitiesdf = function(summariesdf,
                                  label_artists = "artist",
                                  label_user = "collaborator") {
  library(reshape2)
  library(dplyr, warn.conflicts = F)
  u = summaries %>% 
    melt(id.vars = "topic", measure.vars = paste0("TopUser_", 0:9), 
         variable.name = "type", value.name = "node")
  o = summaries %>% 
    melt(id.vars = "topic", measure.vars = paste0("TopObj_", 0:9), 
         variable.name = "type", value.name = "node")
  p_zu = summaries %>% 
    melt(id.vars = "topic", measure.vars = paste0("Pzu_", 0:9), 
         variable.name = "where", value.name = "probability")
  p_zo = summaries %>% 
    melt(id.vars = "topic", measure.vars = paste0("Poz_", 0:9), 
         variable.name = "where", value.name = "probability")
  answer = rbind(u, o)
  answer$probability = c(p_zu$probability, p_zo$probability)
  # answer$connection = 
  #   x = answer$type %>% 
  #   as.character() %>% 
  #   strsplit("_", fixed = TRUE)
  return(answer)
}
