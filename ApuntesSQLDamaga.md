# 🗃️ HIPERCHULETA SQL - De 0 a JOINs

---

## 1. Estructura de Base de Datos (DDL)

### Crear y eliminar bases de datos

```sql
DROP DATABASE IF EXISTS nombreDB;      -- Elimina la BD si existe
CREATE DATABASE nombreDB;              -- Crea la base de datos
USE nombreDB;                          -- Selecciona la BD para trabajar
```

### Crear tablas

```sql
CREATE TABLE nombre_tabla (
    -- Clave primaria simple
    id INT PRIMARY KEY,
    
    -- Con auto incremento (no hace falta insertar valor)
    id INT PRIMARY KEY AUTO_INCREMENT,
    
    -- TIPOS DE DATOS COMUNES
    texto VARCHAR(50),                 -- Texto variable hasta 50 chars
    texto_largo TEXT,                  -- Texto largo sin límite
    numero_entero INT,                 -- Número entero
    numero_decimal DECIMAL(10,2),      -- 10 dígitos, 2 decimales
    fecha DATE,                        -- '2025-11-25'
    fecha_hora DATETIME,               -- '2025-11-25 10:30:00'
    booleano BOOLEAN,                  -- TRUE/FALSE (1/0)
    
    -- RESTRICCIONES
    columna VARCHAR(50) NOT NULL,      -- No permite NULL
    columna VARCHAR(50) DEFAULT 'val', -- Valor por defecto
    columna VARCHAR(50) UNIQUE,        -- Valores únicos
    
    -- ENUM: solo valores específicos
    estado ENUM('activo','inactivo') DEFAULT 'activo',
    
    -- CLAVE FORÁNEA
    idOtraTabla INT,
    FOREIGN KEY (idOtraTabla) REFERENCES otraTabla(id)
);
```

### Clave primaria compuesta

```sql
CREATE TABLE partido (
    elocal INT,
    evisitante INT,
    fecha DATE,
    PRIMARY KEY(elocal, evisitante, fecha),  -- PK compuesta
    FOREIGN KEY(elocal) REFERENCES equipo(idEquipo),
    FOREIGN KEY(evisitante) REFERENCES equipo(idEquipo)
);
```

### Auto-referencia (tabla que se referencia a sí misma)

```sql
CREATE TABLE empleado (
    idEmpleado INT PRIMARY KEY,
    nombre VARCHAR(50),
    idJefe INT,
    FOREIGN KEY (idJefe) REFERENCES empleado(idEmpleado)
);
```

### Modificar tablas (ALTER TABLE)

```sql
ALTER TABLE tabla ADD columna_nueva VARCHAR(50);      -- Añadir columna
ALTER TABLE tabla DROP COLUMN columna;                -- Eliminar columna
ALTER TABLE tabla MODIFY columna INT NOT NULL;        -- Modificar tipo
ALTER TABLE tabla RENAME COLUMN viejo TO nuevo;       -- Renombrar
ALTER TABLE tabla ADD FOREIGN KEY (col) REFERENCES otra(id);

DROP TABLE IF EXISTS nombre_tabla;                    -- Eliminar tabla
```

---

## 2. Insertar, Actualizar y Eliminar (DML)

### INSERT

```sql
-- Especificando columnas (recomendado)
INSERT INTO tabla (col1, col2, col3) VALUES ('valor1', 2, '2025-01-15');

-- Sin especificar columnas (TODOS los valores en orden)
INSERT INTO tabla VALUES (1, 'valor1', 2, '2025-01-15');

-- Múltiples filas
INSERT INTO tabla (col1, col2) VALUES 
    ('valor1', 10),
    ('valor2', 20),
    ('valor3', 30);
```

### UPDATE

> ⚠️ **¡SIEMPRE usar WHERE!** Sin WHERE actualiza TODAS las filas

