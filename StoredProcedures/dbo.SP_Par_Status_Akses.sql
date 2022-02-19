USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Par_Status_Akses - 17022017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Par_Status_Akses
WITH ENCRYPTION
AS

	SELECT CONVERT(INT,A.Kode) AS Kode, A.Uraian
	FROM
	(			
		SELECT '0' AS Kode, 'Aktif' AS Uraian
		UNION ALL
		SELECT '1' AS Kode, 'Tidak Aktif' AS Uraian
		
	) A




GO
