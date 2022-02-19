USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.Rpt108RincianBarangKeNeraca_SUB @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D2 datetime 
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D2 datetime 
SET @Tahun = '2019'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '11'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '2'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @D2 = '20191231' 
*/

	DECLARE @tmpBI TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int, Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 int, 
                             Kd_Pemilik tinyint, No_Register int, Tgl_Perolehan datetime, Harga money)
        DECLARE @JLap Tinyint SET @JLap = 1
        
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'




	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, --
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
            A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Harga
	FROM fn_Kartu108_BrgA1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%', @JLap)  A 
	WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              A.Kd_UPB LIKE @Kd_UPB AND A.KD_BIDANG <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 
	      AND (A.Tahun = @Tahun)	      

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
            A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Harga
	FROM fn_Kartu108_BrgB1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A --LEFT OUTER JOIN
	WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 
	      AND (A.Tahun = @Tahun)

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
				A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Harga
	FROM fn_Kartu108_BrgC1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A --LEFT OUTER JOIN
	WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 
	      AND (A.Tahun = @Tahun)


	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
		      A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Harga
	FROM fn_Kartu108_BrgD1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A --LEFT OUTER JOIN
	 WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 
	      AND (A.Tahun = @Tahun)

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
               A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Harga
	FROM fn_Kartu108_BrgE1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@Jlap)  A --LEFT OUTER JOIN
	WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 
	      AND (A.Tahun = @Tahun)

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0,
               A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
	       A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Harga
	FROM fn_Kartu108_BrgL1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%', @JLap)  A 
	WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)


        INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, 6 AS Kd_Aset1, 1 AS Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Harga
	FROM fn_Kartu108_BrgF1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%', @JLap)  A
        WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)

