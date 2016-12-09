library(tidyr)
library(jsonlite)
library(dplyr)
readData <- function()
{
    
    titletrans <- read.csv("TranslationTitle.csv")
    titletrans$Title <- as.character(titletrans$Title)
    gh  <- fromJSON("http://opendata.cbs.nl/ODataApi/OData/7062/TypedDataSet")$value
    gh$Perioden  <- as.numeric(substr(gh$Perioden, 1,4))
    src  <- fromJSON("http://opendata.cbs.nl/ODataApi/OData/7062/Bronnen")$value
    src  <- select(src, Bronnen = Key, Title)
    gh <- left_join(gh, src, by = "Bronnen") %>%
        left_join( titletrans, by = "Title") %>%
        mutate(Title = factor(TitleEng)) %>%
        select(-TitleEng)
    rm(src)
    gh$Bronnen  <- factor(gh$Bronnen)
    gh$Title <- factor(gh$Title)
    gh
}



meltdata <- function(gh)
{
    
    ghmelt  <- gather(gh, "variable", "value", 4:23 ) %>%
        group_by( Title, variable) %>%
        mutate( valindex = (value/first(value))*100 
                , firstval = first(value)
                , lastval = last(value)
                , firstyear = first(Perioden)
                , lastyear = last(Perioden)) %>%
        ungroup()%>%
        mutate( variable = paste(formatC(as.numeric(substring(variable, regexpr('_', variable)+1)), width=2, flag = "0")
                                 ,'-' 
                                 ,substring(variable, 1, regexpr('_', variable)-1)))%>%
        select( Category
                , CategoryTitle
                , Year = Perioden
                , variable
                , value
                , valindex
                , firstval
                , lastval
                , firstyear
                , lastyear)%>%
        mutate(group = ifelse(as.integer(substring(variable,1,2)) <= 11, "Total", "Per kg of fuel"))
    ghmelt
}

tabdata <- function(ghm, category)
{
    ghtab <- filter(ghm, Category == category) %>%
        mutate(difference = paste(round((lastval/ firstval * 100)- 100 ,1), "%", sep="")) %>%
        select(Measurement = group, CategoryTitle, Emission = variable, difference) %>%
        unique() %>%
        spread(CategoryTitle, difference) %>%
        mutate(Emission = substring(Emission, 6)) %>%
        arrange(desc(Measurement), Emission)
    ghtab
}

