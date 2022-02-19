USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[SP_Qry_Ref_Rek_Aset1] @Kd_Aset1 varchar(1)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Aset1 varchar(1)
SET @Kd_Aset1 = '4' 
*/
	SELECT Kd_Aset1, Nm_Aset1
	FROM Ref_Rek_Aset1
	WHERE Kd_Aset1 LIKE @Kd_Aset1
GO
