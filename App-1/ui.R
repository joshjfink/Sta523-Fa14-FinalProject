library(shiny)


shinyUI(pageWithSidebar(
  titlePanel("Bayesian Posterior Probability Visualization"),
  sidebarPanel(
      selectInput("type", "Prior Distribution Type", choices=c("Discrete", "Continuous"),selected="Discrete"),
      uiOutput("priorNames")
      ),
  mainPanel("Main")))


