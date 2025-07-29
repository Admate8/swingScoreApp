# Engineering

## Dependencies ----
usethis::use_package("dplyr",           min_version = TRUE)
usethis::use_package("tibble",          min_version = TRUE)
usethis::use_package("bslib",           min_version = TRUE)
usethis::use_package("reactable",       min_version = TRUE)
usethis::use_package("shinyWidgets",    min_version = TRUE)
usethis::use_package("purrr",           min_version = TRUE)
usethis::use_package("glue",            min_version = TRUE)
usethis::use_package("echarts4r",       min_version = TRUE)
usethis::use_package("shinyjs",         min_version = TRUE)
usethis::use_package("htmlwidgets",     min_version = TRUE)
usethis::use_package("tidyr",           min_version = TRUE)
usethis::use_package("shinycssloaders", min_version = TRUE)
usethis::use_package("stringr",         min_version = TRUE)
usethis::use_package("here",            min_version = TRUE)
usethis::use_tidy_description()
# attachment::att_amend_desc()

## External resources
## Creates .js and .css files at inst/app/www
# golem::add_js_file("fullPageSettings")
# golem::add_js_handler("handlers")
# golem::add_sass_file("custom_styles")

## Add internal datasets ----
## If you have data in your package
usethis::use_data_raw(name = "my_dataset", open = FALSE)

# Documentation

## Vignette ----
usethis::use_vignette("swingScore")
devtools::build_vignettes()

## Code Coverage----
## Set the code coverage service ("codecov" or "coveralls")
# usethis::use_coverage()

# Create a summary readme for the testthat subdirectory
# covrpage::covrpage()

rstudioapi::navigateToFile("dev/03_deploy.R")
