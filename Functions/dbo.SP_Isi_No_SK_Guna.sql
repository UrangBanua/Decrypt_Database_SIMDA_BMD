USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[SP_Isi_No_SK_Guna] @Tahun varchar(4), @User_ID varchar(20)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4)
SET @TAHUN = '2010'
*/
	IF EXISTS(SELECT * FROM Ta_User_Satker WHERE User_ID = @User_ID)
	BEGIN
		SELECT B.No_SKGuna
		FROM Ta_Penghapusan_Rinc A INNER JOIN
			Ta_Penggunaan B ON A.Tahun = B.Tahun AND A.No_SK = B.No_SKGuna INNER JOIN
			Ta_User_Satker C ON A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub
		WHERE (B.Tahun = @Tahun) AND (C.User_ID = @User_ID)
		GROUP BY B.No_SKGuna
		ORDER BY B.No_SKGuna
	END
	ELSE
	BEGIN
		
		SELECT B.No_SKGuna
		FROM Ta_Penggunaan B
		WHERE (B.Tahun = @Tahun) 
		
		GROUP BY B.No_SKGuna
		ORDER BY B.No_SKGuna
	END





GO
