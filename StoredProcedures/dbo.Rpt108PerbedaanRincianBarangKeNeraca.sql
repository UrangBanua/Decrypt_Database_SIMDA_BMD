USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE Rpt108PerbedaanRincianBarangKeNeraca @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4), @D2 datetime 
WITH ENCRYPTION
AS

/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4), @D2 datetime
SET @Tahun = '2019'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '5'
SET @Kd_Unit = '2'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @D2 = '20191231'
--*/

	DECLARE @JLap Tinyint SET @JLap = 0

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'




DECLARE @tmpBI17 TABLE( RowNumber int, Kd_Bidang varchar(100), Kd_Unit varchar(100), Kd_Sub varchar(100), Kd_UPB varchar(100), Kd_Unit1 varchar(100), Kd_Sub1 varchar(100) ,
		Kd_UPB1 varchar(100), Nm_Bidang varchar(100), Nm_Unit varchar(100), Nm_Sub_Unit varchar(100), Nm_UPB varchar(100), Kd_Grup0 varchar(100), Nm_Grup0 varchar(100), Kd_Grup varchar(100), 
		Kd_Gab varchar(100), Kd_Gab1 varchar(100), Kd_Gab2 varchar(100),  Kd_Gab_Rinci varchar(100),  
		Nm_Grup  varchar(100), Kd_Aset  varchar(100), Nm_BidangAset varchar(100), 
		Nm_Aset varchar (255), Nm_Aset4 varchar(255), Nm_Rincian varchar(255), Nilai money )

DECLARE @tmpBI108 TABLE( RowNumber int, Kd_Bidang varchar(100), Kd_Unit varchar(100), Kd_Sub varchar(100), Kd_UPB varchar(100), Kd_Unit1 varchar(100), Kd_Sub1 varchar(100) ,
		Kd_UPB1 varchar(100), Nm_Bidang varchar(100), Nm_Unit varchar(100), Nm_Sub_Unit varchar(100), Nm_UPB varchar(100), Kd_Grup0 varchar(100), Nm_Grup0 varchar(100), Kd_Grup varchar(100), 
		Kd_Gab varchar(100), Kd_Gab1 varchar(100), Kd_Gab2 varchar(100),  Kd_Gab_Rinci  varchar(100), 
		Nm_Grup  varchar(100), Kd_Aset  varchar(100), Nm_BidangAset varchar(100), 
		Nm_Aset varchar (255), Nm_Aset4 varchar(255), Nm_Rincian varchar(255), Nilai money)

DECLARE @tmp17 TABLE( IDPemda varchar(17), No_Register Int, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 smallint, Harga money)
DECLARE @tmp108 TABLE( IDPemda varchar(17), No_Register Int, Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 smallint, Harga money)

DECLARE @tmpnrc1 TABLE( Kd_Aset17 tinyint, Kd_Aset27 tinyint, Kd_Aset37 tinyint, Kd_Aset47 tinyint, Kd_Aset57 smallint, Harga7 money, 
						Kd_Aset8 tinyint, Kd_Aset08 tinyint, Kd_Aset18 tinyint, Kd_Aset28 tinyint, Kd_Aset38 tinyint, Kd_Aset48 tinyint, Kd_Aset58 smallint, Harga8 money)						
											



