
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinyjs)

shinyUI(fluidPage(
    useShinyjs(),

  # Application title
  titlePanel("Greenhouse gases in the Netherlands"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
        uiOutput("chooseTitle"),
        p("Click on the values in the list to view emissions for a particular source"),
        p("This app shows the development of greenhouse gases within the Netherlands from 1990 - 2015. 
          To the chart readable, all values have been re-indexed to 100% in 1990 with other years a percentage
          difference from 1990. This way it is possible to evaluate the changes per year for all values"),
        p("Data for this app is retrieved from the Dutch Central Bureau of Statistics(CBS) in JSON format every time
          the app is opened."),
        p("I myself provided a translation CSV to translate the dutch terms to English ones and to group 
          the different sources by type (air, road, etc.)"),
        p( a("Those interested in the original dataset, it can be found here", href="http://opendata.cbs.nl/dataportaal/portal.html?_la=nl&_catalog=CBS&tableId=70946ned&_theme=257")),
        width = 3
    ),

    # Show a plot of the generated distribution
    mainPanel(
        div(
            id = "loading_page",
            h1("Loading...")
        ),
        hidden(
            div(id = "main_content",
                h3("Total Emissions", align = "center"),
                plotOutput("meltTotalPlot", height = 390),
                h3("Emissions per kg of fuel", align = "center"),
                plotOutput("meltKGPlot", height = 260),
                width = 9,
                h3("Data table", align = "center"),
                p("This table shows the percentage difference between 1990 and 2015"),
                tableOutput('table')
            )
        )

    )
  )
))
