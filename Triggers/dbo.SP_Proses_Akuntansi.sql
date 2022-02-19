USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** SP_Proses_Akuntansi - 20022020 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Proses_Akuntansi @sKIB varchar(1), @sKode varchar(1), @Tahun1 varchar(4), @Tahun2 varchar(4)
WITH ENCRYPTION
AS

/*
DECLARE @Tahun1 varchar(4), @Tahun2 varchar(4)
SET @Tahun1 = '2008'
SET @Tahun2 = '2015'
*/

DECLARE @intError INT, @tmpThn Smallint

BEGIN TRAN 

SET @tmpThn = (SELECT MAX(Tahun) FROM Ta_KA WHERE Tahun Between @Tahun1 AND @Tahun2) 

IF ((@sKIB = 'B') AND (@sKode = '1'))
BEGIN
	DECLARE @tmpKIBB1 TABLE(IDPemda varchar(17), Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_KA tinyint)
	INSERT INTO @tmpKIBB1
	SELECT DISTINCT B.IDPemda, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, (CASE WHEN B.Harga > A.MinSatuan THEN 1 WHEN B.Harga < A.MinSatuan THEN 0 ELSE 1 END) AS Kd_KA
	FROM (SELECT Tahun, Kd_Prov, Kd_Kab_Kota, MinSatuan, MinTotal, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_KA WHERE Tahun = @tmpThn) A 
	INNER JOIN Ta_KIB_B B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83
	WHERE Year(B.Tgl_Perolehan) BETWEEN @Tahun1 AND @Tahun2

	INSERT INTO @tmpKIBB1
	SELECT DISTINCT B.IDPemda, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, (CASE WHEN B.Harga > A.MinSatuan THEN 1 WHEN B.Harga < A.MinSatuan THEN 0 ELSE 1 END) AS Kd_KA
	FROM (SELECT Tahun, Kd_Prov, Kd_Kab_Kota, MinSatuan, MinTotal, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_KA WHERE Tahun = @tmpThn) A
	INNER JOIN Ta_KIBBR B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83
	WHERE B.Kd_Riwayat = 21 AND Year(B.Tgl_Perolehan) BETWEEN @Tahun1 AND @Tahun2 

	DECLARE @tmpKIBB3 TABLE(IDPemda varchar(17), Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_KA tinyint)
	INSERT INTO @tmpKIBB3
	SELECT IDPemda, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, MAX(Kd_KA) AS Kd_KA FROM @tmpKIBB1 GROUP BY IDPemda, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3
	
	UPDATE Ta_KIB_B
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIB_B A INNER JOIN @tmpKIBB3 B ON A.IDPemda = B.IDPemda
	WHERE Year(Tgl_Perolehan) BETWEEN @Tahun1 AND @Tahun2

	UPDATE Ta_KIBBHapus
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIBBHapus A INNER JOIN @tmpKIBB3 B ON A.IDPemda = B.IDPemda
	WHERE Year(A.Tgl_Perolehan) BETWEEN @Tahun1 AND @Tahun2
END

