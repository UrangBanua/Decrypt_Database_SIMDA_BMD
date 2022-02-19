USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[RptLampiranSKPenghapusan_Sebagian] @Tahun varchar(4), @No_SK Varchar(50), @Kd_Hapus varchar(1)
WITH ENCRYPTION
AS

/*
DECLARE	@Tahun varchar(4), @No_SK Varchar(50), @Kd_Hapus varchar(1)
SET @Tahun = '2011'
SET @No_SK = '101/DPPKAD/2011'
SET @Kd_Hapus = '1'
*/
	--Buat temporary table
	DECLARE	@tmpPenghapusan Table(No_SK Varchar(75), Tgl_SK datetime, Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint,
		Kd_Sub smallint, Kd_UPB int, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint,
		Kd_Pemilik tinyint, No_Register int, Tgl_Perolehan datetime, Kondisi Varchar(2), Nilai money, Keterangan Varchar(255))

	--Input ke temporary table
	INSERT INTO @tmpPenghapusan
	SELECT	A.No_Dokumen, A.Tgl_Dokumen, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1,
		A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, 
		'' AS Kondisi, A.Harga AS Nilai, A.Keterangan
	FROM	Ta_KIBAR A
	WHERE	A.No_Dokumen = @No_SK AND YEAR(A.Tgl_Dokumen) < = @Tahun AND A.Kd_Riwayat = 7

	INSERT INTO @tmpPenghapusan
	SELECT	A.No_Dokumen, A.Tgl_Dokumen, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1,
		A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, 
		A.Kondisi, A.Harga AS Nilai, A.Keterangan
	FROM	Ta_KIBBR A
	WHERE	A.No_Dokumen = @No_SK AND YEAR(A.Tgl_Dokumen) < = @Tahun AND A.Kd_Riwayat = 7

	INSERT INTO @tmpPenghapusan
	SELECT	A.No_Dokumen, A.Tgl_Dokumen, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1,
		A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, 
		A.Kondisi, A.Harga AS Nilai, A.Keterangan
	FROM	Ta_KIBCR A
	WHERE	A.No_Dokumen = @No_SK AND YEAR(A.Tgl_Dokumen) < = @Tahun AND A.Kd_Riwayat = 7

	INSERT INTO @tmpPenghapusan
	SELECT	A.No_Dokumen, A.Tgl_Dokumen, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1,
		A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, 
		A.Kondisi, A.Harga AS Nilai, A.Keterangan
	FROM	Ta_KIBDR A
	WHERE	A.No_Dokumen = @No_SK AND YEAR(A.Tgl_Dokumen) < = @Tahun AND A.Kd_Riwayat = 7

	INSERT INTO @tmpPenghapusan
	SELECT	A.No_Dokumen, A.Tgl_Dokumen, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1,
		A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, 
		A.Kondisi, A.Harga AS Nilai, A.Keterangan
	FROM	Ta_KIBER A
	WHERE	A.No_Dokumen = @No_SK AND YEAR(A.Tgl_Dokumen) < = @Tahun AND A.Kd_Riwayat = 7


	--Tampilkan
	SELECT	A.No_SK, A.Tgl_SK,C.Nm_Aset5, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
		CONVERT(Varchar, RIGHT('0' + A.Kd_Pemilik, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Prov,2)) + 
		'.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Kab_Kota, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Bidang, 2)) + 
		'.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Unit, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Unit, 2)) +
		'.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Sub, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_UPB, 2)) +
		'.' + CONVERT(Varchar, RIGHT('0' + YEAR(A.Tgl_Perolehan), 2))AS Kode_Lokasi,
		CONVERT(Varchar, RIGHT('0' + A.Kd_Aset1, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Aset2, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Aset3, 2))
		 + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Aset4, 2)) + '.' + CONVERT(Varchar, RIGHT('0' + A.Kd_Aset5, 2))
		 + '.' + CONVERT(Varchar, RIGHT('000' + A.No_Register, 2)) AS Kd_Barang, B.Nm_UPB, ISNULL(F.Uraian, '-') AS Kondisi, ISNULL(H.Harga_Awal, 0) AS Harga_Awal,
		ISNULL(A.Nilai, 0) AS Nilai, ISNULL(H.Harga_Awal - A.Nilai, 0) AS Nilai_Sisa, A.Keterangan,
		D.Jab_PimpDaerah, D.Nm_PimpDaerah, E.Nm_Kab_Kota
	FROM	@tmpPenghapusan A INNER JOIN
		Ref_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
			A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
		Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3
			 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5 LEFT OUTER JOIN
		Ref_Kab_Kota E ON A.Kd_Prov = E.Kd_Prov AND A.Kd_Kab_Kota = E.Kd_Kab_Kota LEFT OUTER JOIN
		Ref_Kondisi F ON A.Kondisi = F.Kd_Kondisi INNER JOIN
		Ta_Penghapusan G ON A.No_SK = G.No_SK AND A.Tgl_SK = G.Tgl_SK AND G.Kd_Hapus = @Kd_Hapus INNER JOIN
		(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Pemilik, A.Kd_Aset1, A.Kd_Aset2, 
			A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, SUM(A.Harga) AS Harga_Awal
		FROM	Ta_KIB_A A
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Pemilik, A.Kd_Aset1, A.Kd_Aset2, 
			 A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		
		UNION ALL
		
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Pemilik, A.Kd_Aset1, A.Kd_Aset2, 
			A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, SUM(A.Harga) AS Harga_Awal
		FROM	Ta_KIB_B A
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Pemilik, A.Kd_Aset1, A.Kd_Aset2, 
			 A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		
		UNION ALL
		
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Pemilik, A.Kd_Aset1, A.Kd_Aset2, 
			A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, SUM(A.Harga) AS Harga_Awal
		FROM	Ta_KIB_C A
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Pemilik, A.Kd_Aset1, A.Kd_Aset2, 
			 A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		
		UNION ALL
		
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Pemilik, A.Kd_Aset1, A.Kd_Aset2, 
			A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, SUM(A.Harga) AS Harga_Awal
		FROM	Ta_KIB_D A
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Pemilik, A.Kd_Aset1, A.Kd_Aset2, 
			 A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		
		UNION ALL
		
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Pemilik, A.Kd_Aset1, A.Kd_Aset2, 
			A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, SUM(A.Harga) AS Harga_Awal
		FROM	Ta_KIB_E A
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Pemilik, A.Kd_Aset1, A.Kd_Aset2, 
			 A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		) H ON A.Kd_Prov = H.Kd_Prov AND A.Kd_Kab_Kota = H.Kd_Kab_Kota AND A.Kd_Bidang = H.Kd_Bidang AND A.Kd_Unit = H.Kd_Unit AND
			A.Kd_Sub = H.Kd_Sub AND A.Kd_UPB = H.Kd_UPB AND A.Kd_Aset1 = H.Kd_Aset1 AND A.Kd_Aset2 = H.Kd_Aset2 AND 
			A.Kd_Aset3 = H.Kd_Aset3 AND A.Kd_Aset4 = H.Kd_Aset4 AND A.Kd_Aset5 = H.Kd_Aset5 AND A.No_Register = H.No_Register,
		(SELECT	A.Tahun, A.Jab_PimpDaerah, A.Nm_PimpDaerah
		FROM	Ta_Pemda A
		WHERE	A.Tahun = @Tahun
		) D --LEFT OUTER JOIN--ON YEAR(A.Tgl_SK) = D.Tahun 
	WHERE	A.No_SK = @No_SK AND G.Kd_Hapus = @Kd_Hapus





GO
