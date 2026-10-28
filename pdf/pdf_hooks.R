# =====================================================================
# pdf_hooks.R - Ajustes de R que solo se aplican al compilar el PDF.
# render.R lo inyecta al final de index.Rmd (copia en _build/) cuando el
# formato es pdf_book. La web no lo usa y los capítulos no se tocan.
#
# Tres bloques del libro se construyen en la web con HTML escrito a mano
# (cat() de etiquetas <table>, <div>...), que en LaTeX desaparecería sin
# avisar. Aquí se sustituyen, solo en el PDF, por su versión en LaTeX:
#
#   - Capítulo 4, catálogo de planetas por galaxia (chunk que escribe
#     <table class="rs-catalogo">): una tabla por galaxia con el retrato
#     del planeta, sus compañías y sus astilleros.
#   - Capítulo 6, fichas de las compañías (ficha_card()): recuadro con la
#     forma jurídica, la flota, la sede y los once indicadores.
#   - Capítulo 6, tabla de "otras compañías" (<table class="rs-otras">).
#
# Los chunks se reconocen por su contenido (no por su etiqueta), así que
# siguen funcionando aunque se renombren. Los datos (catalogo, fichas,
# roles...) son los mismos de la web: solo cambia cómo se imprimen.
# =====================================================================

local({

  # --- Utilidades -----------------------------------------------------
  esc <- function(x) {
    x <- gsub("\\", "\001", x, fixed = TRUE)
    x <- gsub("([&%$#_{}])", "\\\\\\1", x)
    x <- gsub("~", "\\textasciitilde{}", x, fixed = TRUE)
    x <- gsub("^", "\\textasciicircum{}", x, fixed = TRUE)
    x <- gsub("\001", "\\textbackslash{}", x, fixed = TRUE)
    x
  }
  # *cursiva* y <em>cursiva</em> -> \emph{...}; <strong> -> \textbf{...}
  inline_tex <- function(x) {
    x <- esc(x)
    x <- gsub("<em>(.*?)</em>", "\\\\emph{\\1}", x, perl = TRUE)
    x <- gsub("<strong>(.*?)</strong>", "\\\\textbf{\\1}", x, perl = TRUE)
    x <- gsub("\\*\\*([^*]+)\\*\\*", "\\\\textbf{\\1}", x)
    x <- gsub("\\*([^*]+)\\*", "\\\\emph{\\1}", x)
    x
  }
  # Imagen comprimida para el PDF (la prepara render.R), si existe
  imagen_pdf <- function(nombre) {
    comp <- file.path("figuras_pdf", paste0(gsub(" ", "_", nombre), ".jpg"))
    if (file.exists(comp)) comp else file.path("figuras", nombre)
  }
  partir <- function(x) {
    if (is.na(x) || !nzchar(x)) character(0) else strsplit(x, "; ", fixed = TRUE)[[1]]
  }
  salida <- function(...) base::cat(..., sep = "")

  # --- Capítulo 4: catálogo de planetas --------------------------------
  catalogo_pdf <- function(catalogo, orden_galaxias) {
    for (g in orden_galaxias) {
      sub <- catalogo[catalogo$galaxia == g, ]
      if (nrow(sub) == 0) next
      n_emp <- sum(vapply(sub$empresas, function(x) length(partir(x)), integer(1)))
      salida("\n\\rsgalaxia{", esc(g), "}{", nrow(sub), " planetas · ",
             n_emp, " compañías}\n")
      salida("\\begingroup\\small\\setlength{\\tabcolsep}{5pt}\n",
             "\\begin{longtable}{@{}>{\\raggedright}p{3.1cm}",
             ">{\\raggedright}p{9.0cm}",
             ">{\\raggedright\\arraybackslash}p{2.9cm}@{}}\n",
             "\\toprule\n",
             "\\textsf{\\textbf{\\footnotesize PLANETA}} & ",
             "\\textsf{\\textbf{\\footnotesize COMPAÑÍAS DE TRANSPORTE CON SEDE}} & ",
             "\\textsf{\\textbf{\\footnotesize ASTILLEROS CON BASE DE FLOTA}}\\\\\n",
             "\\midrule\n\\endhead\n",
             "\\bottomrule\n\\endlastfoot\n")
      for (i in seq_len(nrow(sub))) {
        f   <- sub[i, ]
        emp <- partir(f$empresas)
        ast <- partir(f$astilleros)
        img <- if (!is.na(f$imagen)) {
          paste0("\\par\\smallskip\\includegraphics[width=3.0cm]{",
                 imagen_pdf(f$imagen), "}")
        } else {
          "\\par\\smallskip{\\footnotesize\\itshape\\color{rstarsgris}Sin retrato disponible}"
        }
        ast_tex <- if (length(ast) == 0) {
          "{\\color{rstarsgris}— (ninguno)}"
        } else {
          paste0("\\rsastillero{", esc(ast), "}", collapse = "\\par\\smallskip ")
        }
        salida(
          "{\\sffamily\\bfseries\\normalsize ", esc(f$planeta), "}", img, " & ",
          paste(esc(emp), collapse = " · "),
          "\\par\\smallskip{\\footnotesize\\color{rstarsgris}", length(emp),
          " compañía", if (length(emp) == 1) "" else "s", " con sede}",
          " & ", ast_tex, "\\\\\n",
          if (i < nrow(sub)) "\\midrule[0.3pt]\n" else "")
      }
      salida("\\end{longtable}\n\\endgroup\n")
    }
    invisible(NULL)
  }

  # --- Capítulo 6: fichas ----------------------------------------------
  ficha_pdf <- function(clave) {
    fichas <- get("fichas", envir = knitr::knit_global())
    fmt_mil <- get("fmt_mil", envir = knitr::knit_global())
    fmt_pct <- get("fmt_pct", envir = knitr::knit_global())
    fmt_idx <- get("fmt_idx", envir = knitr::knit_global())
    f <- fichas[fichas$clave == clave, ]
    if (nrow(f) == 0) {
      warning("Ficha no encontrada: ", clave, call. = FALSE)
      return(invisible(NULL))
    }
    pares <- list(
      c("Activo",                paste0(fmt_mil(f$activo), " miles PAVOs")),
      c("Ingresos",              paste0(fmt_mil(f$ing),    " miles PAVOs")),
      c("Margen operativo",      fmt_pct(f$margen)),
      c("Rent. económica",       fmt_pct(f$reneco)),
      c("Rent. financiera",      fmt_pct(f$renfin)),
      c("Empleados",             fmt_mil(f$emplea)),
      c("Flota",                 paste0(fmt_mil(f$flota), " cargueros")),
      c("Rutas",                 fmt_mil(f$rutas)),
      c("Fidelización (IFIDE)",  fmt_idx(f$ifide)),
      c("Digitalización (IDIG)", fmt_idx(f$idig)),
      c("Diversificación (IDIVERSE)", fmt_idx(f$idiverse))
    )
    celdas <- vapply(pares, function(p)
      paste0("\\rsdato{", esc(p[1]), "}{", esc(p[2]), "}"), character(1))
    while (length(celdas) %% 4 != 0) celdas <- c(celdas, "")
    filas <- vapply(split(celdas, ceiling(seq_along(celdas) / 4)),
                    paste, character(1), collapse = " & ")
    salida(
      "\n\\begin{rsficha}\n",
      "\\rsbadge{", esc(f$fjur), "}\\hspace{0.4em}",
      "\\rsbadge{Flota ", esc(tolower(f$eflo)), "}\\hfill",
      "{\\sffamily\\small\\bfseries\\color{rstars}Sede: ", esc(f$sede),
      " · ", esc(f$galaxia), "}\\par\n",
      "\\vspace{3pt}{\\color{rstarsgris!35}\\hrule}\\vspace{5pt}\n",
      "\\noindent\\begin{tabular}{@{}*{4}{p{\\dimexpr0.25\\linewidth-1.5\\tabcolsep\\relax}}@{}}\n",
      paste(filas, collapse = "\\\\[5pt]\n"), "\n",
      "\\end{tabular}\n",
      "\\end{rsficha}\n\n")
    invisible(NULL)
  }

  # --- Capítulo 6: otras compañías ------------------------------------
  otras_pdf <- function(roles) {
    fichas  <- get("fichas", envir = knitr::knit_global())
    fmt_mil <- get("fmt_mil", envir = knitr::knit_global())
    salida("\n\\begingroup\\small\\setlength{\\tabcolsep}{4pt}\n",
           "\\begin{longtable}{@{}>{\\raggedright}p{2.6cm}",
           ">{\\raggedright}p{2.4cm}",
           "r r r r",
           ">{\\raggedright\\arraybackslash}p{4.75cm}@{}}\n",
           "\\toprule\n",
           "\\textbf{Compañía} & \\textbf{Sede (galaxia)} & \\textbf{Activo} & ",
           "\\textbf{Empl.} & \\textbf{Flota} & \\textbf{Rutas} & ",
           "\\textbf{Dónde se cita}\\\\\n\\midrule\n\\endhead\n",
           "\\bottomrule\n",
           "\\multicolumn{7}{@{}l}{\\rule{0pt}{1.3em}\\footnotesize\\color{rstarsgris}",
           "Activo en miles de PAVOs. Datos de la base \\texttt{interestelar\\_300}.}\\\\\n",
           "\\endlastfoot\n")
    n <- 0
    for (k in names(roles)) {
      f <- fichas[fichas$clave == k, ]
      if (nrow(f) == 0) next
      n <- n + 1
      salida(
        if (n %% 2 == 0) "\\rowcolor{rstarsfila}" else "",
        "\\textbf{", esc(f$nombre), "} & ",
        esc(f$sede), " {\\footnotesize\\color{rstarsgris}(", esc(f$galaxia), ")} & ",
        fmt_mil(f$activo), " & ", fmt_mil(f$emplea), " & ",
        fmt_mil(f$flota), " & ", fmt_mil(f$rutas), " & ",
        inline_tex(roles[[k]]), "\\\\\n")
    }
    salida("\\end{longtable}\n\\endgroup\n\n")
    invisible(NULL)
  }

  assign(".rs_catalogo_pdf", catalogo_pdf, envir = knitr::knit_global())
  assign(".rs_ficha_pdf",    ficha_pdf,    envir = knitr::knit_global())
  assign(".rs_otras_pdf",    otras_pdf,    envir = knitr::knit_global())

  # --- Sustitución de los chunks HTML -----------------------------------
  # El código original se ejecuta igual (así se definen los datos), pero
  # con cat() silenciado; después se imprime la versión LaTeX.
  envolver <- function(codigo, llamada) {
    c("local({", "cat <- function(...) invisible(NULL)",
      codigo, llamada, "})")
  }
  knitr::opts_hooks$set(results = function(options) {
    codigo <- paste(options$code, collapse = "\n")
    if (grepl('class="rs-catalogo"', codigo, fixed = TRUE)) {
      options$code <- envolver(options$code,
                               ".rs_catalogo_pdf(catalogo, orden_galaxias)")
    } else if (grepl('class="rs-otras"', codigo, fixed = TRUE)) {
      options$code <- envolver(options$code, ".rs_otras_pdf(roles)")
    } else if (grepl("ficha_card\\s*<-\\s*function", codigo)) {
      options$code <- c(options$code, "ficha_card <- .rs_ficha_pdf")
    }
    options
  })
})
