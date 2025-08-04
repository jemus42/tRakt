all: doc README.md

.PHONY: doc
doc:
	Rscript -e "devtools::document()"

.PHONY: check
check: doc
	Rscript -e "devtools::check()"

.PHONY: build
build: doc
	Rscript -e "devtools::build()"

.PHONY: install
install:
	Rscript -e "pak::local_install(upgrade = FALSE)"

.PHONY: test
test:
	Rscript -e "devtools::test()"

.PHONY: update-workflows
update-workflows:
	Rscript -e "usethis::use_github_action('check-standard')"
	Rscript -e "usethis::use_github_action('pkgdown')"
	Rscript -e "usethis::use_github_action('test-coverage')"

README.md: README.Rmd
	Rscript -e "rmarkdown::render('README.Rmd', output_file = 'README.md')"
	-rm README.html

.PHONY: site
site: doc
	Rscript -e "pkgdown::build_site()"

codemeta.json: DESCRIPTION
	Rscript -e "codemetar::write_codemeta()"

.PHONY:
release: doc site codemeta.json

clean:
	-rm README.md
	-rm -r README_cache
	-rm man/*.rd
	-rm NAMESPACE
