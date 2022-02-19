USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** Rpt108KIR - 20022020 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE dbo.Rpt108KIR @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Ruang varchar(3), @D2 Datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Ruang varchar(3), @Tanggal datetime
SET @Tahun = '2019'
SET @D2 = '20191231'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '5'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Ruang = '1'
-- */
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	IF ISNULL(@Kd_Ruang, '') = '' SET @Kd_Ruang = '%'
	DECLARE @JLap Tinyint
	SET @JLap = 0


	SELECT A.Kd_UPB, ISNULL(A.Kd_Ruang, 99) AS Kd_Ruang, J.Nm_Provinsi, I.Nm_Kab_Kota,
		G.Nm_Bidang, F.Nm_Unit, E.Nm_Sub_Unit, C.Nm_UPB, ISNULL(K.Nm_Ruang, '(tanpa ruangan)') AS Nm_Ruang, K.Nm_Pngjwb, K.Nip_Pngjwb,
		dbo.fn_KdLokasi2_108(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB) AS Kd_Lokasi,
		B.Nm_Aset5, 
		REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Brg,
		--CONVERT(varchar, A.Kd_Aset1) + '.' + CONVERT(varchar, A.Kd_Aset2) + '.' + CONVERT(varchar, A.Kd_Aset3) + '.' + RIGHT ('00' + CONVERT(varchar, A.Kd_Aset4),2) + '.' + RIGHT ('00' + CONVERT(varchar, A.Kd_Aset5),2)  AS Kd_Gab_Brg,
		CASE
		WHEN (ISNULL(A.Merk, '') <> '') AND (ISNULL(A.Type, '') <> '') THEN A.Merk + ' / ' + A.Type
		WHEN (ISNULL(A.Merk, '') <> '') THEN A.Merk
		WHEN (ISNULL(A.Type, '') <> '') THEN A.Type
		ELSE '-'
		END AS MerkType, 
		A.Ukuran, A.Bahan, A.Tahun, A.Tahun_Buku, A.Nomor_Pabrik, A.Jml, A.Harga / 1000 AS Harga, 
		A.Jml_B, A.Jml_KB, A.Jml_RB, A.Keterangan, 
		D.Nm_Pimpinan, D.Nip_Pimpinan, D.Jbt_Pimpinan, D.Nm_Pengurus, D.Nip_Pengurus, D.Jbt_Pengurus
	FROM
		(
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			CASE 
			WHEN C.TgL_Dokumen <= @D2 THEN C.Kd_Ruang
			ELSE A.Kd_Ruang
			END AS Kd_Ruang, 
			A.Kd_Pemilik, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Merk, A.Type, A.CC AS Ukuran, A.Bahan, YEAR(A.Tgl_Perolehan) AS Tahun, 
			YEAR(A.Tgl_Pembukuan) AS Tahun_Buku , A.Nomor_Pabrik, SUM(A.Harga) AS Harga, COUNT(*) AS Jml,
			SUM(CASE A.Kondisi
			WHEN 1 THEN 1
			ELSE 0
			END) AS Jml_B,
			SUM(CASE A.Kondisi
			WHEN 2 THEN 1
			ELSE 0
			END) AS Jml_KB,
			SUM(CASE A.Kondisi
			WHEN 3 THEN 1
			ELSE 0
			END) AS Jml_RB, ISNULL(A.Keterangan, '') AS Keterangan
		FROM fn_Kartu108_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
			Ta_KIBBR C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
					AND A.Kd_Aset = C.Kd_Aset8 AND A.Kd_Aset0 = C.Kd_Aset80 AND A.Kd_Aset1 = C.Kd_Aset81 AND A.Kd_Aset2 = C.Kd_Aset82 AND A.Kd_Aset3 = C.Kd_Aset83 AND A.Kd_Aset4 = C.Kd_Aset84 AND A.Kd_Aset5 = C.Kd_Aset85 AND A.No_Register = C.No_Register 
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) 
		      --AND (A.Kd_Aset2 > 3) 
		     
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Ruang, A.Kd_Pemilik, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Merk, A.Type, A.CC, A.Bahan, YEAR(A.Tgl_Perolehan), YEAR(A.Tgl_Pembukuan), A.Nomor_Pabrik, ISNULL(A.Keterangan, ''), C.Kd_Ruang, C.Tgl_Dokumen

		UNION ALL

		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			CASE 
			WHEN C.TgL_Dokumen <= @D2 THEN C.Kd_Ruang
			ELSE A.Kd_Ruang
			END AS Kd_Ruang, 
			A.Kd_Pemilik, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Judul, A.Pencipta, 
			--A.Ukuran, A.Bahan,
			CASE A.Kd_Aset2
			WHEN 3 THEN CONVERT(varchar, A.Ukuran) + CASE ISNULL(A.Bahan, '') WHEN '' THEN '' ELSE ' ' + A.Bahan END
			ELSE CONVERT(varchar, A.Ukuran)
			END AS Ukuran, 
			CASE A.Kd_Aset2
			WHEN 3 THEN ''
			ELSE A.Bahan
			END AS Bahan,
			
			YEAR(A.Tgl_Perolehan) AS Tahun, YEAR(A.Tgl_Pembukuan) AS Tahun_Buku,'', SUM(A.Harga) AS Harga, COUNT(*) AS Jml,
			SUM(CASE A.Kondisi
			WHEN 1 THEN 1
			ELSE 0
			END) AS Jml_B,
			SUM(CASE A.Kondisi
			WHEN 2 THEN 1
			ELSE 0
			END) AS Jml_KB,
			SUM(CASE A.Kondisi
			WHEN 3 THEN 1
			ELSE 0
			END) AS Jml_RB, ISNULL(A.Keterangan, '') AS Keterangan
		FROM fn_Kartu108_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
		     Ta_KIBER C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
					AND A.Kd_Aset = C.Kd_Aset8 AND A.Kd_Aset0 = C.Kd_Aset80 AND A.Kd_Aset1 = C.Kd_Aset81 AND A.Kd_Aset2 = C.Kd_Aset82 AND A.Kd_Aset3 = C.Kd_Aset83 AND A.Kd_Aset4 = C.Kd_Aset84 AND A.Kd_Aset5 = C.Kd_Aset85 AND A.No_Register = C.No_Register 
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) 
			
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Ruang, A.Kd_Pemilik, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Judul, A.Pencipta, 
			--A.Ukuran, A.Bahan,
			CASE A.Kd_Aset2
			WHEN 3 THEN CONVERT(varchar, A.Ukuran) + CASE ISNULL(A.Bahan, '') WHEN '' THEN '' ELSE ' ' + A.Bahan END
			ELSE CONVERT(varchar, A.Ukuran)
			END, 
			CASE A.Kd_Aset2
			WHEN 3 THEN ''
			ELSE A.Bahan
			END,
			YEAR(A.Tgl_Perolehan), YEAR (A.Tgl_Pembukuan), ISNULL(A.Keterangan, ''), C.Kd_Ruang, C.Tgl_Dokumen
		) A INNER JOIN
		Ref_Rek5_108 B ON A.Kd_Aset = B.Kd_Aset AND A.Kd_Aset0 = B.Kd_Aset0 AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
		Ref_UPB C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB INNER JOIN
		Ref_Sub_Unit E ON C.Kd_Prov = E.Kd_Prov AND C.Kd_Kab_Kota = E.Kd_Kab_Kota AND C.Kd_Bidang = E.Kd_Bidang AND C.Kd_Unit = E.Kd_Unit AND C.Kd_Sub = E.Kd_Sub INNER JOIN
		Ref_Unit F ON E.Kd_Prov = F.Kd_Prov AND E.Kd_Kab_Kota = F.Kd_Kab_Kota AND E.Kd_Bidang = F.Kd_Bidang AND E.Kd_Unit = F.Kd_Unit INNER JOIN
		Ref_Bidang G ON F.Kd_Bidang = G.Kd_Bidang INNER JOIN
		Ref_Kab_Kota I ON A.Kd_Prov = I.Kd_Prov AND A.Kd_Kab_Kota = I.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi J ON I.Kd_Prov = J.Kd_Prov LEFT OUTER JOIN
		(
		SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Ruang, Nm_Ruang, Nm_Pngjwb, Nip_Pngjwb
		FROM Ta_Ruang
		WHERE (Tahun = @Tahun)
		) K ON A.Kd_Prov = K.Kd_Prov AND A.Kd_Kab_Kota = K.Kd_Kab_Kota AND A.Kd_Bidang = K.Kd_Bidang AND A.Kd_Unit = K.Kd_Unit AND A.Kd_Sub = K.Kd_Sub AND A.Kd_UPB = K.Kd_UPB AND A.Kd_Ruang = K.Kd_Ruang,
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
		) D
	WHERE ISNULL(A.Kd_Ruang, '') LIKE @Kd_Ruang
	GROUP BY A.Kd_UPB, A.Kd_Ruang, J.Nm_Provinsi, I.Nm_Kab_Kota, G.Nm_Bidang, F.Nm_Unit, E.Nm_Sub_Unit, C.Nm_UPB, K.Nm_Ruang, K.Nm_Pngjwb, K.Nip_Pngjwb, 
		B.Nm_Aset5,A.Ukuran, A.Bahan, A.Tahun, A.Tahun_Buku, A.Nomor_Pabrik, A.Jml, 
		A.Jml_B, A.Jml_KB, A.Jml_RB, A.Keterangan, A.Merk, A.Type, A.Harga, 
		D.Nm_Pimpinan, D.Nip_Pimpinan, D.Jbt_Pimpinan, D.Nm_Pengurus, D.Nip_Pengurus, D.Jbt_Pengurus,
		A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub,
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	ORDER BY Kd_Lokasi, A.Kd_UPB, ISNULL(A.Kd_Ruang, 99), Kd_Gab_Brg, A.Tahun










GO
