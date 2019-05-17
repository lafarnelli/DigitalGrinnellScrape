#install.packages("dplyr")
#install.packages("tidyr")
#install.packages("tidytext")
#install.packages("httr")
#install.packages("rvest")
#install.packages("RCurl")
#install.packages("tidyverse")
#install.packages("stringr")
library(dplyr)
library(tidyr)
library(tidytext)
library(httr)
library(rvest)
library(RCurl)
library(tidyverse)
library(stringr)

#--------------------------------SCRAPING OBJECT PAGES FROM .CSV------------------------------#
#INCORPORATES .CSV EXPORTED FROM THE SEARCH PAGE (saved in this repo as digitalgrinnell_csv_export.csv)
#https://digital.grinnell.edu/islandora/object/NUMBER is the form all object URLs take

#STEP ONE: FILTER OUT INCOMPATIBLE CASES
#The art objects in Faulconer Gallery are just too different from the rest of the collections,
# and are numerous enough to overwhelm our analysis. Perhaps someone could perform similar
# analyses just on those in the future! We decided to remove them:
data <- digitalgrinnell_csv_export[ -grep("faulconer", digitalgrinnell_csv_export$PID), ]
#These pages all require login by the librarian:
data <- data[ -grep("Alumni oral history interview", data$Description), ]
#This page was under maintenance on the day we ran this scraping script and halted the script bc it had no title:
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

#Save the output so we don't have to run this loop for another 6 hours next time:
write.csv(data2, "H:/data2.csv")
write.csv(data, "H:/data.csv")
write.csv(omitdata, "H:/omitdata.csv") 
#A note: we recognize that the DG website is still under construction and that if we had run this
# scraping script on a different day, we may have filtered out different results. 
# We consider the effects on our analysis to be minimal because there are around 9000 cases, 
# so losing a few here and there should be okay, and because someone else could run the same code in 
# the future and choose different cases to filter. 
