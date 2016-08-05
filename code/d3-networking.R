
make_nodesdf = function(ztoz_df){
  #' Creates df with nodes info for networkD3
  nodesdf = data_frame(id = ztoz_df$X)
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
