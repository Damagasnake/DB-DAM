drop database if exists ligaBaloncesto;
create database ligaBaloncesto;
use ligaBaloncesto;

create table equipo(
	idEquipo int primary key,
    nombreEquipo varchar(50),
    ciudad varchar(50),
    webOficial varchar(100),
    puntos int
);
create table jugador(
	idJugador int primary key,
    idCapitan int,
    foreign key (idCapitan) references jugador(idJugador),
    idEquipo int,
    foreign key (idEquipo) references equipo(idEquipo),
    nombre varchar(50),
    apellido varchar(50),
    posicion varchar(50),
    fechaAlta date,
    salarioBruto int,
    altura int
);
create table partido(
	elocal int,
    evisitante int,
    fecha date,
	resultado varchar(7),
    arbitro int,
    primary key(elocal, evisitante, fecha),
    foreign key(elocal) references equipo(idEquipo),
    foreign key(evisitante) references equipo(idEquipo)
);


-- primero inserto capitanes para que no me falle al referenciarlo con los demás jugadores 

INSERT INTO equipo(idEquipo, nombreEquipo, ciudad, webOficial, puntos) VALUES(101, "FC Barcelona Básquet", "Barcelona", "https://www.fcbarcelona.com", 10);
INSERT INTO equipo(idEquipo, nombreEquipo, ciudad, webOficial, puntos) VALUES(102, "Real Madrid", "Madrid", "https://www.realmadrid.com", 9);
INSERT INTO equipo(idEquipo, nombreEquipo, ciudad, webOficial, puntos) VALUES(103, "Valencia Basket Club", "Valencia", "https://www.valenciabasket.com", 11);
INSERT INTO equipo(idEquipo, nombreEquipo, ciudad, webOficial, puntos) VALUES(104, "Casademont Zaragoza", "Zaragoza", "https://www.casademontzgz.es", 24);
INSERT INTO equipo(idEquipo, nombreEquipo, ciudad, webOficial, puntos) VALUES(105, "Club Baloncesto Gran Canaria", "Las Palmas", "https://cbgrancanaria.net", 14);
INSERT INTO equipo(idEquipo, nombreEquipo, ciudad, webOficial, puntos) VALUES(106, "Saski Baskonia", "Vitoria", "https://www.baskonia.com", 22);

INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(1, 1, 105, "Alejandro", "ARAGON ESPINOZA", "Alero", "2025-10-12", 1800, 190);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(16, 16, 102, "Ana Belén", "RUEDA REINA", "Escolta", "2023-11-02", 2200, 165);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(17, 17, 101, "Fiorella Ruth", "ALBÚJAR ALBINO", "Alero", "2025-03-30", 2200, 160);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(4, 4, 104, "Gabriel", "FERNÁNDEZ CAÑADAS", "Escolta", "2023-04-01", 2200, 182);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(19, 19, 104, "Luz Adriana", "Perdomo", "Alero", "2025-05-19", 2200, 160);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(8, 8, 103, "Miguel Nicolás", "GÓMEZ PEARSON", "Escolta", "2024-02-27", 2200, 179);

INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(16, 3, 102, "Adonis David", "CARPIO ROMERO", "Base", "2024-03-01", 1700, 190);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(19, 20, 104, "Carlos", "Elvira", "Escolta", "2024-01-31", 1900, 170);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(8, 14, 103, "Daniel", "PARRA SEGOVIA", "Pivot", "2025-01-10", 2300, 174);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(17, 12, 101, "David", "MARTÍNEZ GALLEGO", "Escolta", "2025-03-31", 1900, 160);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(1, 13, 105, "David", "MORENO SORIANO", "Pivot", "2025-03-30", 2300, 170);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(1, 5, 105, "Hugo", "GARCÍA SALAZAR", "Alero", "2023-09-10", 1800, 172);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(4, 7, 104, "Inmaculada", "GIL ESCRIBANO", "Base", "2024-01-28", 1700, 165);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(4, 10, 104, "Jaime", "LIZARZA ARNANZ", "Pivot", "2024-11-21", 2300, 189);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(19, 15, 104, "Juan Antonio", "ROS FERNÁNDEZ", "Base", "2025-01-19", 1700, 175);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(1, 11, 105, "Luis Daniel", "LOPEZ MILICIA", "Base", "2024-04-07", 1700, 173);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(1, 18, 105, "Maria Pilar", "Martin Gomez", "Pivot", "2025-03-11", 2300, 160);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(17, 6, 101, "Stiv Brandon GAVIRIA RAMOS", "GARCÍA SALAZAR", "Pivot", "2023-11-29", 2300, 187);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(8, 2, 103, "Yeray", "ARIAS BETHENCOURT", "Pivot", "2024-09-02", 2300, 180);
INSERT INTO jugador(idCapitan, idJugador, idEquipo, nombre, apellido, posicion, fechaAlta, salarioBruto, altura) VALUES(16, 9, 102, "Zoe Mariel", "JASTREB", "Alero", "2023-10-30", 1800, 161);


INSERT INTO partido(elocal, evisitante, fecha, resultado, arbitro) VALUES(101, 102, "2025-10-04", "100-100", 4);
INSERT INTO partido(elocal, evisitante, fecha, resultado, arbitro) VALUES(102, 103, "2025-10-04", "90-91", 5);
INSERT INTO partido(elocal, evisitante, fecha, resultado, arbitro) VALUES(103, 104, "2025-10-11", "88-77", 6);
INSERT INTO partido(elocal, evisitante, fecha, resultado, arbitro) VALUES(101, 105, "2025-10-18", "66-78", 6);
INSERT INTO partido(elocal, evisitante, fecha, resultado, arbitro) VALUES(102, 104, "2025-10-25", "90-90", 7);
INSERT INTO partido(elocal, evisitante, fecha, resultado, arbitro) VALUES(103, 105, "2025-11-01", "79-93", 3);
INSERT INTO partido(elocal, evisitante, fecha, resultado, arbitro) VALUES(104, 105, "2025-11-08", "91-99", 2);
INSERT INTO partido(elocal, evisitante, fecha, resultado, arbitro) VALUES(105, 102, "2025-11-08", "90-66", 1);
INSERT INTO partido(elocal, evisitante, fecha, resultado, arbitro) VALUES(101, 104, "2025-11-15", "110-70", 2);
