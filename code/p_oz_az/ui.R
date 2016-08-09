library(shiny)
library(shinythemes)
library(formattable)
library(networkD3)
source("environments-lib.R")

# Choices for labels in selectInput
labels = get_environment_labels()
env_options = list()
#env_options[["Choose a latent environment"]] = ""
for (i in labels$topic) {
  label = labels[labels$topic == i,]$label
  env_options[[sprintf("%g - %s", i, label)]] <- i
}


shinyUI(fluidPage(theme = shinytheme("journal"),
  titlePanel("Latent structures in Jazz collaboration trajectories"),
  p("Browse through latent collaboration environments found by TribeFlow on Jazz discographies from Discogs.com"),
  tabsetPanel(
    tabPanel("intra-environment",
             br(),
             fluidRow(
               column(5, 
                      wellPanel(
                        selectInput(
                          'topic',
                          'Select a latent environment',
                          choices = env_options,
                          selected = env_options[runif(1, 0, 29)],
                          selectize = TRUE
                        ) 
                      ),
                      offset = 0
               )
             ), 
             
             fluidRow(
               column(6, 
                      h3("artists"),
                      p(em("most likely present")),
                      fluidRow(
                        formattableOutput("environmentTable")
                      ),
                      offset = 0
               ), 
               column(3, 
                      h3("collaborators"),
                      p(em("most likely present")),
                      fluidRow(
                        #formattableOutput("collaboratorTable")
                        htmlOutput("collaboratorList")
                      ),
                      h3("tags"),
                      p(em("in records")),
                      plotOutput("tags", height = '150px', width = '250px'),
                      offset = 1
               )
             ),
             
             fluidRow(
               column(6, 
                      textOutput('entropy', inline = TRUE), 
                      offset = 0
               )
             )
    ), 
    tabPanel("inter-environment",
             fluidRow(
               column(5, 
                      h3("inter-environments"),
                      p(em("nodes are environments. links represent significant chance of a collaborator transitioning between environments")),
                      forceNetworkOutput("z_network", width = 600),
                      offset = 1
               )
             )
    )
  )
))
