CREATE DATABASE IF NOT EXISTS FIXOSA_DAST; -- Cree la base de datos si no existe otra igual 
USE FIXOSA_DAST; -- Usar la base de datos que cree

-- Cree la tabla "direccion" para almacenar la dirección de los clientes
CREATE TABLE direccion (
    idDireccion INT AUTO_INCREMENT PRIMARY KEY, -- Primary key para cada direccion (autoincrementable)
    Direccion VARCHAR(45) NOT NULL,				-- Direccion del cliente
    Ciudad VARCHAR(45) NOT NULL,				-- Ciudad de la direccion
    Pais VARCHAR(45) NOT NULL					-- País de la dirección
);

-- Inserte direcciones cualquiera para los clientes
INSERT INTO direccion (Direccion, Ciudad, Pais) VALUES
('Av Central', 'Guatemala', 'Guatemala'),
('Calle 5', 'Quetzaltenango', 'Guatemala'),
('Boulevard Norte', 'Chiquimula', 'Guatemala');



-- Cree la tabla clientes para almacenar la información de los clientes
CREATE TABLE cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,													-- Primary key para cada cliente (autoincrementable)
    Nombre VARCHAR(45) NOT NULL,																-- Nombre del cliente
    Apellido VARCHAR(45) NOT NULL,																-- Apellido del cliente
    Edad INT NOT NULL,																			-- Edad del cliente
    Direccion_idDireccion INT NOT NULL,															-- Relación con la tabla "direccion"
    FOREIGN KEY (Direccion_idDireccion) REFERENCES direccion(idDireccion) ON DELETE CASCADE
    -- Con el "ON DELETE CASCADE" Si se elimina una dirección, también se eliminarán los clientes relacionados
);

-- Inserte datos de cualquiera en la tabla cliente
INSERT INTO cliente (Nombre, Apellido, Edad, Direccion_idDireccion) VALUES
('Juliana', 'Ramírez', 25, 1),
('Carlos', 'Mejía', 30, 2),
('María', 'López', 22, 3);



-- Cree la tabla "categoria" para clasificar las películas
CREATE TABLE categoria (
    idCategoria INT AUTO_INCREMENT PRIMARY KEY,		-- Primary Key para cada categoria (autoincrementable)
    Nombre VARCHAR(45) NOT NULL						-- Nombre de la categoría 
);

-- Inserte algunas categorias para las peliculas
INSERT INTO categoria (Nombre) VALUES
('Acción'),
('Comedia'),
('Documental');



-- Cree la tabla "peliculas" para guardar la información de cada película
CREATE TABLE peliculas (
    idPeliculas INT AUTO_INCREMENT PRIMARY KEY,													-- Primary Key (autoincrementable)
    Nombre VARCHAR(45) NOT NULL,																-- Nombre de la película
    Duracion INT NOT NULL,																		-- Duración en minutos
    Descripcion TEXT NOT NULL,																	-- Descripción de la película
    Año INT NOT NULL,																			-- Año de estreno
    Categoria_idCategoria INT NOT NULL,															-- Relación con la tabla "categoria"
    FOREIGN KEY (Categoria_idCategoria) REFERENCES categoria(idCategoria) ON DELETE CASCADE
	-- Con el "ON DELETE CASCADE" Si se elimina una categoría, también se eliminan las películas asociadas
);

-- Inserte peliculas de ejemplo y sus datos 
INSERT INTO peliculas (Nombre, Duracion, Descripcion, Año, Categoria_idCategoria) VALUES
('POKEMON1', 95, 'Película animada de Pokémon', 2015, 1),
('La Risa Infinita', 120, 'Comedia para toda la familia', 2020, 2),
('Planeta Tierra', 60, 'Documental sobre la naturaleza', 2018, 3);



-- Cree la tabla "inventario" para manejar la disponibilidad de las películas
CREATE TABLE inventario (
    idCopiasPeliculas INT AUTO_INCREMENT PRIMARY KEY,											-- Primary Key (autoincrementable)
    Peliculas_idPeliculas INT NOT NULL,															-- Relación con la tabla "peliculas"
    Disponible TINYINT NOT NULL,																-- El TinyInt funciona como bits, 1 = si; 0 = no
    FOREIGN KEY (Peliculas_idPeliculas) REFERENCES peliculas(idPeliculas) ON DELETE CASCADE
);

-- Inserte datos en la tabla "inventario"
INSERT INTO inventario (Peliculas_idPeliculas, Disponible) VALUES
(1, 1), 	-- POKEMON1 disponible
(2, 0), 	-- La Risa Infinita no disponible
(3, 1); 	-- Planeta Tierra disponible (los 3 segun TinyInt)



