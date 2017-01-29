# global.R --- defines global, session-independent objects

# Global options ----------------------------------------------------------

options(shiny.trace = FALSE, shiny.reactlog = FALSE)

# Global variables --------------------------------------------------------

# App settings ---
appTitle <- "Statolabium I"
appDesc  <- "korelacje liniowe"

# Colors ---
psColors <- list(
    seagreen = "#00A79D",
    blueLt   = "#438CCA",
    blueDk   = "#105C8A",
    grayLt   = "#CCCCCC",
    greyLt   = "#CCCCCC",
    grayDk   = "#464646",
    greyDk   = "#464646"
)


# Load modules ------------------------------------------------------------

source(normalizePath("modules/intro.R"), local = TRUE)      # Intro page

#  ------------------------------------------------------------------------