-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                    HIPERCHULETA SQL - DE 0 A JOINS                            ║
-- ║                         Damaga Edition 2025                                   ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

-- ═══════════════════════════════════════════════════════════════════════════════
-- 1. ESTRUCTURA DE BASE DE DATOS (DDL - Data Definition Language)
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ CREAR Y ELIMINAR BASES DE DATOS                                            │
-- └─────────────────────────────────────────────────────────────────────────────┘

DROP DATABASE IF EXISTS nombreDB;      -- Elimina la BD si existe (evita errores)
CREATE DATABASE nombreDB;              -- Crea la base de datos
USE nombreDB;                          -- Selecciona la BD para trabajar

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ CREAR TABLAS                                                                │
-- └─────────────────────────────────────────────────────────────────────────────┘

CREATE TABLE nombre_tabla (
    -- Columna con clave primaria simple
    id INT PRIMARY KEY,
    
    -- Columna con auto incremento (no hace falta insertar valor)
    id INT PRIMARY KEY AUTO_INCREMENT,
    
    -- Tipos de datos comunes
    texto VARCHAR(50),                 -- Texto variable hasta 50 caracteres
    texto_largo TEXT,                  -- Texto largo sin límite práctico
    numero_entero INT,                 -- Número entero
    numero_decimal DECIMAL(10,2),      -- Decimal con 10 dígitos, 2 decimales
    fecha DATE,                        -- Solo fecha: '2025-11-25'
    fecha_hora DATETIME,               -- Fecha y hora: '2025-11-25 10:30:00'
    booleano BOOLEAN,                  -- TRUE/FALSE (1/0)
    
    -- Restricciones de columna
    columna VARCHAR(50) NOT NULL,                    -- No permite valores nulos
    columna VARCHAR(50) DEFAULT 'valor',             -- Valor por defecto
    columna VARCHAR(50) UNIQUE,                      -- Valores únicos
    
    -- ENUM: solo permite valores específicos
    estado ENUM('activo','inactivo','pendiente') DEFAULT 'pendiente',
    
    -- Clave foránea (referencia a otra tabla)
    idOtraTabla INT,
    FOREIGN KEY (idOtraTabla) REFERENCES otraTabla(idOtraTabla)
);

-- Clave primaria compuesta (varias columnas forman la PK)
CREATE TABLE partido (
    elocal INT,
    evisitante INT,
    fecha DATE,
    resultado VARCHAR(7),
    PRIMARY KEY(elocal, evisitante, fecha),          -- PK compuesta
    FOREIGN KEY(elocal) REFERENCES equipo(idEquipo),
    FOREIGN KEY(evisitante) REFERENCES equipo(idEquipo)
);

-- Auto-referencia (tabla que se referencia a sí misma)
CREATE TABLE empleado (
    idEmpleado INT PRIMARY KEY,
    nombre VARCHAR(50),
    idJefe INT,
    FOREIGN KEY (idJefe) REFERENCES empleado(idEmpleado)  -- Apunta a la misma tabla
);

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ MODIFICAR TABLAS (ALTER TABLE)                                             │
-- └─────────────────────────────────────────────────────────────────────────────┘

ALTER TABLE tabla ADD columna_nueva VARCHAR(50);           -- Añadir columna
ALTER TABLE tabla DROP COLUMN columna;                     -- Eliminar columna
ALTER TABLE tabla MODIFY columna INT NOT NULL;             -- Modificar tipo/restricción
ALTER TABLE tabla RENAME COLUMN viejo TO nuevo;            -- Renombrar columna
ALTER TABLE tabla ADD FOREIGN KEY (col) REFERENCES otra(id); -- Añadir FK

DROP TABLE IF EXISTS nombre_tabla;                         -- Eliminar tabla


-- ═══════════════════════════════════════════════════════════════════════════════
-- 2. INSERTAR, ACTUALIZAR Y ELIMINAR DATOS (DML - Data Manipulation Language)
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ INSERT - Insertar datos                                                     │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Insertar especificando columnas (recomendado)
INSERT INTO tabla (col1, col2, col3) VALUES ('valor1', 2, '2025-01-15');

-- Insertar sin especificar columnas (hay que poner TODOS los valores en orden)
INSERT INTO tabla VALUES (1, 'valor1', 2, '2025-01-15');

