
---

## 1. Estructura del SELECT

```sql
SELECT columnas                -- 1. Qué columnas quiero
FROM tabla                     -- 2. De qué tabla
WHERE condicion                -- 3. Filtrar filas
GROUP BY columna               -- 4. Agrupar
HAVING condicion_grupo         -- 5. Filtrar grupos
ORDER BY columna               -- 6. Ordenar
LIMIT n;                       -- 7. Limitar resultados
```

> 💡 `*` = comodín (todas las columnas)  
> 💡 `;` = fin de la consulta  
> 💡 SQL no distingue mayúsculas/minúsculas, pero se recomienda escribir palabras clave en MAYÚSCULAS

---

## 2. Consultas Básicas

```sql
-- Todas las columnas
SELECT * FROM jugador;

-- Columnas específicas
SELECT nombre, apellido FROM jugador;

-- Valores únicos (sin repetir)
SELECT DISTINCT posicion FROM jugador;

-- Alias para columnas
SELECT nombre AS NombreJugador, salarioBruto AS Salario FROM jugador;

-- Alias para tablas
SELECT j.nombre, e.nombreEquipo
FROM jugador AS j
JOIN equipo AS e ON j.idEquipo = e.idEquipo;
```

---

## 3. WHERE - Filtrar resultados

### Operadores de comparación

|Operador|Nombre|Ejemplo|
|---|---|---|
|`=`|Igual|`WHERE edad = 20`|
|`<>` o `!=`|Distinto|`WHERE ciudad <> 'Madrid'`|
|`>`|Mayor que|`WHERE edad > 25`|
|`<`|Menor que|`WHERE altura < 180`|
|`>=`|Mayor o igual|`WHERE edad >= 30`|
|`<=`|Menor o igual|`WHERE salario <= 2000`|

### Operadores lógicos

|Operador|Descripción|Ejemplo|
|---|---|---|
|`AND`|Y lógico|`WHERE posicion = 'Base' AND edad > 28`|
|`OR`|O lógico|`WHERE ciudad = 'Madrid' OR ciudad = 'Valencia'`|
|`NOT`|Negación|`WHERE NOT posicion = 'Alero'`|

### Operadores especiales

```sql
-- BETWEEN: rango inclusivo
SELECT * FROM jugador WHERE altura BETWEEN 170 AND 180;

-- IN: lista de valores
SELECT * FROM equipo WHERE ciudad IN ('Madrid', 'Valencia', 'Barcelona');

-- NOT IN: excluir valores
SELECT * FROM equipo WHERE ciudad NOT IN ('Madrid');

-- IS NULL / IS NOT NULL
SELECT * FROM jugador WHERE idCapitan IS NULL;
SELECT * FROM jugador WHERE idCapitan IS NOT NULL;
```

---

## 4. LIKE - Búsqueda por patrones

|Símbolo|Significado|
|---|---|
|`%`|Cualquier cantidad de caracteres (0 o más)|
|`_`|Exactamente UN carácter|

```sql
SELECT * FROM jugador WHERE nombre LIKE 'Ju%';      -- Empieza por "Ju"
SELECT * FROM jugador WHERE nombre LIKE '%ez';      -- Termina en "ez"
SELECT * FROM jugador WHERE nombre LIKE '%ar%';     -- Contiene "ar"
SELECT * FROM jugador WHERE nombre LIKE 'J__n';     -- J + 2 chars + n
SELECT * FROM jugador WHERE nombre NOT LIKE 'A%';   -- NO empieza por A
```

---

## 5. REGEXP - Expresiones regulares (más potente que LIKE)

|Símbolo|Significado|
|---|---|
|`^`|Inicio del texto|
|`$`|Final del texto|
|`[abc]`|Cualquiera de esas letras|
|`[a-z]`|Rango de letras|
|`[0-9]`|Cualquier dígito|
|`\|`|OR (alternativa)|

