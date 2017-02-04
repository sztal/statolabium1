# ui.R --- defines frontend layout and logic

#  ------------------------------------------------------------------------

shinyUI(navbarPage(HTML(paste0(appTitle, "<small>", appDesc, "</small>")),
    # UI with navbar and subpages (implemented as tabs in a tabset)
    tabPanel("Intro", introUI("pageIntro")),
    
    # 'Dane' subpage ----------------------------------------------------------
    tabPanel("Dane",
        tags$section(id = "dane",
            
            # Sidebar page layout definition
            sidebarLayout(
                
                # Sidebar UI definition
                sidebarPanel(
                    
                    # File type handle
                    selectInput("fileType", "Format pliku", c(
                        "tekstowy"    = "flat",
                        ".xls(x)"     = "xlsx",
                        "SPSS (.sav)" = "spss",
                        "przykładowy zbiór danych (Iris)" = "iris"
                    ), selected = "flat"),
                    
                    # File input handle (flat file case)
                    conditionalPanel(
                        # calls the flatFile module
                        condition = "input.fileType == 'flat'",
                        flatFileInput("datafile",
                            label      = "Zbiór danych w formacie tekstowym (np. .txt, .csv, .tsv)",
                            headLabel  = "Nazwy zmiennych w pierwszym wierszu",
                            sepLabel   = "Separator pól",
                            decLabel   = "Separator części dziesiętnej",
                            quoteLabel = "Czudzysłów dla wartości tekstowych"
                        )   
                    ),
                    
                    # File input handle (Excel file case)
                    conditionalPanel(
                        # calls the xlsxFile module
                        condition = "input.fileType == 'xlsx'",
                        xlsxFileInput("datafile",
                            label           = "Plik w formacie programu Excel (.xlsx or .xls)",
                            headLabel       = "Nazwy zmiennych w pierwszy wierszu",
                            sheetIndexLabel = "Numer lub nazwa arkusza, w którym znajduje się zbiór danych",
                            startRowLabel   = "Numer wiersza w arkuszu, w którym zaczyna się zbiór danych",
                            endRowLabel     = "Numer wiesza, w którym zbiór danych się kończy (pozostaw puste, aby wczytać wszystkie wiersze)",
                            colIndexLabel   = "Numery kolumn do wczytania dzielone przecinkiem (pozostaw puste, aby wczytać wszystkie kolumny)"
                        )
                    ),
                    
                    # File input handle (SPSS file case)
                    conditionalPanel(
                        # calls the spssFile module
                        condition = "input.fileType == 'spss'",
                        spssFileInput("datafile",
                            label            = "Plik w formacie pakietu SPSS (.sav)",
                            valueLabelsLabel =  "Etykiety poziomów zmiennych kategorialnych"
                        )
                    ),
                    
                    # File input handle (Iris example dataset case)
                    conditionalPanel(
                        condition = "input.fileType == 'iris'",
                        exampleInput("example")
                    )
                ),
                
                # Main panel definition
                mainPanel(
                    dataTableOutput("table")
                )
            )
        )
    ),
    
    # 'Korelacje' subpage ----------------------------------------------------------
    tabPanel("Korelacje",
        tags$section(id = "Korelacje",
            
            # Sidebar page layout definition
            sidebarLayout(
                
                # Sidebar UI definition
                sidebarPanel(
                    uiOutput("cor1UI"),
                    uiOutput("cor2UI"),
                    selectInput("corPAdjust", "Korekta poziomu istotności (p*)", c(
                        "brak",
                        "Bonferroni",
                        "Holm",
                        "Benjamini-Hochberg (FDR)")
                    ),
                    sliderInput("corConf", "Poziom ufności (%)", min = 80, max = 100, value = 95, step = 1)
                ),
                
                # Main panel UI definition
                mainPanel(
                    
                    # Correlation table
                    dataTableOutput("corTable")
                )
            )
        )
    ),
    
    # 'Porównania' subpage ----------------------------------------------------------
    navbarMenu("Porównania",
        tabPanel("Porównania niezależne",
            tags$section(id = "porównania-niezależne",
            
                # Sidebar page layout definition
                sidebarLayout(
                     
                    # Sidebar UI definition
                    sidebarPanel(
                        uiOutput("cocorIndep1"),
                        uiOutput("cocorIndep2"),
                        uiOutput("cocorIndepFactor"),
                        uiOutput("cocorIndepLvl1"),
                        uiOutput("cocorIndepLvl2"),
                        sliderInput("cocorIndepConf", "Poziom ufności (%)", min = 80, max = 100, value = 95, step = 1)
                    ),
                
                    # Main panel UI definition
                    mainPanel(
                        tags$div(class = "desc-wrapper",
                            h1("Porównywanie korelacji w grupach niezależnych"),
                            p(HTML("Ten panel pozwala na porównywanie natężenia korelacji w dwóch niezależnych grupach.",
                            "Istotność różnicy między współczynnikami korelacji badana jest testem Z&nbsp;Fishera.",
                            "Przedział ufności wyznaczany jest przy użyciu metody Zou (2007).")),
                            tags$br(),
                            uiOutput("cocorIndepDesc"),
                            tags$br(),
                            plotOutput("cocorIndepPlot")
                        )
                    )
                )
            )
        ),
        tabPanel("Porównania zależne",
            tags$section(id = "porównania-zależne",
                
                # Sidebar page layout definition
                sidebarLayout(
                             
                    # Sidebar UI definition
                    sidebarPanel(
                        uiOutput("cocorDepA1"),
                        uiOutput("cocorDepA2"),
                        uiOutput("cocorDepB1"),
                        uiOutput("cocorDepB2"),
                        uiOutput("cocorDepTest"),
                        sliderInput("cocorDepConf", "Poziom ufności (%)", min = 80, max = 100, value = 95, step = 1)
                    ),
                    
                    # Main panel UI definition
                    mainPanel(
                        tags$div(class = "desc-wrapper",
                            h1("Porównywanie korelacji zależnych"),
                            p(
                                "Korelacje zależne dotyczą powiązań określanymi dla różnych zmiennych mierzonych dla tych samych obserwacji.",
                                "Moga one być rozłączne (korelacja między zmiennymi A i B vs. korelacja między zmiennymi C i D) bądź mogą się",
                                "częściowo pokrywać (korelacja między zmiennymi A i B vs. korelacja między zmiennymi B i C).",
                                "Możliwe do wykorzystania w danym przypadku testy istotności wymienione są w panelu użytkownika.",
                                "Przedziały ufności wyznaczane są przy użyciu metody Zou (2007).",
                                tags$br(),
                                uiOutput("cocorDepDesc"),
                                tags$br(),
                                plotOutput("cocorDepPlot")
                            )
                        )
                    )
                )
            )
        )
    ),
    # Options ----------------------------------------------------------
    collapsible = TRUE, position = "fixed-top", selected = "Intro",
    header = headerUI("pageHeader"),
    footer = footerUI("pageFooter"),
    windowTitle = paste(appTitle, appDesc, sep = ": "),
    theme = "css/main.min.css"
))

#  ------------------------------------------------------------------------
