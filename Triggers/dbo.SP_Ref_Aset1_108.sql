USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/* object : SP_Ref_Aset1_108  first created : 15/11/2018 10:00:00 by [hs - 0816 81 1821] */
CREATE PROCEDURE [dbo].[SP_Ref_Aset1_108]  @Kd_Aset varchar(3), @Kd_Aset0 varchar(3)
WITH ENCRYPTION
AS
	SELECT Kd_Aset, Kd_Aset0, Kd_Aset1, Nm_Aset1
	FROM Ref_Rek1_108
	WHERE Kd_Aset=@Kd_Aset AND Kd_Aset0=@Kd_Aset0

GO
