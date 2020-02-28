
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ohno

<!-- badges: start -->

<!-- badges: end -->

The goal of ohno is to check a potential workaround when an existing
package (in this case ohno) defines a functional (`ohno::butcher`) that
modifies the environment associated with the user-supplied function,
with the result that the created closures can be bizarre.

``` r
remotes::install_github("djnavarro/ohno")
```

Here’s the problem:

``` r
library(ohno)

add_with <- function(z) {
  function(x,y) {x + y + z}
}

# ideally we want these to both return 7...
operate(x = 2, y = 4, add_with(z = 1))
#> [1] 7
butcher(x = 2, y = 4, add_with(z = 1))
#> Error in f(x, y): object 'z' not found
```

What’s going on here is that the `operate()` function does exactly what
you’d expect:

``` r
operate
#> function(x, y, f) {
#>   f(x,y)
#>   f(x,y)
#> }
#> <bytecode: 0x5616c75c4040>
#> <environment: namespace:ohno>
```

whereas `butcher()` does something weird, and breaks the `adds_with()`
closure:

``` r
butcher
#> function(x, y, f) {
#>   env <- new.env() # create a new environment
#>   environment(f) <- env
#>   f(x,y)
#> }
#> <bytecode: 0x5616c7016fa8>
#> <environment: namespace:ohno>
```

A simple fix that doesn’t require the user to inject values into the
hidden `env` environment is to use `substitute()` to evaluate `z` early:

``` r
add_with <- function(z) {
  eval(substitute(function(x,y){x + y + z}))
}

operate(2, 4, add_with(1))
#> [1] 7
butcher(2, 4, add_with(1))
#> [1] 7
```
