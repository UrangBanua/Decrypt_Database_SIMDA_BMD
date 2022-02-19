USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO




/****** Object:  SP_Par_Pemda  First Created : 13/03/2006 16:24:54   By [Herry - 0852 1821 9951] ******/

CREATE PROCEDURE [dbo].[SP_Ta_Pemda] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4)
SET @Tahun = '2005'
*/
	SELECT Tahun, Kd_Prov, Kd_Kab_Kota, Nm_PimpDaerah, Jab_PimpDaerah, Nm_Sekda, Nip_Sekda, Jbt_Sekda,
		Nm_Ka_Keu, Nip_Ka_Keu, Jbt_Ka_Keu, Nm_Ka_Umum, Nip_Ka_Umum, Jbt_Ka_Umum
	FROM Ta_Pemda
	WHERE Tahun = @Tahun AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota





GO
