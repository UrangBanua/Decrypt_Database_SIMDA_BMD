USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/* RptLampiranSKPenghapusan - 13032017 - Modified for Ver 2.0.7 [demi@simda.id] */
CREATE PROCEDURE dbo.RptLampiranSKPenghapusanSusut @Tahun varchar(4), @No_SK Varchar(50), @Kd_Hapus varchar(1)
WITH ENCRYPTION
AS
/*
DECLARE	@Tahun varchar(4), @No_SK Varchar(50), @Kd_Hapus varchar(1)
SET @Tahun = '2016'
SET @No_SK = '123'
SET @Kd_Hapus = '2'
*/
	--Buat temporary table
	DECLARE	@tmpPenghapusan Table(No_SK Varchar(75), Tgl_SK datetime, Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint,
		Kd_Sub smallint, Kd_UPB int, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint,
		Kd_Pemilik tinyint, No_Register int, Tgl_Perolehan datetime, Kondisi Varchar(2), Nilai money, Keterangan Varchar(255))
	DECLARE	@tmpsusut Table(Tahun smallint, IDPemda varchar (17), Harga money, Nilai_Susut1 money, Nilai_Susut2 money, Akum_Susut money, Nilai_Sisa money, Sisa_Umur smallint, Jndt varchar (1), Kawal varchar (1))
	DECLARE	@tmpKIB Table(IDPEMDA varchar (17), Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, 
		Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int)

	--Input ke temporary table
	INSERT INTO @tmpPenghapusan
	SELECT	A.No_SK, A.Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1,
		A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, 
		'' AS Kondisi, A.Harga AS Nilai, A.Keterangan
	FROM	Ta_KIBAHapus A
	WHERE	A.No_SK = @No_SK AND YEAR(A.Tgl_SK) < = @Tahun

	INSERT INTO @tmpPenghapusan
	SELECT	B.No_SK, B.Tgl_SK, B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Kd_Aset1,
		B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.Kd_Pemilik, B.No_Register, B.Tgl_Perolehan, 
		'' AS Kondisi, A.Harga AS Nilai, A.Keterangan
	FROM	Ta_KIBAR A INNER JOIN
		Ta_KIBAHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	B.No_SK = @No_SK AND YEAR(B.Tgl_SK) < = @Tahun AND A.Kd_Riwayat IN (2,21)

	INSERT INTO @tmpPenghapusan
	SELECT	A.No_SK, A.Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1,
		A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, 
		A.Kondisi, A.Harga AS Nilai, A.Keterangan
	FROM	Ta_KIBBHapus A
	WHERE	A.No_SK = @No_SK AND YEAR(A.Tgl_SK) < = @Tahun 

	INSERT INTO @tmpPenghapusan
	SELECT	B.No_SK, B.Tgl_SK, B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Kd_Aset1,
		B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.Kd_Pemilik, B.No_Register, B.Tgl_Perolehan, 
		B.Kondisi, A.Harga AS Nilai, A.Keterangan
	FROM	Ta_KIBBR A INNER JOIN
		Ta_KIBBHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	B.No_SK = @No_SK AND YEAR(B.Tgl_SK) < = @Tahun AND A.Kd_Riwayat IN (2,21)


	INSERT INTO @tmpPenghapusan
	SELECT	A.No_SK, A.Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1,
		A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, 
		A.Kondisi, A.Harga AS Nilai, A.Keterangan
	FROM	Ta_KIBCHapus A
	WHERE	A.No_SK = @No_SK AND YEAR(A.Tgl_SK) < = @Tahun

	INSERT INTO @tmpPenghapusan
	SELECT	B.No_SK, B.Tgl_SK, B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Kd_Aset1,
		B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.Kd_Pemilik, B.No_Register, B.Tgl_Perolehan, 
		B.Kondisi, A.Harga AS Nilai, A.Keterangan
	FROM	Ta_KIBCR A INNER JOIN
		Ta_KIBCHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	B.No_SK = @No_SK AND YEAR(B.Tgl_SK) < = @Tahun AND A.Kd_Riwayat IN (2,21)


	INSERT INTO @tmpPenghapusan
	SELECT	A.No_SK, A.Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1,
		A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, 
		A.Kondisi, A.Harga AS Nilai, A.Keterangan
	FROM	Ta_KIBDHapus A
	WHERE	A.No_SK = @No_SK AND YEAR(A.Tgl_SK) < = @Tahun

	INSERT INTO @tmpPenghapusan
	SELECT	B.No_SK, B.Tgl_SK, B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Kd_Aset1,
		B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.Kd_Pemilik, B.No_Register, B.Tgl_Perolehan, 
		B.Kondisi, A.Harga AS Nilai, A.Keterangan
	FROM	Ta_KIBDR A INNER JOIN
		Ta_KIBDHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	B.No_SK = @No_SK AND YEAR(B.Tgl_SK) < = @Tahun AND A.Kd_Riwayat IN (2,21)

	INSERT INTO @tmpPenghapusan
	SELECT	A.No_SK, A.Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1,
		A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, 
		A.Kondisi, A.Harga AS Nilai, A.Keterangan
	FROM	Ta_KIBEHapus A
	WHERE	A.No_SK = @No_SK AND YEAR(A.Tgl_SK) < = @Tahun

	INSERT INTO @tmpPenghapusan
	SELECT	B.No_SK, B.Tgl_SK, B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Kd_Aset1,
		B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.Kd_Pemilik, B.No_Register, B.Tgl_Perolehan, 
		B.Kondisi, A.Harga AS Nilai, A.Keterangan
	FROM	Ta_KIBER A INNER JOIN
		Ta_KIBEHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
	WHERE	B.No_SK = @No_SK AND YEAR(B.Tgl_SK) < = @Tahun AND A.Kd_Riwayat IN (2,21)

--------
	INSERT INTO @tmpsusut
	SELECT	Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt, Kawal 
	FROM	Ta_SusutB A WHERE Tahun = @Tahun

	INSERT INTO @tmpsusut
	SELECT	Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt, Kawal 
	FROM	Ta_SusutC A WHERE Tahun = @Tahun

	INSERT INTO @tmpsusut
	SELECT	Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt, Kawal 
	FROM	Ta_SusutD A WHERE Tahun = @Tahun

	INSERT INTO @tmpsusut
	SELECT	Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt, Kawal 
	FROM	Ta_SusutE A WHERE Tahun = @Tahun

	INSERT INTO @tmpKIB
	SELECT IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register FROM TA_KIB_B WHERE Kd_Hapus = 1
	INSERT INTO @tmpKIB
	SELECT IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register FROM TA_KIB_C WHERE Kd_Hapus = 1
	INSERT INTO @tmpKIB
	SELECT IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register FROM TA_KIB_D WHERE Kd_Hapus = 1
	INSERT INTO @tmpKIB
	SELECT IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register FROM TA_KIB_E WHERE Kd_Hapus = 1



		
	--Tampilkan
	SELECT	A.No_SK, A.Tgl_SK, C.Nm_Aset5, CONVERT(Varchar, RIGHT('0' + A.Kd_Pemilik, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Prov,2)) + 
		'.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Kab_Kota, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Bidang, 2)) + 
		'.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Unit, 2)) + 
		'.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Sub, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_UPB, 2)) +
		'.' + CONVERT(Varchar, RIGHT('0' + YEAR(A.Tgl_Perolehan), 2))AS Kode_Lokasi,

		CONVERT(Varchar, RIGHT('0' + A.Kd_Pemilik, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Prov,2)) + 
		'.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Kab_Kota, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Bidang, 2)) + 
		'.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Unit, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Sub, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_UPB, 2)) AS Kode_Lokasi_UPB,

		CONVERT(Varchar, RIGHT('0' + A.Kd_Aset1, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Aset2, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Aset3, 2))
		 + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Aset4, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Aset5, 2))
		 + '.' + CONVERT(Varchar, RIGHT('000' + A.No_Register, 2)) AS Kd_Barang, B.Nm_UPB, MAX(ISNULL(F.Uraian, '-')) AS Kondisi, SUM(ISNULL(A.Nilai, 0)) AS Nilai, MAX(A.Keterangan) AS Keterangan,
		D.Jab_PimpDaerah, D.Nm_PimpDaerah, E.Nm_Kab_Kota, H.IDPemda, 		    SUM(ISNULL(H.Harga,0))AS Nilai_Perolehan, SUM(ISNULL(H.Nilai_Susut1,0))AS Nilai_Susut1, 
                SUM(ISNULL(H.Nilai_Susut2,0))AS Nilai_Susut2, SUM(ISNULL(H.Akum_Susut,0))AS Akum_Susut, SUM(ISNULL(H.Nilai_Sisa,0))AS Nilai_Sisa,
	       	SUM(ISNULL(H.Akum_Susut,0))- SUM(ISNULL(H.Nilai_Susut1,0)) - SUM(ISNULL(H.Nilai_Susut2,0)) AS Akp_Awal, 
	        SUM(ISNULL(H.Akum_Susut,0)) AS AKP_Akhir, SUM(ISNULL(H.Nilai_Sisa,0)) AS Nilai_Buku

	FROM	@tmpPenghapusan A 
		LEFT OUTER JOIN (
			    SELECT Tahun, A.IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt, Kawal, 
			    Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register 
			    FROM @tmpsusut A INNER JOIN @tmpKIB B ON A.IDPEMDA = B.IDPEMDA
			    ) H 
		ON A.Kd_Prov = H.Kd_Prov AND A.Kd_Kab_Kota = H.Kd_Kab_Kota AND A.Kd_Bidang = H.Kd_Bidang AND 
		A.Kd_Unit = H.Kd_Unit AND A.Kd_Sub = H.Kd_Sub AND A.Kd_UPB = H.Kd_UPB AND A.Kd_Aset1 = H.Kd_Aset1 AND A.Kd_Aset2 = H.Kd_Aset2 AND A.Kd_Aset3 = H.Kd_Aset3
		AND A.Kd_Aset4 = H.Kd_Aset4 AND A.Kd_Aset5 = H.Kd_Aset5 AND A.No_Register = H.No_Register 
		
		INNER JOIN
		Ref_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
			A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
		Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3
			 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5 LEFT OUTER JOIN
		(SELECT	A.Tahun, A.Jab_PimpDaerah, A.Nm_PimpDaerah
		FROM	Ta_Pemda A
		WHERE	A.Tahun = @Tahun
		) D ON YEAR(A.Tgl_SK) = D.Tahun LEFT OUTER JOIN
		Ref_Kab_Kota E ON A.Kd_Prov = E.Kd_Prov AND A.Kd_Kab_Kota = E.Kd_Kab_Kota LEFT OUTER JOIN
		Ref_Kondisi F ON A.Kondisi = F.Kd_Kondisi INNER JOIN
		Ta_Penghapusan G ON A.No_SK = G.No_SK AND A.Tgl_SK = G.Tgl_SK
	WHERE	A.No_SK = @No_SK AND G.Kd_Hapus = @Kd_Hapus
	GROUP BY H.IDPemda, A.No_SK, A.Tgl_SK, A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, C.Nm_Aset5,
		A.Tgl_Perolehan, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		B.Nm_UPB, --F.Uraian, --A.Keterangan,
		D.Jab_PimpDaerah, D.Nm_PimpDaerah, E.Nm_Kab_Kota


GO
