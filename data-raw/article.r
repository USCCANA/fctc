
rm(list = ls())

key <- readr::read_csv("data-raw/implementation/implementation_key.csv")
articles <- sort(unique(key$art))

