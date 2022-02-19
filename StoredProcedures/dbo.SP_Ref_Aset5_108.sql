USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/* object : SP_Ref_Aset5_108  first created : 15/11/2018 10:00:00 by [hs - 0816 81 1821] */
CREATE PROCEDURE [dbo].[SP_Ref_Aset5_108] @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Aset varchar(3), @Kd_Aset_0 varchar(3), @Kd_Aset_1 varchar(3), @Kd_Aset_2 varchar(3), @Kd_Aset_3 varchar(3), @Kd_Aset_4 varchar(3)
SET @Kd_Aset = '4'
SET @Kd_Aset0 = '4'
SET @Kd_Aset1 = '4'
SET @Kd_Aset3 = '4'
SET @Kd_Aset4 = '4'
*/
	SELECT Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Nm_Aset5
	FROM Ref_Rek5_108
	WHERE Kd_Aset=@Kd_Aset AND Kd_Aset0=@Kd_Aset0 AND Kd_Aset1=@Kd_Aset1 AND Kd_Aset2=@Kd_Aset2 AND Kd_Aset3=@Kd_Aset3 AND Kd_Aset4=@Kd_Aset4
             AND IDData = dbo.fn_KdLokasi5(Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5)
GO
