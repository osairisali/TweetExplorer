messageData <- data.frame(from = character(0),  message = character(0), stringsAsFactors = F) #simplified this a bit


shinyUI(fluidPage(
  actionButton("sample", "tes"),
  uiOutput("myUI")
))


shinyServer(function(input, output) {
  
  M_Store <- reactiveValues(DF = messageData)
  
  newMessage <- reactive(data.frame(from = as.character(input$from),message = as.character(input$message)))
  observe({
    M_Store$DF <- rbind(isolate(M_Store$DF), newMessage())
  })
  
  output$myUI <- renderUI({
    
    #some code
    ... M_Store$DF ...
    #some code
    
  })
})

runApp()