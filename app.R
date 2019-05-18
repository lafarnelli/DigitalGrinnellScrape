
#install.packages("dplyr")
#install.packages("ggplot2")
#install.packages("readr")
#install.packages("RColorBrewer") 
#install.packages("shiny")
#install.packages("stringr")
#install.packages("tidygraph")
#install.packages("tidyr")
#install.packages("tidytext")
#install.packages("tidyverse")
#install.packages("tm")
#install.packages("wordcloud2")
#install.packages("survey")
#install.packages("memoise")
#install.packages("readxl")
#install.packages("wordcloud")
#install.packages("stats")
#install.packages("DT")
library(DT)
library(dplyr)     
library(ggplot2)   
library(readr)     
library(RColorBrewer)
library(shiny)
library(stringr)
library(tidygraph)
library(tidyr)     
library(tidytext)
library(tidyverse)
library(tm)     
library(wordcloud)
library(wordcloud2)
library(survey)
library(memoise)
library(readxl)
library(stats)
library(markdown)

#For deciding date cutoffs: 
#summary(metadata$date)
#>   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#>   -225    1914    1950    1938    1988    2019    2542 

#import cleaned dataset
data <- metadata #requires that you downloaded metadata and imported it as a dataset
#data <- read.csv("metadata.csv") #requires that the file is saved in the same folder as app.R

#Key:
#first <- -225-1914
#second <- 1915-1950
#third <- 1951-1988
#fourth <- 1989-2019

#-------------------------------------------------------------------------------------------------------------------#
#                                         DATA WRANGLING & CLEANING                                                 #
#-------------------------------------------------------------------------------------------------------------------#

#faceting date into four time periods according to above Key 
as.integer(data$date)
first <- data %>% filter(between(date, -255, 1914))
second <- data %>% filter(between(date, 1915, 1950))
third <- data %>% filter(between(date, 1951, 1988))
fourth <- data %>% filter(between(date, 1989, 2019))

#cleaning date data
first <- first["topic"]
first <- as.String(first$topic)
first <- as.character(first)

second <- second["topic"]
second <- as.String(second$topic)
second <- as.character(second)

third <- third["topic"]
third <- as.String(third$topic)
third <- as.character(third)

fourth <- fourth["topic"]
fourth <- as.String(fourth$topic)
fourth <- as.character(fourth)

#confirming: topic =/= character?
is.character(data$topic)

#transforming to character for word cloud
data$topic <- as.character(data$topic, mode = "list")

#creating dropdown list of time periods
dateranges <<- list("225BC-1914" = first, "1915-1950" = second, "1951-1988" = third, "1989-2019" = fourth)

#cache results to recall again faster
getTermMatrix <- memoise(function(daterange) {
  
  #remove prepositions, punctuation, etc.
  myCorpus = Corpus(VectorSource(daterange))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("SMART"), "and", "but", "the", "from", "a", "are"))
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})

#--------------------------------------------------------------------------------------------------------------------#
#                                             DEFINE USER INTERFACE                                                  #
#--------------------------------------------------------------------------------------------------------------------#
#building app panels / main page / menu options
ui <- navbarPage("Exploring Digital Grinnell",
                 tabPanel("Word Cloud",
                          sidebarLayout(
                            # sidebar with a slider and selection inputs
                            sidebarPanel(
                              selectInput("selection", "Choose a Date Range:",
                                          choices = dateranges),
                              actionButton("update", "Change"),
                              hr(),
                              sliderInput("freq",
                                          "Minimum Frequency:",
                                          min = 1,  max = 50, value = 15),
                              sliderInput("max",
                                          "Maximum Number of Words:",
                                          min = 1,  max = 300,  value = 100)
                            ),
                            # show Word Cloud
                            mainPanel(
                              plotOutput("plot")
                            )
                          )
                 ),
                 #tabs showing Summary, Table, About
                 tabPanel("Summary",
                          verbatimTextOutput("summary")
                 ),
                 #so as not to clutter up tabs, can click on More to access the rest
                 navbarMenu("More",
                            tabPanel("Table",
                                     DT::dataTableOutput("table")
                            ),
                            tabPanel("About",
                                     fluidRow(
                                       h1("About the Data Source"),
                                       br(),
                                       h4("Digital Grinnell contributes to 'free inquiry and the open exchange of ideas' through the 
                                          "), 
                                       h4("preservation and publication of scholarship created by Grinnell College 
                                          students, faculty"), 
                                       h4("and staff, and selected material that illuminates the 
                                          College’s history and other activities."), 
                                       column(3,
                                              img(class="img-polaroid",
                                                  src=paste0("https://digital.grinnell.edu",
                                                             "/sites/all/themes/digital_grinnell_bootstrap/",
                                                             "logo.png")),
                                              tags$small(
                                                "Source: Digital Grinnell ",
                                                a(href="https://digital.grinnell.edu/")
                                              )
                                       )
                                       )
                                     )
                            )
                 )

#--------------------------------------------------------------------------------------------------------------------#
#                                             DEFINE SERVER LOGIC                                                    #
#--------------------------------------------------------------------------------------------------------------------#
server <- function(input, output, session) {
  # define a reactive expression for the document term matrix
  terms <- reactive({
    # change when the "update" button is pressed...
    input$update
    # but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrix(input$selection)
      })
    })
  })
  
  # make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  
  #plot wordcloud + customization 
  output$plot <- renderPlot({
    v <- terms()
    wordcloud_rep(names(v), v, scale=c(4,0.5),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })
  #summary table of data
  output$summary <- renderPrint({
    summary(data)
  })
  #searchable table of data
  output$table <- DT::renderDataTable({
    DT::datatable(data)
  })
}


shinyApp(ui = ui, server = server)
