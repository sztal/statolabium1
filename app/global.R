# global.R --- defines global, session-independent objects

# Global options ----------------------------------------------------------

options(shiny.trace = FALSE, shiny.reactlog = FALSE)

# Global variables --------------------------------------------------------

# App settings ---
appFamily <- "Statolabium"
appNum    <- "I"
appTitle  <- paste(appFamily, appNum)
appDesc   <- "korelacje liniowe"

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


# Load views --------------------------------------------------------------

source(normalizePath("views/intro.R"), local = TRUE)        # intro page
source(normalizePath("views/dane.R"), local = TRUE)         # dane page


# Load modules ------------------------------------------------------------

source(normalizePath("modules/header.R"), local = TRUE)     # common header
source(normalizePath("modules/footer.R"), local = TRUE)     # common footer

#  ------------------------------------------------------------------------
