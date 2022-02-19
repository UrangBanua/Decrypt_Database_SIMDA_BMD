USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** Rpt108Kondisi - 11052020 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE dbo.Rpt108Kondisi @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kondisi varchar(2), @Pemilik varchar(2),  @D2 Datetime
WITH ENCRYPTION
AS

/*
DECLARE @Tahun varchar(4),  @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), 
@Kondisi varchar(2), @Pemilik varchar(2), @D2 Datetime

SET @Tahun = '2019'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '9'
SET @Kd_Unit = '2'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kondisi = '3'
SET @Pemilik = '11'
SET @D2 = '20191231'
--*/


	IF ISNULL(@Kd_Prov, '') = '' SET @Kd_Prov = '%'
	IF ISNULL(@Kd_Kab_Kota, '') = '' SET @Kd_Kab_Kota = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	IF ISNULL(@Kondisi, '') = '' SET @Kondisi = '%'
	IF ISNULL(@Pemilik, '') = '' SET @Pemilik = '%'

	DECLARE @tmpBI TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 smallint, Kd_Aset5 smallint, No_Register int, 
			Kd_Pemilik tinyint, Asal_Usul varchar(50), Kondisi varchar(2), Ur_Kondisi varchar(20), Merk varchar (50), Type varchar (50), Bahan varchar (50), Susut money, Akum_Susut money, Nilai_Sisa money,
			Tgl_Perolehan datetime, No_Dokumen varchar(100), Harga money, Keterangan varchar(255))
	DECLARE @JLap Tinyint
	SET @JLap = 1


	
