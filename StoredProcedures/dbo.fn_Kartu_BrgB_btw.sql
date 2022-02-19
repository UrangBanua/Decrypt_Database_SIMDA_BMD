USE bmd_hst2020
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION dbo.fn_Kartu_BrgB_btw (@D1 datetime, @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(5))
RETURNS @UpdateKIB TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint,  Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int, 
		         Kd_ASet1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, Kd_Ruang int, Kd_Pemilik tinyint, Harga Money, Masa_Manfaat smallint,  Nilai_Sisa Money, Tgl_Dokumen Datetime,
			 No_Dokumen Varchar(50), Tgl_Perolehan Datetime, Tgl_Pembukuan Datetime, Merk Varchar(50), Type Varchar(50), CC Varchar(50), Bahan Varchar(50), Nomor_Pabrik Varchar(50), Nomor_Rangka Varchar(50), Nomor_Mesin Varchar(50), Nomor_Polisi Varchar(10),
			 Nomor_BPKB Varchar(50), Asal_usul Varchar(50), Kondisi Varchar(2) , Keterangan Varchar(255), Tahun Varchar(4), Kd_KA tinyint, Kd_Mutasi tinyint, Jml_Brg int)

WITH ENCRYPTION
AS
BEGIN

/*
DECLARE @Tahun varchar(4), @D1 Datetime, @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4)

--SET @Tahun = '2016'
SET @D1 = '20180101'
SET @D2 = '20181231'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '11'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = ''
SET @Kd_Aset1	= ''
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


DECLARE @tmpHarga TABLE(Kd_ID int, Kd_Riwayat tinyint, Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, Harga money, Masa_Manfaat smallint, Nilai_Sisa money, Kd_Data tinyint, Kd_KA tinyint, Kd_Mutasi Tinyint, Jml_Brg int)
DECLARE @UbahData TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint,  Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int,  Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, 
				Kd_Ruang int, Kd_Pemilik tinyint, Merk Varchar(50), Type Varchar(50), CC Varchar(50), Bahan Varchar(50), Tgl_Dokumen Datetime, No_Dokumen Varchar(50),  Tgl_Perolehan Datetime , Tgl_Pembukuan Datetime, Nomor_Pabrik Varchar(50), Nomor_Rangka Varchar(50), Nomor_Mesin Varchar(50), Nomor_Polisi Varchar(10), 
            			Nomor_BPKB Varchar(50), Asal_usul Varchar(50), Kondisi Varchar(2), Harga money, Masa_Manfaat smallint, Nilai_Sisa money, Keterangan Varchar (255), Tahun Varchar(4))
--ganti tipe MM jadi smallint

--1. PEROLEHAN 1 (Data KIB)
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID,'0'AS Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, A.Kd_KA, 1 AS Kd_Mutasi, 1 AS Jml_Brg

	FROM (
		SELECT	'0' AS KD_ID,'0'AS Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 
			ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, Kd_Data, Kd_KA, 1 AS Kd_Mutasi, 1 AS Jml_Brg
		FROM	Ta_KIB_B 
		WHERE	(Tgl_Pembukuan BETWEEN @D1 AND @D2) AND (Kd_Data <> 3) AND kd_hapus = 0 and (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) AND
			(Kd_Aset1 LIKE @Kd_Aset1) AND (Kd_Aset2 LIKE @Kd_Aset2) AND (Kd_Aset3 LIKE @Kd_Aset3) AND (Kd_Aset4 LIKE @Kd_Aset4) AND (Kd_Aset5 LIKE @Kd_Aset5) AND (No_Register LIKE @No_Register)
		GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Data, Kd_KA

		UNION ALL

		SELECT	'3' AS KD_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
        	        A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,  ISNULL(SUM(B.Harga),0) AS Harga, 
        	        ISNULL(SUM(B.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(B.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, A.Kd_KA, 1 AS Kd_Mutasi, 1 AS Jml_Brg
		FROM	Ta_KIBBR A INNER JOIN Ta_KIB_B B ON --A.IDPEMDA = B.IDPEMDA
			A.Kd_Prov1 = B.Kd_Prov AND A.Kd_Kab_Kota1 = B.Kd_Kab_Kota 
       		        AND A.Kd_Bidang1 = B.Kd_Bidang AND A.Kd_Unit1 = B.Kd_Unit AND A.Kd_Sub1 = B.Kd_Sub AND A.Kd_UPB1 = B.Kd_UPB 
                 	AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 
                     	AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register1 = B.No_Register
		WHERE	(B.Tgl_Pembukuan = A.Tgl_Dokumen) AND (A.Tgl_Pembukuan BETWEEN @D1 AND @D2) AND
			(A.Kd_Riwayat = 3)  --AND (B.KD_DATA = 6) 
			AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
			(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
        	GROUP BY A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data, A.Kd_KA
	) A
	WHERE 	(A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
	        (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)

	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Kd_Data, A.Kd_KA

	
--1. PEROLEHAN 1a (Data KIBHapus)-- Tambahan 14/12/2013
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID,'0'AS Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 
		ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, Kd_Data, Kd_KA, 1 AS Kd_Mutasi, 1 AS Jml_Brg
	FROM	Ta_KIBBHapus 
	WHERE	(Tgl_Pembukuan BETWEEN @D1 AND @D2) --AND (Kd_Data <> 3) 
		AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) AND
		(Kd_Aset1 LIKE @Kd_Aset1) AND (Kd_Aset2 LIKE @Kd_Aset2) AND (Kd_Aset3 LIKE @Kd_Aset3) AND (Kd_Aset4 LIKE @Kd_Aset4) AND (Kd_Aset5 LIKE @Kd_Aset5) AND (No_Register LIKE @No_Register)
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Data, Kd_KA


--1D. PEROLEHAN 2 (data pindah SKPD Asal)
	/*INSERT INTO @tmpHarga
	SELECT	  '0' AS KD_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
                A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,  ISNULL(SUM(B.Harga),0) AS Harga, 
                ISNULL(SUM(B.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(B.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, A.Kd_KA, 3 AS Kd_Mutasi, 1 AS Jml_Brg
	FROM	Ta_KIBBR A INNER JOIN Ta_KIB_B B ON A.Kd_Prov1 = B.Kd_Prov AND A.Kd_Kab_Kota1 = B.Kd_Kab_Kota 
                     AND A.Kd_Bidang1 = B.Kd_Bidang AND A.Kd_Unit1 = B.Kd_Unit AND A.Kd_Sub1 = B.Kd_Sub AND A.Kd_UPB1 = B.Kd_UPB 
                     AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 
                     AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register1 = B.No_Register
	WHERE	((A.Tgl_Dokumen BETWEEN @D1 AND @D2) 
		AND (A.Tgl_Pembukuan <= @D2)) AND  (A.Kd_Riwayat = 3)  AND (A.Tgl_Pembukuan <= @D1) AND 
		(A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
        GROUP BY A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data, A.Kd_KA
	
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
                A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,  ISNULL(SUM(B.Harga),0) AS Harga, 
                ISNULL(SUM(B.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(B.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, A.Kd_KA, 3 AS Kd_Mutasi, 1 AS Jml_Brg
	FROM	Ta_KIBBR A INNER JOIN Ta_KIB_B B ON --A.IDPEMDA = B.IDPEMDA
		A.Kd_Prov1 = B.Kd_Prov AND A.Kd_Kab_Kota1 = B.Kd_Kab_Kota 
                     AND A.Kd_Bidang1 = B.Kd_Bidang AND A.Kd_Unit1 = B.Kd_Unit AND A.Kd_Sub1 = B.Kd_Sub AND A.Kd_UPB1 = B.Kd_UPB 
                     AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 
                     AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register1 = B.No_Register
	WHERE	(A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND 
		(A.Kd_Riwayat = 3)  AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
        GROUP BY A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data, A.Kd_KA
*/

