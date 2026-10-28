#!/usr/bin/env Rscript
# =====================================================================
# render.R - Renderizado del libro R-Stars: El Universo.
# ---------------------------------------------------------------------
# Uso:
#   Rscript render.R                     # web (bs4_book) en docs/
#   Rscript render.R bookdown::pdf_book  # versión PDF (A4) en _pdf/
#
# Lo normal es no llamarlo directamente, sino con source("Build.R"),
# que genera la web y el PDF y deja el PDF en docs/.
#
# - La WEB se renderiza exactamente igual que siempre, desde la carpeta
#   del proyecto.
# - El PDF se prepara en una carpeta aparte, _build/ (fuera de git):
#     1. Copia allí los .Rmd, la configuración y la carpeta pdf/.
#     2. Prepara copias comprimidas de las imágenes (figuras_pdf/), para
#        que el PDF no pese cientos de megas (los retratos de planetas
#        son PNG de 7-8 MB). Se guardan en _pdf/figuras_pdf/ y solo se
#        regeneran si cambia la imagen original. Necesita el paquete
#        {magick}; si no está, se usan las originales (PDF enorme).
#     3. Añade al final de index.Rmd los ajustes propios del PDF
#        (pdf/pdf_hooks.R).
#     4. Renderiza; el resultado queda en _pdf/RStarsUniverso.pdf y el
#        .log de LaTeX en _build/RStarsUniverso.log.
# =====================================================================

args    <- commandArgs(trailingOnly = TRUE)
formato <- if (length(args) >= 1) args[1] else NULL
es_pdf  <- !is.null(formato) && grepl("pdf", formato)

if (!requireNamespace("bookdown", quietly = TRUE)) {
  stop("Falta el paquete 'bookdown'. Instálalo con install.packages('bookdown').")
}

# ---------------------------------------------------------------------
# WEB: igual que siempre
# ---------------------------------------------------------------------
if (!es_pdf) {
  bookdown::render_book(
    input         = "index.Rmd",
    output_format = formato
  )
  cat("\n[OK] Libro renderizado en 'docs/'.\n")
}

# ---------------------------------------------------------------------
# PDF
# ---------------------------------------------------------------------

# Copias comprimidas de las imágenes: figuras/Mi foto.png ->
# <cache>/Mi_foto.png.jpg (como mucho `ancho` píxeles de ancho, JPEG).
preparar_figuras_pdf <- function(origen = "figuras",
                                 cache  = file.path("_pdf", "figuras_pdf"),
                                 ancho  = 1600, calidad = 85) {
  imgs <- list.files(origen, pattern = "\\.(png|jpe?g)$", ignore.case = TRUE)
  if (length(imgs) == 0) return(invisible(NULL))
  if (!requireNamespace("magick", quietly = TRUE)) {
    warning("No está instalado el paquete 'magick': el PDF usará las ",
            "imágenes originales y pesará muchísimo. Instálalo con ",
            "install.packages('magick').", call. = FALSE, immediate. = TRUE)
    return(invisible(NULL))
  }
  dir.create(cache, recursive = TRUE, showWarnings = FALSE)
  nuevas <- 0
  for (f in imgs) {
    src <- file.path(origen, f)
    dst <- file.path(cache, paste0(gsub(" ", "_", f), ".jpg"))
    if (file.exists(dst) && file.mtime(dst) >= file.mtime(src)) next
    im <- magick::image_read(src)
    im <- magick::image_scale(im, paste0(ancho, ">"))
    im <- magick::image_background(im, "white")
    im <- magick::image_flatten(im)
    magick::image_write(im, dst, format = "jpeg", quality = calidad)
    nuevas <- nuevas + 1
  }
  cat(sprintf("      Imágenes para el PDF: %d (%d nuevas o actualizadas).\n",
              length(imgs), nuevas))
  invisible(cache)
}

if (es_pdf) {
  build_dir  <- "_build"
  output_dir <- "_pdf"

  if (dir.exists(build_dir)) unlink(build_dir, recursive = TRUE)
  dir.create(build_dir)
  dir.create(output_dir, showWarnings = FALSE)
  cat(sprintf("[1/4] Carpeta '%s/' creada.\n", build_dir))

  # Configuración, bibliografía y capítulos
  ficheros <- c("index.Rmd", "_bookdown.yml", "_output.yml", "preamble.tex",
                "_common.R",
                list.files(pattern = "\\.(bib|csl)$"),
                list.files(pattern = "^[0-9]+.*\\.Rmd$"))
  file.copy(ficheros, build_dir, overwrite = TRUE)
  for (d in c("assets", "data", "pdf")) {
    if (dir.exists(d)) file.copy(d, build_dir, recursive = TRUE)
  }
  cat(sprintf("[2/4] Copiados %d ficheros del libro.\n", length(ficheros)))

  # Imágenes: las comprimidas en figuras_pdf/; las originales solo si no
  # hay copia comprimida (p. ej. si falta {magick}).
  cache <- preparar_figuras_pdf()
  dir.create(file.path(build_dir, "figuras"), showWarnings = FALSE)
  if (!is.null(cache)) {
    file.copy(cache, build_dir, recursive = TRUE)
    hechas <- sub("\\.jpg$", "", list.files(cache))
  } else {
    hechas <- character(0)
  }
  originales <- list.files("figuras")
  faltan <- originales[!gsub(" ", "_", originales) %in% hechas]
  file.copy(file.path("figuras", faltan), file.path(build_dir, "figuras"))
  cat(sprintf("[3/4] Imágenes listas (%d comprimidas, %d originales).\n",
              length(hechas), length(faltan)))

  # Ajustes de R propios del PDF, al final de index.Rmd (va antes que
  # todos los capítulos)
  cat("\n\n```{r rstars-pdf-hooks, include=FALSE}\n",
      "source(\"pdf/pdf_hooks.R\", encoding = \"UTF-8\")\n```\n",
      sep = "", file = file.path(build_dir, "index.Rmd"), append = TRUE)

  cat("[4/4] Renderizando el PDF ...\n")
  output_dir_abs <- normalizePath(output_dir)
  proyecto_dir   <- getwd()
  local({
    on.exit(setwd(proyecto_dir), add = TRUE)
    setwd(build_dir)
    options(tinytex.clean = FALSE)   # conserva el .log para diagnosticar
    bookdown::render_book(input = ".", output_format = formato,
                          output_dir = output_dir_abs)
  })
  cat(sprintf("\n[OK] PDF generado en '%s/'.\n", output_dir))
}
