USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[SP_Isi_No_SK_Hapus] @Tahun varchar(4), @User_ID varchar(20)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @User_ID varchar(20)
SET @TAHUN = '2009'
SET @User_Id = 'admin'
*/
	
	IF EXISTS(SELECT * FROM Ta_User_Satker WHERE User_ID = @User_ID)
	BEGIN
		SELECT B.No_SK
		FROM Ta_Penghapusan_Rinc A INNER JOIN
			Ta_Penghapusan B ON A.Tahun = B.Tahun AND A.No_SK = B.No_SK INNER JOIN
			Ta_User_Satker C ON A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub
		WHERE --(B.Tahun = @Tahun) AND 
			(C.User_ID = @User_ID)
		GROUP BY B.No_SK
		ORDER BY B.No_SK
	END
	ELSE

	BEGIN
		SELECT B.No_SK
		FROM
		(
		SELECT B.No_SK
		FROM Ta_Penghapusan_Rinc A INNER JOIN
			Ta_Penghapusan B ON A.Tahun = B.Tahun AND A.No_SK = B.No_SK
		--WHERE (B.Tahun = @Tahun)
		GROUP BY B.No_SK
		
		UNION ALL
	
		SELECT B.No_SK
		FROM Ta_KIBAR A INNER JOIN
			Ta_Penghapusan B ON A.No_Dokumen = B.No_SK
		WHERE --(B.Tahun = @Tahun) AND 
			A.Kd_Riwayat = 7
		
		UNION ALL

		SELECT B.No_SK
		FROM Ta_KIBBR A INNER JOIN
			Ta_Penghapusan B ON A.No_Dokumen = B.No_SK
		WHERE --(B.Tahun = @Tahun) AND 
			A.Kd_Riwayat = 7

		UNION ALL

		SELECT B.No_SK
		FROM Ta_KIBCR A INNER JOIN
			Ta_Penghapusan B ON A.No_Dokumen = B.No_SK
		WHERE --(B.Tahun = @Tahun) AND 
			A.Kd_Riwayat = 7

		UNION ALL

		SELECT B.No_SK
		FROM Ta_KIBDR A INNER JOIN
			Ta_Penghapusan B ON A.No_Dokumen = B.No_SK
		WHERE --(B.Tahun = @Tahun) AND 
			A.Kd_Riwayat = 7

		UNION ALL

		SELECT B.No_SK
		FROM Ta_KIBER A INNER JOIN
			Ta_Penghapusan B ON A.No_Dokumen = B.No_SK
		WHERE --(B.Tahun = @Tahun) AND 
			A.Kd_Riwayat = 7

		UNION ALL

		SELECT B.No_SK
		FROM Ta_KIBAHapus A INNER JOIN
			Ta_Penghapusan B ON A.No_SK = B.No_SK
		--WHERE (B.Tahun = @Tahun)

		UNION ALL

		SELECT B.No_SK
		FROM Ta_KIBBHapus A INNER JOIN
			Ta_Penghapusan B ON A.No_SK = B.No_SK
		--WHERE (B.Tahun = @Tahun)

		UNION ALL

		SELECT B.No_SK
		FROM Ta_KIBCHapus A INNER JOIN
			Ta_Penghapusan B ON A.No_SK = B.No_SK
		--WHERE (B.Tahun = @Tahun)

		UNION ALL

		SELECT B.No_SK
		FROM Ta_KIBDHapus A INNER JOIN
			Ta_Penghapusan B ON A.No_SK = B.No_SK
		--WHERE (B.Tahun = @Tahun)

		UNION ALL

		SELECT B.No_SK
		FROM Ta_KIBEHapus A INNER JOIN
			Ta_Penghapusan B ON A.No_SK = B.No_SK
		--WHERE (B.Tahun = @Tahun)
		) B
		GROUP BY B.No_SK
		ORDER BY B.No_SK
	END





GO
