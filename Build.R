# Build.R  (en la carpeta del proyecto)
# =====================================================================
# Compila R-Stars: El Universo y lo deja listo para publicar en GitHub
# Pages. Uso, desde RStudio:  source("Build.R")
#
#   generar_web: el libro HTML en docs/ (lo de siempre).
#   generar_pdf: además, la versión PDF (A4) en docs/RStars-El-Universo.pdf,
#                enlazada desde la portada de la web.
# Para corregir erratas deprisa: generar_pdf <- FALSE (y recompilar el
# PDF antes de publicar la versión definitiva).
# Para probar solo el PDF: generar_web <- FALSE.
# =====================================================================
generar_web <- TRUE
generar_pdf <- TRUE

build_book <- function() {
  if (!file.exists("render.R")) stop("No se encuentra render.R.")
  source("render.R", local = new.env(), encoding = "UTF-8")

  # GitHub Pages: evitar el procesado Jekyll
  if (!dir.exists("docs")) dir.create("docs", recursive = TRUE)
  if (!file.exists("docs/.nojekyll")) file.create("docs/.nojekyll")
  message("Web generada en docs/.")
}

build_pdf <- function(destino = "docs/RStars-El-Universo.pdf") {

  if (!requireNamespace("tinytex", quietly = TRUE) ||
      !nzchar(Sys.which("xelatex")) && !tinytex::is_tinytex()) {
    warning("No hay LaTeX instalado: no se genera el PDF (la web sí). ",
            "Instálalo con tinytex::install_tinytex().", call. = FALSE)
    return(invisible(FALSE))
  }
  if (!requireNamespace("magick", quietly = TRUE)) {
    message("Aviso: falta el paquete 'magick' (install.packages('magick')). ",
            "Sin él, el PDF usa las imágenes originales y pesa muchísimo.")
  }

  t0 <- Sys.time()
  message("\n=== Generando la versión PDF... ===")

  # El PDF se compila en una sesión de R NUEVA (proceso aparte), para que
  # no le afecte nada de lo cargado al generar la web. Un fallo aquí no
  # afecta a la web, ya generada.
  rscript <- file.path(R.home("bin"), "Rscript")
  estado  <- system2(rscript,
                     c("--no-save", "--no-restore", "render.R",
                       "bookdown::pdf_book"),
                     stdout = "", stderr = "")
  ok <- identical(as.integer(estado), 0L)
  if (!ok) message("ERROR al generar el PDF (código ", estado, ").")

  pdf_generado <- "_pdf/RStarsUniverso.pdf"
  if (ok && file.exists(pdf_generado)) {
    if (!dir.exists(dirname(destino))) dir.create(dirname(destino))
    file.copy(pdf_generado, destino, overwrite = TRUE)
    mb  <- round(file.size(destino) / 1024^2, 1)
    min <- round(as.numeric(difftime(Sys.time(), t0, units = "mins")), 1)
    message(sprintf("PDF listo: %s (%s MB, %s min).", destino, mb, min))
    invisible(TRUE)
  } else {
    warning("No se ha podido generar el PDF. La web SÍ está actualizada. ",
            "Para diagnosticar, revisa _build/RStarsUniverso.log.",
            call. = FALSE)
    invisible(FALSE)
  }
}

if (generar_web) build_book()
if (generar_pdf) build_pdf()
message("\nListo. Revisa el resultado y haz Commit + Push en GitHub Desktop.")
