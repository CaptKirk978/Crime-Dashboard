
server = function(input, output, session) {
  
  rv <- reactiveValues(incidents = incidents) 
  
  
  observeEvent(input$load_data, {
    dir.create("./Data", showWarnings = F)
    
    scrape_dates <- input$scrape_date_range

    scrape_incidents(scrape_dates[1], scrape_dates[2])
    
    new_incidents <- read_in_incidents()
    
    if (!is.null(new_incidents)) {
      
      rv$incidents <- new_incidents
      
      output$status <- renderText("Data successfully loaded!")
      
    } else {
      output$status <- renderText("No files found in the data folder.")
    }
  })
  
  output$map_with_points <- renderLeaflet({
    if (!is.null(rv$incidents)) {
      map <- rv$incidents %>% 
      filter(`date` >= input$mapRange[1], `date` <= input$mapRange[2]) %>% 
      filter(parentIncidentType %in% c(input$crime_filter))
      
      leaflet(data = map) %>% 
      addTiles() %>% 
      addCircleMarkers(
        lng = as.numeric(map$Long),
        lat = as.numeric(map$Lat),
        radius = 5,
        popup = paste(map$date,
                      "<br>",
                      map$blockizedAddress,
                      "<br>",
                      map$parentIncidentType,
                      "<br>",
                      map$narrative
                      ),
        clusterOptions = markerClusterOptions()
      )
    } else {
      leaflet() %>% addTiles()
    }
    
  })
  
  output$total_incidents <- renderText({
    if (!is.null(rv$incidents)) {
      total_incdnts <- rv$incidents %>% 
        filter(`date` >= input$mapRange[1], `date` <= input$mapRange[2],
               parentIncidentType %in% c(input$crime_filter))
      
      nrow(total_incdnts)
    } else {
      return(0)
    }
    
    total_incdnts <- rv$incidents %>% 
      filter(`date` >= input$mapRange[1], `date` <= input$mapRange[2],
             parentIncidentType %in% c(input$crime_filter))
    
      nrow(total_incdnts)
    
  })
  
}