-----------------------------------


      SELECT J.Kd_BidangA, J.Kd_UnitA, J.Kd_SubA, J.Kd_UPBA, 
			E.Nm_Provinsi, 
		CASE A.Kd_Kab_Kota
		WHEN 0 THEN '-'
		ELSE D.Nm_Kab_Kota
		END AS Nm_Kab_Kota, J.Nm_Bidang_Gab, J.Nm_Unit_Gab, J.Nm_Sub_Unit_Gab, J.Nm_UPB_Gab, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
		RIGHT(CONVERT(varchar, G.Kd_Aset), 2) + '.' + RIGHT(CONVERT(varchar, G.Kd_Aset0), 2) AS Kd_Aset0_Gab,
        	RIGHT(CONVERT(varchar, G.Kd_Aset), 2) + '.' + RIGHT(CONVERT(varchar, G.Kd_Aset0), 2) + '.' + CONVERT(varchar, A.Kd_Aset1) AS Kd_Aset1_Gab,
		RIGHT(CONVERT(varchar, G.Kd_Aset), 2) + '.' + RIGHT(CONVERT(varchar, G.Kd_Aset0), 2) + '.' + RIGHT(CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2)  AS Kd_Aset2_Gab,

		RIGHT(CONVERT(varchar, G.Kd_Aset), 2) + '.' + RIGHT(CONVERT(varchar, G.Kd_Aset0), 2) + '.' + RIGHT(CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2)  + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) AS Kd_Aset3_Gab,

		RIGHT(CONVERT(varchar, G.Kd_Aset), 2) + '.' + RIGHT(CONVERT(varchar, G.Kd_Aset0), 2) + '.' + RIGHT(CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2)  + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 2) AS Kd_Aset4_Gab,
		RIGHT(CONVERT(varchar, G.Kd_Aset), 2) + '.' + RIGHT(CONVERT(varchar, G.Kd_Aset0), 2) + '.' + RIGHT(CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2)  + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 2) + '.' + 
		CASE LEN(CONVERT(varchar, A.Kd_Aset5)) WHEN 3 THEN CONVERT(varchar, A.Kd_Aset5) ELSE RIGHT('0' + CONVERT(varchar, A.Kd_Aset5), 2) END AS Kd_Aset5_Gab,
		G.Nm_Aset0, F.Nm_Aset1, A.Nm_Aset2, A.Nm_Aset3, A.Nm_Aset4, A.Nm_Aset5, ISNULL(A.Harga, 0) AS Harga, D.Nm_Kab_Kota AS Nm_Pemda,
		J.Nm_Pimpinan, J.Nip_Pimpinan, J.Jbt_Pimpinan, J.Nm_Pengurus, J.Nip_Pengurus, J.Jbt_Pengurus
	
      FROM
		(
		SELECT @Kd_Prov AS Kd_Prov, @Kd_Kab_Kota AS Kd_Kab_Kota, 
		AA.Kd_Aset, AA.Kd_Aset0, AA.Kd_Aset1, AA.Kd_Aset2, AA.Kd_Aset3, AA.Kd_Aset4, AA.Kd_Aset5, AD.Nm_Aset2, AC.Nm_Aset3, AB.Nm_Aset4, AA.Nm_Aset5, SUM(B.Harga) AS Harga
		FROM Ref_Rek5_108 AA 
		INNER JOIN Ref_Rek4_108 AB ON AA.Kd_Aset = AB.Kd_Aset AND AA.Kd_Aset0 = AB.Kd_Aset0 AND AA.Kd_Aset1 = AB.Kd_Aset1 AND AA.Kd_Aset2 = AB.Kd_Aset2
			AND AA.Kd_Aset3 = AB.Kd_Aset3 AND AA.Kd_Aset4 = AB.Kd_Aset4 
		INNER JOIN Ref_Rek3_108 AC ON AB.Kd_Aset = AC.Kd_Aset AND AB.Kd_Aset0 = AC.Kd_Aset0 AND AB.Kd_Aset1 = AC.Kd_Aset1 AND AB.Kd_Aset2 = AC.Kd_Aset2
			AND AB.Kd_Aset3 = AC.Kd_Aset3 
		INNER JOIN Ref_Rek2_108 AD ON AC.Kd_Aset = AD.Kd_Aset AND AC.Kd_Aset0 = AD.Kd_Aset0 AND AC.Kd_Aset1 = AD.Kd_Aset1 AND AC.Kd_Aset2 = AD.Kd_Aset2
		LEFT OUTER JOIN
			(
			SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 
				A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, YEAR(A.Tgl_Perolehan) AS Tahun,
				SUM(A.Harga) AS Harga
			FROM @tmpBI A
			GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, YEAR(A.Tgl_Perolehan)
        		) B ON AA.Kd_Aset = B.Kd_Aset AND AA.Kd_Aset0 = B.Kd_Aset0 AND AA.Kd_Aset1 = B.Kd_Aset1 AND AA.Kd_Aset2 = B.Kd_Aset2 AND AA.Kd_Aset3 = B.Kd_Aset3 AND AA.Kd_Aset4 = B.Kd_Aset4 AND AA.Kd_Aset5 = B.Kd_Aset5
		GROUP BY AA.Kd_Aset, AA.Kd_Aset0, AA.Kd_Aset1, AA.Kd_Aset2, AA.Kd_Aset3, AA.Kd_Aset4, AA.Kd_Aset5, AD.Nm_Aset2, AC.Nm_Aset3, AB.Nm_Aset4, AA.Nm_Aset5
		HAVING SUM(B.Harga)<>0

		) A INNER JOIN Ref_Rek0_108 G ON A.Kd_Aset = G.Kd_Aset and A.Kd_Aset0 = G.Kd_Aset0 
		    INNER JOIN
			(SELECT Kd_Aset, Kd_Aset0, Kd_Aset1, Nm_Aset1
			 FROM Ref_Rek1_108
			 WHERE Kd_Aset = 1 AND Kd_Aset0 IN (3,5) AND Kd_Aset1 NOT IN (7) AND NOT (KD_ASET = 1 AND KD_ASET0 = 5 AND KD_ASET1 IN (5,6))
			 ) F ON A.Kd_Aset = F.Kd_Aset and A.Kd_Aset0 = F.Kd_Aset0 and A.Kd_Aset1 = F.Kd_Aset1 

		    INNER JOIN Ref_Kab_Kota D ON A.Kd_Prov = D.Kd_Prov AND A.Kd_Kab_Kota = D.Kd_Kab_Kota 
		    INNER JOIN Ref_Provinsi E ON D.Kd_Prov = E.Kd_Prov,
		(

		SELECT @Kd_Bidang AS Kd_BidangA, @Kd_Bidang AS Kd_UnitA, @Kd_Bidang AS Kd_SubA, @Kd_Bidang AS Kd_UPBA, 
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
	ORDER BY A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2
GO
