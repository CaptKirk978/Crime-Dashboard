
server = function(input, output) {
  
  output$map_with_points <- renderLeaflet({
    map <- incidents %>% 
      filter(`date` >= input$mapRange[1], `date` <= input$mapRange[2]) %>% 
      filter(parentIncidentTypeId %in% c(input$crime_filter))
    
    leaflet(data = map) %>% 
      addTiles() %>% 
      addCircleMarkers(
        lng = as.numeric(map$Long),
        lat = as.numeric(map$Lat),
        radius = 5,
        popup = paste(map$parentIncidentType,
                      "<br>",
                      map$Address,
                      "<br>",
                      map$date
                      ),
        clusterOptions = markerClusterOptions()
      )
    
  })
  
  output$total_incidents <- renderText({
    total_incdnts <- incidents %>% 
      filter(`date` >= input$mapRange[1], `date` <= input$mapRange[2],
             parentIncidentTypeId %in% c(input$crime_filter))
    
    nrow(total_incdnts)
  })
  
  
}
