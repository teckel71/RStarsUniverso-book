--[[
filtro.lua - Adapta el libro web a LaTeX/PDF sin tocar los .Rmd.
Solo actua cuando la salida es LaTeX (bookdown::pdf_book).
Basado en el de R-Stars: La Guía, adaptado a R-Stars: El Universo.

  1. Capitulos sin numero (Prefacio, Bibliografia, Licencia): la cabecera
     de sus paginas muestra su titulo.
  2. Salida de consola de R con corte de linea.
  3. Un unico estilo de tabla (filetes, sin rayas verticales, filas
     alternas en gris claro), ajustada al ancho de la pagina.
  4. Imagenes: se usa la copia comprimida de figuras_pdf/ (la prepara
     render.R) para que el PDF no pese cientos de megas.
  5. Videos de YouTube (en el PDF, _common.R deja una cita
     "> **Video:** [titulo](url)"): recuadro con titulo, enlace y QR.
  6. Bibliografia: las referencias van tras el titulo "Bibliografia" y
     no al final del libro (despues de la licencia).
  7. Omite la portada web (index.Rmd): el PDF tiene la suya propia
     (pdf/portada.tex).
]]

if not FORMAT:match('latex') then return {} end

local function latex(s) return pandoc.RawBlock('latex', s) end

-- Escapa los caracteres especiales de LaTeX
local especiales = {
  ['\\'] = '\\textbackslash{}', ['{'] = '\\{', ['}'] = '\\}',
  ['$'] = '\\$', ['&'] = '\\&', ['#'] = '\\#', ['%'] = '\\%',
  ['_'] = '\\_', ['^'] = '\\^{}', ['~'] = '\\textasciitilde{}',
}
local function escapar(s)
  return (s:gsub('[\\{}$&#%%_^~]', especiales))
end

local function ulen(s) return utf8.len(s) or #s end

-- 1. Titulos --------------------------------------------------------------
function Header(h)
  local out = pandoc.List()
  for _, el in ipairs(h.content) do
    if el.t ~= 'Image' then out:insert(el) end
  end
  while #out > 0 and (out[1].t == 'Space' or out[1].t == 'SoftBreak') do
    out:remove(1)
  end
  h.content = out
  if h.level == 1 and #out > 0 and h.classes:includes('unnumbered') then
    local t = escapar(pandoc.utils.stringify(out))
    return { h, latex('\\markboth{' .. t .. '}{' .. t .. '}') }
  end
  return h
end

-- 2. Salida de consola de R (bloques de codigo sin lenguaje) ----------------
function CodeBlock(cb)
  if #cb.classes == 0 then
    return latex('\\begin{SalidaR}\n' .. cb.text .. '\n\\end{SalidaR}')
  end
end

-- 4. Imagenes comprimidas ---------------------------------------------------
-- figuras/Mi foto.png -> figuras_pdf/Mi_foto.png.jpg (si existe)
local function existe(f)
  local h = io.open(f, 'rb')
  if h then h:close() return true end
  return false
end

function Image(img)
  local nombre = img.src:match('^figuras/(.+)$')
  if nombre then
    nombre = nombre:gsub('%%20', ' ')     -- pandoc codifica los espacios
    local comprimida = 'figuras_pdf/' .. nombre:gsub(' ', '_') .. '.jpg'
    if existe(comprimida) then img.src = comprimida end
  end
  -- en la web es una clase de estilo; en el PDF no hace falta
  img.classes = img.classes:filter(function(c) return c ~= 'portada-img' end)
  return img
end

-- 3. Tablas ------------------------------------------------------------------
local ANCHO_ENCABEZADO = 14   -- caracteres a partir de los cuales se parte
local ANCHO_CELDA      = 34   -- idem, para las celdas del cuerpo

local function ancho_columna(texto, minimo)
  local palabra = 0
  for w in texto:gmatch('%S+') do palabra = math.max(palabra, ulen(w)) end
  return math.max(minimo, palabra * 0.21)
