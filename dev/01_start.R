## Fill the DESCRIPTION ----
## Add meta data about your application
##
## /!\ Note: if you want to change the name of your app during development,
## either re-run this function, call golem::set_golem_name(), or don't forget
## to change the name in the app_sys() function in app_config.R /!\
##
golem::fill_desc(
  pkg_name          = "swingScore",
  pkg_title         = "swingScore",
  pkg_description   = "Measuring West Coast Swing competition progression.",
  author_first_name = "Adrian",
  author_last_name  = "Wisnios",
  author_email      = "omega.dancing.score@gmail.com",
  repo_url          = "https://github.com/Admate8/swingScoreApp",
  pkg_version       = "0.0.1"
)

## Set {golem} options ----
golem::set_golem_options()

## Install the required dev dependencies ----
golem::install_dev_deps()

## Create Common Files ----
## See ?usethis for more information
#usethis::use_gpl_license(version = 3, include_future = TRUE)
#usethis::use_readme_rmd(open = FALSE)
#devtools::build_readme()

# Note that `contact` is required since usethis version 2.1.5
# If your {usethis} version is older, you can remove that param
usethis::use_code_of_conduct(contact = "omega.dancing.score@gmail.com")
# usethis::use_lifecycle_badge("Experimental")
# usethis::use_news_md(open = FALSE)

## Init Testing Infrastructure ----
## Create a template for tests
# golem::use_recommended_tests()

## Favicon ----
golem::use_favicon() # path = "path/to/ico". Can be an online file.
# golem::remove_favicon() # Uncomment to remove the default favicon

rstudioapi::navigateToFile("dev/02_dev.R")
