## Test environments

* local: darwin15.6.0-3.6.2
* travis: 3.1, 3.2, 3.3, oldrel, release, devel
* r-hub: windows-x86_64-devel, ubuntu-gcc-release, fedora-clang-devel
* win-builder: windows-x86_64-devel

## R CMD check results

0 errors | 0 warnings | 1 note

- This is a resubmission of a package archived in 2015 due to check failures.  

The current iteration of the package runs all its tests on travis (and rhub, and locally) and skips them on CRAN, because almost every function in this package can only work by making (authenticated, via client id) HTTP requests to a third-party API which in turn requires said API to be available and reliable.  
I believe this is the most practical approach to avoid check failures on CRAN that do not necessarily reflect issues with the package.

According to suggestions by CRAN members I have cautiously enabled some of the function examples out of `\dontrun{}` – these are usually small functions that fetch small amounts of data from the API and should hopefully not cause any trouble, unless however the API happens to be flaky.