```sql
-- Nombres que empiezan por J o M
SELECT nombre FROM jugador WHERE nombre REGEXP '^[JM]';

-- Nombres que terminan en "o"
SELECT nombre FROM jugador WHERE nombre REGEXP 'o$';

-- Equipos que contengan "real" o "club"
SELECT nombreEquipo FROM equipo WHERE nombreEquipo REGEXP 'real|club';

-- Jugadores con números en el nombre
SELECT nombre FROM jugador WHERE nombre REGEXP '[0-9]';

-- Partidos de octubre o noviembre (meses 10 u 11)
SELECT * FROM partido WHERE fecha REGEXP '-1[01]-';

-- Partidos jugados el día 08
SELECT * FROM partido WHERE fecha REGEXP '-08$';
```

---

## 6. ORDER BY - Ordenar

```sql
SELECT * FROM jugador ORDER BY salarioBruto;           -- Ascendente (defecto)
SELECT * FROM jugador ORDER BY salarioBruto ASC;       -- Ascendente
SELECT * FROM jugador ORDER BY salarioBruto DESC;      -- Descendente

-- Múltiples columnas
SELECT * FROM jugador ORDER BY posicion ASC, salarioBruto DESC;
```

---

## 7. LIMIT - Limitar resultados

```sql
SELECT * FROM jugador LIMIT 5;                     -- Primeras 5 filas
SELECT * FROM jugador LIMIT 5 OFFSET 10;           -- 5 filas, saltando 10
SELECT * FROM jugador LIMIT 10, 5;                 -- LIMIT offset, cantidad
```

---

## 8. Funciones de Agregación

|Función|Descripción|
|---|---|
|`COUNT(*)`|Cuenta TODAS las filas|
|`COUNT(col)`|Cuenta filas donde col NO es NULL|
|`COUNT(DISTINCT col)`|Cuenta valores únicos|
|`SUM(col)`|Suma total|
|`AVG(col)`|Promedio|
|`MAX(col)`|Valor máximo|
|`MIN(col)`|Valor mínimo|

```sql
SELECT COUNT(*) AS 'Total jugadores' FROM jugador;
SELECT SUM(salarioBruto) AS 'Salario total' FROM jugador;
SELECT AVG(salarioBruto) AS 'Salario promedio' FROM jugador;
SELECT MAX(salarioBruto) AS 'Salario máximo' FROM jugador;
SELECT MIN(altura) AS 'Altura mínima' FROM jugador;
```

---

## 9. GROUP BY - Agrupar

> 📌 **REGLA DE ORO:** Toda columna en SELECT debe estar en GROUP BY o dentro de una función de agregación

```sql
-- Cuántos jugadores por posición
SELECT posicion, COUNT(*) AS cantidad
FROM jugador
GROUP BY posicion;

-- Salario promedio por equipo
SELECT idEquipo, AVG(salarioBruto) AS salario_medio
FROM jugador
GROUP BY idEquipo;

-- Suma de salarios por equipo
SELECT idEquipo AS Equipo, SUM(salarioBruto) AS 'Presupuesto Total'
FROM jugador
GROUP BY idEquipo;
```

---

## 10. HAVING - Filtrar grupos

> 📌 **WHERE** filtra FILAS antes de agrupar  
> 📌 **HAVING** filtra GRUPOS después de agrupar

```sql
-- Posiciones con más de 3 jugadores
SELECT posicion, COUNT(*) AS cantidad
FROM jugador
GROUP BY posicion
HAVING COUNT(*) > 3;

-- Equipos con salario total > 5000
SELECT idEquipo, SUM(salarioBruto) AS total
FROM jugador
GROUP BY idEquipo
HAVING SUM(salarioBruto) > 5000;

-- Combinando WHERE y HAVING
SELECT idEquipo, AVG(salarioBruto) AS promedio
FROM jugador
WHERE altura > 170
GROUP BY idEquipo
HAVING AVG(salarioBruto) > 2000;
```

---

## 11. Operaciones y Cálculos

```sql
-- Calcular salario neto (IRPF 18%)
SELECT nombre,
       salarioBruto AS SalarioBruto,
       salarioBruto * 0.82 AS SalarioNeto
FROM jugador;

-- Añadir columna fija
SELECT nombre,
       salarioBruto,
       '18%' AS IRPF,
       salarioBruto * 0.82 AS SalarioNeto
FROM jugador;

-- Calcular edad en meses
SELECT nombre, 
       edad,
       edad * 12 AS 'Edad en Meses'
FROM jugador;
```