--2. PEROLEHAN 2 (data pindah SKPD Asal--pengurangan karena pindah skpd) - update di DB Prov Sulut 24-11-2017
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
                A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,  ISNULL(SUM(A.Harga),0) AS Harga, 
                ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, 0 AS Nilai_Sisa, A.Kd_Data, A.Kd_KA, 3 AS Kd_Mutasi, 1 AS Jml_Brg
	FROM	Ta_KIBBR A 
	WHERE	(A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND 
		(A.Kd_Riwayat = 3)  AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
        GROUP BY A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data, A.Kd_KA

---2.Pengurangan aset yg sudah pindah skpd (16-08-2016)

	/*INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
                A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,  ISNULL(SUM(B.Harga),0) AS Harga, 
                ISNULL(SUM(B.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(B.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, A.Kd_KA, 3 AS Kd_Mutasi, 1 AS Jml_Brg
	FROM	Ta_KIBBR A INNER JOIN Ta_KIB_B B ON --A.IDPEMDA = B.IDPEMDA
		A.Kd_Prov1 = B.Kd_Prov AND A.Kd_Kab_Kota1 = B.Kd_Kab_Kota 
                     AND A.Kd_Bidang1 = B.Kd_Bidang AND A.Kd_Unit1 = B.Kd_Unit AND A.Kd_Sub1 = B.Kd_Sub AND A.Kd_UPB1 = B.Kd_UPB 
                     AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 
                     AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register1 = B.No_Register
	WHERE	(B.Tgl_Pembukuan = A.Tgl_Dokumen) AND (A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND
		(A.Kd_Riwayat = 3)  AND (B.KD_DATA = 6) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
        GROUP BY A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data, A.Kd_KA



--2a. PEROLEHAN 2 (data pindah SKPD Asal --penambahan dlm tahun berjalan) -- Pengurangan Pindah SKPD (13032014--Bulleleng)
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID,Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,  
		ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, Kd_Data, Kd_KA, 3 AS Kd_Mutasi, 1 AS Jml_Brg
	FROM	Ta_KIBBR 
	WHERE	((Tgl_Dokumen BETWEEN @D1 AND @D2) AND (Tgl_Pembukuan <= @D2)) AND (Tgl_Pembukuan >= @D1) AND
		 (Kd_Riwayat = 3)  AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) AND
		(Kd_Aset1 LIKE @Kd_Aset1) AND (Kd_Aset2 LIKE @Kd_Aset2) AND (Kd_Aset3 LIKE @Kd_Aset3) AND (Kd_Aset4 LIKE @Kd_Aset4) AND (Kd_Aset5 LIKE @Kd_Aset5) AND (No_Register LIKE @No_Register)
        GROUP BY Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Data, Kd_KA
*/
---------

--2. PEROLEHAN 2
        INSERT INTO @tmpHarga
	SELECT	  '0' AS KD_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, 
                A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, SUM(B.Harga), SUM(B.Masa_Manfaat), SUM(B.Nilai_Sisa), A.Kd_Data, 
                A.Kd_KA, 2 AS Kd_Mutasi, 1 AS Jml_Brg
	FROM	Ta_KIBBR A INNER JOIN Ta_KIB_C B ON A.Kd_Prov1 = B.Kd_Prov AND A.Kd_Kab_Kota1 = B.Kd_Kab_Kota 
                     AND A.Kd_Bidang1 = B.Kd_Bidang AND A.Kd_Unit1 = B.Kd_Unit AND A.Kd_Sub1 = B.Kd_Sub AND A.Kd_UPB1 = B.Kd_UPB 
                     AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 
                     AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register1 = B.No_Register
        WHERE	(A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 3)  AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
	GROUP BY A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data, A.Kd_KA           
--------


--3. PEROLEHAN 3 (data barang dihapus asal) 
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID, '0' AS Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 
		ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, 0 AS Kd_Data, Kd_KA, 3 AS Kd_Mutasi, 1 AS Jml_Brg
	FROM	Ta_KIBBHapus 
	WHERE	(Tgl_SK BETWEEN @D1 AND @D2) AND (Tgl_Pembukuan <= @D2) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) AND
		(Kd_Aset1 LIKE @Kd_Aset1) AND (Kd_Aset2 LIKE @Kd_Aset2) AND (Kd_Aset3 LIKE @Kd_Aset3) AND (Kd_Aset4 LIKE @Kd_Aset4) AND (Kd_Aset5 LIKE @Kd_Aset5) AND (No_Register LIKE @No_Register)
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_KA

	--Tambahan perolehan riwayat aset yang dihapus -- Tambahan 14/12/2013
	INSERT INTO @tmpHarga
	SELECT	  MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, NULL AS Kd_Data, 3 AS Kd_Mutasi, 0 AS Jml_Brg
	FROM	Ta_KIBBR A INNER JOIN
		Ta_KIBBHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	(A.Kd_Riwayat = 2) AND (A.Kd_Data <> 3) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) 
		AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		AND B.Tgl_SK BETWEEN @D1 AND @D2
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data

	-- Tambahan 14/12/2013
	INSERT INTO @tmpHarga
	SELECT	  MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, NULL AS Kd_Data, 3 AS Kd_Mutasi, 0 AS Jml_Brg
	FROM	Ta_KIBBR A INNER JOIN
		Ta_KIBBHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	(A.Kd_Riwayat = 21) AND (A.Kd_Data <> 3) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) 
		AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		AND B.Tgl_SK BETWEEN @D1 AND @D2
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data


