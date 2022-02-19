USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.RptDaftarBarang @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), 
		@Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @D2 Datetime
WITH ENCRYPTION
AS

/*
DECLARE @Tahun varchar(4), @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3)
	, @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3)
SET @Tahun = '2020'
SET @D2 = '20201231'
SET @Kd_Prov = '99'
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = ''
SET @Kd_UPB = ''
SET @Kd_Aset = '1'
SET @Kd_Aset0 = '3'
SET @Kd_Aset1 = '2'
SET @Kd_Aset2 = ''
SET @Kd_Aset3 = ''
SET @Kd_Aset4 = ''
SET @Kd_Aset5 = ''
---*/
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	IF ISNULL(@Kd_Aset, '') = '' SET @Kd_Aset = '%'
	IF ISNULL(@Kd_Aset0, '') = '' SET @Kd_Aset0 = '%'
	IF ISNULL(@Kd_Aset1, '') = '' SET @Kd_Aset1 = '%'
	IF ISNULL(@Kd_Aset2, '') = '' SET @Kd_Aset2 = '%'
	IF ISNULL(@Kd_Aset3, '') = '' SET @Kd_Aset3 = '%'
	IF ISNULL(@Kd_Aset4, '') = '' SET @Kd_Aset4 = '%'
	IF ISNULL(@Kd_Aset5, '') = '' SET @Kd_Aset5 = '%'


       	DECLARE @tmpBI TABLE(Kd_Aset tinyint,Kd_Aset0 tinyint,Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, Tahun Varchar(4), Luas_M2 Float, Jumlah Int, Asal_Usul Varchar(50), Harga money, Kondisi Varchar(20), Keterangan varchar(255))
	DECLARE @JLap Tinyint SET @JLap = 0

       IF @Kd_Aset1 = '1'
       INSERT INTO @tmpBI
       SELECT A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Tahun, A.Luas_M2, 1 AS Jumlah, A.Asal_Usul, A.Harga, 'Baik' AS Kondisi, ISNULL(A.Keterangan, '') AS Keterangan	
       FROM
           (SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		    A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, YEAR(A.Tgl_Perolehan) AS Tahun, A.Luas_M2, A.Asal_Usul, A.Harga, A.Keterangan 
            FROM fn_Kartu108_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,@Kd_Aset,@Kd_Aset0,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,'%',@JLap)  A 
            WHERE (A.Kd_Pemilik IN(0, 11, 12)) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	          AND (A.Kd_Aset LIKE @Kd_Aset) AND (A.Kd_Aset0 LIKE @Kd_Aset0) AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5)
           ) A 
                        
	IF @Kd_Aset1 = '2'
	INSERT INTO @tmpBI
	SELECT  A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Tahun, 0 AS Luas_M2, COUNT(*) AS Jumlah, A.Asal_Usul, SUM(A.Harga), 
		B.Uraian AS Kondisi, ISNULL(A.Keterangan, '') AS Keterangan	
	FROM
		(SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			 A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, A.Asal_Usul, A.Harga, A.Kondisi, A.Keterangan 
		FROM fn_Kartu108_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset,@Kd_Aset0,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,'%',@JLap)  A 
		WHERE 	(A.Kd_Pemilik IN(0, 11, 12))
			AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
			AND (A.Kd_Aset LIKE @Kd_Aset) AND (A.Kd_Aset0 LIKE @Kd_Aset0) AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5)
			) A LEFT OUTER JOIN
		Ref_Kondisi B ON A.Kondisi = B.Kd_Kondisi
	GROUP BY  A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Tahun, A.Asal_Usul, A.Kondisi, A.Keterangan, B.Uraian

       IF @Kd_Aset1 = '3'
       INSERT INTO @tmpBI
       SELECT  A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Tahun, A.Luas_Lantai, 1 AS Jumlah, A.Asal_Usul, A.Harga, B.Uraian AS Kondisi, ISNULL(A.Keterangan, '') AS Keterangan	
       FROM
		(SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			 A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, YEAR(A.Tgl_Pembukuan) AS Tahun_Buku, 
			A.Luas_Lantai, A.Asal_Usul, A.Harga, A.Kondisi, A.Keterangan 
		FROM fn_Kartu108_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,@Kd_Aset,@Kd_Aset0,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,'%',@JLap)  A 
		WHERE   (A.Kd_Pemilik IN(0, 11, 12))
		 	AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		 	 AND (A.Kd_Aset LIKE @Kd_Aset) AND (A.Kd_Aset0 LIKE @Kd_Aset0) AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5)
		) A LEFT OUTER JOIN
		Ref_Kondisi B ON A.Kondisi = B.Kd_Kondisi  

       IF @Kd_Aset1 = '4'
       INSERT INTO @tmpBI
       SELECT  A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Tahun, A.Panjang, 1 AS Jumlah, A.Asal_Usul, A.Harga, B.Uraian AS Kondisi, ISNULL(A.Keterangan, '') AS Keterangan	
       FROM
		(SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			 A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, YEAR(A.Tgl_Pembukuan) AS Tahun_Buku,
			A.panjang, A.Asal_Usul, A.Harga, A.Kondisi, A.Keterangan 
		FROM fn_Kartu108_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,@Kd_Aset,@Kd_Aset0,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,'%',@JLap)  A 
		WHERE   (A.Kd_Pemilik IN(0, 11, 12))
		  	AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		  	 AND (A.Kd_Aset LIKE @Kd_Aset) AND (A.Kd_Aset0 LIKE @Kd_Aset0) AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5)
		) A LEFT OUTER JOIN
		Ref_Kondisi B ON A.Kondisi = B.Kd_Kondisi

       IF @Kd_Aset1 = '5'
       INSERT INTO @tmpBI
       SELECT  A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Tahun, 0 AS Panjang, COUNT(*) AS Jumlah, A.Asal_Usul, SUM(A.Harga), B.Uraian AS Kondisi, ISNULL(A.Keterangan, '') AS Keterangan	
       FROM
		(SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			 A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, YEAR(A.Tgl_Pembukuan) AS Tahun_Buku,
			A.Asal_Usul, A.Harga, A.Kondisi, A.Keterangan 
		FROM fn_Kartu108_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,@Kd_Aset,@Kd_Aset0,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,'%',@JLap)  A 
		WHERE   (A.Kd_Pemilik IN(0, 11, 12))
		  	AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		  	 AND (A.Kd_Aset LIKE @Kd_Aset) AND (A.Kd_Aset0 LIKE @Kd_Aset0) AND (A.Kd_Aset1 LIKE @Kd_Aset1) AND (A.Kd_Aset2 LIKE @Kd_Aset2) AND (A.Kd_Aset3 LIKE @Kd_Aset3) AND (A.Kd_Aset4 LIKE @Kd_Aset4) AND (A.Kd_Aset5 LIKE @Kd_Aset5)
		) A LEFT OUTER JOIN
		Ref_Kondisi B ON A.Kondisi = B.Kd_Kondisi
       GROUP BY  A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Tahun, A.Asal_Usul, A.Kondisi, A.Keterangan, B.Uraian

       IF @Kd_Aset1 = '6'
       INSERT INTO @tmpBI
       SELECT  A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Tahun, 0 AS Panjang, COUNT(*) AS Jumlah, A.Asal_Usul, SUM(A.Harga), B.Uraian AS Kondisi, ISNULL(A.Keterangan, '') AS Keterangan	
       FROM
		(SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			 A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, YEAR(A.Tgl_Pembukuan) AS Tahun_Buku,
			A.Asal_Usul, A.Harga, A.Kondisi, A.Keterangan 
		FROM fn_Kartu108_BrgF(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,@Kd_Aset,@Kd_Aset0,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,'%',@JLap)  A 
		WHERE   (A.Kd_Pemilik IN(0, 11, 12))
		  	AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		  	) A LEFT OUTER JOIN
		Ref_Kondisi B ON A.Kondisi = B.Kd_Kondisi
       GROUP BY  A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Tahun, A.Asal_Usul, A.Kondisi, A.Keterangan, B.Uraian

       SELECT J.Kd_BidangA, J.Kd_UnitA, J.Kd_SubA, J.Kd_UPBA, I.Nm_Provinsi, 
		CASE @Kd_Kab_Kota
		WHEN 0 THEN '-'
		ELSE H.Nm_Kab_Kota 
                END AS Nm_Kab_Kota, J.Nm_Bidang_Gab, J.Nm_Unit_Gab, J.Nm_Sub_Unit_Gab, J.Nm_UPB_Gab,
		A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset), 1) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset0), 1) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) AS Kd_Aset_Gab1,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset), 1) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset0), 1) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) AS Kd_Aset_Gab2,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset), 1) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset0), 1) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) AS Kd_Aset_Gab3,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset), 1) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset0), 1) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 4) AS Kd_Aset_Gab4,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset), 1) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset0), 1) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 4) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset5), 5) AS Kd_Aset_Gab5,
		F.Nm_Aset1, E.Nm_Aset2, D.Nm_Aset3, C.Nm_Aset4, B.Nm_Aset5,
		A.Tahun, A.Luas_M2, A.Jumlah, A.Asal_Usul, A.Harga, A.Kondisi, A.Keterangan,
		J.Nm_Pimpinan, J.Nip_Pimpinan, J.Jbt_Pimpinan, J.Nm_Pengurus, J.Nip_Pengurus, J.Jbt_Pengurus
	FROM
                @tmpBI  A INNER JOIN
		Ref_Rek5_108 B ON  A.Kd_Aset = B.Kd_Aset AND  A.Kd_Aset0 = B.Kd_Aset0 AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
		Ref_Rek4_108 C ON C.Kd_Aset = B.Kd_Aset AND  C.Kd_Aset0 = B.Kd_Aset0 AND B.Kd_Aset1 = C.Kd_Aset1 AND B.Kd_Aset2 = C.Kd_Aset2 AND B.Kd_Aset3 = C.Kd_Aset3 AND B.Kd_Aset4 = C.Kd_Aset4 INNER JOIN
		Ref_Rek3_108 D ON C.Kd_Aset = D.Kd_Aset AND  C.Kd_Aset0 = D.Kd_Aset0 AND C.Kd_Aset1 = D.Kd_Aset1 AND C.Kd_Aset2 = D.Kd_Aset2 AND C.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
		Ref_Rek2_108 E ON D.Kd_Aset = E.Kd_Aset AND  D.Kd_Aset0 = E.Kd_Aset0 AND D.Kd_Aset1 = E.Kd_Aset1 AND D.Kd_Aset2 = E.Kd_Aset2 INNER JOIN
		Ref_Rek1_108 F ON E.Kd_Aset = F.Kd_Aset AND  E.Kd_Aset0 = F.Kd_Aset0 AND E.Kd_Aset1 = F.Kd_Aset1 INNER JOIN
		Ref_Kab_Kota H ON @Kd_Prov = H.Kd_Prov AND @Kd_Kab_Kota = H.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi I ON H.Kd_Prov = I.Kd_Prov,
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
			SELECT TOP 1 MAX(Tahun) AS Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			FROM Ta_UPB
			WHERE (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			ORDER BY Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			) F ON A.Tahun = F.Tahun AND A.Kd_Prov = F.Kd_Prov AND A.Kd_Kab_Kota = F.Kd_Kab_Kota AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB
		) J
	
	ORDER BY A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Tahun


GO
