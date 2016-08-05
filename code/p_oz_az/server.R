library(shiny)
library(formattable)
library(readr)
library(dplyr)
library(ggplot2)
library(futile.logger)
source("environments-lib.R")

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
      select(artist = node, `probability(artist | environment)` = probability)
    max_prob = max(probs$`probability(artist | environment)`)
    min_prob = min(probs$`probability(artist | environment)`)
    probs %>% 
      formattable(list(
        area(col = `probability(artist | environment)`) ~ normalize_bar("pink", min = min_prob, max = max_prob / .25)
      ))
  })

  output$collaboratorTable <- renderFormattable({
    probs = prob_ztoa %>% 
      filter(topic == current_topic(), grepl("User", type)) %>% 
      select(collaborator = node, `probability(environment | collaborator)` = probability) 
    max_prob = max(probs$`probability(environment | collaborator)`)
    min_prob = min(probs$`probability(environment | collaborator)`)
    probs %>% 
      formattable(list(
        area(col = `probability(environment | collaborator)`) ~ normalize_bar("lightgreen", min = min_prob, max = max_prob)
      ))
  })
  
  output$entropy = renderText({
    value = entropies %>% 
      filter(topic == current_topic())
    sprintf("Entropy: %.2f", value$entropy)
  })
  
  output$tags = renderPlot({
    topic_tags %>% 
      filter(topic == current_topic()) %>%
      ggplot(aes(x = reorder(tag, Freq), y = Freq)) + 
      geom_bar(stat = "identity") + 
      coord_flip()
  })
})
