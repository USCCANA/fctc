
rm(list = ls())

key <- readr::read_csv("data-raw/implementation/implementation_key.csv")
articles <- sort(unique(key$art))

file.remove("R/articles.r")

# Create one data object per article
for (art in articles) {

  # Creating a name for the object
  objname <- paste0("art", gsub("^([0-9])(?=(_|$))", "0\\1", art, perl = TRUE))

  # Writing manual
  doc <- paste("#' Article", art)
  doc <- c(doc, "#' @details\n#' This article includes the following sections:")

  # Fetching the corresponding list of sections
  sec <- key$id[key$art == art]

  ans <- NULL
  for (s in sec) {

    # Writting manual
    doc <- with(key[key$id == s,,drop=FALSE], c(doc, sprintf("#' - %s ([website](%s))", description, url)))

    dat <- suppressMessages(
      readr::read_csv(sprintf("data-raw/implementation/%s.csv", s))
    )

    years <- colnames(dat)[grepl("^[0-9]{4}$", colnames(dat))]
    z <- lapply(years, function(x) cbind(dat[c("Party", x)], year=x))
    z <- lapply(z, `colnames<-`, c("party", "answer", "year"))

    z <- do.call(rbind, z)
    z$section <- s

    ans <- rbind(ans, z)

  }

  # Creating object
  assign(objname, ans, envir = .GlobalEnv)

  doc <- c(doc, sprintf("#' @format A dataset with %i rows and %i columns.", nrow(ans), ncol(ans)))

  doc <- c(doc, paste("#' @name", objname))
  doc <- c(doc, "#'\n#' @family FCTC articles", sprintf("\"%s\"\n", objname))
  cat(doc, file = "R/articles.r", sep="\n", append = TRUE)

  message("Article ", art, " done.")

}

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