---

## 12. Funciones de Formato

```sql
-- CONCAT: unir textos
SELECT CONCAT(nombre, ' ', apellido) AS NombreCompleto FROM jugador;

-- Añadir símbolo de euros
SELECT 
    idEquipo AS Equipo,
    CONCAT(FORMAT(SUM(salarioBruto), 2), ' €') AS 'Presupuesto Total'
FROM jugador
GROUP BY idEquipo;

-- FORMAT: formatear números con decimales
SELECT FORMAT(salarioBruto, 2) FROM jugador;  -- 2300.00

-- UPPER / LOWER
SELECT UPPER(nombre) FROM jugador;   -- MAYÚSCULAS
SELECT LOWER(nombre) FROM jugador;   -- minúsculas

-- LENGTH: longitud del texto
SELECT nombre, LENGTH(nombre) AS caracteres FROM jugador;

-- SUBSTRING: extraer parte del texto
SELECT SUBSTRING(nombre, 1, 3) FROM jugador;  -- Primeros 3 caracteres

-- TRIM: quitar espacios
SELECT TRIM(nombre) FROM jugador;

-- REPLACE: reemplazar texto
SELECT REPLACE(nombre, 'Juan', 'Pedro') FROM jugador;
```

---

## 13. Funciones de Fecha

### Formato de fechas en SQL

```
'YYYY-MM-DD'  →  '2025-11-25'
```

> Siempre entre comillas, mes y día con dos dígitos

### Funciones principales

```sql
-- Fecha y hora actual
SELECT NOW() AS FechaHoraActual;      -- 2025-11-25 10:30:00
SELECT CURDATE() AS FechaActual;      -- 2025-11-25
SELECT CURTIME() AS HoraActual;       -- 10:30:00

-- Extraer partes de fecha
SELECT YEAR(fecha) FROM partido;       -- 2025
SELECT MONTH(fecha) FROM partido;      -- 11
SELECT DAY(fecha) FROM partido;        -- 25
SELECT DAYNAME(fecha) FROM partido;    -- Tuesday
SELECT MONTHNAME(fecha) FROM partido;  -- November

-- Diferencia entre fechas (en días)
SELECT nombre, fechaAlta,
       DATEDIFF(CURDATE(), fechaAlta) AS 'Días en la liga'
FROM jugador;

-- Sumar/restar tiempo
SELECT DATE_ADD(fecha, INTERVAL 7 DAY) FROM partido;    -- +7 días
SELECT DATE_SUB(fecha, INTERVAL 1 MONTH) FROM partido;  -- -1 mes
```

### Ejemplos prácticos con fechas

```sql
-- Jugadores que ingresaron este año
SELECT nombre, fechaAlta FROM jugador
WHERE YEAR(fechaAlta) = YEAR(CURDATE());

-- Partidos del mes actual
SELECT * FROM partido
WHERE MONTH(fecha) = MONTH(CURDATE()) AND YEAR(fecha) = YEAR(CURDATE());

-- 5 jugadores más antiguos
SELECT nombre, fechaAlta,
       DATEDIFF(CURDATE(), fechaAlta) AS 'Días en liga'
FROM jugador
ORDER BY fechaAlta ASC
LIMIT 5;

-- Partidos de los últimos 30 días
SELECT * FROM partido
WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);
```

---

## 14. Funciones Condicionales

```sql
-- IF simple
SELECT nombre, 
       IF(salarioBruto > 2000, 'Alto', 'Normal') AS categoria 
FROM jugador;

-- IFNULL: reemplazar NULL
SELECT IFNULL(telefono, 'Sin teléfono') FROM jugador;

-- COALESCE: primer valor no nulo
SELECT COALESCE(movil, fijo, 'Sin contacto') FROM jugador;

-- CASE: múltiples condiciones
SELECT nombre,
    CASE 
        WHEN salarioBruto >= 2300 THEN 'Premium'
        WHEN salarioBruto >= 2000 THEN 'Medio'
        ELSE 'Base'
    END AS categoria
FROM jugador;

-- CASE simple
SELECT nombre,
    CASE posicion
        WHEN 'Base' THEN 'Organizador'
        WHEN 'Pivot' THEN 'Interior'
        ELSE 'Exterior'
    END AS rol
FROM jugador;
```

