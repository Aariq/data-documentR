#' Create metadata for a data frame
#'
#' Prompts the user for short descriptions of a dataset as well as descriptions of the data contained in each of its columns.
#'
#' @param df a data frame
#'
#' @return a list
#' @import glue
#' @import crayon
#' @importFrom purrr map2
#' @importFrom lubridate tz
#' @importFrom rlang as_name enquo
#' @export
#'
#' @examples
#' \dontrun{
#' describe(mtcars)
#' }
describe <- function(df){
  dfname <- as_name(enquo(df))
  foo <- function(x, col_name) {
    x_class <- class(x)[1]
    class_abrev <- switch(x_class,
                          "character" = "<chr>",
                          "numeric" ="<dbl>",
                          "integer" = "<int>",
                          "logical" = "<lgl>",
                          "factor" = "<fct>",
                          "Date" = "<date>",
                          "POSIXct" = "<POSIXct>")
    #factors
    if (is.factor(x)) {
      lvls <- levels(x)
      lvl_str <- glue_collapse(lvls, sep = ", ", width = 25, last = ", and ")
      cat("Enter description for", blue(glue("`{col_name}` <fctr w/ {length(lvls)} levels>")))
      desc <- readline(prompt = "Description: ")
      cat("Describe how to interpet the levels", blue(glue("({lvl_str})")))
      details <-readline(prompt = "Levels: ")

      #posixct date times
    } else if (inherits(x, "POSIXct")) {
      cat("Enter description for", blue(glue("`{col_name}` {class_abrev}.")))
      desc <- readline(prompt = "Description: ")
      tz <- tz(x)
      if (tz != "")
        ans <-
        menu(
          title = glue("Is {green(tz(x))} the correct time zone for `{blue(col_name)}`?"),
          choices = c("Yes", "No")
        )
      if(tz == "") {
        cat(glue("Enter a timezone for `{blue(col_name)}`"))
        tz <- readline(prompt = "Timezone: ")
      }
      details <- c("format: ISO (yyyy-mm-dd HH:MM:SS)", glue("time zone: {tz}"))

      #dates
    } else if (inherits(x, "date")) {
      details <- "format: ISO (yyyy-mm-dd)"

      #double
    } else if (inherits(x, "numeric")) {
      cat("Enter description for", blue(glue("`{col_name}` {class_abrev}.")))
      desc <- readline(prompt = "Description: ")
      cat(glue("what are the units for {blue(col_name)}?"))
      u <- readline(prompt = "Units: ")
      details <- glue("Units: {u}")

      #everythign else
    } else {
      cat("Enter description for", blue(glue("`{col_name}` {class_abrev}.")))
      desc <- readline(prompt = "Description: ")
      details <- NULL
    }
    return(list(desc = desc, details = details))
  }
  cat("Enter a description for", blue(glue("`{dfname}`")),
"Include details such as the when, where, how, why, and by whom it was collected: ")
  gen_desc <- readline(prompt = "Description: ")
  col_desc <- map2(df, colnames(df), ~foo(.x, .y))
  return(list(gen_desc = gen_desc, col_desc = col_desc))
}


docr <- function(x, path) {
  x <- pluck(out, 2)
  descriptions <- map_chr(x, as_mapper("desc"))
  details <- map(x, as_mapper("details"))


  write_lines(
    paste0(glue("## Description\n
{out$gen_desc}\n
## Columns:\n\n
"),
           glue_collapse(glue("`{names(x)}` : {descriptions}\n
- {details}\n\n
 "))),
    path)
}

docr(out, here::here("test.md"))