-- Insertar múltiples filas de una vez
INSERT INTO tabla (col1, col2) VALUES 
    ('valor1', 10),
    ('valor2', 20),
    ('valor3', 30);

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ UPDATE - Actualizar datos                                                   │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- ¡SIEMPRE usar WHERE! Sin WHERE actualiza TODAS las filas
UPDATE tabla SET columna = 'nuevo_valor' WHERE id = 1;

-- Actualizar varias columnas
UPDATE tabla SET col1 = 'valor1', col2 = 100 WHERE condicion;

-- Actualizar con cálculo
UPDATE jugador SET salarioBruto = salarioBruto * 1.10 WHERE idEquipo = 101;  -- Subir 10%

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ DELETE - Eliminar datos                                                     │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- ¡SIEMPRE usar WHERE! Sin WHERE elimina TODAS las filas
DELETE FROM tabla WHERE id = 1;

DELETE FROM tabla WHERE columna = 'valor' AND otra_columna > 10;

-- Eliminar todo (pero mantiene la estructura de la tabla)
DELETE FROM tabla;        -- Resetea auto_increment? NO
TRUNCATE TABLE tabla;     -- Resetea auto_increment? SÍ (más rápido)


-- ═══════════════════════════════════════════════════════════════════════════════
-- 3. SELECT BÁSICO - Consultar datos
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ SINTAXIS GENERAL (orden obligatorio de cláusulas)                          │
-- └─────────────────────────────────────────────────────────────────────────────┘

SELECT columnas                -- 1. Qué columnas quiero
FROM tabla                     -- 2. De qué tabla
WHERE condicion                -- 3. Filtrar filas (opcional)
GROUP BY columna               -- 4. Agrupar (opcional)
HAVING condicion_grupo         -- 5. Filtrar grupos (opcional)
ORDER BY columna               -- 6. Ordenar (opcional)
LIMIT n;                       -- 7. Limitar resultados (opcional)

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ SELECT BÁSICO                                                               │
-- └─────────────────────────────────────────────────────────────────────────────┘

SELECT * FROM tabla;                           -- Todas las columnas
SELECT col1, col2 FROM tabla;                  -- Columnas específicas
SELECT DISTINCT col1 FROM tabla;               -- Valores únicos (sin repetir)

-- Alias: renombrar columnas en el resultado
SELECT nombreEquipo AS equipo, ciudad AS ubicacion FROM equipo;
SELECT col1 nombre, col2 apellido FROM tabla;  -- AS es opcional


-- ═══════════════════════════════════════════════════════════════════════════════
-- 4. WHERE - Filtrar resultados
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ OPERADORES DE COMPARACIÓN                                                   │
-- └─────────────────────────────────────────────────────────────────────────────┘

SELECT * FROM tabla WHERE columna = 'valor';       -- Igual
SELECT * FROM tabla WHERE columna != 'valor';      -- Distinto (también <>)
SELECT * FROM tabla WHERE columna <> 'valor';      -- Distinto (alternativa)
SELECT * FROM tabla WHERE columna > 10;            -- Mayor que
SELECT * FROM tabla WHERE columna < 10;            -- Menor que
SELECT * FROM tabla WHERE columna >= 10;           -- Mayor o igual
SELECT * FROM tabla WHERE columna <= 10;           -- Menor o igual

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ OPERADORES LÓGICOS                                                          │
-- └─────────────────────────────────────────────────────────────────────────────┘

SELECT * FROM tabla WHERE cond1 AND cond2;         -- Ambas deben cumplirse
SELECT * FROM tabla WHERE cond1 OR cond2;          -- Al menos una
SELECT * FROM tabla WHERE NOT condicion;           -- Negación

-- Ejemplo combinado
SELECT * FROM jugador WHERE posicion = 'Base' AND salarioBruto > 1800;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ OPERADORES ESPECIALES                                                       │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- BETWEEN: rango inclusivo (incluye los extremos)
SELECT * FROM jugador WHERE altura BETWEEN 170 AND 180;
-- Equivale a: WHERE altura >= 170 AND altura <= 180

-- IN: lista de valores posibles
SELECT * FROM Cita WHERE estado IN ('programada', 'atendida');
-- Equivale a: WHERE estado = 'programada' OR estado = 'atendida'

-- NOT IN: excluir valores
SELECT * FROM Cita WHERE estado NOT IN ('cancelada');

-- IS NULL / IS NOT NULL: comprobar valores nulos
SELECT * FROM tabla WHERE columna IS NULL;
SELECT * FROM tabla WHERE columna IS NOT NULL;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ LIKE: búsqueda por patrones                                                 │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- %  = cualquier cantidad de caracteres (0 o más)
-- _  = exactamente UN carácter

