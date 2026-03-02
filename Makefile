all: format doc README.md

.PHONY: format
format:
	air format .

.PHONY: doc
doc: format
	Rscript -e "usethis::use_tidy_description()"
	Rscript -e "devtools::document()"

.PHONY: check
check: doc
	Rscript -e "devtools::check()"

.PHONY: build
build: doc
	Rscript -e "devtools::build()"

.PHONY: install
install: doc
	Rscript -e "pak::local_install(upgrade = FALSE)"

.PHONY: deps
deps:
	Rscript -e "pak::local_install_dev_deps()"

.PHONY: test
test:
	Rscript -e "devtools::test(reporter = 'summary')"

.PHONY: coverage
coverage:
	Rscript -e "covr::report(covr::package_coverage(\".\"), file = \"coverage.html\")"


.PHONY: update-workflows
update-workflows:
	Rscript -e "usethis::use_github_action('check-standard')"
	Rscript -e "usethis::use_github_action('pkgdown')"
	Rscript -e "usethis::use_github_action('test-coverage')"

README.md: README.Rmd
	Rscript -e "rmarkdown::render('README.Rmd', output_file = 'README.md')"
	-rm README.html

.PHONY: site
site: doc README.md
	Rscript -e "pkgdown::build_site()"

codemeta.json: DESCRIPTION
	Rscript -e "codemetar::write_codemeta()"

.PHONY:
release: clean doc site codemeta.json

clean:
	-rm README.md
	-rm -r README_cache
	-rm man/*.rd
	-rm NAMESPACE
	$(MAKE) doc
