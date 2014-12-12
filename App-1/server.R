shinyServer(function(input,output){

  priors <- reactive({
    if(input$type=="Continuous") c("Normal", "Uniform", "Exponential", "Inverse-Gamma")
    else if(input$type=="Discrete") c("Bernoulli", "Binomial", "Poisson")
    })
  
  output$priorNames <- renderUI({
    selectInput("Priors","Choose a Prior:",choices=priors(),selected=priors()[1],multiple=T)
  })
})

# output$dldat <- downloadHandler(
#     filename = function() { paste(input$dat, '.csv', sep='') },
#     content = function(file) {
#       write.csv(dat(), file)
#     }
#   )