SELECT * FROM tabla WHERE nombre LIKE 'A%';        -- Empieza por A
SELECT * FROM tabla WHERE nombre LIKE '%ez';       -- Termina en 'ez'
SELECT * FROM tabla WHERE nombre LIKE '%ar%';      -- Contiene 'ar'
SELECT * FROM tabla WHERE nombre LIKE 'J__n';      -- J + 2 caracteres + n (Juan, Jaen)
SELECT * FROM tabla WHERE email LIKE '%@gmail%';   -- Emails de Gmail

-- NOT LIKE: que NO coincida
SELECT * FROM tabla WHERE nombre NOT LIKE 'A%';


-- ═══════════════════════════════════════════════════════════════════════════════
-- 5. ORDER BY - Ordenar resultados
-- ═══════════════════════════════════════════════════════════════════════════════

SELECT * FROM jugador ORDER BY salarioBruto;           -- Ascendente (por defecto)
SELECT * FROM jugador ORDER BY salarioBruto ASC;       -- Ascendente (explícito)
SELECT * FROM jugador ORDER BY salarioBruto DESC;      -- Descendente

-- Ordenar por múltiples columnas (primero por posición, luego por salario)
SELECT * FROM jugador ORDER BY posicion ASC, salarioBruto DESC;

-- Ordenar por número de columna (no recomendado, pero funciona)
SELECT nombre, apellido, salarioBruto FROM jugador ORDER BY 3 DESC;  -- 3 = salarioBruto


-- ═══════════════════════════════════════════════════════════════════════════════
-- 6. LIMIT - Limitar resultados
-- ═══════════════════════════════════════════════════════════════════════════════

SELECT * FROM jugador LIMIT 5;                     -- Primeras 5 filas
SELECT * FROM jugador LIMIT 5 OFFSET 10;           -- 5 filas, saltando las 10 primeras
SELECT * FROM jugador LIMIT 10, 5;                 -- Alternativa: LIMIT offset, cantidad

-- Top 3 jugadores mejor pagados
SELECT nombre, salarioBruto FROM jugador ORDER BY salarioBruto DESC LIMIT 3;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 7. FUNCIONES DE AGREGACIÓN
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ FUNCIONES PRINCIPALES                                                       │
-- └─────────────────────────────────────────────────────────────────────────────┘

SELECT COUNT(*) FROM jugador;                      -- Cuenta TODAS las filas
SELECT COUNT(columna) FROM tabla;                  -- Cuenta filas donde columna NO es NULL
SELECT COUNT(DISTINCT columna) FROM tabla;         -- Cuenta valores únicos

SELECT SUM(salarioBruto) FROM jugador;             -- Suma total
SELECT AVG(salarioBruto) FROM jugador;             -- Promedio (average)
SELECT MAX(salarioBruto) FROM jugador;             -- Valor máximo
SELECT MIN(altura) FROM jugador;                   -- Valor mínimo

-- Combinar varias funciones
SELECT 
    COUNT(*) AS total,
    SUM(salarioBruto) AS suma_salarios,
    AVG(salarioBruto) AS promedio,
    MAX(salarioBruto) AS maximo,
    MIN(salarioBruto) AS minimo
FROM jugador;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 8. GROUP BY - Agrupar resultados
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ REGLA DE ORO: toda columna en SELECT debe estar en GROUP BY o en función   │
-- └─────────────────────────────────────────────────────────────────────────────┘

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


-- ═══════════════════════════════════════════════════════════════════════════════
-- 9. HAVING - Filtrar grupos
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ WHERE vs HAVING                                                             │
-- │ • WHERE filtra FILAS antes de agrupar                                       │
-- │ • HAVING filtra GRUPOS después de agrupar                                   │
-- └─────────────────────────────────────────────────────────────────────────────┘

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
WHERE altura > 170                     -- Primero filtra jugadores altos
GROUP BY idEquipo                      -- Luego agrupa por equipo
HAVING AVG(salarioBruto) > 2000;       -- Finalmente filtra equipos con promedio > 2000


-- ═══════════════════════════════════════════════════════════════════════════════
-- 10. FUNCIONES ÚTILES
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ FUNCIONES DE TEXTO                                                          │
-- └─────────────────────────────────────────────────────────────────────────────┘

