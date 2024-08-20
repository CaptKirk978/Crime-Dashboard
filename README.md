# **Indiana Crime Data Dashboard**

This project is an R Shiny web application designed to visualize "incident" data across Marion County, Indiana. It features an interactive map and general statistics on the date range selected. The application also features a user interface for scraping new incident data from <https://cityprotect.com> using a modified API to capture the entire county.

## **Installation** {#installation}

### **1. Prerequisites**

-   R (built with version 4.1.1)
-   RStudio (recommended)

### **2. Clone the Repository**

```{bash}
git clone https://github.com/CaptKirk978/Crime-Dashboard.git
cd Crime-Dashboard
```

### **3. Install Required Packages**

Open an R console and run the following command to install the required packages:

```{r}
install.packages(c("shiny", "bs4Dash", "leaflet", "vroom", "dplyr", "lubridate", "httr", "jsonlite", "stringr"))
```

## **Usage** {#usage}

### **1. Run the application**

To run the application, execute the following code in an R console with updated arguments for your local machine.

```{r}
shiny::runApp(
  appDir = getwd(),
  port = 5374,
  launch.browser = getOption("shiny.launch.browser", interactive()),
  host = getOption("shiny.host", "127.0.0.1"),
  workerId = "",
  quiet = FALSE,
  display.mode = c("auto", "normal", "showcase"),
  test.mode = getOption("shiny.testmode", FALSE)
)
```

### **2. Access the Application**

The Shiny application should start on your local machine at <http://127.0.0.1:5374> which can be navigated to in your browser.
