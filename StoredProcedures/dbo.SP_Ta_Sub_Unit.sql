USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/****** Object : SP_Ta_Sub_Unit  First Created : 15/03/2006 10:00:00 By [Herry - 0852 1821 9951] ******/

CREATE PROCEDURE [dbo].[SP_Ta_Sub_Unit] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3)
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
	SELECT Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Alamat
	FROM Ta_Sub_Unit
	WHERE Tahun = @Tahun AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota
		AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub





GO