SELECT UPPER(nombre) FROM tabla;                   -- Mayúsculas
SELECT LOWER(nombre) FROM tabla;                   -- Minúsculas
SELECT LENGTH(nombre) FROM tabla;                  -- Longitud del texto
SELECT CONCAT(nombre, ' ', apellido) FROM tabla;   -- Concatenar textos
SELECT SUBSTRING(nombre, 1, 3) FROM tabla;         -- Subcadena (pos inicial, longitud)
SELECT TRIM(nombre) FROM tabla;                    -- Quitar espacios inicio/fin
SELECT REPLACE(texto, 'viejo', 'nuevo') FROM t;    -- Reemplazar texto

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ FUNCIONES DE FECHA                                                          │
-- └─────────────────────────────────────────────────────────────────────────────┘

SELECT NOW();                                      -- Fecha y hora actual
SELECT CURDATE();                                  -- Fecha actual (sin hora)
SELECT CURTIME();                                  -- Hora actual (sin fecha)

SELECT YEAR(fecha) FROM tabla;                     -- Extraer año
SELECT MONTH(fecha) FROM tabla;                    -- Extraer mes (1-12)
SELECT DAY(fecha) FROM tabla;                      -- Extraer día del mes
SELECT DAYNAME(fecha) FROM tabla;                  -- Nombre del día (Monday, etc)
SELECT MONTHNAME(fecha) FROM tabla;                -- Nombre del mes

SELECT DATEDIFF(fecha1, fecha2) FROM tabla;        -- Diferencia en días
SELECT DATE_ADD(fecha, INTERVAL 7 DAY) FROM t;     -- Sumar días
SELECT DATE_SUB(fecha, INTERVAL 1 MONTH) FROM t;   -- Restar meses

-- Filtrar por fechas
SELECT * FROM Cita WHERE fechaHora > '2025-11-01';
SELECT * FROM Cita WHERE YEAR(fechaHora) = 2025 AND MONTH(fechaHora) = 11;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ FUNCIONES NUMÉRICAS                                                         │
-- └─────────────────────────────────────────────────────────────────────────────┘

SELECT ROUND(numero, 2) FROM tabla;                -- Redondear a 2 decimales
SELECT CEIL(numero) FROM tabla;                    -- Redondear hacia arriba
SELECT FLOOR(numero) FROM tabla;                   -- Redondear hacia abajo
SELECT ABS(numero) FROM tabla;                     -- Valor absoluto
SELECT MOD(numero, 2) FROM tabla;                  -- Módulo (resto división)

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ FUNCIONES CONDICIONALES                                                     │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- IF simple
SELECT nombre, IF(salarioBruto > 2000, 'Alto', 'Normal') AS categoria FROM jugador;

-- IFNULL: reemplazar NULL
SELECT IFNULL(telefono, 'Sin teléfono') FROM tabla;

-- COALESCE: primer valor no nulo
SELECT COALESCE(movil, fijo, 'Sin contacto') FROM tabla;

-- CASE: múltiples condiciones (como switch)
SELECT nombre,
    CASE 
        WHEN salarioBruto >= 2300 THEN 'Premium'
        WHEN salarioBruto >= 2000 THEN 'Medio'
        ELSE 'Base'
    END AS categoria
FROM jugador;

-- CASE simple (comparando con valor)
SELECT nombre,
    CASE posicion
        WHEN 'Base' THEN 'Organizador'
        WHEN 'Pivot' THEN 'Interior'
        ELSE 'Exterior'
    END AS rol
FROM jugador;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 11. JOINS - Combinar tablas
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ DIAGRAMA DE JOINS                                                           │
-- │                                                                             │
-- │   INNER JOIN        LEFT JOIN         RIGHT JOIN        FULL JOIN          │
-- │   ┌───┬───┐         ┌───┬───┐         ┌───┬───┐         ┌───┬───┐          │
-- │   │   │███│         │███│███│         │███│███│         │███│███│          │
-- │   │ A │███│ B       │███│███│ B       │ A │███│         │███│███│          │
-- │   │   │███│         │███│███│         │   │███│         │███│███│          │
-- │   └───┴───┘         └───┴───┘         └───┴───┘         └───┴───┘          │
-- │   Solo coincid.     Todo A + coinc.   Coinc. + todo B   Todo de ambas      │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ INNER JOIN (o simplemente JOIN) - Solo coincidencias en AMBAS tablas       │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Sintaxis explícita (recomendada)
SELECT j.nombre, j.apellido, e.nombreEquipo
FROM jugador j
INNER JOIN equipo e ON j.idEquipo = e.idEquipo;

