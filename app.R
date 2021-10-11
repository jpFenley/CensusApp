library(shiny)
library(maps)
library(ggplot2)
library(mapproj)
source("helpers.R")

counties <- readRDS("counties.rds")
head(counties)

ui <- fluidPage(
  titlePanel("censusVis"),
  sidebarLayout(
    sidebarPanel(
      helpText('Create demographic maps with information
               from the 2010 US Census.'),
      selectInput(inputId = "race",
                  label = 'Choose a variable to Display',
                  choices = c('Percent White',
                              'Percent Black',
                              'Percent Hispanic',
                              'Percent Asian'),
                  selected = 'Percent White'),
      sliderInput(inputId = "range",
                  label = "Range of interest:",
                  min = 0,
                  max = 100,
                  value = c(0, 100))),
    mainPanel(

      plotOutput(outputId = "map")
    )
  )
)


server <- function(input, output) {
  output$map <- renderPlot({
    target_race = switch(input$race,
                         "Percent White" = counties$white,
                         "Percent Black" = counties$black,
                         "Percent Hispanic" = counties$hispanic,
                         "Percent Asian" = counties$asian)
    race_name = switch (input$race,
                        "Percent White" = "% White",
                        "Percent Black" = "% Black",
                        "Percent Hispanic" = "% Hispanic",
                        "Percent Asian" = "% Asian")
    colors = switch (input$race,
                     "Percent White" = "darkgreen",
                     "Percent Black" = "black",
                     "Percent Hispanic" = "darkorange",
                     "Percent Asian" = "darkviolet")
    
    percent_map(var = target_race,
                color=colors, 
                legend.title=race_name, 
                max=input$range[2], min=input$range[1])
  })
}


shinyApp(ui = ui, server = server)
