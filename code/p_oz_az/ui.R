library(shiny)
library(formattable)

shinyUI(fluidPage(
  # Application title
  titlePanel("Probability of transition to artist"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput(
        'topic',
        'Environment',
        choices = NULL,
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
      )
    )
  )
))
