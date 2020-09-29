## Here is a sample file of the code used for data filtering after the
## gelocation extraction step. Note that this was an iterative process
## where the steps and filters were very arbtrary, so this code only
## gives an indication of what was done.
library(dplyr)

vegan_data_geopy <- read.csv("finalveganmergeB.csv")

select(vegan_data_geopy, -X, -X.1, -X.2, -Unnamed..0) -> vegan_data_geopy

vegan_data_geopy$location <- unlist(lapply(vegan_data_geopy$location, as.character))
vegan_data_geopy$country <- unlist(lapply(vegan_data_geopy$country, as.character))

vegan_data_geopy %>% 
  group_by(country) %>%
  summarize(count = n()) -> vegan_country_groupings

barplot(height = vegan_country_groupings$count, names.arg = vegan_country_groupings$country)

# Filter out countries not in selected sample and nonsense
vegan_data_geopy %>%
  filter(country != "" & country != "bahamas"
         & country != "barbados" & country != "china"
         & country != "costa rica" & country != "country"
         & country != "https://t.co/cW5qxuNJVQ"
         & country != "https://t.co/HfosZuTvPV"
         & country != "indonesia" & country != "jamaica"
         & country != "jordan" & country != "Kenya"
         & country != "Kingdom of Saudi Arabia"
         & country != "Malaysia" & country != "Libya"
         & country != "Malta" & country != "Panama"
         & country != "Taiwan" & country != "Thailand"
         & country != "United Arab Emirates") -> vegan_data_geopy

# Filter for countries and look at locations
vegan_data_geopy %>% 
  filter(country == "poland") -> test
sample_n(test, size=nrow(test))$location

# Filter out observations where locations are clearly wrong
filter(vegan_data_geopy, location != "Seattle, WA" | country != "poland") -> vegan_data_geopy
filter(vegan_data_geopy, location != "The World" | country != "poland") -> vegan_data_geopy

# Note that lower case letters were kept in the countries to not confuse
# with the observations that had a geolocation country (which were capitalized).
# These could have had nonsence locations but would still have valid country field.


write.csv(vegan_data_geopy, file = "vegan_data.csv")

