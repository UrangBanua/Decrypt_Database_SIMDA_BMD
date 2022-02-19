USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_KA2] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3)
WITH ENCRYPTION
AS
	SELECT Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Aset1, Kd_Aset2, Kd_Aset3,
		'0' + CONVERT(varchar, Kd_Aset1) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset3), 2) AS Kd_Gab
	FROM Ta_KA2
	WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota)





GO
