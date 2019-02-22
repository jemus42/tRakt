## Test environments
* local OS X install, R 3.5.2
* ubuntu 16.04 (on travis-ci), oldred, release, devel
* r-hub (rhub::check_for_cran)

## R CMD check results

0 errors | 0 warnings | 1 note

This is a resubmission of a package archived in 2015 due to check failures.  

The current iteration of the package runs all its tests on travis (and rhub, and locally) and skips them on CRAN, because almost every function in this package can only work by making (authenticated) HTTP requests to a third-party API which in turn requires said API to be available and reliable.  
I believe this is the most practical approach to avoid check failures on CRAN that do not necessarily reflect issues with the package.
