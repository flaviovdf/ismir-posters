
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

get_gene_labels = function(){
  labels = structure(list(topic = 0:39, label = c("0 : Rihanna, Ellie Goulding, Katy Perry, Lana Del Rey, Imagi...", 
                                                  "1 : Queen, Michael Jackson, The Beatles, Madonna, U2, Electr...", 
                                                  "2 : Taylor Swift, Katy Perry, Carrie Underwood, Kelly Clarks...", 
                                                  "3 : Radiohead, The Smiths, The National, Interpol, The Cure,...", 
                                                  "4 : Kanye West, Kid Cudi, Drake, Jay-Z, Lil' Wayne, Lupe Fia...", 
                                                  "5 : Linkin Park, System of a Down, Breaking Benjamin, Avenge...", 
                                                  "6 : 소녀시대, 2NE1, SHINee, Big Bang, Super Junior, 4minute, Aft...", 
                                                  "7 : Muse, The Killers, Placebo, Coldplay, Keane, 30 Seconds ...", 
                                                  "8 : One Direction, Katy Perry, Britney Spears, Demi Lovato, ...", 
                                                  "9 : Lady Gaga, Lana Del Rey, Marina & the Diamonds, Britney ...", 
                                                  "10 : Björk, Tori Amos, Madonna, Massive Attack, PJ Harvey, T...", 
                                                  "11 : Glee Cast, Rihanna, Lady Gaga, Taylor Swift, Katy Perry...", 
                                                  "12 : Mariah Carey, Britney Spears, Christina Aguilera, Madon...", 
                                                  "13 : All Time Low, Paramore, Taylor Swift, My Chemical Roman...", 
                                                  "14 : Iron Maiden, Metallica, Megadeth, AC/DC, Porcupine Tree...", 
                                                  "15 : Rihanna, Lady Gaga, Katy Perry, Beyoncé, Christina Agui...", 
                                                  "16 : Coldplay, John Mayer, The Fray, Snow Patrol, Jason Mraz...", 
                                                  "17 : Britney Spears, Wanessa, Christina Aguilera, t.A.T.u., ...", 
                                                  "18 : 浜崎あゆみ, 倖田來未, 安室奈美恵, Boa, 宇多田ヒカル, Britney Spears, Perfum...", 
                                                  "19 : Nightwish, Within Temptation, Evanescence, Epica, Korn,...", 
                                                  "20 : Beyoncé, Lady Gaga, Britney Spears, Shakira, Rihanna, C...", 
                                                  "21 : Britney Spears, Girls Aloud, The Saturdays, Cheryl Cole...", 
                                                  "22 : Daft Punk, deadmau5, Skrillex, David Guetta, The Prodig...", 
                                                  "23 : O.S.T.R., Pezet, The Corrs, Tori Amos, donGURALesko, El...", 
                                                  "24 : Lana Del Rey, Florence + the Machine, Marina & the Diam...", 
                                                  "25 : Britney Spears, Leona Lewis, Kelly Clarkson, Lady Gaga,...", 
                                                  "26 : Arctic Monkeys, The Strokes, The Beatles, The Killers, ...", 
                                                  "27 : Adele, Amy Winehouse, P!nk, Pink, Alanis Morissette, Al...", 
                                                  "28 : Miley Cyrus, Taylor Swift, Demi Lovato, Britney Spears,...", 
                                                  "29 : Eminem, Kanye West, Jay-Z, Nas, 50 Cent, 2Pac, The Game...", 
                                                  "30 : Hey, Myslovitz, happysad, Coma, Florence + the Machine,...", 
                                                  "31 : Rihanna, Black Eyed Peas, David Guetta, Britney Spears,...", 
                                                  "32 : Madonna, Nelly Furtado, Alicia Keys, Wanessa, Shakira, ...", 
                                                  "33 : Los Hermanos, Legião Urbana, The Beatles, Arctic Monkey...", 
                                                  "34 : Rihanna, Chris Brown, Usher, Beyoncé, Nicki Minaj, Kany...", 
                                                  "35 : Madonna, Kylie Minogue, Lady Gaga, Christina Aguilera, ...", 
                                                  "36 : Katy Perry, Paramore, Avril Lavigne, Rihanna, The Prett...", 
                                                  "37 : The Beatles, Pink Floyd, Nirvana, Red Hot Chili Peppers...", 
                                                  "38 : Britney Spears, Christina Aguilera, Madonna, Rihanna, L...", 
                                                  "39 : Hans Zimmer, Bring Me the Horizon, A Day to Remember, b..."
  )), class = c("tbl_df", "tbl", "data.frame"), row.names = c(NA, 
                                                              -40L), .Names = c("topic", "label"))                                                                  
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
