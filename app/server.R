# server.R --- defines the server-side logic of the application

#  ------------------------------------------------------------------------

shinyServer(function(input, output, session) {
    # Session specific logic
    
    # Load packages ---
    library(cocor)
    
    # Get user-provided data
    datafile <- callModule(flatFile, "datafile",
        stringsAsFactors = TRUE,
        check.names      = FALSE
    )
    
    output$table <- renderDataTable(
            datafile(),
            options = list(
            pageLength = 10,
            lengthMenu = list(c(5, 10, 15, 20, -1), c('5', '10', '15', '20', 'Całość')),
            searching  = TRUE
        )
    ) 
}) 

#  ------------------------------------------------------------------------
