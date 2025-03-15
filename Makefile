all: doc README.md

doc:
	Rscript -e "devtools::document()"

check:
	Rscript -e "devtools::check()"

build:
	Rscript -e "devtools::build()"

update-workflows:
	Rscript -e "usethis::use_github_action('check-standard')"
	Rscript -e "usethis::use_github_action('pkgdown')"
	Rscript -e "usethis::use_github_action('test-coverage')"

README.md: README.Rmd
	Rscript -e "rmarkdown::render('README.Rmd', output_file = 'README.md')"
