library(shiny)
library(bs4Dash)
library(leaflet)
library(vroom)
library(dplyr)
library(lubridate)
library(httr)
library(jsonlite)
library(stringr)

read_in_incidents <- function() {
  
  data_folder <- "./data/"  
  
  incident_files <- list.files(data_folder, pattern = "\\.csv$", full.names = TRUE)
  
  if (length(incident_files) == 0) return(NULL)
  
  vroom(incident_files) %>% 
    distinct(`id`, .keep_all = T)
}


scrape_incidents <- function(scrape_from_date, scrape_to_date) {
  
  from_date <- paste0('\"', format(scrape_from_date, "%Y-%m-%dT%H:%M:%S.000Z"), '\"')
  to_date <- paste0('\"', format(scrape_to_date, "%Y-%m-%dT%H:%M:%S.000Z"), '\"')
  
  # api URL
  url <- "https://ce-portal-service.commandcentral.com/api/v1.0/public/incidents"
  
  payload <- paste0(
    '{"limit":2000,"offset":0,"geoJson":{"type":"Polygon","coordinates":[[[-85.954885,39.640356],[-86.327408,39.634263],[-86.327393,39.922914],[-85.958472,39.925696],[-85.954885,39.640356]]]},"projection":false,"propertyMap":{"toDate":', to_date, ',"fromDate":', from_date, ',"pageSize":"2000","parentIncidentTypeIds":"149,150,148,8,97,104,165,98,100,179,178,180,101,99,103,163,168,166,12,161,14,16,15","zoomLevel":"15","latitude":"39.768710408143214","longitude":"-86.15357897257186","days":"1,2,3,4,5,6,7","startHour":"0","endHour":"24","timezone":"+00:00","relativeDate":"custom","agencyIds":"indy.gov,sheridanpd.org,ciceroin.org,carmel.in.gov,mcohiosheriff.org,westfield.in.gov,illinois.edu,cityoflawrence.org,speedwayin.gov,butlersheriff.org,hamiltoncounty.in.gov,noblesville.in.us,fishers.in.us,arcadiaindiana.org,perryschools.org"}}'
  )
  
  response <- POST(url, add_headers("Content-Type" = "application/json"), body = payload)
  
  raw_json <- content(response, as = "text")
  
  json <- fromJSON(raw_json)
  
  total_incidents <- json[["result"]][["list"]][["incidents"]]
  
  incident_count <- nrow(json[["result"]][["list"]][["incidents"]])
  
  total_incident_count <- incident_count
  
  request_count <- 2
  
  while (!is.null(incident_count)) {
    request_count <- request_count + 1
    print(request_count)
    
    next_payload <- json[["navigation"]][["nextPagePath"]][["requestData"]]
    payload <- toJSON(next_payload, auto_unbox = T)
    response <- POST(url, add_headers("Content-Type" = "application/json"), body = payload)
    
    raw_json <- content(response, as = "text")
    json <- fromJSON(raw_json)
    
    incident_count <- nrow(json[["result"]][["list"]][["incidents"]])
    total_incident_count <- total_incident_count + incident_count
    
    incidents <- json[["result"]][["list"]][["incidents"]]
    
    total_incidents <- total_incidents %>% 
      bind_rows(incidents)
  }

  
  
  total_incidents$location$coordinates <- gsub("\\(", "", total_incidents$location$coordinates)
  total_incidents$location$coordinates <- gsub("\\)", "", total_incidents$location$coordinates)
  total_incidents$location$coordinates <- gsub("c", "", total_incidents$location$coordinates)
  total_incidents[c('Long', 'Lat')] <- str_split_fixed(total_incidents$location$coordinates, ',', 2)
  
  total_incidents <- total_incidents %>% 
    distinct(`id`, .keep_all = T) %>%  
    select(-c(location))
  
  write.csv(total_incidents, file = paste0("./Data/Incidents_", from_date, "-", to_date, ".csv"), row.names = F)

  
  
}

incidents <- read_in_incidents() 




