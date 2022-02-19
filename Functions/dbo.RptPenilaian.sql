USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[RptPenilaian] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D1 datetime, @D2 datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D1 datetime, @D2 datetime
SET @Tahun = '2013'
SET @Kd_Prov = '28'
SET @Kd_Kab_Kota = '6'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @D1 = '20130101'
SET @D2 = '20131231'
*/
	DECLARE @tmpBI TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, Kd_Pemilik tinyint, No_Register int, 
		Tgl_Perolehan datetime, Tgl_Pembukuan datetime, Merk varchar(50), Type varchar(50), No_Sertifikat varchar(100), Bahan varchar(50), Asal_Usul varchar(50), Ukuran varchar(50), Satuan varchar(50), Kondisi varchar(20), Harga money)

        DECLARE @tmpBI_btw TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, Kd_Pemilik tinyint, No_Register int, 
		Tgl_Perolehan datetime, Tgl_Pembukuan datetime, Merk varchar(50), Type varchar(50), No_Sertifikat varchar(100), Bahan varchar(50), Asal_Usul varchar(50), Ukuran varchar(50), Satuan varchar(50), Kondisi varchar(20), Harga money, Kd_Mutasi tinyint, Kd_Riwayat tinyint)

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Sertifikat_Nomor, '-'), '', A.Asal_usul, A.Luas_M2, 'M2', 'Baik', A.Harga
	FROM fn_Kartu_BrgA_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Merk, A.Type,
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
		A.Bahan, A.Asal_usul, A.CC, '', B.Uraian AS Kondisi, A.Harga
	FROM fn_Kartu_BrgB_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A LEFT OUTER JOIN
		Ref_Kondisi B On A.Kondisi = B.Kd_Kondisi
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Dokumen_Nomor, '-'), REPLACE(A.Beton_Tidak, 'Tidak', ''), A.Asal_usul, A.Luas_Lantai, 'M2', 
		B.Uraian AS Kondisi, A.Harga
	FROM fn_Kartu_BrgC_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A LEFT OUTER JOIN
		Ref_Kondisi B On A.Kondisi = B.Kd_Kondisi
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Dokumen_Nomor, '-'), A.Konstruksi, A.Asal_usul, A.Luas, 'M2', 
		B.Uraian AS Kondisi, A.Harga
	FROM fn_Kartu_BrgD_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A LEFT OUTER JOIN
		Ref_Kondisi B On A.Kondisi = B.Kd_Kondisi
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', '-',
		CASE A.Kd_Aset2
		WHEN 18 THEN A.Bahan
		WHEN 17 THEN A.Bahan
		ELSE '-'
		END, A.Asal_usul, A.Ukuran,
		CASE A.Kd_Aset2
		WHEN 19 THEN A.Bahan
		ELSE ''
		END, B.Uraian AS Kondisi, A.Harga
	FROM fn_Kartu_BrgE_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A LEFT OUTER JOIN
		Ref_Kondisi B On A.Kondisi = B.Kd_Kondisi
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 6, 20, 1, 1, 1,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Dokumen_Nomor , '-'), REPLACE(A.Beton_tidak, 'Tidak', ''), A.Asal_usul, A.Kondisi, '', 'Baik', A.Harga
	FROM fn_Kartu_BrgF_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

        INSERT INTO @tmpBI_btw
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Sertifikat_Nomor, '-'), '', A.Asal_usul, A.Luas_M2, 'M2', 'Baik', A.Harga, A.Kd_Mutasi, B.Kd_Riwayat
	FROM fn_Kartu_BrgA_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A INNER JOIN
		Ta_KIBAR B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
		       		A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
		       		A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND B.Kd_Riwayat = 21

	INSERT INTO @tmpBI_btw
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Merk, A.Type,
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
		A.Bahan, A.Asal_usul, A.CC, '', C.Uraian AS Kondisi, A.Harga, A.Kd_Mutasi, B.Kd_Riwayat
	FROM fn_Kartu_BrgB_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A INNER JOIN
		Ta_KIBBR B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
		       		A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
		       		A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register  LEFT OUTER JOIN
		Ref_Kondisi C On A.Kondisi = C.Kd_Kondisi		
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND B.Kd_Riwayat = 21

	INSERT INTO @tmpBI_btw
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Dokumen_Nomor, '-'), REPLACE(A.Beton_Tidak, 'Tidak', ''), A.Asal_usul, A.Luas_Lantai, 'M2', 
		C.Uraian AS Kondisi, A.Harga, A.Kd_Mutasi, B.Kd_Riwayat
	FROM fn_Kartu_BrgC_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A INNER JOIN
		Ta_KIBCR B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
		       		A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
		       		A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register LEFT OUTER JOIN
		Ref_Kondisi C On A.Kondisi = C.Kd_Kondisi
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND B.Kd_Riwayat = 21

	INSERT INTO @tmpBI_btw
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Dokumen_Nomor, '-'), A.Konstruksi, A.Asal_usul, A.Luas, 'M2', 
		C.Uraian AS Kondisi, A.Harga, A.Kd_Mutasi, B.Kd_Riwayat
	FROM fn_Kartu_BrgD_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A INNER JOIN
		Ta_KIBDR B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
		       		A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
		       		A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register LEFT OUTER JOIN
		Ref_Kondisi C On A.Kondisi = C.Kd_Kondisi
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND B.Kd_Riwayat = 21

	INSERT INTO @tmpBI_btw
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', '-',
		CASE A.Kd_Aset2
		WHEN 18 THEN A.Bahan
		WHEN 17 THEN A.Bahan
		ELSE '-'
		END, A.Asal_usul, A.Ukuran,
		CASE A.Kd_Aset2
		WHEN 19 THEN A.Bahan
		ELSE ''
		END, C.Uraian AS Kondisi, A.Harga, A.Kd_Mutasi, B.Kd_Riwayat
	FROM fn_Kartu_BrgE_btw(@D1, @D2,@Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A INNER JOIN
		Ta_KIBER B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
		       		A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
		       		A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register LEFT OUTER JOIN
		Ref_Kondisi C On A.Kondisi = C.Kd_Kondisi
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND B.Kd_Riwayat = 21
	/*
	INSERT INTO @tmpBI_btw
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 6, 20, 1, 1, 1,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Dokumen_Nomor , '-'), REPLACE(A.Beton_tidak, 'Tidak', ''), A.Asal_usul, A.Kondisi, '', 'Baik', A.Harga, A.Kd_Mutasi
	FROM fn_Kartu_BrgF_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	*/

	SELECT J.Kd_UPBA, I.Nm_Provinsi, 
		CASE A.Kd_Kab_Kota
		WHEN 0 THEN I.Nm_Provinsi
		ELSE H.Nm_Kab_Kota
		END AS Nm_Kab_Kota, F.Nm_Bidang, E.Nm_Unit, D.Nm_Sub_Unit, J.Nm_UPB_Gab, UPPER(K.Nm_Pemilik) AS Nm_Pemilik,
		dbo.fn_KdLokasi2(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, @Kd_UPB) AS Kd_Lokasi,
		B.Nm_Aset5, REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Brg,
		CASE WHEN A.Total1 + A.Total2 + A.Total3 = 1 THEN-- RIGHT('0000' + CONVERT(varchar, A.Reg1), 4)
			CASE
			WHEN A.Reg1 <> 0 THEN RIGHT('0000' + CONVERT(varchar, A.Reg1), 4)
			WHEN A.Reg2 <> 0 THEN RIGHT('0000' + CONVERT(varchar, A.Reg2), 4)  --ini yang diperbaiki
			WHEN A.Reg3 <> 0 THEN RIGHT('0000' + CONVERT(varchar, A.Reg3), 4)
			END
		ELSE '0001 s/d ' + RIGHT('0000' + CONVERT(varchar, A.Total1 + A.Total2 + A.Total3), 4)
		END AS No_Register, 
		CASE
		WHEN (ISNULL(A.Merk, '') <> '') AND (ISNULL(A.Type, '') <> '') THEN A.Merk + ' / ' + A.Type
		WHEN (ISNULL(A.Merk, '') <> '') THEN A.Merk
		WHEN (ISNULL(A.Type, '') <> '') THEN A.Type
		ELSE '-'
		END AS MerkType, 
		A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi, 
		A.Total1, A.Harga1, A.Total2, A.Harga2, A.Total3, A.Harga3,
		A.Total1 - A.Total2 + A.Total3 AS Total,
		A.Harga1 - A.Harga2 + A.Harga3 AS Harga,
		J.Nm_Pimpinan, J.Nip_Pimpinan, J.Jbt_Pimpinan, J.Nm_Pengurus, J.Nip_Pengurus, J.Jbt_Pengurus
	FROM
		(
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
			A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik,
			A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi,
			MIN(A.Reg1) AS Reg1, SUM(A.Total1) AS Total1, SUM(A.Harga1) AS Harga1,
			MIN(A.Reg2) AS Reg2, SUM(A.Total2) AS Total2, SUM(A.Harga2) AS Harga2,
			MIN(A.Reg3) AS Reg3, SUM(A.Total3) AS Total3, SUM(A.Harga3) AS Harga3
		FROM
			(
			SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
				A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik,
				A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi,
				MIN(A.No_Register) AS Reg1, COUNT(*) AS Total1, SUM(A.Harga) AS Harga1, 0 AS Reg2, 0 AS Total2, 0 AS Harga2, 0 AS Reg3, 0 AS Total3, 0 AS Harga3
			FROM @tmpBI A
			--WHERE (A.Tgl_Pembukuan < @D1)
			GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
				A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik,
				A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi
	
			UNION ALL
	
			SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
				A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik,
				A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi,
				0 AS Reg1, 0 AS Total1, 0 AS Harga1, 0 AS Reg2, 0 AS Total2, 0 AS Harga2, MIN(A.No_Register) AS Reg3, COUNT(*) AS Total3, SUM(A.Harga) AS Harga3
			FROM @tmpBI_btw A 
			WHERE /*(A.Tgl_Pembukuan BETWEEN @D1 AND @D2)*/ A.Kd_Mutasi IN (1) 
			GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
				A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik,
				A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi
	
			UNION ALL
	
                        SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
				A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik,
				A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi,
				0 AS Reg1, 0 AS Total1, 0 AS Harga1, 0 AS Reg2, 0 AS Total2, 0 AS Harga2, MIN(A.No_Register) AS Reg3, 0 AS Total3, SUM(A.Harga) AS Harga3
			FROM @tmpBI_btw A 
			WHERE /*(A.Tgl_Pembukuan BETWEEN @D1 AND @D2)*/ A.Kd_Mutasi IN (4) 
			GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
				A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik,
				A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi
			/*
			UNION ALL

			SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
				A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik,
				A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi,
				0 AS Reg1, 0 AS Total1, 0 AS Harga1, MIN(A.No_Register) AS Reg2, COUNT(*) AS Total2, SUM(A.Harga) AS Harga2, 0 AS Reg3, 0 AS Total3, 0 AS Harga3
			FROM @tmpBI_btw A 
			WHERE A.Kd_Mutasi IN (2,3)
			GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
				A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik,
				A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi
			
                        UNION ALL

			SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
				A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik,
				A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi,
				0 AS Reg1, 0 AS Total1, 0 AS Harga1, MIN(A.No_Register) AS Reg2, 0 AS Total2, SUM(A.Harga) AS Harga2, 0 AS Reg3, 0 AS Total3, 0 AS Harga3
			FROM @tmpBI_btw A 
			WHERE A.Kd_Mutasi IN (5)
			GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
				A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik,
				A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi
			*/
			) A
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
			A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik,
			A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi
		) A INNER JOIN
		Ref_Rek_Aset5 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
		Ref_Sub_Unit D ON A.Kd_Bidang = D.Kd_Bidang AND A.Kd_Unit = D.Kd_Unit AND A.Kd_Sub = D.Kd_Sub INNER JOIN
		Ref_Unit E ON D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
		Ref_Bidang F ON E.Kd_Bidang = F.Kd_Bidang INNER JOIN
		Ref_Pemda G ON A.Kd_Prov = G.Kd_Prov AND A.Kd_Kab_Kota = G.Kd_Kab_Kota INNER JOIN
		Ref_Kab_Kota H ON G.Kd_Prov = H.Kd_Prov AND G.Kd_Kab_Kota = H.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi I ON H.Kd_Prov = I.Kd_Prov INNER JOIN
		Ref_Pemilik K ON A.Kd_Pemilik = K.Kd_Pemilik,
		(
		SELECT @Kd_UPB AS Kd_UPBA, 
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) + '.' + RIGHT('0' + @Kd_Sub, 2) + '.' + RIGHT('0' + @Kd_UPB, 2) AS Kd_UPB_Gab,
			B.Nm_UPB AS Nm_UPB_Gab, A.Nm_Pimpinan, A.Nip_Pimpinan, A.Jbt_Pimpinan,
			A.Nm_Pengurus, A.Nip_Pengurus, A.Jbt_Pengurus
		FROM Ta_UPB A INNER JOIN
			Ref_UPB B ON A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
			(
			SELECT TOP 1 Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			FROM Ta_UPB
			WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			ORDER BY Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			) C ON A.Tahun = C.Tahun AND A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
		) J
	WHERE A.Harga3 <> 0
	ORDER BY Kd_Lokasi, Kd_Gab_Brg, No_Register

GO
