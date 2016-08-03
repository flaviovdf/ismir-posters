library(ggplot2)
library(readr)
library(reshape2)
library(dplyr, warn.conflicts = F)
source("d3-networking.R")
theme_set(theme_light())

## READ / CLEAN
entropies = read_delim("../data/poster-jazz-trajs/EntropyInEnvTop10.dat", 
                       col_names = T,
                       delim = "\t")
names(entropies)[1] = c("topic")
entropies$topic = as.numeric(substr(entropies$topic, 3, 5))
el1 = entropies %>% 
  melt(id.vars = "topic", measure.vars = paste0("name_top_", 0:9), 
       variable.name = "type", value.name = "node") %>% 
  select(-type)
el2 = entropies %>% 
  melt(id.vars = "topic", measure.vars = paste0("val_top_", 0:9), 
       variable.name = "type", value.name = "entropy") %>% 
  select(-type)
entropies = left_join(el1, el2)

## SEE 

summary(entropies)

entropies %>% 
  arrange(-entropy) %>% 
  slice(c(1:4, (n()-4):n()))

## USE

plot_entropy = function(data, indexes, label){
  data %>% 
    arrange(-entropy) %>% 
    # slice(c(1:4, (n()-4):n())) %>% 
    slice(indexes) %>% 
    mutate(class = label) %>% 
    ggplot(aes(x = reorder(node, entropy), y = entropy)) + 
    geom_point(size = 5, colour = "darkorange") +  
    facet_grid(class ~ .) + 
    ylim(0, 10) + 
    labs(x = "Artist", y = "Entropy") + 
    coord_flip()
}

entropyplot1 = entropies %>% plot_entropy(1:4, "top-4")
entropyplot1
pdf("top-entropy-As.pdf", height = 3, width = 6)
entropyplot1
dev.off()

num_artists = NROW(entropies)
entropyplot2 = entropies %>% plot_entropy((num_artists-3):num_artists, "bottom-4")
entropyplot2
pdf("bottom-entropy-As.pdf", height = 3, width = 6)
entropyplot2
dev.off()
