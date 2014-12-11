library(shiny)

shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    data=read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                  quote=input$quote)
    
    
      college=data
      #Deal with the first column
      rownames(college)=college[,1]
      college=college[,-1]
      
      college$Private=as.character(college$Private)
      
      college[college=="Yes"]=1
      college[college=="No"]=0
      
      college$Private=as.numeric(college$Private)
      
      #Random selection of training set and test set
      n = nrow(college)
      set.seed(42)
      n.train=round(.8*n)
      n.test = n - n.train
      X = as.matrix(college[-2]) # remove Apps = Y
      
      train = sample(1:n, n.train)
      
      X.train = X[train,]
      X.test= X[-train,]
      Y.train = college$Apps[train]
      Y.test = college$Apps[-train]
      
      ### R interface to JAGS:
      library(R2jags)
      library(R2WinBUGS)
      # Create a data list with inputs for WinBugs
      scaled.X = scale(X)
      data = list(Y = college$Apps, X=scaled.X, p=ncol(X))
      data$n = length(data$Y)
      data$scales = attr(scaled.X, "scaled:scale")
      data$Xbar = attr(scaled.X, "scaled:center")
      #data$a = input_a
      
      # write the model
      
      rr.model = function() {
        df1 <- 9
        shape1 <- df1/2
        df2 <- 7
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
        lambda.beta = rep(1, 17)
        return(list(alpha=alpha, phi=phi, lambda=lambda,
                    lambda.beta=lambda.beta))
      }
      
      # a list of all the parameters to save
      parameters = c("beta.orig","beta.0", "sigma","lambda.beta", "lambda")
      
      rr.model.file = paste(getwd(),"rr-model.txt", sep="/")
      write.model(rr.model, rr.model.file)
      
      bf.sim = jags(data, inits=rr.inits, parameters, model.file=rr.model.file,  n.iter=5000)
      
      bf.bugs = as.mcmc(bf.sim$BUGSoutput$sims.matrix)  # create an MCMC object 
      
      plot(bf.bugs[,"beta.orig[1]"])
    
    
  })
})