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
        nm <- datafile()() %>% names %>% keep(map_lgl(datafile()(), is.numeric)) #%>% discard(~ .x %in% input$cor1)
        selectizeInput("cor2", "Drugi zbiór zmiennych", choices = nm, multiple = TRUE)
    })
    
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
    
    # Dynamic UI ---
    output$cocorIndep1 <- renderUI({
        nm <- datafile()() %>% select_if(is.numeric) %>% names
        selectizeInput("cocorIndep1", "Zmienna I", choices = nm, multiple = FALSE)
    })
    output$cocorIndep2 <- renderUI({
        nm <- datafile()() %>% select_if(is.numeric) %>% names #%>% discard(~ .x == input$cocorIndep1)
        selectizeInput("cocorIndep2", "Zmienna II", choices = nm, multiple = FALSE)
    })
    output$cocorIndepFactor <- renderUI({
        nm <- datafile()() %>% keep(~ !is.numeric(.x) || identical(as.integer(.x), .x)) %>% names
        selectizeInput("cocorIndepFactor", "Zmienna grupująca", choices = nm, multiple = FALSE)
    })
    output$cocorIndepLvl1 <- renderUI({
        fct <- get_validated("cocorIndepFactor", input)
        nm  <- datafile()()[[fct()]] %>% levels
        tags$div(class = "selectize-input-lvl-choice",
            selectizeInput("cocorIndepLvl1", "Grupa I", choices = nm, multiple = FALSE)
        )
    })
    output$cocorIndepLvl2 <- renderUI({
        fct <- get_validated("cocorIndepFactor", input)
        nm <- datafile()()[[fct()]] %>% levels #%>% discard(~ .x == input$cocorIndepLvl1)
        tags$div(class = "selectize-input-lvl-choice",
            selectizeInput("cocorIndepLvl2", "Grupa II", choices = nm, multiple = FALSE)
        )
    })
    
    # Output ---
    output$cocorIndepDesc <- renderUI({
        p(
            sprintf("Współczynnik korelacji w grupie I wyniósł %s.", .frm(Corr()[[1]]$estimate[1])),
            tags$br(),
            sprintf("Współczynnik korelacji w grupie II wyniósł %s.", .frm(Corr()[[1]]$estimate[2])),
            tags$br(),
            sprintf("Różnica między współczynnikami wyniosła %s, z = %s", 
                    .frm(Corr()[[1]]$estimate[1] - Corr()[[1]]$estimate[2]), .frm(Corr()$fisher1925$statistic)),
            sprintf("; p %s.", if (Corr()$fisher1925$p.value < 0.001) .pval(Corr()$fisher1925$p.value) 
                               else paste0("= ", .frm(Corr()$fisher1925$p.value))),
            tags$br(),
            sprintf("Przedział ufności określany metodą Zou wyniósł: %s.", .frmCI(Corr()$zou2007$conf.int[1], Corr()$zou2007$conf.int[2])),
            tags$br(), tags$br(),
            sprintf("Liczebność grupy I: %d.", sum(datafile()()[[input$cocorIndepFactor]] == input$cocorIndepLvl1), na.rm = TRUE),
            tags$br(),
            sprintf("Liczebność grupy II: %d.", sum(datafile()()[[input$cocorIndepFactor]] == input$cocorIndepLvl2), na.rm = TRUE)
        )
    })
    output$cocorIndepPlot <- renderPlot({
        
        Viz() %>% ggplot(aes(x = Grupa, y = `Korelacja Liniowa`)) + geom_point(pch = 16, size = 3) +
            geom_errorbar(aes(ymin = conf.low, ymax = conf.high, width = .1)) + scale_y_continuous(limits = c(-1, 1)) +
            geom_hline(yintercept = 0, lty = 2)
    })
    
    # 'Porównania zależne' subpage logic --------------------------------------
    
    # Dynamic UI
    output$cocorDepA1   <- renderUI({
        nm <- datafile()() %>% select_if(is.numeric) %>% names
        selectizeInput("cocorDepA1", "Korelacja A, zmienna I", choices = nm, multiple = FALSE)
    })
    output$cocorDepA2   <- renderUI({
        nm <- datafile()() %>% select_if(is.numeric) %>% names
        selectizeInput("cocorDepA2", "Korelacja A, zmienna II", choices = nm, multiple = FALSE)
    })
    output$cocorDepB1   <- renderUI({
        nm <- datafile()() %>% select_if(is.numeric) %>% names
        selectizeInput("cocorDepB1", "Korelacja B, zmienna I", choices = nm, multiple = FALSE)
    })
    output$cocorDepB2   <- renderUI({
        nm <- datafile()() %>% select_if(is.numeric) %>% names
        selectizeInput("cocorDepB2", "Korelacja B, zmienna II", choices = nm, multiple = FALSE)
    })
    output$cocorDepTest <- renderUI({
        shiny::validate(
            need(input$cocorDepA1 != input$cocorDepA2, message = FALSE),
            need(input$cocorDepB1 != input$cocorDepB2, message = FALSE),
            need(!all(c(input$cocorDepA1, input$cocorDepA2) %in% c(input$cocorDepB1, input$cocorDepB2)), message = FALSE)
        )
        nm <- if (any(c(input$cocorDepA1, input$cocorDepA2) %in% c(input$cocorDepB1, input$cocorDepB2))) {
            c("Pearson-Filon (1898)",
              "Hotelling (1940)",
              "Williams (1959)",
              "Hendrickson-Stanley-Hill (1970)",
              "Olkin (1967)",
              "Dunn-Clark (1969)",
              "Steiger (1980)",
              "Meng-Rosenthal-Rubin (1992)",
              "Hittner-May-Silver (2003)")
        } else {
            c("Pearson-Filon (1898)",
              "Dunn-Clark (1969)",
              "Steiger (1980)",
              "Raghunathan (1996)",
              "Silver (2004)")
        }
        selectizeInput("cocorDepTest", "Test istotności", choices = nm, multiple = FALSE)
    })
    
    # Output ---
    output$cocorDepDesc <- renderUI({
        
        # Wait for a test
        validate(
            need(input$cocorDepA1 != input$cocorDepA2, message = FALSE),
            need(input$cocorDepB1 != input$cocorDepB2, message = FALSE),
            need(input$cocorDepTest, message = FALSE)
        )
        
        test <- switch(input$cocorDepTest,
            `Pearson-Filon (1898)`            = "pearson1898",
            `Hotelling (1940)`                = "hotelling1940",
            `Williams (1959)`                 = "williams1959",
            `Hendrickson-Stanley-Hill (1970)` = "hendrickson1970",
            `Olkin (1967)`                    = "olkin1967",
            `Dunn-Clark (1969)`               = "dunn1969",
            `Steiger (1980)`                  = "steiger1980",
            `Meng-Rosenthal-Rubin (1992)`     = "meng1992",
            `Hittner-May-Silver (2003)`       = "hittner2003",
            `Raghunathan (1996)`              = "raghunathan1996",
            `Silver (2004)`                   = "silver2004"
        )
        ct <- CD()[[test]]
        p(
            sprintf("Współczynnik korelacji A wyniósł %s.", .frm(ct$estimate[1])),
            tags$br(),
            sprintf("Współczynnik korelacji B wyniósł %s.", .frm(ct$estimate[2])),
            tags$br(),
            sprintf("Różnica między współczynnikami wyniosła %s,", .frm(ct$estimate[1] - ct$estimate[2])),
            paste0(
                if (test %in% c("pearson1898", "hotelling1940", "williams1959", "hendrickson1970"))
                    sprintf("t(%d) = %s", ct$parameter, .frm(ct$statistic))
                else sprintf("z = %s", .frm(ct$statistic)), 
                sprintf("; p %s.", if (ct$p.value < 0.001) .pval(ct$p.value) else paste0("= ", .frm(ct$p.value)))
            ),
            tags$br(),
            sprintf("Przedział ufności określony metodą Zou wyniósł: %s.", .frmCI(CD()[["zou2007"]]$conf.int[1], CD()[["zou2007"]]$conf.int[2])),
            tags$br(), tags$br(),
            sprintf("Liczba ważnych obserwacji: %d.", select_(datafile()(), .dots = c(input$cocorDepA1, input$cocorDepA2, 
                                                                                  input$cocorDepB1, input$cocorDepB2)) %>% 
                                                      complete.cases %>% sum(., na.rm = TRUE)),
            tags$br(),
            sprintf("Test istotności metodą: %s.", input$cocorDepTest)
        )
    })
    output$cocorDepPlot <- renderPlot({
        VD() %>% ggplot(aes(x = Korelacja, y = `Korelacja Liniowa`)) + geom_point(pch = 16, size = 3) +
            geom_errorbar(aes(ymin = conf.low, ymax = conf.high, width = .1)) + scale_y_continuous(limits = c(-1, 1)) +
            geom_hline(yintercept = 0, lty = 2)
    })
    
})

#  ------------------------------------------------------------------------
