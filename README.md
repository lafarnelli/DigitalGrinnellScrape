# DigitalGrinnellScrape : STA-230 Final Project

#### LaAnna Farnelli, Emma Foulkes & Judy Oh

Our project aims to explore, describe and analyze the contents of Digital Grinnell, a relatively new platform that features historical materials from Grinnell's archives in the form of art, specimen, books, and manuscript collections. Digital Grinnell can be found in its current state at https://digital.grinnell.edu/. Since the library staff have not yet finished digitizing all of the collections they deem relevant for inclusion in Digital Grinnell, the site itself is an incomplete/in-progress data source--but that means our project sets a useful precedent for future projects on the evolving website. Our goal is to find important trends, relationships, and results in DG and then communicate them to a general audience using the visualization and analysis skills we have learned over the course of this semester. 


#### Our project aims to satisfy the following requirements, according to the assignment rubric:

### Web Scraping

Our data was scraped from Digital Grinnell in two stages (represented in the scripts Scraping Stage One.R and Scraping.R). This was not merely a scrape single table from a webpage; we iteratively scrape data from several indexed webpages, each of which has a metadata table of variable length and detail, and use common metadata across collections in order to perform analysis on the whole site. 

### Data Processing & Cleaning

The specimens included in DG do not all have the same metadata, not all of the metadata will be useful, and we might not scrape it all cleanly on our first run-through. We expect to use string manipulations at the very least, and most likely to derive new variables.

### Data Visualization

Our data is almost entirely categorical (with the exception of the variable Index Date, which describes the date of an object's creation), and dealing with textual information, so we incorporate several wordclouds assessing different levels and facets of the collections, as well as barplots comparing frequencies of objects across collections and frequencies of topics/themes across objects. 

### Modeling

This stage of analysis provided an opportunity for the "research" requirement of the assignment, as we learned about LDA in order to cluster the language from the College's object descriptions into a few "topics."