```sql
UPDATE tabla SET columna = 'nuevo_valor' WHERE id = 1;

-- Varias columnas
UPDATE tabla SET col1 = 'valor1', col2 = 100 WHERE condicion;

-- Con cálculo
UPDATE jugador SET salarioBruto = salarioBruto * 1.10 WHERE idEquipo = 101;
```

### DELETE

> ⚠️ **¡SIEMPRE usar WHERE!** Sin WHERE elimina TODAS las filas

```sql
DELETE FROM tabla WHERE id = 1;

DELETE FROM tabla WHERE columna = 'valor' AND otra > 10;

-- Eliminar todo
DELETE FROM tabla;        -- NO resetea auto_increment
TRUNCATE TABLE tabla;     -- SÍ resetea auto_increment (más rápido)
```

---

## 3. SELECT Básico

### Sintaxis general (orden obligatorio)

```sql
SELECT columnas                -- 1. Qué columnas quiero
FROM tabla                     -- 2. De qué tabla
WHERE condicion                -- 3. Filtrar filas
GROUP BY columna               -- 4. Agrupar
HAVING condicion_grupo         -- 5. Filtrar grupos
ORDER BY columna               -- 6. Ordenar
LIMIT n;                       -- 7. Limitar resultados
```

### Consultas básicas

```sql
SELECT * FROM tabla;                           -- Todas las columnas
SELECT col1, col2 FROM tabla;                  -- Columnas específicas
SELECT DISTINCT col1 FROM tabla;               -- Valores únicos

-- Alias (renombrar columnas)
SELECT nombreEquipo AS equipo, ciudad AS ubicacion FROM equipo;
SELECT col1 nombre, col2 apellido FROM tabla;  -- AS es opcional
```

---

## 4. WHERE - Filtrar resultados

### Operadores de comparación

| Operador | Significado |
|----------|-------------|
| `=` | Igual |
| `!=` o `<>` | Distinto |
| `>` | Mayor que |
| `<` | Menor que |
| `>=` | Mayor o igual |
| `<=` | Menor o igual |

```sql
SELECT * FROM tabla WHERE columna = 'valor';
SELECT * FROM tabla WHERE columna != 'valor';
SELECT * FROM tabla WHERE columna > 10;
```

### Operadores lógicos

```sql
SELECT * FROM tabla WHERE cond1 AND cond2;     -- Ambas deben cumplirse
SELECT * FROM tabla WHERE cond1 OR cond2;      -- Al menos una
SELECT * FROM tabla WHERE NOT condicion;       -- Negación
```

### Operadores especiales

```sql
-- BETWEEN: rango inclusivo
SELECT * FROM jugador WHERE altura BETWEEN 170 AND 180;
-- Equivale a: WHERE altura >= 170 AND altura <= 180

-- IN: lista de valores posibles
SELECT * FROM Cita WHERE estado IN ('programada', 'atendida');
-- Equivale a: WHERE estado = 'programada' OR estado = 'atendida'

-- NOT IN: excluir valores
SELECT * FROM Cita WHERE estado NOT IN ('cancelada');

-- IS NULL / IS NOT NULL
SELECT * FROM tabla WHERE columna IS NULL;
SELECT * FROM tabla WHERE columna IS NOT NULL;
```

### LIKE: búsqueda por patrones

| Símbolo | Significado |
|---------|-------------|
| `%` | Cualquier cantidad de caracteres (0 o más) |
| `_` | Exactamente UN carácter |

```sql
SELECT * FROM tabla WHERE nombre LIKE 'A%';        -- Empieza por A
SELECT * FROM tabla WHERE nombre LIKE '%ez';       -- Termina en 'ez'
SELECT * FROM tabla WHERE nombre LIKE '%ar%';      -- Contiene 'ar'
SELECT * FROM tabla WHERE nombre LIKE 'J__n';      -- J + 2 chars + n
SELECT * FROM tabla WHERE nombre NOT LIKE 'A%';    -- NO empieza por A
```

---

## 5. ORDER BY - Ordenar

