library(ggplot2)
source("d3-networking.R")

summaries <- read_delim("../data/poster-jazz-trajs/SummaryMachineReadable.dat", 
                        delim = "\t")
entropies = read_delim("../data/poster-jazz-trajs/EntropyZ.dat", 
                       col_names = F,
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
    coord_flip() %>% 
    return()
}

plot_entropy_poz(prob_ztoa, 0)
plot_entropy_poz(prob_ztoa, 10)
plot_entropy_poz(prob_ztoa, 27)

# POUCO ENTRÓPICOS

plot_entropy_poz(prob_ztoa, 18)
plot_entropy_poz(prob_ztoa, 20)
plot_entropy_poz(prob_ztoa, 1)
plot_entropy_poz(prob_ztoa, 26)
plot_entropy_poz(prob_ztoa, 5)
plot_entropy_poz(prob_ztoa, 3)


## OBJETOS

prob_ztoa %>% 
  filter(grepl("TopObj", type)) %>% 
  ggplot(aes(x = reorder(node, probability), y = probability)) + 
  facet_wrap(~topic, scales = "free_x") + 
  geom_bar(stat = "identity")


## TABELAS

library(formattable)
prob_ztoa %>% 
  filter(topic == 0, grepl("TopObj", type)) %>% 
  select(node, probability) %>% 
  formattable(list(area(col = probability) ~ normalize_bar("pink", 0.25)))