---

## 15. JOINs - Combinar tablas

### Diagrama visual

```
INNER JOIN        LEFT JOIN         RIGHT JOIN
┌───┬───┐         ┌───┬───┐         ┌───┬───┐
│   │███│         │███│███│         │███│███│
│ A │███│ B       │███│███│ B       │ A │███│
│   │███│         │███│███│         │   │███│
└───┴───┘         └───┴───┘         └───┴───┘
Solo coincid.     Todo A + coinc.   Coinc. + todo B
```

### INNER JOIN

```sql
SELECT j.nombre, j.apellido, e.nombreEquipo
FROM jugador j
INNER JOIN equipo e ON j.idEquipo = e.idEquipo;
```

### LEFT JOIN

```sql
-- Todos los equipos, tengan o no jugadores
SELECT e.nombreEquipo, j.nombre
FROM equipo e
LEFT JOIN jugador j ON e.idEquipo = j.idEquipo;

-- Encontrar equipos SIN jugadores
SELECT e.nombreEquipo
FROM equipo e
LEFT JOIN jugador j ON e.idEquipo = j.idEquipo
WHERE j.idJugador IS NULL;
```

### SELF JOIN

```sql
-- Jugadores con su capitán
SELECT 
    j.nombre AS jugador,
    c.nombre AS capitan
FROM jugador j
INNER JOIN jugador c ON j.idCapitan = c.idJugador;
```

### Múltiples JOINs

```sql
-- Partidos con nombres de equipos
SELECT 
    el.nombreEquipo AS local,
    ev.nombreEquipo AS visitante,
    p.fecha,
    p.resultado
FROM partido p
INNER JOIN equipo el ON p.elocal = el.idEquipo
INNER JOIN equipo ev ON p.evisitante = ev.idEquipo;
```

---

## 16. Subconsultas

### En WHERE (un valor)

```sql
-- Jugadores que ganan más que el promedio
SELECT nombre, salarioBruto FROM jugador
WHERE salarioBruto > (SELECT AVG(salarioBruto) FROM jugador);

-- Jugadores del equipo con más puntos
SELECT nombre FROM jugador
WHERE idEquipo = (SELECT idEquipo FROM equipo ORDER BY puntos DESC LIMIT 1);
```

### En WHERE (lista con IN)

```sql
-- Equipos que tienen jugadores Base
SELECT nombreEquipo FROM equipo
WHERE idEquipo IN (SELECT idEquipo FROM jugador WHERE posicion = 'Base');

-- Equipos que NO tienen jugadores Base
SELECT nombreEquipo FROM equipo
WHERE idEquipo NOT IN (SELECT idEquipo FROM jugador WHERE posicion = 'Base');
```

### En FROM (tabla derivada)

```sql
-- Promedio de jugadores por equipo
SELECT AVG(total) AS promedio_jugadores
FROM (
    SELECT idEquipo, COUNT(*) AS total 
    FROM jugador 
    GROUP BY idEquipo
) AS jugadores_por_equipo;  -- ¡Alias OBLIGATORIO!
```

### En SELECT

```sql
-- Cada equipo con su número de jugadores
SELECT 
    nombreEquipo,
    (SELECT COUNT(*) FROM jugador j WHERE j.idEquipo = e.idEquipo) AS num_jugadores
FROM equipo e;
```

### Correlacionadas

```sql
-- Jugadores que ganan más que el promedio de SU equipo
SELECT nombre, salarioBruto, idEquipo
FROM jugador j1
WHERE salarioBruto > (
    SELECT AVG(salarioBruto) 
    FROM jugador j2 
    WHERE j2.idEquipo = j1.idEquipo
);
```

---

## 17. Resumen cuándo usar cada cosa

|Situación|Solución|
|---|---|
|Comparar con un valor (MAX, MIN, AVG...)|`WHERE col = (SELECT ...)`|
|Comparar con una lista|`WHERE col IN (SELECT ...)`|
|Excluir una lista|`WHERE col NOT IN (SELECT ...)`|
|Calcular sobre resultados agrupados|Subconsulta en `FROM`|
|Añadir columna calculada por fila|Subconsulta en `SELECT`|
|Comprobar si existe algo relacionado|`EXISTS / NOT EXISTS`|
|Filtrar filas|`WHERE`|
|Filtrar grupos|`HAVING`|
|Buscar patrones simples|`LIKE`|
|Buscar patrones complejos|`REGEXP`|

