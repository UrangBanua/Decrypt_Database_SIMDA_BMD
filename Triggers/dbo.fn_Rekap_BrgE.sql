USE bmd_hst2020
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO


/*** fn_Kartu_BrgE - 16112015 - Modified for Ver 2.0.7 [demi@simda.id] ***/

CREATE FUNCTION [dbo].[fn_Rekap_BrgE] (@D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4))
RETURNS @UpdateKIB TABLE(Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Pemilik tinyint, Kondisi Varchar(2), Harga money)
WITH ENCRYPTION
AS
BEGIN
/*
DECLARE @UpdateKIB TABLE(Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Pemilik tinyint, Kondisi Varchar(2), Harga money)
DECLARE @Tahun varchar(4), @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3)
SET @Tahun = '2015'
SET @D2 = '20151231'
SET @Kd_Prov = '11'
SET @Kd_Kab_Kota = '23'
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @Kd_UPB = ''
*/
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

	DECLARE @no_urut  TABLE(Kd_Id Int, IDPemda varchar(17))
	DECLARE @tmpHarga TABLE(IDPemda varchar(17), Kd_Aset1 tinyint, Kd_Aset2 tinyint, Harga money, Kd_KA tinyint)
	DECLARE @UbahData TABLE(IDPemda varchar(17), Kd_Pemilik tinyint, Kondisi Varchar(2))

	INSERT INTO @UpdateKIB
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik, A.Kondisi, SUM(A.Harga) AS Harga
	FROM Ta_KIB_E A
	WHERE IDPemda NOT IN
		(
		SELECT A.IDPemda
		FROM
			(
			SELECT A.IDPemda
			FROM Ta_KIBER A
			UNION
			SELECT A.IDPemda
			FROM Ta_KIBEHapus A
			) A
		GROUP BY A.IDPemda
		)
	AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
		AND A.Kd_Data <> 3 AND A.Kd_Hapus  <> 1 AND A.Kd_Bidang <> 22 AND (A.Kd_KA = 1)
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik, A.Kondisi

	INSERT INTO @no_urut
	SELECT MAX(Kd_Id), IDPemda
	FROM Ta_KIBER
	WHERE Tgl_Dokumen <= @D2 AND Kd_Riwayat IN(1,18,22)
	GROUP BY IDPemda
        
	--1. PEROLEHAN 1
	INSERT INTO @tmpHarga
	SELECT A.IDPemda, A.Kd_Aset1, A.Kd_Aset2, A.Harga, A.Kd_KA
	FROM Ta_KIB_E A INNER JOIN
		(
		SELECT A.IDPemda
		FROM
			(
			SELECT A.IDPemda
			FROM Ta_KIBER A
			UNION
			SELECT A.IDPemda
			FROM Ta_KIBEHapus A
			) A
		GROUP BY A.IDPemda
		) B ON A.IDPemda = B.IDPemda
	WHERE A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
		AND A.Kd_Data <> 3 AND A.Kd_Hapus  <> 1 AND A.Kd_Bidang <> 22

	--2. PEROLEHAN 2
	INSERT INTO @tmpHarga
	SELECT A.IDPemda, A.Kd_Aset1, A.Kd_Aset2, ISNULL(SUM(A.Harga), 0) AS Harga, A.Kd_KA
	FROM Ta_KIBER A
	WHERE A.Tgl_dokumen > @D2 AND A.Kd_Riwayat = 3 AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
		AND A.Kd_Bidang <> 22
	GROUP BY A.IDPemda, A.Kd_Aset1, A.Kd_Aset2, A.Kd_KA

	--3. PEROLEHAN 3
	INSERT INTO @tmpHarga
	SELECT A.IDPemda, A.Kd_Aset1, A.Kd_Aset2, ISNULL(SUM(A.Harga), 0) AS Harga, Kd_KA
	FROM Ta_KIBEHapus A
	WHERE A.Tgl_SK > @D2 AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	GROUP BY A.IDPemda, A.Kd_Aset1, A.Kd_Aset2, A.Kd_KA

	--4. KAPITALISASI
	INSERT INTO @tmpHarga
	SELECT A.IDPemda, A.Kd_Aset1, A.Kd_Aset2, ISNULL(SUM(A.Harga), 0) AS Harga, NULL AS Kd_KA
	FROM Ta_KIBER A 
	WHERE A.Tgl_dokumen <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
		AND (A.Kd_Riwayat = 2) AND A.Kd_Data <> 3 AND A.Kd_Bidang <> 22
	GROUP BY A.IDPemda, A.Kd_Aset1, A.Kd_Aset2

	--5. HAPUS SEBAGIAN
	INSERT INTO @tmpHarga
	SELECT A.IDPemda, A.Kd_Aset1, A.Kd_Aset2, ISNULL(SUM(-A.Harga), 0) AS Harga, NULL AS Kd_KA
	FROM Ta_KIBER A
	WHERE A.Tgl_dokumen <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
		AND (A.Kd_Riwayat = 7) AND A.Kd_Data <> 3 AND A.Kd_Bidang <> 22
	GROUP BY A.IDPemda, A.Kd_Aset1, A.Kd_Aset2

	--6. KOREKSI
	INSERT INTO @tmpHarga
	SELECT A.IDPemda, A.Kd_Aset1, A.Kd_Aset2, ISNULL(SUM(A.Harga), 0) AS Harga, NULL AS Kd_KA
	FROM Ta_KIBER A 
	WHERE A.Tgl_dokumen <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
		AND (A.Kd_Riwayat = 21) AND A.Kd_Data <> 3 AND A.Kd_Bidang <> 22
	GROUP BY A.IDPemda, A.Kd_Aset1, A.Kd_Aset2
	--UBAH DATA KIB E
	--1
	INSERT INTO @UbahData
	SELECT A.IDPemda, A.Kd_Pemilik, A.Kondisi
	FROM Ta_KIB_E A INNER JOIN
		(
		SELECT A.IDPemda
		FROM
			(
			SELECT A.IDPemda
			FROM Ta_KIBER A
			UNION
			SELECT A.IDPemda
			FROM Ta_KIBEHapus A
			) A
		GROUP BY A.IDPemda
		) C ON A.IDPemda = C.IDPemda LEFT OUTER JOIN
		(
		SELECT A.Kd_Riwayat, A.Kd_Id, A.IDPemda
		FROM Ta_KIBER A INNER JOIN
			@no_urut B ON A.Kd_Id = B.Kd_Id AND A.IDPemda = B.IDPemda
		) B ON A.IDPemda = B.IDPemda
	WHERE (B.IDPemda IS NULL) AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
		AND A.Kd_Hapus <> 1

	--2
	INSERT INTO @UbahData
	SELECT A.IDPemda, A.Kd_Pemilik, A.Kondisi
	FROM Ta_KIBEHapus A LEFT OUTER JOIN
		(
		SELECT A.Kd_Riwayat, A.Kd_Id, A.IDPemda
		FROM Ta_KIBER A INNER JOIN
			@no_urut B ON A.Kd_Id = B.Kd_Id AND A.IDPemda = B.IDPemda
		) B ON A.IDPemda = B.IDPemda
	WHERE (B.IDPemda IS NULL) AND A.Tgl_SK > @D2 AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	--3
	INSERT INTO @UbahData
	SELECT A.IDPemda, A.Kd_Pemilik, A.Kondisi
	FROM Ta_KIBER A LEFT OUTER JOIN
		(
		SELECT A.Kd_Riwayat, A.Kd_Id, A.IDPemda
		FROM Ta_KIBER A INNER JOIN
			@no_urut B ON A.Kd_Id = B.Kd_Id AND A.IDPemda = B.IDPemda
		) B ON A.IDPemda = B.IDPemda
	WHERE (B.IDPemda IS NULL) AND A.Tgl_dokumen > @D2 AND A.Kd_Riwayat = 3 AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB

	--UBAH DATA KIB E (RIWAYAT)
	INSERT INTO @UbahData
	SELECT A.IDPemda, A.Kd_Pemilik, A.Kondisi
	FROM Ta_KIBER A INNER JOIN
		(
		SELECT A.Kd_Riwayat, MAX(A.Kd_Id) AS Kd_Id, A.IDPemda
		FROM Ta_KIBER A INNER JOIN
			@no_urut B ON A.Kd_Id = B.Kd_Id AND A.IDPemda = B.IDPemda
		GROUP BY A.Kd_Riwayat, A.IDPemda
		) B ON A.Kd_Riwayat = B.Kd_Riwayat AND A.Kd_Id = B.Kd_Id AND A.IDPemda = B.IDPemda
	WHERE A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB

	INSERT INTO @UpdateKIB
	SELECT A.Kd_Aset1, A.Kd_Aset2, B.Kd_Pemilik, B.Kondisi, SUM(A.Harga)
	FROM(
		SELECT A.IDPemda, A.Kd_Aset1, A.Kd_Aset2, ISNULL(SUM(A.Harga),0) AS Harga, MAX(A.Kd_KA) AS Kd_KA
		FROM @TMPHARGA A 
		GROUP BY A.IDPemda, A.Kd_Aset1, A.Kd_Aset2
		) A INNER JOIN
		(
		SELECT A.IDPemda, A.Kd_Pemilik, A.Kondisi
		FROM @UBAHDATA A 
		)B ON A.IDPemda = B.IDPemda
	WHERE (A.Kd_KA = 1)
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, B.Kd_Pemilik, B.Kondisi

	RETURN
END






GO
