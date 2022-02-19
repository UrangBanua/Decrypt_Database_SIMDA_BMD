USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** RptRincianBarangKeNeraca_SUB - 08032017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE RptRincianBarangKeNeraca_SUB @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4), @D2 datetime 
WITH ENCRYPTION
AS

/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4), @D2 datetime
SET @Tahun = '2015'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '11'
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @Kd_UPB = ''
SET @D2 = '20151231'
*/
	DECLARE @JLap Tinyint SET @JLap = 0

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

	SELECT  @Kd_Bidang AS Kd_Bidang, @Kd_Unit AS Kd_Unit, @Kd_Sub AS Kd_Sub, @Kd_UPB AS Kd_UPB,
		@Kd_Bidang + ' . ' + @Kd_Unit AS Kd_Unit1,
		@Kd_Bidang + ' . ' + @Kd_Unit + ' . ' + @Kd_Sub AS Kd_Sub1,
		@Kd_Bidang + ' . ' + @Kd_Unit + ' . ' + @Kd_Sub + ' . ' + @Kd_UPB AS Kd_UPB1,
		C.Nm_Bidang, 
		C.Nm_Unit, C.Nm_Sub_Unit, C.Nm_UPB,
		CASE
		WHEN A.Kd_Aset1 IN (1) THEN 1
		WHEN A.Kd_Aset1 IN (2) THEN 2
 		WHEN A.Kd_Aset1 IN (3) THEN 3
 		WHEN A.Kd_Aset1 IN (4) THEN 4
 		WHEN A.Kd_Aset1 IN (5) THEN 5
		WHEN A.Kd_Aset1 IN (6) THEN 6
                WHEN A.Kd_Aset1 IN (7) THEN 7
 		ELSE 0
		END AS Kd_Grup,
		RIGHT('00' + CONVERT(varchar, A.Kd_Aset1),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset2),2) AS Kd_Gab,
		RIGHT('00' + CONVERT(varchar, A.Kd_Aset1),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset2),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset3),2) AS Kd_Gab1,
		RIGHT('00' + CONVERT(varchar, X.Kd_Aset1),2) + ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset2),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset3),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset4),2) AS Kd_Gab2,
		RIGHT('00' + CONVERT(varchar, X.Kd_Aset1),2) + ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset2),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset3),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset4),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset5),2) AS Kd_Gab_Rinci,
		CASE
		WHEN A.Kd_Aset1 IN (1) THEN 'Tanah'
		WHEN A.Kd_Aset1 IN (2) THEN 'Peralatan dan Mesin'
 		WHEN A.Kd_Aset1 IN (3) THEN 'Gedung dan Bangunan Gedung'
 		WHEN A.Kd_Aset1 IN (4) THEN 'Jalan, Irigasi dan Jaringan'
 		WHEN A.Kd_Aset1 IN (5) THEN 'Aset Tetap Lainnya'
		WHEN A.Kd_Aset1 IN (6) THEN 'Konstruksi Dalam Pengerjaan'
                WHEN A.Kd_Aset1 IN (7) THEN 'Aset Lainnya'
 		ELSE ''
		END AS Nm_Grup,
		RIGHT('00' + CONVERT(varchar, A.Kd_Aset3), 2) AS Kd_Aset,H.Nm_Aset2 AS Nm_BidangAset, A.Nm_Aset3 AS Nm_Aset, Z.Nm_Aset4 AS Nm_Aset4, X.Nm_Aset5 AS Nm_Rincian, ISNULL(B.Harga, 0) AS Nilai,
		D.Nm_Pemda, NULL AS Logo
	FROM
		Ref_Rek_Aset5 X INNER JOIN
		Ref_Rek_Aset4 Z ON X.Kd_Aset1 = Z.Kd_Aset1 AND X.Kd_Aset2 = Z.Kd_Aset2 AND X.Kd_Aset3 = Z.Kd_Aset3 AND X.Kd_Aset4 = Z.Kd_Aset4 INNER JOIN
		Ref_Rek_Aset3 A ON Z.Kd_Aset1 = A.Kd_Aset1 AND Z.Kd_Aset2 = A.Kd_Aset2 AND Z.Kd_Aset3 = A.Kd_Aset3 INNER JOIN
		Ref_Rek_Aset2 H ON A.Kd_Aset1 = H.Kd_Aset1 AND A.Kd_Aset2 = H.Kd_Aset2
		INNER JOIN
		(
		SELECT A.Kd_Aset1, A.Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, SUM(A.Harga) AS Harga
		FROM
		       (
			SELECT 
                               CASE WHEN B.Kd_Prov IS NOT NULL THEN 7 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
                               CASE WHEN B.Kd_Prov IS NOT NULL THEN 22 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
                               CASE WHEN B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
                               CASE WHEN B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset4 END AS Kd_Aset4, 
                               CASE WHEN B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5,
                               A.Harga
			FROM fn_Kartu_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
				(SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register  
                                 FROM Ta_KIBAR 
                                 WHERE Kd_Riwayat IN(9,10,11,12,13) AND Tgl_Dokumen <= @D2
                                 GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
                                ) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
                                       A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND 
                                       A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND 
                                       A.No_Register = B.No_Register 
		        WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.KD_BIDANG <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 
					
			UNION ALL
				
			SELECT CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 7 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
                               CASE WHEN A.Kondisi >= 3 THEN 21 WHEN B.Kd_Prov IS NOT NULL THEN 22 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset4 END AS Kd_Aset4, 
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5, 
                               A.Harga
			FROM fn_Kartu_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
				(SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register  
                                 FROM Ta_KIBBR 
                                 WHERE Kd_Riwayat IN(9,10,11,12,13) AND Tgl_Dokumen <= @D2
                                 GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
                                ) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
                                       A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND 
                                       A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND 
                                       A.No_Register = B.No_Register 
                        WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.KD_BIDANG <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)
					
			       UNION ALL

                       SELECT  CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 7 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
                               CASE WHEN A.Kondisi >= 3 THEN 21 WHEN B.Kd_Prov IS NOT NULL THEN 22 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset4 END AS Kd_Aset4, 
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5, 
                               A.Harga
			FROM fn_Kartu_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
				(SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register  
                                 FROM Ta_KIBCR 
                                 WHERE Kd_Riwayat IN(9,10,11,12,13) AND Tgl_Dokumen <= @D2
                                 GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
                                ) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
                                       A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND 
                                       A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND 
                                       A.No_Register = B.No_Register
                        WHERE B.Kd_Prov is NULL AND A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.KD_BIDANG <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)			
					
			UNION ALL
			
			SELECT CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 7 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
                               CASE WHEN A.Kondisi >= 3 THEN 21 WHEN B.Kd_Prov IS NOT NULL THEN 22 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset4 END AS Kd_Aset4, 
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5, 
                               A.Harga
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
                              A.Kd_UPB LIKE @Kd_UPB AND A.KD_BIDANG <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)
		
			UNION ALL
			
			SELECT CASE WHEN A.Kondisi >= 3 THEN 7 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
			       CASE WHEN A.Kondisi >= 3 THEN 21 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
			       CASE WHEN A.Kondisi >= 3 THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
			       CASE WHEN A.Kondisi >= 3 THEN 1 ELSE A.Kd_Aset4 END AS Kd_Aset4, 
			       CASE WHEN A.Kondisi >= 3 THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5, A.Harga
  			FROM fn_Kartu_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
	                WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END
					
			UNION ALL
				
			SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Harga
  			FROM fn_Kartu_BrgL(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END 
					
			UNION ALL

			SELECT CASE WHEN A.Kondisi >= 3 THEN 7 ELSE 6 END AS Kd_Aset1, 
			       20 AS Kd_Aset2, 1 AS Kd_Aset3, 1 AS Kd_Aset4, 1 AS Kd_Aset5, A.Harga 
			FROM fn_Kartu_BrgF(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END  
 		       ) A
		       GROUP BY A.Kd_Aset1, A.Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5
		) B ON X.Kd_Aset1 = B.Kd_Aset1 AND X.Kd_Aset2 = B.Kd_Aset2 AND X.Kd_Aset3 = B.Kd_Aset3 AND X.Kd_Aset4 = B.Kd_Aset4 AND X.Kd_Aset5 = B.Kd_Aset5, 
		(
		SELECT MAX(E.Nm_Bidang) AS Nm_Bidang, MAX(D.Nm_Unit) AS Nm_Unit, MAX(C.Nm_Sub_Unit) AS Nm_Sub_Unit, MAX(F.Nm_UPB) AS Nm_UPB
		FROM Ta_UPB A INNER JOIN
			Ref_UPB F ON A.Kd_Prov = F.Kd_Prov AND A.Kd_Kab_Kota = F.Kd_Kab_Kota AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB INNER JOIN
			Ta_Sub_Unit B ON A.Tahun = B.Tahun AND A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub INNER JOIN
			Ref_Sub_Unit C ON B.Kd_Prov = C.Kd_Prov AND B.Kd_Kab_Kota = C.Kd_Kab_Kota AND B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub INNER JOIN
			Ref_Unit D ON C.Kd_Prov = D.Kd_Prov AND C.Kd_Kab_Kota = D.Kd_Kab_Kota AND C.Kd_Bidang = D.Kd_Bidang AND C.Kd_Unit = D.Kd_Unit INNER JOIN
			Ref_Bidang E ON D.Kd_Bidang = E.Kd_Bidang
		WHERE A.Tahun = @Tahun AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
		) C,
		(
		SELECT UPPER(B.Nm_Pemda) AS Nm_Pemda
		FROM Ta_Pemda A Inner Join
		     Ref_Pemda B On A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota
		WHERE A.Tahun = @Tahun AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota)
		) D
	WHERE B.Harga <> 0
	ORDER BY Kd_Grup, A.Kd_Aset2


GO
