library(readr)
library(dplyr, warn.conflicts = F)

collaborations = read_csv("/Users/nazareno/Dropbox/ismir-data/Paper-Collab/jazz/ready-to-model.csv", col_names = TRUE)
collaborations = collaborations[-1,]

names(collaborations) = c("collab_id", 
                          "artist_id", 
                          "collaboration", 
                          "collaborator", 
                          "artist", 
                          "year", 
                          "album", 
                          "tags")

collaborations = collaborations[grepl(
  "bass|guitar|drum|vocal|voic|percuss|keyboard|trumpet|sax|saxophon|trombon|flute|synthes|piano",
  tolower(collaborations$collaboration)
), ] %>% 
  mutate(year = substr(year, 1, 4))

collaborations %>% 
  filter(collaborator == "Eric Dolphy") %>% 
  select(collaborator, artist, year) %>% # put album in for more info
  filter(year <= 1964) %>% # year of death
  distinct() %>% 
  arrange(year) %>% 
  View()

collaborations %>% 
  filter(collaborator == "Herbie Hancock") %>% 
  select(collaborator, artist, year) %>% # put album in for more info
  filter(year <= 1990) %>% # year of death
  distinct() %>% 
  arrange(year) %>% 
  View()