---

## 18. Orden de Ejecución Real

> No es el orden en que se escribe, sino cómo MySQL lo procesa:

1. `FROM / JOIN` → De dónde saco los datos
2. `WHERE` → Filtro filas
3. `GROUP BY` → Agrupo
4. `HAVING` → Filtro grupos
5. `SELECT` → Elijo columnas
6. `DISTINCT` → Elimino duplicados
7. `ORDER BY` → Ordeno
8. `LIMIT` → Limito resultados

---

## 19. Errores Comunes

### ❌ Columna en SELECT no está en GROUP BY

```sql
-- MAL
SELECT nombre, COUNT(*) FROM jugador GROUP BY idEquipo;

-- BIEN
SELECT idEquipo, COUNT(*) FROM jugador GROUP BY idEquipo;
```

### ❌ Función de agregación en WHERE

```sql
-- MAL
SELECT * FROM jugador WHERE salarioBruto > AVG(salarioBruto);

-- BIEN (usar subconsulta)
SELECT * FROM jugador 
WHERE salarioBruto > (SELECT AVG(salarioBruto) FROM jugador);
```

### ❌ Comparar NULL con =

```sql
-- MAL
SELECT * FROM jugador WHERE idCapitan = NULL;

-- BIEN
SELECT * FROM jugador WHERE idCapitan IS NULL;
```

---

## 20. Plantillas Rápidas para Examen

### "Los X que tienen Y"

```sql
SELECT a.* FROM tablaA a
INNER JOIN tablaB b ON a.id = b.idA;
```

### "Los X que NO tienen Y"

```sql
SELECT a.* FROM tablaA a
LEFT JOIN tablaB b ON a.id = b.idA
WHERE b.id IS NULL;
```

### "Cuántos Y tiene cada X"

```sql
SELECT a.nombre, COUNT(b.id) AS cantidad
FROM tablaA a
LEFT JOIN tablaB b ON a.id = b.idA
GROUP BY a.id, a.nombre;
```

### "El X con más Y"

```sql
SELECT a.nombre, COUNT(b.id) AS cantidad
FROM tablaA a
INNER JOIN tablaB b ON a.id = b.idA
GROUP BY a.id, a.nombre
ORDER BY cantidad DESC
LIMIT 1;
```

### "Los X cuyo Y es mayor que el promedio"

```sql
SELECT * FROM tabla
WHERE columna > (SELECT AVG(columna) FROM tabla);
```

### "Grupos que cumplan condición después de agrupar"

```sql
SELECT columna, COUNT(*) AS total
FROM tabla
GROUP BY columna
HAVING COUNT(*) > 5;
```

---


# 📝 Soluciones - Ejercicios Funciones de Agregación SQL

> Ejercicios del PDF de Luz Adriana Perdomo - Base de Datos DAM 1

---

## Ejercicio 1: Jugadores del equipo 102 ordenados por apellido y conteo total

**Enunciado:** Muestra los datos de los jugadores que pertenecen al equipo 102 ordenados por apellido, y adicionalmente indica cuántos jugadores tiene ese equipo.

```sql
SELECT 
    j.*,
    (SELECT COUNT(*) FROM jugador WHERE idEquipo = 102) AS total_equipo
FROM jugador j
WHERE j.idEquipo = 102
ORDER BY j.apellido;
```

**Técnica usada:** Subconsulta en SELECT para añadir el conteo como columna extra.

---

## Ejercicio 2: Jugadores pívot ordenados por id y salario promedio del puesto

**Enunciado:** Obtén los datos de los jugadores cuya posición sea pívot, ordenados por id, e incluye el salario promedio de todos los jugadores que juegan en esa misma posición.

```sql
SELECT 
    j.*,
    (SELECT AVG(salarioBruto) FROM jugador WHERE posicion = 'Pivot') AS salario_promedio_pivots
FROM jugador j
WHERE j.posicion = 'Pivot'
ORDER BY j.idJugador;
```

