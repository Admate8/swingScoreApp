# Test your app

## Run checks ----
## Check the package before sending to prod
devtools::check()

# Deploy

## Local, CRAN or Package Manager ----
## This will build a tar.gz that can be installed locally,
## sent to CRAN, or to a package manager
devtools::build()

# Deploy to Posit Connect or ShinyApps.io
# In command line.
rsconnect::deployApp(
  appName  = desc::desc_get_field("Package"),
  appTitle = desc::desc_get_field("Package"),
  appFiles = c(
    # Add any additional files unique to your app here.
    "R/",
    "inst/",
    "data/",
    "NAMESPACE",
    "DESCRIPTION",
    "app.R"
  ),
  appId       = rsconnect::deployments(".")$appID,
  lint        = FALSE,
  forceUpdate = TRUE
)
