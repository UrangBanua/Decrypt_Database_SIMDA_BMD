USE bmd_hst2020
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO



/*** fn_Kartu_BrgL_Awl - 16112015 - Modified for Ver 2.0.7 [demi@simda.id] ***/

CREATE FUNCTION [dbo].[fn_Kartu_BrgL_Awl] (@D1 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4),
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(5))

RETURNS @UpdateKIB TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint,  Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub tinyint, Kd_UPB int, 
			 Kd_ASet1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, 
			 No_Register int, Kd_Ruang int, Kd_Pemilik tinyint, Tgl_Perolehan Datetime , Tgl_Pembukuan Datetime, Tgl_Dokumen Datetime, No_Dokumen Varchar(100),  Judul Varchar(255), Pencipta Varchar(255), Bahan Varchar(50), Ukuran Float(8),
			 Asal_usul Varchar(50), Kondisi Varchar(2), Harga money, Masa_Manfaat smallint, Nilai_Sisa money, Keterangan Varchar (255), Kd_KA tinyint)



WITH ENCRYPTION
AS
BEGIN

/*
DECLARE @Tahun varchar(4), @D1 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4)

SET @Tahun = '2011'
SET @D1 = '20111231'
SET @Kd_Prov = '22'
SET @Kd_Kab_Kota = '16'
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @Kd_UPB = ''
SET @Kd_Aset1	= ''
SET @Kd_Aset2	= ''
SET @Kd_Aset3	= ''
SET @Kd_Aset4	= ''
SET @Kd_Aset5	= ''
SET @No_Register = ''
*/
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



DECLARE @tmpHarga TABLE(Kd_ID int, Kd_Riwayat tinyint, Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub tinyint, Kd_UPB int, Kd_ASet1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, Harga money, Masa_Manfaat smallint, Nilai_Sisa money, Kd_Data tinyint, Kd_KA tinyint)
DECLARE @UbahData TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint,  Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub tinyint, Kd_UPB int,  Kd_ASet1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, Kd_Ruang int,
			Kd_Pemilik tinyint, Tgl_Perolehan Datetime , Tgl_Pembukuan Datetime, Tgl_Dokumen Datetime, No_Dokumen Varchar(50), Judul Varchar (255), Pencipta Varchar (255), Bahan Varchar (50), Ukuran Float(8),
			Asal_usul Varchar(50), Kondisi Varchar(2), Harga money, Masa_Manfaat smallint, Nilai_Sisa money, Keterangan Varchar (255))

--1. PEROLEHAN 1
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID,'0'AS Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,  ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, Kd_Data, Kd_KA
	FROM	Ta_Lainnya 
	WHERE	Tgl_Pembukuan <= @D1 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
		AND Kd_Data <> 3 
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Data, Kd_KA

--2. PEROLEHAN 2
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID,Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,  ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, Kd_DAta, Kd_KA
	FROM	Ta_KILER 
	WHERE	Tgl_dokumen > @D1 AND Kd_Riwayat = 3 AND Tgl_Pembukuan <= @D1 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
	GROUP BY Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Data, Kd_KA

--3. PEROLEHAN 3
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID,'0'AS Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,  ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, Kd_DAta, Kd_KA
	FROM	Ta_KILHapus 
	WHERE	Tgl_SK > @D1 AND Tgl_Pembukuan <= @D1 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Data, Kd_KA

--4. KAPITALISASI
	INSERT INTO @tmpHarga
	SELECT	MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, NULL AS Kd_KA
	FROM	Ta_KILER A 
	WHERE	A.Tgl_dokumen <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND (KD_RIWAYAT=2)
		AND A.Kd_Data <> 3
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data

