# R-Stars: El Universo

Guía divulgativa del marco narrativo *R-Stars*, el escenario de ciencia
ficción que da contexto a los manuales técnicos del proyecto
[**R-Teca**](https://blog.uclm.es/miguelangeltarancon/r-teca/):

- [R-Stars: La Guía](https://teckel71.github.io/RStars-book/)
- [Estadística Empresarial](https://teckel71.github.io/EstadisticaEmpresarial-book/)

Este libro no es un manual técnico ni pretende enseñar estadística o R:
reúne, en un solo sitio y con tono narrativo, todo lo que hay que saber
sobre las compañías, planetas, personajes y organizaciones que pueblan
los ejercicios de los manuales serios.

El libro está construido con [R Markdown](https://rmarkdown.rstudio.com/) y
[**bookdown**](https://bookdown.org/yihui/bookdown/), y publicado en GitHub
Pages en <https://teckel71.github.io/RStarsUniverso-book/>.

## Estructura

- `index.Rmd` — Portada, metadatos y cabecera del libro.
- `00-prefacio.Rmd` — Prefacio.
- `01-como_usar.Rmd` — El proyecto R-Teca y cómo usar este libro.
- `02-cronologia.Rmd` — Cronología del sector interestelar.
- `03-fisica_warp.Rmd` — La física del plasma warp.
- `04-geografia.Rmd` — Geografía galáctica.
- `05-personajes_organizaciones.Rmd` — Personajes ilustres y organizaciones.
- `06-companias_astilleros.Rmd` — Compañías y astilleros del sector.
- `07-bases_datos.Rmd` — Las bases de datos del universo R-Stars.
- `08-guinos.Rmd` — Guiños, glosario y coda.
- `20-references.Rmd` — Bibliografía.
- `99-licencia.Rmd` — Licencia.

## Compilación

Desde la consola de R, en el directorio del proyecto:

```r
bookdown::render_book("index.Rmd", "bookdown::bs4_book")
```

O bien, desde RStudio: pestaña **Build > Build Book**.

El resultado se genera en la carpeta `docs/`, que es la que utiliza GitHub
Pages para servir el libro.

## Licencia

© 2026 Miguel Ángel Tarancón Morán. Licencia
[CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/deed.es).