IF ((@sKIB = 'B') AND (@sKode = '2'))
BEGIN
	DECLARE @tmpKIBB2 TABLE(IDPemda varchar(17), Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_KA tinyint)
	INSERT INTO @tmpKIBB2
	SELECT DISTINCT B.IDPemda, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, (CASE WHEN B.Harga > A.MinSatuan THEN 1 WHEN B.Harga < A.MinSatuan THEN 0 ELSE 1 END) AS Kd_KA
	FROM (SELECT Tahun, Kd_Prov, Kd_Kab_Kota, MinSatuan, MinTotal, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_KA WHERE Tahun = @tmpThn) A 
	INNER JOIN Ta_KIB_B B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83
	WHERE Year(B.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2

	INSERT INTO @tmpKIBB2
	SELECT DISTINCT B.IDPemda, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, (CASE WHEN B.Harga > A.MinSatuan THEN 1 WHEN B.Harga < A.MinSatuan THEN 0 ELSE 1 END) AS Kd_KA
	FROM (SELECT Tahun, Kd_Prov, Kd_Kab_Kota, MinSatuan, MinTotal, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_KA WHERE Tahun = @tmpThn) A
	INNER JOIN Ta_KIBBR B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83
	WHERE B.Kd_Riwayat = 21 AND Year(B.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2 

	DECLARE @tmpKIBB4 TABLE(IDPemda varchar(17), Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_KA tinyint)
	INSERT INTO @tmpKIBB4
	SELECT IDPemda, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, MAX(Kd_KA) AS Kd_KA FROM @tmpKIBB2 GROUP BY IDPemda, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3
	
	UPDATE Ta_KIB_B
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIB_B A INNER JOIN @tmpKIBB4 B ON A.IDPemda = B.IDPemda
	WHERE Year(A.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2

	UPDATE Ta_KIBBHapus
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIBBHapus A INNER JOIN @tmpKIBB4 B ON A.IDPemda = B.IDPemda
	WHERE Year(A.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2
END

IF ((@sKIB = 'C') AND (@sKode = '1'))
BEGIN
	DECLARE @tmpKIBC1 TABLE(IDPemda varchar(17), Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_KA tinyint)
	INSERT INTO @tmpKIBC1
	SELECT DISTINCT B.IDPemda, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, (CASE WHEN B.Harga > A.MinSatuan THEN 1 WHEN B.Harga < A.MinSatuan THEN 0 ELSE 1 END) AS Kd_KA
	FROM (SELECT Tahun, Kd_Prov, Kd_Kab_Kota, MinSatuan, MinTotal, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_KA WHERE Tahun = @tmpThn) A
	INNER JOIN Ta_KIB_C B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83
	WHERE Year(B.Tgl_Perolehan) BETWEEN @Tahun1 AND @Tahun2 

	UPDATE Ta_KIB_C
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIB_C A INNER JOIN @tmpKIBC1 B ON A.IDPemda = B.IDPemda
	WHERE Year(A.Tgl_Perolehan) BETWEEN @Tahun1 AND @Tahun2

	UPDATE Ta_KIBCHapus
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIBCHapus A INNER JOIN @tmpKIBC1 B ON A.IDPemda = B.IDPemda
	WHERE Year(A.Tgl_Perolehan) BETWEEN @Tahun1 AND @Tahun2
END

IF ((@sKIB = 'C') AND (@sKode = '2'))
BEGIN
	DECLARE @tmpKIBC2 TABLE(IDPemda varchar(17), Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_KA tinyint)
	INSERT INTO @tmpKIBC2
	SELECT DISTINCT B.IDPemda, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, (CASE WHEN B.Harga > A.MinSatuan THEN 1 WHEN B.Harga < A.MinSatuan THEN 0 ELSE 1 END) AS Kd_KA
	FROM (SELECT Tahun, Kd_Prov, Kd_Kab_Kota, MinSatuan, MinTotal, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_KA WHERE Tahun = @tmpThn) A
	INNER JOIN Ta_KIB_C B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83
	WHERE Year(B.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2 

	UPDATE Ta_KIB_C
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIB_C A INNER JOIN @tmpKIBC2 B ON A.IDPemda = B.IDPemda
	WHERE Year(A.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2

	UPDATE Ta_KICBHapus
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIBCHapus A INNER JOIN @tmpKIBC2 B ON A.IDPemda = B.IDPemda
	WHERE Year(A.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2
END

IF ((@sKIB = 'D') AND (@sKode = '1')) 
BEGIN
	DECLARE @tmpKIBD1 TABLE(IDPemda varchar(17), Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_KA tinyint)
	INSERT INTO @tmpKIBD1
	SELECT DISTINCT B.IDPemda, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, (CASE WHEN B.Harga > A.MinSatuan THEN 1 WHEN B.Harga < A.MinSatuan THEN 0 ELSE 1 END) AS Kd_KA
	FROM (SELECT Tahun, Kd_Prov, Kd_Kab_Kota, MinSatuan, MinTotal, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_KA WHERE Tahun = @tmpThn) A
	INNER JOIN Ta_KIB_D B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83
	WHERE Year(B.Tgl_Perolehan) BETWEEN @Tahun1 AND @Tahun2 

	UPDATE Ta_KIB_D
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIB_D A INNER JOIN @tmpKIBD1 B ON A.IDPemda = B.IDPemda
	WHERE Year(A.Tgl_Perolehan) BETWEEN @Tahun1 AND @Tahun2
	
	UPDATE Ta_KIBDHapus
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIBDHapus A INNER JOIN @tmpKIBD1 B ON A.IDPemda = B.IDPemda
	WHERE Year(A.Tgl_Perolehan) BETWEEN @Tahun1 AND @Tahun2
END

IF ((@sKIB = 'D') AND (@sKode = '2')) 
BEGIN
	DECLARE @tmpKIBD2 TABLE(IDPemda varchar(17), Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_KA tinyint)
	INSERT INTO @tmpKIBD2
	SELECT DISTINCT B.IDPemda, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, (CASE WHEN B.Harga > A.MinSatuan THEN 1 WHEN B.Harga < A.MinSatuan THEN 0 ELSE 1 END) AS Kd_KA
	FROM (SELECT Tahun, Kd_Prov, Kd_Kab_Kota, MinSatuan, MinTotal, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_KA WHERE Tahun = @tmpThn) A
	INNER JOIN Ta_KIB_D B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83
	WHERE Year(B.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2 

	UPDATE Ta_KIB_D
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIB_D A INNER JOIN @tmpKIBD2 B ON A.IDPemda = B.IDPemda
	WHERE Year(A.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2
	
	UPDATE Ta_KIBDHapus
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIBDHapus A INNER JOIN @tmpKIBD2 B ON A.IDPemda = B.IDPemda
	WHERE Year(A.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2
END
	
IF ((@sKIB = 'E') AND (@sKode = '1')) 
BEGIN
	DECLARE @tmpKIBE1 TABLE(IDPemda varchar(17), Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_KA tinyint)
	INSERT INTO @tmpKIBE1
	SELECT DISTINCT B.IDPemda, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, (CASE WHEN B.Harga > A.MinSatuan THEN 1 WHEN B.Harga < A.MinSatuan THEN 0 ELSE 1 END) AS Kd_KA
	FROM (SELECT Tahun, Kd_Prov, Kd_Kab_Kota, MinSatuan, MinTotal, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_KA WHERE Tahun = @tmpThn) A
	INNER JOIN Ta_KIB_E B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83
	WHERE Year(B.Tgl_Perolehan) BETWEEN @Tahun1 AND @Tahun2 

	UPDATE Ta_KIB_E
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIB_E A INNER JOIN @tmpKIBE1 B ON A.IDPemda = B.IDPemda
	WHERE Year(A.Tgl_Perolehan) BETWEEN @Tahun1 AND @Tahun2

	UPDATE Ta_KIBEHapus
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIBEHapus A INNER JOIN @tmpKIBE1 B ON A.IDPemda = B.IDPemda
	WHERE Year(A.Tgl_Perolehan) BETWEEN @Tahun1 AND @Tahun2
END 

IF ((@sKIB = 'E') AND (@sKode = '2')) 
BEGIN
	DECLARE @tmpKIBE2 TABLE(IDPemda varchar(17), Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_KA tinyint)
	INSERT INTO @tmpKIBE2
	SELECT DISTINCT B.IDPemda, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, (CASE WHEN B.Harga > A.MinSatuan THEN 1 WHEN B.Harga < A.MinSatuan THEN 0 ELSE 1 END) AS Kd_KA
	FROM (SELECT Tahun, Kd_Prov, Kd_Kab_Kota, MinSatuan, MinTotal, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_KA WHERE Tahun = @tmpThn) A
	INNER JOIN Ta_KIB_E B ON A.Tahun = Year(B.Tgl_Pembukuan) AND A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83
	WHERE Year(B.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2 

	UPDATE Ta_KIB_E
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIB_E A INNER JOIN @tmpKIBE2 B ON A.IDPemda = B.IDPemda
	WHERE Year(A.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2

	UPDATE Ta_KIBEHapus
	SET Kd_KA = B.Kd_KA
	FROM Ta_KIBEHapus A INNER JOIN @tmpKIBE2 B ON A.IDPemda = B.IDPemda
	WHERE Year(A.Tgl_Pembukuan) BETWEEN @Tahun1 AND @Tahun2
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
