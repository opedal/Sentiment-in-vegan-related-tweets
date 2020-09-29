library(dplyr)
library(rtweet)
api_key <- NA # omitted
api_secret_key <- NA # omitted
access_token <- NA # omitted
access_token_secret <- NA # omitted

token <- create_token(
  app = NA, # omitted
  consumer_key = api_key,
  consumer_secret = api_secret_key,
  access_token = access_token,
  access_secret = access_token_secret)


vegantweets <- search_tweets(q = "vegan OR plantbased OR dairyfree OR wegan
                                   OR vegetali", 
                             token = token, include_rts = T, n = 10000)
# filter out protected users
vegantweets %>% filter(protected == F) -> vegantweets
# drop columns with list elements to save as csv
vegantweets %>%
  select(-mentions_user_id, -mentions_screen_name, -bbox_coords, 
         -coords_coords, -geo_coords, -ext_media_expanded_url,
         -ext_media_t.co, -ext_media_url, -media_type, -media_url,
         -media_expanded_url, -media_t.co, -urls_expanded_url,
         -urls_t.co, -urls_url, -symbols, -hashtags) -> vegantweets

vegan_data <- read.csv("vegan_data.csv")
# remove extra column from csv file
vegan_data <- select(vegan_data, -X)
vegan_data <- rbind(vegantweets, vegan_data)
# distinct on screen_name and tweet text to reduce to almost original number of obs
vegan_data <- distinct(vegan_data, text, screen_name, .keep_all = T)
write.csv(vegan_data, file = "vegan_data.csv")

## Note that the random tweets extracted below were never used in the analysis,
## as we only looked at English tweets and thus never had to correct for 
## language baselines

random_tweets <- stream_tweets(token = token)
# filter out protectes users
random_tweets %>% filter(protected == F) -> random_tweets
# drop columns with list elements to save as csv
random_tweets %>%
  select(-mentions_user_id, -mentions_screen_name, -bbox_coords, 
         -coords_coords, -geo_coords, -ext_media_expanded_url,
         -ext_media_t.co, -ext_media_url, -media_type, -media_url,
         -media_expanded_url, -media_t.co, -urls_expanded_url,
         -urls_t.co, -urls_url, -symbols, -hashtags) -> random_tweets

random_data <- read.csv("random_data.csv")
# remove extra column from csv file
random_data <- select(random_data, -X)
random_data <- rbind(random_tweets, random_data)
random_data <- distinct(random_data, text, screen_name, .keep_all = T)
write.csv(random_data, file = "random_data.csv")
