USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** SP_Ta_Pengadaan_Ta_KIB ver 2.11 - 31072019 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE [dbo].[SP_Ta_Pengadaan_Rinc_Ta_KIB] @Tahun varchar(4), @No_Kontrak varchar(50), @Pil tinyint, @Posting tinyint
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @No_Kontrak varchar(50), @Pil tinyint, @Posting tinyint
SET @Tahun = '2019'
SET @No_Kontrak = '0029'
SET @Pil = 1
SET @Posting = 1
*/
 
IF @Pil = 1 
BEGIN
   SELECT DISTINCT A.Tahun, A.No_Kontrak, B.No_BAST, A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, 
	REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab, 
	D.Nm_Aset5, B.No_Register, B.Kd_Ruang, B.Kd_Pemilik, B.Tgl_Perolehan, B.Tgl_Pembukuan, B.Judul, B.Type, B.Ukuran, B.CC, B.Pencipta, B.Bahan, B.Nomor_Pabrik, B.Nomor_Rangka, 
	B.Nomor_Mesin, B.Nomor_Polisi, B.Nomor_BPKB, B.Luas_Lantai, B.Panjang, B.Lebar, B.Lokasi, B.Hak_Tanah, B.Penggunaan, B.Bertingkat_Tidak, B.Beton_tidak, B.Dokumen_Nomor, B.Dokumen_Tanggal, B.Konstruksi,
	B.Asal_Usul, B.Kondisi, B.Harga, B.Nilai_Sisa, B.Masa_Manfaat,
	B.Keterangan, B.No_SP2D, B.No_ID, B.Kd_Penyusutan, B.Kd_Data, 
	B.Log_User, B.Log_entry, B.Kd_KA, B.Kd_Hapus, A.Jumlah,
	A.AlokasiPenunjang AS Penunjang, A.Total_J, B.Invent
   FROM (SELECT A.Tahun, A.No_Kontrak, A.No_ID, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85,'' AS Kd_Gab,
			A.Harga, CONVERT(decimal(19,8),0) AS Jumlah, A.Jumlah_Harga, A.Biaya_Penunjang, A.Total, 
			IsNull(A.Penunjang/A.Jumlah,0) AS AlokasiPenunjang, A.Total_J
			FROM (SELECT A.Tahun, A.No_Kontrak, A.No_ID, 
				A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85,
				A.Harga, A.Jumlah, A.Jumlah_Harga, C.Biaya_Penunjang, D.Total, 
				((ROUND(CONVERT(decimal(19,8),(A.Jumlah_Harga/D.Total)),2))*C.Biaya_Penunjang) AS Penunjang, D.Total_J
			FROM (SELECT Tahun, No_Kontrak, No_ID, 
			Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85,
			Harga, Jumlah, (Jumlah * Harga) AS Jumlah_Harga FROM Ta_Pengadaan_Rinc) A INNER JOIN
			Ta_Pengadaan B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak LEFT OUTER JOIN
			(	
			SELECT A.Tahun, A.No_Kontrak, SUM(A.Nilai) AS Biaya_Penunjang
			FROM Ta_Pengadaan_SP2D_Rinc A INNER JOIN
				Ta_Pengadaan B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak
			WHERE A.Jn_SP2D = 2 AND A.Tahun = @Tahun AND A.No_Kontrak = @No_Kontrak AND B.Kd_Posting = @Posting
			GROUP BY A.Tahun, A.No_Kontrak
			) C ON A.Tahun = C.Tahun AND A.No_Kontrak = C.No_Kontrak INNER JOIN
			(
			SELECT A.Tahun, A.No_Kontrak, SUM(A.Jumlah * A.Harga) AS Total, SUM(A.Jumlah) AS Total_J
			FROM Ta_Pengadaan_Rinc A INNER JOIN
				Ta_Pengadaan B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak 
			WHERE A.Tahun = @Tahun AND A.No_Kontrak = @No_Kontrak AND B.Kd_Posting = @Posting
			GROUP BY A.Tahun, A.No_Kontrak
			) D ON A.Tahun = D.Tahun AND A.No_Kontrak = D.No_Kontrak
		WHERE A.Tahun = @Tahun AND A.No_Kontrak = @No_Kontrak AND B.Kd_Posting = @Posting) A 
	) A INNER JOIN
	(
	  SELECT A.No_Kontrak, B.Tahun, B.No_BAST, B.Kd_Aset8, B.Kd_Aset80, B.Kd_Aset81, B.Kd_Aset82, B.Kd_Aset83, B.Kd_Aset84, B.Kd_Aset85, 
		B.No_Register, B.Kd_Ruang, B.Kd_Pemilik, B.Tgl_Perolehan, B.Tgl_Pembukuan, B.Judul, B.Type, B.Ukuran, B.CC, B.Pencipta, B.Bahan, B.Nomor_Pabrik, B.Nomor_Rangka, 
		B.Nomor_Mesin, B.Nomor_Polisi, B.Nomor_BPKB, B.Luas_Lantai, B.Panjang, B.Lebar, B.Lokasi, B.Hak_Tanah, B.Penggunaan, B.Bertingkat_Tidak, B.Beton_tidak, B.Dokumen_Nomor, B.Dokumen_Tanggal, B.Konstruksi,
		B.Asal_Usul, B.Kondisi, B.Harga, B.Nilai_Sisa, B.Masa_Manfaat,
		B.Keterangan, B.No_SP2D, B.No_ID, B.Kd_Penyusutan, B.Kd_Data, 
		B.Log_User, B.Log_entry, B.Kd_KA, B.Kd_Hapus, B.Invent
	  FROM Ta_Pengadaan_Bast A INNER JOIN 
		Ta_Pengadaan_Bast_Rinc B ON A.Tahun = B.Tahun AND A.No_BAST = B.No_BAST
	  WHERE A.Tahun = @Tahun AND A.No_Kontrak = @No_Kontrak 
	) B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak AND 
		A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84 AND A.Kd_Aset85 = B.Kd_Aset85 /*AND A.Harga = B.Harga*/ INNER JOIN
	Ref_Rek5_108 D ON B.Kd_Aset8 = D.Kd_Aset AND B.Kd_Aset80 = D.Kd_Aset0 AND B.Kd_Aset81 = D.Kd_Aset1 AND B.Kd_Aset82 = D.Kd_Aset2 AND B.Kd_Aset83 = D.Kd_Aset3 AND B.Kd_Aset84 = D.Kd_Aset4 AND B.Kd_Aset85 = D.Kd_Aset5
