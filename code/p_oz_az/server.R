library(shiny)
library(formattable)
library(readr)
library(dplyr)
source("d3-networking.R")

summaries <- read_delim("SummaryMachineReadableNew.dat",
                        delim = "\t")
names(summaries)[1] = "topic"
summaries$topic = as.numeric(substr(summaries$topic, 3, 5))

entropies = read_delim("EntropyAZ.dat",
                       col_names = T,
                       delim = "\t")
names(entropies) = c("environment", "entropy")
entropies$topic = 0:29

prob_ztoa = create_probabilitiesdf(summaries)
prob_ztoa = left_join(prob_ztoa, select(entropies, topic, entropy))
prob_ztoa$topic = reorder(as.factor(prob_ztoa$topic), -prob_ztoa$entropy)

entropies = entropies %>% arrange(-entropy)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  updateSelectizeInput(session, 'topic', choices = entropies$topic, server = TRUE)
  
  output$environmentTable <- renderFormattable({
    probs = prob_ztoa %>% 
      filter(topic == input$topic, grepl("TopObj", type)) %>% 
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
      filter(topic == input$topic, grepl("User", type)) %>% 
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
      filter(topic == input$topic)
    paste("Entropy: ", value$entropy)
  })
})
