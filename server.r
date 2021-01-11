# Define server logic required to draw a histogram ----
server <- function(input, output) {

  observe({
    
    showModal(modalDialog(title = "Julia loading",
                          "The Julia computing environment is setting up",
                          easyClose = TRUE,
                          footer="It can take up to half a minute."))
    
    tktdjl2r::tktdjl2r_setup()
    
    removeModal()
  })
  

  df <- reactive({
    time = 1:input$nbrTimePts
    exposure = runif(input$nbrTimePts,0,10)
    TK = runTK(time,exposure, 0.5)$TK
    
    data.frame(
      time = c(time,time),
      varValues = c(exposure,TK),
      Variables = c(rep("Exposure", length(exposure)), rep("Toxicokinetic", length(TK)))
    )
  })
  
  output$Plot <- renderPlot({
    
    ggplot2::ggplot() +
      theme_minimal() +
      labs(x = "Times", y = "Scaled Internal Concentration") +
      geom_line(data = df(),
                aes(x = time, y = varValues, color = Variables))

    })

}

