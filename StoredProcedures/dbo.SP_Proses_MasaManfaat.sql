USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** SP_Proses_MasaManfaat - 21012016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Proses_MasaManfaat @sKIB varchar(1), @Tahun1 varchar(4), @Tahun2 varchar(4)
WITH ENCRYPTION
AS

/*
DECLARE @Tahun1 varchar(4), @Tahun2 varchar(4)
SET @Tahun1 = '2008'
SET @Tahun2 = '2015'
*/

DECLARE @intError INT

BEGIN TRAN 

IF @sKIB = 'B'
BEGIN
	UPDATE Ta_KIB_B
	SET Masa_Manfaat = (A.Umur*12), Kd_Penyusutan = A.Metode
	FROM
	(SELECT A.Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, B.Umur, B.Metode
	FROM (
		SELECT MAX(A.Tahun) AS Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84
		FROM Ref_Penyusutan A 
		WHERE A.Tahun <= @Tahun2
		GROUP BY A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84) A INNER JOIN
	      Ref_Penyusutan B ON A.Tahun = B.Tahun AND A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	      WHERE A.Tahun <= @Tahun2
	) A INNER JOIN
	Ta_KIB_B B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	WHERE Year(B.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2

	UPDATE Ta_KIBBR
	SET Masa_Manfaat = (A.Umur*12), Kd_Penyusutan = A.Metode
	FROM
	(SELECT A.Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, B.Umur, B.Metode
	FROM (
		SELECT MAX(A.Tahun) AS Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84
		FROM Ref_Penyusutan A 
		WHERE A.Tahun <= @Tahun2
		GROUP BY A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84) A INNER JOIN
	      Ref_Penyusutan B ON A.Tahun = B.Tahun AND A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	      WHERE A.Tahun <= @Tahun2
	) A INNER JOIN
	Ta_KIBBR B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	WHERE (Year(B.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2) AND B.Kd_Riwayat = 3
END


IF @sKIB = 'C' 
BEGIN
	UPDATE Ta_KIB_C
	SET Masa_Manfaat = (A.Umur*12), Kd_Penyusutan = A.Metode
	FROM
	(SELECT A.Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, B.Umur, B.Metode
	FROM (
		SELECT MAX(A.Tahun) AS Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84
		FROM Ref_Penyusutan A 
		WHERE A.Tahun <= @Tahun2
		GROUP BY A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84) A INNER JOIN
	      Ref_Penyusutan B ON A.Tahun = B.Tahun AND A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	      WHERE A.Tahun <= @Tahun2
	) A INNER JOIN
	Ta_KIB_C B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	WHERE Year(B.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2

	UPDATE Ta_KIBCR
	SET Masa_Manfaat = (A.Umur*12), Kd_Penyusutan = A.Metode
	FROM
	(SELECT A.Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, B.Umur, B.Metode
	FROM (
		SELECT MAX(A.Tahun) AS Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84
		FROM Ref_Penyusutan A 
		WHERE A.Tahun <= @Tahun2
		GROUP BY A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84) A INNER JOIN
	      Ref_Penyusutan B ON A.Tahun = B.Tahun AND A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	      WHERE A.Tahun <= @Tahun2
	) A INNER JOIN
	Ta_KIBCR B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	WHERE (Year(B.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2) AND B.Kd_Riwayat = 3
END

IF @sKIB = 'D' 
BEGIN
	UPDATE Ta_KIB_D
	SET Masa_Manfaat = (A.Umur*12), Kd_Penyusutan = A.Metode
	FROM
	(SELECT A.Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, B.Umur, B.Metode
	FROM (
		SELECT MAX(A.Tahun) AS Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84
		FROM Ref_Penyusutan A 
		WHERE A.Tahun <= @Tahun2
		GROUP BY A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84) A INNER JOIN
	      Ref_Penyusutan B ON A.Tahun = B.Tahun AND A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	      WHERE A.Tahun <= @Tahun2
	) A INNER JOIN
	Ta_KIB_D B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	WHERE Year(B.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2

	UPDATE Ta_KIBDR
	SET Masa_Manfaat = (A.Umur*12), Kd_Penyusutan = A.Metode
	FROM
	(SELECT A.Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, B.Umur, B.Metode
	FROM (
		SELECT MAX(A.Tahun) AS Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84
		FROM Ref_Penyusutan A 
		WHERE A.Tahun <= @Tahun2
		GROUP BY A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84) A INNER JOIN
	      Ref_Penyusutan B ON A.Tahun = B.Tahun AND A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	      WHERE A.Tahun <= @Tahun2
	) A INNER JOIN
	Ta_KIBDR B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	WHERE (Year(B.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2) AND B.Kd_Riwayat = 3
END
	
IF @sKIB = 'E' 
BEGIN
	UPDATE Ta_KIB_E
	SET Masa_Manfaat = (A.Umur*12), Kd_Penyusutan = A.Metode
	FROM
	(SELECT A.Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, B.Umur, B.Metode
	FROM (
		SELECT MAX(A.Tahun) AS Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84
		FROM Ref_Penyusutan A 
		WHERE A.Tahun <= @Tahun2
		GROUP BY A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84) A INNER JOIN
	      Ref_Penyusutan B ON A.Tahun = B.Tahun AND A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	      WHERE A.Tahun <= @Tahun2
	) A INNER JOIN
	Ta_KIB_E B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	WHERE Year(B.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2

	UPDATE Ta_KIBER
	SET Masa_Manfaat = (A.Umur*12), Kd_Penyusutan = A.Metode
	FROM
	(SELECT A.Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, B.Umur, B.Metode
	FROM (
		SELECT MAX(A.Tahun) AS Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84
		FROM Ref_Penyusutan A 
		WHERE A.Tahun <= @Tahun2
		GROUP BY A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84) A INNER JOIN
	      Ref_Penyusutan B ON A.Tahun = B.Tahun AND A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	      WHERE A.Tahun <= @Tahun2
	) A INNER JOIN
	Ta_KIBER B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	WHERE (Year(B.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2) AND B.Kd_Riwayat = 3
END 

IF @sKIB = 'L' 
BEGIN
	UPDATE Ta_Lainnya
	SET Masa_Manfaat = (A.Umur*12), Kd_Penyusutan = A.Metode
	FROM
	(SELECT A.Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, B.Umur, B.Metode
	FROM (
		SELECT MAX(A.Tahun) AS Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84
		FROM Ref_Penyusutan A 
		WHERE A.Tahun <= @Tahun2
		GROUP BY A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84) A INNER JOIN
	      Ref_Penyusutan B ON A.Tahun = B.Tahun AND A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	      WHERE A.Tahun <= @Tahun2
	) A INNER JOIN
	Ta_Lainnya B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	WHERE Year(B.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2

	UPDATE Ta_KILER
	SET Masa_Manfaat = (A.Umur*12), Kd_Penyusutan = A.Metode
	FROM
	(SELECT A.Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, B.Umur, B.Metode
	FROM (
		SELECT MAX(A.Tahun) AS Tahun, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84
		FROM Ref_Penyusutan A 
		WHERE A.Tahun <= @Tahun2
		GROUP BY A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84) A INNER JOIN
	      Ref_Penyusutan B ON A.Tahun = B.Tahun AND A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	      WHERE A.Tahun <= @Tahun2
	) A INNER JOIN
	Ta_KILER B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84
	WHERE (Year(B.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2) AND B.Kd_Riwayat = 3
END 

SELECT @intError = @@ERROR
IF (@intError <> 0) GOTO PROBLEM

COMMIT TRAN

PROBLEM:
IF (@intError <> 0) BEGIN
    PRINT 'Proses Update Masa manfaat KIB GAGAL !'
    ROLLBACK TRAN
END



GO