-- Cree la tabla "renta" para registrar las películas rentadas por los clientes
CREATE TABLE renta (
    idRenta INT AUTO_INCREMENT PRIMARY KEY,																	-- Primary Key (autoincrementable)
    Fecha_Renta DATE NOT NULL,																				-- Fecha en que se rentó la película
    Fecha_Entrega DATE NOT NULL,																			-- Fecha en que debe entregarse
    Inventario_idCopiasPeliculas INT NOT NULL,																-- Relación con el inventario
    Cliente_idCliente INT NOT NULL,																			-- Relación con el cliente
    FOREIGN KEY (Inventario_idCopiasPeliculas) REFERENCES inventario(idCopiasPeliculas) ON DELETE CASCADE,	
    FOREIGN KEY (Cliente_idCliente) REFERENCES cliente(idCliente) ON DELETE CASCADE
    -- Con el "ON DELETE CASCADE" en L96 si se elimina una copia de película del inventario, también se eliminan las rentas asociadas
    -- Con el "ON DELETE CASCADE" en L97 si se elimina un cliente, también se eliminan automáticamente sus rentas
);

-- Inserte datos de rentas de ejemplo
INSERT INTO renta (Fecha_Renta, Fecha_Entrega, Inventario_idCopiasPeliculas, Cliente_idCliente) VALUES
('2025-04-01', '2025-04-07', 1, 1),
('2025-04-05', '2025-04-10', 2, 2),
('2025-04-07', '2025-04-15', 3, 3);



-- Cree la tabla "empleado" para almacenar información de los empleados (parte del paso 7 que pide la adicion de 2 tablas)
CREATE TABLE empleado (
    idEmpleado INT AUTO_INCREMENT PRIMARY KEY,		-- Primary key (autoincrementable)
    Nombre VARCHAR(45) NOT NULL,					-- Nombre del empleado
    Puesto VARCHAR(45) NOT NULL						-- Puesto que ocupa en el trabajo
);

-- Inserte datos cualquiera de empleados
INSERT INTO empleado (Nombre, Puesto) VALUES
('Ana Torres', 'Atención al cliente'),
('Luis Pérez', 'Cajero');



-- Cree la tabla "renta_empleado" para vincular cada renta con el empleado que la atendió
CREATE TABLE renta_empleado (
    idRentaEmpleado INT AUTO_INCREMENT PRIMARY KEY,											-- Primary key (autoincrementable)
    Renta_idRenta INT NOT NULL,																-- Relación con la tabla "renta"
    Empleado_idEmpleado INT NOT NULL,														-- Relación con la tabla "empleado"
    FOREIGN KEY (Renta_idRenta) REFERENCES renta(idRenta) ON DELETE CASCADE,
    FOREIGN KEY (Empleado_idEmpleado) REFERENCES empleado(idEmpleado) ON DELETE CASCADE
    -- Con el "ON DELETE CASCADE" en L129 si se elimina una renta, también se eliminan automáticamente los registros relacionados en esta tabla
    -- Con el "ON DELETE CASCADE" en L130 si se elimina un empleado, también se eliminan los registros asociados en esta tabla
);

-- Inserte datos cualquiera en la tabla renta_empleado
INSERT INTO renta_empleado (Renta_idRenta, Empleado_idEmpleado) VALUES
(1, 1),
(2, 2),
(3, 1);



-- Cree las consultas para ver el contenido del número de tablas que pedía (5) y las cuales yo considere principales
SELECT * FROM direccion;
SELECT * FROM cliente;
SELECT * FROM peliculas;
SELECT * FROM inventario;
SELECT * FROM renta;

-- Segun lo pedido busque nombre = Juliana en las tablas que tuvieran campo
SELECT * FROM cliente
WHERE Nombre = 'Juliana';
-- Estas consultas probablemente no devolverán nada porque 'Juliana' no es una película ni una categoría, pero "nombre" esta presente en las columnas 
SELECT * FROM peliculas
WHERE Nombre = 'Juliana';
SELECT * FROM categoria
WHERE Nombre = 'Juliana';

-- Eliminar una película específica (POKEMON1) segun lo solicitado
DELETE FROM peliculas
WHERE Nombre = 'POKEMON1';

-- Mostrar categorías ordenadas alfabéticamente
SELECT * FROM categoria
ORDER BY Nombre ASC;

-- Mostrar películas ordenadas por año de forma descendente
SELECT * FROM peliculas
ORDER BY Año DESC;