USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


 
/*** RptDaftarBarang_Gab - 05012016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE dbo.RptDaftarBarang_Gab @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @D2 datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @D2 datetime
SET @Tahun = '2012'
SET @Kd_Prov = '99'
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset1 = '3'
SET @D2 = '20121231'
*/
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

	DECLARE @JLap Tinyint SET @JLap = 0

	SELECT	K.Tahun, 
		J.Kd_Prov, J.Kd_Kab_Kota, J.Kd_Bidang, J.Kd_Unit, J.Kd_Sub, J.Kd_UPB, I.Nm_Provinsi, 
		H.Nm_Kab_Kota, N.Nm_Bidang, M.Nm_Unit, L.Nm_Sub_Unit, J.Nm_UPB,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) As Kd_Prov_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) As Kd_Kab_Kota_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) AS Kd_Bidang_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) AS Kd_Unit_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) AS Kd_Sub_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_UPB), 2) AS Kd_UPB_Gab,
		@Kd_Bidang AS Kd_BidangA, @Kd_Unit AS Kd_UnitA, @Kd_Sub AS Kd_SubA, @Kd_UPB AS Kd_UPBA, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) AS Kd_Aset_Gab1,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) AS Kd_Aset_Gab2,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) AS Kd_Aset_Gab3,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 4) AS Kd_Aset_Gab4,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 4) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset5), 5) AS Kd_Aset_Gab5,
		F.Nm_Aset1, E.Nm_Aset2, D.Nm_Aset3, C.Nm_Aset4, B.Nm_Aset5,
		A.Tahun AS Peroleh, A.Luas_M2, A.Jumlah, A.Asal_Usul, A.Harga, O.Uraian AS Kondisi, A.Keterangan,
		K.Nm_Pimpinan, K.Nip_Pimpinan, K.Jbt_Pimpinan, K.Nm_Pengurus, K.Nip_Pengurus, K.Jbt_Pengurus
	FROM
		(
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, A.Luas_M2, 1 AS Jumlah, A.Asal_Usul, A.Harga, '' AS Kondisi, ISNULL(A.Keterangan, '') AS Keterangan
		FROM fn_Kartu_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,'%',@JLap) A LEFT OUTER JOIN
		 	fn_Penghapusan(@Tahun, '1') B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
		     	A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND 
		     	A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register		
		WHERE (B.Kd_Prov IS NULL) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
			AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5)
			AND (A.Kd_Pemilik IN(0, 11, 12))
			AND (YEAR(A.Tgl_Pembukuan) <= @D2)

		UNION ALL
		
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, 0 AS Panjang, COUNT(*) AS Jumlah, A.Asal_Usul, SUM(A.Harga) AS Harga, A.Kondisi, ISNULL(A.Keterangan, '') AS Keterangan
		FROM fn_Kartu_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,'%',@JLap) A LEFT OUTER JOIN
		 	fn_Penghapusan(@Tahun, '2') B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
		     	A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND 
		     	A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov IS NULL) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
			AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5)
			AND (A.Kd_Pemilik IN(0, 11, 12))
			AND (YEAR(A.Tgl_Pembukuan) <= @D2)
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, YEAR(A.Tgl_Perolehan), A.Asal_Usul, A.Kondisi, ISNULL(A.Keterangan, '')
	
		UNION ALL
	
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, A.Luas_Lantai, 1 AS Jumlah, A.Asal_Usul, A.Harga, A.Kondisi, ISNULL(A.Keterangan, '') AS Keterangan
		FROM fn_Kartu_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,'%',@JLap) A LEFT OUTER JOIN
		 	fn_Penghapusan(@Tahun, '3') B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
		     	A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND 
		     	A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov IS NULL) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
			AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5)
			AND (A.Kd_Pemilik IN(0, 11, 12))
			AND (YEAR(A.Tgl_Pembukuan) <= @D2)
		
		UNION ALL
		
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, A.Panjang, 1 AS Jumlah, A.Asal_Usul, A.Harga, A.Kondisi, ISNULL(A.Keterangan, '') AS Keterangan
		FROM fn_Kartu_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,'%',@JLap) A LEFT OUTER JOIN
		 	fn_Penghapusan(@Tahun, '4') B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
		     	A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND 
		     	A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov IS NULL) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
			AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5)
			AND (A.Kd_Pemilik IN(0, 11, 12))
			AND (YEAR(A.Tgl_Pembukuan) <= @D2)
	
		UNION ALL
		
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, 0 AS Panjang, COUNT(*) AS Jumlah, A.Asal_Usul, SUM(A.Harga) AS Harga, A.Kondisi, ISNULL(A.Keterangan, '') AS Keterangan
		FROM fn_Kartu_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,'%',@JLap) A LEFT OUTER JOIN
		 	fn_Penghapusan(@Tahun, '5') B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
		     	A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND 
		     	A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov IS NULL) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
			AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5)
			AND (A.Kd_Pemilik IN(0, 11, 12))
			AND (YEAR(A.Tgl_Pembukuan) <= @D2)
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, YEAR(A.Tgl_Perolehan), A.Asal_Usul, A.Kondisi, ISNULL(A.Keterangan, '')
		) A LEFT OUTER JOIN
		Ta_UPB K ON A.Kd_Prov = K.Kd_Prov AND A.Kd_Kab_Kota = K.Kd_Kab_Kota AND A.Kd_Bidang = K.Kd_Bidang AND A.Kd_Unit = K.Kd_Unit AND A.Kd_Sub = K.Kd_Sub AND A.Kd_UPB = K.Kd_UPB LEFT OUTER JOIN
		Ref_UPB J ON A.Kd_prov = J.Kd_Prov AND A.Kd_Kab_Kota = J.Kd_Kab_Kota AND A.Kd_Bidang = J.Kd_Bidang AND A.Kd_Unit = J.Kd_Unit AND A.Kd_Sub = J.Kd_Sub AND A.Kd_UPB = J.Kd_UPB INNER JOIN
		Ref_Sub_Unit L ON A.Kd_prov = L.Kd_Prov AND A.Kd_Kab_Kota = L.Kd_Kab_Kota AND A.Kd_Bidang = L.Kd_Bidang AND A.Kd_Unit = L.Kd_Unit AND A.Kd_Sub = L.Kd_Sub INNER JOIN
		Ref_Unit M ON L.Kd_prov = M.Kd_Prov AND L.Kd_Kab_Kota = M.Kd_Kab_Kota AND L.Kd_Bidang = M.Kd_Bidang AND L.Kd_Unit = M.Kd_Unit INNER JOIN
		Ref_Bidang N ON M.Kd_Bidang = N.Kd_Bidang INNER JOIN
		Ref_Rek_Aset5 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
		Ref_Rek_Aset4 C ON B.Kd_Aset1 = C.Kd_Aset1 AND B.Kd_Aset2 = C.Kd_Aset2 AND B.Kd_Aset3 = C.Kd_Aset3 AND B.Kd_Aset4 = C.Kd_Aset4 INNER JOIN
		Ref_Rek_Aset3 D ON C.Kd_Aset1 = D.Kd_Aset1 AND C.Kd_Aset2 = D.Kd_Aset2 AND C.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
		Ref_Rek_Aset2 E ON D.Kd_Aset1 = E.Kd_Aset1 AND D.Kd_Aset2 = E.Kd_Aset2 INNER JOIN
		Ref_Rek_Aset1 F ON E.Kd_Aset1 = F.Kd_Aset1 INNER JOIN
		Ref_Pemda G ON A.Kd_Prov = G.Kd_Prov AND A.Kd_Kab_Kota = G.Kd_Kab_Kota INNER JOIN
		Ref_Kab_Kota H ON A.Kd_Prov = H.Kd_Prov AND A.Kd_Kab_Kota = H.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi I ON H.Kd_Prov = I.Kd_Prov LEFT OUTER JOIN
		Ref_Kondisi O ON A.Kondisi = O.Kd_Kondisi
	WHERE K.Tahun = @Tahun
	GROUP BY K.Tahun, J.Kd_Prov, J.Kd_Kab_Kota, J.Kd_Bidang, J.Kd_Unit, J.Kd_Sub, J.Kd_UPB, I.Nm_Provinsi, 
		H.Nm_Kab_Kota, N.Nm_Bidang, M.Nm_Unit, L.Nm_Sub_Unit, J.Nm_UPB, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
		A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, F.Nm_Aset1, E.Nm_Aset2, D.Nm_Aset3, C.Nm_Aset4, B.Nm_Aset5,
		A.Tahun, A.Luas_M2, A.Jumlah, A.Asal_Usul, A.Harga, O.Uraian, A.Keterangan,
		K.Nm_Pimpinan, K.Nip_Pimpinan, K.Jbt_Pimpinan, K.Nm_Pengurus, K.Nip_Pengurus, K.Jbt_Pengurus
	ORDER BY J.Kd_Prov, J.Kd_Kab_Kota, J.Kd_Bidang, J.Kd_Unit, J.Kd_Sub, J.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tahun

GO
