#install.packages("dplyr")
#install.packages("foreach")
#install.packages("tidyr")
#install.packages("tidytext")
#install.packages("httr")
#install.packages("rvest")
#install.packages("RCurl")
#install.packages("tidyverse")
#install.packages("stringr")
#install.packages("doParallel")
library(doParallel) 
library(foreach)
library(dplyr)
library(tidyr)
library(tidytext)
library(httr)
library(rvest)
library(RCurl)
library(tidyverse)
library(stringr)
## THIS SCRIPT ASSUMES WE HAVE ALREADY CONTSTRUCTED "data2.csv" -- MUST HAVE ALREADY RUN SCRAPING STAGE ONE
## BEFORE RUNNING, NEED TO SET PRIORITY OF RSTUDIO TO HIGH IN TASK MANAGER (task manager -> details -> rstudio -> priority)

#EXTRACT URLs using the pattern we observed by looking through a few different object pages on the site:
urls <- paste("https://digital.grinnell.edu/islandora/object/",data2$PID, sep="")

#We chose to use parallellization in order to avoid any more 7-hour loops. A useful skill!
myCluster <- makeCluster(5)   ## Determines the number of clusters to use in parallel
registerDoParallel(myCluster)

## Function for extracting metadata from the url
f1 <- function (Url) {
  webpage <- GET(Url)
  #print(content(webpage))
  html_nodes(content(webpage), "table")[[1]] %>%
    html_table()
  #print(html_text(metadata)[[1]])
  #return(metadata)
}

## Foreach loop using parallel processing, must list all used packages and specify way to combine at end
alttitle <- foreach(i=1:length(urls),.combine = rbind, .packages = c("httr", "dplyr", "RCurl", "rvest", 
                                        "tidyr", "tidytext", "tidyverse", "stringr")) %dopar% {
  
  ## creates a data frame of the metadata taken from url
  copy <- data.frame(f1(urls[i]))
  
  ## determines if the desired data is in the table and extracts corresponding rows if it is
  if(length(grep("Alternative Title", copy$X1)) > 0){
    pos_alttitle <- which(copy$X1 == "Alternative Title") 
    pos1_alttitle <- copy[pos_alttitle,] 
    ## condenses metadata with multiple rows and lists using a comma as the separator
    pos1_alttitle <- pos1_alttitle %>% group_by(X1) %>% summarise(X2 = paste(X2, collapse = ", "))
  }
  ## if no row exists, creates a row and enters NA as the value
  else{
    pos1_alttitle <- data.frame("X1" =c("Alternative Title"), X2 = c("NA"))
  }
}  

write.csv(alttitle, "H:/alttitle.csv")

## runs through same code for publisher to create a dataframe with publisher metadata
publisher <- foreach(i=1:length(urls),.combine = rbind, .packages = c("httr", "dplyr", "RCurl", "rvest", "tidyr", 
                                                                      "tidytext", "tidyverse", "stringr")) %dopar% {
                                                                    
  copy <- data.frame(f1(urls[i]))  
  
  if(length(grep("Publisher", copy$X1)) > 0){
    pos_pub <- which(copy$X1 == "Publisher")
    pos1_pub <- copy[pos_pub,]
    pos1_pub <- pos1_pub %>% group_by(X1) %>% summarise(X2 = paste(X2, collapse = ", "))
  }
  else{
    pos1_pub <- data.frame("X1" =c("Publisher"), X2 = c("NA"))
  }
}

write.csv(publisher, "H:/publisher.csv")
  
## runs through same code for index date to create a dataframe with index date metadata
date <- foreach(i=1:length(urls),.combine = rbind, .packages = c("httr", "dplyr", "RCurl", "rvest","tidyr", 
                                                                 "tidytext", "tidyverse", "stringr")) %dopar% {
                                                                       
  copy <- data.frame(f1(urls[i]))
                                                                       
  if(length(grep("Index Date", copy$X1)) > 0){
    pos_date <- which(copy$X1 == "Index Date")
    pos1_date <- copy[pos_date,]
    pos1_date <- pos1_date %>% group_by(X1) %>% summarise(X2 = paste(X2, collapse = ", "))
  }
  else{
    pos1_date <- data.frame("X1" =c("Index Date"), X2 = c("NA"))
  }
}  

write.csv(date, "H:/date.csv")
                                                                   
