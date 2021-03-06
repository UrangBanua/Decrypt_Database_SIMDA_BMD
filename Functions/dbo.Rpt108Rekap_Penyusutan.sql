USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.Rpt108Rekap_Penyusutan @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), 
       	                             @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D1 datetime
WITH ENCRYPTION
AS


/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D1 datetime
SET @Tahun = '2019'
SET @Kd_Prov = '15'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '13'
SET @Kd_Unit = '1'
SET @Kd_Sub = '11'
SET @Kd_UPB = ''
SET @D1= '20191231'
--*/

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '')   = '' SET @Kd_Unit   = '%'
	IF ISNULL(@Kd_Sub, '')    = '' SET @Kd_Sub    = '%'
	IF ISNULL(@Kd_UPB, '')    = '' SET @Kd_UPB    = '%'

    DECLARE @JLap Tinyint SET @JLap = 1

		
----------------------------
 
 
	SELECT A.Jndt, B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_Kab_Kota, B.Nm_Bidang, B.Nm_Unit, B.Nm_Sub_Unit, 
               B.Nm_UPB, 
               CASE A.Jndt WHEN 0 THEN 'ASET TETAP' WHEN 1 THEN 'ASET TETAP YANG DIREKLASIFIKASI KE ASET LAINNYA' ELSE 'ASET TETAP YANG DIHAPUSKAN' END AS Nm_Jndt, 
               A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1,
		A.Uraian, YEAR (@D1) AS Tahun_Sblm, ISNULL(A.Nilai_Perolehan,0) AS Nilai_Perolehan, ISNULL (A.Nilai_Susut1,0) AS Nilai_Susut1 , 
               ISNULL(A.Nilai_Susut2,0) AS Nilai_Susut2, ISNULL(A.Akum_Susut,0) AS Akum_Susut, ISNULL (A.Nilai_Sisa,0) AS Nilai_Sisa, ISNULL(A.Akp_Awal,0) AS Akp_Awal
	FROM 
            (

	     SELECT 0 AS Jndt,  A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1,
		  'TANAH' AS Uraian, SUM(ISNULL(A.Harga,0)) AS Nilai_Perolehan, 0 AS Nilai_Susut1, 0 AS Nilai_Susut2, 0 AS Akum_Susut, 
                    SUM(ISNULL(A.Harga,0)) AS Nilai_Sisa, 0 AS Akp_Awal
	     FROM fn_Kartu108_BrgA1(@Tahun, @D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap) A 
	     WHERE A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
                   A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND A.Tgl_Pembukuan <= @D1 AND A.Kd_Aset1 = 1 AND A.Kd_KA = 1 AND A.Kd_Bidang <> 22 AND 
                   (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)
                    AND (A.Tahun = @Tahun)
	     GROUP BY A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1
	     
	     UNION ALL

	     SELECT B.Jndt, A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1,
			'PERALATAN MESIN' AS Uraian, SUM(ISNULL(B.Harga,0))AS Nilai_Perolehan, SUM(ISNULL(B.Nilai_Susut1,0))AS Nilai_Susut1, 
                    SUM(ISNULL(B.Nilai_Susut2,0))AS Nilai_Susut2, SUM(ISNULL(B.Akum_Susut,0))AS Akum_Susut, SUM(ISNULL(B.Nilai_Sisa,0))AS Nilai_Sisa,
	       	    SUM(ISNULL(B.Akum_Susut,0))- SUM(ISNULL(B.Nilai_Susut1,0)) - SUM(ISNULL(B.Nilai_Susut2,0)) AS Akp_Awal
	     FROM fn108_UPB_B(@Tahun, @D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%') A 
                              INNER JOIN Ta_SusutB B ON A.IDPemda = B.IDPemda 
                              LEFT OUTER JOIN
                                   (SELECT IDPemda FROM Ta_KIBBR
                                    WHERE Kd_Riwayat = 1 AND YEAR(Tgl_Dokumen) = @Tahun
                                    ) C ON B.IDPemda = C.IDPemda                                
	     WHERE B.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
                   A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND NOT (B.Jndt = 1 AND B.Nilai_Susut1 = 0 AND C.IDPemda IS NULL)  --AND (A.Tahun = @Tahun)
				 
		GROUP BY B.Jndt, A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1
	
	     UNION ALL

	     SELECT B.Jndt,  A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1,
		'GEDUNG BANGUNAN' AS Uraian, SUM(ISNULL(B.Harga,0))AS Nilai_Perolehan, SUM(ISNULL(B.Nilai_Susut1,0))AS Nilai_Susut1, 
                    SUM(ISNULL(B.Nilai_Susut2,0))AS Nilai_Susut2, SUM(ISNULL(B.Akum_Susut,0))AS Akum_Susut, SUM(ISNULL(B.Nilai_Sisa,0))AS Nilai_Sisa,
	       	    SUM(ISNULL(B.Akum_Susut,0))- SUM(ISNULL(B.Nilai_Susut1,0)) - SUM(ISNULL(B.Nilai_Susut2,0)) AS Akp_Awal
	     FROM fn108_UPB_C(@Tahun, @D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%') A 
                             INNER JOIN Ta_SusutC B ON A.IDPemda = B.IDPemda 
                             LEFT OUTER JOIN 
                                   (SELECT IDPemda FROM Ta_KIBCR
                                    WHERE Kd_Riwayat = 1 AND YEAR(Tgl_Dokumen) = @Tahun
                                   ) C ON B.IDPemda = C.IDPemda
	     WHERE B.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
                   A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND NOT(B.Jndt = 1 AND Nilai_Susut1 = 0 AND C.IDPemda IS NULL)  --AND (A.Tahun = @Tahun)          
	     GROUP BY B.Jndt, A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1
	
	     UNION ALL

	     SELECT B.Jndt,  A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1,
			'JALAN IRIGASI JARINGAN' AS Uraian, SUM(ISNULL(B.Harga,0))AS Nilai_Perolehan, SUM(ISNULL(B.Nilai_Susut1,0))AS Nilai_Susut1, 
                    SUM(ISNULL(B.Nilai_Susut2,0))AS Nilai_Susut2, SUM(ISNULL(B.Akum_Susut,0))AS Akum_Susut, SUM(ISNULL(B.Nilai_Sisa,0))AS Nilai_Sisa,
	       	    SUM(ISNULL(B.Akum_Susut,0))- SUM(ISNULL(B.Nilai_Susut1,0)) - SUM(ISNULL(B.Nilai_Susut2,0)) AS Akp_Awal
	     FROM fn108_UPB_D(@Tahun, @D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%') A 
                             INNER JOIN Ta_SusutD B ON A.IDPemda = B.IDPemda 
                             LEFT OUTER JOIN 
                                   (SELECT IDPemda FROM Ta_KIBDR
                                    WHERE Kd_Riwayat = 1 AND YEAR(Tgl_Dokumen) = @Tahun
                                   ) C ON B.IDPemda = C.IDPemda
	     WHERE B.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
                   A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND NOT(B.Jndt = 1 AND Nilai_Susut1 = 0 AND C.IDPemda IS NULL ) --AND (A.Tahun = @Tahun)
	     GROUP BY B.Jndt,A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1
	
	     UNION ALL
	     
	    SELECT A.JNDT, A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1,
		'ASET TETAP LAINNYA' AS Uraian, SUM(ISNULL(A.Nilai_Perolehan,0)) AS Nilai_Perolehan , SUM(ISNULL(A.Nilai_Susut1,0)) AS Nilai_Susut1, 
		SUM(ISNULL(A.Nilai_Susut2,0)) AS Nilai_Susut2,  SUM(ISNULL(A.Akum_Susut,0)) AS Akum_Susut, 
		SUM(A.Nilai_Perolehan - A.Akum_Susut) AS Nilai_Sisa,
		SUM(ISNULL(A.Akp_Awal,0)) AS Akp_Awal
	    FROM
		(
		
			SELECT 0 AS JNDT, A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1,
			'ASET TETAP LAINNYA' AS Uraian, 
			SUM(ISNULL(A.HARGA,0)) AS Nilai_Perolehan, 
			0 AS Nilai_Susut1, 0 AS Nilai_Susut2,  
			0 AS Akum_Susut, 0 AS Nilai_Sisa,
			0 AS Akp_Awal
			FROM fn_Kartu108_BrgE1(@Tahun, @D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@Jlap)  A 
			WHERE A.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
					   A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB 
	                   
			 GROUP BY A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1
			 
			UNION ALL
				
			SELECT 0 AS Jndt,A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1,
			'ASET TETAP LAINNYA' AS Uraian, 
			 0 AS Nilai_Perolehan, 
			SUM(ISNULL(C.Nilai_Susut1,0))AS Nilai_Susut1, 
			SUM(ISNULL(C.Nilai_Susut2,0))AS Nilai_Susut2, 
			SUM(ISNULL(C.Akum_Susut,0))AS Akum_Susut, 
			SUM(ISNULL(C.Nilai_Sisa,0))AS Nilai_Sisa,
	       		SUM(ISNULL(C.Akum_Susut,0))- SUM(ISNULL(C.Nilai_Susut1,0)) - SUM(ISNULL(C.Nilai_Susut2,0)) AS Akp_Awal
			FROM fn_Kartu108_BrgE1(@Tahun, @D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@Jlap)  A 
					 LEFT OUTER JOIN Ta_SusutE C ON A.IDPEMDA = C.IDPEMDA
					 LEFT OUTER JOIN  (SELECT IDPemda FROM Ta_KIBER
										WHERE Kd_Riwayat = 1 AND YEAR(Tgl_Dokumen) = @Tahun
									   ) D ON D.IDPemda = C.IDPemda
			WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
						A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 
						AND A.Tahun = @Tahun AND C.Tahun = @Tahun
			GROUP BY A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1
	     
			
			) A
	   WHERE A.KD_ASET = 1 AND A.KD_ASET0 = 3 AND A.KD_ASET1 = 5
	   GROUP BY A.JNDT, A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1
	   
	    UNION ALL

	     SELECT 0, A.KD_ASET, A.KD_ASET0,A.Kd_Aset1,
		   'KONSTRUKSI DALAM PENGERJAAN' AS Uraian, SUM(ISNULL(A.Harga,0)) AS Nilai_Perolehan, 0 AS Nilai_Susut1, 
                    0 AS Nilai_Susut2, 0 AS Akum_Susut, SUM(ISNULL(A.Harga,0)) AS Nilai_Sisa, 0 AS Akp_Awal
	     FROM fn_Kartu108_BrgF1(@Tahun, @D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap) A 
	     WHERE A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
                   A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND A.Tgl_Pembukuan <= @D1 AND A.Kondisi <> 3 AND A.Kd_KA = 1 AND 
                  (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND (A.Tahun = @Tahun)
	      GROUP BY A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1
	)A, 
        (		
         SELECT @Kd_Prov AS Kd_Prov, @Kd_Kab_Kota AS Kd_Kab_Kota, @Kd_Bidang AS Kd_Bidang, @Kd_Unit AS Kd_Unit, @Kd_Sub AS Kd_Sub, 
                @Kd_UPB AS Kd_UPB, E.Nm_Bidang, D.Nm_Unit, C.Nm_sub_Unit, B.Nm_UPB			
	 FROM Ta_UPB A INNER JOIN
              Ref_UPB B ON A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
	      Ref_Sub_Unit C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub INNER JOIN
	      Ref_Unit D ON C.Kd_Bidang = D.Kd_Bidang AND C.Kd_Unit = D.Kd_Unit INNER JOIN
	      Ref_Bidang E ON D.Kd_Bidang = E.Kd_Bidang INNER JOIN
	      (
	       SELECT TOP 1 Tahun, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
	       FROM Ta_UPB A
	       WHERE (A.Tahun = @Tahun) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	       ORDER BY Tahun, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
	       ) F ON A.Tahun = F.Tahun AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB
	 ) B,
         (
	  SELECT A.Nm_Kab_Kota
	  FROM Ref_Kab_Kota A
	  WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
	 ) C
       ORDER BY A.Jndt,A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1






GO
