
get_environment_labels = function(){
  library(tibble)
  labels = data_frame(topic = 0:29, label = "unlabeled")
  labels[labels$topic == 0, "label"] = "Funk, fusion & soul jazz"
  labels[labels$topic == 1, "label"] = "Free/improv. contemporary"
  labels[labels$topic == 2, "label"] = "European big bands in 50/60s"
  labels[labels$topic == 3, "label"] = "Free/improv. Contemporary London Big bands"
  labels[labels$topic == 4, "label"] = "50s, 60s US big bands"
  labels[labels$topic == 5, "label"] = "Avant garde A"
  labels[labels$topic == 6, "label"] = "Swing era around Duke"
  labels[labels$topic == 7, "label"] = "Swing era around Louis A."
  labels[labels$topic == 8, "label"] = "Cool jazz"
  labels[labels$topic == 9, "label"] = "Contemporary European ensembles"
  labels[labels$topic == 10, "label"] = "Cool and bop"
  labels[labels$topic == 11, "label"] = "Fusion, smooth, rock jazz"
  labels[labels$topic == 12, "label"] = "US Big Bands related to Stan Kenton"
  labels[labels$topic == 13, "label"] = "Avant garde B"
  labels[labels$topic == 14, "label"] = "Swing era around Count Basie"
  labels[labels$topic == 15, "label"] = "Easy listening Big Bands"
  labels[labels$topic == 16, "label"] = "Fusion and Post/hard bop"
  labels[labels$topic == 17, "label"] = "Mostly french"
  labels[labels$topic == 18, "label"] = "Brazilian jazz"
  labels[labels$topic == 20, "label"] = "Italian + Chet"
  labels[labels$topic == 23, "label"] = "Contemporary Big Bands"
  labels[labels$topic == 25, "label"] = "Central European contemporary"
  labels[labels$topic == 26, "label"] = "Swedish"
  labels[labels$topic == 27, "label"] = "Bebop A"
  labels[labels$topic == 28, "label"] = "Free jazz A"
  labels[labels$topic == 29, "label"] = "Bebop B"
  return(labels)
}

create_probabilitiesdf = function(summariesdf,
                                  label_artists = "artist",
                                  label_user = "collaborator") {
  library(reshape2)
  library(dplyr, warn.conflicts = F)
  u = summariesdf %>% 
    melt(id.vars = "topic", measure.vars = paste0("TopUser_", 0:9), 
         variable.name = "type", value.name = "node")
  o = summariesdf %>% 
    melt(id.vars = "topic", measure.vars = paste0("TopObj_", 0:9), 
         variable.name = "type", value.name = "node")
  p_zu = summariesdf %>% 
    melt(id.vars = "topic", measure.vars = paste0("Pzu_", 0:9), 
         variable.name = "where", value.name = "probability")
  p_zo = summariesdf %>% 
    melt(id.vars = "topic", measure.vars = paste0("Poz_", 0:9), 
         variable.name = "where", value.name = "probability")
  answer = rbind(u, o)
  answer$probability = c(p_zu$probability, p_zo$probability)
  # answer$connection = 
  #   x = answer$type %>% 
  #   as.character() %>% 
  #   strsplit("_", fixed = TRUE)
  return(answer)
}

create_pztoa = function(summaries){
  names(summaries)[1] = "topic"
  summaries$topic = as.numeric(substr(summaries$topic, 3, 5))
  return(create_probabilitiesdf(summaries))
}

create_entropy_az = function(data){
  names(data) = c("environment", "entropy")
  data$topic = as.numeric(substr(data$environment, 3, 5))
  return(data)
}

summarise_collaboration_data = function(){
  #'Offline processing of poster data to generate files used in the 
  #'shiny demos.
  library(readr)
  library(dplyr, warn.conflicts = F)
  
  # Whom to focus on
  flog.info("Reading summaries")
  prob_ztoa = read_delim("../../data/poster-jazz-trajs/SummaryMachineReadableNew.dat", delim = "\t") %>% 
    create_pztoa()
  artists = prob_ztoa %>% 
    filter(grepl("TopObj", type)) %>% 
    select(topic, node, probability)
  collaborators = prob_ztoa %>% 
    filter(grepl("User", type)) %>% 
    select(topic, node)
  
  # Collaboration data
  collaborations = read_csv("../../data/poster-jazz-trajs/Collaborations.csv")
  
  artist_activity = data.frame()
  for (i in 0:29) {
    topic_activity = summarise_artist_collabs(artists[artists$topic == i, "node"], 
                                              collaborations) %>% 
      cbind(topic = i)
    artist_activity = rbind(artist_activity, topic_activity)
  }
  
  topic_tags = summarise_tags(collaborations, artists) 
  collaborator_instruments = collaborations %>% 
    count(collaborator, collaboration, sort = T) %>% 
    group_by(collaborator) %>% 
    slice(1)
  
  write_csv(artist_activity, "most-probable-artists-activity.csv")
  write_csv(collaborator_instruments %>% select(1,2), "most-common-collaborator-instrument.csv")
  write_csv(topic_tags, "tag-frequency-for-most-probable.csv")
}


summarise_tags = function(collaboration_subset, paz_df){
  library(stringr)
  per_artist = collaboration_subset %>%
    select(artist, album, tags) %>% 
    distinct() %>% 
    group_by(artist) %>% 
    do(str_split(.$tags, pattern = "', '") %>% 
         unlist() %>% 
         str_replace_all("['\\[\\]]", "") %>% 
         table() %>% 
         as.data.frame())
  relative_freqs = per_artist %>%
    filter(`.` != "Jazz") %>% 
    group_by(artist) %>%
    mutate(Freq = Freq / sum(Freq))
  answer = inner_join(paz_df, relative_freqs, by = c("node" = "artist"))
  names(answer)[4] = "tag"
  profiles = answer %>%
    group_by(topic, tag) %>%
    summarise(importance = sum(probability * Freq))
  return(profiles)
}

summarise_artist_collabs = function(artist_names, collaboration_df){
  collaboration_df %>% 
    filter(artist %in% artist_names) %>% 
    group_by(artist) %>% 
    mutate(year = ifelse(0, NA, year)) %>% 
    summarise(earliest = min(year, na.rm = TRUE), 
              count = n())
}
