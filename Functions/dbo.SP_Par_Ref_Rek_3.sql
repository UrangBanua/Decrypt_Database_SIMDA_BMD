USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/****** Object : SP_Par_Ref_Rek_3  First Created : 15/03/2006 10:00:00 By [Herry - 0852 1821 9951] ******/

CREATE PROCEDURE [dbo].[SP_Par_Ref_Rek_3] @Kd_Rek_1 varchar(3), @Kd_Rek_2 varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Rek_1 varchar(3)
SET @Kd_Rek_1 = '4'
*/
	SELECT Kd_Rek_1, Kd_Rek_2, Kd_Rek_3, Nm_Rek_3, SaldoNorm
	FROM Ref_Rek_3
	WHERE Kd_Rek_1=@Kd_Rek_1 AND Kd_Rek_2=@Kd_Rek_2





GO
