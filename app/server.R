# server.R --- defines the server-side logic of the application

#  ------------------------------------------------------------------------

shinyServer(function(input, output, session) {
    # Session specific logic
    
    # Load packages ---
    library(cocor)
    
    # Initialize modules ---
    callModule(intro, "pageIntro")
}) 

#  ------------------------------------------------------------------------