# DigitalGrinnellScrape : STA-230 Final Project

### For Results See: Final Paper.pdf, variables_comparison.html, collections_comparison.html, dates_comparison.html, app.R

#### LaAnna Farnelli, Emma Foulkes & Judy Oh

Our project explores and describes the contents of Digital Grinnell, a relatively new platform that features historical materials from College's collections of art, specimens, texts, photography, and other media. Digital Grinnell can be found in its current state at https://digital.grinnell.edu/. Since the library staff have not yet finished digitizing all of the collections they deem relevant for inclusion in Digital Grinnell, the site itself is an incomplete/in-progress data source--but that means our project sets a useful precedent for future projects on the evolving website. 

#### Research Objectives:

We use R for web scraping, data cleaning, text mining, modelling, and data visualization in order to discover and share important trends, themes, and relationships within the archival language of Digital Grinnell and interpret from those findings some of the institution's values.

#### Our tasks (and associated items in this repository) fall into the following categories:

### Web Scraping and Data Cleaning

##### Scraping Stage One.R; Scraping.R; omitdata.csv

Our data was scraped from Digital Grinnell in two stages (represented in the scripts Scraping Stage One.R and Scraping.R). This was not merely a single table from a webpage; we iteratively scrape data from several indexed webpages, each of which has a metadata table of variable length and detail, and use common metadata across collections in order to perform analysis on the whole site. The first stage took the .csv we exported from Digital Grinnell's search tool and filtered it to useful objects, which weren't corrupt pages or pages requiring log-ins. The second stage took that list of useful webpages and scraped their metadata.
At various points we perform string manipulations to subset our data by collection and to make cases compatible for our wordclouds or for our model.

### Data Visualization

##### app.R; Collections Comparison.Rmd; Dates Comparison.Rmd; Variables Comparison.Rmd

Our data is almost entirely categorical and textual, so we incorporate several wordclouds assessing different levels and facets of the collections, as well as barplots comparing frequencies of objects across collections and frequencies of topics/themes across objects. 

### Modeling

##### model.R; LDAGibbs 3 TopicsToTerms.csv

Our implementation of a Latent Dirichlent Allocation model with Gibbs sampling on our data. Output gives the highest-probability words for each of the underlying "topics" the model found within Descriptions of items. 
