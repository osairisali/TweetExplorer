require(rtweet)
require(tidyverse)
require(tidytext)
require(cld3)
require(udpipe)
require(igraph)
require(hrbrthemes)
require(ggraph)
require(wordcloud)
require(tibbletime)
require(lubridate)

Textprocessing <- function(x){ 
  # piping will work only with {} and . (dot) to mark data if the fun's first 
  # argument is not the data.
  x <- as.character(x) %>%
  {gsub("http[[:alnum:]]*",'', .)} %>%
  {gsub('http\\S+\\s*', '', .)}  %>% ## Remove URLs
  {gsub('\\b+RT', '', .)} %>%  ## Remove RT
  {gsub('\\b+amp', '', .)}  %>% ## remove amp
  {gsub('#\\S+', '', .)} %>% ## Remove Hashtags
  {gsub('@\\S+', '', .)} %>% ## Remove Mentions
  {gsub('[[:cntrl:]]', '', .)} %>% ## Remove Controls & special chr
  {gsub("\\d", '', .)} %>% ## Remove Controls and special characters
  {gsub('[[:punct:]]', '', .)} %>% ## Remove Punctuations
  {gsub("^[[:space:]]*","", .)} %>% ## Remove leading whitespaces
  {gsub("[[:space:]]*$","", .)} %>% ## Remove trailing whitespaces
  {gsub(' +',' ', .)} ## Remove extra whitespaces
  #{gsub(' +',' ', .)} ## HOW TO REMOVE TCO LINK ????????????????
  return(x)
}

## load indonesian stopwords
stop <- tibble(words = readLines("stpID.txt"))

## additional common-abbreviations
tmb <- tibble(words = c("yg", "sdh", "akn", "dgn", "y", "gk", "gmn"))
stop <- rbind(stop, tmb)