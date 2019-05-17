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
                 "Scholarship at Grinnell", #1
                 "Student Scholarship", #94
                 "Faculty Scholarship", #85
                 "Syllabi and Curricular Materials", #0
                 "Early College History", #49
                 "G.W. Cook", #0
                 "Buildings", #47
                 "Postcards", #6
                 "Ley", #0
                 "Kleinschmidt", #57
                 "Life at Grinnell College", #386
                 "Geology", #0
                 "Abolition and Freedom", #0
                 "Coins", #0
                 "Social Justice at Grinnell", #49
                 "Poweshiek History Preservation Project" #1983
                 )


temp <- data.frame()

getCol<-function(str){
  temp <- metadata[grep(collections[2], metadata$item),]
}

temp.social <- metadata[grep(collections[1], metadata$item),]
temp.scholar <- metadata[grep(collections[2], metadata$item),]
temp.sscholar <- metadata[grep(collections[3], metadata$item),]
temp.fscholar <- metadata[grep(collections[4], metadata$item),]
temp.syllabi <- metadata[grep(collections[5], metadata$item),]
temp.early <- metadata[grep(collections[6], metadata$item),]
temp.cook <- metadata[grep(collections[7], metadata$item),]
temp.build <- metadata[grep(collections[8], metadata$item),]
temp.postcards <- metadata[grep(collections[9], metadata$item),]
temp.ley <- metadata[grep(collections[10], metadata$item),]
temp.klein <- metadata[grep(collections[11], metadata$item),]
temp.life <- metadata[grep(collections[12], metadata$item),]
temp.geology <- metadata[grep(collections[13], metadata$item),]
temp.abolition <- metadata[grep(collections[14], metadata$item),]
temp.coins <- metadata[grep(collections[15], metadata$item),]
temp.justice <- metadata[grep(collections[16], metadata$item),]
temp.history <- metadata[grep(collections[17], metadata$item),]

getColSize<-function(str){
  temp <- metadata[grep(collections[1], metadata$item),]
  length(temp)
}
