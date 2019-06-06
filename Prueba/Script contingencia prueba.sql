USE PedidosP
GO

-- DESHABILITAR CONSTRAINTS DE CLIENTE, CABEZERAP Y DETALLEP
ALTER TABLE catalogo.Cliente NOCHECK CONSTRAINT ALL
ALTER TABLE movimiento.CabezeraP NOCHECK CONSTRAINT ALL
ALTER TABLE movimiento.DetalleP NOCHECK CONSTRAINT ALL

-- RESTAURAR ACTUALIZACI�N DE VALORES DEL CAMPO CODPED DE CABEZERAP Y DETALLEP
UPDATE movimiento.CabezeraP
SET codped = 'R' + SUBSTRING(codped,DATALENGTH(codped)-1,2)

UPDATE movimiento.DetalleP
SET codped = 'R' + SUBSTRING(codped,DATALENGTH(codped)-1,2)
GO

	-- CREAR TABLAS AUXILIARES PARA CABEZERAP Y DETALLEP
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

	-- INSERTAR VALORES DE LA TABLA CABEZERAP Y DETALLEP EN
	-- LAS TABLAS AUXILIARES CORRESPONDIENTES
INSERT INTO CabezeraPAux 
SELECT * FROM movimiento.CabezeraP

INSERT INTO DetallePAux
SELECT* FROM movimiento.DetalleP

	-- ELIMINAR VALORES DE LA TABLA CABEZERAP Y DETALLEP
DELETE FROM movimiento.CabezeraP
DELETE FROM movimiento.DetalleP

	-- REDUCIR TAMA�O DEL CAMPO CODPED DE CABEZERAP Y DETALLEP
ALTER TABLE movimiento.CabezeraP
ALTER COLUMN codped CHAR(3)

ALTER TABLE movimiento.DetalleP
ALTER COLUMN codped CHAR(3)
GO

	-- MOVER DATOS DE TALBAS AUXILIARES A CABEZERAP Y DETALLEP
	-- SEG�N CORRESPONDA
INSERT INTO movimiento.DetalleP
SELECT * FROM DetallePAux

INSERT INTO movimiento.CabezeraP
SELECT * FROM CabezeraPAux