end

-- Reparte en varias lineas encabezados y celdas largas (tablas de kable)
local function partir_celdas(s)
  -- \textbf{\multicolumn{n}{al}{x}} -> \multicolumn{n}{al}{\textbf{x}}
  -- (kableExtra genera el orden erroneo, que LaTeX no admite)
  local function reordenar(cmd, arg)
    local n, al, x = arg:sub(2, -2):match('^\\multicolumn(%b{})(%b{})(%b{})$')
    if n then return '\\multicolumn' .. n .. al .. '{\\' .. cmd .. x .. '}' end
  end
  s = s:gsub('\\(textbf)(%b{})', reordenar)
  s = s:gsub('\\(textit)(%b{})', reordenar)
  s = s:gsub('\\(emph)(%b{})', reordenar)

  s = s:gsub('\\multicolumn{1}{c}{\\textbf(%b{})}', function(arg)
    local texto = arg:sub(2, -2)
    if ulen(texto) <= ANCHO_ENCABEZADO or texto:find('\\\\') then return nil end
    return string.format(
      '\\multicolumn{1}{c}{\\parbox[b]{%.1fcm}{\\centering\\textbf{%s}}}',
      ancho_columna(texto, 2.3), texto)
  end)

  s = s:gsub('\\multicolumn{1}{c}(%b{})', function(arg)
    local texto = arg:sub(2, -2)
    if texto:sub(1, 1) == '\\' or ulen(texto) <= ANCHO_CELDA then return nil end
    -- unas 2-3 lineas de entre 4 y 6 cm
    local ancho = math.min(6, math.max(ancho_columna(texto, 4), ulen(texto) * 0.09))
    return string.format(
      '\\multicolumn{1}{c}{\\parbox[t]{%.1fcm}{\\raggedright %s}}',
      ancho, texto)
  end)
  return s
end

