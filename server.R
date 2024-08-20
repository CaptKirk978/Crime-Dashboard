
server = function(input, output, session) {
  
  rv <- reactiveValues(incidents = incidents) 
  
  
  observeEvent(input$load_data, {
    dir.create("./Data", showWarnings = FALSE)
    
    scrape_dates <- input$scrape_date_range

    scrape_incidents(scrape_dates[1], scrape_dates[2])
    
    new_incidents <- read_in_incidents()
    
    if (!is.null(new_incidents)) {
      
      rv$incidents <- new_incidents
      updateDateRangeInput(
        session,
        inputId = "mapRange",
        min = min(rv$incidents$date),   
        max = max(rv$incidents$date)
      )
      
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
                      map$incidentType
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
      
      paste(nrow(total_incdnts), "Incident(s)")
    } else {
      return(0)
    }
  })
  
  output$total_crime <- renderText({
    if (!is.null(rv$incidents)) {
      crime <- rv$incidents %>% 
        filter(`date` >= input$mapRange[1], `date` <= input$mapRange[2],
               parentIncidentType %in% c("Theft from Vehicle", "Robbery", "Theft",
                                         "Theft of Vehicle", "Sexual Offense", "Assault", 
                                         "Property Crime", "Breaking & Entering", "Homicide"),
               parentIncidentType %in% c(input$crime_filter))
      
      paste(nrow(crime), "Crime(s)")
    } else {
      return(0)
    }
  })
  
  output$total_misc <- renderText({
    if (!is.null(rv$incidents)) {
      misc <- rv$incidents %>% 
        filter(`date` >= input$mapRange[1], `date` <= input$mapRange[2],
               !parentIncidentType %in% c("Theft from Vehicle", "Robbery", "Theft",
                                         "Theft of Vehicle", "Sexual Offense", "Assault", 
                                         "Property Crime", "Breaking & Entering", "Homicide"),
               parentIncidentType %in% c(input$crime_filter))
      
      paste(nrow(misc), "Call(s)")
    } else {
      return(0)
    }
  })
  
}
