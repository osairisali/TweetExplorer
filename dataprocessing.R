

# Select only Indonesian language & cleaning tweets ----
tex <- sample %>%
  mutate(# tagging languange column
    lang = detect_language(text),
    # encode to utf-8
    text = enc2utf8(text),
    # clean tweet symbols
    text = Textprocessing(text)) %>%
  # filter only indonesian
  filter(lang == "id")

# Modify text with additional rough classification columns ----
tex_class <- tex %>%
  mutate(jokowi = str_detect(text, fixed("jokowi", ignore_case = T)),
         pilpres = str_detect(text, fixed("pilpres", ignore_case = T)),
         prabowo = str_detect(text, fixed("prabowo", ignore_case = T)),
         pemilu = str_detect(text, fixed("pemilu", ignore_case = T)),
         # indonesia deleted because too mainstream
         #indonesia = str_detect(text, fixed("indonesia", 
         #                                  ignore_case = T)), 
         presiden = str_detect(text, fixed("presiden", ignore_case = T)),
         `pemilihan presiden` = str_detect(text, 
                                           fixed("pemilihan presiden",
                                                 ignore_case = T)),
         bangsa = str_detect(text, fixed("bangsa", ignore_case = T)),
         negara = str_detect(text, fixed("negara", ignore_case = T)))
score <- tibble(score = rowSums(select(tex_class, jokowi:negara)))
tex_class <- cbind(tex_class, score) # can't do in mutate()
tex_class <- arrange(tex_class, desc(score)) # why I can't do piping here