#! /usr/bin/env Rscript
rmarkdown::render(input         = "./for_starters.Rmd",
                  output_format = "html_document")

# Collect output files

out_docs   <- paste0("./", c(list.files(path = "./", pattern = "*.html")))
out_assets <- c("assets", "for_starters_files")


# Copy files to btsync directory

out_dir <- "~/Dokumente/syncthing/tobi.tadaa-data.de/sugr/"

sapply(out_docs,   file.copy, to = out_dir, overwrite = T, recursive = F)
sapply(out_assets, file.copy, to = out_dir, overwrite = T, recursive = T)


# since everything works fine, this isn't of any use for now,
# I'll keep it just in case anything breaks

# system(command = "cp -r ./_site/ ~/Dokumente/btsync/tobi.tadaa-data.de/Netrunner/")