------------


	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, A.Kondisi, A.Ur_Kondisi, A.Merk, A.Type, A.Bahan, 0 AS Susut, 0 AS Akum_Susut, 0 AS Nilai_Sisa,
		A.Tgl_Perolehan, A.No_Dokumen, A.Harga, A.Keterangan
	FROM (
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			A.Kd_Pemilik, A.Asal_usul, '1' AS Kondisi, 'Baik' AS Ur_Kondisi, A.Hak_Tanah AS Merk, A.Luas_M2 AS Type, A.Alamat AS Bahan,
			A.Tgl_Perolehan, A.Sertifikat_Nomor AS No_Dokumen, A.Harga, A.Keterangan
		FROM fn_Kartu108_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
		) A
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.Kondisi LIKE @Kondisi AND A.Kd_Pemilik LIKE @Pemilik 
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, A.Kondisi, A.Ur_Kondisi, A.Merk, A.Type, A.Bahan, 
		A.Tgl_Perolehan, A.No_Dokumen, A.Harga, A.Keterangan


	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, A.Kondisi, C.Uraian AS Ur_Kondisi, A.Merk, A.Type, A.Bahan, 
		SUM(ISNULL(B.Susut,0))AS Susut, SUM(ISNULL(B.Akum_Susut,0))AS Akum_Susut, SUM(ISNULL(B.Nilai_Sisa,0))AS Nilai_Sisa, 
		 A.Tgl_Perolehan, A.Nomor_Polisi AS No_Dokumen, A.Harga, A.Keterangan
	FROM fn_Kartu108_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
		Ref_Kondisi C ON A.Kondisi = C.Kd_Kondisi LEFT OUTER JOIN
		(
		SELECT A.TAHUN, A.IDPEMDA, B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, CASE A.Nilai_Susut1 WHEN 0 THEN 0 ELSE 1 END AS Jn, 
          		  B.Kd_Aset8, B.Kd_Aset80, B.Kd_Aset81, B.Kd_Aset82, B.Kd_Aset83, B.Kd_Aset84, B.Kd_Aset85, B.No_Reg8,
        		   A.Harga, 0 AS Susut1, 0 AS Susut2, (A.Nilai_Susut1+A.Nilai_Susut2) AS Susut, 
        		    A.Akum_Susut, A.Nilai_Sisa
     		FROM Ta_SusutB A INNER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
    		 WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND 
        		   (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB) AND (B.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)
			AND (A.Tahun = @Tahun)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit 
			AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset = B.Kd_Aset8 AND A.Kd_Aset0 = B.Kd_Aset80 AND A.Kd_Aset1 = B.Kd_Aset81 AND A.Kd_Aset2 = B.Kd_Aset82 AND 
			A.Kd_Aset3 = B.Kd_Aset83 AND A.Kd_Aset4 = B.Kd_Aset84 AND A.Kd_Aset5 = B.Kd_Aset85 AND A.No_Register = B.No_Reg8
	WHERE /*B.TAHUN = @TAHUN AND*/(A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.Kondisi LIKE @Kondisi AND A.Kd_Pemilik LIKE @Pemilik --AND B.KD_PROV IS NULL
	GROUP BY B.IDPEMDA, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, A.Kondisi, C.Uraian, A.Merk, A.Type, A.Bahan, --B.Susut, B.Akum_Susut, B.Nilai_Sisa,
		A.Tgl_Perolehan, A.Nomor_Polisi, A.Harga, A.Keterangan


		

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, A.Kondisi, C.Uraian AS Ur_Kondisi, A. Beton_tidak AS Merk, A.Luas_Lantai AS Type, A.Lokasi AS Bahan, 
		SUM(ISNULL(B.Susut,0))AS Susut, SUM(ISNULL(B.Akum_Susut,0))AS Akum_Susut, SUM(ISNULL(B.Nilai_Sisa,0))AS Nilai_Sisa, 
		A.Tgl_Perolehan, A.Dokumen_Nomor AS No_Dokumen, A.Harga, A.Keterangan
	FROM fn_Kartu108_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
		Ref_Kondisi C ON A.Kondisi = C.Kd_Kondisi LEFT OUTER JOIN
		(
		SELECT A.TAHUN, B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, CASE A.Nilai_Susut1 WHEN 0 THEN 0 ELSE 1 END AS Jn, 
          		  B.Kd_Aset8, B.Kd_Aset80, B.Kd_Aset81, B.Kd_Aset82, B.Kd_Aset83, B.Kd_Aset84, B.Kd_Aset85, B.No_Reg8, 
        		  A.Harga, 0 AS Susut1, 0 AS Susut2, (A.Nilai_Susut1+A.Nilai_Susut2) AS Susut, 
        		  A.Akum_Susut, A.Nilai_Sisa
     		FROM Ta_SusutC A INNER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
    		 WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND 
        		   (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB) AND (B.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)
			AND (A.Tahun = @Tahun)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit 
			AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset = B.Kd_Aset8 AND A.Kd_Aset0 = B.Kd_Aset80 AND A.Kd_Aset1 = B.Kd_Aset81 AND A.Kd_Aset2 = B.Kd_Aset82 AND 
			A.Kd_Aset3 = B.Kd_Aset83 AND A.Kd_Aset4 = B.Kd_Aset84 AND A.Kd_Aset5 = B.Kd_Aset85 AND A.No_Register = B.No_Reg8

	WHERE /*B.TAHUN = @TAHUN AND*/(A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.Kondisi LIKE @Kondisi AND A.Kd_Pemilik LIKE @Pemilik 
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, A.Kondisi, C.Uraian, A. Beton_tidak, A.Luas_Lantai, A.Lokasi, --B.Susut, B.Akum_Susut, B.Nilai_Sisa,
		A.Tgl_Perolehan, A.Dokumen_Nomor, A.Harga, A.Keterangan

	


	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, A.Kondisi, C.Uraian AS Ur_Kondisi, A.Konstruksi AS Merk, A.Luas AS Type, A.Lokasi AS Bahan, 
		SUM(ISNULL(B.Susut,0))AS Susut, SUM(ISNULL(B.Akum_Susut,0))AS Akum_Susut, SUM(ISNULL(B.Nilai_Sisa,0))AS Nilai_Sisa, 

		A.Tgl_Perolehan, A.Dokumen_Nomor AS No_Dokumen, A.Harga, A.Keterangan
	FROM fn_Kartu108_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
		Ref_Kondisi C ON A.Kondisi = C.Kd_Kondisi LEFT OUTER JOIN
		(
		SELECT A.TAHUN, B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, CASE A.Nilai_Susut1 WHEN 0 THEN 0 ELSE 1 END AS Jn, 
          		  B.Kd_Aset8, B.Kd_Aset80, B.Kd_Aset81, B.Kd_Aset82, B.Kd_Aset83, B.Kd_Aset84, B.Kd_Aset85, B.No_Reg8, 
			    A.Harga, 0 AS Susut1, 0 AS Susut2, (A.Nilai_Susut1+A.Nilai_Susut2) AS Susut, 
        		    A.Akum_Susut, A.Nilai_Sisa
     		FROM Ta_SusutD A INNER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
    		 WHERE(B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND 
        		   (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB) AND (B.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)
		AND (A.Tahun = @Tahun)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit 
			AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset = B.Kd_Aset8 AND A.Kd_Aset0 = B.Kd_Aset80 AND A.Kd_Aset1 = B.Kd_Aset81 AND A.Kd_Aset2 = B.Kd_Aset82 AND 
			A.Kd_Aset3 = B.Kd_Aset83 AND A.Kd_Aset4 = B.Kd_Aset84 AND A.Kd_Aset5 = B.Kd_Aset85 AND A.No_Register = B.No_Reg8
	WHERE /*B.TAHUN = @TAHUN AND*/(A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.KOndisi LIKE @Kondisi AND A.Kd_Pemilik LIKE @Pemilik --AND A.Kd_Aset1 = @Kd_Aset1
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, A.Kondisi, C.Uraian, A.Konstruksi, A.Luas, A.Lokasi, --B.Susut, B.Akum_Susut, B.Nilai_Sisa,
		A.Tgl_Perolehan, A.Dokumen_Nomor, A.Harga, A.Keterangan

	
		

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, A.Kondisi, C.Uraian AS Ur_Kondisi, A.Judul AS Merk, A.Pencipta AS Type, A.Bahan, 
		SUM(ISNULL(B.Susut,0))AS Susut, SUM(ISNULL(B.Akum_Susut,0))AS Akum_Susut, SUM(ISNULL(B.Nilai_Sisa,0))AS Nilai_Sisa, 
		A.Tgl_Perolehan, A.Ukuran AS No_Dokumen, A.Harga, A.Keterangan
	FROM fn_Kartu108_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
		Ref_Kondisi C ON A.Kondisi = C.Kd_Kondisi LEFT OUTER JOIN
		(
		SELECT A.TAHUN, B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, CASE A.Nilai_Susut1 WHEN 0 THEN 0 ELSE 1 END AS Jn, 
          		  B.Kd_Aset8, B.Kd_Aset80, B.Kd_Aset81, B.Kd_Aset82, B.Kd_Aset83, B.Kd_Aset84, B.Kd_Aset85, B.No_Reg8, 
			  (A.Nilai_Susut1+A.Nilai_Susut2) AS Susut, 
        		  A.Akum_Susut, A.Nilai_Sisa
     		FROM Ta_SusutE A INNER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
    		 WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND 
        		(B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB) AND (B.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)
		AND (A.Tahun = @Tahun)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit 

			AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset = B.Kd_Aset8 AND A.Kd_Aset0 = B.Kd_Aset80 AND A.Kd_Aset1 = B.Kd_Aset81 AND A.Kd_Aset2 = B.Kd_Aset82 AND 
			A.Kd_Aset3 = B.Kd_Aset83 AND A.Kd_Aset4 = B.Kd_Aset84 AND A.Kd_Aset5 = B.Kd_Aset85 AND A.No_Register = B.No_Reg8
	WHERE /*B.TAHUN = @TAHUN AND*/(A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.KOndisi LIKE @Kondisi AND A.Kd_Pemilik LIKE @Pemilik --AND A.Kd_Aset1 = @Kd_Aset1
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, A.Kondisi, C.Uraian, A.Judul, A.Pencipta, A.Bahan, --B.Susut, B.Akum_Susut, B.Nilai_Sisa,
		A.Tgl_Perolehan, A.Ukuran, A.Harga, A.Keterangan

	

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, A.Kondisi, C.Uraian AS Ur_Kondisi, A. Beton_tidak AS Merk, A.Luas_Lantai AS Type, A.Lokasi AS Bahan, 0 AS Susut, 0 AS Akum_Susut, 0 AS Nilai_Sisa,
		A.Tgl_Perolehan, A.Dokumen_Nomor AS No_Dokumen, A.Harga, A.Keterangan
	FROM fn_Kartu108_BrgF(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
		Ref_Kondisi C ON A.Kondisi = C.Kd_Kondisi 
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.Kondisi LIKE @Kondisi AND A.Kd_Pemilik LIKE @Pemilik --AND A.Kd_Aset1 = @Kd_Aset1
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, A.Kondisi, C.Uraian, A. Beton_tidak, A.Luas_Lantai, A.Lokasi, --B.Susut, B.Akum_Susut, B.Nilai_Sisa,
		A.Tgl_Perolehan, A.Dokumen_Nomor, A.Harga, A.Keterangan
	
	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, A.Kondisi, C.Uraian AS Ur_Kondisi, A.Judul AS Merk, A.Pencipta AS Type, A.Bahan, 
		SUM(ISNULL(B.Susut,0))AS Susut, SUM(ISNULL(B.Akum_Susut,0))AS Akum_Susut, SUM(ISNULL(B.Nilai_Sisa,0))AS Nilai_Sisa, 

		A.Tgl_Perolehan, A.Ukuran AS No_Dokumen, A.Harga, A.Keterangan
	FROM fn_Kartu108_BrgL(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
		Ref_Kondisi C ON A.Kondisi = C.Kd_Kondisi LEFT OUTER JOIN
		(
		SELECT A.TAHUN, B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, CASE A.Nilai_Susut1 WHEN 0 THEN 0 ELSE 1 END AS Jn, 
          		  B.Kd_Aset8, B.Kd_Aset80, B.Kd_Aset81, B.Kd_Aset82, B.Kd_Aset83, B.Kd_Aset84, B.Kd_Aset85, B.No_Reg8,
	 		   A.Harga, 0 AS Susut1, 0 AS Susut2, (A.Nilai_Susut1+A.Nilai_Susut2) AS Susut, 
        		    A.Akum_Susut, A.Nilai_Sisa
     		FROM Ta_SusutL A INNER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
    		 WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND 
        		   (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB) AND (B.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)
			AND (A.Tahun = @Tahun)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit 
			AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset = B.Kd_Aset8 AND A.Kd_Aset0 = B.Kd_Aset80 AND A.Kd_Aset1 = B.Kd_Aset81 AND A.Kd_Aset2 = B.Kd_Aset82 AND 
			A.Kd_Aset3 = B.Kd_Aset83 AND A.Kd_Aset4 = B.Kd_Aset84 AND A.Kd_Aset5 = B.Kd_Aset85 AND A.No_Register = B.No_Reg8
	WHERE /*B.TAHUN = @TAHUN AND*/(A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.KOndisi LIKE @Kondisi AND A.Kd_Pemilik LIKE @Pemilik --AND A.Kd_Aset1 = @Kd_Aset1
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, A.Kondisi, C.Uraian, A.Judul, A.Pencipta, A.Bahan, --B.Susut, B.Akum_Susut, B.Nilai_Sisa,
		A.Tgl_Perolehan, A.Ukuran, A.Harga, A.Keterangan

	SELECT M.Nm_Pemda, L.Nm_Provinsi, K.Nm_Kab_KOta, J.Nm_Bidang, I.Nm_Unit, H.Nm_Sub_Unit, G.Nm_UPB, 
		A.Kd_Prov, A.Kd_Kab_Kota,
		RIGHT('00' + CONVERT(varchar, A.Kd_Prov),2) AS Kd_GabProv,
		RIGHT('00' + CONVERT(varchar, A.Kd_Prov),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Kab_Kota),2) AS Kd_Gabkab, 
		A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
		RIGHT('00' + CONVERT(varchar, A.Kd_Bidang),2) AS Kd_Gabbidang,
		RIGHT('00' + CONVERT(varchar, A.Kd_Bidang),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Unit),2) AS Kd_Gabunit,
		RIGHT('00' + CONVERT(varchar, A.Kd_Bidang),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Unit),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Sub),2) AS Kd_Gabsub,
		RIGHT('00' + CONVERT(varchar, A.Kd_Bidang),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Unit),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Sub),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_UPB),3) AS Kd_GabUPB, 
		A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		RIGHT('00' + CONVERT(varchar, A.Kd_Aset1),2) AS Kd_Gab1,
		RIGHT('00' + CONVERT(varchar, A.Kd_Aset1),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset2),2) AS Kd_Gab2,
		RIGHT('00' + CONVERT(varchar, A.Kd_Aset1),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset2),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset3),2) AS Kd_Gab3,
		RIGHT(CONVERT(varchar, A.Kd_Aset1),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset2),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset3),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset4),3) AS Kd_Gab4,
		REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab5,
		-- RIGHT(CONVERT(varchar, A.Kd_Aset1),2) + ' . ' + RIGHT(CONVERT(varchar, A.Kd_Aset2),2)+ ' . ' + RIGHT(CONVERT(varchar, A.Kd_Aset3),2)+ ' . ' + RIGHT(CONVERT(varchar, A.Kd_Aset4),3) + ' . ' + RIGHT(CONVERT(varchar, A.Kd_Aset5),3)AS Kd_Gab5, 
		A.No_Register, B.Nm_Aset1, C.Nm_Aset2, D.Nm_Aset3, E.Nm_Aset4, F.Nm_Aset5, 
		A.Kd_Pemilik, O.Nm_Pemilik, A.Asal_usul, A.Kondisi, A.Ur_Kondisi, ISNULL (A.Merk,'-') AS Merk, ISNULL (A.Type,'-') AS Type, ISNULL (A.Bahan,'-') AS Bahan,
		A.Susut, A.Akum_Susut, A.Nilai_sisa,
		A.Tgl_Perolehan, A.No_Dokumen, A.Harga, A.Keterangan,
		N.Nm_Pimpinan, N.Nip_Pimpinan, N.Jbt_Pimpinan, N.Nm_Pengurus, N.Nip_Pengurus, N.Jbt_Pengurus
	FROM @tmpBI A INNER JOIN

		Ref_Rek5_108 F ON A.Kd_Aset = F.Kd_Aset AND A.Kd_Aset0 = F.Kd_Aset0 AND A.Kd_Aset1 = F.Kd_Aset1 AND A.Kd_Aset2 = F.Kd_Aset2 AND A.Kd_Aset3 = F.Kd_Aset3 AND A.Kd_Aset4 = F.Kd_Aset4 AND A.Kd_Aset5 = F.Kd_Aset5 INNER JOIN
		Ref_Rek4_108 E ON F.Kd_Aset = E.Kd_Aset AND F.Kd_Aset0 = E.Kd_Aset0 AND F.Kd_Aset1 = E.Kd_Aset1 AND F.Kd_Aset2 = E.Kd_Aset2 AND F.Kd_Aset3 = E.Kd_Aset3 AND F.Kd_Aset4 = E.Kd_Aset4 INNER JOIN
		Ref_Rek3_108 D ON E.Kd_Aset = D.Kd_Aset AND E.Kd_Aset0 = D.Kd_Aset0 AND E.Kd_Aset1 = D.Kd_Aset1 AND E.Kd_Aset2 = D.Kd_Aset2 AND E.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
		Ref_Rek2_108 C ON D.Kd_Aset = C.Kd_Aset AND D.Kd_Aset0 = C.Kd_Aset0 AND D.Kd_Aset1 = C.Kd_Aset1 AND D.Kd_Aset2 = C.Kd_Aset2 INNER JOIN
		Ref_Rek1_108 B ON C.Kd_Aset = B.Kd_Aset AND C.Kd_Aset0 = B.Kd_Aset0 AND C.Kd_Aset1 = B.Kd_Aset1 INNER JOIN
		Ref_Rek0_108 BX ON B.Kd_Aset = BX.Kd_Aset AND B.Kd_Aset0 = BX.Kd_Aset0 INNER JOIN

		Ref_UPB G ON A.Kd_Prov = G.Kd_Prov AND A.Kd_Kab_Kota = G.Kd_Kab_Kota AND A.Kd_Bidang = G.Kd_Bidang AND A.Kd_Unit = G.Kd_Unit AND A.Kd_Sub = G.Kd_Sub AND A.Kd_UPB = G.Kd_UPB INNER JOIN
		Ref_Sub_Unit H ON G.Kd_Prov = H.Kd_Prov AND G.Kd_Kab_Kota = H.Kd_Kab_Kota AND G.Kd_Bidang = H.Kd_Bidang AND G.Kd_Unit = H.Kd_Unit AND G.Kd_Sub = H.Kd_Sub INNER JOIN
		Ref_Unit I ON H.Kd_Prov = I.Kd_Prov AND H.Kd_Kab_Kota = I.Kd_Kab_Kota AND H.Kd_Bidang = I.Kd_Bidang AND H.Kd_Unit = I.Kd_Unit INNER JOIN
		Ref_Bidang J ON I.Kd_Bidang = J.Kd_Bidang INNER JOIN
		Ref_Kab_Kota K ON A.Kd_Prov = K.Kd_Prov AND A.Kd_Kab_Kota = K.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi L ON K.Kd_Prov = L.Kd_Prov INNER JOIN
		Ref_Pemda M ON K.Kd_Prov = M.Kd_Prov AND K.Kd_Kab_Kota = M.Kd_Kab_Kota INNER JOIN
		Ref_Pemilik O ON A.Kd_Pemilik = O.Kd_Pemilik,
		(
			SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Nm_Pimpinan, A.Nip_Pimpinan, A.Jbt_Pimpinan,
				A.Nm_Pengurus, A.Nip_Pengurus, A.Jbt_Pengurus
			FROM Ta_UPB A INNER JOIN
				(
				SELECT TOP 1 Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
				FROM Ta_UPB
				WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
				ORDER BY Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
				) B ON A.Tahun = B.Tahun AND A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			) N

	ORDER BY A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register

GO