```sql
SELECT * FROM jugador ORDER BY salarioBruto;           -- Ascendente (defecto)
SELECT * FROM jugador ORDER BY salarioBruto ASC;       -- Ascendente
SELECT * FROM jugador ORDER BY salarioBruto DESC;      -- Descendente

-- Múltiples columnas
SELECT * FROM jugador ORDER BY posicion ASC, salarioBruto DESC;

-- Por número de columna (no recomendado)
SELECT nombre, apellido, salarioBruto FROM jugador ORDER BY 3 DESC;
```

---

## 6. LIMIT - Limitar resultados

```sql
SELECT * FROM jugador LIMIT 5;                     -- Primeras 5 filas
SELECT * FROM jugador LIMIT 5 OFFSET 10;           -- 5 filas, saltando 10
SELECT * FROM jugador LIMIT 10, 5;                 -- LIMIT offset, cantidad

-- Top 3 mejores pagados
SELECT nombre, salarioBruto FROM jugador ORDER BY salarioBruto DESC LIMIT 3;
```

---

## 7. Funciones de Agregación

| Función | Descripción |
|---------|-------------|
| `COUNT(*)` | Cuenta TODAS las filas |
| `COUNT(col)` | Cuenta filas donde col NO es NULL |
| `COUNT(DISTINCT col)` | Cuenta valores únicos |
| `SUM(col)` | Suma total |
| `AVG(col)` | Promedio |
| `MAX(col)` | Valor máximo |
| `MIN(col)` | Valor mínimo |

```sql
SELECT COUNT(*) FROM jugador;
SELECT SUM(salarioBruto) FROM jugador;
SELECT AVG(salarioBruto) FROM jugador;
SELECT MAX(salarioBruto), MIN(altura) FROM jugador;

-- Combinar varias
SELECT 
    COUNT(*) AS total,
    AVG(salarioBruto) AS promedio,
    MAX(salarioBruto) AS maximo
FROM jugador;
```

---

## 8. GROUP BY - Agrupar

> 📌 **REGLA DE ORO:** Toda columna en SELECT debe estar en GROUP BY o dentro de una función de agregación

```sql
-- Cuántos jugadores hay por posición
SELECT posicion, COUNT(*) AS cantidad
FROM jugador
GROUP BY posicion;

-- Salario promedio por equipo
SELECT idEquipo, AVG(salarioBruto) AS salario_medio
FROM jugador
GROUP BY idEquipo;

-- Agrupar por múltiples columnas
SELECT idEquipo, posicion, COUNT(*) AS cantidad
FROM jugador
GROUP BY idEquipo, posicion;
```

---

## 9. HAVING - Filtrar grupos

> 📌 **WHERE vs HAVING:**
> - `WHERE` filtra **FILAS** antes de agrupar
> - `HAVING` filtra **GRUPOS** después de agrupar

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
WHERE altura > 170                     -- Filtra jugadores altos
GROUP BY idEquipo                      -- Agrupa por equipo
HAVING AVG(salarioBruto) > 2000;       -- Filtra equipos
```

---

## 10. Funciones Útiles

### Funciones de texto

```sql
UPPER(nombre)                          -- Mayúsculas
LOWER(nombre)                          -- Minúsculas
LENGTH(nombre)                         -- Longitud
CONCAT(nombre, ' ', apellido)          -- Concatenar
SUBSTRING(nombre, 1, 3)                -- Subcadena (pos, longitud)
TRIM(nombre)                           -- Quitar espacios
REPLACE(texto, 'viejo', 'nuevo')       -- Reemplazar
```

### Funciones de fecha

```sql
NOW()                                  -- Fecha y hora actual
CURDATE()                              -- Fecha actual
CURTIME()                              -- Hora actual

YEAR(fecha)                            -- Extraer año
MONTH(fecha)                           -- Extraer mes (1-12)
DAY(fecha)                             -- Extraer día
DAYNAME(fecha)                         -- Nombre del día
MONTHNAME(fecha)                       -- Nombre del mes

