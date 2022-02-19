USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_Par_Penyusutan]
WITH ENCRYPTION
AS
	SELECT Tahun, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Metode, Umur, ThnPenyusutan,
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84,
		'0' + CONVERT(varchar, Kd_Aset1) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset4), 2) AS Kd_Gab,
		CONVERT(varchar, Kd_Aset8) + '.' + RIGHT(CONVERT(varchar, Kd_Aset80), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset81), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset82), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset83), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset84), 2) AS Kd_Gab_108
	FROM Ref_Penyusutan
	ORDER BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84
GO
