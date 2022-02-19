USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/****** Object : SP_Par_Ref_Rek_Aset4  First Created : 15/03/2006 10:00:00 By [Herry - 0852 1821 9951] ******/
CREATE PROCEDURE [dbo].[SP_Par_Ref_Rek_Aset4] @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Aset1 varchar(3)
SET @Kd_Aset1 = '4'
*/
	SELECT Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Nm_Aset4
	FROM Ref_Rek_Aset4
	WHERE Kd_Aset1=@Kd_Aset1 AND Kd_Aset2=@Kd_Aset2 AND Kd_Aset3=@Kd_Aset3






GO
