USE bmd_hst2020
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION dbo.fn_Kartu108_BrgB_Awl (@D1 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(5))

RETURNS @UpdateKIB TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint,  Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int, /*Kd_Gab_Bidang varchar(3), Kd_Gab_Unit varchar(3), Kd_Gab_Sub varchar(3), Kd_Gab_UPB varchar(3), Nm_UPB Varchar(255),*/ 
		         Kd_ASet tinyint,Kd_ASet0 tinyint, Kd_ASet1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 smallint, Kd_Aset5 smallint, No_Register int, Kd_Ruang int, Kd_Pemilik tinyint, Harga Money, Masa_Manfaat smallint,  Nilai_Sisa Money,/* Kd_AsetGab Varchar(50), Nm_Aset Varchar(255),*/ Tgl_Dokumen Datetime,
			 No_Dokumen Varchar(100), Tgl_Perolehan Datetime, Tgl_Pembukuan Datetime, Merk Varchar(50), Type Varchar(50), CC Varchar(50), Bahan Varchar(50), Nomor_Pabrik Varchar(50), Nomor_Rangka Varchar(50), Nomor_Mesin Varchar(50), Nomor_Polisi Varchar(10),
			 Nomor_BPKB Varchar(50), Asal_usul Varchar(50), Kondisi Varchar(2) , /*Uraian Varchar(50),*/ Keterangan Varchar(255), Tahun Varchar(4), Kd_KA tinyint)



WITH ENCRYPTION
AS
BEGIN

