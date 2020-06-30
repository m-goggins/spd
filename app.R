## app.R ##

# load required packages

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(readstata13)
library(highcharter)
library(maps)
library(rsconnect)
library(ggplot2)
library(plotly)
library(leaflet)
library(shinythemes)

# Load data
df <- read.dta13("data/ois_data.dta")
# Create a palette that maps factor levels to colors
pal <- colorFactor(c("navy", "red"), domain = c("ship", "pirate"))


## UI ##
ui <- bootstrapPage(
  # tags$head(includeHTML("gtag.html")),
  navbarPage(theme = shinytheme("flatly"), collapsible = TRUE,
             "Seattle Police Data", id="nav",
             tabPanel("Officer-Involved Shootings Mapper",
                      div(class="outer",
                          map <- leaflet() %>%
                            setView(lng = -122.3321, lat = 47.6062, zoom = 10) %>% 
                            addTiles() %>% 
                            addCircles(data = df, lat = ~ latitude, lng = ~ longitude, 
                                       color = ~ifelse(fatal_str == "Yes", "red", "navy"),
                                       fillOpacity = 0.5,
                                       label = sprintf("<strong>Officer Involved Shooting</strong><br/>Date: %s<br/> <br/>Subject Race: %s<br/> <br/>Subject Gender: %s<br/> <br/>Subject Age: %g<br/> <br/>Officer Race: %s<br/> <br/>Officer Gender: %s<br/> <br/>Years of SPD Service: %g<br/>", 
                                                       df$date_str, df$subjectrace, df$subjectgender, df$subjectage, df$officerrace, df$officergender, df$yearsofspdservice) %>% lapply(htmltools::HTML),
                                       labelOptions = labelOptions(
                                         style = list("font-weight" = "normal", padding = "3px 8px", "color" = "black"),
                                         textsize = "15px", direction = "auto")),

                          absolutePanel(id = "controls", class = "panel panel-default",
                                        top = 75, left = 55, width = 250, fixed=TRUE,
                                        draggable = TRUE, height = "auto",

                                        h3(textOutput("reactive_case_count"), align = "right"), 
                                        h4(textOutput("reactive_death_count"), align = "right"),
                                        span(h4(textOutput("reactive_disciplined_count"), align = "right"), style="color:#006d2c"),
                                        h6(textOutput("clean_date_reactive"), align = "right")
                          ),

                          absolutePanel(id = "logo", class = "card", bottom = 20, left = 20, width = 30, fixed=TRUE, draggable = FALSE, height = "auto",
                                        actionButton("twitter_share", label = "", icon = icon("twitter"),style='padding:5px',
                                                     onclick = sprintf("window.open('%s')",
                                                                       "https://twitter.com/intent/tweet?text=%20@Seattle_PD%20officer-involved%20shooting%20mapper&url=https://bit.ly/spd-ois&hashtags=spd&hashtags=seattle")))


                      )
             ),
             
             tabPanel("About",
                      tags$div(
                        "Note: This dashboard is still a work in progress. Please email me if there are specific statistics/maps you'd like to see.",
                        tags$br(), tags$br(),tags$h4("Background"), 
                        "This dashboard grew out of the surge of protests against police brutality against people of color in Seattle and around the United States. 
                        I wondered what the officer-involved shooting data looked like in Seattle and found", 
                        tags$a(href= "https://catalog.data.gov/dataset/spd-officer-involved-shooting-ois-data", "publicly available data"), 
                        "from 2005 until mid-2017. Below is a brief overview of political actions taken by King County and the City of Seattle.",
                        tags$br(),tags$br(),
                        "2017: King County issues a review police inquests, establishing a new process for investigating officer-involved shootings, among other items.",
                        tags$br(), tags$br(),
                        "2018: Voters pass Initiative 940, which would allow for easier prosecution of 'police officers for unjustified shootings of civilians and required independent investigations into 
                        officer-involved use of deadly force.'", tags$a(href="https://sccinsight.com/2020/02/13/seattle-suing-king-county-over-inquest-process/","(Seattle City Council Insight)") ,
                        tags$br(), tags$br(),
                        "2019: The City of Seattle sues King County on behalf of police officers, arguing that the review process from 2017 and the adopted Executive Order is an overreach of power,
                        because it, among other things, calls for a jury to decide whether 'whether the law enforcement member acted pursuant to policy and training' and grants victims' families
                      the right to a lawyer as well as police officers, but only if they agree to be cross-examined.",
                       
                        tags$br(),tags$br(),tags$br(),tags$h4("Sources and Code"),
                        "Code and input data used to generate this Shiny mapping tool are available on ",tags$a(href="https://github.com/m-goggins/spd", "Github."),
                        tags$br(),
                        "The mapping code and color schemes are largely based off of Dr. Edward Parker's work found here: " ,tags$a(href="https://github.com/eparker12/nCoV_tracker", "Github."),
                        tags$br(),
                        "A very helpful and succint analysis of King County and the City of Seattle's inquest process can be found on the ",tags$a(href="https://sccinsight.com/2020/02/13/seattle-suing-king-county-over-inquest-process/","Seattle City Council Insight "),
                        "page.",
                        tags$br(),tags$br(),tags$h4("Contact"),
                        "Marcelle Goggins",tags$br(),
                        "mgoggins@uw.edu",tags$br(),tags$br()
                      )
             )
             
  )
)# End of fluidPage


server = function(input, output, session) {


} #end of Server

shinyApp(ui, server)
