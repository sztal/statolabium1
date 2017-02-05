# functions.R --- helper functions



# Reactive functions factories --------------------------------------------

# Get reactive value when validated
get_validated <- function(nm, input) {
    reactive(
        {
            # If no file is selected, don't do anything
            shiny::validate(need(input[[nm]], message = FALSE))
            input[[nm]]
        }, 
        quoted = FALSE
    )
}


# Standard functions ------------------------------------------------------

# format numeric values ---
.frm <- function(x, digits = 3L, dec = getOption("OutDec")) {
    if (is.integer(x)) {
        format(x)
    } else if (is.numeric(x)) {
        format(x, digits = 0L, nsmall = digits, dec = dec)
    }
}

# format p-values ---
.pval <- function(x, digits = 3L, dec = getOption("OutDec"), sig_stars = FALSE, abbreviate = TRUE) {
    pv <- x
    num_stars <- ifelse(pv > 0.05, 0L, ifelse(pv > 0.01, 1L, ifelse(pv > 0.001, 2L, 3L)))
    if (abbreviate) {
        pv <- ifelse (round(x, digits) < 10^(-digits) / 2,
                      paste0("< ", paste(0, paste0(c(rep(0, digits - 1), 1), collapse = ""), sep = dec)),
                      format(x, digits = 0L, nsmall = digits, dec = dec)
        )
    }
    if (sig_stars) {
        stars <- sapply(lapply(num_stars, function(x) rep("*", x)), paste0, collapse = "")
        pv    <- paste0(pv, stars)
    }
    pv
}

# Add padding ---
.pad <- function(x, n) {
    x <- as.character(x)
    if (length(x) >= n) return(x)
    else return(c(x, rep("", n - length(x))))
}

# Format confidence bounds ---
.frmCI <- function(lo, hi) {
    paste0("[", .frm(lo), "; ", .frm(hi), "]")
}

# Get tidy correlation output ---
tidy_cor <- function(htest, conf_lvl = NULL) {
    if (is_null(conf_lvl)) conf_lvl <- "CI"
    else if (is_numeric(conf_lvl)) conf_lvl <- paste0(round(conf_lvl * 100), "% CI")
    df <- tidy(htest) %>% mutate(CI = .frmCI(conf.low, conf.high))
    df <- df %>% select(estimate, CI, parameter, statistic, p.value) %>%
        rename_(.dots = set_names(names(.), c("r", conf_lvl, "df", "t", "p")))
    df <- df %>% mutate_at(vars(r, t), .frm) %>% mutate_at(vars(starts_with("p")), .pval)
    df
}

# Correlation table for two sets of variables (data.frames) ---
correlation_table <- function(df1, df2, conf_lvl = .95, adjust_method = NULL) {
    m1       <- ncol(df1)
    m2       <- ncol(df2)
    nm1      <- names(df1)
    nm2      <- names(df2)
    Corr     <- cross2(df2, df1) %>% map(~ cor.test(.x[[1]], .x[[2]], conf.level = conf_lvl)) %>% map(tidy_cor, conf_lvl) %>% 
        bind_rows %>% cbind(`Zmienna I` = reduce(map(nm1, .pad, m2), c), `Zmienna II` = rep(nm2, m1), .)
    if (!is.null(adjust_method)) {
        Corr <- mutate(Corr, `p*` = p %>% gsub(",", ".", .) %>% as.numeric %>% p.adjust(method = adjust_method) %>% .pval)
    }
    Corr
}

#  ------------------------------------------------------------------------