**Técnica usada:** Subconsulta en SELECT con AVG().

---

## Ejercicio 3: Jugadores altura > 180 y salario < 2000, con edad máxima y mínima

**Enunciado:** Selecciona los jugadores que cumplan estas condiciones y muestra también la edad máxima y mínima dentro de ese subconjunto.

### Opción A: Si tienes columna `edad`

```sql
SELECT 
    j.*,
    (SELECT MAX(edad) FROM jugador WHERE altura > 180 AND salarioBruto < 2000) AS edad_maxima,
    (SELECT MIN(edad) FROM jugador WHERE altura > 180 AND salarioBruto < 2000) AS edad_minima
FROM jugador j
WHERE j.altura > 180 AND j.salarioBruto < 2000;
```

### Opción B: Adaptado a tu BD (usando fechaAlta)

```sql
SELECT 
    j.*,
    (SELECT MIN(fechaAlta) FROM jugador WHERE altura > 180 AND salarioBruto < 2000) AS mas_antiguo,
    (SELECT MAX(fechaAlta) FROM jugador WHERE altura > 180 AND salarioBruto < 2000) AS mas_reciente
FROM jugador j
WHERE j.altura > 180 AND j.salarioBruto < 2000;
```

**Técnica usada:** Múltiples subconsultas en SELECT con MAX() y MIN().

---

## Ejercicio 4: Partidos jugados en marzo y total de goles marcados

**Enunciado:** Muestra todos los partidos disputados en marzo y calcula el total de goles marcados (local + visitante) durante ese mes.

### Si tienes columnas `goles_local` y `goles_visitante`

```sql
SELECT 
    p.*,
    (SELECT SUM(goles_local + goles_visitante) 
     FROM partido 
     WHERE MONTH(fecha) = 3) AS total_goles_marzo
FROM partido p
WHERE MONTH(fecha) = 3;
```

### Adaptado a tu BD (noviembre, que sí tiene datos)

```sql
SELECT 
    p.*,
    (SELECT COUNT(*) FROM partido WHERE MONTH(fecha) = 11) AS partidos_noviembre
FROM partido p
WHERE MONTH(fecha) = 11;
```

**Técnica usada:** Filtro con MONTH() + subconsulta con SUM().

---

## Ejercicio 5: Jugadores de equipos 103 y 104 con salario > 2100 y promedio por equipo

**Enunciado:** Muestra los jugadores que cumplan esta condición y calcula el salario promedio del equipo al que pertenecen.

```sql
SELECT 
    j.*,
    (SELECT AVG(salarioBruto) FROM jugador WHERE idEquipo = j.idEquipo) AS salario_promedio_equipo
FROM jugador j
WHERE j.idEquipo IN (103, 104) AND j.salarioBruto > 2100;
```

**Técnica usada:** IN para múltiples valores + subconsulta correlacionada (depende de `j.idEquipo`).

---

## Ejercicio 6: Equipos cuya web no contenga "www" y cantidad de jugadores

**Enunciado:** Lista los nombres de los equipos cuya página web no incluya la palabra "www" y muestra cuántos jugadores tiene cada uno.

```sql
SELECT 
    e.nombreEquipo,
    e.webOficial,
    COUNT(j.idJugador) AS cantidad_jugadores
FROM equipo e
LEFT JOIN jugador j ON e.idEquipo = j.idEquipo
WHERE e.webOficial NOT LIKE '%www%'
GROUP BY e.idEquipo, e.nombreEquipo, e.webOficial;
```

> ⚠️ En tu BD todas las webs tienen "www", no devolverá resultados. Para probar usa `LIKE '%www%'`.

**Técnica usada:** NOT LIKE + LEFT JOIN + GROUP BY + COUNT().

---

## Ejercicio 7: Equipos cuya web termine en '.com' y salario total de jugadores

**Enunciado:** Muestra el nombre de los equipos y la suma total del salario de todos sus jugadores si su web finaliza en ".com".

### Con LIKE

