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
                        "SPSS (.sav)" = "spss"
                    )),
                    
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
