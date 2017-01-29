# ui.R --- defines frontend layout and logic

#  ------------------------------------------------------------------------

shinyUI(navbarPage(appTitle,
    # UI with navbar and subpages (implemented as tabs in a tabset)
    # Options ---
    collapsible = TRUE, position = "fixed-top",
    
    tabPanel("Intro", introUI("pageIntro")),
    tabPanel("Dane"),
    tabPanel("Korelacje"),
    tabPanel("Porównania niezależne"),
    tabPanel("Porównania zależne")
    
    
))

#  ------------------------------------------------------------------------