# Check username

Check username

## Usage

``` r
check_username(user, validate = FALSE)
```

## Arguments

- user:

  The username input.

- validate:

  `logical(1) [TRUE]`: Retrieve user profile to check if it exists.

## Value

An HTTP error if the checks fail or else `TRUE` invisibly. If
`validate`, the user profile is returned as a `list`.
