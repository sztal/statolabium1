# example.R --- example dataset(s) UI and server-side logic


# UI function -------------------------------------------------------------

exampleInput <- function(id) {
    # Namespace function using the provided id
    ns <- NS(id)
    
    tagList(
        p("Słynny", tags$a(href = "https://en.wikipedia.org/wiki/Iris_flower_data_set", "zbiór danych"), "zgromadzony w pierwszej połowie XX wieku przez Edgara Andersona i rozsławiony przez Ronalda Fishera, który wykorzystał go do opracowania metody", tags$em("liniowej analizy dyskryminacyjnej."), "Zbiór danych zawiera pomiary długości i szerokości płatkow oraz działek kielicha trzech gatunków irysów: ", tags$em("Iris setosa,"), tags$em("Iris virginica,"),tags$em("Iris versicolor."), "Łącznie zgromadzone zostało 150 pomiarów, po 50 na każdy gatunek.")
    )
}

#  ------------------------------------------------------------------------
