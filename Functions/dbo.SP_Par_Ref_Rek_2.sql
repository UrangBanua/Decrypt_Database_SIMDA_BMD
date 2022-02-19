USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/****** Object : SP_Par_Ref_Rek_2  First Created : 15/03/2006 10:00:00 By [Herry - 0852 1821 9951] ******/

CREATE PROCEDURE [dbo].[SP_Par_Ref_Rek_2] @Kd_Rek_1 varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Rek_1 varchar(3)
SET @Kd_Rek_1 = '4'
*/
	SELECT Kd_Rek_1, Kd_Rek_2, Nm_Rek_2
	FROM Ref_Rek_2
	WHERE Kd_Rek_1= @Kd_Rek_1



GO
