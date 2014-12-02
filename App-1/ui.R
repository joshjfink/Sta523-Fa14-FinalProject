library(shiny)

# ui.R
shinyUI(fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Select parameters for prior and likelihood to see posterior probability density."),
      
      selectInput("var", 
                  label = "Choose a prior density distribution",
                  choices = c("Normal", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = -100, 
                  max = 100, 
                  value = c(-100, 100)),
      conditionalPanel(condition = "input.variable == 'Normal'",
                       sliderInput("integer", "Integer:", 
                                   min=0, max=1, value=0)),
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, 
                  max = 100, 
                  value = c(0, 100))
      ),
    mainPanel(
      textOutput("text1")
    )
  )
))