/*
DECLARE @Tahun varchar(4), @D1 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4)

SET @Tahun = '2018'
SET @D1 = '20180101'
SET @Kd_Prov = '13'
SET @Kd_Kab_Kota = '33'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset  = '1'
SET @Kd_Aset0 = ''
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
	IF ISNULL (@Kd_Aset,'') = '' SET @Kd_Aset = '%'
	IF ISNULL (@Kd_Aset0,'') = '' SET @Kd_Aset0 = '%'
	IF ISNULL (@Kd_Aset1,'') = '' SET @Kd_Aset1 = '%'
	IF ISNULL (@Kd_Aset2,'') = '' SET @Kd_Aset2 = '%'
	IF ISNULL (@Kd_Aset3,'') = '' SET @Kd_Aset3 = '%'
	IF ISNULL (@Kd_Aset4,'') = '' SET @Kd_Aset4 = '%'
	IF ISNULL (@Kd_Aset5,'') = '' SET @Kd_Aset5 = '%'
	IF ISNULL (@No_Register,'') = '' SET @No_Register = '%'



DECLARE @tmpHarga TABLE(Kd_ID int, Kd_Riwayat tinyint, Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int, 
						Kd_ASet tinyint,Kd_ASet0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 smallint, Kd_Aset5 smallint, No_Register int, Harga money, Masa_Manfaat smallint, Nilai_Sisa money, Kd_Data tinyint, Kd_KA tinyint)
DECLARE @UbahData TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint,  Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int,  
						Kd_ASet tinyint,Kd_ASet0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 smallint, Kd_Aset5 smallint, No_Register int, 
						Kd_Ruang int, Kd_Pemilik tinyint, Merk Varchar(50), Type Varchar(50), CC Varchar(50), Bahan Varchar(50), Tgl_Dokumen Datetime, No_Dokumen Varchar(100),  Tgl_Perolehan Datetime , Tgl_Pembukuan Datetime, Nomor_Pabrik Varchar(50), Nomor_Rangka Varchar(50), Nomor_Mesin Varchar(50), Nomor_Polisi Varchar(10), 
            			Nomor_BPKB Varchar(50), Asal_usul Varchar(50), Kondisi Varchar(2), Harga money, Masa_Manfaat smallint, Nilai_Sisa money, Keterangan Varchar (255), Tahun Varchar(4))


--I. Data nilai dan volume
--1. PEROLEHAN 1 
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID,'0'AS Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
			Kd_Aset8,Kd_Aset80,Kd_Aset81,Kd_Aset82,Kd_Aset83,Kd_Aset84,Kd_Aset85, No_Register,  
			ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, Kd_Data, Kd_KA
	FROM	Ta_KIB_B 
	WHERE	Tgl_Pembukuan < @D1 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
			Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
			AND Kd_Data <> 3 and kd_hapus = 0 
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
			Kd_Aset8,Kd_Aset80,Kd_Aset81,Kd_Aset82,Kd_Aset83,Kd_Aset84,Kd_Aset85, No_Register,   
			Kd_Data, Kd_KA

--2. PEROLEHAN 2 
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID,Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
			Kd_Aset8,Kd_Aset80,Kd_Aset81,Kd_Aset82,Kd_Aset83,Kd_Aset84,Kd_Aset85, No_Register, 
			ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, Kd_Data, Kd_KA
	FROM	Ta_KIBBR 
	WHERE	Tgl_dokumen > @D1 AND Kd_Riwayat = 3 AND Tgl_Pembukuan <= @D1 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
			Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
			
	GROUP BY Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
			Kd_Aset8,Kd_Aset80,Kd_Aset81,Kd_Aset82,Kd_Aset83,Kd_Aset84,Kd_Aset85, No_Register,  
			Kd_Data, Kd_KA

--3. PEROLEHAN 3 
	INSERT INTO @tmpHarga
	SELECT	'0' AS KD_ID,'0'AS Kd_Riwayat,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
			Kd_Aset8,Kd_Aset80,Kd_Aset81,Kd_Aset82,Kd_Aset83,Kd_Aset84,Kd_Aset85, No_Register,  
			ISNULL(SUM(Harga),0) AS Harga, ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, 0 AS Kd_Data, Kd_KA
	FROM	Ta_KIBBHapus 
	WHERE	Tgl_SK > @D1 AND Tgl_Pembukuan <= @D1 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
			Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
			Kd_Aset8,Kd_Aset80,Kd_Aset81,Kd_Aset82,Kd_Aset83,Kd_Aset84,Kd_Aset85, No_Register,  
			Kd_KA

--4. KAPITALISASI
	INSERT INTO @tmpHarga
	SELECT	MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
		ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, NULL AS Kd_Data
	FROM	Ta_KIBBR A 
	WHERE	A.Tgl_dokumen < @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		 A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND (KD_RIWAYAT=2)
		AND A.Kd_Data <> 3 
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
			A.Kd_Data

--5. HAPUS SEBAGIAN
	INSERT INTO @tmpHarga
	SELECT	MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register,
		ISNULL(SUM(-Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, NULL AS Kd_Data
	FROM	Ta_KIBBR A
	WHERE	A.Tgl_dokumen < @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		 A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND (KD_RIWAYAT=2)
		AND A.Kd_Data <> 3 
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
			A.Kd_Data

--6. KOREKSI
	INSERT INTO @tmpHarga
	SELECT	MAX(A.Kd_ID)AS Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
		ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, A.Kd_Data, NULL AS Kd_Data
	FROM	Ta_KIBBR A 
	WHERE	A.Tgl_dokumen < @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		 A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND (KD_RIWAYAT=2)
		AND A.Kd_Data <> 3 
	GROUP BY A.Kd_ID, A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
			A.Kd_Data

--SELECT * FROM @tmpHarga

--UBAH DATA KIB B
	INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
		A.Kd_Ruang, 
	       A.Kd_Pemilik, A.Merk, A.Type, A.CC, A.Bahan, A.Tgl_Perolehan AS Tgl_Dokumen, 'Data KIB' AS No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, 
	       A.Nomor_BPKB, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun
	FROM Ta_KIB_B A LEFT OUTER JOIN
		(
		SELECT A.Kd_Riwayat, A.Kd_Id AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register
		FROM Ta_KIBBR A
		WHERE (Kd_Riwayat = 18) AND A.Tgl_Pembukuan <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
				A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND (KD_RIWAYAT=2)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
			A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND 
			A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND 
			A.Kd_Aset84 = B.Kd_Aset84 AND A.Kd_Aset85 = B.Kd_Aset85 AND A.No_Register = B.No_Register
	WHERE (B.Kd_Prov IS NULL) AND A.Tgl_Pembukuan <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		A.KD_HAPUS = 0 AND 
	    A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register

--2
    INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
			A.Kd_Ruang, 
	       A.Kd_Pemilik, A.Merk, A.Type, A.CC, A.Bahan, A.Tgl_Perolehan AS Tgl_Dokumen, 'Data KIB' AS No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, 
	       A.Nomor_BPKB, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun
	FROM Ta_KIBBHapus A LEFT OUTER JOIN
		(
		SELECT A.Kd_Riwayat, A.Kd_Id AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
     			A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register
		FROM Ta_KIBBR A
		WHERE (Kd_Riwayat = 18) AND A.Tgl_Pembukuan <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
				A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND (KD_RIWAYAT=2)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
			A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND 
			A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND 
			A.Kd_Aset84 = B.Kd_Aset84 AND A.Kd_Aset85 = B.Kd_Aset85 AND A.No_Register = B.No_Register

	WHERE (B.Kd_Prov IS NULL) AND A.Tgl_SK > @D1 AND A.Tgl_Pembukuan <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
	       A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register

--3
        INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, A.Kd_Ruang, 
	       A.Kd_Pemilik, A.Merk, A.Type, A.CC, A.Bahan, A.Tgl_Perolehan AS Tgl_Dokumen, 'Data KIB' AS No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, 
	       A.Nomor_BPKB, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun
	FROM Ta_KIBBR A LEFT OUTER JOIN
		(
		SELECT A.Kd_Riwayat, A.Kd_Id AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register
		FROM Ta_KIBBR A
		WHERE (Kd_Riwayat = 18) AND A.Tgl_Pembukuan <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
				A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND (KD_RIWAYAT=2)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
			A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND 
						A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND 
			A.Kd_Aset84 = B.Kd_Aset84 AND A.Kd_Aset85 = B.Kd_Aset85 AND A.No_Register = B.No_Register
	WHERE (B.Kd_Prov IS NULL) AND A.Tgl_dokumen > @D1 AND A.Kd_Riwayat = 3 AND A.Tgl_Pembukuan <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
	       A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register

--UBAH DATA KIB B (RIWAYAT)
	INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
			A.Kd_Ruang, 
	       A.Kd_Pemilik, A.Merk, A.Type,  A.CC, A.Bahan, A.Tgl_Dokumen, A.No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, 
	       A.Nomor_BPKB, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun
	FROM Ta_KIBBR A INNER JOIN
		(
		SELECT A.Kd_Riwayat, MAX(A.Kd_Id) AS Kd_Id, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register
		FROM Ta_KIBBR A
		WHERE Kd_Riwayat = 18
		GROUP BY A.Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register
		) B ON A.Kd_Riwayat = B.Kd_Riwayat AND A.Kd_Id = B.Kd_Id AND A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND 
				A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND 
				A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND 
				A.Kd_Aset84 = B.Kd_Aset84 AND A.Kd_Aset85 = B.Kd_Aset85 AND A.No_Register = B.No_Register

	WHERE	A.Tgl_Pembukuan <= @D1 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
	       A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register

   INSERT INTO @UpdateKIB
   SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,/* C.Kd_Gab_Bidang, C.Kd_Gab_Unit, C.Kd_Gab_Sub, C.Kd_Gab_UPB, C.Nm_UPB,*/ 
		   A.Kd_Aset, A.Kd_Aset0, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	       A.No_Register, B.Kd_Ruang, B.Kd_Pemilik, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa,/* D.Kd_AsetGab, D.Nm_Aset,*/ B.Tgl_Dokumen, B.No_Dokumen, B.Tgl_Perolehan, B.Tgl_Pembukuan, B.Merk, B.Type,  B.CC, B.Bahan, 
	       B.Nomor_Pabrik, B.Nomor_Rangka, B.Nomor_Mesin, B.Nomor_Polisi, B.Nomor_BPKB, 
	       B.Asal_usul, B.Kondisi , /*B.Uraian,*/ B.Keterangan, B.Tahun, A.Kd_KA
   FROM (
	
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,  ISNULL(SUM(A.Harga),0) AS Harga, ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, MAX(Kd_KA) AS Kd_KA
	FROM @TMPHARGA A 
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
	) A INNER JOIN
	(
	SELECT  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, 
            A.Kd_Pemilik, A.Merk, A.Type, A.CC, A.Bahan, A.Tgl_Dokumen, A.No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, 
            A.Nomor_BPKB, A.Asal_usul, A.Kondisi, /*B.Uraian,*/ A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan,A.Tahun
	FROM @UBAHDATA A /*INNER JOIN
		 REF_KONDISI B ON A.Kondisi = B.Kd_Kondisi*/
	)B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND 
			 A.Kd_ASet = B.Kd_ASet AND A.Kd_ASet0 = B.Kd_ASet0 AND A.Kd_ASet1 = B.Kd_ASet1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 
              AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register 
	
	
	RETURN END










GO
