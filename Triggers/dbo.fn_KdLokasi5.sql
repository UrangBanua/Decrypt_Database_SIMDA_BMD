USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_KdLokasi5] (@K varchar(2), @K0 varchar(2), @K1 varchar(2), @K2 varchar(2), @K3 varchar(2), @K4 varchar(2), @K5 varchar(3)) 
RETURNS varchar(5)
WITH ENCRYPTION
AS 
BEGIN
	DECLARE @kdLokasi varchar(5), @N int, @N0 int, @N1 int, @N2 int, @N3 int, @N4 int, @N5 int 

	SET @N  = @K  + 1 
    	SET @N0 = @K0 + 1
    	SET @N1 = @K1 + 1
    	SET @N2 = @K2 + 1
    	SET @N3 = @K3 + 1
    	SET @N4 = @K4 + 1
    	SET @N5 = @K5 + 1
	
	IF @K  = 2 SET @N  = @K  * 2 
    	IF @K0 = 2 SET @N0 = @K0 * 2
    	IF @K1 = 2 SET @N1 = @K1 * 2
    	IF @K2 = 2 SET @N2 = @K2 * 2
    	IF @K3 = 2 SET @N3 = @K3 * 2
    	IF @K4 = 2 SET @N4 = @K4 * 2
    	IF @K5 = 2 SET @N5 = @K5 * 2

	IF @K  = 3 SET @N  = @K  * 3 
    	IF @K0 = 3 SET @N0 = @K0 * 3
    	IF @K1 = 3 SET @N1 = @K1 * 3
    	IF @K2 = 3 SET @N2 = @K2 * 3
    	IF @K3 = 3 SET @N3 = @K3 * 3
    	IF @K4 = 3 SET @N4 = @K4 * 3
    	IF @K5 = 3 SET @N5 = @K5 * 3

	SET @kdLokasi = Convert(varchar, ((@N5*@N5)+@N4))+Convert(varchar, ((@N5+@N4)*@N3)) + Convert(varchar, (@N1*@N5)) + Convert(varchar, (@N4+@N5))

	SET @kdLokasi = SubString(@kdLokasi,1,5)

	RETURN @kdLokasi
END

GO
