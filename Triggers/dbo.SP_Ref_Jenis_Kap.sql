USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Ref_Jenis_Kap - 08112016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Ref_Jenis_Kap
WITH ENCRYPTION
AS

	SELECT CONVERT(INT,A.Kode) AS Kode, A.Uraian
	FROM
	(			
		SELECT '1' AS Kode, 'Overhaul' AS Uraian
		UNION ALL
		SELECT '2' AS Kode, 'Renovasi' AS Uraian
	) A


GO
