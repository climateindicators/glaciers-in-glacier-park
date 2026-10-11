# Build tidy long-format data for the A Closer Look: Glaciers in Glacier National Park indicator.
#
#   Rscript R/build_data.R
#
# Reads EPA's published figure CSVs in data-raw/ and writes data/*.csv plus
# data/meta.yml. Rerunning with unchanged inputs produces byte-identical output.
# Nothing here touches the network.
#
# Generated as a stub by the build-indicator skill. Each figure below has a
# `todo_reshape()` call standing where its reshape belongs. Replace that line,
# then delete the todo_reshape() helper once no call to it remains.
#
# TO UPDATE THE DATA: drop replacement CSVs into data-raw/ and rerun. Headers
# are asserted, not assumed, so a renamed or reordered column stops the build.

suppressPackageStartupMessages({
  library(dplyr)
})

root <- here::here()
source(file.path(root, "R/utils/epa_csv.R"))
source(file.path(root, "R/utils/write_stable.R"))

raw_dir <- file.path(root, "data-raw")
out_dir <- file.path(root, "data")
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

# ---- Indicator constants -----------------------------------------------------

INDICATOR <- list(
  name                    = "A Closer Look: Glaciers in Glacier National Park",
  slug                    = "glaciers-in-glacier-park",
  publisher               = "U.S. Environmental Protection Agency",
  source_page             = "https://19january2025snapshot.epa.gov/climate-indicators/closer-look-glaciers-glacier-national-park/index.html",
  technical_documentation = "https://19january2025snapshot.epa.gov/sites/default/files/2021-03/documents/glaciernp_td.pdf",
  rights                  = "Public domain, work of the U.S. Government (17 U.S.C. 105)"
)

# ---- Figure 1: Total Glacier Area in Glacier National Park, 1966–2015 ----

f1_path <- file.path(raw_dir, "glacier-park_fig-1.csv")
f1_meta <- read_epa_preamble(f1_path)
f1_raw  <- read_epa_csv(f1_path)

# All columns are listed as expected headers so a rename or reorder stops the
# build from the first run. When you write the reshape, move the identifier
# columns into id_cols so the split between keys and series is explicit.
F1_VALUE <- "Total glacier area"

assert_headers(
  f1_raw,
  id_cols          = "Year",
  expected_headers = F1_VALUE,
  what             = "glacier-park_fig-1.csv"
)

# One series measured at four survey years, so year and value is the whole
# shape. Values stay character so EPA's 10 significant digits survive.
f1 <- f1_raw |>
  transmute(year = Year, value = .data[[F1_VALUE]])
f1 <- f1[order(as.integer(f1$year)), ]

assert_conservation(f1_raw, F1_VALUE, nrow(f1), "glacier-park_fig-1.csv")

write_csv_stable(f1, file.path(out_dir, "glacier_park_total_area.csv"))

# ---- Data dictionary ---------------------------------------------------------

col <- function(name, type, description) {
  list(name = name, type = type, description = description)
}

meta <- list(
  indicator = INDICATOR,
  datasets = list(
    list(
      file            = "glacier_park_total_area.csv",
      figure          = "Figure 1",
      figure_title    = f1_meta$title,
      source_file     = "glacier-park_fig-1.csv",
      source_sha256   = file_sha256(f1_path),
      source_encoding = "windows-1252",
      data_source     = f1_meta$data_source,
      web_update      = f1_meta$web_update,
      unit            = f1_meta$units,
      rows            = nrow(f1),
      columns         = list(
        col("year", "integer", "Year of the aerial survey: 1966, 1998, 2005, or 2015."),
        col("value", "number", "Total surface area of the 37 named glaciers in Glacier National Park, in square miles.")
      )
    )
  )
)

write_yaml_stable(meta, file.path(out_dir, "meta.yml"))

# ---- Verify what was written -------------------------------------------------

written <- list.files(out_dir, pattern = "[.](csv|yml)$", full.names = TRUE)
invisible(lapply(written, assert_clean_output))

cat("\nWrote:\n")
for (p in written) {
  cat(sprintf("  %-34s %8d bytes  %s\n", basename(p), file.size(p), substr(file_sha256(p), 1, 12)))
}
