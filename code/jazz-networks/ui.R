#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Latent structures in jazz collaboration trajectories"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      p("Controls will come here")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      forceNetworkOutput("z_network")
    )
  )
))
