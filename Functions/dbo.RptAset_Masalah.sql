USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** RptAset_Masalah - 12122015 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE [dbo].[RptAset_Masalah] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE  @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3)
SET @Tahun = '2008'
SET @Kd_Prov	= '9'
SET @Kd_Kab_Kota= '0'
SET @Kd_Bidang	= '5'
SET @Kd_Unit	= '1'
SET @Kd_Sub	= '1'
SET @Kd_UPB	= '1'
*/
	IF ISNULL(@Kd_Prov, '') = '' SET @Kd_Prov = '%'
	IF ISNULL(@Kd_Kab_Kota, '') = '' SET @Kd_Kab_Kota = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'


DECLARE @TMP_DOKUMEN TABLE(Kd_Pemilik tinyint, Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB smallint, KD_JENIS TINYINT, JENIS_BRG VARCHAR(255), KD_GAB_BRG VARCHAR(15), NO_REGISTER INT,
	ALAMAT VARCHAR(255), HARGA MONEY, NO_DOKUMEN VARCHAR(255), KD_MASALAH TINYINT, KET_MASALAH VARCHAR(255), KD_LOKASI VARCHAR(255), KD_LOKASI_GRP VARCHAR(255))
--KIB A
INSERT INTO @TMP_DOKUMEN
SELECT	A.KD_PEMILIK, A.KD_PROV, A.KD_KAB_KOTA, A.KD_BIDANG, A.KD_UNIT, A.KD_SUB, A.KD_UPB, A.KD_ASET1, C.Nm_Aset1,
	REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Brg,
	A.NO_REGISTER, B.ALAMAT,
	SUM(A.HARGA) AS HARGA, A.SERTIFIKAT_NOMOR, NULL AS KD_MASALAH, NULL AS KET_MASALAH,
	dbo.fn_KdLokasi(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, @Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi,
	dbo.fn_KdLokasi3(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, @Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi_Grp
FROM	TA_KIB_A A INNER JOIN
	TA_SUB_UNIT B ON A.KD_PROV = B.KD_PROV AND A.KD_KAB_KOTA = B.KD_KAB_KOTA AND A.KD_BIDANG = B.KD_BIDANG AND A.KD_UNIT = B.KD_UNIT AND A.KD_SUB = B.KD_SUB INNER JOIN
	REF_REK_ASET1 C ON A.KD_ASET1 = C.KD_ASET1
WHERE	--(A.Kd_Masalah In(0,1,2,3,4)) AND	 
	A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit
	AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
GROUP BY A.KD_PEMILIK, A.KD_PROV, A.KD_KAB_KOTA, A.KD_BIDANG, A.KD_UNIT, A.KD_SUB, A.KD_UPB, A.KD_ASET1, C.NM_ASET1,
	A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.TGL_PEROLEHAN,
	A.NO_REGISTER, B.ALAMAT, A.HARGA, A.SERTIFIKAT_NOMOR--, A.KD_MASALAH, A.KET_MASALAH
ORDER BY A.KD_PEMILIK, A.KD_PROV, A.KD_KAB_KOTA, A.KD_BIDANG, A.KD_UNIT, A.KD_SUB, A.KD_UPB, A.NO_REGISTER

--KIB B
INSERT INTO @TMP_DOKUMEN
SELECT	A.KD_PEMILIK, A.KD_PROV, A.KD_KAB_KOTA, A.KD_BIDANG, A.KD_UNIT, A.KD_SUB, A.KD_UPB, A.KD_ASET1, C.Nm_Aset1,
	REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Brg,
	A.NO_REGISTER, B.ALAMAT, A.HARGA, A.NOMOR_BPKB,NULL AS KD_MASALAH, NULL AS KET_MASALAH,
	dbo.fn_KdLokasi(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, @Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi,
	dbo.fn_KdLokasi3(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, @Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi_Grp
FROM	TA_KIB_B A INNER JOIN
	TA_SUB_UNIT B ON A.KD_PROV = B.KD_PROV AND A.KD_KAB_KOTA = B.KD_KAB_KOTA AND A.KD_BIDANG = B.KD_BIDANG AND A.KD_UNIT = B.KD_UNIT AND A.KD_SUB = B.KD_SUB INNER JOIN
	REF_REK_ASET1 C ON A.KD_ASET1 = C.KD_ASET1
WHERE	--(A.Kd_Masalah In(0,1,2,3,4)) AND
	 A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit
	AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
GROUP BY A.KD_PEMILIK, A.KD_PROV, A.KD_KAB_KOTA, A.KD_BIDANG, A.KD_UNIT, A.KD_SUB, A.KD_UPB, A.KD_ASET1, C.NM_ASET1,
	A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.TGL_PEROLEHAN,
	A.NO_REGISTER, B.ALAMAT, A.HARGA, A.NOMOR_BPKB--, A.KD_MASALAH, A.KET_MASALAH
ORDER BY A.KD_PEMILIK, A.KD_PROV, A.KD_KAB_KOTA, A.KD_BIDANG, A.KD_UNIT, A.KD_SUB, A.KD_UPB, A.NO_REGISTER

--KIB C
INSERT INTO @TMP_DOKUMEN
SELECT	A.KD_PEMILIK, A.KD_PROV, A.KD_KAB_KOTA, A.KD_BIDANG, A.KD_UNIT, A.KD_SUB, A.KD_UPB, A.KD_ASET1, C.Nm_Aset1,
	REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Brg,
	A.NO_REGISTER, B.ALAMAT, A.HARGA, A.DOKUMEN_NOMOR, NULL AS KD_MASALAH, NULL AS KET_MASALAH,
	dbo.fn_KdLokasi(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, @Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi,
	dbo.fn_KdLokasi3(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, @Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi_Grp
FROM	TA_KIB_C A INNER JOIN
	TA_SUB_UNIT B ON A.KD_PROV = B.KD_PROV AND A.KD_KAB_KOTA = B.KD_KAB_KOTA AND A.KD_BIDANG = B.KD_BIDANG AND A.KD_UNIT = B.KD_UNIT AND A.KD_SUB = B.KD_SUB INNER JOIN
	REF_REK_ASET1 C ON A.KD_ASET1 = C.KD_ASET1
WHERE	--(A.Kd_Masalah In(0,1,2,3,4)) AND 
	A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit
	AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
GROUP BY A.KD_PEMILIK, A.KD_PROV, A.KD_KAB_KOTA, A.KD_BIDANG, A.KD_UNIT, A.KD_SUB, A.KD_UPB, A.KD_ASET1, C.NM_ASET1,
	A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.TGL_PEROLEHAN,
	A.NO_REGISTER, B.ALAMAT, A.HARGA, A.DOKUMEN_NOMOR--, A.KD_MASALAH, A.KET_MASALAH
ORDER BY A.KD_PEMILIK, A.KD_PROV, A.KD_KAB_KOTA, A.KD_BIDANG, A.KD_UNIT, A.KD_SUB, A.KD_UPB, A.NO_REGISTER


SELECT	RIGHT('0' + A.Kd_Prov,2) AS Kd_Prov, 
	RIGHT('0' + A.Kd_Prov,2)+'.'+RIGHT('0' + A.Kd_Kab_Kota,2) AS Kd_Kab_Kota_Gab,
	RIGHT('0' + A.Kd_Bidang,2) AS Kd_Bidang,
	RIGHT('0' + A.Kd_Kab_Kota,2)+'.'+ RIGHT('0' + A.Kd_Bidang,2) +'.'+ RIGHT('000' + A.Kd_Unit,3)AS Kd_Unit_Gab,
	RIGHT('0' + A.Kd_Prov,2)+'.'+RIGHT('0' + A.Kd_Kab_Kota,2)+'.'+ RIGHT('0' + A.Kd_Kab_Kota,2)+'.'+ RIGHT('0' + A.Kd_Bidang,2) +'.'+ RIGHT('000' + A.Kd_Unit,3)+'.'+RIGHT('000' + A.Kd_Sub,3) AS Kd_Sub_Gab,
	RIGHT('0' + A.Kd_Kab_Kota,2)+'.'+ RIGHT('0' + A.Kd_Bidang,2) +'.'+ RIGHT('000' + A.Kd_Unit,3)+'.'+RIGHT('000' + A.Kd_Sub,3)+'.'+ RIGHT('0000' + A.Kd_UPB,4) AS Kd_UPB_Gab,
	A.KD_LOKASI, A.KD_LOKASI_GRP, A.NO_REGISTER, UPPER(A.NM_PROVINSI) AS NM_PROVINSI, UPPER(A.NM_KAB_KOTA) AS NM_KAB_KOTA, UPPER(A.NM_PEMDA) AS NM_PEMDA, UPPER(A.NM_BIDANG) AS NM_BIDANG, UPPER(A.NM_UNIT)AS NM_UNIT, 
	UPPER(A.NM_SUB_UNIT) AS NM_SUB_UNIT, UPPER(A.NM_UPB) AS NM_UPB, A.KD_PEMILIK, A.KD_JENIS, A.JENIS_BRG, KD_GAB_BRG,
	A.ALAMAT, (A.HARGA/1000) AS HARGA, A.NO_DOKUMEN, A.KD_MASALAH, A.KET_MASALAH
FROM
	(
	SELECT	RIGHT('0' + A.KD_PROV,2) AS KD_PROV, RIGHT('0' + A.KD_KAB_KOTA,2) AS KD_KAB_KOTA, RIGHT('0' + A.KD_BIDANG, 2) AS KD_BIDANG,
		RIGHT('0' + A.KD_UNIT,2) AS KD_UNIT, RIGHT('0' + A.KD_SUB,2) AS KD_SUB, RIGHT('0' + A.KD_UPB, 2) AS KD_UPB, A.KD_JENIS, A.JENIS_BRG, A.KD_GAB_BRG,
		A.NO_REGISTER, B.NM_PROVINSI, C.NM_KAB_KOTA, H.NM_PEMDA, D.NM_BIDANG, E.NM_UNIT, F.NM_SUB_UNIT, G.NM_UPB, A.KD_PEMILIK, A.ALAMAT, A.HARGA, A.NO_DOKUMEN, 
		A.KD_MASALAH, A.KET_MASALAH, A.KD_LOKASI, A.KD_LOKASI_GRP
		
	FROM	@TMP_DOKUMEN A INNER JOIN
		REF_PROVINSI B ON A.KD_PROV = B.KD_PROV INNER JOIN
		REF_KAB_KOTA C ON A.KD_PROV = C.KD_PROV AND A.KD_KAB_KOTA = C.KD_KAB_KOTA INNER JOIN
		REF_BIDANG D ON A.KD_BIDANG = D.KD_BIDANG INNER JOIN
		REF_UNIT E ON A.KD_PROV = E.KD_PROV AND A.KD_KAB_KOTA = E.KD_KAB_KOTA AND A.KD_BIDANG = E.KD_BIDANG AND A.KD_UNIT = E.KD_UNIT INNER JOIN
		REF_SUB_UNIT F ON A.KD_PROV = F.KD_PROV AND A.KD_KAB_KOTA = F.KD_KAB_KOTA AND A.KD_BIDANG = F.KD_BIDANG AND A.KD_UNIT = F.KD_UNIT AND A.KD_SUB = F.KD_SUB INNER JOIN
		REF_UPB G ON A.KD_PROV = G.KD_PROV AND A.KD_KAB_KOTA = G.KD_KAB_KOTA AND A.KD_BIDANG = G.KD_BIDANG AND A.KD_UNIT = G.KD_UNIT AND A.KD_SUB = G.KD_SUB AND A.KD_UPB = G.KD_UPB INNER JOIN
		REF_PEMDA H ON A.KD_PROV = H.KD_PROV AND A.KD_KAB_KOTA = H.KD_KAB_KOTA
	GROUP BY A.KD_PROV, A.KD_KAB_KOTA, A.KD_BIDANG,	A.KD_UNIT, A.KD_SUB, A.KD_UPB, A.KD_JENIS, A.JENIS_BRG, A.KD_GAB_BRG, A.NO_REGISTER, 
		 B.NM_PROVINSI, C.NM_KAB_KOTA, H.NM_PEMDA, D.NM_BIDANG, E.NM_UNIT, F.NM_SUB_UNIT, G.NM_UPB, A.KD_PEMILIK, 
		 A.ALAMAT, A.HARGA, A.NO_DOKUMEN, A.KD_MASALAH, A.KET_MASALAH, A.KD_LOKASI, A.KD_LOKASI_GRP
	) A
GROUP BY	A.KD_PROV, A.KD_KAB_KOTA, A.KD_BIDANG, A.KD_UNIT, A.KD_SUB, A.KD_UPB, A.KD_JENIS, A.JENIS_BRG, A.KD_GAB_BRG, 
		A.KD_LOKASI, A.KD_LOKASI_GRP, A.NO_REGISTER,
		A.NM_PROVINSI, A.NM_KAB_KOTA, A.NM_PEMDA, A.NM_BIDANG, A.NM_UNIT, A.NM_SUB_UNIT, A.NM_UPB, A.KD_PEMILIK, 
		A.ALAMAT, A.HARGA, A.NO_DOKUMEN, A.KD_MASALAH, A.KET_MASALAH
ORDER BY	A.KD_PROV, A.KD_KAB_KOTA, A.KD_BIDANG, A.KD_UNIT, A.KD_SUB, A.KD_UPB, A.KD_JENIS

GO
