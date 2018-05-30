require(shiny)

# Load data into R ----

load("sample.RData")

# Define server logic ----
shinyServer(function(input, output, session) {
  
  # Sourcing textprocessing functions first ----
  source("textprocessingfun.R")
  
  # First eventReactive to wrangle data ----
  tex <- eventReactive(input$sample, {
    sample %>%
      mutate(# tagging languange column
        lang = detect_language(text),
        # encode to utf-8
        text = enc2utf8(text),
        # clean tweet symbols
        text = Textprocessing(text)) %>%
      # filter only indonesian
      filter(lang == "id")
  })
  
  tex_class <- eventReactive(input$sample, {
    t <- tex() %>%
      mutate(jokowi = str_detect(text, 
                                 fixed("jokowi", ignore_case = T)),
             pilpres = str_detect(text, 
                                  fixed("pilpres", ignore_case = T)),
             prabowo = str_detect(text, 
                                  fixed("prabowo", ignore_case = T)),
             pemilu = str_detect(text, 
                                 fixed("pemilu", ignore_case = T)),
             # indonesia deleted because too mainstream
             #indonesia = str_detect(text, fixed("indonesia", 
             #                                  ignore_case = T)), 
             presiden = str_detect(text, 
                                   fixed("presiden", 
                                               ignore_case = T)),
             `pemilihan presiden` = str_detect(text, 
                                               fixed("pemilihan presiden",
                                                     ignore_case = T)),
             bangsa = str_detect(text, 
                                 fixed("bangsa", ignore_case = T)),
             negara = str_detect(text, 
                                 fixed("negara", ignore_case = T)))
    score <- tibble(score = rowSums(select(t, jokowi:negara)))
    t <- cbind(t, score) # can't do in mutate()
    t <- arrange(t, desc(score)) # why I can't do piping here
    t
  })
  
  # Butuh cara menunjukkan notifikasi pengolahan data selesai
  # PLOTTING ----
  
  # Plotting tab panel 2
  output$overview <- renderPlot({
    
    tex_class() %>%
      as_tbl_time(created_at) %>%
      mutate(day = day(created_at)) %>%
      count(created_at, score, day) %>% # count occurence at each
                                        # created_at, score, and day
      ungroup() %>%
      collapse_by(period = "minute") %>% # grouping by each minute 
                                         # occurance
      #group_by(created_at, score, day) %>% # don't use this. this won't 
                                            # plot correctly
      ggplot(mapping = aes(x = created_at, 
                           y = n,
                           fill = as.factor(score))) + 
      geom_col(alpha = 1, show.legend = F) +
      xlab("") + 
      ylab("Score Tweets") +
      facet_grid(as.factor(score) ~ day, scales = "free")
    
  })
  
  # Plotting tab panel 3
  
  skor <- eventReactive(input$applyskorplot, {
    tex_class() %>%
      as_tbl_time(created_at) %>%
      mutate(day = day(created_at)) %>%
      filter(score == isolate(input$skor), 
             day == isolate(input$day)) %>%
      count(created_at, score, day) %>%
      collapse_by("minute")
  })
  
  output$skorplot <- renderPlot({
      ggplot(data = skor(),
             mapping = aes(x = created_at, 
                           y = n)) + 
      geom_col(show.legend = F) +
      xlab("") + 
      ylab("Score Tweets")
  })
  
  # Plotting tab panel 4 
  
  tweetrank <- eventReactive(input$applyrank, {
    tex() %>%
    mutate(day = day(created_at)) %>% # code berulang dgn plotting tab 2
    count(screen_name, 
          day, 
          sort = T) %>%
    filter(day %in% c(isolate(input$daytab4))) %>%
    # Top number active users
    top_n(isolate(input$rank), 
          n) %>%
    ungroup()
    })
  
  output$tweetrank <- renderPlot({
    ggplot(data = tweetrank(),
           aes(x = factor(screen_name,
                          levels = rev(unique(screen_name))),
               y = n)) +
      geom_col(aes(fill = screen_name), 
               alpha = 0.5, 
               show.legend = F) +
      coord_flip()
  })
  
  # Plotting tab panel 5
  
  users <- eventReactive(input$applyrankuser, {
    tex_class() %>%
      mutate(day = day(created_at)) %>% # code berulang dgn plotting tab 2
      group_by(screen_name) %>%
#tex_class()[, tex_class$score > 0 & tex_class$day %in% c(isolate(input$daytab5))]
      filter(score > 0 & day %in% c(isolate(input$daytab5))) %>%
      summarise(`political key` = sum(score),
                tweeting = n()) %>%
      arrange(desc(`political key`)) %>%
      top_n(isolate(input$rankuser), wt = `political key`)
    })
  
  output$userrank <- renderPlot({
    ggplot(data = users(),
           aes(x = factor(screen_name, levels = rev(screen_name)),
               y = `political key`,
               fill = screen_name)) +
      geom_col(alpha = 0.5, show.legend = F) +
      coord_flip()
  })
  
})
