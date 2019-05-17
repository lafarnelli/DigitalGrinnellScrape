#Takes in metadata.csv (output from Scraping.R)
#function getCol Produces a dataframe for each interesting collection (takes a string as input)
#function getColSize Produces size of that collection
#For use in collection-level analysis

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
library(dplyr)
library(tidyr)
library(tidytext)
library(httr)
library(rvest)
library(RCurl)
library(tidyverse)
library(stringr)

collections <- c("Social Gospel", #34
  "Scholarship at Grinnell",
  "Student Scholarship",
  "Faculty Scholarship",
  "Syllabi and Curricular Materials",
  "Early College History",
  "G.W. Cook Correspondence",
  "Grinnell College Buildings",
  "Historic Iowa Postcards",
  "Jimmy Ley Collection",
  "Kleinschmidt Architectural History",
  "Life at Grinnell College",
  "Social Gospel",
  "Grinnell College Geology Collection",
  "Visualizing Abolition and Freedom",
  "Ancient Coins",
  "Social Justice at Grinnell",
  "Poweshiek History Preservation Project")


temp <- data.frame()

getCol<-function(str){
  temp <- metadata[grep(collections[1], metadata$item),]
}

getColSize<-function(str){
  temp <- metadata[grep(collections[1], metadata$item),]
  length(temp)
}

