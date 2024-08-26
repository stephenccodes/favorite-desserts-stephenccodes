
library(here)
library(tidyverse)

fav_desserts <- read_csv(here("favorite_desserts.csv"))


library(tidyverse)
library(rvest)  # used to scrape website content

# Check if that data folder exists and creates it if not
dir.create("data", showWarnings = FALSE)

# Read the webpage code
webpage <- read_html("https://www.eatthis.com/iconic-desserts-united-states/")

# Extract the desserts listing
dessert_elements<- html_elements(webpage, "h2")
dessert_listing <- dessert_elements %>% 
  html_text2() %>%             # extracting the text associated with this type of element of the webpage
  as_tibble() %>%              # make it a data frame
  rename(dessert = value) %>%  # better name for the column
  head(.,-3) %>%               # 3 last ones were not desserts 
  rowid_to_column("rank") %>%  # adding a column using the row number as a proxy for the rank
  write_csv("data/iconic_desserts.csv") # save it as csv

iconic_desserts <- read_csv(here("favorite_desserts.csv"))


for (i in fav_desserts$Favorite_dessert) {
  if (str_split_1(i[[1]], " ")[1] %in% dessert_listing$dessert) {
    print(paste(i, " is in the iconic list"))
  }  
}


inner_join(dessert_listing, fav_desserts, join_by(Favorite_dessert == dessert))
