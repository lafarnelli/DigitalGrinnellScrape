# DigitalGrinnellScrape : STA-230 Final Project

#### LaAnna Farnelli, Emma Foulkes & Judy Oh

Our project explores and describes the contents of Digital Grinnell, a relatively new platform that features historical materials from College's collections of art, specimens, texts, photography, and other media. Digital Grinnell can be found in its current state at https://digital.grinnell.edu/. Since the library staff have not yet finished digitizing all of the collections they deem relevant for inclusion in Digital Grinnell, the site itself is an incomplete/in-progress data source--but that means our project sets a useful precedent for future projects on the evolving website. 

#### Research Objectives:

We use R for web scraping, data cleaning, text mining, modelling, and data visualization in order to discover and share important trends, themes, and relationships within the DG collections and interpret from those findings some of the institution's values.

#### Our tasks (and associated items in this repository) fall into the following categories:

### Web Scraping and Data Cleaning

##### Scraping Stage One.R; Scraping.R; omitdata.csv

Our data was scraped from Digital Grinnell in two stages (represented in the scripts Scraping Stage One.R and Scraping.R). This was not merely a scrape single table from a webpage; we iteratively scrape data from several indexed webpages, each of which has a metadata table of variable length and detail, and use common metadata across collections in order to perform analysis on the whole site. The first stage took the .csv we exported from Digital Grinnell's search tool and filtered it to useful objects, which weren't corrupt pages or pages requiring log-ins. The second stage took that list of useful webpages and scraped their metadata. 

### Data Visualization

##### app.R; Collections Comparison.Rmd & collections_comparison.html; Dates Comparison.Rmd & dates_comparison.html; Variables Comparison.Rmd & variables_comparison.html

Our data is almost entirely categorical (with the exception of the variable Index Date, which describes the date of an object's creation), and dealing with textual information, so we incorporate several wordclouds assessing different levels and facets of the collections, as well as barplots comparing frequencies of objects across collections and frequencies of topics/themes across objects. 

### Modeling

##### model.R

This stage of analysis provided an opportunity for the "research" requirement of the assignment, as we learned about LDA in order to cluster the language from the College's object descriptions into a few "topics."