-- Filas alternas en gris claro. Si desde_inicio es falso, solo se colorean
-- las filas entre \midrule y \bottomrule (el cuerpo de la tabla). Una fila
-- puede ocupar varias lineas: el color va al principio de la fila.
local function cebra(lineas, desde_inicio)
  local en_cuerpo, inicio, n, out = desde_inicio, desde_inicio, 0, {}
  for _, l in ipairs(lineas) do
    if l ~= '\0' then
      if l:match('^\\midrule') then
        en_cuerpo, inicio = true, true
      elseif l:match('^\\bottomrule') then
        en_cuerpo = false
      elseif en_cuerpo and l:match('%S') then
        if inicio and not l:match('^\\rowcolor') and not l:match('^\\[a-z]*rule') then
          n = n + 1
          if n % 2 == 0 then l = '\\rowcolor{rstarsfila}' .. l end
        end
        inicio = l:match('\\\\%s*$') ~= nil
      end
      out[#out + 1] = l
    end
  end
  return table.concat(out, '\n')
end

-- Estilo comun: filetes de booktabs, sin rayas verticales, filas alternas
local function estilo_libro(tab)
  -- sin rayas verticales en la especificacion de columnas
  tab = tab:gsub('^(\\begin{tabular})(%b{})', function(b, spec)
    return b .. spec:gsub('|', '')
  end)

  local lineas = {}
  for l in (tab .. '\n'):gmatch('(.-)\n') do lineas[#lineas + 1] = l end

  local con_hline = tab:find('\\hline', 1, true) ~= nil
  local reglas = {}               -- posiciones de \hline
  if con_hline then
    for i, l in ipairs(lineas) do
      if l:match('^%s*\\hline%s*$') then reglas[#reglas + 1] = i end
    end
    if #reglas >= 2 then
      for k, i in ipairs(reglas) do
        if k == 1 then lineas[i] = '\\toprule'
        elseif k == 2 then lineas[i] = '\\midrule'
        elseif k == #reglas then lineas[i] = '\\bottomrule'
        else lineas[i] = '\0' end
      end
    end
  end

  return cebra(lineas, false)
end

-- Tabla de kable (LaTeX crudo de knitr): devuelve el LaTeX transformado
local function arreglar_tabla(s)
  s = s:gsub('\\rowcolor{gray!10}', '')             -- se pone mas abajo
  s = partir_celdas(s)
  s = s:gsub('(\\begin{tabular}.-\\end{tabular})', function(tab)
    return '\\tablarstars{' .. estilo_libro(tab) .. '}'
  end)
  -- sin entorno flotante: centrada, en su sitio
  s = s:gsub('\\begin{table}%b[]', '\\begin{table}')
  s = s:gsub('\\begin{table}', '\\begin{center}')
  s = s:gsub('\\end{table}', '\\end{center}')
  return s
end

local function es_tabla_cruda(b)
  return b.t == 'RawBlock' and (b.format == 'latex' or b.format == 'tex')
         and b.text:find('\\begin{tabular}', 1, true) ~= nil
end

-- Tabla de markdown (|...|). Si es corta, se convierte en tabular (para
-- que vaya en un bloque con su rotulo); si es larga (puede ocupar mas de
-- una pagina), sigue siendo longtable y el rotulo se mete en su pie, de
-- modo que siempre acompana a las ultimas filas de la tabla.
local FILAS_TABLA_LARGA = 14

local function a_latex(bloques)
  return (pandoc.write(pandoc.Pandoc(bloques), 'latex'):gsub('%s+$', ''))
end

local function filas_de(tbl)
  local n = 0
  for _, b in ipairs(tbl.bodies or {}) do n = n + #(b.body or {}) end
  return n
end

local function tabla_markdown(tbl, rotulo)
  if not pandoc.write then return nil end            -- pandoc antiguo
  local ok, tex = pcall(pandoc.write, pandoc.Pandoc({ tbl }), 'latex')
  if not ok or not tex:find('\\begin{longtable}', 1, true) then return nil end
  tex = tex:gsub('\\noalign{}', '')
  local _, fin_spec, spec = tex:find('\\begin{longtable}%b[](%b{})')
  if not spec then _, fin_spec, spec = tex:find('\\begin{longtable}(%b{})') end
  if not spec then return nil end
  local cuerpo = tex:sub(fin_spec + 1):match('^(.*)\\end{longtable}')
  if not cuerpo then return nil end
  local cab  = (cuerpo:match('^(.-)\\endhead') or ''):gsub('\\endfirsthead.*$', '')
  local pie  = cuerpo:match('\\endhead(.-)\\endlastfoot') or ''
  local filas = cuerpo:match('\\endlastfoot(.*)$') or cuerpo
  if filas_de(tbl) > FILAS_TABLA_LARGA then
    local lineas = {}
    for l in (filas .. '\n'):gmatch('(.-)\n') do lineas[#lineas + 1] = l end
    filas = cebra(lineas, true)
    -- fechas como 1965/1984/2021: que puedan partirse tras la barra
    filas = filas:gsub('(%d)/(%d)', '%1/\\allowbreak{}%2')
    local ncol = #(tbl.colspecs or {})
    local final = pie
    if rotulo and ncol > 0 then
      final = pie .. '\n\\multicolumn{' .. ncol .. '}{c}{\\rule{0pt}{1.6em}\\small ' ..
              a_latex(rotulo.content):gsub('\n', ' ') .. '}\\\\\n'
    end
    return latex('\\begingroup\\small\n\\begin{longtable}[]' .. spec .. '\n' ..
                 cab .. '\\endhead\n' .. final .. '\\endlastfoot\n' .. filas ..
                 '\n\\end{longtable}\n\\endgroup'), true
  end

  local tab = '\\begin{tabular}' .. spec .. '\n' .. cab .. filas .. pie ..
              '\n\\end{tabular}'
  tab = tab:gsub('\n%s*\n', '\n')
  return latex('\\begin{center}\\small\n\\tablarstars{' .. estilo_libro(tab) ..
               '}\n\\end{center}'), false
end

-- 5 a 7. Recorrido del documento --------------------------------------------

-- Cita "> **Video:** [titulo](url)" que deja insertar_youtube() en el PDF
local function video(b)
  if b.t ~= 'BlockQuote' or #b.content ~= 1 then return nil end
  local p = b.content[1]
  if p.t ~= 'Para' and p.t ~= 'Plain' then return nil end
  local primero = p.content[1]
  if not (primero and primero.t == 'Strong' and
          pandoc.utils.stringify(primero):match('^V.-deo')) then return nil end  -- 'í' son 2 bytes
  for _, el in ipairs(p.content) do
    if el.t == 'Link' then
      local titulo = a_latex({ pandoc.Plain(el.content) }):gsub('\n', ' ')
      return latex('\\rsvideo{' .. titulo .. '}{' .. el.target .. '}')
    end
  end
  return nil
end

local function es_titulo_bibliografia(b)
  return b.t == 'Header' and b.level == 1 and
         pandoc.utils.stringify(b.content):match('^Bibliograf') ~= nil
end

-- Ilustraciones dentro de subapartados (personajes, organizaciones,
-- compañías, astilleros): al 70 % del ancho, para que no ocupe cada una
-- media página. Las de capítulo y sección siguen a todo el ancho.
local ANCHO_SUBAPARTADO = '70%'
local function reducir_imagenes(b)
  return pandoc.walk_block(b, { Image = function(img)
    img.attributes['width'] = ANCHO_SUBAPARTADO
    return img
  end })
end

local function es_figura(b)
  if b.t == 'Figure' then return true end
  -- pandoc 2: parrafo con una sola imagen con pie (figura implicita)
  return (b.t == 'Para' or b.t == 'Plain') and #b.content == 1 and
         b.content[1].t == 'Image' and #b.content[1].caption > 0
end

local function procesar(bl)
  local out = pandoc.List()
  local i, n = 1, #bl
  local nivel = 0
  while i <= n do
    local b = bl[i]
    if b.t == 'Header' then nivel = b.level end
    if nivel >= 3 and es_figura(b) then b = reducir_imagenes(b) end
    if b.t == 'Header' and b.level == 1 and #b.content == 0 then
      -- 7. Portada web: se salta hasta el siguiente capitulo.
      i = i + 1
      while i <= n and not (bl[i].t == 'Header' and bl[i].level == 1) do
        i = i + 1
      end
    else
      local v = video(b)
      if v then
        out:insert(v)
      elseif es_tabla_cruda(b) then
        out:insert(latex(arreglar_tabla(b.text)))
      elseif b.t == 'Table' then
        out:insert((tabla_markdown(b, nil)) or b)
      else
        out:insert(b)
      end
      i = i + 1
    end
  end
  return out
end

-- 6. Bibliografia en su sitio
local function colocar_referencias(bl)
  local pos_titulo, pos_refs = nil, nil
  for k, b in ipairs(bl) do
    if es_titulo_bibliografia(b) then pos_titulo = k end
    if b.t == 'Div' and b.identifier == 'refs' then pos_refs = k end
  end
  if not pos_titulo then return bl end
  -- fin del capitulo de bibliografia: antes del siguiente titulo de nivel 1
  local fin = #bl + 1
  for k = pos_titulo + 1, #bl do
    if bl[k].t == 'Header' and bl[k].level == 1 then fin = k break end
  end
  local refs
  if pos_refs then
    if pos_refs > pos_titulo and pos_refs < fin then return bl end
    refs = bl[pos_refs]
    bl:remove(pos_refs)
    if pos_refs < fin then fin = fin - 1 end
  else
    refs = pandoc.Div({}, pandoc.Attr('refs'))   -- lo llena citeproc
  end
  bl:insert(fin, refs)
  return bl
end

function Pandoc(doc)
  doc.blocks = colocar_referencias(procesar(doc.blocks))
  return doc
end
