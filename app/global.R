# global.R --- defines global, session-independent objects


# Load Shiny and other packages -------------------------------------------

library(shiny)
library(DT)
library(xlsx)
library(foreign)

# Global options ----------------------------------------------------------

options(shiny.trace = FALSE, shiny.reactlog = TRUE)

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

# Load modules ------------------------------------------------------------

source(normalizePath("modules/staticElements/header.R"), local = TRUE)  # common header
source(normalizePath("modules/staticElements/footer.R"), local = TRUE)  # common footer
source(normalizePath("modules/fileUpload/flatFile.R"), local = TRUE)    # flat file (text) upload
source(normalizePath("modules/fileUpload/excelFile.R"), local = TRUE)   # excel file upload
source(normalizePath("modules/fileUpload/spssFile.R"), local = TRUE)    # spss file upload
source(normalizePath("modules/fileUpload/example.R"), local = TRUE)     # example file (iris)

#  ------------------------------------------------------------------------
