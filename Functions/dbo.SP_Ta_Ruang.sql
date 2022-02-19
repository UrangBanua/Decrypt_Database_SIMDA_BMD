USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_Ruang] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Urusan varchar(1), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3)
SET @Tahun     = '' 
SET @Kd_Urusan = ''
SET @Kd_Bidang = '' 
SET @Kd_Unit   = '' 
SET @Kd_Sub    = ''
*/
	SELECT Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Ruang, Nm_Ruang,
		Nm_Pngjwb, Nip_Pngjwb, Jbt_Pngjwb, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, 
		No_Register, Kd_Pemilik
	FROM Ta_Ruang
	WHERE Tahun = @Tahun AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota 
		AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB





GO
