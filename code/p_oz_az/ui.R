library(shiny)
library(formattable)
source("environments-lib.R")

# Choices for labels in selectInput
labels = get_environment_labels()
env_options = list()
env_options[["Choose a latent environment"]] = ""
for (i in labels$topic) {
  label = labels[labels$topic == i,]$label
  env_options[[sprintf("%g - %s", i, label)]] <- i
}


shinyUI(fluidPage(
  # Application title
  titlePanel("Latent structures in Jazz collaboration trajectories"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput(
        'topic',
        'Environment',
        choices = env_options,
        selectize = TRUE
      ), 
      br(),
      textOutput('entropy', inline = TRUE)
    ),
    
    mainPanel(
      fluidRow(
        formattableOutput("environmentTable")
      ),
      fluidRow(
        formattableOutput("collaboratorTable")
      ), 
      fluidRow(
        plotOutput("tags")
      )
    )
  )
))
