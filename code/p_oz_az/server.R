library(shiny)
library(formattable)
library(readr)
library(dplyr)
library(wordcloud)
library(ggplot2)
library(futile.logger)
source("environments-lib.R")
source("d3-networking.R")

# ----------------------------------------
# READ & CLEAN
# ----------------------------------------
flog.info("Reading summaries")
prob_ztoa = read_delim("SummaryMachineReadableNew.dat", delim = "\t") %>% 
  create_pztoa()

flog.info("Reading entropies")
entropies = read_delim("EntropyAZ.dat",
                       col_names = T,
                       delim = "\t") %>% 
  create_entropy_az()

prob_ztoa = left_join(prob_ztoa, select(entropies, topic, entropy))
entropies = entropies %>% arrange(-entropy)

topic_tags = read_csv("tag-frequency-for-most-probable.csv")
artist_activity = read_csv("most-probable-artists-activity.csv")

topic_tags = topic_tags %>% 
  mutate(tag = ifelse(tag == "Contemporary Jazz", "Contempor.", tag)) %>% 
  mutate(tag = ifelse(tag == "Avant-garde Jazz", "Avant-garde", tag)) %>% 
  mutate(tag = ifelse(tag == "Free Improvisation", "Free Improv", tag))

collaborators = prob_ztoa %>% 
  filter(grepl("User", type)) %>% 
  arrange(-probability)
instruments = read_csv("most-common-collaborator-instrument.csv")
collaborators = collaborators %>% 
  left_join(instruments, by = c("node" = "collaborator"))

# NETWORK STUFF
ztoz <-read.delim("ZtoZMatColToRow.dat",
                  stringsAsFactors = FALSE)
nodes = make_nodesdf(ztoz)
links = make_linksdf(ztoz, nodes, 1/30)

nodes = left_join(nodes, get_environment_labels(), 
                  by = c("index" = "topic"))
nodes$label = sprintf("%s (%s)", nodes$label, nodes$id)


# ----------------------------------------
# SERVER
# ----------------------------------------
shinyServer(function(input, output, session) {
  current_topic = reactive ({
    input$topic
  })
  
  output$environmentTable <- renderFormattable({
    probs = prob_ztoa %>% 
      filter(topic == current_topic(), grepl("TopObj", type)) %>% 
      mutate(probability = round(probability*1e3)/1e3)  %>% 
      select(artist = node, `probability(artist | environment)` = probability)
    max_prob = max(probs$`probability(artist | environment)`)
    min_prob = min(probs$`probability(artist | environment)`)
    probs %>% 
      formattable(
        list(
          area(col = `probability(artist | environment)`) ~ normalize_bar("pink", min = min_prob, max = max_prob / .25)
        )
      )
  })

  output$collaboratorList <- renderText({
    c = collaborators %>% 
      filter(topic == current_topic()) 
    HTML(
      paste(sprintf("%s (%s)", 
                    c$node, 
                    c$collaboration),
            collapse = "<br/> "
      )
    )
  })
  
  output$entropy = renderText({
    value = entropies %>% 
      filter(topic == current_topic())
    sprintf("Entropy: %.2f", value$entropy)
  })
  
  output$tags = renderPlot({
    v = topic_tags %>% 
      filter(topic == current_topic()) 
    wordcloud(v$tag, sqrt(v$importance*1e5), 
              scale=c(2,.25),
              min.freq = 10,
              random.order = FALSE,
              max.words = 5,
              rot.per = 0,
              colors=brewer.pal(6, "OrRd")[3:6])
  })
  
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
      fontSize = 16,
      zoom = TRUE)
    fn
  })
})
