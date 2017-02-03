# server.R --- defines the server-side logic of the application

#  ------------------------------------------------------------------------

shinyServer(function(input, output, session) {
    # Session specific logic
    
    # Data access reactive ---
    source(normalizePath("functions/reactives.R"), local = TRUE)
    
    # 'Dane' subpage logic -----------------------------------------------------
    output$table <- renderDataTable(
        datafile()(),
        extensions = DT_extensions
    )
    
    # 'Korelacje' subpage logic ----------------------------------------------
    output$cor1UI <- renderUI({
        nm <- datafile()() %>% names %>% keep(map_lgl(datafile()(), is.numeric))
        selectizeInput("cor1", "Pierwszy zbiór zmiennych", choices = nm, multiple = TRUE)
    })
    output$cor2UI <- renderUI({
        nm <- datafile()() %>% names %>% keep(map_lgl(datafile()(), is.numeric)) %>% discard(~ .x %in% input$cor1)
        selectizeInput("cor2", "Drugi zbiór zmiennych", choices = nm, multiple = TRUE)
    })
    
    # Summary
    # output$corSummary <- renderUI({
    #     
    #     tags$dl(
    #         tags$dt("Zmiennych w zbiorze I:"), tags$dd(length(input$cor1)),
    #         tags$dt("Zmiennych w zbiorze II:"), tags$dd(length(input$cor2)),
    #         tags$dt("Łącznie korelacji:"), tags$dd(length(input$cor1) * length(input$cor2)),
    #         tags$dt("Liczba obserwacji:"), tags$dd(nrow(datafile()())),
    #         tags$dt("Korekta p-wartości (p*):"), tags$dd(input$corPAdjust),
    #         #if (!is.null(input$cor2) && !is.null(input$cor2)) browser(),
    #         tags$dt("Poziom ufności:"), tags$dd(paste0(round(input$corConf), "%"))
    #     )
    # })
    
    # Correlation table
    output$corTable <- renderDataTable({
        
        cor1 <- get_validated("cor1", input)   # Validity-aware accessor (set I)
        cor2 <- get_validated("cor2", input)   # Validity-aware accessor (set II)
         
        # Get parameters
        df1     <- datafile()() %>% select_(.dots = cor1())
        df2     <- datafile()() %>% select_(.dots = cor2())
        conf    <- input$corConf / 100
        PAdjust <- switch(input$corPAdjust,
            brak       = NULL,
            Bonferroni = "bonferroni",
            Holm       = "holm",
            `Benjamini-Hochberg (FDR)` = "BH"
        )

        # return a correlation table
        correlation_table(df1, df2, conf, PAdjust)
    },
    extensions = DT_extensions
    )
    
    # 'Porównania niezależne' subpage logic -----------------------------------
    output$cocorIndep1 <- renderUI({
        nm <- datafile()() %>% select_if(is.numeric) %>% names
        selectizeInput("cocorIndep1", "Zmienna I", choices = nm, multiple = FALSE)
    })
    output$cocorIndep2 <- renderUI({
        nm <- datafile()() %>% select_if(is.numeric) %>% names %>% discard(input$cocorIndep1)
        selectizeInput("cocorIndep2", "Zmienna II", choices = nm, multiple = FALSE)
    })
    
})

#  ------------------------------------------------------------------------
