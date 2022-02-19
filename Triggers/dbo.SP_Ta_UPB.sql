USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[SP_Ta_UPB] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10)
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
	SELECT Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB,
		Nm_Pimpinan, Nip_Pimpinan, Jbt_Pimpinan, Nm_Pengurus, Nip_Pengurus, Jbt_Pengurus, Nm_Penyimpan, Nip_Penyimpan, Jbt_Penyimpan
	FROM Ta_UPB
	WHERE Tahun = @Tahun AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota 
		AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB





GO
