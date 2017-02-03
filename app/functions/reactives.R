# reactives.R --- reactive helper functions


# Reactives ---------------------------------------------------------------

# Datafile reactive
datafile <- reactive({
    switch(input$fileType,
           flat = callModule(flatFile, "datafile",
                             stringsAsFactors = TRUE,
                             check.names      = FALSE
           ),
           xlsx = callModule(xlsxFile, "datafile"),
           spss = callModule(spssFile, "datafile"),
           iris = reactive(tbl_dt(iris))
    )
})

# Get reactive value when validated
get_validated <- function(nm, input) {
    reactive(
        {
            # If no file is selected, don't do anything
            shiny::validate(need(input[[nm]], message = FALSE))
            input[[nm]]
        }, 
        quoted = FALSE
    )
}

#  ------------------------------------------------------------------------