DATEDIFF(fecha1, fecha2)               -- Diferencia en días
DATE_ADD(fecha, INTERVAL 7 DAY)        -- Sumar días
DATE_SUB(fecha, INTERVAL 1 MONTH)      -- Restar meses
```

### Funciones numéricas

```sql
ROUND(numero, 2)                       -- Redondear a 2 decimales
CEIL(numero)                           -- Redondear arriba
FLOOR(numero)                          -- Redondear abajo
ABS(numero)                            -- Valor absoluto
MOD(numero, 2)                         -- Módulo (resto)
```

### Funciones condicionales

```sql
-- IF simple
SELECT nombre, IF(salarioBruto > 2000, 'Alto', 'Normal') AS cat FROM jugador;

-- IFNULL: reemplazar NULL
SELECT IFNULL(telefono, 'Sin teléfono') FROM tabla;

-- COALESCE: primer valor no nulo
SELECT COALESCE(movil, fijo, 'Sin contacto') FROM tabla;

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

## 11. JOINs - Combinar tablas

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

### INNER JOIN - Solo coincidencias en AMBAS tablas

```sql
SELECT j.nombre, j.apellido, e.nombreEquipo
FROM jugador j
INNER JOIN equipo e ON j.idEquipo = e.idEquipo;

-- Múltiples tablas
SELECT 
    p.nombreCompleto AS paciente,
    m.nombreCompleto AS medico,
    c.fechaHora
FROM Cita c
INNER JOIN pacientes p ON c.idPaciente = p.idPaciente
INNER JOIN medicos m ON c.idMedico = m.idMedico;
```

### LEFT JOIN - Todo de la izquierda + coincidencias

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

### RIGHT JOIN - Coincidencias + todo de la derecha

```sql
SELECT e.nombreEquipo, j.nombre
FROM jugador j
RIGHT JOIN equipo e ON j.idEquipo = e.idEquipo;
```

### SELF JOIN - Tabla consigo misma

```sql
-- Jugadores con su capitán
SELECT 
    j.nombre AS jugador,
    c.nombre AS capitan
FROM jugador j
INNER JOIN jugador c ON j.idCapitan = c.idJugador;
```

### Múltiples JOINs encadenados

```sql
-- Receta completa: paciente → cita → receta → detalle → medicamento
SELECT 
    p.nombreCompleto AS paciente,
    m.nombreCompleto AS medico,
    med.nombreComercial AS medicamento,
    rd.dosis
FROM RecetaDetalle rd
INNER JOIN Receta r ON rd.idReceta = r.idReceta
INNER JOIN Cita c ON r.idCita = c.idCita
INNER JOIN pacientes p ON c.idPaciente = p.idPaciente
INNER JOIN medicos m ON c.idMedico = m.idMedico
INNER JOIN medicamentos med ON rd.idMedicamento = med.idMedicamento;

-- Partidos con nombres de equipos (join doble a misma tabla)
SELECT 
    el.nombreEquipo AS local,
    ev.nombreEquipo AS visitante,
    p.resultado
FROM partido p
INNER JOIN equipo el ON p.elocal = el.idEquipo
INNER JOIN equipo ev ON p.evisitante = ev.idEquipo;
```

---

## 12. Subconsultas

### En WHERE

```sql
-- Jugadores que ganan más que el promedio
SELECT nombre, salarioBruto FROM jugador
WHERE salarioBruto > (SELECT AVG(salarioBruto) FROM jugador);

-- Jugadores del equipo con más puntos
SELECT nombre FROM jugador
WHERE idEquipo = (SELECT idEquipo FROM equipo ORDER BY puntos DESC LIMIT 1);

-- Médicos que han atendido citas
SELECT nombreCompleto FROM medicos
WHERE idMedico IN (SELECT DISTINCT idMedico FROM Cita);
```

### En FROM (tabla derivada)