-- Sintaxis implícita (antigua, evitar)
SELECT j.nombre, j.apellido, e.nombreEquipo
FROM jugador j, equipo e
WHERE j.idEquipo = e.idEquipo;

-- Ejemplo hospital: citas con datos de paciente y médico
SELECT 
    p.nombreCompleto AS paciente,
    m.nombreCompleto AS medico,
    c.fechaHora,
    c.motivo
FROM Cita c
INNER JOIN pacientes p ON c.idPaciente = p.idPaciente
INNER JOIN medicos m ON c.idMedico = m.idMedico;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ LEFT JOIN - Todo de la tabla IZQUIERDA + coincidencias de la derecha       │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Todos los equipos, tengan o no jugadores
SELECT e.nombreEquipo, j.nombre
FROM equipo e
LEFT JOIN jugador j ON e.idEquipo = j.idEquipo;
-- Si un equipo no tiene jugadores, aparece con NULL en nombre

-- Encontrar equipos SIN jugadores
SELECT e.nombreEquipo
FROM equipo e
LEFT JOIN jugador j ON e.idEquipo = j.idEquipo
WHERE j.idJugador IS NULL;

-- Todos los pacientes con sus citas (aunque no tengan citas)
SELECT p.nombreCompleto, c.fechaHora
FROM pacientes p
LEFT JOIN Cita c ON p.idPaciente = c.idPaciente;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ RIGHT JOIN - Coincidencias de izquierda + todo de la tabla DERECHA         │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Equivalente al LEFT JOIN anterior pero al revés
SELECT e.nombreEquipo, j.nombre
FROM jugador j
RIGHT JOIN equipo e ON j.idEquipo = e.idEquipo;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ SELF JOIN - Tabla que se une consigo misma                                  │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Jugadores con su capitán (ambos están en la misma tabla)
SELECT 
    j.nombre AS jugador,
    c.nombre AS capitan
FROM jugador j
INNER JOIN jugador c ON j.idCapitan = c.idJugador;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ MÚLTIPLES JOINS - Encadenar varias tablas                                   │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Receta completa: paciente → cita → receta → detalle → medicamento
SELECT 
    p.nombreCompleto AS paciente,
    m.nombreCompleto AS medico,
    med.nombreComercial AS medicamento,
    rd.dosis,
    rd.frecuencia
FROM RecetaDetalle rd
INNER JOIN Receta r ON rd.idReceta = r.idReceta
INNER JOIN Cita c ON r.idCita = c.idCita
INNER JOIN pacientes p ON c.idPaciente = p.idPaciente
INNER JOIN medicos m ON c.idMedico = m.idMedico
INNER JOIN medicamentos med ON rd.idMedicamento = med.idMedicamento;

-- Partidos con nombres de equipos (join doble a la misma tabla)
SELECT 
    el.nombreEquipo AS local,
    ev.nombreEquipo AS visitante,
    p.fecha,
    p.resultado
FROM partido p
INNER JOIN equipo el ON p.elocal = el.idEquipo
INNER JOIN equipo ev ON p.evisitante = ev.idEquipo;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 12. SUBCONSULTAS
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ SUBCONSULTA EN WHERE                                                        │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Jugadores que ganan más que el promedio
SELECT nombre, salarioBruto FROM jugador
WHERE salarioBruto > (SELECT AVG(salarioBruto) FROM jugador);

-- Jugadores del equipo con más puntos
SELECT nombre, apellido FROM jugador
WHERE idEquipo = (SELECT idEquipo FROM equipo ORDER BY puntos DESC LIMIT 1);

-- Médicos que han atendido citas
SELECT nombreCompleto FROM medicos
WHERE idMedico IN (SELECT DISTINCT idMedico FROM Cita);

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ SUBCONSULTA EN FROM (tabla derivada)                                        │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Promedio de citas por médico
SELECT AVG(total_citas) AS promedio_citas_por_medico
FROM (
    SELECT idMedico, COUNT(*) AS total_citas
    FROM Cita
    GROUP BY idMedico
) AS citas_por_medico;                 -- ¡Necesita alias obligatorio!

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ SUBCONSULTA EN SELECT                                                       │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Cada equipo con su número de jugadores
SELECT 
    nombreEquipo,
    (SELECT COUNT(*) FROM jugador j WHERE j.idEquipo = e.idEquipo) AS num_jugadores
FROM equipo e;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 13. CONSULTAS DE EJEMPLO COMBINADAS
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ LIGA BALONCESTO                                                             │
-- └─────────────────────────────────────────────────────────────────────────────┘

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
    j.altura AS altura_jugador,
    c.nombre AS capitan,
    c.altura AS altura_capitan
