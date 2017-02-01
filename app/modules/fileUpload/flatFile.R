# flatFileInput.R --- creates flat file input UI and server-side logic


# UI function -------------------------------------------------------------

flatFileInput <- function(id, 
                            label = "Flat file (i.e. .txt, .csv, .tsv)",
                            headLabel  = "Has heading",
                            sepLabel   = "Field separator",
                            decLabel   = "Decimal separator",
                            quoteLabel = "Quote") {
    # Namespace function using the provided id
    ns <- NS(id)
    
    tagList(
        fileInput(ns("file"), label, accept = "text/csv"),
        checkboxInput(ns("heading"), headLabel, value = TRUE),
        selectInput(ns("sep"), sepLabel, c(
           "tabulator" = "\t",
           "przecinek" = ",",
           "średnik"   = ";"
        ), selected = "średnik"),
        selectInput(ns("dec"), decLabel, c(
            "przecinek" = ",",
            "kropka"    = "."
        ), selected = "przecinek"),
        selectInput(ns("quote"), quoteLabel, c(
            "brak" = "",
            "cudzysłów podwójny" = "\"",
            "cudzysłów pojedynczy" = "'"
        ), selected = "brak")
    )
}


# Server function ---------------------------------------------------------

flatFile <- function(input, output, session,
                     stringsAsFactors = TRUE, check.names = FALSE) {
    userFile <- reactive({
        # If no file is selected, don't do anything
        shiny::validate(need(input$file, message = FALSE))
        input$file
    })
    
    # The user's data parsed into a data.frame
    dataframe <- reactive({
        read.table(userFile()$datapath,
            header = input$heading,
            sep    = input$sep,
            dec    = input$dec,
            quote  = input$quote,
            stringsAsFactors = stringsAsFactors,
            check.names = check.names
        )
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
