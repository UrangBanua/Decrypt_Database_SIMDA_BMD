USE bmd_hst2020
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_Kartu_BrgE_btw (@D1 Datetime, @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(6))

RETURNS @UpdateKIB TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint,  Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int, 
			 Kd_ASet1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, 
			 No_Register int, Kd_Ruang int, Kd_Pemilik tinyint, Tgl_Perolehan Datetime , Tgl_Pembukuan Datetime, Tgl_Dokumen Datetime, No_Dokumen Varchar(100),  Judul Varchar(255), Pencipta Varchar(255), Bahan Varchar(50), Ukuran Varchar(50),
			 Asal_usul Varchar(50), Kondisi Varchar(2), Harga money, Masa_Manfaat smallint, Nilai_Sisa money, Keterangan Varchar (255), Kd_KA tinyint, Kd_Mutasi tinyint, Jml_Brg int)

WITH ENCRYPTION
AS
BEGIN

---Last modified 25-12-2012


/*
DECLARE @Tahun varchar(4), @D1 Datetime, @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4)

SET @Tahun = '2018'
SET @D1 = '20180101'
SET @D2 = '20181231'
SET @Kd_Prov = '30'
SET @Kd_Kab_Kota = '2'
SET @Kd_Bidang = '8'
SET @Kd_Unit = '1'
SET @Kd_Sub = '2'
SET @Kd_UPB = '7'
SET @Kd_Aset1	= '5'
SET @Kd_Aset2	= ''
SET @Kd_Aset3	= ''
SET @Kd_Aset4	= ''
SET @Kd_Aset5	= ''
SET @No_Register = ''
--*/

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	IF ISNULL (@Kd_Aset1,'') = '' SET @Kd_Aset1 = '%'
	IF ISNULL (@Kd_Aset2,'') = '' SET @Kd_Aset2 = '%'
	IF ISNULL (@Kd_Aset3,'') = '' SET @Kd_Aset3 = '%'
	IF ISNULL (@Kd_Aset4,'') = '' SET @Kd_Aset4 = '%'
	IF ISNULL (@Kd_Aset5,'') = '' SET @Kd_Aset5 = '%'
	IF ISNULL (@No_Register,'') = '' SET @No_Register = '%'



DECLARE @tmpHarga TABLE(Kd_ID int, Kd_Riwayat tinyint, Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int, Kd_ASet1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, 
	Harga money, Masa_Manfaat smallint, Nilai_Sisa money, Tgl_Dokumen Datetime, No_Dokumen Varchar(100), Kd_Data tinyint, Kd_KA tinyint, Kd_Mutasi tinyint, Jml_Brg int)
DECLARE @UbahData TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint,  Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int,  Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, Kd_Ruang int,
			Kd_Pemilik tinyint, Tgl_Perolehan Datetime , Tgl_Pembukuan Datetime, Tgl_Dokumen Datetime, No_Dokumen Varchar(100), Judul Varchar (255), Pencipta Varchar (255), Bahan Varchar (50), Ukuran varchar(50),
			Asal_usul Varchar(50), Kondisi Varchar(2), Harga money, Masa_Manfaat smallint, Nilai_Sisa money, Keterangan Varchar (255))


	
--1. PEROLEHAN 1

	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
                A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,  ISNULL(SUM(B.Harga),0) AS Harga, 
                ISNULL(SUM(B.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(B.Nilai_Sisa),0) AS Nilai_Sisa, A.Tgl_Dokumen, A.No_Dokumen,A.Kd_Data, A.Kd_KA, 2 AS Kd_Mutasi, 1 AS Jml_Brg
	FROM	Ta_KIBER A INNER JOIN Ta_KIB_E B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota 
                     AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB 
                     AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 
                     AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	(A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 3)  AND (A.Kd_Prov1 = @Kd_Prov) 
                 AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) 
                 AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) 
                 AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
	GROUP BY A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, 
                 A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data, A.Kd_KA

	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID,'0'AS Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data, A.Kd_KA, 1 AS Kd_Mutasi, 1 AS Jml_Brg

	FROM (
		SELECT	'0' AS KD_ID,'0'AS Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 
			ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, Tgl_Pembukuan AS Tgl_Dokumen, '' AS No_Dokumen, Kd_Data, Kd_KA, 1 AS Kd_Mutasi, 1 AS Jml_Brg
		FROM	Ta_KIB_E 
		WHERE	(Tgl_Pembukuan BETWEEN @D1 AND @D2) AND (Kd_Data <> 3) AND kd_hapus = 0 and (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) AND
			(Kd_Aset1 LIKE @Kd_Aset1) AND (Kd_Aset2 LIKE @Kd_Aset2) AND (Kd_Aset3 LIKE @Kd_Aset3) AND (Kd_Aset4 LIKE @Kd_Aset4) AND (Kd_Aset5 LIKE @Kd_Aset5) AND (No_Register LIKE @No_Register) 
		GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,  Tgl_Pembukuan, Kd_Data, Kd_KA

		UNION ALL

		SELECT	'3' AS KD_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
        	        A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,  ISNULL(SUM(B.Harga),0) AS Harga, 
        	        ISNULL(SUM(B.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(B.Nilai_Sisa),0) AS Nilai_Sisa, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data, A.Kd_KA, 1 AS Kd_Mutasi, 1 AS Jml_Brg
		FROM	Ta_KIBER A INNER JOIN Ta_KIB_E B ON --A.IDPEMDA = B.IDPEMDA
			A.Kd_Prov1 = B.Kd_Prov AND A.Kd_Kab_Kota1 = B.Kd_Kab_Kota 
       		        AND A.Kd_Bidang1 = B.Kd_Bidang AND A.Kd_Unit1 = B.Kd_Unit AND A.Kd_Sub1 = B.Kd_Sub AND A.Kd_UPB1 = B.Kd_UPB 
                 	AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 
                     	AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register1 = B.No_Register
		WHERE	(B.Tgl_Pembukuan = A.Tgl_Dokumen) AND (A.Tgl_Pembukuan BETWEEN @D1 AND @D2) AND
			(A.Kd_Riwayat = 3)  --AND (B.KD_DATA = 6) 
			AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
			(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
        	GROUP BY A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data, A.Kd_KA
	) A
	WHERE 	(A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
	        (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)

	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data, A.Kd_KA

--1. PEROLEHAN 1a (Data KIBHapus)-- Tambahan 14/12/2013
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID,'0'AS Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 
		ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, Tgl_SK AS Tgl_Dokumen, No_SK AS No_Dokumen, Kd_Data, Kd_KA, 1 AS Kd_Mutasi, 1 AS Jml_Brg
	FROM	Ta_KIBEHapus
	WHERE	(Tgl_Pembukuan BETWEEN @D1 AND @D2) --AND (Kd_Data <> 3) 
		AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) AND
		(Kd_Aset1 LIKE @Kd_Aset1) AND (Kd_Aset2 LIKE @Kd_Aset2) AND (Kd_Aset3 LIKE @Kd_Aset3) AND (Kd_Aset4 LIKE @Kd_Aset4) AND (Kd_Aset5 LIKE @Kd_Aset5) AND (No_Register LIKE @No_Register)
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Tgl_SK, No_SK, Kd_Data, Kd_KA

--2. PEROLEHAN 2
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID, A.Kd_Riwayat, A.Kd_Prov1 AS Kd_Prov, A.Kd_Kab_Kota1 AS Kd_Kab_Kota, A.Kd_Bidang1 AS Kd_Bidang, A.Kd_Unit1 AS Kd_Unit, A.Kd_Sub1 AS Kd_Sub, A.Kd_UPB1 AS Kd_UPB, 
                A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1 AS No_Register,  ISNULL(SUM(B.Harga),0) AS Harga, 
                ISNULL(SUM(B.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(B.Nilai_Sisa),0) AS Nilai_Sisa, A.Tgl_Dokumen, A.No_Dokumen,A.Kd_Data, A.Kd_KA, 1 AS Kd_Mutasi, 1 AS Jml_Brg
	FROM	Ta_KIBER A INNER JOIN Ta_KIB_E B ON A.Kd_Prov1 = B.Kd_Prov AND A.Kd_Kab_Kota1 = B.Kd_Kab_Kota 
                     AND A.Kd_Bidang1 = B.Kd_Bidang AND A.Kd_Unit1 = B.Kd_Unit AND A.Kd_Sub1 = B.Kd_Sub AND A.Kd_UPB1 = B.Kd_UPB 
                     AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 
                     AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register1 = B.No_Register
	WHERE	(A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 3)  AND (A.Kd_Prov1 = @Kd_Prov) 
                 AND (A.Kd_Kab_Kota1 = @Kd_Kab_Kota) AND (A.Kd_Bidang1 LIKE @Kd_Bidang) AND (A.Kd_Unit1 LIKE @Kd_Unit) 
                 AND (A.Kd_Sub1 LIKE @Kd_Sub) AND (A.Kd_UPB1 LIKE @Kd_UPB) AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) 
                 AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register1 LIKE @No_Register)
	GROUP BY A.Kd_Riwayat, A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, A.Kd_ASet1, A.Kd_Aset2, 
                 A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data, A.Kd_KA

-- PEROLEHAN 2a -- Pengurangan Pindah SKPD (13032014--Bulleleng)
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID,Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 
		ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, Tgl_Dokumen, No_Dokumen, Kd_Data, Kd_KA, 3 AS Kd_Mutasi, 1 AS Jml_Brg
	FROM	Ta_KIBER 
	WHERE	((Tgl_Dokumen BETWEEN @D1 AND @D2)
		AND (Kd_Riwayat = 3)  AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) AND
		(Kd_Aset1 LIKE @Kd_Aset1) AND (Kd_Aset2 LIKE @Kd_Aset2) AND (Kd_Aset3 LIKE @Kd_Aset3) AND (Kd_Aset4 LIKE @Kd_Aset4) AND (Kd_Aset5 LIKE @Kd_Aset5) AND (No_Register LIKE @No_Register))
	GROUP BY Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Tgl_Dokumen, No_Dokumen, Kd_Data, Kd_KA

--3. PEROLEHAN 3
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID,'0'AS Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 
		ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, Tgl_SK AS Tgl_Dokumen, No_SK AS No_Dokumen, Kd_DAta, Kd_KA, 3 AS Kd_Mutasi, 1 AS Jml_Brg
	FROM	Ta_KIBEHapus 
	WHERE	(Tgl_SK BETWEEN @D1 AND @D2) AND (Tgl_Pembukuan <= @D2) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) AND
		(Kd_Aset1 LIKE @Kd_Aset1) AND (Kd_Aset2 LIKE @Kd_Aset2) AND (Kd_Aset3 LIKE @Kd_Aset3) AND (Kd_Aset4 LIKE @Kd_Aset4) AND (Kd_Aset5 LIKE @Kd_Aset5) AND (No_Register LIKE @No_Register)
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Tgl_SK, No_SK, Kd_Data, Kd_KA

	--Tambahan perolehan riwayat aset yang dihapus -- Tambahan 14/12/2013
	INSERT INTO @tmpHarga
	SELECT	MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, 
		A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data, NULL AS Kd_Data, 3 AS Kd_Mutasi, 0 AS Jml_Brg
	FROM	Ta_KIBER A INNER JOIN
		Ta_KIBEHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	(A.Kd_Riwayat = 2) AND (A.Kd_Data <> 3) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) 
		AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		AND B.Tgl_SK BETWEEN @D1 AND @D2
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data

	-- Tambahan 14/12/2013
	INSERT INTO @tmpHarga
	SELECT	MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, 
		A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data, NULL AS Kd_Data, 3 AS Kd_Mutasi, 0 AS Jml_Brg
	FROM	Ta_KIBER A INNER JOIN
		Ta_KIBEHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	(A.Kd_Riwayat = 21) AND (A.Kd_Data <> 3) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) 
		AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		AND B.Tgl_SK BETWEEN @D1 AND @D2
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Dokumen, A.No_Dokumen,A.Kd_Data


--4. KAPITALISASI
	INSERT INTO @tmpHarga
	SELECT	MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, 
		ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data, NULL AS Kd_KA, 4 AS Kd_Mutasi, 0 AS Jml_Brg
	FROM	Ta_KIBER A LEFT OUTER JOIN
		Ta_KIBEHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	(Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 2) AND (A.Kd_Data <> 3) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		AND B.Kd_Prov IS NULL
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data

	INSERT INTO @tmpHarga
	SELECT	MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, 
		ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data, NULL AS Kd_KA, 4 AS Kd_Mutasi, 0 AS Jml_Brg
	FROM	Ta_KIBER A LEFT OUTER JOIN
		Ta_KIBEHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	(Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 2) AND (A.Kd_Data <> 3) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		AND B.Tgl_SK > @D2
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data

--5. HAPUS SEBAGIAN
	INSERT INTO @tmpHarga
	SELECT	MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, 
		ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data, NULL AS Kd_KA, 5 AS Kd_Mutasi, 0 AS Jml_Brg
	FROM	Ta_KIBER A
	WHERE	(Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 7) AND (A.Kd_Data <> 3) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) AND
		(Kd_Aset1 LIKE @Kd_Aset1) AND (Kd_Aset2 LIKE @Kd_Aset2) AND (Kd_Aset3 LIKE @Kd_Aset3) AND (Kd_Aset4 LIKE @Kd_Aset4) AND (Kd_Aset5 LIKE @Kd_Aset5) AND (No_Register LIKE @No_Register)
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data


--6. KOREKSI
	INSERT INTO @tmpHarga
	SELECT	MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, 
		ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data, NULL AS Kd_KA, 4 AS Kd_Mutasi, 0 AS Jml_Brg
	FROM	Ta_KIBER A LEFT OUTER JOIN
		Ta_KIBEHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	(Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 21) AND (A.Kd_Data <> 3) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		AND B.Kd_Prov IS NULL
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data

	INSERT INTO @tmpHarga
	SELECT	MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, 
		ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Tgl_Dokumen, A.No_Dokumen,A.Kd_Data, NULL AS Kd_KA, 4 AS Kd_Mutasi, 0 AS Jml_Brg
	FROM	Ta_KIBER A LEFT OUTER JOIN
		Ta_KIBEHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	(Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 21) AND (A.Kd_Data <> 3) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		AND B.Tgl_SK > @D2
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Data


--UBAH DATA KIB E
--1
	INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
           A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan,'' AS Tgl_Dokumen, '' AS No_Dokumen, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan	
	FROM Ta_KIB_E A LEFT OUTER JOIN
		(
		SELECT A.Tgl_Dokumen, A.Kd_Riwayat, A.Kd_Id AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM Ta_KIBER A
		WHERE (A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat IN(2,3,7,18,21)) AND (A.Kd_Prov = @Kd_Prov )AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang)AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		      (Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
		       A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
		       A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE --(B.Kd_Prov IS NULL) AND 
		--(A.Tgl_Pembukuan BETWEEN @D1 AND @D2) AND --buleleng -14032014
		(A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
	        (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)

--2
	INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
           A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan,'' AS Tgl_Dokumen, '' AS No_Dokumen, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan	
	FROM Ta_KIBEHapus A LEFT OUTER JOIN
		(
		SELECT A.Kd_Riwayat, A.Kd_Id AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM Ta_KIBER A
		WHERE (A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat IN(2,3,7,18,21)) AND (A.Kd_Prov = @Kd_Prov )AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang)AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		      (Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
			A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
			A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE (B.Kd_Prov IS NULL) AND (A.Tgl_SK BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
	      (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)

	--Tambahan untuk aset yang sudah dihapus -- Tambahan 14/12/2013
	INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
           A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan,'' AS Tgl_Dokumen, '' AS No_Dokumen, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan	
	FROM Ta_KIBEHapus A LEFT OUTER JOIN
		(
		SELECT A.Kd_Riwayat, A.Kd_Id AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM Ta_KIBER A
		WHERE (A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat IN(2,3,7,18,21)) AND (A.Kd_Prov = @Kd_Prov )AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang)AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND

		      (Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
			A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
			A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE (B.Kd_Prov IS NULL) AND (A.Tgl_Pembukuan BETWEEN @D1 AND @D2) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
	      (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)

--3
	INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
           A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan,'' AS Tgl_Dokumen, '' AS No_Dokumen, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan	
	FROM Ta_KIBER A LEFT OUTER JOIN
		(
		SELECT A.Kd_Riwayat, A.Kd_Id AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM Ta_KIBER A
		WHERE (A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 18) AND  (A.Kd_Prov = @Kd_Prov )AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang)AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		      (Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
			A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
			A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE (B.Kd_Prov IS NULL) AND (A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat IN(2,3,7))  AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
	      (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)

--UBAH DATA KIB E (RIWAYAT)
	INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
           A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Tgl_Dokumen, A.No_Dokumen, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan
	FROM Ta_KIBER A INNER JOIN
		(
		SELECT A.Kd_Riwayat, MAX(A.Kd_Id) AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM Ta_KIBER A
		WHERE (A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 18) AND  (A.Kd_Prov = @Kd_Prov )AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang)AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		      (Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		GROUP BY A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		) B ON (A.Kd_Riwayat = B.Kd_Riwayat) AND (A.Kd_Id = B.Kd_Id) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
	               (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
	WHERE (A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Prov = B.Kd_Prov) AND (A.Kd_Kab_Kota = B.Kd_Kab_Kota) AND (A.Kd_Bidang = B.Kd_Bidang) AND (A.Kd_Unit = B.Kd_Unit) AND (A.Kd_Sub = B.Kd_Sub) AND (A.Kd_UPB = B.Kd_UPB) AND
	      (A.Kd_Aset1 = B.Kd_Aset1) AND (A.Kd_Aset2 = B.Kd_Aset2) AND (A.Kd_Aset3 = B.Kd_Aset3) AND (A.Kd_Aset4 = B.Kd_Aset4) AND (A.Kd_Aset5 = B.Kd_Aset5) AND (A.No_Register = B.No_Register)


   INSERT INTO @UpdateKIB
   SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	  A.No_Register, B.Kd_Ruang, B.Kd_Pemilik, B.Tgl_Perolehan, B.Tgl_Pembukuan, A.Tgl_Dokumen, A.No_Dokumen, B.Judul, B.Pencipta, B.Bahan, B.Ukuran,
	  B.Asal_usul, B.Kondisi, B.Harga, B.Masa_Manfaat, B.Nilai_Sisa, B.Keterangan, A.Kd_KA, A.Kd_Mutasi, A.Jml_Brg
   FROM(
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,  ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, 
		ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Tgl_Dokumen, A.No_Dokumen, MAX(A.Kd_KA) AS Kd_KA, A.Kd_Mutasi, ISNULL(SUM(A.Jml_Brg),0) AS Jml_Brg
	FROM @TMPHARGA A 
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Dokumen, A.No_Dokumen, A.Kd_Mutasi
	) A INNER JOIN
	(
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
           A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Tgl_Dokumen, A.No_Dokumen, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan
	FROM @UBAHDATA A 
	)B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_ASet1 = B.Kd_ASet1 
           AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register 

	RETURN END











GO
