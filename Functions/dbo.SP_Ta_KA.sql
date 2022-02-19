USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_KA] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3)
WITH ENCRYPTION
AS
	SELECT Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Aset1, Kd_Aset2, Kd_Aset3, MinSatuan, MinTotal, Kd_KA,
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, 
		'0' + CONVERT(varchar, Kd_Aset1) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset3), 2) AS Kd_Gab,
		CONVERT(varchar, Kd_Aset8) + '.' + RIGHT(CONVERT(varchar, Kd_Aset80), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset81), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset82), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset83), 2) AS Kd_Gab_108
	FROM Ta_KA
	WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota)


GO
