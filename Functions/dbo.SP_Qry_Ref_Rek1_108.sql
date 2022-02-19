USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/* object : SP_Qry_Ref_Rek1_108  first created : 15/11/2018 10:00:00 by [hs - 0816 81 1821] */
CREATE PROCEDURE [dbo].[SP_Qry_Ref_Rek1_108]  @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3)
WITH ENCRYPTION
AS
	
	IF ISNULL(@Kd_Aset1, '') = '' SET @Kd_Aset1 = '%'

	IF ((@Kd_Aset = '1') AND (@Kd_Aset0 = '3') AND (@Kd_Aset1 = '9')) /*Parameter Penyusutan*/
	BEGIN
		SELECT Kd_Aset, Kd_Aset0, Kd_Aset1, Nm_Aset1
		FROM Ref_Rek1_108
		WHERE Kd_Aset=@Kd_Aset AND Kd_Aset0 IN (3)
		UNION ALL
		SELECT Kd_Aset, Kd_Aset0, Kd_Aset1, Nm_Aset1
		FROM Ref_Rek1_108
		WHERE Kd_Aset=@Kd_Aset AND Kd_Aset0 IN (5) AND Kd_Aset1 = 3
	END
	ELSE
	BEGIN
		SELECT Kd_Aset, Kd_Aset0, Kd_Aset1, Nm_Aset1
		FROM Ref_Rek1_108
		WHERE Kd_Aset=@Kd_Aset AND Kd_Aset0=@Kd_Aset0 AND Kd_Aset1 LIKE @Kd_Aset1
	END

GO
