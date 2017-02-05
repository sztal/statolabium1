# intro.R --- a module defining the 'Intro' page

# UI function -------------------------------------------------------------

introUI <- function(id) {
    # Namespace function using the provided id
    ns <- NS(id)
    
    tagList(
        tags$section(id = "intro",
            fluidRow(
                column(12,
                    h1(paste0("Czym jest ", appFamily, "?"), class = "margin-top"),    
                    p(HTML("<em>StatLab</em> to darmowe narzędzie do wykonywania analiz statystycznych, na które najczęściej nie pozwalają najbardziej popularne i płatne programy takie jak <em>SPSS</em>, <em>STATISTICA</em> czy <em>MedCalc</em>. Dzięki niemu opracowanie wyników do prac magisterskich, doktoratów czy artykułów naukowych będzie pełniejsze, a wykonanie samych analiz przyjemniejsze. Wychodząc naprzeciw potrzebom studentów i pracowników naukowych tworzymy narzędzie, które będzie łatwe w obsłudze, a jednocześnie pozwoli na pogłębioną eksplorację zebranych danych. Na chwilę obecną dostępny jest moduł <em>PorKor</em>, który będzie doskonałym uzupełnieniem w pracy z Waszymi ulubionymi pakietami statystycznymi.")),
                    h1("Jak działa moduł PorKor?"),
                    p(HTML(
                        "Moduł ten pozwala na <strong>Por</strong>ównywanie <strong>Kor</strong>elacji. Niejednokrotnie w realizowanych przez nas analizach statystycznych wyników badań zachodzi potrzeba sprawdzenia, czy dwa wyliczone współczynniki korelacji liniowej różnią się od siebie w sposób istotny statystycznie. Pozwala to na testowanie hipotez zakładających na przykład, iż korelacja pewnych zmiennych jest istotnie silniejsza w grupie kobiet niż w grupie mężczyzn (korelacje niezależne), lub mówiących o tym, że korelacja zmiennych A i B jest silniejsza niż korelacja zmiennych A i C (korelacje zależne nierozłączne) lub C i D (korelacje zależne rozłączne). Moduł pozwala na wybór wszystkich najczęściej spotykanych rodzajów testów istotności różnic między współczynnikami korelacji. Dodatkowo we wszystkich przypadkach wyliczane są odpowiednie przedziały ufności. Tym samym <em>PorKor</em> jest przydatny we wszystkich projektach badawczych, w których właściwym jest pracowanie ze współczynnikami korelacji liniowej <em>r</em> Pearsona." 
                    )),
                    h1(paste0("Jak działa ", appTitle, "?"), class = "margin-top"),
                    p(HTML("Aby analizować dane przy użyciu modułu <em>PorKor</em> wystarczy przesłać swój zbiór danych (panel 'Dane'). Obecnie wspierane dane są w formacie tekstowym (<em>.csv</em> czy <em>.txt</em>), programu <em>Excel</em> (<em>.xls</em>, <em>.xlsx</em>) oraz <em>SPSS</em> (<em>.sav</em>). Po wczytaniu danych można natychmiastowo przejść do ich analizy. Panel 'Korelacje' pozwala na szybkie określanie korelacji między dwoma dowolnie zdefiniowanymi zbiorami zmiennych. W przypadku określania istotności dużej liczby współczynników korelacji wskazane jest korygowanie p-wartości (obecnie dostępne są następujące korekty: Bonferroniego, Holma oraz Benjaminiego-Hochberga). Panel 'Porównania' pozwala porównywać współczynniki korelacji między grupami niezależnymi lub współczynniki zależne (czyli różne współczynniki korelacji określane na tej samej grupie obserwacji).")),
                    h1("Metody i implementacja", class = "margin-top"),
                    p(HTML("Współczynniki korelacji liniowej oraz testy ich istotności (hipotezą zerową jest zawsze <em>r</em> = 0) i przedziały ufności wyznaczane są przy użyciu standardowych metod wykorzystujących transformację <em>z</em> Fishera. Testy porównujące korelacje wykorzystują metody zaimplementowane w pakiecie <a href='https://cran.r-project.org/web/packages/cocor/cocor.pdf'>cocor</a> dostępy w środowisku obliczeniowym R. Dokumentacja pakietu zawiera też spis literatury przedmiotu, w której omówione są wszystkie wykorzystywane tu testy."),
                      tags$br(), tags$br(),
                      HTML("Wszystkie obliczenia przeprowadzane są przy użyciu języka <em>R</em>. Również praktycznie cały kod aplikacji został napisany w <em>R</em> i przy użyciu frameworku <em>Shiny</em>.")),
                    p(HTML("Masz dla nas informacje zwrotne, uwagi, pomysły lub wyrażasz chęć współtworzenia tego narzędzia? Napisz na: <a href='mailto:info@pogotowiestatystyczne.pl'>info@pogotowiestatystyczne.pl</a>"))
                )
            )
        )
    )
}

#  ------------------------------------------------------------------------
