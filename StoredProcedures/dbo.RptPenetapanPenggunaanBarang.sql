USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[RptPenetapanPenggunaanBarang] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @No_SKGuna Varchar(50)
WITH ENCRYPTION
AS

/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3) , @Kd_Sub varchar(3) , @Kd_UPB varchar(3), @No_SKGuna Varchar(50) 
SET @Tahun = '2010'
SET @Kd_Prov = '99'
SET @Kd_Kab_Kota = '99'
SET @No_SKGuna = '01/sk'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
*/

	DECLARE @tmpBI TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, Kd_Pemilik tinyint, No_Register int, Tgl_Perolehan datetime, Merk varchar(50), Type varchar(50), No_Sertifikat varchar(100), Bahan varchar(50), Asal_Usul varchar(50), Ukuran varchar(50), Satuan varchar(50), Kondisi int, Harga money, No_SKGuna Varchar(50), Keterangan Varchar(255))

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, '', '', ISNULL(A.Sertifikat_Nomor, '-'), '', A.Asal_usul, A.Luas_M2, 'M2', '1', A.Harga, A.No_SKGuna, A.Keterangan
	FROM TA_KIB_A  A
	WHERE (YEAR(A.TGL_PEROLEHAN) <= @TAHUN) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.No_SKGuna = @No_SKGuna) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Merk, A.Type,
		CASE
		WHEN (ISNULL(REPLACE(A.Nomor_Pabrik, '-', ''), '') = '') AND (ISNULL(REPLACE(A.Nomor_Rangka, '-', ''), '') = '') AND (ISNULL(REPLACE(A.Nomor_Mesin, '-', ''), '') = '') THEN '-'
		WHEN (ISNULL(REPLACE(A.Nomor_Pabrik, '-', ''), '') = '') AND (ISNULL(REPLACE(A.Nomor_Rangka, '-', ''), '') = '') THEN A.Nomor_Mesin
		WHEN (ISNULL(REPLACE(A.Nomor_Pabrik, '-', ''), '') = '') AND (ISNULL(REPLACE(A.Nomor_Mesin, '-', ''), '') = '') THEN A.Nomor_Rangka
		WHEN (ISNULL(REPLACE(A.Nomor_Rangka, '-', ''), '') = '') AND (ISNULL(REPLACE(A.Nomor_Mesin, '-', ''), '') = '') THEN A.Nomor_Pabrik
		WHEN (ISNULL(REPLACE(A.Nomor_Pabrik, '-', ''), '') = '') THEN A.Nomor_Rangka + CHAR(13) + A.Nomor_Mesin
		WHEN (ISNULL(REPLACE(A.Nomor_Rangka, '-', ''), '') = '') THEN A.Nomor_Pabrik + CHAR(13) + A.Nomor_Mesin
		WHEN (ISNULL(REPLACE(A.Nomor_Mesin, '-', ''), '') = '') THEN A.Nomor_Pabrik + CHAR(13) + A.Nomor_Rangka
		ELSE A.Nomor_Pabrik + CHAR(13) + A.Nomor_Rangka + CHAR(13) + A.Nomor_Mesin
		END,
		A.Bahan, A.Asal_usul, A.CC, '', A.Kondisi, A.Harga, A.No_SKGuna, A.Keterangan
	FROM TA_KIB_B  A
	WHERE (YEAR(A.TGL_PEROLEHAN) <= @TAHUN) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.No_SKGuna = @No_SKGuna) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, '', '', ISNULL(A.Dokumen_Nomor, '-'), REPLACE(A.Beton_Tidak, 'Tidak', ''), A.Asal_usul, A.Luas_Lantai, 'M2', A.Kondisi, A.Harga, A.No_SKGuna, A.Keterangan
	FROM TA_KIB_C  A
	WHERE (YEAR(A.TGL_PEROLEHAN) <= @TAHUN) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.No_SKGuna = @No_SKGuna) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, '', '', ISNULL(A.Dokumen_Nomor, '-'), A.Konstruksi, A.Asal_usul, A.Luas, 'M2', A.Kondisi, A.Harga, A.No_SKGuna, A.Keterangan
	FROM TA_KIB_D  A
	WHERE (YEAR(A.TGL_PEROLEHAN) <= @TAHUN) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.No_SKGuna = @No_SKGuna) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, '', '', '-',
		CASE A.Kd_Aset2
		WHEN 18 THEN A.Bahan
		WHEN 17 THEN A.Bahan
		ELSE '-'
		END, A.Asal_usul, A.Ukuran,
		CASE A.Kd_Aset2
		WHEN 19 THEN A.Bahan
		ELSE ''
		END, A.Kondisi, A.Harga, A.No_SKGuna, A.Keterangan
	FROM TA_KIB_E  A
	WHERE (YEAR(A.TGL_PEROLEHAN) <= @TAHUN) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.No_SKGuna = @No_SKGuna) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)


	DECLARE @Ta_KIB_B TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB smallint, Kd_Pemilik tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, Reg1 int, Reg2 int, MerkType varchar(100), No_Sertifikat varchar(50), Bahan varchar(50), Tahun smallint, Ukuran varchar(50), Satuan varchar(50), Kondisi int, Asal_usul varchar(50), Harga money, Total int, No_SKGuna Varchar(50), Keterangan Varchar(255))
	DECLARE @Kd_Prov1 tinyint, @Kd_Kab_Kota1 tinyint, @Kd_Bidang1 tinyint, @Kd_Unit1 smallint, @Kd_Sub1 smallint, @Kd_UPB1 smallint, @Kd_Pemilik1 tinyint, @Kd_Aset11 tinyint, @Kd_Aset21 tinyint, @Kd_Aset31 tinyint, @Kd_Aset41 tinyint, @Kd_Aset51 tinyint, @No_Register1 int, @MerkType1 varchar(100), @No_Sertifikat1 varchar(50), @Bahan1 varchar(50), @Tahun1 smallint, @Ukuran1 varchar(50), @Satuan1 varchar(50), @Kondisi1 int, @Asal_usul1 varchar(50), @Harga1 money , @No_SKGuna1 Varchar(50), @Keterangan1 Varchar(255) 
	DECLARE @Kd_Prov2 tinyint, @Kd_Kab_Kota2 tinyint, @Kd_Bidang2 tinyint, @Kd_Unit2 smallint, @Kd_Sub2 smallint, @Kd_UPB2 smallint, @Kd_Pemilik2 tinyint, @Kd_Aset12 tinyint, @Kd_Aset22 tinyint, @Kd_Aset32 tinyint, @Kd_Aset42 tinyint, @Kd_Aset52 tinyint, @MerkType2 varchar(200), @No_Sertifikat2 varchar(50), @Bahan2 varchar(50), @Tahun2 smallint, @Ukuran2 varchar(50), @Satuan2 varchar(50), @Kondisi2 int, @Asal_usul2 varchar(50), @Harga2 money , @No_SKGuna2 Varchar(50), @Keterangan2 Varchar(255)
	DECLARE @Reg1 int, @Reg2 int, @Jumlah int

	DECLARE c1 CURSOR FOR
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub,  A.Kd_UPB, A.Kd_Pemilik,
		A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		CASE
		WHEN (ISNULL(A.Merk, '') <> '') AND (ISNULL(A.Type, '') <> '') THEN A.Merk + ' / ' + A.Type
		WHEN (ISNULL(A.Merk, '') <> '') THEN A.Merk
		WHEN (ISNULL(A.Type, '') <> '') THEN A.Type
		ELSE '-'
		END AS MerkType, 
		ISNULL(A.No_Sertifikat, '') AS No_Sertifikat, ISNULL(A.Bahan, '') AS Bahan, YEAR(A.Tgl_Perolehan) AS Tahun,
		ISNULL(A.Ukuran, '') AS Ukuran, ISNULL(A.Satuan, '') AS Satuan,
		ISNULL(A.Kondisi, '') AS Kondisi, ISNULL(A.Asal_Usul, '') AS Asal_Usul, A.Harga, A.No_SKGuna, A.Keterangan
	FROM @tmpBI A LEFT OUTER JOIN
		(
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM Ta_Penghapusan_Rinc A INNER JOIN
			Ta_Penghapusan B ON A.Tahun = B.Tahun AND A.No_SK = B.No_SK
		WHERE (B.Tahun = @Tahun) AND (B.Tgl_SK <= (@Tahun + '1231'))
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
			A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND 
			A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE B.Kd_Prov IS NULL

	OPEN c1

	FETCH NEXT FROM c1 INTO @Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @Kd_Pemilik1, @Kd_Aset11, @Kd_Aset21, @Kd_Aset31, @Kd_Aset41, @Kd_Aset51, @No_Register1, @MerkType1, @No_Sertifikat1, @Bahan1, @Tahun1, @Ukuran1, @Satuan1, @Kondisi1, @Asal_usul1, @Harga1, @No_SKGuna1, @Keterangan1

	SET @Kd_Prov2 = @Kd_Prov1
	SET @Kd_Kab_Kota2 = @Kd_Kab_Kota1
	SET @Kd_Bidang2 = @Kd_Bidang1
	SET @Kd_Unit2 = @Kd_Unit1
	SET @Kd_Sub2 = @Kd_Sub1
	SET @Kd_UPB2 = @Kd_UPB1
	SET @Kd_Pemilik2 = @Kd_Pemilik1
	SET @Kd_Aset12 = @Kd_Aset11
	SET @Kd_Aset22 = @Kd_Aset21
	SET @Kd_Aset32 = @Kd_Aset31
	SET @Kd_Aset42 = @Kd_Aset41
	SET @Kd_Aset52 = @Kd_Aset51
	SET @MerkType2 = @MerkType1
	SET @No_Sertifikat2 = @No_Sertifikat1
	SET @Bahan2 = @Bahan1
	SET @Tahun2 = @Tahun1
	SET @Ukuran2 = @Ukuran1
	SET @Satuan2 = @Satuan1
	SET @Kondisi2 = @Kondisi1
	SET @Asal_usul2 = @Asal_usul1
	SET @Reg1 = @No_Register1
	SET @Reg2 = @No_Register1
	SET @Harga2 = @Harga1
	SET @Jumlah = 1
	SET @No_SKGuna2 = @No_SKGuna1
	SET @Keterangan2 = @Keterangan1
	

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@Kd_Prov2 = @Kd_Prov1) AND (@Kd_Kab_Kota2 = @Kd_Kab_Kota1) AND (@Kd_Bidang2 = @Kd_Bidang1) AND (@Kd_Unit2 = @Kd_Unit1) AND (@Kd_Sub2 = @Kd_Sub1) AND (@Kd_UPB2 = @Kd_UPB1) AND (@Kd_Pemilik2 = @Kd_Pemilik1) AND (@Kd_Aset12 = @Kd_Aset11) AND (@Kd_Aset22 = @Kd_Aset21) AND (@Kd_Aset32 = @Kd_Aset31) AND (@Kd_Aset42 = @Kd_Aset41) AND (@Kd_Aset52 = @Kd_Aset51) AND (@MerkType2 = @MerkType1) AND (@No_Sertifikat2 = @No_Sertifikat1) AND (@Bahan2 = @Bahan1) AND (@Tahun2 = @Tahun1) AND (@Ukuran2 = @Ukuran1) AND (@Satuan2 = @Satuan1) AND (@Kondisi2 = @Kondisi1) AND (@Asal_usul2 = @Asal_usul1) AND (@Harga2 = @Harga1) AND (@No_SKGuna2 = @No_SKGuna1) AND (@Keterangan2 = @Keterangan1)
		BEGIN
			SET @Reg2 = @No_Register1
			SET @Jumlah = @Jumlah + 1
		END
		ELSE
		BEGIN
			INSERT INTO @Ta_KIB_B
			SELECT @Kd_Prov2, @Kd_Kab_Kota2, @Kd_Bidang2, @Kd_Unit2, @Kd_Sub2, @Kd_UPB2, @Kd_Pemilik2, @Kd_Aset12, @Kd_Aset22, @Kd_Aset32, @Kd_Aset42, @Kd_Aset52, @Reg1, @Reg2, @MerkType2, @No_Sertifikat2, @Bahan2, @Tahun2, @Ukuran2, @Satuan2, @Kondisi2, @Asal_usul2, @Harga2 * @Jumlah, @Jumlah , @No_SKGuna2, @Keterangan2

			SET @Kd_Prov2 = @Kd_Prov1
			SET @Kd_Kab_Kota2 = @Kd_Kab_Kota1
			SET @Kd_Bidang2 = @Kd_Bidang1
			SET @Kd_Unit2 = @Kd_Unit1
			SET @Kd_Sub2 = @Kd_Sub1
			SET @Kd_UPB2 = @Kd_UPB1
			SET @Kd_Pemilik2 = @Kd_Pemilik1
			SET @Kd_Aset12 = @Kd_Aset11
			SET @Kd_Aset22 = @Kd_Aset21
			SET @Kd_Aset32 = @Kd_Aset31
			SET @Kd_Aset42 = @Kd_Aset41
			SET @Kd_Aset52 = @Kd_Aset51
			SET @MerkType2 = @MerkType1
			SET @No_Sertifikat2 = @No_Sertifikat1
			SET @Bahan2 = @Bahan1
			SET @Tahun2 = @Tahun1
			SET @Ukuran2 = @Ukuran1
			SET @Satuan2 = @Satuan1
			SET @Kondisi2 = @Kondisi1
			SET @Asal_usul2 = @Asal_usul1
			SET @Reg1 = @No_Register1
			SET @Reg2 = @No_Register1
			SET @Harga2 = @Harga1
			SET @Jumlah = 1
			SET @No_SKGuna2 = @No_SKGuna1
			SET @Keterangan2 = @Keterangan1			
		END

		FETCH NEXT FROM c1 INTO @Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @Kd_Pemilik1, @Kd_Aset11, @Kd_Aset21, @Kd_Aset31, @Kd_Aset41, @Kd_Aset51, @No_Register1, @MerkType1, @No_Sertifikat1, @Bahan1, @Tahun1, @Ukuran1, @Satuan1, @Kondisi1, @Asal_usul1, @Harga1 , @No_SKGuna1, @Keterangan1
	END

	INSERT INTO @Ta_KIB_B
	SELECT @Kd_Prov2, @Kd_Kab_Kota2, @Kd_Bidang2, @Kd_Unit2, @Kd_Sub2, @Kd_UPB2, @Kd_Pemilik2, @Kd_Aset12, @Kd_Aset22, @Kd_Aset32, @Kd_Aset42, @Kd_Aset52, @Reg1, @Reg2, @MerkType2, @No_Sertifikat2, @Bahan2, @Tahun2, @Ukuran2, @Satuan2, @Kondisi2, @Asal_usul2, @Harga2 * @Jumlah, @Jumlah, @No_SKGuna2, @Keterangan2

	CLOSE c1
	DEALLOCATE c1

	SELECT  I.Nm_Provinsi, H.Nm_Kab_Kota,
		/*CASE A.Kd_Kab_Kota
		WHEN 0 THEN '-'
		ELSE H.Nm_Kab_Kota
		END AS Nm_Kab_Kota, */
		F.Nm_Bidang, E.Nm_Unit, D.Nm_Sub_Unit, J.Nm_UPB_Gab,
		RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) + '.' + RIGHT('0' + @Kd_Sub, 2)  + '.' + RIGHT('0' + @Kd_UPB, 2) AS Kd_UPB_Gab,

		B.Nm_Aset5, REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Brg,
		CASE
		WHEN A.Total = 1 THEN RIGHT('0000' + CONVERT(varchar, A.Reg1), 4)
		ELSE RIGHT('0000' + CONVERT(varchar, A.Reg1), 4) + ' s/d ' + RIGHT('0000' + CONVERT(varchar, A.Reg2), 4)
		END AS No_Register, 
		A.MerkType, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi, A.Tahun,
		A.Total, A.Harga, 
		CASE A.Kondisi
		WHEN 1 THEN COUNT(*)
		ELSE '0'
		END AS Baik,
		CASE A.Kondisi
		WHEN 2 THEN COUNT(*)
		ELSE '0'
		END AS KurangBaik,
		CASE A.Total
		WHEN 1 THEN 1
		ELSE A.Harga
		END AS HrgSat, J.Nm_PimpDaerah, J.Jab_PimpDaerah,  A.No_SKGuna, K.Tgl_SKGuna, A.Keterangan

	FROM @Ta_KIB_B A INNER JOIN
		Ref_Rek_Aset5 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
		Ref_Sub_Unit D ON A.Kd_Bidang = D.Kd_Bidang AND A.Kd_Unit = D.Kd_Unit AND A.Kd_Sub = D.Kd_Sub INNER JOIN
		Ref_Unit E ON D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
		Ref_Bidang F ON E.Kd_Bidang = F.Kd_Bidang INNER JOIN
		Ref_Pemda G ON A.Kd_Prov = G.Kd_Prov AND A.Kd_Kab_Kota = G.Kd_Kab_Kota INNER JOIN
		Ref_Kab_Kota H ON G.Kd_Prov = H.Kd_Prov AND G.Kd_Kab_Kota = H.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi I ON H.Kd_Prov = I.Kd_Prov LEFT OUTER JOIN
		Ta_Penggunaan K ON A.No_SKGuna = K.No_SKGuna, 
		(
		SELECT  RIGHT('0' + A.Kd_Bidang, 2) + '.' + RIGHT('0' + A.Kd_Unit, 2) + '.' + RIGHT('0' + A.Kd_Sub, 2) + '.' + RIGHT('0' + A.Kd_UPB, 2) AS Kd_UPB_Gab,
			B.Nm_UPB AS Nm_UPB_Gab, A.Nm_Pimpinan, A.Nip_Pimpinan, A.Jbt_Pimpinan,
			A.Nm_Pengurus, A.Nip_Pengurus, A.Jbt_Pengurus, D.Nm_PimpDaerah, D. Jab_PimpDaerah
		FROM Ta_UPB A INNER JOIN
			Ref_UPB B ON A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
			(
			SELECT TOP 1 Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			FROM Ta_UPB
			WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			ORDER BY Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			) C ON A.Tahun = C.Tahun AND A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB INNER JOIN
			(
			SELECT Tahun, Kd_Prov, Kd_Kab_Kota, Nm_PimpDaerah, Jab_PimpDaerah
			FROM TA_PEMDA
			WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota)
			) D ON A.Tahun = D.Tahun AND A.Kd_Prov = D.Kd_Prov AND A.Kd_Kab_Kota = D.Kd_Kab_Kota
		) J
	GROUP BY I.Nm_Provinsi, A.Kd_Kab_Kota, H.Nm_Kab_Kota, F.Nm_Bidang, E.Nm_Unit, D.Nm_Sub_Unit,  J.Nm_UPB_Gab, A.Tahun, A.Kd_UPB, A.Kd_Sub, A.Kd_Unit, A.Kd_Bidang, A.Kd_Prov, A.Kd_Pemilik, B.Nm_Aset5, A.Kd_Aset5, A.Kd_Aset4, A.Kd_Aset3, A.Kd_Aset2, A.Kd_Aset1, A.Total, A.Reg1,  A.Reg2,
		 A.MerkType, A.No_Sertifikat,A.Bahan, A.Asal_usul, A.Ukuran, A.Satuan, A.Kondisi, A.Harga, J.Nm_PimpDaerah, J.Jab_PimpDaerah, A.No_SKGuna,  K.Tgl_SKGuna, A.Keterangan         	
	ORDER BY Kd_Gab_Brg--, A.No_Register





GO
