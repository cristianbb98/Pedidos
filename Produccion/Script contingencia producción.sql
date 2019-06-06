USE Pedidos
GO

-- DESHABILITAR CONSTRAINTS DE CLIENTE, CABEZERAP Y DETALLEP
ALTER TABLE catalogo.Cliente DROP CONSTRAINT pk_Cliente 
ALTER TABLE movimiento.CabezeraP DROP CONSTRAINT pk_CabezeraP 
ALTER TABLE movimiento.DetalleP DROP CONSTRAINT pk_DetalleP
ALTER TABLE catalogo.Cliente NOCHECK CONSTRAINT ALL
ALTER TABLE movimiento.CabezeraP NOCHECK CONSTRAINT ALL
ALTER TABLE movimiento.DetalleP NOCHECK CONSTRAINT ALL

-- RESTAURAR ACTUALIZACIÓN DE VALORES DEL CAMPO CODPED Y CODCLI
-- DE CABEZERAP, DETALLEP Y CLIENTE
UPDATE movimiento.CabezeraP
SET codped = 'R' + SUBSTRING(TRIM(codped),DATALENGTH(TRIM(codped))-1,2)
UPDATE movimiento.DetalleP
SET codped = 'R' + SUBSTRING(TRIM(codped),DATALENGTH(TRIM(codped))-1,2)
GO
UPDATE catalogo.Cliente
SET codcli = 'C' + SUBSTRING(TRIM(codcli),DATALENGTH(TRIM(codcli))-1,2)
UPDATE catalogo.Cliente
SET garante = 'C' + SUBSTRING(TRIM(garante),DATALENGTH(TRIM(garante))-1,2)
UPDATE movimiento.CabezeraP
SET codcli = 'C' + SUBSTRING(TRIM(codcli),DATALENGTH(TRIM(codcli))-1,2)
GO


-- CREAR TABLAS AUXILIARES PARA CABEZERAP, DETALLEP Y PEDIDOS
CREATE TABLE CabezeraPAux(
	[codped] [char](3) NOT NULL,
	[fecha] [datetime] NULL,
	[montototal] [numeric](10, 2) NULL,
	[codcli] [char](3) NOT NULL)

CREATE TABLE DetallePAux(
	[numlinea] [tinyint] NOT NULL,
	[preciou] [numeric](7, 2) NULL,
	[cantidad] [smallint] NULL,
	[codped] [char](3) NOT NULL,
	[codpro] [char](3) NOT NULL)

CREATE TABLE ClienteAux(
	[codcli] [char](3) NOT NULL,
	[codciu] [char](3) NOT NULL,
	[garante] [char](3) NOT NULL,
	[direnvio] [varchar](80) NULL,
	[credito] [numeric](7, 2) NULL,
	[descuento] [numeric](5, 2) NULL)

-- INSERTAR VALORES DE LA TABLA CABEZERAP, DETALLEP Y CLIENTE
-- EN LAS TABLAS AUXILIARES CORRESPONDIENTES
INSERT INTO CabezeraPAux 
SELECT * FROM movimiento.CabezeraP

INSERT INTO DetallePAux
SELECT * FROM movimiento.DetalleP

INSERT INTO ClienteAux
SELECT * FROM catalogo.Cliente

-- ELIMINAR VALORES DE LA TABLA CABEZERAP, DETALLEP Y CLIENTE
DELETE FROM movimiento.CabezeraP
DELETE FROM movimiento.DetalleP
DELETE FROM catalogo.Cliente

-- REDUCIR TAMAÑO DEL CAMPO CODPED DE CABEZERAP, DETALLEP Y CLIENTE
ALTER TABLE movimiento.CabezeraP
ALTER COLUMN codped CHAR(3) NOT NULL

ALTER TABLE movimiento.DetalleP
ALTER COLUMN codped CHAR(3) NOT NULL
GO

ALTER TABLE catalogo.Cliente
ALTER COLUMN codcli CHAR(3) NOT NULL

ALTER TABLE catalogo.Cliente
ALTER COLUMN garante CHAR(3) NOT NULL

ALTER TABLE movimiento.CabezeraP
ALTER COLUMN codcli CHAR(3) NOT NULL
GO

-- MOVER DATOS DE TABLAS AUXILIARES A CABEZERAP, DETALLEP Y CLIENTE
-- SEGÚN CORRESPONDA Y LIMPIARLAS
INSERT INTO movimiento.DetalleP
SELECT * FROM DetallePAux
DELETE FROM DetallePAux

INSERT INTO movimiento.CabezeraP
SELECT * FROM CabezeraPAux
DELETE FROM CabezeraPAux

INSERT INTO catalogo.Cliente
SELECT * FROM ClienteAux
DELETE FROM ClienteAux

-- ELIMINAR TABLAS AUXILIARES
DROP TABLE ClienteAux
DROP TABLE CabezeraPAux
DROP TABLE DetallePAux


-- HABILITAR Y CONSTRAINTS
ALTER TABLE catalogo.Cliente 
ADD CONSTRAINT pk_Cliente PRIMARY KEY CLUSTERED (codcli) 

ALTER TABLE movimiento.CabezeraP
ADD CONSTRAINT pk_CabezeraP PRIMARY KEY CLUSTERED (codped)  

ALTER TABLE movimiento.DetalleP
ADD CONSTRAINT pk_DetalleP PRIMARY KEY CLUSTERED (numlinea, codped)

ALTER TABLE catalogo.Cliente CHECK CONSTRAINT ALL
ALTER TABLE movimiento.CabezeraP CHECK CONSTRAINT ALL
ALTER TABLE movimiento.DetalleP CHECK CONSTRAINT ALL