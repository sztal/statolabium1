# header.R --- defines a common heading for all subpages


# UI function -------------------------------------------------------------

headerUI <- function(id) {
    # Namespace function using the provided id
    ns <- NS(id)
    
    tagList(
        column(12,
            tags$section(id = "header",
                img(class = "img-responsive", src = "img/Logo.png")
            )
        )
    )
}

#  ------------------------------------------------------------------------
