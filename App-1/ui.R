library(shiny)

# ui.R
shinyUI(fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 
                'Choose CSV File (<5MB)',
                accept = c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
      helpText("Select prior parameters."),
      
      ## Decision node 0
      selectInput("type", "Distribution Type", 
                  list("Discrete" = "disc", 
                        "Continuous" = "cont")),
      ## Decision node 1 | Decision node 0
      ## Choose a distribution for type selected at node 0.
      conditionalPanel(
        condition = "input.type == 'disc'",
        selectInput("discType", "Discrete:",
                    list("Bernoulli", "Binomial", "Poisson", "Geometric"))
      ),
      conditionalPanel(
        condition = "input.type == 'cont'",
        selectInput("contType", "Continuous:",
                    list("Normal", "Uniform", "Pareto", "Exponential", "Inverse-Gamma"))
      ),
      
      ## Decision node 2 | Decision node 1
      ## Display appropriate parameters for distribution chosen at node 1.
      conditionalPanel(
        condition = "input.contType == 'Normal'",
        sliderInput("norm.mean", "Mean", min = 0, max = 100, value = 1),
        sliderInput("norm.var", "Variance", min = 0, max = 100, value = 1)
      )
    ),
    mainPanel(
      textOutput("text1")
    )
  )
))