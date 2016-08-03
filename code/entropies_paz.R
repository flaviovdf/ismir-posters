library(ggplot2)
source("d3-networking.R")

summaries <- read_delim("../data/poster-jazz-trajs/SummaryMachineReadableNew.dat",
                        delim = "\t")
names(summaries)[1] = "topic"
summaries$topic = as.numeric(substr(summaries$topic, 3, 5))

entropies = read_delim("../data/poster-jazz-trajs/EntropyAZ.dat",
                       col_names = T,
                       delim = "\t")
names(entropies) = c("environment", "entropy")
entropies$topic = 0:29

prob_ztoa = create_probabilitiesdf(summaries)
prob_ztoa = left_join(prob_ztoa, select(entropies, topic, entropy))
prob_ztoa$topic = reorder(as.factor(prob_ztoa$topic), -prob_ztoa$entropy)

# MUITO ENTRÓPICOS

arrange(entropies, -entropy) %>% head()
arrange(entropies, -entropy) %>% tail()

prob_ztoa %>% 
  filter(grepl("TopObj", type)) %>% 
  ggplot(aes(x = reorder(node, probability), y = probability)) + 
  facet_wrap(~ topic, scales = "free_x") + 
  geom_bar(stat = "identity")

# individualmente

plot_entropy_poz = function(data, topic_index){
  data %>% 
    filter(topic == topic_index, grepl("TopObj", type)) %>% 
    ggplot(aes(x = reorder(node, probability), y = probability)) + 
    facet_grid(topic ~ ., scales = "free_x") + 
    geom_bar(stat = "identity") +
    ylim(0, 0.2) + 
    xlab("Artist") + 
    coord_flip() %>% 
    return()
}

savePlot = function(plot, filename){
  pdf(filename, width = 6, height = 4)
  print(plot)
  dev.off()
}

# Most entropic is obscure
# plot_entropy_poz(prob_ztoa, 13)
# Good examples:
p1 = plot_entropy_poz(prob_ztoa, 5)
savePlot(p1, "entropic-1.pdf")
p2 = plot_entropy_poz(prob_ztoa, 3)
savePlot(p2, "entropic-2.pdf")

# least entropic:
#plot_entropy_poz(prob_ztoa, 6)
p4 = plot_entropy_poz(prob_ztoa, 14)
savePlot(p4, "notentropic-1.pdf")
p3 = plot_entropy_poz(prob_ztoa, 7)
savePlot(p3, "notentropic-2.pdf")
#plot_entropy_poz(prob_ztoa, 21)

# prob_ztoa %>% 
#   filter(grepl("TopObj", type)) %>% 
#   ggplot(aes(x = reorder(node, probability), y = probability)) + 
#   facet_wrap(~topic, scales = "free_x") + 
#   geom_bar(stat = "identity")
