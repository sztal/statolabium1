# xlsxFile.R --- creates xlsx file input UI and server-side logic


# UI function -------------------------------------------------------------

xlsxFileInput <- function(id,
                          label           = "Excel file (.xlsx or .xls)",
                          headLabel       = "Has heading",
                          sheetIndexLabel = "Numeric index or the name of a sheet that contains the dataset",
                          startRowLabel   = "First row index",
                          endRowLabel     = "Last row index (leave empty to get all rows)",
                          colIndexLabel   = "Columns indices separated with comma (leave empty to get all columns)") {
    # Namespace function using the provided id
    ns <- NS(id)
    
    tagList(
        fileInput(ns("xlsxFile"), label, 
                  accept = c("application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")),
        checkboxInput(ns("heading"), headLabel, value = TRUE),
        textInput(ns("sheetIndex"), sheetIndexLabel, value = 1),
        textInput(ns("startRow"), startRowLabel, value = 1),
        textInput(ns("endRow"), endRowLabel, value = ""),
        textInput(ns("colIndex"), colIndexLabel, value = "")
    )
}

# Server function ---------------------------------------------------------

xlsxFile <- function(input, output, session) {
    
    userFile <- get_validated("xlsxFile", input)
    
    # The user's data parsed into a data.frame
    dataframe <- reactive({
        read.xlsx(userFile()$datapath,
            header        = input$heading,
            sheetIndex    = if (is.na(as.numeric(input$sheetIndex))) NULL else as.numeric(input$sheetIndex),
            sheetName     = if (is.na(as.numeric(input$sheetIndex))) input$sheetIndex else NULL,
            startRow      = as.numeric(input$startRow),
            endRow        = if(input$endRow == "") NULL else as.numeric(input$endRow),
            colIndex      = if(input$colIndex == "") NULL else as.numeric(gsub(" ", "", unlist(strsplit(input$colIndex, ",")))),
            as.data.frame = TRUE
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
