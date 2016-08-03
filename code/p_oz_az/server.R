library(shiny)
library(formattable)
source("d3-networking.R")

summaries <- read_delim("SummaryMachineReadable.dat", 
                        delim = "\t")
entropies = read_delim("EntropyZ.dat",
                       col_names = F,
                       delim = "\t")
names(entropies) = c("environment", "entropy")
entropies$topic = 0:29

prob_ztoa = create_probabilitiesdf(summaries)
#prob_ztoa$topic = as.factor(prob_ztoa$topic)
prob_ztoa = left_join(prob_ztoa, select(entropies, topic, entropy))
prob_ztoa$topic = reorder(as.factor(prob_ztoa$topic), -prob_ztoa$entropy)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  updateSelectizeInput(session, 'topic', choices = prob_ztoa$topic, server = TRUE)
  
  output$environmentTable <- renderFormattable({
    prob_ztoa %>% 
      filter(topic == input$topic, grepl("TopObj", type)) %>% 
      select(artist = node, `probability(artist | environment)` = probability) %>% 
      formattable(list(area(col = `probability(artist | environment)`) ~ normalize_bar("pink", 0.25)))
  })

  output$collaboratorTable <- renderFormattable({
    prob_ztoa %>% 
      filter(topic == input$topic, grepl("User", type)) %>% 
      select(collaborator = node, `probability(environment | collaborator)` = probability) %>% 
      formattable(list(area(col = `probability(environment | collaborator)`) ~ normalize_bar("lightgreen", 0.25)))
  })
  
  output$entropy = renderText({
    value = entropies %>% 
      filter(topic == input$topic)
    paste("Entropy: ", value$entropy)
  })
})
