USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/* object : SP_Ref_Aset2_108  first created : 15/11/2018 10:00:00 by [hs - 0816 81 1821] */
CREATE PROCEDURE [dbo].[SP_Ref_Aset2_108] @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3)
SET @Kd_Aset = '4'
SET @Kd_Aset0 = '4'
SET @Kd_Aset1 = '4'
*/
	SELECT Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Nm_Aset2
	FROM Ref_Rek2_108
	WHERE Kd_Aset=@Kd_Aset AND Kd_Aset0=@Kd_Aset0 AND Kd_Aset1=@Kd_Aset1

GO