--4. KAPITALISASI
--Perbaikan mutasi jika ada penghapusan tidak masuk lagi--12/12/13
	INSERT INTO @tmpHarga
	SELECT	  MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, NULL AS Kd_Data, 4 AS Kd_Mutasi, 0 AS Jml_Brg
	FROM	Ta_KIBBR A LEFT OUTER JOIN
		Ta_KIBBHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	(A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 2) AND (A.Kd_Data <> 3) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) 
		AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		AND B.Kd_Prov IS NULL
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data

	INSERT INTO @tmpHarga
	SELECT	  MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, NULL AS Kd_Data, 4 AS Kd_Mutasi, 0 AS Jml_Brg
	FROM	Ta_KIBBR A INNER JOIN
		Ta_KIBBHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	(A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 2) AND (A.Kd_Data <> 3) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) 
		AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		AND B.Tgl_SK > @D2
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data


--5. HAPUS SEBAGIAN
	INSERT INTO @tmpHarga
	SELECT	 MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, NULL AS Kd_Data, 5 AS Kd_Mutasi, 0 AS Jml_Brg
	FROM	Ta_KIBBR A
	WHERE	(Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 7) AND (A.Kd_Data <> 3) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) AND
		(Kd_Aset1 LIKE @Kd_Aset1) AND (Kd_Aset2 LIKE @Kd_Aset2) AND (Kd_Aset3 LIKE @Kd_Aset3) AND (Kd_Aset4 LIKE @Kd_Aset4) AND (Kd_Aset5 LIKE @Kd_Aset5) AND (No_Register LIKE @No_Register)
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data

