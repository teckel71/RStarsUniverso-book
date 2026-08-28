#!/usr/bin/env Rscript
# =====================================================================
# render.R - Renderizado del libro R-Stars: El Universo.
# ---------------------------------------------------------------------
# Uso:
#   Rscript render.R                 # Renderiza con el primer formato de _output.yml (bs4_book)
#   Rscript render.R bookdown::pdf_book
#
# Requisitos: paquete `bookdown` (y `rmarkdown`, `knitr`).
# El resultado se genera en la carpeta indicada en `_bookdown.yml`
# (`output_dir: docs`).
# =====================================================================

args    <- commandArgs(trailingOnly = TRUE)
formato <- if (length(args) >= 1) args[1] else NULL

if (!requireNamespace("bookdown", quietly = TRUE)) {
  stop("Falta el paquete 'bookdown'. Instálalo con install.packages('bookdown').")
}

bookdown::render_book(
  input         = "index.Rmd",
  output_format = formato
)

cat("\n[OK] Libro renderizado.\n")
