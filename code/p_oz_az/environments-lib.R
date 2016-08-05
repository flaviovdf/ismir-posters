
get_environment_labels = function(){
  library(tibble)
  labels = data_frame(topic = 0:29, label = "unlabeled")
  labels[labels$topic == 3, "label"] = "Free/Improv. Big bands in London"
  labels[labels$topic == 4, "label"] = "50s, 60s big bands"
  labels[labels$topic == 5, "label"] = "Experimental"
  labels[labels$topic == 8, "label"] = "CHET BRUBECK MILES MULLIGAN"
  labels[labels$topic == 18, "label"] = "Brazilian jazz"
  labels[labels$topic == 20, "label"] = "Italian + Chet"
  labels[labels$topic == 23, "label"] = "Big bands (WE?)"
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
    select(topic, node)
  collaborators = prob_ztoa %>% 
    filter(grepl("User", type)) %>% 
    select(topic, node)
  
  # Collaboration data
  collaborations = read_csv("../../data/poster-jazz-trajs/Collaborations.csv")
  
  artist_activity = data.frame()
  topic_tags = data.frame()
  for (i in 0:29) {
    this_topic = collaborations %>% 
      filter(artist %in% artists[artists$topic == i, "node"]) %>% 
      summarise_tags() %>% 
      mutate(topic = i)
    topic_tags = rbind(topic_tags, this_topic)
    
    topic_activity = summarise_artist_collabs(artists[artists$topic == i, "node"], 
                                              collaborations) %>% 
      cbind(topic = i)
    artist_activity = rbind(artist_activity, topic_activity)
  }
  names(topic_tags)[1] = "tag"
  write_csv(artist_activity, "most-probable-artists-activity.csv")
  write_csv(topic_tags, "tag-frequency-for-most-probable.csv")
}


# TODO Weighted sum somewho
summarise_tags = function(collaboration_subset){
  library(stringr)
  all = collaboration_subset$tags %>%
    str_split(pattern = "', '") %>% 
    unlist() %>% 
    str_replace_all("['\\[\\]]", "") %>% 
    table() %>% 
    as.data.frame()
  return(all)
}

summarise_artist_collabs = function(artist_names, collaboration_df){
  collaboration_df %>% 
    filter(artist %in% artist_names) %>% 
    group_by(artist) %>% 
    mutate(year = ifelse(0, NA, year)) %>% 
    summarise(earliest = min(year, na.rm = TRUE), 
              count = n())
}