END

IF @Pil = 2
BEGIN
  SELECT DISTINCT A.Tahun, A.No_Kontrak, B.No_BAST, A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, 
	REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab, 
	D.Nm_Aset5, B.No_Register, B.Kd_Ruang, B.Kd_Pemilik, B.Tgl_Perolehan, B.Tgl_Pembukuan, B.Judul, B.Type, B.Ukuran, B.CC, B.Pencipta, B.Bahan, B.Nomor_Pabrik, B.Nomor_Rangka, 
	B.Nomor_Mesin, B.Nomor_Polisi, B.Nomor_BPKB, B.Luas_Lantai, B.Panjang, B.Lebar, B.Lokasi, B.Hak_Tanah, B.Penggunaan, B.Bertingkat_Tidak, B.Beton_tidak, B.Dokumen_Nomor, B.Dokumen_Tanggal, B.Konstruksi,
	B.Asal_Usul, B.Kondisi, B.Harga, B.Nilai_Sisa, B.Masa_Manfaat,
	B.Keterangan, B.No_SP2D, B.No_ID, B.Kd_Penyusutan, B.Kd_Data, 
	B.Log_User, B.Log_entry, B.Kd_KA, B.Kd_Hapus, A.Jumlah,
	CASE WHEN B.No_Register = 1 THEN A.AlokasiPenunjang ELSE 0 END AS Penunjang, A.Total_J, B.Invent
   FROM (SELECT A.Tahun, A.No_Kontrak, A.No_ID, 
	--A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, '' AS Kd_Gab,
	A.Harga, CONVERT(decimal(19,8),0) AS Jumlah, A.Jumlah_Harga, A.Biaya_Penunjang, A.Total, 
	IsNull(A.Penunjang,0) AS AlokasiPenunjang, A.Total_J
	  FROM (SELECT A.Tahun, A.No_Kontrak, A.No_ID, 
			--A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
			A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85,
			A.Harga, A.Jumlah, A.Jumlah_Harga, C.Biaya_Penunjang, D.Total, 
			C.Biaya_Penunjang AS Penunjang, D.Total_J
		FROM (SELECT Tahun, No_Kontrak, No_ID, 
			Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, 
			Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85,
			Harga, Jumlah, (Jumlah * Harga) AS Jumlah_Harga FROM Ta_Pengadaan_Rinc) A INNER JOIN
			Ta_Pengadaan B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak LEFT OUTER JOIN
			(	
			SELECT A.Tahun, A.No_Kontrak, A.No_ID, 
			--A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
			A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85,
			(A.Jumlah * A.Harga) AS Jumlah_Harga, B.Nilai AS Biaya_Penunjang
			FROM Ta_Pengadaan_Rinc A INNER JOIN Ta_Pengadaan_SP2D_Rinc B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak
				INNER JOIN Ta_Pengadaan C ON A.Tahun = C.Tahun AND A.No_Kontrak = C.No_Kontrak 
			WHERE A.No_Kontrak = @No_Kontrak 
			AND (A.Jumlah * A.Harga) = (SELECT MAX((A.Jumlah * A.Harga)) AS Jumlah_Harga FROM Ta_Pengadaan_Rinc A WHERE A.No_Kontrak = @No_Kontrak)
			AND B.Jn_SP2D = 2 AND A.Tahun = @Tahun AND A.No_Kontrak = @No_Kontrak AND C.Kd_Posting = @Posting
			) C ON A.Tahun = C.Tahun AND A.No_Kontrak = C.No_Kontrak AND A.No_ID = C.No_ID INNER JOIN
			(
			SELECT A.Tahun, A.No_Kontrak, SUM(A.Jumlah * A.Harga) AS Total, SUM(A.Jumlah) AS Total_J
			FROM Ta_Pengadaan_Rinc A INNER JOIN
				Ta_Pengadaan B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak 
			WHERE A.Tahun = @Tahun AND A.No_Kontrak = @No_Kontrak AND B.Kd_Posting = @Posting
			GROUP BY A.Tahun, A.No_Kontrak
			) D ON A.Tahun = D.Tahun AND A.No_Kontrak = D.No_Kontrak
		WHERE A.Tahun = @Tahun AND A.No_Kontrak = @No_Kontrak AND B.Kd_Posting = @Posting) A 
	) A INNER JOIN
	(
	  SELECT A.No_Kontrak, B.Tahun, B.No_BAST, 
	    --B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, 
	    B.Kd_Aset8, B.Kd_Aset80, B.Kd_Aset81, B.Kd_Aset82, B.Kd_Aset83, B.Kd_Aset84, B.Kd_Aset85, 
		B.No_Register, B.Kd_Ruang, B.Kd_Pemilik, B.Tgl_Perolehan, B.Tgl_Pembukuan, B.Judul, B.Type, B.Ukuran, B.CC, B.Pencipta, B.Bahan, B.Nomor_Pabrik, B.Nomor_Rangka, 
		B.Nomor_Mesin, B.Nomor_Polisi, B.Nomor_BPKB, B.Luas_Lantai, B.Panjang, B.Lebar, B.Lokasi, B.Hak_Tanah, B.Penggunaan, B.Bertingkat_Tidak, B.Beton_tidak, B.Dokumen_Nomor, B.Dokumen_Tanggal, B.Konstruksi,
		B.Asal_Usul, B.Kondisi, B.Harga, B.Nilai_Sisa, B.Masa_Manfaat,
		B.Keterangan, B.No_SP2D, B.No_ID, B.Kd_Penyusutan, B.Kd_Data, 
		B.Log_User, B.Log_entry, B.Kd_KA, B.Kd_Hapus, B.Invent
	  FROM Ta_Pengadaan_Bast A INNER JOIN 
		Ta_Pengadaan_Bast_Rinc B ON A.Tahun = B.Tahun AND A.No_BAST = B.No_BAST
	  WHERE A.Tahun = @Tahun AND A.No_Kontrak = @No_Kontrak 
	) B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak AND 
		A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83 AND A.Kd_Aset84 = B.Kd_Aset84 AND A.Kd_Aset85 = B.Kd_Aset85 /*AND A.Harga = B.Harga*/ INNER JOIN
	--Ref_Map5_17_108 C ON A.Kd_Aset1 = C.Kd1 AND A.Kd_Aset2 = C.Kd2 AND A.Kd_Aset3 = C.Kd3 AND A.Kd_Aset4 = C.Kd4 AND A.Kd_Aset5 = C.Kd5 INNER JOIN
	Ref_Rek5_108 D ON B.Kd_Aset8 = D.Kd_Aset AND B.Kd_Aset80 = D.Kd_Aset0 AND B.Kd_Aset81 = D.Kd_Aset1 AND B.Kd_Aset82 = D.Kd_Aset2 AND B.Kd_Aset83 = D.Kd_Aset3 AND B.Kd_Aset84 = D.Kd_Aset4 AND B.Kd_Aset85 = D.Kd_Aset5
	--Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
END






GO