FROM jugador j
INNER JOIN jugador c ON j.idCapitan = c.idJugador
WHERE j.altura > c.altura;

-- Equipos que han jugado como local más de 2 veces
SELECT e.nombreEquipo, COUNT(*) AS partidos_local
FROM equipo e
INNER JOIN partido p ON e.idEquipo = p.elocal
GROUP BY e.idEquipo, e.nombreEquipo
HAVING COUNT(*) > 2;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ HOSPITAL                                                                    │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- Cuántas recetas ha emitido cada médico
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

-- Pacientes que han recibido más de 2 medicamentos diferentes
SELECT 
    p.nombreCompleto,
    COUNT(DISTINCT rd.idMedicamento) AS medicamentos_diferentes
FROM pacientes p
INNER JOIN Cita c ON p.idPaciente = c.idPaciente
INNER JOIN Receta r ON c.idCita = r.idCita
INNER JOIN RecetaDetalle rd ON r.idReceta = rd.idReceta
GROUP BY p.idPaciente, p.nombreCompleto
HAVING COUNT(DISTINCT rd.idMedicamento) > 2;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 14. TRUCOS Y ERRORES COMUNES
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ ERRORES TÍPICOS                                                             │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- ❌ ERROR: columna en SELECT no está en GROUP BY ni en función agregada
SELECT nombre, COUNT(*) FROM jugador GROUP BY idEquipo;  -- FALLA

-- ✅ CORRECTO:
SELECT idEquipo, COUNT(*) FROM jugador GROUP BY idEquipo;

-- ❌ ERROR: usar función de agregación en WHERE
SELECT * FROM jugador WHERE salarioBruto > AVG(salarioBruto);  -- FALLA

-- ✅ CORRECTO: usar subconsulta
SELECT * FROM jugador WHERE salarioBruto > (SELECT AVG(salarioBruto) FROM jugador);

-- ❌ ERROR: comparar con NULL usando =
SELECT * FROM tabla WHERE columna = NULL;  -- No funciona como esperas

-- ✅ CORRECTO: usar IS NULL
SELECT * FROM tabla WHERE columna IS NULL;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ ORDEN DE EJECUCIÓN REAL (no es el orden en que se escribe)                  │
-- └─────────────────────────────────────────────────────────────────────────────┘

-- 1. FROM / JOIN      → De dónde saco los datos
-- 2. WHERE            → Filtro filas
-- 3. GROUP BY         → Agrupo
-- 4. HAVING           → Filtro grupos
-- 5. SELECT           → Elijo columnas
-- 6. DISTINCT         → Elimino duplicados
-- 7. ORDER BY         → Ordeno
-- 8. LIMIT            → Limito resultados


-- ═══════════════════════════════════════════════════════════════════════════════
-- 15. PLANTILLAS RÁPIDAS
-- ═══════════════════════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ "Dame los X que tienen Y"                                                   │
-- └─────────────────────────────────────────────────────────────────────────────┘
SELECT a.* FROM tablaA a
INNER JOIN tablaB b ON a.id = b.idA;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ "Dame los X que NO tienen Y"                                                │
-- └─────────────────────────────────────────────────────────────────────────────┘
SELECT a.* FROM tablaA a
LEFT JOIN tablaB b ON a.id = b.idA
WHERE b.id IS NULL;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ "Cuántos Y tiene cada X"                                                    │
-- └─────────────────────────────────────────────────────────────────────────────┘
SELECT a.nombre, COUNT(b.id) AS cantidad
FROM tablaA a
LEFT JOIN tablaB b ON a.id = b.idA
GROUP BY a.id, a.nombre;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ "El X con más/menos Y"                                                      │
-- └─────────────────────────────────────────────────────────────────────────────┘
SELECT a.nombre, COUNT(b.id) AS cantidad
FROM tablaA a
INNER JOIN tablaB b ON a.id = b.idA
GROUP BY a.id, a.nombre
ORDER BY cantidad DESC   -- o ASC para el menor
LIMIT 1;

-- ┌─────────────────────────────────────────────────────────────────────────────┐
-- │ "Los X cuyo Y es mayor que el promedio"                                     │
-- └─────────────────────────────────────────────────────────────────────────────┘
SELECT * FROM tabla
WHERE columna > (SELECT AVG(columna) FROM tabla);


-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║                              FIN DE LA CHULETA                                ║
-- ║                           ¡Buena suerte en el examen!                         ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝
