USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.RptLMB_Tambah @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D1 datetime, @D2 datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D1 datetime, @D2 datetime
SET @Tahun = '2016'
SET @Kd_Prov = '0'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '4'
SET @Kd_Unit = '2'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @D1 = '20160101'
SET @D2 = '20161231'
*/
	DECLARE @tmpBI TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, Kd_Pemilik tinyint, No_Register int, 
		Tgl_Perolehan datetime, Tgl_Pembukuan datetime, Merk varchar(50), Type varchar(50), No_Sertifikat varchar(100), Bahan varchar(50), Asal_Usul varchar(50), Ukuran varchar(50), Satuan varchar(50), Kondisi varchar(20), Harga money)

        DECLARE @tmpBI_btw TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, Kd_Pemilik tinyint, No_Register int, 
		Tgl_Perolehan datetime, Tgl_Pembukuan datetime, Merk varchar(50), Type varchar(50), No_Sertifikat varchar(100), Bahan varchar(50), Asal_Usul varchar(50), Ukuran varchar(50), Satuan varchar(50), Kondisi varchar(20), Harga money, Kd_Mutasi tinyint)

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
------------

--------
		
	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Sertifikat_Nomor, '-'), '', A.Asal_usul, A.Luas_M2, 'M2', 'Baik', A.Harga
	FROM fn_Kartu_BrgA_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A LEFT OUTER JOIN
		TA_KIB_A C ON A.KD_PROV = C.KD_PROV AND A.KD_KAB_KOTA = C.KD_KAB_KOTA AND A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT AND A.KD_SUB = C.KD_SUB AND A.KD_UPB = C.KD_UPB
				AND A.KD_ASET1 = C.KD_ASET1 AND A.KD_ASET2 = C.KD_ASET2 AND A.KD_ASET3 = C.KD_ASET3 AND A.KD_ASET4 = C.KD_ASET4 AND A.KD_ASET5 = C.KD_ASET5 AND A.NO_REGISTER = C.NO_REGISTER
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.TGL_PEROLEHAN BETWEEN @D1 AND @D2 AND C.KD_HAPUS = 0

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
		Ref_Kondisi B On A.Kondisi = B.Kd_Kondisi LEFT OUTER JOIN
		TA_KIB_B C ON A.KD_PROV = C.KD_PROV AND A.KD_KAB_KOTA = C.KD_KAB_KOTA AND A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT AND A.KD_SUB = C.KD_SUB AND A.KD_UPB = C.KD_UPB
				AND A.KD_ASET1 = C.KD_ASET1 AND A.KD_ASET2 = C.KD_ASET2 AND A.KD_ASET3 = C.KD_ASET3 AND A.KD_ASET4 = C.KD_ASET4 AND A.KD_ASET5 = C.KD_ASET5 AND A.NO_REGISTER = C.NO_REGISTER
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.TGL_PEROLEHAN BETWEEN @D1 AND @D2 AND C.KD_HAPUS = 0

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Dokumen_Nomor, '-'), REPLACE(A.Beton_Tidak, 'Tidak', ''), A.Asal_usul, A.Luas_Lantai, 'M2', 
		B.Uraian AS Kondisi, A.Harga
	FROM fn_Kartu_BrgC_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A LEFT OUTER JOIN
		Ref_Kondisi B On A.Kondisi = B.Kd_Kondisi LEFT OUTER JOIN
		TA_KIB_C C ON A.KD_PROV = C.KD_PROV AND A.KD_KAB_KOTA = C.KD_KAB_KOTA AND A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT AND A.KD_SUB = C.KD_SUB AND A.KD_UPB = C.KD_UPB
				AND A.KD_ASET1 = C.KD_ASET1 AND A.KD_ASET2 = C.KD_ASET2 AND A.KD_ASET3 = C.KD_ASET3 AND A.KD_ASET4 = C.KD_ASET4 AND A.KD_ASET5 = C.KD_ASET5 AND A.NO_REGISTER = C.NO_REGISTER
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.TGL_PEROLEHAN BETWEEN @D1 AND @D2 AND C.KD_HAPUS = 0
	

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Dokumen_Nomor, '-'), 
		A.Konstruksi, A.Asal_usul, A.Luas, 'M2', 
		B.Uraian AS Kondisi, A.Harga
	FROM fn_Kartu_BrgD_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A LEFT OUTER JOIN
		Ref_Kondisi B On A.Kondisi = B.Kd_Kondisi LEFT OUTER JOIN
		TA_KIB_D C ON A.KD_PROV = C.KD_PROV AND A.KD_KAB_KOTA = C.KD_KAB_KOTA AND A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT AND A.KD_SUB = C.KD_SUB AND A.KD_UPB = C.KD_UPB
				AND A.KD_ASET1 = C.KD_ASET1 AND A.KD_ASET2 = C.KD_ASET2 AND A.KD_ASET3 = C.KD_ASET3 AND A.KD_ASET4 = C.KD_ASET4 AND A.KD_ASET5 = C.KD_ASET5 AND A.NO_REGISTER = C.NO_REGISTER
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.TGL_PEROLEHAN BETWEEN @D1 AND @D2 AND C.KD_HAPUS = 0


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
		Ref_Kondisi B On A.Kondisi = B.Kd_Kondisi LEFT OUTER JOIN
		TA_KIB_E C ON A.KD_PROV = C.KD_PROV AND A.KD_KAB_KOTA = C.KD_KAB_KOTA AND A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT AND A.KD_SUB = C.KD_SUB AND A.KD_UPB = C.KD_UPB
				AND A.KD_ASET1 = C.KD_ASET1 AND A.KD_ASET2 = C.KD_ASET2 AND A.KD_ASET3 = C.KD_ASET3 AND A.KD_ASET4 = C.KD_ASET4 AND A.KD_ASET5 = C.KD_ASET5 AND A.NO_REGISTER = C.NO_REGISTER
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.TGL_PEROLEHAN BETWEEN @D1 AND @D2 AND C.KD_HAPUS = 0

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 6, 20, 1, 1, 1,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Dokumen_Nomor , '-'), REPLACE(A.Beton_tidak, 'Tidak', ''), A.Asal_usul, A.Kondisi, '', 'Baik', A.Harga
	FROM fn_Kartu_BrgF_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.TGL_PEROLEHAN BETWEEN @D1 AND @D2
---aset lain
	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Judul , '-'),  ISNULL(A.Pencipta , '-'), A.Asal_usul, A.Kondisi, '', 'Baik', A.Harga
	FROM fn_Kartu_BrgL_awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A LEFT OUTER JOIN
		TA_LAINNYA C ON A.KD_PROV = C.KD_PROV AND A.KD_KAB_KOTA = C.KD_KAB_KOTA AND A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT AND A.KD_SUB = C.KD_SUB AND A.KD_UPB = C.KD_UPB
				AND A.KD_ASET1 = C.KD_ASET1 AND A.KD_ASET2 = C.KD_ASET2 AND A.KD_ASET3 = C.KD_ASET3 AND A.KD_ASET4 = C.KD_ASET4 AND A.KD_ASET5 = C.KD_ASET5 AND A.NO_REGISTER = C.NO_REGISTER
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.TGL_PEROLEHAN BETWEEN @D1 AND @D2 --AND C.KD_HAPUS = 0

        INSERT INTO @tmpBI_btw
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Sertifikat_Nomor, '-'), '', A.Asal_usul, A.Luas_M2, 'M2', 'Baik', A.Harga, A.Kd_Mutasi
	FROM fn_Kartu_BrgA_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A LEFT OUTER JOIN
		TA_KIB_A C ON A.KD_PROV = C.KD_PROV AND A.KD_KAB_KOTA = C.KD_KAB_KOTA AND A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT AND A.KD_SUB = C.KD_SUB AND A.KD_UPB = C.KD_UPB
				AND A.KD_ASET1 = C.KD_ASET1 AND A.KD_ASET2 = C.KD_ASET2 AND A.KD_ASET3 = C.KD_ASET3 AND A.KD_ASET4 = C.KD_ASET4 AND A.KD_ASET5 = C.KD_ASET5 AND A.NO_REGISTER = C.NO_REGISTER
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.TGL_PEROLEHAN BETWEEN @D1 AND @D2 AND C.KD_HAPUS = 0

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
		A.Bahan, A.Asal_usul, A.CC, '', B.Uraian AS Kondisi, A.Harga, A.Kd_Mutasi
	FROM fn_Kartu_BrgB_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A LEFT OUTER JOIN
		Ref_Kondisi B On A.Kondisi = B.Kd_Kondisi LEFT OUTER JOIN
		TA_KIB_B C ON A.KD_PROV = C.KD_PROV AND A.KD_KAB_KOTA = C.KD_KAB_KOTA AND A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT AND A.KD_SUB = C.KD_SUB AND A.KD_UPB = C.KD_UPB
				AND A.KD_ASET1 = C.KD_ASET1 AND A.KD_ASET2 = C.KD_ASET2 AND A.KD_ASET3 = C.KD_ASET3 AND A.KD_ASET4 = C.KD_ASET4 AND A.KD_ASET5 = C.KD_ASET5 AND A.NO_REGISTER = C.NO_REGISTER
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.TGL_PEROLEHAN BETWEEN @D1 AND @D2 AND C.KD_HAPUS = 0
	

	INSERT INTO @tmpBI_btw
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Dokumen_Nomor, '-'), REPLACE(A.Beton_Tidak, 'Tidak', ''), A.Asal_usul, A.Luas_Lantai, 'M2', 
		B.Uraian AS Kondisi, A.Harga, A.Kd_Mutasi
	FROM fn_Kartu_BrgC_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A LEFT OUTER JOIN
		Ref_Kondisi B On A.Kondisi = B.Kd_Kondisi LEFT OUTER JOIN
		TA_KIB_C C ON A.KD_PROV = C.KD_PROV AND A.KD_KAB_KOTA = C.KD_KAB_KOTA AND A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT AND A.KD_SUB = C.KD_SUB AND A.KD_UPB = C.KD_UPB
				AND A.KD_ASET1 = C.KD_ASET1 AND A.KD_ASET2 = C.KD_ASET2 AND A.KD_ASET3 = C.KD_ASET3 AND A.KD_ASET4 = C.KD_ASET4 AND A.KD_ASET5 = C.KD_ASET5 AND A.NO_REGISTER = C.NO_REGISTER
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.TGL_PEROLEHAN BETWEEN @D1 AND @D2 AND C.KD_HAPUS = 0

	INSERT INTO @tmpBI_btw
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Dokumen_Nomor, '-'), A.Konstruksi, A.Asal_usul, A.Luas, 'M2', 
		B.Uraian AS Kondisi, A.Harga, A.Kd_Mutasi
	FROM fn_Kartu_BrgD_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A LEFT OUTER JOIN
		Ref_Kondisi B On A.Kondisi = B.Kd_Kondisi LEFT OUTER JOIN
		TA_KIB_D C ON A.KD_PROV = C.KD_PROV AND A.KD_KAB_KOTA = C.KD_KAB_KOTA AND A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT AND A.KD_SUB = C.KD_SUB AND A.KD_UPB = C.KD_UPB
				AND A.KD_ASET1 = C.KD_ASET1 AND A.KD_ASET2 = C.KD_ASET2 AND A.KD_ASET3 = C.KD_ASET3 AND A.KD_ASET4 = C.KD_ASET4 AND A.KD_ASET5 = C.KD_ASET5 AND A.NO_REGISTER = C.NO_REGISTER
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.TGL_PEROLEHAN BETWEEN @D1 AND @D2 AND C.KD_HAPUS = 0

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
		END, B.Uraian AS Kondisi, A.Harga, A.Kd_Mutasi
	FROM fn_Kartu_BrgE_btw(@D1, @D2,@Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A LEFT OUTER JOIN
		Ref_Kondisi B On A.Kondisi = B.Kd_Kondisi LEFT OUTER JOIN
		TA_KIB_E C ON A.KD_PROV = C.KD_PROV AND A.KD_KAB_KOTA = C.KD_KAB_KOTA AND A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT AND A.KD_SUB = C.KD_SUB AND A.KD_UPB = C.KD_UPB
				AND A.KD_ASET1 = C.KD_ASET1 AND A.KD_ASET2 = C.KD_ASET2 AND A.KD_ASET3 = C.KD_ASET3 AND A.KD_ASET4 = C.KD_ASET4 AND A.KD_ASET5 = C.KD_ASET5 AND A.NO_REGISTER = C.NO_REGISTER
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.TGL_PEROLEHAN BETWEEN @D1 AND @D2 AND C.KD_HAPUS = 0

	INSERT INTO @tmpBI_btw
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 6, 20, 1, 1, 1,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Dokumen_Nomor , '-'), REPLACE(A.Beton_tidak, 'Tidak', ''), A.Asal_usul, A.Kondisi, '', 'Baik', A.Harga, A.Kd_Mutasi
	FROM fn_Kartu_BrgF_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.TGL_PEROLEHAN BETWEEN @D1 AND @D2

	INSERT INTO @tmpBI_btw	
	SELECT 	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Judul , '-') AS Judul,  ISNULL(A.Pencipta , '-') As Pencipta, A.Asal_usul, A.Kondisi, '', 'Baik', A.Harga, A.Kd_Mutasi
	FROM fn_Kartu_BrgL_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A LEFT OUTER JOIN
		TA_LAINNYA C ON A.KD_PROV = C.KD_PROV AND A.KD_KAB_KOTA = C.KD_KAB_KOTA AND A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT AND A.KD_SUB = C.KD_SUB AND A.KD_UPB = C.KD_UPB
				AND A.KD_ASET1 = C.KD_ASET1 AND A.KD_ASET2 = C.KD_ASET2 AND A.KD_ASET3 = C.KD_ASET3 AND A.KD_ASET4 = C.KD_ASET4 AND A.KD_ASET5 = C.KD_ASET5 AND A.NO_REGISTER = C.NO_REGISTER
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.TGL_PEROLEHAN BETWEEN @D1 AND @D2 --AND C.KD_HAPUS = 0

---------------

	SELECT J.Kd_UPBA, I.Nm_Provinsi, CASE A.Kd_Kab_Kota WHEN 0 THEN I.Nm_Provinsi ELSE H.Nm_Kab_Kota END AS Nm_Kab_Kota, 
	F.Nm_Bidang, E.Nm_Unit, D.Nm_Sub_Unit, J.Nm_UPB_Gab, UPPER(K.Nm_Pemilik) AS Nm_Pemilik, YEAR (A.Tgl_Perolehan) AS Thn_Perolehan, A.Tgl_Pembukuan,
	dbo.fn_KdLokasi2(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, @Kd_UPB) AS Kd_Lokasi, A.Kd_Aset1, L.Nm_Aset1,
	B.Nm_Aset5, REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Brg,
	CASE WHEN A.TOTAL = 1 THEN
	CASE WHEN A.Reg3 <> 0 THEN RIGHT('0000' + CONVERT(varchar, A.Reg3), 4)
	END
	ELSE RIGHT('0000' +CONVERT(varchar, A.Reg3), 4) + ' s/d ' + RIGHT('0000' + CONVERT(varchar, SUM(A.REG3+A.TOTAL-1)), 4)
	END AS No_register,
	CASE
	WHEN (ISNULL(A.Merk, '') <> '') AND (ISNULL(A.Type, '') <> '') THEN A.Merk + ' / ' + A.Type
	WHEN (ISNULL(A.Merk, '') <> '') THEN A.Merk
	WHEN (ISNULL(A.Type, '') <> '') THEN A.Type
	ELSE '-'
	END AS MerkType, 
	ISNULL(A.No_Sertifikat, '-') AS No_Sertifikat, ISNULL(A.Bahan,'-') AS Bahan, ISNULL(A.Asal_Usul, '-') AS Asal_Usul, ISNULL(A.Ukuran, '-') AS Ukuran, ISNULL(A.Satuan,'-') AS Satuan, ISNULL(A.Kondisi, '-') AS Kondisi, 
	SUM(A.Total) AS Total,
	SUM(A.Harga3) AS Harga,
	J.Nm_Pimpinan, J.Nip_Pimpinan, J.Jbt_Pimpinan, J.Nm_Pengurus, J.Nip_Pengurus, J.Jbt_Pengurus
	FROM
	(

		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
			A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik,A.Tgl_Perolehan, A.Tgl_Pembukuan,
			A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi,
			A.Reg3, A.Total, A.Harga3
		FROM
		(
			SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
				A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan,
				A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi,
				MIN(A.No_Register) AS Reg3,  COUNT(*) AS Total, SUM(A.Harga) AS Harga3
			FROM @tmpBI_btw A 
			WHERE A.Kd_Mutasi IN (1,2,3,4,5) 
			GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
				A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan,
				A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi
		) A
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
			A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik,A.Tgl_Perolehan, A.Tgl_Pembukuan,
			A.Merk, A.Type, A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi, A.Reg3, A.Total, A.Harga3
		) A INNER JOIN
		Ref_Rek_Aset5 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
		Ref_Sub_Unit D ON A.Kd_Bidang = D.Kd_Bidang AND A.Kd_Unit = D.Kd_Unit AND A.Kd_Sub = D.Kd_Sub INNER JOIN
		Ref_Unit E ON D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
		Ref_Bidang F ON E.Kd_Bidang = F.Kd_Bidang INNER JOIN
		Ref_Pemda G ON A.Kd_Prov = G.Kd_Prov AND A.Kd_Kab_Kota = G.Kd_Kab_Kota INNER JOIN
		Ref_Kab_Kota H ON G.Kd_Prov = H.Kd_Prov AND G.Kd_Kab_Kota = H.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi I ON H.Kd_Prov = I.Kd_Prov INNER JOIN
		Ref_Rek_Aset1 L ON A.Kd_Aset1 = L.Kd_Aset1  INNER JOIN
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
	WHERE A.Harga3 <>0
	GROUP BY J.Kd_UPBA, I.Nm_Provinsi, I.Nm_Provinsi, A.Kd_Kab_Kota, H.Nm_Kab_Kota, F.Nm_Bidang , E.Nm_Unit, D.Nm_Sub_Unit, J.Nm_UPB_Gab,
		K.Nm_Pemilik, A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, B.Nm_Aset5, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Merk, A.Type, A.No_Sertifikat,  A.Tgl_Perolehan, A.Tgl_Pembukuan,
		A.Bahan, A.Asal_Usul, A.Ukuran,  A.Satuan, A.Kondisi,
		A.Total, A.Harga3,A.Reg3, L.Nm_aset1,
		J.Nm_Pimpinan, J.Nip_Pimpinan, J.Jbt_Pimpinan,  J.Nm_Pengurus, J.Nip_Pengurus,J.Jbt_Pengurus
	ORDER BY Kd_Lokasi, Kd_Gab_Brg, No_Register



GO
