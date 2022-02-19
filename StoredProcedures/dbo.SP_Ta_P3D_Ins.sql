USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Ta_P3D - 01122016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE [SP_Ta_P3D_Ins] @No_BAST varchar(50), @Tanggal varchar(8), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Nm_Kab_Kota varchar(100)
WITH ENCRYPTION
AS
	
	IF NOT EXISTS (SELECT Nm_Kab_Kota FROM Ta_P3D WHERE (No_BAST = @No_BAST))
	BEGIN 
		INSERT INTO Ta_P3D (No_BAST, Tanggal, Kd_Prov, Kd_Kab_Kota, Nm_Kab_Kota)
		SELECT @No_BAST, @Tanggal, @Kd_Prov, @Kd_Kab_Kota, @Nm_Kab_Kota
	END 

	--ELSE
	--BEGIN
	--	UPDATE Ta_P3D SET Tanggal = @Tanggal, Kd_Prov = @Kd_Prov, Kd_Kab_Kota = @Kd_Kab_Kota, Nm_Kab_Kota = @Nm_Kab_Kota
	--	WHERE No_BAST = @No_BAST
	--END


GO
