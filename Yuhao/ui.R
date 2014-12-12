library(shiny)

shinyUI(fluidPage(
  titlePanel("Uploading Files"),
  
  sidebarLayout(
    sidebarPanel(
      sidebarPanel(
        fileInput('file1', 'Choose CSV File',
                  accept=c('text/csv', 
                           'text/comma-separated-values,text/plain', 
                           '.csv')),
        tags$hr(),
        checkboxInput('header', 'Header', TRUE),
        radioButtons('sep', 'Separator',
                     c(Comma=',',
                       Semicolon=';',
                       Tab='\t'),
                     ','),
        radioButtons('quote', 'Quote',
                     c(None='',
                       'Double Quote'='"',
                       'Single Quote'="'"),
                     '"')
      ),
      helpText("Select prior parameters."),
      
      ##input prior parameter, need to be modified
      selectInput("input_a", label = "Prior Parameter a:", 
                  choices = c(5, 7, 9, 11), selected = 7),
      
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
      plotOutput("distPlot")
    )
  )
))

