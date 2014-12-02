library(shiny)

# ui.R
shinyUI(fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 
                'Choose CSV File',
                accept = c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
      helpText("Select prior parameters."),
      selectInput("type", "Distribution Type", 
                  list("Discrete" = "disc", 
                        "Continuous" = "cont")),
      conditionalPanel(
        condition = "input.type == 'disc'",
        selectInput("disc", "Discrete:",
                    list("Bernoulli", "Binomial", "Poisson", "Geometric"))
      ),
      conditionalPanel(
        condition = "input.type == 'cont'",
        selectInput("cont", "Continuous:",
                    list("Normal", "Uniform", "Pareto", "Exponential", "Inverse-Gamma"))
      )
    ),
    mainPanel(
      textOutput("text1")
    )
  )
))