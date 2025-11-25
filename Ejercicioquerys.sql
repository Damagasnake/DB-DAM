
-- 1. Muéstrame el nombre y vía de administración de los medicamentos que son de via oral
select nombreComercial, viaAdministracion from medicamentos where viaAdministracion= 'Oral';
-- 2. Muéstrame el principio activo de los medicamentos que su presentación sean en mcg
select principioActivo from medicamentos where nombreComercial like '%mg%';
-- 3. Muéstrame el Id de los medicamentos que se deben tomar cada 8 Horas
select idMedicamento from RecetaDetalle where frecuencia like '%8%';
-- 4. Realiza una lista de medicamentos organizados de forma alfabética por nombre y presentación
select nombreComercial, presentacion from medicamentos order by nombreComercial;
-- 5. Muéstrame as observaciones del día 11 de noviembre.
SELECT observaciones FROM Receta WHERE fecha = '2025-11-11';