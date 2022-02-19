USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.RptRekapBarangKeNeraca @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D2 datetime 
WITH ENCRYPTION
AS

/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D2 datetime
SET @Tahun = '2015'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '11'
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @Kd_UPB = ''
SET @D2 = '20151231' 
*/
	DECLARE @tmpBI TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, 
                             Kd_Pemilik tinyint, No_Register int, Tgl_Perolehan datetime, Harga money)
        DECLARE @JLap Tinyint SET @JLap = 1
        
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

        INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
               CASE WHEN B.Kd_Prov IS NOT NULL THEN 7 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
               CASE WHEN B.Kd_Prov IS NOT NULL THEN 22 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
               CASE WHEN B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
               CASE WHEN B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset4 END AS Kd_Aset4, 
               CASE WHEN B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5,
	       A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Harga
	FROM fn_Kartu_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%', @JLap)  A LEFT OUTER JOIN
	       (SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register  
                FROM Ta_KIBAR 
                WHERE Kd_Riwayat IN(9,10,11,12,13) AND Tgl_Dokumen <= @D2
                GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
               ) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
                      A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND 
                      A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND 
                      A.No_Register = B.No_Register 
	WHERE 
              A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              A.Kd_UPB LIKE @Kd_UPB AND A.KD_BIDANG <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 7 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
               CASE WHEN A.Kondisi >= 3 THEN 21 WHEN B.Kd_Prov IS NOT NULL THEN 22 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset4 END AS Kd_Aset4, 
               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5,
	       A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Harga
	FROM fn_Kartu_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
	       (SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register  
                FROM Ta_KIBBR 
                WHERE Kd_Riwayat IN(9,10,11,12,13) AND Tgl_Dokumen <= @D2
                GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
               ) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
                      A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND 
                      A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND 
                      A.No_Register = B.No_Register 
	WHERE 
              A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 
		
	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 7 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
               CASE WHEN A.Kondisi >= 3 THEN 21 WHEN B.Kd_Prov IS NOT NULL THEN 22 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset4 END AS Kd_Aset4, 
               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5,
	       A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Harga
	FROM fn_Kartu_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
	      (SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register  
                FROM Ta_KIBCR 
                WHERE Kd_Riwayat IN(9,10,11,12,13) AND Tgl_Dokumen <= @D2
                GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
               ) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
                      A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND 
                      A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND 
                      A.No_Register = B.No_Register 
	WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 
		
	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 7 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
               CASE WHEN A.Kondisi >= 3 THEN 21 WHEN B.Kd_Prov IS NOT NULL THEN 22 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset4 END AS Kd_Aset4, 
               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5,
	       A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Harga
	FROM fn_Kartu_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
	       (SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register  
                FROM Ta_KIBDR 
                WHERE Kd_Riwayat IN(9,10,11,12,13) AND Tgl_Dokumen <= @D2
                GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
               ) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
                      A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND 
                      A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND 
                      A.No_Register = B.No_Register 
	WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
               CASE WHEN A.Kondisi >= 3 THEN 7 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
               CASE WHEN A.Kondisi >= 3 THEN 21 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
               CASE WHEN A.Kondisi >= 3 THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
               CASE WHEN A.Kondisi >= 3 THEN 1 ELSE A.Kd_Aset4 END AS Kd_Aset4, 
               CASE WHEN A.Kondisi >= 3 THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5,
               A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Harga
	FROM fn_Kartu_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@Jlap)  A 
	WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
               A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
	       A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Harga
	FROM fn_Kartu_BrgL(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%', @JLap)  A 
	WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)

        INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 6 AS Kd_Aset1, 20 AS Kd_Aset2, 1 AS Kd_Aset3, 1 AS Kd_Aset4, 1 AS Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Harga
	FROM fn_Kartu_BrgF(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%', @JLap)  A
        WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)

      SELECT J.Kd_BidangA, J.Kd_UnitA, J.Kd_SubA, J.Kd_UPBA, E.Nm_Provinsi, 
		CASE A.Kd_Kab_Kota
		WHEN 0 THEN '-'
		ELSE D.Nm_Kab_Kota
		END AS Nm_Kab_Kota, J.Nm_Bidang_Gab, J.Nm_Unit_Gab, J.Nm_Sub_Unit_Gab, J.Nm_UPB_Gab, CASE WHEN A.Kd_Aset1 = 7 THEN 2 ELSE 1 END AS Kd_Aset,
                CASE WHEN A.Kd_Aset1 = 7 THEN 'ASET LAINNYA' ELSE 'ASET TETAP' END AS Nm_Aset, A.Kd_Aset1, A.Kd_Aset2, 
                RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) AS Kd_Aset1_Gab, RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) AS Kd_Aset2_Gab,
		F.Nm_Aset1, A.Nm_Aset2, ISNULL(A.Harga, 0) AS Harga, D.Nm_Kab_Kota AS Nm_Pemda,
		J.Nm_Pimpinan, J.Nip_Pimpinan, J.Jbt_Pimpinan, J.Nm_Pengurus, J.Nip_Pengurus, J.Jbt_Pengurus
	
      FROM
		(
		SELECT @Kd_Prov AS Kd_Prov, @Kd_Kab_Kota AS Kd_Kab_Kota, A.Kd_Aset1, A.Kd_Aset2, A.Nm_Aset2, SUM(B.Harga) AS Harga
		FROM Ref_Rek_Aset2 A LEFT OUTER JOIN
			(
			SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
				A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, YEAR(A.Tgl_Perolehan) AS Tahun,
				SUM(A.Harga) AS Harga
			FROM @tmpBI A
			GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, YEAR(A.Tgl_Perolehan)
        		) B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2
		GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Nm_Aset2
		) A INNER JOIN
		Ref_Rek_Aset1 F ON A.Kd_Aset1 = F.Kd_Aset1 INNER JOIN
		Ref_Kab_Kota D ON A.Kd_Prov = D.Kd_Prov AND A.Kd_Kab_Kota = D.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi E ON D.Kd_Prov = E.Kd_Prov,
		(
		SELECT @Kd_Bidang AS Kd_BidangA, @Kd_Unit AS Kd_UnitA, @Kd_Sub AS Kd_SubA, @Kd_UPB AS Kd_UPBA, 
			RIGHT('0' + @Kd_Bidang, 2) AS Kd_Bidang_Gab,
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) AS Kd_Unit_Gab,
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) + '.' + RIGHT('0' + @Kd_Sub, 2) AS Kd_Sub_Gab,
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) + '.' + RIGHT('0' + @Kd_Sub, 2) + '.' + RIGHT('0' + @Kd_UPB, 2) AS Kd_UPB_Gab,
			E.Nm_Bidang AS Nm_Bidang_Gab, D.Nm_Unit AS Nm_Unit_Gab, C.Nm_Sub_Unit AS Nm_Sub_Unit_Gab, B.Nm_UPB AS Nm_UPB_Gab,
			A.Nm_Pimpinan, A.Nip_Pimpinan, A.Jbt_Pimpinan, A.Nm_Pengurus, A.Nip_Pengurus, A.Jbt_Pengurus
		FROM Ta_UPB A INNER JOIN
			Ref_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
			Ref_Sub_Unit C ON B.Kd_Prov = C.Kd_Prov AND B.Kd_Kab_Kota = C.Kd_Kab_Kota AND B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub INNER JOIN
			Ref_Unit D ON C.Kd_Prov = D.Kd_Prov AND C.Kd_Kab_Kota = D.Kd_Kab_Kota AND C.Kd_Bidang = D.Kd_Bidang AND C.Kd_Unit = D.Kd_Unit INNER JOIN
			Ref_Bidang E ON D.Kd_Bidang = E.Kd_Bidang INNER JOIN
			(
			SELECT TOP 1 Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			FROM Ta_UPB
			WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			ORDER BY Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			) F ON A.Tahun = F.Tahun AND A.Kd_Prov = F.Kd_Prov AND A.Kd_Kab_Kota = F.Kd_Kab_Kota AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB
		) J
	ORDER BY A.Kd_Aset1, A.Kd_Aset2





GO
