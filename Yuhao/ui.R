library(shiny)

# ui.R
shinyUI(fluidPage(
  titlePanel("Bayesian Posterior Probability Visualization"),  
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 
                'Choose CSV File (<5MB)',
                accept = c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
      tags$hr(),
      helpText("The response variable must be the first column in the CSV."),
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
                   '"'),
      helpText("Select prior parameters."),
      ## Decision node 0
      selectInput("type", "Prior Distribution Type", 
                  list("Discrete" = "disc", 
                       "Continuous" = "cont")),
      ## Decision node 1 | Decision node 0
      ## Choose a distribution for type selected at node 0.
      conditionalPanel(
        condition = "input.type == 'disc'",
        selectInput("discType", "Discrete:",
                    list("Bernoulli", "Binomial", "Poisson")),
        ## Discrete
        ## Decision node 2 | Decision node 1
        ## Display appropriate parameters for distribution chosen at node 1.
        conditionalPanel(
          condition = "input.discType == 'Bernoulli'",
          sliderInput("bern.prop", "Probability", min = 0.00, max = 1.00, value = 0.50)
        ),
        conditionalPanel(
          condition = "input.discType == 'Binomial'",
          sliderInput("binom.trials", "Number of Trials", min = 0, max = 100, value = 50),
          sliderInput("binom.succeses", "Success probability of each trial", min = 0.00, max = 1.00, value = 0.50)
        ),
        conditionalPanel(
          condition = "input.discType == 'Poisson'",
          sliderInput("pois.lambda", "Lambda", min = 0, max = 100, value = 1)
        )
      ),
      conditionalPanel(
        condition = "input.type == 'cont'",
        selectInput(inputId = "contType", 
                    label = "Continuous:",
                    choices = list("Normal", "Uniform", 
                                   "Exponential", "Inverse-Gamma")),
        ## Continuous
        ## Decision node 2 | Decision node 1
        ## Display appropriate parameters for distribution chosen at node 1.
        conditionalPanel(
          condition = "input.contType == 'Normal'",
          sliderInput(inputId = "norm.mean", 
                      label = "Mean", 
                      min = 0, 
                      max = 200, 
                      value = 100),
          sliderInput(inputId = "norm.var", 
                      label = "Variance", 
                      min = 0, 
                      max = 200, 
                      value = 100)
        ),
        conditionalPanel(
          condition = "input.contType == 'Uniform'",
          sliderInput(inputId = "norm.a", 
                      label = "a", 
                      min = 0, 
                      max = 300, 
                      value = 0),
          sliderInput(inputId = "norm.b", 
                      label = "b", 
                      min = 0, 
                      max = 300, 
                      value = 100)
        ),
        conditionalPanel(
          condition = "input.contType == 'Exponential'",
          sliderInput(inputId = "expo.rate", 
                      label = "Rate, lambda",
                      min = 0, 
                      max = 500, 
                      value = 1)
        ),
        conditionalPanel(
          condition = "input.contType == 'Inverse-Gamma'",
          sliderInput(inputId = "invgam.shape", 
                      label = "Shape, alpha", 
                      min = 0, 
                      max = 500, 
                      value = 1),
          sliderInput(inputId = "invgam.scale", 
                      label = "Scale, real", 
                      min = 0, 
                      max = 500, 
                      value = 1)
        )
      ),
      submitButton("Submit") # output cond on submit
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
))
## References:
## Nested conditionalPanel statements: http://shiny.rstudio.com/reference/shiny/latest/conditionalPanel.html



