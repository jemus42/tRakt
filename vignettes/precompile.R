# Pre-compute vignettes that make live trakt.tv API calls.
#
# Why: vignettes are built during `R CMD check` and by the pkgdown workflow.
# If their code hits the live API, an upstream outage or drift turns the docs
# build red even when the package is fine. To avoid that, the API-backed
# vignettes are authored in `*.Rmd.orig` (with live code) and knitted *here*,
# once, into static `*.Rmd` files that ship with the package. The generated
# `.Rmd` contains the code and its baked-in output as plain text -- no requests
# are made at check/build time.
#
# See <https://ropensci.org/blog/2019/12/08/precompute-vignettes/>.
#
# Usage: run deliberately, with valid credentials / a healthy API, from the
# package root:
#
#   Rscript vignettes/precompile.R
#
# then inspect the diff of the generated `*.Rmd` and commit both files.

# Knit with the working directory set to vignettes/ so relative paths behave
# the same as during a normal vignette build.
withr::with_dir("vignettes", {
	knitr::knit("tRakt.Rmd.orig", "tRakt.Rmd")
	knitr::knit("show-analysis-24.Rmd.orig", "show-analysis-24.Rmd")
})

message("Done. Review `git diff vignettes/*.Rmd` before committing.")
