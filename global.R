library(shiny)
library(bs4Dash)
library(leaflet)
library(vroom)
library(dplyr)
library(lubridate)

######### Indy Incident map data ###########

incidents <- vroom(file = list.files("./Data/", full.names = T))




