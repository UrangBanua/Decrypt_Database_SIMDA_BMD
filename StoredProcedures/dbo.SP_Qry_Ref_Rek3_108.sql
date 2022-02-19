USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/* object : SP_Qry_Ref_Rek3_108  first created : 06/02/2019 10:00:00*/
CREATE PROCEDURE [dbo].[SP_Qry_Ref_Rek3_108]  @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3)
WITH ENCRYPTION
AS

/*
DECLARE @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3)
SET @Kd_Aset  = '1'
SET @Kd_Aset0 = '3' 
SET @Kd_Aset1 = '4' 
SET @Kd_Aset2 = '1'

1,3,4,1 = Pengadaan
*/

IF @Kd_Aset1 = '1'
BEGIN
	SELECT Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Nm_Aset3
	FROM Ref_Rek3_108
	WHERE Kd_Aset=@Kd_Aset AND Kd_Aset0=@Kd_Aset0 AND Kd_Aset1=@Kd_Aset1 AND Kd_Aset2=@Kd_Aset2
END 
ELSE IF @Kd_Aset1 = '2'
BEGIN
	SELECT Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Nm_Aset3
	FROM Ref_Rek3_108
	WHERE Kd_Aset=@Kd_Aset AND Kd_Aset0=@Kd_Aset0 AND Kd_Aset1=@Kd_Aset1
END
ELSE IF (@Kd_Aset = '1') AND (@Kd_Aset0 = '5') AND (@Kd_Aset1 = '3') AND (@Kd_Aset2 = '1')
BEGIN
	SELECT Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Nm_Aset3
	FROM Ref_Rek3_108
	WHERE Kd_Aset=@Kd_Aset AND Kd_Aset0=@Kd_Aset0 AND Kd_Aset1=@Kd_Aset1 AND Kd_Aset2=@Kd_Aset2
END
ELSE IF (@Kd_Aset = '1') AND (@Kd_Aset0 = '3') AND (@Kd_Aset1 = '4') AND (@Kd_Aset2 = '1') /*Pengadaan*/
BEGIN
	SELECT Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Nm_Aset3
	FROM Ref_Rek3_108
	WHERE Kd_Aset LIKE @Kd_Aset AND Kd_Aset0 LIKE @Kd_Aset0 AND Kd_Aset1 < 6
END
ELSE
BEGIN
	SELECT Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Nm_Aset3
	FROM Ref_Rek3_108
	WHERE Kd_Aset LIKE @Kd_Aset AND Kd_Aset0 LIKE @Kd_Aset0 AND Kd_Aset1 LIKE @Kd_Aset1
END




GO
