ui <- bs4DashPage(
  help = NULL,
  dark = TRUE,
  title = "Bailey Kirk's Dashboard",
  fullscreen = T,
  header = dashboardHeader(
    title = dashboardBrand(
      title = "Bailey Kirk",
      color = "primary",
      href = "https://baileykirk.work",
      image = "https://adminlte.io/themes/v3/dist/img/AdminLTELogo.png"
    )
  ),
  sidebar = dashboardSidebar(
    collapsed = TRUE,
    sidebarMenu(
      id = "sidebarmenu",
      sidebarHeader("Pages"),
      menuItem(
        "Summary",
        tabName = "Summary",
        icon = icon("map")
      ),
      menuItem(
        "Item 2",
        tabName = "test",
        icon = icon("question")
      )
    )
  ),
  body = dashboardBody(
    bs4TabItems(
      bs4TabItem(
        tabName = "Summary",
        fluidRow(
          infoBox(
            title = "Total Incidents",
            icon = icon("handcuffs"),
            fill = T,
            color = "primary",
            textOutput("total_incidents"),
            "Content of Box 1"
          ),
          infoBox(
            title = "Crime",
            icon = ,
            fill = T,
            color = "primary",
            "Content of Box 2"
          ),
          infoBox(
            title = "Not Crime",
            icon = ,
            fill = T,
            color = "primary",
            "Content of Box 3"
          )
        ),
        fluidRow(
          leafletOutput("map_with_points", height = "70vh")
        )
      ),
      bs4TabItem(
        tabName = "test"
      )
    )
  ),
  controlbar = dashboardControlbar(
    skin = "light",
    pinned = FALSE,
    collapsed = TRUE,
    overlay = TRUE,
    controlbarMenu(
      id = "controlbarmenu",
      controlbarItem(
        title = "Data Filters",
        dateRangeInput("mapRange",
          "Date Range: ",
          start = tryCatch({min(incidents$date)}, 
                           error = function(e) {Sys.Date() %m+% days(-1)}),
          end = tryCatch({min(incidents$date) %m+% days(1)}, 
                         error = function(e) {Sys.Date() %m+% days(-2)}),
          min = min(incidents$date),
          max = max(incidents$date)
        ),
        checkboxGroupInput("crime_filter",
          label = h3("Incident Types:"),
          choices = list(
            "Proactive Policing" = "Proactive Policing",
            "Quality of Life" = "Quality of Life",
            "Property Crime" = "Property Crime",
            "Breaking & Entering" = "Breaking & Entering",
            "Fire" = "Fire",
            "Robbery" = "Robbery",
            "Assault" = "Assault",
            "Theft" = "Theft",
            "Theft of Vehicle" = "Theft of Vehicle",
            "Theft from Vehicle" = "Theft from Vehicle",
            "Emergency" = "Emergency",
            "Sexual Offense" = "Sexual Offense",
            "Homicide" = "Homicide",
            "Community Policing" = "Community Policing"
          ),
          selected = list(
            "Proactive Policing" = "Proactive Policing",
            "Quality of Life" = "Quality of Life",
            "Property Crime" = "Property Crime",
            "Breaking & Entering" = "Breaking & Entering",
            "Fire" = "Fire",
            "Robbery" = "Robbery",
            "Assault" = "Assault",
            "Theft" = "Theft",
            "Theft of Vehicle" = "Theft of Vehicle",
            "Theft from Vehicle" = "Theft from Vehicle",
            "Emergency" = "Emergency",
            "Sexual Offense" = "Sexual Offense",
            "Homicide" = "Homicide",
            "Community Policing" = "Community Policing"
          )
        )
      ),
      controlbarItem(
        title = "Scrape Data",
        dateRangeInput("scrape_date_range",
          "Date Range: ",
          start = Sys.Date() %m+% days(-2),
          end = Sys.Date() %m+% days(-1),
          min = Sys.Date() %m+% days(-364),
          max = Sys.Date() %m+% days(-1)
        ),
        actionButton(inputId = "load_data", label = "Load Data"),
        p("This might take a few minutes depending on your selected date range"),
        br(),
        textOutput("status")
      )
    )
  ),
  footer = dashboardFooter(
    left = a(
      href = "https://baileykirk.work",
      target = "_blank",
      "© 2024 Bailey Kirk. All rights reserved."
    )
  )
)
