USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** SP_Ref_Map_Rekening - 11112015 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Ref_Map_Rekening
WITH ENCRYPTION
AS

	SELECT Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Rek_1, Kd_Rek_2, Kd_Rek_3, Kd_Rek_4,
		RIGHT('0' + CONVERT(varchar, Kd_Aset), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset0), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset1) , 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset2) , 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset3) , 2) AS Kd_Gab_1,
		CONVERT(varchar, Kd_Rek_1) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Rek_2), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Rek_3), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Rek_4), 2)  AS Kd_Gab_2
	FROM Ref_Map_Rekening




GO