insert into @tmp17 



			SELECT C.IdPemda, A.No_Register,                                
			CASE WHEN B.Kd_Prov IS NOT NULL THEN 7 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
                               CASE WHEN B.Kd_Prov IS NOT NULL THEN 22 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
                               CASE WHEN B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
                               CASE WHEN B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset4 END AS Kd_Aset4, 
                               CASE WHEN B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5,
                               A.Harga
			FROM fn_Kartu_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
			
			INNER JOIN (
					SELECT IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
					FROM fn_UPB_A(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%') A
					) C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND 
    	                	  	A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB AND A.Kd_Aset1 = C.Kd_Aset1 AND 
        	              		A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5 AND 
                	      		A.No_Register = C.No_Register 
			LEFT OUTER JOIN
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


			SELECT C.IdPemda, A.No_Register, CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 7 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
                               CASE WHEN A.Kondisi >= 3 THEN 21 WHEN B.Kd_Prov IS NOT NULL THEN 22 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset4 END AS Kd_Aset4, 
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5, 
                               A.Harga
			FROM fn_Kartu_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
			
			INNER JOIN (
					SELECT IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
					FROM fn_UPB_B(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%') A
					) C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND 
    	                	  	A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB AND A.Kd_Aset1 = C.Kd_Aset1 AND 
        	              		A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5 AND 
                	      		A.No_Register = C.No_Register 
			LEFT OUTER JOIN
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


			SELECT C.IdPemda, A.No_Register, CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 7 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
                               CASE WHEN A.Kondisi >= 3 THEN 21 WHEN B.Kd_Prov IS NOT NULL THEN 22 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset4 END AS Kd_Aset4, 
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5, 
                               A.Harga
			FROM fn_Kartu_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
			
			INNER JOIN (
					SELECT IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
					FROM fn_UPB_C(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%') A
					) C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND 
    	                	  	A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB AND A.Kd_Aset1 = C.Kd_Aset1 AND 
        	              		A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5 AND 
                	      		A.No_Register = C.No_Register 
			LEFT OUTER JOIN
				(SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register  
                                 FROM Ta_KIBCR 
                                 WHERE Kd_Riwayat IN(9,10,11,12,13) AND Tgl_Dokumen <= @D2
                                 GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
                                ) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
                                       A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND 
                                       A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND 
                                       A.No_Register = B.No_Register 
                                       
                        WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.KD_BIDANG <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)

					
			UNION ALL


			SELECT C.IdPemda, A.No_Register, CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 7 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
                               CASE WHEN A.Kondisi >= 3 THEN 21 WHEN B.Kd_Prov IS NOT NULL THEN 22 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset4 END AS Kd_Aset4, 
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5, 
                               A.Harga
			FROM fn_Kartu_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
			
			INNER JOIN (
					SELECT IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
					FROM fn_UPB_D(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%') A
					) C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND 
    	                	  	A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB AND A.Kd_Aset1 = C.Kd_Aset1 AND 
        	              		A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5 AND 
                	      		A.No_Register = C.No_Register 
			LEFT OUTER JOIN
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


			SELECT C.IdPemda, A.No_Register, CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 7 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
                               CASE WHEN A.Kondisi >= 3 THEN 21 WHEN B.Kd_Prov IS NOT NULL THEN 22 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset4 END AS Kd_Aset4, 
                               CASE WHEN A.Kondisi >= 3 OR B.Kd_Prov IS NOT NULL THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5, 
                               A.Harga
			FROM fn_Kartu_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
			
			INNER JOIN (
					SELECT IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
					FROM fn_UPB_E(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%') A
					) C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND 
    	                	  	A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB AND A.Kd_Aset1 = C.Kd_Aset1 AND 
        	              		A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5 AND 
                	      		A.No_Register = C.No_Register 
			LEFT OUTER JOIN
				(SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register  
                                 FROM Ta_KIBER 
                                 WHERE Kd_Riwayat IN(9,10,11,12,13) AND Tgl_Dokumen <= @D2

                                 GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, 
Kd_Aset4, Kd_Aset5, No_Register
                                ) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
                                       A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND 
                                       A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND 
                                       A.No_Register = B.No_Register 
                                       
                        WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.KD_BIDANG <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)

			UNION ALL




			SELECT C.IdPemda, A.No_Register,  A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Harga
  			FROM fn_Kartu_BrgL(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
			INNER JOIN (
					SELECT IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
					FROM fn_UPB_L(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%') A
					) C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND 
    	                	  	A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB AND A.Kd_Aset1 = C.Kd_Aset1 AND 
        	              		A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5 AND 
                	      		A.No_Register = C.No_Register 																								
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END 

			UNION ALL

			SELECT A.IdPemda, A.No_Register, CASE WHEN A.Kondisi >= 3 THEN 7 ELSE 6 END AS Kd_Aset1, 
			       20 AS Kd_Aset2, 1 AS Kd_Aset3, 1 AS Kd_Aset4, 1 AS Kd_Aset5, A.Harga 
			FROM fn_UPB_F (@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 																						
			
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END  



----------------------------------------------------------------------------------------------------------------------------------
insert into @tmp108

			SELECT	A.IdPemda, A.No_Register, A.Kd_Aset, A.Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5,
                               A.Harga
			FROM fn_Kartu108_BrgA1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
		        WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.KD_BIDANG <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 
				AND (A.Tahun = @Tahun)
					
			UNION ALL
				
			SELECT	A.IdPemda, A.No_Register, A.Kd_Aset, A.Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5,
                               A.Harga

			FROM fn_Kartu108_BrgB1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, 
@Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
                        WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.KD_BIDANG <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)
				AND (A.Tahun = @Tahun)

			       UNION ALL

			SELECT	A.IdPemda, A.No_Register, A.Kd_Aset, A.Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5,
                               A.Harga
			FROM fn_Kartu108_BrgC1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
                        WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.KD_BIDANG <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)			
				AND (A.Tahun = @Tahun)
	
			UNION ALL
			
			SELECT	A.IdPemda, A.No_Register, A.Kd_Aset, A.Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5,
                               A.Harga
                               
			FROM fn_Kartu108_BrgD1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.KD_BIDANG <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)
				AND (A.Tahun = @Tahun)

			UNION ALL
			
			SELECT	A.IdPemda, A.No_Register, A.Kd_Aset, A.Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5,
                               A.Harga

  			FROM fn_Kartu108_BrgE1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
	                WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END
				AND (A.Tahun = @Tahun)
	
			UNION ALL
				
			SELECT	A.IdPemda, A.No_Register, A.Kd_Aset, A.Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5,
                               A.Harga
  			FROM fn_Kartu108_BrgL1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END 
				AND (A.Tahun = @Tahun)

			UNION ALL

			SELECT A.IdPemda, A.No_Register, A.Kd_Aset, A.Kd_Aset0, CASE WHEN A.Kondisi >= 3 THEN 7 ELSE 6 END AS Kd_Aset1, 
			       Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, A.Harga 
			FROM fn_Kartu108_BrgF1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
                              A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END  
  				AND (A.Tahun = @Tahun)


---------------------------------------------------------------------------------------------------------------------------

INSERT INTO @tmpnrc1 
SELECT A.Kd_Aset1 as Kd_Aset17, A.Kd_Aset2 as Kd_Aset27, A.Kd_Aset3 as Kd_Aset37, A.Kd_Aset4 as Kd_Aset47, A.Kd_Aset5 as Kd_Aset5, SUM(A.Harga) AS Harga7, 
MAX(B.Kd_Aset) AS Kd_Aset8, MAX(B.Kd_Aset0) AS Kd_Aset08, MAX(B.Kd_Aset1) AS Kd_Aset18, MAX(B.Kd_Aset2) AS Kd_Aset28, MAX(B.Kd_Aset3)  AS Kd_Aset38, MAX(B.Kd_Aset4) AS Kd_Aset48, MAX(B.Kd_Aset5) AS Kd_Aset58, SUM(B.Harga) AS Harga8 
FROM @tmp17 A full outer JOIN @tmp108 B ON A.IDPemda = B.IDPemda
where A.Kd_Aset1<>7 and not (B.kd_aset=1 AND B.Kd_Aset0=5)
GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5


INSERT INTO @tmpnrc1 
SELECT A.Kd_Aset1 as Kd_Aset17, A.Kd_Aset2 as Kd_Aset27, A.Kd_Aset3 as Kd_Aset37, A.Kd_Aset4 as Kd_Aset47, A.Kd_Aset5 as Kd_Aset5, SUM(A.Harga) AS Harga7, 
MAX(B.Kd_Aset) AS Kd_Aset8, MAX(B.Kd_Aset0) AS Kd_Aset08, MAX(B.Kd_Aset1) AS Kd_Aset18, MAX(B.Kd_Aset2) AS Kd_Aset28, MAX(B.Kd_Aset3)  AS Kd_Aset38, MAX(B.Kd_Aset4) AS Kd_Aset48, MAX(B.Kd_Aset5) AS Kd_Aset58, SUM(B.Harga) AS Harga8 
FROM @tmp17 A full outer JOIN @tmp108 B ON A.IDPemda = B.IDPemda
where A.Kd_Aset1=7 and (B.kd_aset=1 AND B.Kd_Aset0=5)
GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5


IF OBJECT_ID('tmpnrc', 'U') IS NOT NULL DROP TABLE tmpnrc;
SELECT IDENTITY(int, 1,1) AS RowNumber, A.* INTO tmpnrc FROM @tmpnrc1 A 


 INSERT INTO @tmpBI17
	SELECT B.RowNumber, @Kd_Bidang AS Kd_Bidang, @Kd_Unit AS Kd_Unit, @Kd_Sub AS Kd_Sub, @Kd_UPB AS Kd_UPB,
		@Kd_Bidang + ' . ' + @Kd_Unit AS Kd_Unit1,
		@Kd_Bidang + ' . ' + @Kd_Unit + ' . ' + @Kd_Sub AS Kd_Sub1,
		@Kd_Bidang + ' . ' + @Kd_Unit + ' . ' + @Kd_Sub + ' . ' + @Kd_UPB AS Kd_UPB1,
		C.Nm_Bidang, 
		C.Nm_Unit, C.Nm_Sub_Unit, C.Nm_UPB,

		'' AS Kd_Grup0,

		CASE WHEN A.Kd_Aset1 IN (7) THEN 'ASET LAINNYA'
 		ELSE 'ASET TETAP'
		END AS Nm_Grup0,	
		
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
		RIGHT('00' + CONVERT(varchar, A.Kd_Aset3), 2) AS Kd_Aset,H.Nm_Aset2 AS Nm_BidangAset, A.Nm_Aset3 AS Nm_Aset, Z.Nm_Aset4 AS Nm_Aset4, X.Nm_Aset5 AS Nm_Rincian, ISNULL(B.Harga7, 0) AS Nilai/*, ISNULL(B.Harga8, 0) AS Nilai8*/
		
		FROM
	
		Ref_Rek_Aset5 X INNER JOIN
		Ref_Rek_Aset4 Z ON X.Kd_Aset1 = Z.Kd_Aset1 AND X.Kd_Aset2 = Z.Kd_Aset2 AND X.Kd_Aset3 = Z.Kd_Aset3 AND X.Kd_Aset4 = Z.Kd_Aset4 INNER JOIN
		Ref_Rek_Aset3 A ON Z.Kd_Aset1 = A.Kd_Aset1 AND Z.Kd_Aset2 = A.Kd_Aset2 AND Z.Kd_Aset3 = A.Kd_Aset3 INNER JOIN
		Ref_Rek_Aset2 H ON A.Kd_Aset1 = H.Kd_Aset1 AND A.Kd_Aset2 = H.Kd_Aset2
		INNER JOIN
		(
		SELECT RowNumber, Kd_Aset17, Kd_Aset27, Kd_Aset37, Kd_Aset47, Kd_Aset57, Harga7, Kd_Aset8, Kd_Aset08, Kd_Aset18, Kd_Aset28, Kd_Aset38, Kd_Aset48, Kd_Aset58, Harga8
		FROM tmpnrc 
		) B ON X.Kd_Aset1 = B.Kd_Aset17 AND X.Kd_Aset2 = B.Kd_Aset27 AND X.Kd_Aset3 = B.Kd_Aset37 AND X.Kd_Aset4 = B.Kd_Aset47 AND X.Kd_Aset5 = B.Kd_Aset57, 
				
		(
		SELECT MAX(E.Nm_Bidang) AS Nm_Bidang, MAX(D.Nm_Unit) AS Nm_Unit, MAX(C.Nm_Sub_Unit) AS Nm_Sub_Unit, MAX(F.Nm_UPB) AS Nm_UPB
		FROM Ta_UPB A INNER JOIN
			Ref_UPB F ON A.Kd_Prov = F.Kd_Prov AND A.Kd_Kab_Kota = F.Kd_Kab_Kota AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB INNER JOIN
			Ta_Sub_Unit B ON A.Tahun = B.Tahun AND A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub INNER JOIN
			Ref_Sub_Unit C ON B.Kd_Prov = C.Kd_Prov AND B.Kd_Kab_Kota = C.Kd_Kab_Kota AND B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub INNER JOIN
			Ref_Unit D ON C.Kd_Prov = D.Kd_Prov AND C.Kd_Kab_Kota = D.Kd_Kab_Kota AND C.Kd_Bidang = D.Kd_Bidang AND C.Kd_Unit = D.Kd_Unit INNER JOIN
			Ref_Bidang E ON D.Kd_Bidang = E.Kd_Bidang
		WHERE A.Tahun = @Tahun AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
		) C
	WHERE B.Harga7 <> 0
	ORDER BY Kd_Grup, A.Kd_Aset2

--------------------------------------------------------------------------------------------------------------------


INSERT INTO @tmpBI108
SELECT A.RowNumber, A.Kd_Bidang , A.Kd_Unit , A.Kd_Sub , A.Kd_UPB , A.Kd_Unit1 , A.Kd_Sub1 ,
		A.Kd_UPB1 , A.Nm_Bidang , A.Nm_Unit , A.Nm_Sub_Unit , A.Nm_UPB , A.Kd_Grup0 , A.Nm_Grup0 , A.Kd_Grup , 
		A.Kd_Gab , A.Kd_Gab1 , A.Kd_Gab2 ,  A.Kd_Gab_Rinci  , A.Nm_Grup  , A.Kd_Aset  , A.Nm_BidangAset , 
		A.Nm_Aset , A.Nm_Aset4 , A.Nm_Rincian , A.Nilai 
FROM (
	SELECT B.RowNumber , @Kd_Bidang AS Kd_Bidang, @Kd_Unit AS Kd_Unit, @Kd_Sub AS Kd_Sub, @Kd_UPB AS Kd_UPB,
		@Kd_Bidang + ' . ' + @Kd_Unit AS Kd_Unit1,
		@Kd_Bidang + ' . ' + @Kd_Unit + ' . ' + @Kd_Sub AS Kd_Sub1,
		@Kd_Bidang + ' . ' + @Kd_Unit + ' . ' + @Kd_Sub + ' . ' + @Kd_UPB AS Kd_UPB1,
		C.Nm_Bidang, 
		C.Nm_Unit, C.Nm_Sub_Unit, C.Nm_UPB,
		
		CASE WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (5) THEN '1.5'
 		ELSE '1.3'
		END AS Kd_Grup0,

		CASE WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (5) THEN 'ASET LAINNYA'
 		ELSE 'ASET TETAP'
		END AS Nm_Grup0,	

		CASE
		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (3) AND A.Kd_Aset1 IN (1) THEN '1'
		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (3) AND A.Kd_Aset1 IN (2) THEN '2'
 		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (3) AND A.Kd_Aset1 IN (3) THEN '3'
 		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (3) AND A.Kd_Aset1 IN (4) THEN '4'
 		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (3) AND A.Kd_Aset1 IN (5) THEN '5'
		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (3) AND A.Kd_Aset1 IN (6) THEN '6'
                WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (3) AND A.Kd_Aset1 IN (7) THEN '7'
 		 
		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (5) AND A.Kd_Aset1 IN (1) THEN '1.5.1'
		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (5) AND A.Kd_Aset1 IN (2) THEN '1.5.2'
 		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (5) AND A.Kd_Aset1 IN (3) THEN '1.5.3'
 		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (5) AND A.Kd_Aset1 IN (4) THEN '1.5.4'
 		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (5) AND A.Kd_Aset1 IN (5) THEN '1.5.5'
		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (5) AND A.Kd_Aset1 IN (6) THEN '1.5.6'
                WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (5) AND A.Kd_Aset1 IN (7) THEN '1.5.7'

		ELSE '0'
		END AS Kd_Grup,
		-- A.Kd_Aset, 
		A.Kd_Aset1,
		RIGHT('00' + CONVERT(varchar, A.Kd_Aset1),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset2),2) AS Kd_Gab,
		RIGHT('00' + CONVERT(varchar, A.Kd_Aset1),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset2),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset3),2) AS Kd_Gab1,
		RIGHT('00' + CONVERT(varchar, X.Kd_Aset1),2) + ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset2),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset3),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset4),2) AS Kd_Gab2,
		RIGHT('00' + CONVERT(varchar, X.Kd_Aset),2) + ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset0),2) + ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset1),2) + ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset2),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset3),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset4),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, X.Kd_Aset5),2) AS Kd_Gab_Rinci,
		CASE
		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (3) AND A.Kd_Aset1 IN (1) THEN 'Tanah'
		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (3) AND A.Kd_Aset1 IN (2) THEN 'Peralatan dan Mesin'
 		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (3) AND A.Kd_Aset1 IN (3) THEN 'Gedung dan Bangunan Gedung'
 		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (3) AND A.Kd_Aset1 IN (4) THEN 'Jalan, Irigasi dan Jaringan'
 		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (3) AND A.Kd_Aset1 IN (5) THEN 'Aset Tetap Lainnya'
		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (3) AND A.Kd_Aset1 IN (6) THEN 'Konstruksi Dalam Pengerjaan'

		WHEN A.Kd_Aset IN (1) AND A.Kd_Aset0 IN (5)  THEN 'ASET LAINNYA'

 		ELSE ''
		END AS Nm_Grup,
		RIGHT('00' + CONVERT(varchar, A.Kd_Aset3), 2) AS Kd_Aset,H.Nm_Aset2 AS Nm_BidangAset, A.Nm_Aset3 AS Nm_Aset, Z.Nm_Aset4 AS Nm_Aset4, X.Nm_Aset5 AS Nm_Rincian, ISNULL(B.Harga8, 0) AS Nilai

	FROM
		Ref_Rek5_108 X INNER JOIN
		Ref_Rek4_108 Z ON X.Kd_Aset = Z.Kd_Aset AND X.Kd_Aset0 = Z.Kd_Aset0 AND X.Kd_Aset1 = Z.Kd_Aset1 AND X.Kd_Aset2 = Z.Kd_Aset2 AND X.Kd_Aset3 = Z.Kd_Aset3 AND X.Kd_Aset4 = Z.Kd_Aset4 INNER JOIN
		Ref_Rek3_108 A ON Z.Kd_Aset = A.Kd_Aset AND Z.Kd_Aset0 = A.Kd_Aset0 AND Z.Kd_Aset1 = A.Kd_Aset1 AND Z.Kd_Aset2 = A.Kd_Aset2 AND Z.Kd_Aset3 = A.Kd_Aset3 INNER JOIN
		Ref_Rek2_108 H ON A.Kd_Aset = H.Kd_Aset AND A.Kd_Aset0 = H.Kd_Aset0 AND A.Kd_Aset1 = H.Kd_Aset1 AND A.Kd_Aset2 = H.Kd_Aset2
		INNER JOIN
		(
		SELECT RowNumber, Kd_Aset8, Kd_Aset08, Kd_Aset18, Kd_Aset28, Kd_Aset38, Kd_Aset48, Kd_Aset58, Harga8
		FROM tmpnrc
		) B ON X.Kd_Aset = B.Kd_Aset8 AND X.Kd_Aset0 = B.Kd_Aset08 AND X.Kd_Aset1 = B.Kd_Aset18 AND X.Kd_Aset2 = B.Kd_Aset28 AND X.Kd_Aset3 = B.Kd_Aset38 AND X.Kd_Aset4 = B.Kd_Aset48 AND X.Kd_Aset5 = B.Kd_Aset58, 
		(
		SELECT MAX(E.Nm_Bidang) AS Nm_Bidang, MAX(D.Nm_Unit) AS Nm_Unit, MAX(C.Nm_Sub_Unit) AS Nm_Sub_Unit, MAX(F.Nm_UPB) AS Nm_UPB
		FROM Ta_UPB A INNER JOIN
			Ref_UPB F ON A.Kd_Prov = F.Kd_Prov AND A.Kd_Kab_Kota = F.Kd_Kab_Kota AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB INNER JOIN
			Ta_Sub_Unit B ON A.Tahun = B.Tahun AND A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub INNER JOIN
			Ref_Sub_Unit C ON B.Kd_Prov = C.Kd_Prov AND B.Kd_Kab_Kota = C.Kd_Kab_Kota AND B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub INNER JOIN
			Ref_Unit D ON C.Kd_Prov = D.Kd_Prov AND C.Kd_Kab_Kota = D.Kd_Kab_Kota AND C.Kd_Bidang = D.Kd_Bidang AND C.Kd_Unit = D.Kd_Unit INNER JOIN
			Ref_Bidang E ON D.Kd_Bidang = E.Kd_Bidang
		WHERE A.Tahun = @Tahun AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
		) C
	WHERE B.Harga8 <> 0
	
) A



SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, A.Nm_Bidang, A.Nm_Unit, A.Nm_Sub_Unit, A.Nm_UPB, A.Kd_Grup0, A.Nm_Grup0, 
A.Kd_Grup, A.Kd_Gab, A.Kd_Gab1, A.Kd_Gab2, A.Kd_Gab_Rinci, A.Nm_Grup, A.Kd_Aset, A.Nm_BidangAset, A.Nm_Aset, A.Nm_Aset4, A.Nm_Rincian, isnull(A.Nilai,0) AS Nilai, 
A.Kd_Gab_Rinci AS Kd_Gab_Rinci_17, C.Kd_Gab_Rinci AS Kd_Gab_Rinci_108, C.Kd_Bidang, C.Kd_Unit, C.Kd_Sub, C.Kd_UPB, C.Kd_Unit1, C.Kd_Sub1, C.Kd_UPB1, C.Nm_Bidang, C.Nm_Unit, C.Nm_Sub_Unit, C.Nm_UPB, 
C.Kd_Grup0, C.Nm_Grup0, C.Kd_Grup, C.Kd_Gab, C.Kd_Gab1, C.Kd_Gab2, C.Kd_Gab_Rinci, C.Nm_Grup, C.Kd_Aset, C.Nm_BidangAset, C.Nm_Aset, C.Nm_Aset4, C.Nm_Rincian, isnull(C.Nilai,0) AS Nilai, isnull(C.Nilai,0)-isnull(A.Nilai,0) as selisih
FROM @tmpBI108 A full outer JOIN  @tmpBI17 C ON A.RowNumber = C.RowNumber 
ORDER BY C.Kd_Grup0, C.Kd_Grup, C.Kd_Gab_Rinci








GO
