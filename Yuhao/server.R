library(shiny)

shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    data=read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                  quote=input$quote)
    
    shinjags = function(data,input_a,input_b){
      
      
      
      n = nrow(data)
      X = as.matrix(data[,-1]) # remove Y
      
      ### R interface to JAGS:
      library(R2jags)
      library(R2WinBUGS)
      # Create a data list with inputs for WinBugs
      scaled.X = scale(X)
      data = list(Y = data[,1], X=scaled.X, p=ncol(X))
      data$n = length(data$Y)
      data$scales = attr(scaled.X, "scaled:scale")
      data$Xbar = attr(scaled.X, "scaled:center")
      data$a = input_a
      data$b = input_b
      
      # write the model
      
      rr.model = function() {
        df1 <- a
        shape1 <- df1/2
        df2 <- b
        shape2 <- df2/2
        
        for (i in 1:n) {
          mu[i] <- inprod(X[i,], beta) + alpha
          lambda[i] ~ dgamma(shape1, shape1)
          prec1[i] <- phi*lambda[i]
          Y[i] ~ dnorm(mu[i], prec1[i])
        }
        phi ~ dgamma(1.0E-6, 1.0E-6)
        alpha ~ dnorm(0, 1.0E-10)
        
        for (j in 1:p) {
          prec.beta[j] <- lambda.beta[j]*phi
          beta[j] ~ dnorm(0, prec.beta[j])
          lambda.beta[j] ~ dgamma(shape2, shape2)
        }
        
        for (j in 1:p) {
          beta.orig[j] <- beta[j]/scales[j]   # rescale
        }
        beta.0[1] <- alpha[1] - inprod(beta[1:p], Xbar)
        sigma <- pow(phi, -.5)
      }
      
      # create a function that provides intial values for WinBUGS
      rr.inits = function() {
        bf.lm <- lm(data$Y ~ -1 + data$X)
        coefs = coef(bf.lm)
        alpha = coefs[1]
        beta = coefs[-1]
        phi = (1/summary(bf.lm)$sigma)^2
        lambda = rep(1, data$n)
        lambda.beta = rep(1, data$p)
        return(list(alpha=alpha, phi=phi, lambda=lambda,
                    lambda.beta=lambda.beta))
      }
      
      # a list of all the parameters to save
      parameters = c("beta.orig","beta.0", "sigma","lambda.beta", "lambda")
      
      rr.model.file = paste(getwd(),"rr-model.txt", sep="/")
      write.model(rr.model, rr.model.file)
      
      bf.sim = jags(data, inits=rr.inits, parameters, model.file=rr.model.file,  n.iter=5000)
      
      bf.bugs = as.mcmc(bf.sim$BUGSoutput$sims.matrix)  # create an MCMC object 
      return(bf.bugs)
    }
      plot(shinjags(data,input$invgam.shape,input$invgam.scale)[,"beta.orig[1]"])
    
    
  })
})