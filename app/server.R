# server.R --- defines the server-side logic of the application

#  ------------------------------------------------------------------------

shinyServer(function(input, output, session) {
    # Session specific logic
    
    # Load packages ---
    library(cocor)
    
    # Load dataset ---
    datafile <- reactive({
        switch(input$fileType,
            flat = callModule(flatFile, "datafile",
                stringsAsFactors = TRUE,
                check.names      = FALSE
            ),
            xlsx = callModule(xlsxFile, "datafile"),
            spss = callModule(spssFile, "datafile"),
            iris = reactive(iris)
        )
    })
    
    # datafile <- callModule(xlsxFile, "datafile")
        
    output$table <- renderDataTable(
        datafile()(),
        extensions = c(
            'KeyTable',
            'Buttons',
            'FixedColumns',
            'ColReorder'
        ),
        options = list(
            pageLength   = 10,
            lengthMenu   = list(c(5, 10, 15, 20, -1), c('5', '10', '15', '20', 'Całość')),
            searching    = TRUE,
            keys         = TRUE,
            dom          = 'Blfrtip',
            buttons      = I('colvis'),
            #dom          = 'tl',
            scrollX      = TRUE,
            fixedColumns = TRUE,
            colReorder   = TRUE
        )
    ) 
}) 

#  ------------------------------------------------------------------------
