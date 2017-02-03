# global.R --- defines global, session-independent objects


# Load Shiny and other packages -------------------------------------------

library(shiny)
library(DT)
library(magrittr)
library(tibble)
library(data.table)
library(dplyr)
library(dtplyr)
library(purrr)
library(broom)
library(xlsx)
library(foreign)
library(cocor)

# helper functions ---
source(normalizePath("functions/functions.R"), local = TRUE)

# Global options ----------------------------------------------------------

options(shiny.trace = FALSE, shiny.reactlog = TRUE, OutDec = ",")
options(
    DT.options  = list(
        pageLength = 10,
        lengthMenu   = list(c(5, 10, 15, 20, -1), c('5', '10', '15', '20', 'Całość')),
        searching    = TRUE,
        keys         = TRUE,
        dom          = 'Blfrtip',
        buttons      = I('colvis'),
        scrollX      = TRUE,
        fixedColumns = TRUE,
        colReorder   = TRUE,
        language   = list(
            url = "//cdn.datatables.net/plug-ins/1.10.13/i18n/Polish.json",
            buttons = list(colvis = "Wybierz kolumny")
        )
    )
)
# Extensions used by all DataTables
DT_extensions <- c(
    'KeyTable',
    'Buttons',
    'FixedColumns',
    'ColReorder'
)

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
