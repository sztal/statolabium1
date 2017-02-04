# reactives.R --- reactive helper functions


# Reactives ---------------------------------------------------------------

# Datafile reactive ---
datafile <- reactive({
    switch(input$fileType,
           flat = callModule(flatFile, "datafile",
                             stringsAsFactors = TRUE,
                             check.names      = FALSE
           ),
           xlsx = callModule(xlsxFile, "datafile"),
           spss = callModule(spssFile, "datafile"),
           iris = reactive(tbl_dt(iris))
    )
})

# Reactive helper for independent correlations ---
Corr <- reactive({
    shiny::validate(
        need(input$cocorIndep1 != input$cocorIndep2, message = FALSE),
        need(input$cocorIndepLvl1 != input$cocorIndepLvl2, message = FALSE)
    )
    CN <- datafile()() %>% split(.[[input$cocorIndepFactor]]) %>% extract(names(.) %in% c(input$cocorIndepLvl1, input$cocorIndepLvl2)) %>%
        map(~ c(r = cor(.x[[input$cocorIndep1]], .x[[input$cocorIndep2]]), n = nrow(.x)))
    cocor.indep.groups(r1.jk = CN[[1]][1], r2.hm = CN[[2]][1], n1 = CN[[1]][2], n2 = CN[[2]][2],
                       conf.level = input$cocorIndepConf / 100, return.htest = TRUE)
})

# Reactive helper for independent correlations (visualization) ---
Viz <- reactive({
    shiny::validate(
        need(input$cocorIndep1 != input$cocorIndep2, message = FALSE),
        need(input$cocorIndepLvl1 != input$cocorIndepLvl2, message = FALSE)
    )
    datafile()() %>% split(.[[input$cocorIndepFactor]]) %>% extract(names(.) %in% c(input$cocorIndepLvl1, input$cocorIndepLvl2)) %>%
        map(~ tidy(cor.test(.x[[input$cocorIndep1]], .x[[input$cocorIndep2]], conf.level = input$cocorIndepConf / 100))) %>% 
        bind_rows %>% select(estimate, conf.low, conf.high) %>% 
        mutate(Grupa = factor(c(input$cocorIndepLvl1, input$cocorIndepLvl2), levels = c(input$cocorIndepLvl1, input$cocorIndepLvl2))) %>% 
        rename(`Korelacja Liniowa` = estimate)
})

# Reactive helper for dependent correlations ---
CD <- reactive({
    shiny::validate(
        need(input$cocorDepA1 != input$cocorDepA2, message = FALSE),
        need(input$cocorDepB1 != input$cocorDepB2, message = FALSE),
        need(!all(c(input$cocorDepA1, input$cocorDepA2) %in% c(input$cocorDepB1, input$cocorDepB2)), message = FALSE)
    )
    frm <- paste("~", input$cocorDepA1, "+", input$cocorDepA2, "|", input$cocorDepB1, "+", input$cocorDepB2) %>% as.formula
    datafile()() %>% cocor(frm, data = ., conf.level = input$cocorDepConf / 100, return.htest = TRUE)
})

# Reactive helper for dependent correlations (visualization) ---
VD <- reactive({
    shiny::validate(
        need(input$cocorDepA1 != input$cocorDepA2, message = FALSE),
        need(input$cocorDepB1 != input$cocorDepB2, message = FALSE),
        need(!all(c(input$cocorDepA1, input$cocorDepA2) %in% c(input$cocorDepB1, input$cocorDepB2)), message = FALSE)
    )
    ct1 <- cor.test(datafile()()[[input$cocorDepA1]], datafile()()[[input$cocorDepA2]], conf.level = input$cocorDepConf / 100) %>% tidy()
    ct2 <- cor.test(datafile()()[[input$cocorDepB1]], datafile()()[[input$cocorDepB2]], conf.level = input$cocorDepConf / 100) %>% tidy()
    dat <- bind_rows(ct1, ct2) %>% cbind(Korelacja = c("A", "B"), .) %>% select(Korelacja, estimate, conf.low, conf.high) %>%
        rename(`Korelacja Liniowa` = estimate)
    dat
})

#  ------------------------------------------------------------------------
