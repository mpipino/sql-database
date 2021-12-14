--CREATE TABLE nombres(id int identity(1,1), nombre varchar(100))

alter PROCEDURE sProc_ins_Nombres (@inicio int, @cantidad int)
AS
--DECLARE @cont int
--SET @cont=1

IF @INICIO IS NULL OR @inicio > @cantidad
	BEGIN
		PRINT 'EL VALOR DEL PARAMETRO INICIO ES INCORRECTO'
		RETURN
	END
ELSE
	BEGIN
		PRINT 'INICIO DEL PROCESO:' + CONVERT(VARCHAR,GETDATE())
		PRINT ''
	END

WHILE @inicio <= @cantidad
BEGIN
	BEGIN			
			PRINT 'PROCESANDO REGISTRO NUMERO ' + CONVERT(varchar,@inicio)
			INSERT INTO nombres VALUES ('Juan ' + CONVERT(varchar,@inicio))
			SET @inicio = @inicio + 1						
			PRINT ''
	END		
END
PRINT ''
PRINT 'PROCESO FINALIZADO:' + CONVERT(VARCHAR,GETDATE())
	
