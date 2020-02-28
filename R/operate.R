
#' Evaluate f with x and y, badly
#'
#' @param x first input
#' @param y second input
#' @param f function to be evaluated using inputs x and y
#'
#' @export
butcher <- function(x, y, f) {
  env <- new.env() # create a new environment
  environment(f) <- env
  f(x,y)
}



#' Evaluate f with x and y
#'
#' @param x first input
#' @param y second input
#' @param f function to be evaluated using inputs x and y
#'
#' @export
operate <- function(x, y, f) {
  f(x,y)
  f(x,y)
}