```sql
-- Promedio de citas por médico
SELECT AVG(total_citas) AS promedio
FROM (
    SELECT idMedico, COUNT(*) AS total_citas
    FROM Cita
    GROUP BY idMedico
) AS citas_por_medico;   -- ¡Alias OBLIGATORIO!
```

### En SELECT

```sql
-- Cada equipo con su número de jugadores
SELECT 
    nombreEquipo,
    (SELECT COUNT(*) FROM jugador j WHERE j.idEquipo = e.idEquipo) AS num_jugadores
FROM equipo e;
```

---

## 13. Ejemplos Combinados

### Liga Baloncesto

```sql
-- Top 3 equipos por puntos con número de jugadores
SELECT 
    e.nombreEquipo,
    e.puntos,
    COUNT(j.idJugador) AS num_jugadores
FROM equipo e
LEFT JOIN jugador j ON e.idEquipo = j.idEquipo
GROUP BY e.idEquipo, e.nombreEquipo, e.puntos
ORDER BY e.puntos DESC
LIMIT 3;

-- Jugadores más altos que su capitán
SELECT 
    j.nombre AS jugador,
    j.altura AS alt_jugador,
    c.nombre AS capitan,
    c.altura AS alt_capitan
FROM jugador j
INNER JOIN jugador c ON j.idCapitan = c.idJugador
WHERE j.altura > c.altura;
```

### Hospital

```sql
-- Recetas por médico con especialidad
SELECT 
    m.nombreCompleto,
    esp.nombre AS especialidad,
    COUNT(r.idReceta) AS total_recetas
FROM medicos m
INNER JOIN especialidades esp ON m.idEspecialidad = esp.idEspecialidad
LEFT JOIN Cita c ON m.idMedico = c.idMedico
LEFT JOIN Receta r ON c.idCita = r.idCita
GROUP BY m.idMedico, m.nombreCompleto, esp.nombre
ORDER BY total_recetas DESC;

-- Medicamentos más recetados
SELECT 
    med.nombreComercial,
    COUNT(*) AS veces_recetado
FROM medicamentos med
INNER JOIN RecetaDetalle rd ON med.idMedicamento = rd.idMedicamento
GROUP BY med.idMedicamento, med.nombreComercial
ORDER BY veces_recetado DESC
LIMIT 5;
```

---

## 14. Errores Comunes

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
SELECT * FROM jugador WHERE salarioBruto > (SELECT AVG(salarioBruto) FROM jugador);
```

### ❌ Comparar NULL con =

```sql
-- MAL
SELECT * FROM tabla WHERE columna = NULL;

-- BIEN
SELECT * FROM tabla WHERE columna IS NULL;
```

---

## 15. Orden de Ejecución Real

> No es el orden en que se escribe, sino cómo MySQL lo procesa internamente:

1. `FROM / JOIN` → De dónde saco los datos
2. `WHERE` → Filtro filas
3. `GROUP BY` → Agrupo
4. `HAVING` → Filtro grupos
5. `SELECT` → Elijo columnas
6. `DISTINCT` → Elimino duplicados
7. `ORDER BY` → Ordeno
8. `LIMIT` → Limito resultados

---

## 16. Plantillas Rápidas

### "Dame los X que tienen Y"

```sql
SELECT a.* FROM tablaA a
INNER JOIN tablaB b ON a.id = b.idA;
```

### "Dame los X que NO tienen Y"

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

### "El X con más/menos Y"

```sql
SELECT a.nombre, COUNT(b.id) AS cantidad
FROM tablaA a
INNER JOIN tablaB b ON a.id = b.idA
GROUP BY a.id, a.nombre
ORDER BY cantidad DESC   -- o ASC para el menor
LIMIT 1;
```

### "Los X cuyo Y es mayor que el promedio"

```sql
SELECT * FROM tabla
WHERE columna > (SELECT AVG(columna) FROM tabla);
```

---

> 🍀 **¡Buena suerte en el examen!**