```sql
SELECT 
    e.nombreEquipo,
    e.webOficial,
    SUM(j.salarioBruto) AS salario_total
FROM equipo e
INNER JOIN jugador j ON e.idEquipo = j.idEquipo
WHERE e.webOficial LIKE '%.com'
GROUP BY e.idEquipo, e.nombreEquipo, e.webOficial;
```

### Con REGEXP

```sql
SELECT 
    e.nombreEquipo,
    SUM(j.salarioBruto) AS salario_total
FROM equipo e
INNER JOIN jugador j ON e.idEquipo = j.idEquipo
WHERE e.webOficial REGEXP '\\.com$'
GROUP BY e.idEquipo, e.nombreEquipo;
```

**Técnica usada:** LIKE/REGEXP para filtrar texto + JOIN + GROUP BY + SUM().

---

## Ejercicio 8: Promedio de goles por partido en un año específico

**Enunciado:** Muestra todos los partidos jugados durante el año 2025 y calcula el promedio total de goles por partido.

### Si tienes columnas de goles

```sql
-- Consulta simple del promedio
SELECT 
    AVG(goles_local + goles_visitante) AS promedio_goles_por_partido
FROM partido
WHERE YEAR(fecha) = 2025;

-- Con detalle de partidos
SELECT 
    p.*,
    (SELECT AVG(goles_local + goles_visitante) 
     FROM partido 
     WHERE YEAR(fecha) = 2025) AS promedio_goles_año
FROM partido p
WHERE YEAR(fecha) = 2025;
```

### Adaptado a tu BD (conteo de partidos)

```sql
SELECT 
    COUNT(*) AS total_partidos,
    MIN(fecha) AS primer_partido,
    MAX(fecha) AS ultimo_partido
FROM partido
WHERE YEAR(fecha) = 2025;
```

**Técnica usada:** YEAR() para filtrar + AVG().

---

## Ejercicio 9: Equipos con más de 5 jugadores y edad promedio del plantel

**Enunciado:** Muestra los equipos que tengan más de 5 jugadores y calcula la edad promedio de sus jugadores.

### Si tienes columna `edad`

```sql
SELECT 
    e.nombreEquipo,
    COUNT(j.idJugador) AS num_jugadores,
    AVG(j.edad) AS edad_promedio
FROM equipo e
INNER JOIN jugador j ON e.idEquipo = j.idEquipo
GROUP BY e.idEquipo, e.nombreEquipo
HAVING COUNT(j.idJugador) > 5;
```

### Adaptado a tu BD (antigüedad en días)

```sql
SELECT 
    e.nombreEquipo,
    COUNT(j.idJugador) AS num_jugadores,
    AVG(DATEDIFF(CURDATE(), j.fechaAlta)) AS promedio_dias_en_liga
FROM equipo e
INNER JOIN jugador j ON e.idEquipo = j.idEquipo
GROUP BY e.idEquipo, e.nombreEquipo
HAVING COUNT(j.idJugador) > 2;  -- Cambiado a >2 porque no hay equipos con >5
```

**Técnica usada:** JOIN + GROUP BY + HAVING + COUNT() + AVG().

---

## Ejercicio 10: Equipos con más de 10 goles como locales (SUM + HAVING)

**Enunciado:** Suma los goles marcados por cada equipo cuando jugó como local y muestra solo los equipos que superen los 10 goles.

### Si tienes columna `goles_local`

```sql
SELECT 
    e.nombreEquipo,
    SUM(p.goles_local) AS total_goles_local
FROM equipo e
INNER JOIN partido p ON e.idEquipo = p.elocal
GROUP BY e.idEquipo, e.nombreEquipo
HAVING SUM(p.goles_local) > 10;
```

### Adaptado a tu BD (partidos jugados como local)

```sql
SELECT 
    e.nombreEquipo,
    COUNT(p.elocal) AS partidos_como_local
FROM equipo e
INNER JOIN partido p ON e.idEquipo = p.elocal
GROUP BY e.idEquipo, e.nombreEquipo
HAVING COUNT(p.elocal) > 1;
```

**Técnica usada:** JOIN + GROUP BY + SUM() + HAVING.

---

## Ejercicio 11: Jugadores ordenados por fecha de nacimiento y conteo por década

