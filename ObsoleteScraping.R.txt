install.packages("dplyr")
install.packages("tidyr")
install.packages("tidytext")
install.packages("httr")
install.packages("rvest")
install.packages("RCurl")
install.packages("tidyverse")
install.packages("stringr")
install.packages("foreach")
library(dplyr)
library(tidyr)
library(tidytext)
library(httr)
library(rvest)
library(RCurl)
library(tidyverse)
library(stringr)
library(foreach)

#Requires data2.csv file (output from Scraping Stage One) as input!

#EXTRACT URLs
urls <- paste("https://digital.grinnell.edu/islandora/object/",data2$PID, sep="")

#DEFINE FUNCTION TO APPLY TO AN OBJECT

f1 <- function (Url) {
  webpage <- GET(Url)
  #print(content(webpage))
  html_nodes(content(webpage), "table")[[1]] %>%
    html_table()
  #print(html_text(metadata)[[1]])
  #return(metadata)
}

## creates a blank data frame to be added to in the for loop
title <- data.frame()
publisher <- data.frame() 
date <- data.frame()  

## for loop for adding in the rows of the desired metadata characteristic
for (i in 1:100) { #change number later
  copy <- data.frame(f1(urls[i]))
  
  if(length(grep("Title", copy$X1)) > 0){
    pos_title <- which(copy$X1 == "Title") ## locates the row with an entry of title
    pos1_title <- copy[pos_title,] ## removes the row with entry title
    ## collapses multiple entries of title into one row, separates entries using ,
    pos1_title <- pos1_title %>% group_by(X1) %>% summarise(X2 = paste(X2, collapse = ", "))
  }
  else{ ## creates a row with a null entry for title
    pos1_title <- data.frame("X1" =c("Title"), X2 = c("NA"))
  }
  ## stacks all rows together for overall title dataframe
  title <- rbind(title, pos1_title)
  
  ## runs through same code for publisher to create a dataframe with publisher metadata
  if(length(grep("Publisher", copy$X1)) > 0){
    pos_pub <- which(copy$X1 == "Publisher")
    pos1_pub <- copy[pos_pub,]
    pos1_pub <- pos1_pub %>% group_by(X1) %>% summarise(X2 = paste(X2, collapse = ", "))
  }
  else{
    pos1_pub <- data.frame("X1" =c("Publisher"), X2 = c("NA"))
  }
  
  publisher <- rbind(publisher, pos1_pub)
  
  ## runs through same code for index date to create a dataframe with index date metadata
  if(length(grep("Index Date", copy$X1)) > 0){
    pos_date <- which(copy$X1 == "Index Date")
    pos1_date <- copy[pos_date,]
    pos1_date <- pos1_date %>% group_by(X1) %>% summarise(X2 = paste(X2, collapse = ", "))
  }
  else{
    pos1_date <- data.frame("X1" =c("Index Date"), X2 = c("NA"))
  }
  
  date <- rbind(date, pos1_date)
}

## binds all meta data tables together by column
metadata <- cbind(title, publisher, date)





