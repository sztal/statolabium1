# spssFile.R --- spss file input UI and server-side logic


# UI function -------------------------------------------------------------

spssFileInput <- function(id,
                          label            = "SPSS file (.sav)",
                          valueLabelsLabel = "Use value labels") {
    # Namespace function using the provided id
    ns <- NS(id)
    
    tagList(
        fileInput(ns("spssFile"), label, 
                  accept = c("application/x-spss-sav")),
        checkboxInput(ns("valueLabels"), valueLabelsLabel, value = TRUE)
    )
}

# Server function ---------------------------------------------------------

spssFile <- function(input, output, session) {
    
    userFile <- get_validated("spssFile", input)
    
    # The user's data parsed into a data.frame
    dataframe <- reactive({
        read.spss(userFile()$datapath,
            use.value.labels  = input$valueLabels,
            to.data.frame     = TRUE,
            trim.factor.names = TRUE,
            trim_values       = TRUE
        ) %>% tbl_dt
    })
    
    # Notify when the file is uploaded
    observe({
        msg <- sprintf("Plik o nazwie %s został wczytany", userFile()$name)
        cat(msg, "\n")
    })
    
    # return the reactive that yields the data.frame
    return(dataframe)
}

#  ------------------------------------------------------------------------