**Enunciado:** Lista a los jugadores ordenados por su fecha de nacimiento y muestra cuántos jugadores nacieron en cada década.

### Si tienes `fechaNacimiento`

```sql
-- Jugadores ordenados
SELECT * FROM jugador ORDER BY fechaNacimiento;

-- Conteo por década
SELECT 
    CONCAT(FLOOR(YEAR(fechaNacimiento) / 10) * 10, 's') AS decada,
    COUNT(*) AS cantidad
FROM jugador
GROUP BY FLOOR(YEAR(fechaNacimiento) / 10)
ORDER BY decada;
```

### Adaptado a tu BD (por año de alta)

```sql
-- Jugadores ordenados por fecha de alta
SELECT * FROM jugador ORDER BY fechaAlta;

-- Conteo por año de alta
SELECT 
    YEAR(fechaAlta) AS año_alta,
    COUNT(*) AS cantidad
FROM jugador
GROUP BY YEAR(fechaAlta)
ORDER BY año_alta;
```

**Técnica usada:** FLOOR() + YEAR() para agrupar por década + GROUP BY + CONCAT().

---

## Ejercicio 12: Edad promedio por posición, solo si promedio > 25 años

**Enunciado:** Agrupa a los jugadores por su posición, calcula la edad promedio y muestra únicamente aquellas posiciones en las que dicho promedio supere los 25 años.

### Si tienes columna `edad`

```sql
SELECT 
    posicion,
    AVG(edad) AS edad_promedio
FROM jugador
GROUP BY posicion
HAVING AVG(edad) > 25;
```

### Adaptado a tu BD (altura promedio > 175)

```sql
SELECT 
    posicion,
    AVG(altura) AS altura_promedio,
    AVG(salarioBruto) AS salario_promedio
FROM jugador
GROUP BY posicion
HAVING AVG(altura) > 175;
```

**Técnica usada:** GROUP BY + AVG() + HAVING.

---

## 📊 Resumen de Técnicas por Ejercicio

|Ejercicio|Técnicas principales|
|---|---|
|1|Subconsulta en SELECT, COUNT(), ORDER BY|
|2|Subconsulta en SELECT, AVG(), WHERE, ORDER BY|
|3|Múltiples subconsultas, MAX(), MIN(), AND|
|4|MONTH(), SUM(), subconsulta|
|5|IN, subconsulta correlacionada, AVG()|
|6|NOT LIKE, LEFT JOIN, GROUP BY, COUNT()|
|7|LIKE/REGEXP, JOIN, GROUP BY, SUM()|
|8|YEAR(), AVG()|
|9|JOIN, GROUP BY, HAVING, COUNT(), AVG()|
|10|JOIN, GROUP BY, SUM(), HAVING|
|11|FLOOR(), YEAR(), GROUP BY, CONCAT()|
|12|GROUP BY, AVG(), HAVING|

---

## 🔑 Patrones Clave para el Examen

### Patrón 1: Añadir agregado como columna extra

```sql
SELECT 
    columnas,
    (SELECT FUNCION() FROM tabla WHERE condicion) AS nombre_columna
FROM tabla
WHERE condicion;
```

### Patrón 2: Agrupar y filtrar grupos

```sql
SELECT columna, FUNCION(otra_columna)
FROM tabla
GROUP BY columna
HAVING FUNCION(otra_columna) > valor;
```

### Patrón 3: JOIN con agregación

```sql
SELECT t1.columna, COUNT(t2.id) AS total
FROM tabla1 t1
INNER JOIN tabla2 t2 ON t1.id = t2.id_t1
GROUP BY t1.id, t1.columna;
```

### Patrón 4: Filtrar por parte de fecha

```sql
WHERE YEAR(fecha) = 2025
WHERE MONTH(fecha) = 11
WHERE fecha BETWEEN '2025-01-01' AND '2025-12-31'
```

### Patrón 5: Filtrar por texto

```sql
WHERE columna LIKE '%texto%'        -- Contiene
WHERE columna LIKE 'texto%'         -- Empieza por
WHERE columna LIKE '%texto'         -- Termina en
WHERE columna NOT LIKE '%texto%'    -- NO contiene
WHERE columna REGEXP 'patron'       -- Expresión regular
```

---
