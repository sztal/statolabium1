# footer.R --- defines a common footer of all subpages


# UI function -------------------------------------------------------------

footerUI <- function(id) {
    # Namespace function using the provided id
    ns <- NS(id)
    
    tagList(
        column(12,
            tags$section(id = "footer",
                fluidRow(
                    column(6,
                        a(img(class = "img-responsive", src = "img/Logo.png"), href = "http://pogotowiestatystyczne.pl/")
                    ),
                    column(6, class = "nice-border",
                        tags$dl(
                            tags$dt("Strona WWW:"),
                            tags$dd(a("www.pogotowiestatystyczne.pl/", href = "http://pogotowiestatystyczne.pl/")),
                            tags$dt("E-mail:"),
                            tags$dd(a("info@pogotowiestatystyczne.pl", href = "mailto:info@pogotowiestatystyczne.pl?Subject=Pytanie")),
                            tags$dt("Problemy techniczne:"),
                            tags$dd(a("technik@pogotowiestatystyczne.pl", href = "mailto:technik@pogotowiestatystyczne.pl?Subject=Problem")),
                            tags$dt("Autor:"),
                            tags$dd("Szymon Talaga, Pogotowie Statystyczne")
                        )
                    )
                ),
                fluidRow(class = "stopka",
                    column(12,
                        span("Pogotowie Statystyczne ®"),
                        span(" | kompleksowo, szybko, najlepiej", class = "slogan"),
                        span(paste0(" | Wszelkie prawa zastrzeżone 2007-", format(Sys.Date(), "%Y")))
                    )
                )
            )
        )
    )
}

#  ------------------------------------------------------------------------
