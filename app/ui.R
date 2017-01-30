# ui.R --- defines frontend layout and logic

#  ------------------------------------------------------------------------

shinyUI(navbarPage(HTML(paste0(appTitle, "<small>", appDesc, "</small>")),
    # UI with navbar and subpages (implemented as tabs in a tabset)
    tabPanel("Intro", introUI("pageIntro")),
    tabPanel("Dane"),
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
