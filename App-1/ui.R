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
                    list("Bernoulli", "Binomial", "Poisson", "Geometric")),
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
        ),
        conditionalPanel(
          condition = "input.discType == 'Geometric'",
          sliderInput("binom.trials", "Number of Trials", min = 0, max = 100, value = 50),
          sliderInput("binom.succeses", "Success probability of each trial", min = 0.00, max = 1.00, value = 0.50)  
        )
      ),
      conditionalPanel(
        condition = "input.type == 'cont'",
        selectInput("contType", "Continuous:",
                    list("Normal", "Uniform", "Pareto", "Exponential", "Inverse-Gamma")),
        ## Continuous
        ## Decision node 2 | Decision node 1
        ## Display appropriate parameters for distribution chosen at node 1.
        conditionalPanel(
          condition = "input.contType == 'Normal'",
          sliderInput("norm.mean", "Mean", min = 0, max = 200, value = 100),
          sliderInput("norm.var", "Variance", min = 0, max = 200, value = 100)
        ),
        conditionalPanel(
          condition = "input.contType == 'Uniform'",
          sliderInput("norm.a", "a", min = 0, max = 300, value = 0),
          sliderInput("norm.b", "b", min = 0, max = 300, value = 100)
        ),
        conditionalPanel(
          condition = "input.contType == 'Pareto'",
          sliderInput("norm.mean", "Mean", min = 0, max = 400, value = 1),
          sliderInput("norm.var", "Variance", min = 0, max = 400, value = 1)
        ),
        conditionalPanel(
          condition = "input.contType == 'Exponential'",
          sliderInput("norm.mean", "Mean", min = 0, max = 500, value = 1),
          sliderInput("norm.var", "Variance", min = 0, max = 500, value = 1)
        ),
        conditionalPanel(
          condition = "input.contType == 'Inverse-Gamma'",
          sliderInput("norm.mean", "Mean", min = 0, max = 500, value = 1),
          sliderInput("norm.var", "Variance", min = 0, max = 500, value = 1)
        )
      )
    ),
    mainPanel(
      textOutput("text1"),
      tableOutput('contents')
    )
  )
))

## References:
## Nested conditionalPanel statements: http://shiny.rstudio.com/reference/shiny/latest/conditionalPanel.html