## runs through same code for related item to create a dataframe with metadata
item <- foreach(i=1:length(urls),.combine = rbind, .packages = c("httr", "dplyr", "RCurl", "rvest","tidyr", 
                                                                 "tidytext", "tidyverse", "stringr")) %dopar% {
                                                                   
  copy <- data.frame(f1(urls[i]))
                                                                   
  if(length(grep("Related Item", copy$X1)) > 0){
    pos_item <- which(copy$X1 == "Related Item")
    pos1_item <- copy[pos_item,]
    pos1_item <- pos1_item %>% group_by(X1) %>% summarise(X2 = paste(X2, collapse = ", "))
  }
  else{
    pos1_item <- data.frame("X1" =c("Related Item"), X2 = c("NA"))
  }
}

write.csv(item, "H:/item.csv")
  
## runs through same code for related item to create a dataframe with metadata
key <- foreach(i=1:length(urls),.combine = rbind, .packages = c("httr", "dplyr", "RCurl", "rvest","tidyr", 
                                                                 "tidytext", "tidyverse", "stringr")) %dopar% {
                                                                   
  copy <- data.frame(f1(urls[i]))
                                                                   
  if(length(grep("Keyword", copy$X1)) > 0){
    pos_key <- which(copy$X1 == "Keyword")
    pos1_key <- copy[pos_key,]
    pos1_key <- pos1_key %>% group_by(X1) %>% summarise(X2 = paste(X2, collapse = ", "))
  }
  else{
    pos1_key <- data.frame("X1" =c("Keyword"), X2 = c("NA"))
  }
}

write.csv(key, "H:/key.csv")

## runs through same code for type of resource to create a dataframe with metadata
resource <- foreach(i=1:length(urls),.combine = rbind, .packages = c("httr", "dplyr", "RCurl", "rvest","tidyr", 
                                                                 "tidytext", "tidyverse", "stringr")) %dopar% {
                                                                   
  copy <- data.frame(f1(urls[i]))
                                                                   
  if(length(grep("Type of Resource", copy$X1)) > 0){
    pos_resource <- which(copy$X1 == "Type of Resource")
    pos1_resource <- copy[pos_resource,]
    pos1_resource <- pos1_resource %>% group_by(X1) %>% summarise(X2 = paste(X2, collapse = ", "))
  }
  else{
    pos1_resource <- data.frame("X1" =c("Type of Resource"), X2 = c("NA"))
  }
}

write.csv(resource, "H:/resource.csv")
  
## runs through same code for topic to create a dataframe with metadata
topic <- foreach(i=1:length(urls),.combine = rbind, .packages = c("httr", "dplyr", "RCurl", "rvest","tidyr", 
                                                                 "tidytext", "tidyverse", "stringr")) %dopar% {
                                                                   
  copy <- data.frame(f1(urls[i]))
                                                                   
  if(length(grep("Topic", copy$X1)) > 0){
    pos_topic <- which(copy$X1 == "Topic")
    pos1_topic <- copy[pos_topic,]
    pos1_topic <- pos1_topic %>% group_by(X1) %>% summarise(X2 = paste(X2, collapse = ", "))
  }
  else{
    pos1_topic <- data.frame("X1" =c("Topic"), X2 = c("NA"))
  }
}

write.csv(topic, "H:/topic.csv")
  
## runs through same code for geographic to create a dataframe with metadata
geo <- foreach(i=1:length(urls),.combine = rbind, .packages = c("httr", "dplyr", "RCurl", "rvest","tidyr", 
                                                                 "tidytext", "tidyverse", "stringr")) %dopar% {
                                                                   
  copy <- data.frame(f1(urls[i]))
                                                                   
  if(length(grep("Geographic", copy$X1)) > 0){
    pos_geo <- which(copy$X1 == "Geographic")
    pos1_geo <- copy[pos_geo,]
    pos1_geo <- pos1_geo %>% group_by(X1) %>% summarise(X2 = paste(X2, collapse = ", "))
  }
  else{
    pos1_geo <- data.frame("X1" =c("Geographic"), X2 = c("NA"))
  }
}

write.csv(geo, "H:/geo.csv")

## binds all meta data tables together by column
metadata <- cbind(alttitle, publisher, date, item, key, resource, topic, geo)

## removing all odd columns which are extrenous titles
cleaned <- metadata[,seq(2, ncol(metadata), by=2)] 

## rewriting the column names in order to label the variables
names(cleaned) <- c("alttitle", "publisher", "date", 
                    "item", "key", "resource", "topic", "geo")

metadata <- cbind(data2, cleaned)

## Removes unnecessary columns
metadata <- metadata[,-1]
metadata <- metadata[,-4]
metadata <- metadata[,-12]

write.csv(metadata, "H:/metadata.csv")
