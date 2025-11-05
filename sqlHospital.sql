DROP DATABASE IF EXISTS hospital;
CREATE DATABASE hospital;
USE hospital;

-- ============================================
-- CREACIÓN DE TABLAS
-- ============================================

-- Tabla de especialidades
CREATE TABLE especialidades(
    idEspecialidad INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Tabla de médicos
CREATE TABLE medicos(
    idMedico INT PRIMARY KEY,
    nombreCompleto VARCHAR(50),
    nroCategoria VARCHAR(8),
    Telefono INT,
    email VARCHAR(50),
    idEspecialidad INT,
    nameId VARCHAR(50),
    FOREIGN KEY (idEspecialidad) REFERENCES especialidades(idEspecialidad)
);

-- Tabla de pacientes
CREATE TABLE pacientes(
    idPaciente INT PRIMARY KEY,
    nombreCompleto VARCHAR(50),
    numeroIdentidad VARCHAR(8),
    fechaNacimiento DATE,
    sexo BOOLEAN,
    direccion VARCHAR(100),
    Telefono INT,
    email VARCHAR(50)
);

-- Tabla de medicamentos
CREATE TABLE medicamentos(
    idMedicamento INT PRIMARY KEY,
    nombreComercial VARCHAR(50),
    principioActivo VARCHAR(50),
    presentacion VARCHAR(50),
    viaAdministracion VARCHAR(50),
    diagnosticoAsociado VARCHAR(50)
);

-- Tabla Cita
CREATE TABLE Cita(
    idCita INT PRIMARY KEY,
    idPaciente INT NOT NULL,
    idMedico INT NOT NULL,
    fechaHora DATETIME NOT NULL,
    motivo VARCHAR(200) NOT NULL,
    estado ENUM('programada','atendida','cancelada') DEFAULT 'programada',
    FOREIGN KEY (idPaciente) REFERENCES pacientes(idPaciente),
    FOREIGN KEY (idMedico) REFERENCES medicos(idMedico)
);

-- Tabla Receta
CREATE TABLE Receta(
    idReceta INT PRIMARY KEY AUTO_INCREMENT,
    idCita INT NOT NULL,
    fecha DATE NOT NULL,
    observaciones TEXT,
    FOREIGN KEY (idCita) REFERENCES Cita(idCita)
);

-- Tabla RecetaDetalle
CREATE TABLE RecetaDetalle(
    idRecetaDetalle INT PRIMARY KEY AUTO_INCREMENT,
    idReceta INT NOT NULL,
    idMedicamento INT NOT NULL,
    dosis VARCHAR(60),
    frecuencia VARCHAR(60) NOT NULL,
    duracionDias INT NOT NULL,
    instrucciones TEXT,
    FOREIGN KEY (idReceta) REFERENCES Receta(idReceta),
    FOREIGN KEY (idMedicamento) REFERENCES medicamentos(idMedicamento)
);

-- ============================================
-- INSERCIÓN DE DATOS
-- ============================================

-- 1. Insertar Especialidades
INSERT INTO especialidades (idEspecialidad, nombre) VALUES
(1, 'Medicina General'),
(2, 'Dermatología'),
(3, 'Neumología'),
(4, 'Cardiología'),
(5, 'Pediatría');

-- 2. Insertar Médicos
INSERT INTO medicos (idMedico, nombreCompleto, nroCategoria, Telefono, email, idEspecialidad, nameId) VALUES
(1, 'Dra. Laura Méndez', 'MED12345', 912345001, 'laura.mendez@hospital.com', 1, 'LMendez'),
(2, 'Dra. Silvia Ríos', 'DER23456', 912345002, 'silvia.rios@hospital.com', 2, 'SRios'),
(3, 'Dr. Miguel Torres', 'NEU34567', 912345003, 'miguel.torres@hospital.com', 3, 'MTorres'),
(4, 'Dr. Andrés Pardo', 'CAR45678', 912345004, 'andres.pardo@hospital.com', 4, 'APardo'),
(5, 'Dra. Paula Gómez', 'PED56789', 912345005, 'paula.gomez@hospital.com', 5, 'PGomez');

-- 3. Insertar Pacientes
INSERT INTO pacientes (idPaciente, nombreCompleto, numeroIdentidad, fechaNacimiento, sexo, direccion, Telefono, email) VALUES
(1, 'Simón Pedro', '12345678', '1985-03-15', 1, 'Calle Mayor 10, Madrid', 655123001, 'simon.pedro@email.com'),
(2, 'Andrés de Betesda', '23456789', '1978-07-22', 1, 'Avenida Constitución 25, Madrid', 655123002, 'andres.betesda@email.com'),
(3, 'Juan de Zebedeo', '34567890', '1990-11-08', 1, 'Plaza España 5, Madrid', 655123003, 'juan.zebedeo@email.com'),
(4, 'Felipe de Betesda', '45678901', '1982-05-30', 1, 'Calle Alcalá 40, Madrid', 655123004, 'felipe.betesda@email.com'),
(5, 'Santiago el Mayor', '56789012', '1965-09-12', 1, 'Gran Vía 100, Madrid', 655123005, 'santiago.mayor@email.com'),
(6, 'Mateo Leví', '67890123', '2015-02-18', 1, 'Calle Serrano 30, Madrid', 655123006, 'contacto.mateo@email.com'),
(7, 'Tomás Dídimo', '78901234', '1988-12-25', 1, 'Paseo Castellana 80, Madrid', 655123007, 'tomas.didimo@email.com'),
(8, 'Santiago el Menor', '89012345', '1992-06-14', 1, 'Calle Goya 15, Madrid', 655123008, 'santiago.menor@email.com');

-- 4. Insertar Medicamentos
INSERT INTO medicamentos (idMedicamento, nombreComercial, principioActivo, presentacion, viaAdministracion, diagnosticoAsociado) VALUES
(1, 'Paracetamol 500mg', 'Paracetamol', 'Comprimidos', 'Oral', 'Dolor y fiebre'),
(2, 'Amoxicilina 875/125mg', 'Amoxicilina + Clavulánico', 'Comprimidos', 'Oral', 'Infecciones bacterianas'),
(3, 'Betametasona Crema 0.05%', 'Betametasona', 'Crema', 'Tópica', 'Dermatitis'),
(4, 'Salbutamol Inhalador', 'Salbutamol', 'Inhalador', 'Inhalatoria', 'Asma'),
(5, 'Omeprazol 20mg', 'Omeprazol', 'Cápsulas', 'Oral', 'Dispepsia'),
(6, 'Losartán 50mg', 'Losartán', 'Comprimidos', 'Oral', 'Hipertensión'),
(7, 'Hidroclorotiazida 25mg', 'Hidroclorotiazida', 'Comprimidos', 'Oral', 'Hipertensión'),
(8, 'Clotrimazol Crema 1%', 'Clotrimazol', 'Crema', 'Tópica', 'Infecciones fúngicas'),
(9, 'Ibuprofeno 400mg', 'Ibuprofeno', 'Comprimidos', 'Oral', 'Dolor e inflamación'),
(10, 'Diazepam 5mg', 'Diazepam', 'Comprimidos', 'Oral', 'Ansiedad y espasmos'),
(11, 'Loratadina 10mg', 'Loratadina', 'Comprimidos', 'Oral', 'Alergia'),
(12, 'Mupirocina Ungüento', 'Mupirocina', 'Ungüento', 'Tópica', 'Infecciones cutáneas');

-- 5. Insertar Citas
INSERT INTO Cita (idCita, idPaciente, idMedico, fechaHora, motivo, estado) VALUES
(1, 1, 1, '2025-11-06 09:30:00', 'Dolor de garganta, fiebre leve y malestar general', 'atendida'),
(2, 2, 2, '2025-11-06 11:00:00', 'Irritación cutánea en brazos tras usar detergente nuevo', 'atendida'),
(3, 3, 3, '2025-11-06 15:00:00', 'Dificultad respiratoria y tos nocturna', 'atendida'),
(4, 4, 1, '2025-11-07 10:00:00', 'Dolor abdominal poscomida, ardor estomacal', 'atendida'),
(5, 5, 4, '2025-11-08 09:00:00', 'Control de presión arterial; refiere cefalea leve', 'atendida'),
(6, 5, 2, '2025-11-08 11:30:00', 'Lesión descamativa entre los dedos del pie derecho', 'atendida'),
(7, 6, 5, '2025-11-09 16:00:00', 'Dolor de oído derecho, congestión nasal', 'atendida'),
(8, 7, 3, '2025-11-10 09:00:00', 'Tos seca y malestar general sin fiebre alta', 'atendida'),
(9, 1, 4, '2025-11-10 12:00:00', 'Dolor lumbar leve y mareos esporádicos', 'atendida'),
(10, 8, 1, '2025-11-11 08:30:00', 'Congestión nasal y estornudos frecuentes', 'atendida'),
(11, 4, 4, '2025-11-11 11:00:00', 'Revisión de tratamiento antihipertensivo', 'atendida'),
(12, 1, 2, '2025-11-12 15:00:00', 'Lesión en antebrazo con costra y enrojecimiento', 'atendida');

-- 6. Insertar Recetas
INSERT INTO Receta (idReceta, idCita, fecha, observaciones) VALUES
(1, 1, '2025-11-06', 'Reposo 3 días, mantener hidratación, reevaluar si fiebre persiste.'),
(2, 2, '2025-11-06', 'Aplicar capa fina dos veces al día por 5 días; evitar el producto causante.'),
(3, 3, '2025-11-06', '2 inhalaciones cada 8 horas durante 3 días; control a la semana.'),
(4, 4, '2025-11-07', 'Tomar 1 cápsula diaria antes del desayuno durante 14 días.'),
(5, 5, '2025-11-08', 'Reanudar medicación diaria; medir presión cada 3 días.'),
(6, 6, '2025-11-08', 'Aplicar 2 veces al día durante 14 días; mantener pies secos.'),
(7, 7, '2025-11-09', 'Tomar antibiótico 7 días, analgésico cada 8h; mantener oído seco.'),
(8, 8, '2025-11-10', 'Tratamiento sintomático; líquidos abundantes; reposo domiciliario.'),
(9, 9, '2025-11-10', 'Reposo relativo; evitar cargar peso; analgésicos según dolor.'),
(10, 10, '2025-11-11', '1 tableta diaria por 7 días; evitar polvo y flores.'),
(11, 11, '2025-11-11', 'Mantener dosis actual; control cada 3 meses.'),
(12, 12, '2025-11-12', 'Aplicar capa fina 3 veces al día por 5 días; cubrir con gasa limpia.');

-- 7. Insertar Detalles de Recetas
INSERT INTO RecetaDetalle (idRecetaDetalle, idReceta, idMedicamento, dosis, frecuencia, duracionDias, instrucciones) VALUES
-- Caso 1: Simón Pedro - Faringoamigdalitis
(1, 1, 1, '500 mg', 'cada 8 horas', 3, 'Tomar después de las comidas con abundante agua.'),
(2, 1, 2, '875/125 mg', 'cada 8 horas', 7, 'Completar tratamiento aunque mejoren los síntomas.'),

-- Caso 2: Andrés - Dermatitis de contacto
(3, 2, 3, '0.05%', 'cada 12 horas', 5, 'Aplicar capa fina en zona afectada; no cubrir.'),

-- Caso 3: Juan - Crisis asmática
(4, 3, 4, '100 mcg', 'cada 8 horas', 3, 'Agitar antes de usar; 2 inhalaciones por dosis.'),

-- Caso 4: Felipe - Dispepsia funcional
(5, 4, 5, '20 mg', 'cada 24 horas', 14, 'Tomar en ayunas, 30 minutos antes del desayuno.'),

-- Caso 5: Santiago Mayor - Hipertensión
(6, 5, 6, '50 mg', 'cada 24 horas', 30, 'Tomar por la mañana con el desayuno.'),
(7, 5, 7, '25 mg', 'cada 24 horas', 30, 'Tomar junto con el Losartán.'),

-- Caso 6: Santiago Mayor - Tiña pedis
(8, 6, 8, '1%', 'cada 12 horas', 14, 'Limpiar y secar bien la zona antes de aplicar.'),

-- Caso 7: Mateo - Otitis media
(9, 7, 2, '875/125 mg', 'cada 12 horas', 7, 'Tomar con alimentos para mejor tolerancia.'),
(10, 7, 1, '500 mg', 'cada 8 horas', 7, 'Solo si hay dolor; no exceder 3 gramos al día.'),

-- Caso 8: Tomás - Infección respiratoria
(11, 8, 4, '100 mcg', 'según necesidad', 5, 'Usar si hay dificultad respiratoria.'),
(12, 8, 1, '500 mg', 'cada 8 horas', 5, 'Tomar con abundante líquido.'),

-- Caso 9: Simón Pedro - Lumbalgia
(13, 9, 9, '400 mg', 'cada 8 horas', 7, 'Tomar con alimentos; suspender si hay dolor gástrico.'),
(14, 9, 10, '5 mg', 'cada 12 horas', 5, 'Tomar solo si hay espasmos musculares.'),

-- Caso 10: Santiago Menor - Rinitis alérgica
(15, 10, 11, '10 mg', 'cada 24 horas', 7, 'Tomar preferiblemente por la noche.'),

-- Caso 11: Felipe - Revisión hipertensión
(16, 11, 6, '50 mg', 'cada 24 horas', 90, 'Continuar con tratamiento habitual.'),

-- Caso 12: Simón Pedro - Dermatitis infectada
(17, 12, 12, '2%', 'cada 8 horas', 5, 'Limpiar zona con agua y jabón antes de aplicar.');
