install.packages("dplyr")
install.packages("ggplot2")
install.packages("readr")
install.packages("RColorBrewer") 
install.packages("shiny")
install.packages("stringr")
install.packages("tidygraph")
install.packages("tidyr")
install.packages("tidytext")
install.packages("tidyverse")
install.packages("tm")
install.packages("wordcloud2")
install.packages("survey")
install.packages("memoise")
install.packages("readxl")
install.packages("wordcloud")
install.packages("stats")
install.packages("DT")
install.packages("plotly")
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
library(plotly)


#import cleaned dataset
data <- read.csv("~/Desktop/metadata.csv") 
#requires that you downloaded metadata and imported it as a dataset
#data <- read.csv("metadata.csv") #requires that the file is saved in the same folder as app.R

#Key:
#first <- 1840-1900
#second <- 1901-1950
#third <- 1951-2000
#fourth <- 2001-2019

#------------------------------------------------------------------------------------------------global


first <- data %>% filter(between(date, 1840, 1900))
second <- data %>% filter(between(date, 1901, 1950))
ggplot(data=second) + geom_histogram(mapping = aes(date))
third <- data %>% filter(between(date, 1951, 2000))
ggplot(data=third) + geom_histogram(mapping = aes(date))
fourth <- data %>% filter(between(date, 2001, 2019))
ggplot(data=fourth) + geom_histogram(mapping = aes(date))


#faceting date into four time periods according to above Key 
as.integer(data$date)
first <- data %>% filter(between(date, 1840, 1900))
second <- data %>% filter(between(date, 1901, 1950))
third <- data %>% filter(between(date, 1951, 2000))
fourth <- data %>% filter(between(date, 2001, 2019))

#cleaning description data
first <- first["Description"]
first <- as.String(first$Description)
first <- as.character(first)

second <- second["Description"]
second <- as.String(second$Description)
second <- as.character(second)

third <- third["Description"]
third <- as.String(third$Description)
third <- as.character(third)

fourth <- fourth["Description"]
fourth <- as.String(fourth$Description)
fourth <- as.character(fourth)

# contains characters?
is.character(data$Title)
#no
is.character(data$Description)
#yes
is.character(data$topic)
#no

#creating dropdown list of time periods
dateranges <<- list("1840-1900" = first, "1901-1950" = second, "1951-2000" = third, "2001-2019" = fourth)

#cache results to recall again faster
getTermMatrix <- memoise(function(daterange) {
  #if (!(daterange %in% dateranges))
  #stop("Unknown daterange")
  
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


#------------------------------------------------------------------------------------------------ui

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
                            tabPanel("Visual Summaries",
                                     plotlyOutput("plot2"),
                                     plotlyOutput("plot3"),
                                     plotlyOutput("plot4"),
                                     plotlyOutput("plot5")
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

#------------------------------------------------------------------------------------------------server
server <- function(input, output) {
  # Define a reactive expression for the document term matrix
  terms <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrix(input$selection)
      })
    })
  })
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  
  output$plot <- renderPlot({
    v <- terms()
    wordcloud_rep(names(v), v, scale=c(5,0.5),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })
  output$summary <- renderPrint({
    summary(data)
  })
  output$table <- DT::renderDataTable({
    DT::datatable(data)
  })
  output$plot2 <- renderPlotly({
    print(
      ggplotly(
      ggplot(data=first) +                         
    geom_histogram(mapping = aes(first$date), 
                   binwidth = NULL, bins = 20, col="red", fill="lightblue") + 
    geom_density(mapping = aes(x=first$date, y = (..count..)))  +   
    labs(title="Figure 9: Housing Prices in Ames, Iowa (in $100,000)", 
         x="Sale Price of Individual Homes")))
  })
  output$plot3 <- renderPlotly({
    print(
      ggplotly(
        ggplot(data=second) +                         
          geom_histogram(mapping = aes(second$date), 
                         binwidth = NULL, bins = 20, col="red", fill="lightblue") + 
          geom_density(mapping = aes(x=second$date, y = (..count..)))  +   
          labs(title="Figure 9: Housing Prices in Ames, Iowa (in $100,000)", 
               x="Sale Price of Individual Homes")))
  })
  output$plot4 <- renderPlotly({
    print(
      ggplotly(
        ggplot(data=third) +                         
          geom_histogram(mapping = aes(third$date), 
                         binwidth = NULL, bins = 20, col="red", fill="lightblue") + 
          geom_density(mapping = aes(x=third$date, y = (..count..)))  +   
          labs(title="Figure 9: Housing Prices in Ames, Iowa (in $100,000)", 
               x="Sale Price of Individual Homes")))
  })
  output$plot5 <- renderPlotly({
    print(
      ggplotly(
        ggplot(data=fourth) +                         
          geom_histogram(mapping = aes(fourth$date), 
                         binwidth = NULL, bins = 20, col="red", fill="lightblue") + 
          geom_density(mapping = aes(x=fourth$date, y = (..count..)))  +   
          labs(title="Figure 9: Housing Prices in Ames, Iowa (in $100,000)", 
               x="Sale Price of Individual Homes")))
  })
}


#------------------------------------------------------------------------------------------------run app!!!

shinyApp(ui = ui, server = server)
