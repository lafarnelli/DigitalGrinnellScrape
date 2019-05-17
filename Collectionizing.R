#Takes in metadata.csv (output from Scraping.R)
#Produces a dataframe for each interesting collection
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

collections <- c("Visualizing Abolition and Freedom",
"Social Gospel",
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

colldf <- data.frame()
colldf$name <- collections
for i in collections{

#Determine the number of objects in each collections
colldf$freq <- length(grep(metadata$item, collections(i)))
}
