USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ref_Rek_Penyusutan] @Nm_Aset3 varchar(50)
WITH ENCRYPTION
AS
	SELECT *
	FROM Ref_Rek_Aset3
	WHERE (Kd_Aset1 NOT IN (1, 6))
		AND (Nm_Aset3 LIKE '%' + @Nm_Aset3 + '%')





GO