--5. HAPUS SEBAGIAN
	INSERT INTO @tmpHarga
	SELECT	MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(-Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, NULL AS Kd_KA
	FROM	Ta_KILER A
	WHERE	A.Tgl_dokumen <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND (A.Kd_Riwayat = 7)
		AND A.Kd_Data <> 3
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data

--6. KOREKSI
	INSERT INTO @tmpHarga
	SELECT	MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, NULL AS Kd_KA
	FROM	Ta_KILER A 
	WHERE	A.Tgl_dokumen <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND (KD_RIWAYAT=21)
		AND A.Kd_Data <> 3
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data


--UBAH DATA KIB E
--1
	INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
           A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan,'' AS Tgl_Dokumen, '' AS No_Dokumen, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan	
	FROM Ta_Lainnya A LEFT OUTER JOIN
		(
		SELECT A.Kd_Riwayat, A.Kd_Id AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM Ta_KILER A
		WHERE (Kd_Riwayat = 18) AND A.Tgl_Pembukuan <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
			Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
			A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
			A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE (B.Kd_Prov IS NULL) AND A.Tgl_Pembukuan <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register

--2
	INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
           A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan,'' AS Tgl_Dokumen, '' AS No_Dokumen, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan	
	FROM Ta_KILHapus A LEFT OUTER JOIN
		(
		SELECT A.Kd_Riwayat, A.Kd_Id AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM Ta_KILER A
		WHERE (Kd_Riwayat = 18) AND A.Tgl_Pembukuan <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
			Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
			A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
			A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE (B.Kd_Prov IS NULL) AND A.Tgl_SK > @D1 AND A.Tgl_Pembukuan <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register

--3
	INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
           A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan,'' AS Tgl_Dokumen, '' AS No_Dokumen, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan	
	FROM Ta_KILER A LEFT OUTER JOIN
		(
		SELECT A.Kd_Riwayat, A.Kd_Id AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM Ta_KILER A
		WHERE (Kd_Riwayat = 18) AND A.Tgl_Pembukuan <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
			Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
			A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
			A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE (B.Kd_Prov IS NULL) AND A.Tgl_dokumen > @D1 AND A.Kd_Riwayat = 3 AND A.Tgl_Pembukuan <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register

--UBAH DATA KIB E (RIWAYAT)
	INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
           A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Tgl_Dokumen, A.No_Dokumen, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan
	FROM Ta_KILER A INNER JOIN
		(
		SELECT A.Kd_Riwayat, MAX(A.Kd_Id) AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM Ta_KILER A
		WHERE Kd_Riwayat = 18
		GROUP BY A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		) B ON A.Kd_Riwayat = B.Kd_Riwayat AND A.Kd_Id = B.Kd_Id AND A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND 
			A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND 
			A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	A.Tgl_Pembukuan <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register


   INSERT INTO @UpdateKIB
   SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, /*C.Kd_Gab_Bidang, C.Kd_Gab_Unit, C.Kd_Gab_Sub, C.Kd_Gab_UPB, C.Nm_UPB,*/ A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	      /*D.Kd_AsetGab, D.Nm_Aset,*/ A.No_Register, B.Kd_Ruang, B.Kd_Pemilik, B.Tgl_Perolehan, B.Tgl_Pembukuan, B.Tgl_Dokumen, B.No_Dokumen, B.Judul, B.Pencipta, B.Bahan, B.Ukuran,
		  B.Asal_usul, B.Kondisi, B.Harga, B.Masa_Manfaat, B.Nilai_Sisa, B.Keterangan, A.Kd_KA
   FROM(
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,  ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, MAX(A.Kd_KA) AS Kd_KA
	FROM @TMPHARGA A 
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
	) A INNER JOIN
	(
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
           A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Tgl_Dokumen, A.No_Dokumen, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan
	FROM @UBAHDATA A /*INNER JOIN
		 REF_KONDISI B ON A.Kondisi = B.Kd_Kondisi*/
	)B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_ASet1 = B.Kd_ASet1 
           AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register /*INNER JOIN
	(
  	SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Nm_UPB,
		RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) AS Kd_Gab_Bidang,
		CASE LEN(CONVERT(Varchar, A.Kd_Unit)) WHEN 1 THEN
		'00'+ CONVERT(Varchar, A.Kd_Unit) ELSE
		RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 3) END AS Kd_Gab_Unit,
		CASE LEN(CONVERT(varchar, A.Kd_Sub)) WHEN 3 THEN 
		CONVERT(varchar, A.Kd_Sub) ELSE RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) END AS Kd_Gab_Sub,
		CASE LEN(CONVERT(varchar, A.Kd_UPB)) WHEN 3 THEN 
		CONVERT(varchar, A.Kd_UPB) ELSE RIGHT('0' + CONVERT(varchar, A.Kd_UPB), 2) END AS Kd_Gab_UPB
	 FROM	Ref_UPB A	
	 ) C ON A. Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB INNER JOIN
	 (
	 SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, CONVERT(varchar, A.Kd_Aset1) + '.' + CONVERT(varchar, A.Kd_Aset2) + '.' + CONVERT(varchar, A.Kd_Aset3) + 
		'.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset5), 2) AS Kd_AsetGab, A.Nm_Aset5 AS Nm_Aset
         FROM   Ref_Rek_Aset5 A
	 )D ON A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5*/

	RETURN
END










GO
