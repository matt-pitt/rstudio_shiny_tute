source("helpers.R")
counties <- readRDS("data/counties.rds")
library(maps)
library(mapproj)
library(shiny)

# UI
ui <- fluidPage(
    titlePanel("censusVis"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Create demographic maps with 
               information from the 2010 US Census."),
            
            selectInput("var", 
                        label = "Choose a variable to display",
                        choices = c("Percent White", 
                                    "Percent Black",
                                    "Percent Hispanic", 
                                    "Percent Asian"),
                        selected = "Percent White"),
            
            sliderInput("range", 
                        label = "Range of interest:",
                        min = 0, max = 100, value = c(0, 100))
        ),
        
        mainPanel(plotOutput("map") 
        )
    )
)

# server
server <- function(input, output) {
    output$map <- renderPlot({
        data <- switch(input$var, 
                       "Percent White" = counties$white,
                       "Percent Black" = counties$black,
                       "Percent Hispanic" = counties$hispanic,
                       "Percent Asian" = counties$asian)
        
        color <- switch(input$var, 
                        "Percent White" = "darkgreen",
                        "Percent Black" = "black",
                        "Percent Hispanic" = "darkred",
                        "Percent Asian" = "goldenrod4")
        
        legend.title <- switch(input$var, 
                        "Percent White" = "% white",
                        "Percent Black" = "% black",
                        "Percent Hispanic" = "% hispanic",
                        "Percent Asian" = "$ asian")
        
        percent_map(var = data, color = color, legend.title = legend.title, input$range[1], input$range[2])
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
