install.packages("dplyr")
install.packages("tidyr")
install.packages("tidytext")
install.packages("httr")
install.packages("rvest")
install.packages("RCurl")
install.packages("tidyverse")
install.packages("stringr")
library(dplyr)
library(tidyr)
library(tidytext)
library(httr)
library(rvest)
library(RCurl)
library(tidyverse)
library(stringr)

#--------------------------------HTTR SCRAPING FROM HOME PAGE--------------------------------#
#url <- 'https://digital.grinnell.edu/'
#website1 <- GET(url) 
#print(content(website1))

#titles1 <- html_nodes(content(website1), "h1")
#print(html_text(titles1)[[1]]) # "Welcome to Digital Grinnell"

#titles2 <- html_nodes(content(website1), "h2")
#print(html_text(titles2)[[1]]) # "Browse by Collection"
#print(html_text(titles2)[[2]]) # "Collection Search"
#print(html_text(titles2)[[3]]) # "User Login"

#titles <- html_nodes(content(website1), "h3")
#print(html_text(titles)[[1]]) # "Scholarship at Grinnell"
#print(html_text(titles)[[2]]) # "Special Collections and Archives"
#print(html_text(titles)[[3]]) # "Faulconer Art"
#print(html_text(titles)[[4]]) # "Grinnell College Campus Collections"
#print(html_text(titles)[[5]]) # "Social Justice at Grinnell"
#print(html_text(titles)[[6]]) # "Poweshiek History Preservation Project"
#print(html_text(titles)[[7]]) # "Alumni Oral Histories"
#---------------------------------------------------------------------------------------------#


#--------------------------------SCRAPING OBJECT PAGES FROM .CSV------------------------------#
#INCORPORATING .CSV EXPORTED FROM THE SEARCH PAGE
#https://digital.grinnell.edu/islandora/object/NUMBER is the form all object URLs take

#STEP ONE: FILTER OUT FAULCONER & ALUMNI ORAL HISTORIES
data <- csv_export_1556812852[ -grep("faulconer", csv_export_1556812852$PID), ]
data <- data[ -grep("Alumni oral history interview", data$Description), ]
data <- data[ -grep("Disruptive Mood Dysregulation Disorder and What a Good Day Looks Like", data$Title), ]

#REMOVE FIRST 34 CASES (COLLECTIONS, NOT OBJECTS)
data2 <- data[-c(1:34),]

#STEP TWO: EXTRACT URLs
urls <- paste("https://digital.grinnell.edu/islandora/object/",data2$PID, sep="")

#REMOVE NULL PAGES and PAGES REQUIRING LOGIN
omitdata <- data.frame()
for (i in 1:length(urls)) {
  if (is.null(content(GET(urls[i])))){
    omitdata <- rbind(omitdata, data2[i,])
  }
  else{
    website1 <- GET(urls[i]) 
    #print(content(website1))
    titles1 <- html_nodes(content(website1), "h1")
    if( "My Account" == html_text(titles1)[[1]]){
      omitdata <- rbind(omitdata, data2[i,])
    }
  }
}

data2 <- data2[!(data2$PID %in% omitdata$PID),]

write.csv(data2, "H:/data2.csv")
write.csv(data, "H:/data.csv")
write.csv(omitdata, "H:/omitdata.csv")