--6. KOREKSI
--Perbaikan mutasi jika ada penghapusan tidak masuk lagi--12/12/13
	INSERT INTO @tmpHarga
	SELECT	 MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, NULL AS Kd_Data, 4 AS Kd_Mutasi, 0 AS Jml_Brg
	FROM	Ta_KIBBR A LEFT OUTER JOIN
		Ta_KIBBHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	(A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 21) AND (A.Kd_Data <> 3) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		AND B.Kd_Prov IS NULL
	GROUP BY B.Tgl_SK, A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data

	INSERT INTO @tmpHarga
	SELECT	 MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, NULL AS Kd_Data, 4 AS Kd_Mutasi, 0 AS Jml_Brg
	FROM	Ta_KIBBR A LEFT OUTER JOIN
		Ta_KIBBHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	(A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 21) AND (A.Kd_Data <> 3) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		(A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		AND B.Tgl_SK > @D2
	GROUP BY B.Tgl_SK, A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Data


--UBAH DATA KIB B
--1
/*	INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
	       A.Kd_Pemilik, A.Merk, A.Type, A.CC, A.Bahan, A.Tgl_Perolehan AS Tgl_Dokumen, 'Data KIB' AS No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, 
	       A.Nomor_BPKB, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun
	FROM Ta_KIB_B A LEFT OUTER JOIN
		(
		SELECT A.Tgl_Dokumen, A.Kd_Riwayat, A.Kd_Id AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM Ta_KIBBR A
		WHERE (A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat IN(2,3,7,18,21)) AND (A.Kd_Prov = @Kd_Prov )AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang)AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		      (Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
		       A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
		       A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE (B.Kd_Prov IS NULL) AND 
		(A.Tgl_Pembukuan BETWEEN @D1 AND @D2) AND ---buleleng -14032014
		(A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
	        (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)

*/
	INSERT INTO @UbahData
	SELECT  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
	       A.Kd_Pemilik, A.Merk, A.Type, A.CC, A.Bahan, A.Tgl_DOKUMEN, 'Data KIB' AS No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, 
	       A.Nomor_BPKB, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun
	FROM 
	(
		SELECT  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
		       A.Kd_Pemilik, A.Merk, A.Type, A.CC, A.Bahan, '' AS TGL_DOKUMEN, 'Data KIB' AS No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, 
			       A.Nomor_BPKB, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun
		FROM Ta_KIB_B A 
		WHERE (A.Tgl_Pembukuan BETWEEN @D1 AND @D2) AND 
			(A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		        (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
			--AND (A.KD_DATA = 6)
		UNION ALL

		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
		       A.Kd_Pemilik, A.Merk, A.Type, A.CC, A.Bahan, A.Tgl_Dokumen, 'Data KIB' AS No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, 
		       A.Nomor_BPKB, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun
		FROM Ta_KIBBR A
		WHERE --(A.Tgl_Pembukuan BETWEEN @D1 AND @D2) AND
			 (A.Kd_Riwayat IN(2,3,7,18,21)) AND (A.Kd_Prov = @Kd_Prov )AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang)AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
			      (Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)

	) A

	WHERE 	(A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
	        (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		--AND (A.KD_DATA = 6)



--2(hapus)
        INSERT INTO @UbahData
	SELECT  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
	       A.Kd_Pemilik, A.Merk, A.Type, A.CC, A.Bahan, A.Tgl_Perolehan AS Tgl_Dokumen, 'Data KIB' AS No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, 
	       A.Nomor_BPKB, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun
	FROM Ta_KIBBHapus A LEFT OUTER JOIN
		(
		SELECT A.Kd_Riwayat, A.Kd_Id AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM Ta_KIBBR A
		WHERE (A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat IN(2,3,7,18,21)) AND (A.Kd_Prov = @Kd_Prov )AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang)AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		      (Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
			A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
			A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE (B.Kd_Prov IS NULL) AND (A.Tgl_SK BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
	      (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)

	--Tambahan untuk aset yang sudah dihapus -- Tambahan 14/12/2013
	INSERT INTO @UbahData
	SELECT  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
	       A.Kd_Pemilik, A.Merk, A.Type, A.CC, A.Bahan, A.Tgl_Perolehan AS Tgl_Dokumen, 'Data KIB' AS No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, 
	       A.Nomor_BPKB, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun
	FROM Ta_KIBBHapus A LEFT OUTER JOIN
		(
		SELECT A.Kd_Riwayat, A.Kd_Id AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM Ta_KIBBR A
		WHERE (A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat IN(2,3,7,18,21)) AND (A.Kd_Prov = @Kd_Prov )AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang)AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		      (Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
			A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
			A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE (B.Kd_Prov IS NULL) AND (A.Tgl_Pembukuan BETWEEN @D1 AND @D2) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
	      (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)


--3(kapitalisasi)
        INSERT INTO @UbahData
	SELECT  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
	       A.Kd_Pemilik, A.Merk, A.Type, A.CC, A.Bahan, A.Tgl_Perolehan AS Tgl_Dokumen, 'Data KIB' AS No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, 
	       A.Nomor_BPKB, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun
	FROM Ta_KIBBR A LEFT OUTER JOIN
		(
		SELECT A.Kd_Riwayat, A.Kd_Id AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM Ta_KIBBR A
		WHERE (A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 18) AND  (A.Kd_Prov = @Kd_Prov )AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang)AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		      (Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
			A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
			A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE (B.Kd_Prov IS NULL) AND (A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat IN(2,3,7))  AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
	      (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)

--UBAH DATA KIB B (RIWAYAT)

	INSERT INTO @UbahData
	SELECT   A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
	       A.Kd_Pemilik, A.Merk, A.Type,  A.CC, A.Bahan, A.Tgl_Dokumen, A.No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, 
	       A.Nomor_BPKB, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun
	FROM Ta_KIBBR A INNER JOIN
		(
		SELECT A.Kd_Riwayat, MAX(A.Kd_Id) AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM Ta_KIBBR A
		WHERE (A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND (A.Kd_Riwayat = 18) AND  (A.Kd_Prov = @Kd_Prov )AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang)AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
		      (Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
		GROUP BY A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		) B ON (A.Kd_Riwayat = B.Kd_Riwayat) AND (A.Kd_Id = B.Kd_Id) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
	               (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5) AND (A.No_Register LIKE @No_Register)
	WHERE (A.Tgl_Dokumen BETWEEN @D1 AND @D2) AND (A.Tgl_Pembukuan <= @D2) AND 
		(A.Kd_Prov = B.Kd_Prov) AND (A.Kd_Kab_Kota = B.Kd_Kab_Kota) AND (A.Kd_Bidang = B.Kd_Bidang) AND (A.Kd_Unit = B.Kd_Unit) AND (A.Kd_Sub = B.Kd_Sub) AND (A.Kd_UPB = B.Kd_UPB) AND
	      (A.Kd_Aset1 = B.Kd_Aset1) AND (A.Kd_Aset2 = B.Kd_Aset2) AND (A.Kd_Aset3 = B.Kd_Aset3) AND (A.Kd_Aset4 = B.Kd_Aset4) AND (A.Kd_Aset5 = B.Kd_Aset5) AND (A.No_Register = B.No_Register)

   INSERT INTO @UpdateKIB
   SELECT  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	       A.No_Register, B.Kd_Ruang, B.Kd_Pemilik, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, B.Tgl_Dokumen, B.No_Dokumen, B.Tgl_Perolehan, B.Tgl_Pembukuan, B.Merk, B.Type,  B.CC, B.Bahan, 
	       B.Nomor_Pabrik, B.Nomor_Rangka, B.Nomor_Mesin, B.Nomor_Polisi, B.Nomor_BPKB, 
	       B.Asal_usul, B.Kondisi , B.Keterangan, B.Tahun, A.Kd_KA, A.Kd_Mutasi, A.Jml_Brg
   FROM (
	
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,  
		ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, MAX(Kd_KA) AS Kd_KA, A.Kd_Mutasi, ISNULL(SUM(A.Jml_Brg),0) AS Jml_Brg
	FROM @TMPHARGA A 
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Mutasi
	) A INNER JOIN
	(
	SELECT  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, MAX(A.Kd_Ruang) AS Kd_Ruang, 
                MAX(A.Kd_Pemilik) AS Kd_Pemilik, MAX(A.Merk) AS Merk, MAX(A.Type) AS Type, MAX(A.CC) AS CC, MAX(A.Bahan) AS Bahan, MAX(A.Tgl_Dokumen) AS Tgl_Dokumen, MAX(A.No_Dokumen) AS No_Dokumen, 
                MAX(A.Tgl_Perolehan) AS Tgl_Perolehan, MAX(A.Tgl_Pembukuan) AS Tgl_Pembukuan, MAX(A.Nomor_Pabrik) AS Nomor_Pabrik, MAX(A.Nomor_Rangka) AS Nomor_Rangka, MAX(A.Nomor_Mesin) AS Nomor_mesin, MAX(A.Nomor_Polisi) AS Nomor_Polisi, 
                MAX(A.Nomor_BPKB) AS Nomor_BPKB, MAX(A.Asal_usul) AS Asal_Usul, MAX(A.Kondisi) AS Kondisi, SUM(A.Harga) AS Harga, MAX(A.Masa_Manfaat) AS Masa_Manfaat, SUM(A.Nilai_Sisa) AS Nilai_Sisa, MAX(A.Keterangan) AS Keterangan, MAX(A.Tahun) AS Tahun
	FROM @UBAHDATA A 
        GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
	)B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_ASet1 = B.Kd_ASet1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 
              AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register 

	RETURN END


GO
