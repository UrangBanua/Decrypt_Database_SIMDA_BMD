USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** RptGuna_Usaha - 08032017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE dbo.RptGuna_Usaha @Tahun Varchar(4), @Kd_Prov Varchar(3), @Kd_Kab_Kota Varchar(3), @Kd_Bidang Varchar(3), @Kd_Unit Varchar(3), @Kd_Sub Varchar(3), @Kd_UPB Varchar(3)
WITH ENCRYPTION
AS

/*
DECLARE @Tahun Varchar(4), @Kd_Prov Varchar(3), @Kd_Kab_Kota Varchar(3), @Kd_Bidang Varchar(3), @Kd_Unit Varchar(3), @Kd_Sub Varchar(3), @Kd_UPB Varchar(3)
SET @Tahun = '2016'
SET @Kd_Prov = '30'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
*/
	DECLARE @JLap Tinyint SET @JLap = 0
	DECLARE @TahunL Varchar(8) 
	SET @TahunL =   @Tahun + '1231'

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'


	DECLARE @Guna_Usaha Table(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset1 tinyint,
		Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register smallint, Nm_Aset varchar(255), Kd_Riwayat tinyint, Nm_Riwayat varchar(100), 
		No_Dokumen varchar(250), Alamat varchar(255), Asal_Usul varchar(50), Tgl_Perolehan datetime, Konstruksi varchar(25), Kondisi varchar(2), Luas float, Harga money,
		No_SK varchar(75), Tgl_SK datetime, Tgl_Mulai datetime, Tgl_Selesai datetime, Nama_Rekanan varchar(200), Alamat_Rekanan varchar(200))
	



	INSERT INTO @Guna_Usaha
	SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
	A.No_Register, A.Nm_Aset5, A.Kd_Riwayat, A.Nm_Riwayat, A.No_Dokumen, A.Alamat, A.Asal_Usul, A.Tgl_Perolehan, A.Konstruksi, A.Kondisi, A.Luas, A.Harga, 
	A.No_SK, A.Tgl_SK, A.Tgl_Mulai, A.Tgl_Selesai, A.Nama_Rekanan, A.Alamat_Rekanan
	FROM
	(
	SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.No_Register, A.Nm_Aset5, A.Kd_Riwayat, A.Nm_Riwayat, A.No_Dokumen, A.Alamat, A.Asal_Usul, A.Tgl_Perolehan, A.Konstruksi, A.Kondisi, A.Luas, A.Harga,
		A.No_SK, A.Tgl_SK, A.Tgl_Mulai, A.Tgl_Selesai, A.Nama_Rekanan, A.Alamat_Rekanan
	FROM
		(--KIB A
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.No_Register, C.Nm_Aset5, B.Kd_Riwayat, D.Nm_Riwayat, A.No_Dok AS No_Dokumen, A.Alamat, A.Asal_Usul, A.Tgl_Perolehan, '' AS Konstruksi, '' AS Kondisi, A.Luas_M2 AS Luas, A.Harga,
			B.No_Dokumen AS No_SK, B.TGL_DOKUMEN AS Tgl_SK, B.Tgl_Mulai, B.Tgl_Selesai, B.Nm_Rekanan AS Nama_Rekanan, B.Alamat_Reakanan AS Alamat_Rekanan
		FROM	fn_Kartu_BrgA(@TahunL,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,'%','%','%','%','%','%',@JLap) A LEFT OUTER JOIN
			Ta_KIBAR B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				      A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND
				      A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register INNER JOIN
			Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND
			                   A.Kd_Aset5 = C.Kd_Aset5 LEFT OUTER JOIN
			Ref_Riwayat D ON B.Kd_Riwayat = D.Kd_Riwayat
		WHERE	(B.Kd_Riwayat IN(8,9,10,11,12,13))
		) A

	UNION ALL

	SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.No_Register, A.Nm_Aset5, A.Kd_Riwayat, A.Nm_Riwayat, A.No_Dokumen, A.Alamat, A.Asal_Usul, A.Tgl_Perolehan, A.Konstruksi, A.Kondisi, A.Luas, A.Harga,
		A.No_SK, A.Tgl_SK, A.Tgl_Mulai, A.Tgl_Selesai, A.Nama_Rekanan, A.Alamat_Rekanan
	FROM
		(--KIB B
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.No_Register, C.Nm_Aset5, B.Kd_Riwayat, D.Nm_Riwayat, A.No_Dokumen, E.Alamat, A.Asal_Usul, A.Tgl_Perolehan, '' AS Konstruksi, B.Kondisi, 0 AS Luas, A.Harga,
			B.No_Dokumen AS No_SK, B.TGL_DOKUMEN AS Tgl_SK, B.Tgl_Mulai, B.Tgl_Selesai, B.Nm_Rekanan AS Nama_Rekanan, B.Alamat_Reakanan AS Alamat_Rekanan
		FROM	fn_Kartu_BrgB(@TahunL,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,'%','%','%','%','%','%',@JLap) A LEFT OUTER JOIN
			Ta_KIBBR B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				      A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND
				      A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register INNER JOIN
			Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND
			                   A.Kd_Aset5 = C.Kd_Aset5 LEFT OUTER JOIN
			Ref_Riwayat D ON B.Kd_Riwayat = D.Kd_Riwayat INNER JOIN
			Ta_UPB E ON A.Kd_Prov = E.Kd_Prov AND A.Kd_Kab_Kota = E.Kd_Kab_Kota AND A.Kd_Bidang = E.Kd_Bidang AND A.Kd_Unit = E.Kd_Unit AND A.Kd_Sub = E.Kd_Sub AND A.Kd_UPB = E.Kd_UPB
		WHERE	(B.Kd_Riwayat IN(8,9,10,11,12,13))
		) A
	
	UNION ALL

	SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.No_Register, A.Nm_Aset5, A.Kd_Riwayat, A.Nm_Riwayat, A.No_Dokumen, A.Alamat, A.Asal_Usul, A.Tgl_Perolehan, A.Konstruksi, A.Kondisi, A.Luas, A.Harga,
		A.No_SK, A.Tgl_SK, A.Tgl_Mulai, A.Tgl_Selesai, A.Nama_Rekanan, A.Alamat_Rekanan
	FROM
		(--KIB C
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.No_Register, C.Nm_Aset5, B.Kd_Riwayat, D.Nm_Riwayat, A.Dokumen_Nomor AS No_Dokumen, A.Lokasi AS Alamat, A.Asal_Usul, A.Tgl_Perolehan, A.Beton_Tidak AS Konstruksi, B.Kondisi, A.Luas_Lantai AS Luas, A.Harga,
			B.No_Dokumen AS No_SK, B.TGL_DOKUMEN AS Tgl_SK, B.Tgl_Mulai, B.Tgl_Selesai, B.Nm_Rekanan AS Nama_Rekanan, B.Alamat_Reakanan AS Alamat_Rekanan
		FROM	fn_Kartu_BrgC(@TahunL,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,'%','%','%','%','%','%',@JLap) A LEFT OUTER JOIN
			Ta_KIBCR B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				      A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND
				      A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register INNER JOIN
			Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND
			                   A.Kd_Aset5 = C.Kd_Aset5 LEFT OUTER JOIN
			Ref_Riwayat D ON B.Kd_Riwayat = D.Kd_Riwayat
		WHERE	(B.Kd_Riwayat IN(8,9,10,11,12,13))
		) A

	UNION ALL

	SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.No_Register, A.Nm_Aset5, A.Kd_Riwayat, A.Nm_Riwayat, A.No_Dokumen, A.Alamat, A.Asal_Usul, A.Tgl_Perolehan, A.Konstruksi, A.Kondisi, A.Luas, A.Harga,
		A.No_SK, A.Tgl_SK, A.Tgl_Mulai, A.Tgl_Selesai, A.Nama_Rekanan, A.Alamat_Rekanan
	FROM
		(--KIB D
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.No_Register, C.Nm_Aset5, B.Kd_Riwayat, D.Nm_Riwayat, A.Dokumen_Nomor AS No_Dokumen, A.Lokasi AS Alamat, A.Asal_Usul, A.Tgl_Perolehan, A.Konstruksi, B.Kondisi, A.Luas, A.Harga,
			B.No_Dokumen AS No_SK, B.Tgl_Dokumen AS Tgl_SK, B.Tgl_Mulai, B.Tgl_Selesai, B.Nm_Rekanan AS Nama_Rekanan, B.Alamat_Reakanan AS Alamat_Rekanan
		FROM	fn_Kartu_BrgD(@TahunL,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,'%','%','%','%','%','%',@JLap) A LEFT OUTER JOIN
			Ta_KIBDR B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				      A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND
				      A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register INNER JOIN
			Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND
			                   A.Kd_Aset5 = C.Kd_Aset5 LEFT OUTER JOIN
			Ref_Riwayat D ON B.Kd_Riwayat = D.Kd_Riwayat
		WHERE	(B.Kd_Riwayat IN(8,9,10,11,12,13))
		) A
	) A


	SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, H.Nm_UPB, C.Nm_Provinsi, D.Nm_Kab_Kota, E.Nm_Bidang, F.Nm_Unit, G.Nm_Sub_Unit,
		B.Jbt_Pimpinan, B.Nm_Pimpinan, B.NIP_Pimpinan, B.Jbt_Pengurus, B.Nm_Pengurus, B.NIP_Pengurus,
		A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) AS Kd_Aset_Gab1,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) AS Kd_Aset_Gab2,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) AS Kd_Aset_Gab3,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 4) AS Kd_Aset_Gab4,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 4) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset5), 5) AS Kd_Aset_Gab5,
	A.Nm_Aset, A.Nm_Riwayat, A.No_Dokumen, A.Alamat, A.Asal_Usul, A.Tgl_Perolehan, ISNULL(A.Konstruksi,'-') AS Konstruksi, A.Kondisi AS Kd_Kondisi, I.Uraian AS Kondisi, A.Luas, A.Harga, A.No_SK, A.TGL_SK, A.Tgl_Mulai, A.Tgl_Selesai, A.Nama_Rekanan, A.Alamat_Rekanan
	FROM	@Guna_Usaha A INNER JOIN
		Ta_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
		Ref_Provinsi C ON B.Kd_Prov = C.Kd_Prov INNER JOIN
		Ref_Kab_Kota D ON B.Kd_Prov = D.Kd_Prov AND B.Kd_Kab_Kota = D.Kd_Kab_Kota INNER JOIN
		Ref_Bidang E ON A.Kd_Bidang = E.Kd_Bidang INNER JOIN
		Ref_Unit F ON A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit INNER JOIN
		Ref_Sub_Unit G ON A.Kd_Bidang = G.Kd_Bidang AND A.Kd_Unit = G.Kd_Unit AND A.Kd_Sub = G.Kd_Sub INNER JOIN
		Ref_UPB H ON A.Kd_Bidang = H.Kd_Bidang AND A.Kd_Unit = H.Kd_Unit AND A.Kd_Sub = H.Kd_Sub AND A.Kd_UPB = H.Kd_UPB LEFT OUTER JOIN
		Ref_Kondisi I ON A.Kondisi = I.Kd_Kondisi
	WHERE B.Tahun = @Tahun
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, H.Nm_UPB, C.Nm_Provinsi, D.Nm_Kab_Kota, E.Nm_Bidang, F.Nm_Unit, G.Nm_Sub_Unit,
	B.Jbt_Pimpinan, B.Nm_Pimpinan, B.NIP_Pimpinan, B.Jbt_Pengurus, B.Nm_Pengurus, B.NIP_Pengurus,
	A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset, A.Nm_Riwayat, A.No_Dokumen, A.Alamat, A.Asal_Usul, A.Tgl_Perolehan, A.Konstruksi,
	A.Kondisi, I.Uraian, A.Luas, A.Harga, A.No_SK,  A.TGL_SK, A.Tgl_Mulai, A.Tgl_Selesai, A.Nama_Rekanan, A.Alamat_Rekanan



GO
