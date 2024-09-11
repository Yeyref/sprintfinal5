-- Creación del usuario con privilegios
CREATE USER 'usuario_tlv'@'localhost' IDENTIFIED BY 'contraseña_segura';

GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT ON te_lo_vendo.* TO 'usuario_tlv'@'localhost';

FLUSH PRIVILEGES;

-- Eliminación de tablas si ya existen (para evitar errores al ejecutar el script varias veces)
DROP TABLE IF EXISTS proveedores;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS productos;

-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS te_lo_vendo;
USE te_lo_vendo;

-- Creación de las tablas
CREATE TABLE proveedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_representante VARCHAR(100),
    nombre_corporativo VARCHAR(100),
    telefono1 VARCHAR(20),
    nombre_contacto1 VARCHAR(50),
    telefono2 VARCHAR(20),
    nombre_contacto2 VARCHAR(50),
    categoria VARCHAR(50),
    correo_electronico VARCHAR(100)
);

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    direccion VARCHAR(255)
);

CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10, 2),
    categoria VARCHAR(50),
    color VARCHAR(50),
    stock INT,
    proveedor_id INT,
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)
);

-- Inserción de datos en las tablas
-- Insertar proveedores
INSERT INTO proveedores (nombre_representante, nombre_corporativo, telefono1, nombre_contacto1, telefono2, nombre_contacto2, categoria, correo_electronico)
VALUES
    ('Juan Pérez', 'ElectroMundo', '123456789', 'Ana Ruiz', '987654321', 'Luis Gómez', 'Electrónica', 'contacto@electromundo.com'),
    ('Laura Fernández', 'TecnoPlus', '234567890', 'Carlos López', '876543210', 'María Martínez', 'Electrónica', 'info@tecnoplus.com'),
    ('Pedro Gómez', 'CompuStore', '345678901', 'Sandra Pérez', '765432109', 'Jorge Fernández', 'Computación', 'ventas@compustore.com'),
    ('Sofía Martínez', 'GadgetWorld', '456789012', 'Luis García', '654321098', 'Elena Sánchez', 'Electrónica', 'sofia@gadgetworld.com'),
    ('Carlos López', 'SmartTech', '567890123', 'Marta Rodríguez', '543210987', 'David Álvarez', 'Tecnología', 'carlos@smarttech.com');

-- Insertar clientes
INSERT INTO clientes (nombre, apellido, direccion)
VALUES
    ('Pedro', 'Rojas', 'Av. Siempre Viva 123'),
    ('María', 'Gómez', 'Calle Falsa 456'),
    ('Luis', 'Pérez', 'Paseo del Prado 789'),
    ('Ana', 'Torres', 'Avenida Libertador 321'),
    ('Carlos', 'Mendoza', 'Plaza Mayor 654');

-- Insertar productos
INSERT INTO productos (nombre, precio, categoria, color, stock, proveedor_id)
VALUES
    ('Laptop Gaming', 1200.00, 'Electrónica', 'Negro', 30, 1),
    ('Smartphone X', 800.00, 'Electrónica', 'Azul', 50, 2),
    ('Monitor LED', 250.00, 'Computación', 'Blanco', 40, 3),
    ('Teclado Mecánico', 100.00, 'Computación', 'Rojo', 25, 3),
    ('Auriculares Bluetooth', 150.00, 'Electrónica', 'Negro', 35, 4),
    ('Reloj Inteligente', 200.00, 'Electrónica', 'Gris', 20, 4),
    ('Cámara de Seguridad', 180.00, 'Electrónica', 'Blanco', 45, 5),
    ('Tablet Pro', 600.00, 'Electrónica', 'Plata', 15, 5),
    ('Disco Duro Externo', 120.00, 'Computación', 'Negro', 60, 3),
    ('Estación de Carga', 75.00, 'Electrónica', 'Blanco', 50, 2);

-- Consultas SQL segun los requerimientos...

-- Categoría de productos que más se repite
SELECT categoria, COUNT(*) AS cantidad
FROM productos
GROUP BY categoria
ORDER BY cantidad DESC
LIMIT 1;

-- Productos con mayor stock
SELECT nombre, stock
FROM productos
ORDER BY stock DESC
LIMIT 5;

-- Color de producto más común
SELECT color, COUNT(*) AS cantidad
FROM productos
GROUP BY color
ORDER BY cantidad DESC
LIMIT 1;

-- Proveedores con menor stock de productos
SELECT p.nombre_corporativo, COUNT(pr.id) AS cantidad_productos
FROM proveedores p
JOIN productos pr ON p.id = pr.proveedor_id
GROUP BY p.id
ORDER BY cantidad_productos ASC
LIMIT 1;

-- Actualizar la categoría de productos más popular
UPDATE productos
SET categoria = 'Electrónica y computación'
WHERE categoria = (
    SELECT categoria
    FROM (
        SELECT categoria, COUNT(*) AS cantidad
        FROM productos
        GROUP BY categoria
        ORDER BY cantidad DESC
        LIMIT 1
    ) AS subconsulta
);

