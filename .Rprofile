## Print this on start so I know it's loaded.
## cat("Loading custom .Rprofile")


### Misc options
options(stringsAsFactors = FALSE)         # Doing the right(eous) thing.


### Prompt
options(prompt = sample(c("☉ ", "♫ ", "⚒ ", "⚙ "), 1),
        continue = "   ↳ ")


### Startup
startup <- function(){
  version     <- R.Version()
  # date_string <- format(Sys.Date(), "%A, der %d. %B %Y")
  ddate       <- ddateR::ddate()

  msg <- sprintf("Oh hello! Great to see you again!\n%s
                  \nYou're working with %s. Let's crunch some numbers!",
                 ddate, version$nickname)

  cat(paste0("\014", msg, "\n\n"))
}

startup()
rm(startup)


### Packages
# suppressPackageStartupMessages(library("devtools"))
suppressPackageStartupMessages(library("ddateR"))
