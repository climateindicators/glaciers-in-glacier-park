# Provenance

Every file in this directory is reproduced unmodified from EPA's published
indicator page and its per-figure data downloads. To update the data, replace the
file and rerun `Rscript R/build_data.R`.

## Indicator page

- `source-page.html`  \
  <https://19january2025snapshot.epa.gov/climate-indicators/closer-look-glaciers-glacier-national-park/index.html>  \
  sha256 `ead68f8716aa8b3f4f6f3368284d05d3be852c1ac165c2c9818cb92826bf0189`

Technical documentation: <https://19january2025snapshot.epa.gov/sites/default/files/2021-03/documents/glaciernp_td.pdf>

## Figure data

- `glacier-park_fig-1.csv`  \
  <https://19january2025snapshot.epa.gov/sites/default/files/2021-03/glacier-park_fig-1.csv>  \
  sha256 `f99a909115431a915240d3b0cec1d01c5feaaadc1c6f6dcf435dc0bbd486aef0`  \
  encoding windows-1252, 4 data rows, columns: `Year`, `Total glacier area`  \
  title: Figure 1. Total Glacier Area in Glacier National Park, 1966–2015  \
  data source: Fagre et al., 2017; USGS, 2017.; web update: April 2021; units: square miles

- **Figure 2** has no data download on EPA's page. The narrative carries the caption; there is nothing to build.
