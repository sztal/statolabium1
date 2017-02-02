# ui.R --- defines frontend layout and logic

#  ------------------------------------------------------------------------

shinyUI(navbarPage(HTML(paste0(appTitle, "<small>", appDesc, "</small>")),
    # UI with navbar and subpages (implemented as tabs in a tabset)
    tabPanel("Intro", introUI("pageIntro")),
    
    # 'Dane' subpage --- 
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
                        exampleInput("Opis zbioru danych")
                    )
                ),
                
                # Main panel definition
                mainPanel(
                    dataTableOutput("table")
                )
            )
        )
    ),
    tabPanel("Korelacje"),
    navbarMenu("Porównania",
               tabPanel("Porównania niezależne"),
               tabPanel("Porównania zależne")
    ),
    # Options ---
    collapsible = TRUE, position = "fixed-top", selected = "Intro",
    header = headerUI("pageHeader"),
    footer = footerUI("pageFooter"),
    windowTitle = paste(appTitle, appDesc, sep = ": "),
    theme = "css/main.min.css"
))

#  ------------------------------------------------------------------------
