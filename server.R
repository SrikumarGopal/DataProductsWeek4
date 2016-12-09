
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)



load_data <- function() {
    Sys.sleep(1)
    hide("loading_page")
    show("main_content")
}
pdf(NULL)
shinyServer(function(input, output) {

    source("readData.R")
    gh <- readData()
    ghm <- meltdata(gh)
    

    output$chooseTitle <- renderUI({
        d <- unique(gh$Category)
        d <- d[!is.na(d)&d!=""]
        selectInput("title", "Source", as.list(d), size = 8, selectize = F)
    })
 
    # gh <- reactive({
    #     d <- readData()
    #     d
    #     
    # })
    # ghm <- reactive({
    #     d <- gh()
    #     d <- meltdata(d)
    #     d
    # })
    
  
  output$meltTotalPlot <- renderPlot({
      d <- ghm
      d <- d[d$Category == input$title & d$group == "Total",]
      d$variable <- substring(d$variable,6)
      
      if(nrow(d) == 0)
      {
            return(NULL)
      }
      else
      {
          g <- ggplot(data = d, aes(x = Year, y = valindex))
          g <- g + geom_hline(yintercept=100)
          g <- g + geom_line(aes(col=CategoryTitle)) + facet_wrap(~variable, ncol=5)
          g <- g + xlab("Year") + ylab("% difference")
          print(g) 
      }

        
  })
  
  output$meltKGPlot <- renderPlot({
      d <- ghm
      d <- d[d$Category == input$title & d$group != "Total",]
      d$variable <- substring(d$variable,6)
      
      if(nrow(d) == 0)
      {
          return(NULL)
      }
      else
      {
          g <- ggplot(data = d, aes(x = Year, y = valindex))
          g <- g + geom_hline(yintercept=100)
          g <- g + geom_line(aes(col=CategoryTitle)) + facet_wrap(~variable, ncol = 5)
          g <- g + xlab("Year") + ylab("% difference")
          print(g) 
      }
      
      
  })
  
  # ghtab <- reactive({
  #     d <-  ghm
  #     d <- tabdata(d, input$title)
  #     d
  #     
  # })
  
  output$table <- renderTable(
      {
          d <- tabdata(ghm, input$title)
          d
              
          
      }
  )
  load_data()   

})
