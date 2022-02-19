USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** Rpt_Daftar_Rinci - 05012016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE dbo.Rpt_Daftar_Rinci @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @D2 Datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @D2 datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3)
SET @Tahun = 2012
SET @D2 = '20121231'
SET @Kd_Prov = '99'
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset1 = '3'
SET @Kd_Aset2 = ''
SET @Kd_Aset3 = ''
*/
	DECLARE @JLap Tinyint SET @JLap = 0

	IF ISNULL(@Kd_Kab_Kota, '') = '' SET @Kd_Kab_Kota = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	IF ISNULL(@Kd_Aset1, '') = '' SET @Kd_Aset1 = '%'
	IF ISNULL(@Kd_Aset2, '') = '' SET @Kd_Aset2 = '%'
	IF ISNULL(@Kd_Aset3, '') = '' SET @Kd_Aset3 = '%'
	IF ISNULL(@Kd_Aset4, '') = '' SET @Kd_Aset4 = '%'
	IF ISNULL(@Kd_Aset5, '') = '' SET @Kd_Aset5 = '%'	

	SELECT	MAX(K.Tahun) As Tahun1, J.Kd_Prov, J.Kd_Kab_Kota, J.Kd_Bidang, J.Kd_Unit, J.Kd_Sub, J.Kd_UPB, I.Nm_Provinsi, 
		H.Nm_Kab_Kota, N.Nm_Bidang, M.Nm_Unit, L.Nm_Sub_Unit, J.Nm_UPB, 
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) As Kd_Prov_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) As Kd_Kab_Kota_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) AS Kd_Bidang_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) AS Kd_Unit_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) AS Kd_Sub_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_UPB), 2) AS Kd_UPB_Gab,
		A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) AS Kd_Aset_Gab1,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) AS Kd_Aset_Gab2,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) AS Kd_Aset_Gab3,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 4) AS Kd_Aset_Gab4,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 4) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset5), 5) AS Kd_Aset_Gab5,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_UPB), 2) + '.' +
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 4) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset5), 5) AS Kd_Aset_UPB,
		F.Nm_Aset1, E.Nm_Aset2, D.Nm_Aset3, C.Nm_Aset4, B.Nm_Aset5,
		A.Tahun, A.Luas_M2, A.Jumlah, A.Asal_Usul, A.Harga, A.Kondisi, A.Keterangan,
		O.Nm_Pimpinan, O.Nip_Pimpinan, O.Jbt_Pimpinan, O.Nm_Pengurus, O.Nip_Pengurus, O.Jbt_Pengurus --G.Logo 

	FROM
		(
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, A.Luas_M2, 1 AS Jumlah, A.Asal_Usul, A.Harga, 'Baik' AS Kondisi, ISNULL(A.Keterangan, '') AS Keterangan
		FROM fn_Kartu_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset1, '%', '%','%','%','%',@JLap)  A 
		WHERE (A.Kd_Pemilik IN(0, 11, 12)) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5)
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan), A.Luas_M2, A.Asal_Usul, A.Harga, A.Keterangan
		
		UNION ALL
		
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, 0 AS Panjang, COUNT(*) AS Jumlah, A.Asal_Usul, SUM(A.Harga) AS Harga, 
			C.Uraian AS Kondisi, ISNULL(A.Keterangan, '') AS Keterangan
		FROM fn_Kartu_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,@Kd_Aset1, '%','%','%','%','%',@JLap) A LEFT OUTER JOIN
			Ref_Kondisi C On A.Kondisi = C.Kd_Kondisi
		WHERE (A.Kd_Pemilik IN(0, 11, 12)) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5)
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, YEAR(A.Tgl_Perolehan), A.Asal_Usul, A.Kondisi, ISNULL(A.Keterangan, ''), C.Uraian
	
		UNION ALL
	
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, A.Luas_Lantai, 1 AS Jumlah, A.Asal_Usul, A.Harga, 
			C.Uraian AS Kondisi, ISNULL(A.Keterangan, '') AS Keterangan
		FROM fn_Kartu_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset1, '%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
			Ref_Kondisi C On A.Kondisi = C.Kd_Kondisi
		WHERE (A.Kd_Pemilik IN(0, 11, 12))AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5)
		
		UNION ALL
		
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, A.Panjang, 1 AS Jumlah, A.Asal_Usul, A.Harga, 
			C.Uraian AS Kondisi, ISNULL(A.Keterangan, '') AS Keterangan
		FROM fn_Kartu_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,@Kd_Aset1, '%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
			Ref_Kondisi C On A.Kondisi = C.Kd_Kondisi
		WHERE (A.Kd_Pemilik IN(0, 11, 12)) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	          	AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5)
	
		UNION ALL
		
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, 0 AS Panjang, COUNT(*) AS Jumlah, A.Asal_Usul, SUM(Harga) AS Harga, 
			C.Uraian AS Kondisi, ISNULL(A.Keterangan, '') AS Keterangan
		FROM fn_Kartu_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,@Kd_Aset1, '%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
			Ref_Kondisi C On A.Kondisi = C.Kd_Kondisi
		WHERE (A.Kd_Pemilik IN(0, 11, 12)) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	          	AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5)
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,  A.Kd_Pemilik, YEAR(A.Tgl_Perolehan), A.Asal_Usul, A.Kondisi, ISNULL(A.Keterangan, ''), C.Uraian
		
		UNION ALL
		
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, 0 AS Panjang, COUNT(*) AS Jumlah, A.Asal_Usul, SUM(A.Harga) AS Harga, 
			C.Uraian AS Kondisi, ISNULL(A.Keterangan, '') AS Keterangan
		FROM fn_Kartu_BrgF(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,@Kd_Aset1, '%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
			Ref_Kondisi C On A.Kondisi = C.Kd_Kondisi
		WHERE (A.Kd_Pemilik IN(0, 11, 12)) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	          	AND (@Kd_Aset1 = 6) 
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, YEAR(A.Tgl_Perolehan), A.Asal_Usul, A.Kondisi, ISNULL(A.Keterangan, ''), C.Uraian
		
		) A LEFT OUTER JOIN

		Ta_UPB K ON A.Kd_prov = K.Kd_Prov AND A.Kd_Kab_Kota = K.Kd_Kab_Kota AND A.Kd_Bidang = K.Kd_Bidang AND A.Kd_Unit = K.Kd_Unit AND A.Kd_Sub = K.Kd_Sub AND A.Kd_UPB = K.Kd_UPB LEFT OUTER JOIN
		Ref_UPB J ON K.Kd_prov = J.Kd_Prov AND K.Kd_Kab_Kota = J.Kd_Kab_Kota AND K.Kd_Bidang = J.Kd_Bidang AND K.Kd_Unit = J.Kd_Unit AND K.Kd_Sub = J.Kd_Sub AND K.Kd_UPB = J.Kd_UPB INNER JOIN
		Ref_Sub_Unit L ON J.Kd_prov = L.Kd_Prov AND J.Kd_Kab_Kota = L.Kd_Kab_Kota AND J.Kd_Bidang = L.Kd_Bidang AND J.Kd_Unit = L.Kd_Unit AND J.Kd_Sub = L.Kd_Sub INNER JOIN
		Ref_Unit M ON L.Kd_prov = M.Kd_Prov AND L.Kd_Kab_Kota = M.Kd_Kab_Kota AND L.Kd_Bidang = M.Kd_Bidang AND L.Kd_Unit = M.Kd_Unit INNER JOIN
		Ref_Bidang N ON M.Kd_Bidang = N.Kd_Bidang INNER JOIN
		Ref_Rek_Aset5 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
		Ref_Rek_Aset4 C ON B.Kd_Aset1 = C.Kd_Aset1 AND B.Kd_Aset2 = C.Kd_Aset2 AND B.Kd_Aset3 = C.Kd_Aset3 AND B.Kd_Aset4 = C.Kd_Aset4 INNER JOIN
		Ref_Rek_Aset3 D ON C.Kd_Aset1 = D.Kd_Aset1 AND C.Kd_Aset2 = D.Kd_Aset2 AND C.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
		Ref_Rek_Aset2 E ON D.Kd_Aset1 = E.Kd_Aset1 AND D.Kd_Aset2 = E.Kd_Aset2 INNER JOIN
		Ref_Rek_Aset1 F ON E.Kd_Aset1 = F.Kd_Aset1 INNER JOIN
		Ref_Pemda G ON A.Kd_Prov = G.Kd_Prov AND A.Kd_Kab_Kota = G.Kd_Kab_Kota INNER JOIN
		Ref_Kab_Kota H ON A.Kd_Prov = H.Kd_Prov AND A.Kd_Kab_Kota = H.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi I ON A.Kd_Prov = I.Kd_Prov,		
		(
		SELECT @Kd_Bidang AS Kd_BidangA, @Kd_Unit AS Kd_UnitA, @Kd_Sub AS Kd_SubA, @Kd_UPB AS Kd_UPBA, 
			RIGHT('0' + @Kd_Bidang, 2) AS Kd_Bidang_Gab,
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) AS Kd_Unit_Gab,
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) + '.' + RIGHT('0' + @Kd_Sub, 2) AS Kd_Sub_Gab,
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) + '.' + RIGHT('0' + @Kd_Sub, 2) + '.' + RIGHT('0' + @Kd_UPB, 2) AS Kd_UPB_Gab,
			E.Nm_Bidang AS Nm_Bidang_Gab, D.Nm_Unit AS Nm_Unit_Gab, C.Nm_Sub_Unit AS Nm_Sub_Unit_Gab, B.Nm_UPB AS Nm_UPB_Gab,
			A.Nm_Pimpinan, A.Nip_Pimpinan, A.Jbt_Pimpinan, A.Nm_Pengurus, A.Nip_Pengurus, A.Jbt_Pengurus
		FROM Ta_UPB A INNER JOIN
			Ref_UPB B ON A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
			Ref_Sub_Unit C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub INNER JOIN
			Ref_Unit D ON C.Kd_Bidang = D.Kd_Bidang AND C.Kd_Unit = D.Kd_Unit INNER JOIN
			Ref_Bidang E ON D.Kd_Bidang = E.Kd_Bidang INNER JOIN
			(
			SELECT TOP 1 Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			FROM Ta_UPB
			WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			ORDER BY Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			) F ON A.Tahun = F.Tahun AND A.Kd_Prov = F.Kd_Prov AND A.Kd_Kab_Kota = F.Kd_Kab_Kota AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB
		) O
		
	GROUP BY J.Kd_Prov, J.Kd_Kab_Kota, J.Kd_Bidang, J.Kd_Unit, J.Kd_Sub, J.Kd_UPB, I.Nm_Provinsi, 
		H.Nm_Kab_Kota, N.Nm_Bidang, M.Nm_Unit, L.Nm_Sub_Unit, J.Nm_UPB,A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
		A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, F.Nm_Aset1, E.Nm_Aset2, D.Nm_Aset3, C.Nm_Aset4, B.Nm_Aset5,
		A.Tahun, A.Luas_M2, A.Jumlah, A.Asal_Usul, A.Harga, A.Kondisi, A.Keterangan,
		O.Nm_Pimpinan, O.Nip_Pimpinan, O.Jbt_Pimpinan, O.Nm_Pengurus, O.Nip_Pengurus, O.Jbt_Pengurus
	ORDER BY J.Kd_Prov, J.Kd_Kab_Kota, J.Kd_Bidang, J.Kd_Unit, J.Kd_Sub, J.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_register, A.Tahun



GO
