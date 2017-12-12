
rm(list = ls())



key <- readr::read_csv("data-raw/implementation/implementation_key.csv")
articles <- sort(unique(key$art))


cat(
  "#%--------------------------------------------------------------------------",
  "#% DO NOT EDIT BY HAND!",
  "#% THIS FILE WAS CREATED AUTOMATICALLY BY THE SCRIPT STORED IN:",
  "#%  data-raw/article.r",
  "#% PLEASE, IF NEEDED, EDIT THAT DOCUMENT INSTEAD.",
  sprintf("#%% LAST UPDATE: %s", Sys.time()),
  "#%--------------------------------------------------------------------------\n\n",
  file   = "R/articles.r",
  sep    = "\n",
  append = FALSE
  )

overalldoc <- c("#' @template data-structure")


# Create one data object per article
set.seed(1)
articles <- articles[order(as.integer(gsub("_.+", "", articles)))]
for (art in articles) {

  # Creating a name for the object
  objname <- paste0("art", gsub("^([0-9])(?=(_|$))", "0\\1", art, perl = TRUE))
  arttitle <- stringr::str_to_title(gsub("_", " ", art))

  # Writing manual
  doc <- paste("#' Article", arttitle)
  doc <- c(doc, "#' @details\n#' This article includes the following sections of the [Reporting Instrument][fctc-reporting]:")
  overalldoc <- c(
    overalldoc,
    sprintf("#'\n#' @section Article %s:\n#'", arttitle),
    sprintf(
      "#' This article is associated with the dataset [%s]. It includes the following sections:",
      art,
      objname)
    )

  # Fetching the corresponding list of sections
  sec <- key$id[key$art == art]

  ans <- NULL
  for (s in sec) {

    # Writting manual
    which_id <- which(key$id == s)
    doc <- with(key[which_id,,drop=FALSE], c(doc, sprintf("#' - %s ([website](%s))", description, url)))
    overalldoc <- c(overalldoc, tail(doc, 1L))

    dat <- suppressMessages(
      readr::read_csv(sprintf("data-raw/implementation/%s.csv", s))
    )

    years <- colnames(dat)[grepl("^[0-9]{4}$", colnames(dat))]
    z <- lapply(years, function(x) cbind(dat[c("Party", x)], year=x))
    z <- lapply(z, `colnames<-`, c("party", "answer", "year"))

    z <- do.call(rbind, z)
    z$section <- unique(key$description[which_id])

    ans <- rbind(ans, z)

  }

  # Fixing types
  ans$year <- as.integer(as.character(ans$year))

  # Creating object
  assign(objname, ans, envir = .GlobalEnv)

  doc <- c(
    doc,
    sprintf(
      "#' @templateVar nobs %s\n#' @templateVar nvariables %s\n #' @template articles",
      nrow(ans),
      ncol(ans)
      )
    )

  doc <- c(doc, paste("#' @name", objname))
  doc <- c(doc, "#'\n#' @family FCTC articles", sprintf("\"%s\"\n", objname))
  cat(doc, file = "R/articles.r", sep="\n", append = TRUE)

  message("Article ", art, " done.")

}

overalldoc <- c(
  overalldoc,
  "#' @section Last update:",
  paste("#'",readLines("data-raw/implementation/readme.md")[1], collapse = "\n")
  )

overalldoc <- c(overalldoc, "NULL")
cat(overalldoc, file = "R/articles.r", sep = "\n", append = TRUE)

# Storing the data
usethis::use_data(art10, overwrite = TRUE)
usethis::use_data(art11, overwrite = TRUE)
usethis::use_data(art12, overwrite = TRUE)
usethis::use_data(art13, overwrite = TRUE)
usethis::use_data(art14, overwrite = TRUE)
usethis::use_data(art15, overwrite = TRUE)
usethis::use_data(art16, overwrite = TRUE)
usethis::use_data(art17, overwrite = TRUE)
usethis::use_data(art18, overwrite = TRUE)
usethis::use_data(art19, overwrite = TRUE)
usethis::use_data(art20, overwrite = TRUE)
usethis::use_data(art02_and_26_assistance_provided, overwrite=TRUE)
usethis::use_data(art02_and_26_assistance_received, overwrite=TRUE)
usethis::use_data(art02_and_26_other_questions_related_to_assistance, overwrite=TRUE)
usethis::use_data(art02_and_26_priorities_and_comments, overwrite=TRUE)
usethis::use_data(art05, overwrite = TRUE)
usethis::use_data(art06, overwrite = TRUE)
usethis::use_data(art08, overwrite = TRUE)
usethis::use_data(art09, overwrite = TRUE)
