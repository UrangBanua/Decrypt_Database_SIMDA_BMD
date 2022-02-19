USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO




/*** SP_BatalHapus - 11112015 - Modified for Ver 2.0.7 [demi@simda.id] ***/

CREATE PROCEDURE SP_BatalHapus @IDPemda varchar(17), @Kd_ID varchar(3), @KIB varchar(1)
WITH ENCRYPTION
AS

/*
DECLARE @IDPemda varchar(17), @Kd_ID varchar(3), @KIB varchar(1)
SET @IDPemda = '13'
SET @KIB = 'A'
*/
		
IF @KIB = 'A' 
BEGIN
	UPDATE Ta_KIB_A 
	SET Kd_Hapus= 0	
	WHERE IDPemda = @IDPemda

	DELETE Ta_KIBAHapus WHERE IDPemda = @IDPemda
END

IF @KIB = 'B' 
BEGIN
	UPDATE Ta_KIB_B 
	SET Kd_Hapus= 0	
	WHERE IDPemda = @IDPemda

	DELETE Ta_KIBBHapus WHERE IDPemda = @IDPemda	
END

IF @KIB = 'C' 
BEGIN
	UPDATE Ta_KIB_C 
	SET Kd_Hapus= 0	
	WHERE IDPemda = @IDPemda

	DELETE Ta_KIBCHapus WHERE IDPemda = @IDPemda		
END

IF @KIB = 'D' 
BEGIN
	UPDATE Ta_KIB_D 
	SET Kd_Hapus= 0	
	WHERE IDPemda = @IDPemda

	DELETE Ta_KIBDHapus WHERE IDPemda = @IDPemda	
END

IF @KIB = 'E' 
BEGIN
	UPDATE Ta_KIB_E 
	SET Kd_Hapus= 0	
	WHERE IDPemda = @IDPemda

	DELETE Ta_KIBEHapus WHERE IDPemda = @IDPemda	
END

IF @KIB = 'L' 
BEGIN
	UPDATE Ta_Lainnya 
	SET Kd_Hapus= 0	
	WHERE IDPemda = @IDPemda

	DELETE Ta_LainnyaHapus WHERE IDPemda = @IDPemda	
END






GO
