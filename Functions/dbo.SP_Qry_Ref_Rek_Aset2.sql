USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/****** Object : SP_Qry_Ref_Rek_Aset2  First Created : 15/03/2006 10:00:00 By [Herry - 0852 1821 9951] ******/

CREATE  PROCEDURE [dbo].[SP_Qry_Ref_Rek_Aset2] @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3)
SET @Kd_Aset1 = '4' 
SET @Kd_Aset2 = '4' 
*/
	SELECT Kd_Aset1, Kd_Aset2, Nm_Aset2
	FROM Ref_Rek_Aset2
	WHERE (Kd_Aset1 = @Kd_Aset1) AND (Kd_Aset2 LIKE @Kd_Aset2)





GO
