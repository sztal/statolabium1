# dane.R --- a module defining the 'Dane' page


# UI function -------------------------------------------------------------

daneUI <- function(id) {
    # Namespace function using the provided id
    ns <- NS(id)
    
    tagList(
        tags$section(id = "dane",
            
            # Sidebar page layout definition
            sidebarLayout(
                
                # Sidebar UI definition
                sidebarPanel(
                    
                ),
                
                # Main panel UI definition
                mainPanel(
                    
                )
                
            )
        )
    )
}
