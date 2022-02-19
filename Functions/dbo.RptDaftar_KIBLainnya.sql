USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** RptDaftar_KIBLainnya - 11012017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE RptDaftar_KIBLainnya @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D2 datetime 
WITH ENCRYPTION
AS

/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D2 datetime
SET @Tahun = '2016'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = ''
SET @D2 = '20161231' 
*/
	DECLARE @KIBRB TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, 
			Kd_Pemilik tinyint, No_Register int, Tgl_Perolehan datetime, Tgl_Pembukuan datetime, HargaRB money, Asal_usul varchar (50),Tahun smallint, Alamat varchar(255), Luas varchar(50), Merk varchar (50), Type varchar (50), CC varchar (50), kondisi varchar (20), keterangan varchar (255))
	DECLARE @KIBM TABLE (Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, 
			Kd_Pemilik tinyint, No_Register int, Tgl_Perolehan datetime, Tgl_Pembukuan datetime, HargaM money, Asal_usul varchar (50),Tahun smallint, AlamatM varchar(255), LuasM varchar(50), No_dokumen varchar (50), tgl_dokumen datetime, kondisi varchar (20), keterangan varchar (255) )
	DECLARE @KIBL TABLE (Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, 
			Kd_Pemilik tinyint, No_Register int, Tgl_Perolehan datetime, Tgl_Pembukuan datetime, HargaL money, Asal_usul varchar (50),Tahun smallint, judul varchar(50),pencipta varchar (50), spesifikasi varchar (50), kondisi varchar (20), keterangan varchar (255))
	DECLARE @JLap Tinyint

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'



--RUSAK BERAT
	INSERT INTO @KIBRB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
	       A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga AS HargaRB, A.Asal_usul, A.Tahun, A.Alamat, A.Luas, A.Merk, A.Type, A.CC, A.Kondisi, A.Keterangan
        FROM   
            (
             SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
					A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Asal_usul, YEAR(A.Tgl_Perolehan) AS Tahun, 
					NULL AS Alamat, NULL As Luas, A.Merk, A.Type, A.CC, A.Kondisi,A.Keterangan
			 FROM fn_Kartu_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
			 WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
				   AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
										WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
										WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
									ELSE 12 END)  
				   AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) AND (A.Kondisi = 3)

             UNION ALL
	
			 SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
				A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Asal_usul, YEAR(A.Tgl_Perolehan) AS Tahun,
				A.Lokasi AS Alamat, A.Luas_Lantai AS Luas,NULL, NULL, NULL, A.Kondisi,A.Keterangan
			 FROM fn_Kartu_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%',@JLap)  A 
			 WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
				   AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
										WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
										WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
									ELSE 12 END)  
				   AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) AND (A.Kondisi = 3)

             UNION ALL
	
			 SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
				A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Asal_usul, YEAR(A.Tgl_Perolehan) AS Tahun,
				A.Lokasi AS Alamat, A.Luas,NULL, NULL, NULL, A.Kondisi,A.Keterangan
			 FROM fn_Kartu_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%',@JLap)  A 
			 WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
				   AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
										WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
										WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
									ELSE 12 END)  
				   AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) AND (A.Kondisi = 3)

             UNION ALL	

			 SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
				A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Asal_usul, YEAR(A.Tgl_Perolehan) AS Tahun,
				NULL, NULL,NULL,NULL,NULL, A.Kondisi,A.Keterangan
			 FROM fn_Kartu_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%',@JLap)  A 
			 WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
				   AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
										WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
										WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
									ELSE 12 END)  
				   AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) AND (A.Kondisi = 3)

			/* UNION ALL	

			 SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
				A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Asal_usul, YEAR(A.Tgl_Perolehan) AS Tahun,
				NULL, NULL, NULL,NULL,NULL, A.Kondisi,A.Keterangan
			 FROM fn_Kartu_BrgL(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%',@JLap)  A 
			 WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
				   AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
										WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
										WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
									ELSE 12 END)  
				   AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) AND (A.KONDISI = 3)
*/
			 UNION ALL 	

			 SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
				A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Asal_usul, YEAR(A.Tgl_Perolehan) AS Tahun,
				A.Lokasi AS Alamat, A.Luas_Lantai AS Luas,NULL,NULL,NULL, A.Kondisi,A.Keterangan
			 FROM fn_Kartu_BrgF(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%',@JLap)  A
			 WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
				   AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
										WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
										WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
									ELSE 12 END)  
				   AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) AND (A.Kondisi = 3)
		) A

	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
	       A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Asal_usul, A.Tahun, A.Alamat, A.Luas, A.Merk, A.Type, A.CC, A.Kondisi, A.Keterangan

---tambahan utk aset yg dimanfaatkan

	INSERT INTO @KIBM
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
	       A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga AS HargaM, A.Asal_usul,A.Tahun, A.AlamatM, A.LuasM, A.No_dokumen, A.tgl_dokumen, A.Kondisi, A.Keterangan
        FROM   
	(
	     		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		    		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Asal_usul,YEAR(A.Tgl_Perolehan) AS Tahun,
				A.Alamat AS AlamatM, A.Luas_M2 AS LuasM, B.No_dokumen, B.tgl_dokumen, null as Kondisi, A.Keterangan
	     		FROM fn_Kartu_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%',@JLap)  A  INNER JOIN
				Ta_KIBAR B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				      A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND
				      A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register 
	     		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	           		AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1)
	           		AND (A.KD_BIDANG <> 22) AND (B.Kd_Riwayat IN(10,11,12,13)) AND (B.Tgl_Dokumen <= @D2)

             		UNION ALL 	

			SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
				A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Asal_usul,YEAR(A.Tgl_Perolehan) AS Tahun,
				null AS AlamatM, null AS LuasM, B.No_dokumen, B.tgl_dokumen, A.Kondisi,A.Keterangan

			FROM fn_Kartu_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A  INNER JOIN
				Ta_KIBBR B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
					A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND
					A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register 
			WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
				AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1)
				AND (A.KD_BIDANG <> 22) AND (A.Kondisi <> 3) AND (B.Kd_Riwayat IN(10,11,12,13)) AND (B.Tgl_Dokumen <= @D2)

             		UNION ALL 	

			SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
				A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Asal_usul,YEAR(A.Tgl_Perolehan) AS Tahun,
				A.Lokasi AS AlamatM, A.Luas_Lantai AS LuasM, B.No_dokumen, B.tgl_dokumen, A.Kondisi,A.Keterangan
				
			FROM fn_Kartu_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%',@JLap)  A  INNER JOIN
				Ta_KIBCR B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
					A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND
					A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register 
			WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      			AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1)
				AND (A.KD_BIDANG <> 22) AND (A.Kondisi <> 3) AND (B.Kd_Riwayat IN(10,11,12,13)) AND (B.Tgl_Dokumen <= @D2)

             		UNION ALL 	

			SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
				A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga,A.Asal_usul,YEAR(A.Tgl_Perolehan) AS Tahun,
				A.Lokasi AS AlamatM, A.Luas AS LuasM, B.No_dokumen, B.tgl_dokumen, A.Kondisi,A.Keterangan

			FROM fn_Kartu_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%',@JLap)  A  INNER JOIN
				Ta_KIBDR B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
					A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND
					A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register 
			WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		      		AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1)
		      		AND (A.KD_BIDANG <> 22) AND (A.Kondisi <> 3) AND (B.Kd_Riwayat IN(10,11,12,13)) AND (B.Tgl_Dokumen <= @D2)

				) A

	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
	       A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Asal_usul,A.Tahun, A.AlamatM, A.LuasM, A.No_dokumen, A.tgl_dokumen, A.Kondisi, A.Keterangan


	INSERT INTO @KIBL
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
				A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga AS HargaL, A.Asal_usul,YEAR(A.Tgl_Perolehan) AS Tahun, 
				A.Judul, A.Pencipta, A.Bahan, A.Kondisi,A.Keterangan
	FROM fn_Kartu_BrgL (@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%',@JLap)  A  INNER JOIN
				TA_LAINNYA B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
					A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND
					A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register 
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		      		AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1)AND (A.KD_BIDANG <> 22)
				AND (B.Tgl_Pembukuan <= @D2)

	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
				A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Asal_usul, A.Judul, A.Pencipta, A.Bahan, A.Kondisi,A.Keterangan
	
-----

	SELECT A.Kd_Prov, C.Nm_Provinsi, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB,
		A.Kd_Aset1, B.Nm_Aset1, A.Kd_Aset2, B.Nm_Aset2, A.Kd_Aset3, B.Nm_Aset3, A.Kd_Aset4, B.Nm_Aset4, A.Kd_Aset5, B.Nm_Aset5, 
		CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)AS Kd_Aset_Gab2,    
		CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)AS Kd_Aset_Gab3,     
		CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4)AS Kd_Aset_Gab4,     
		CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4)+'.'+CONVERT(varchar, A.Kd_Aset5)AS Kd_Aset_Gab5,     
		dbo.fn_KdLokasi(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tahun) AS Kd_Lokasi,
		dbo.fn_KdLokasi3(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tahun) AS Kd_Lokasi_Grp,
		A.No_register, ISNULL ((A.HargaRB / 1000), 0) AS HargaRB, ISNULL ((A.HargaL / 1000), 0) AS HargaL, ISNULL ((A.HargaM / 1000), 0) AS HargaM, 
		ISNULL (A.HargaRB,0) + ISNULL (A.HargaL, 0) + ISNULL (A.HargaM, 0) AS Total,
		A.Asal_usul,A.Tahun, A.Alamat, ISNULL (A.Luas, '-') AS Luas, ISNULL (A.Merk, '-') AS Merk, 
		ISNULL (A.Type, '-') AS Type, ISNULL (A.CC, '-') AS CC, 
		ISNULL (A.AlamatM, '-') AS AlamatM, ISNULL (A.LuasM, '-') AS LuasM, A.No_dokumen, 
		A.Tgl_Dokumen, ISNULL (A.JUDUL, '-') AS Judul, 
		ISNULL (A.Pencipta, '-') AS Pencipta, ISNULL (A.spesifikasi, '-') AS spesifikasi, A.Kondisi, A.Uraian, A.Keterangan
		
	FROM

	(
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
				A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, NULL AS HARGARB, A.HargaL, NULL AS HARGAM, A.Asal_usul,A.Tahun, NULL AS Alamat, NULL AS Luas, NULL AS Merk, NULL AS Type, 
				NULL AS CC, NULL AS AlamatM, NULL AS LuasM, NULL AS No_dokumen, NULL AS Tgl_Dokumen, A.Judul, A.Pencipta, A.Spesifikasi, A.Kondisi, B.Uraian, A.Keterangan
		FROM @KIBL A INNER JOIN
			Ref_Kondisi B ON A.Kondisi = B.Kd_Kondisi
		
		UNION ALL

		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
				A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan,  NULL AS HARGARB,  NULL AS HARGAL, A.HARGAM, A.Asal_usul,A.Tahun, NULL AS Alamat, NULL AS Luas, NULL AS Merk, NULL AS Type, NULL AS CC,
				A.AlamatM, A.LuasM, A.No_dokumen, A.tgl_dokumen, NULL, NULL, NULL, A.Kondisi, B.Uraian, A.Keterangan
		FROM @KIBM A INNER JOIN
			Ref_Kondisi B ON A.Kondisi = B.Kd_Kondisi

		UNION ALL

		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
				A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.HargaRB, NULL AS HARGAM, NULL AS HARGAL, A.Asal_usul,A.Tahun, A.Alamat, A.Luas, A.Merk, A.Type, A.CC, 
				 NULL AS AlamatM,  NULL AS LUASM, NULL AS NO_DOKUMEN, NULL AS TGL_DOKUMEN, NULL, NULL,NULL, A.Kondisi, B.Uraian, A.Keterangan
		FROM @KIBRB A INNER JOIN
			Ref_Kondisi B ON A.Kondisi = B.Kd_Kondisi
		

	) A 
	
	INNER JOIN
	(
	SELECT  A.Kd_Aset1, A.Nm_Aset1, B.Kd_Aset2, B.Nm_Aset2, C.Kd_Aset3, C.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, E.Kd_Aset5, E.Nm_Aset5
	FROM    Ref_Rek_Aset1 A INNER JOIN
                Ref_Rek_Aset2 B ON A.Kd_Aset1 = B.Kd_Aset1 INNER JOIN
                Ref_Rek_Aset3 C ON B.Kd_Aset1 = C.Kd_Aset1 AND B.Kd_Aset2 = C.Kd_Aset2 INNER JOIN
                Ref_Rek_Aset4 D ON C.Kd_Aset1 = D.Kd_Aset1 AND C.Kd_Aset2 = D.Kd_Aset2 AND C.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
                Ref_Rek_Aset5 E ON D.Kd_Aset1 = E.Kd_Aset1 AND D.Kd_Aset2 = E.Kd_Aset2 AND D.Kd_Aset3 = E.Kd_Aset3 AND D.Kd_Aset4 = E.Kd_Aset4
	) B ON  A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND 
                A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
	(
	SELECT  A.Kd_Prov, A.Nm_Provinsi, B.Kd_Kab_Kota, B.Nm_Kab_Kota, D.Kd_Bidang, C.Nm_Bidang, D.Kd_Unit, D.Nm_Unit, E.Kd_Sub, E.Nm_Sub_Unit, F.Kd_UPB, F.Nm_UPB
	FROM    Ref_Unit D INNER JOIN
                Ref_Bidang C ON D.Kd_Bidang = C.Kd_Bidang INNER JOIN
                Ref_Sub_Unit E ON D.Kd_Prov = E.Kd_Prov AND D.Kd_Kab_Kota = E.Kd_Kab_Kota AND D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
                Ref_UPB F ON E.Kd_Prov = F.Kd_Prov AND E.Kd_Kab_Kota = F.Kd_Kab_Kota AND E.Kd_Bidang = F.Kd_Bidang AND E.Kd_Unit = F.Kd_Unit AND 
                E.Kd_Sub = F.Kd_Sub INNER JOIN
                Ref_Provinsi A INNER JOIN
                Ref_Kab_Kota B ON A.Kd_Prov = B.Kd_Prov ON D.Kd_Prov = B.Kd_Prov AND D.Kd_Kab_Kota = B.Kd_Kab_Kota  
		
	)C ON   A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND 
                A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB 
	
WHERE A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
      A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND A.Tgl_Pembukuan <= @D2

--ORDER BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
GROUP BY A.Kd_Prov, C.Nm_Provinsi, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB,
		A.Kd_Aset1, B.Nm_Aset1, A.Kd_Aset2, B.Nm_Aset2, A.Kd_Aset3, B.Nm_Aset3, A.Kd_Aset4, B.Nm_Aset4, A.Kd_Aset5, B.Nm_Aset5, 
		A.No_register, A.HargaL, A.HargaRB, A.HargaM, A.Asal_usul,A.Tahun, A.Alamat, A.Luas, A.Merk, A.Type, A.CC, A.AlamatM, A.LuasM, A.No_dokumen, 
		A.tgl_dokumen,	A.Judul, A.Pencipta, A.spesifikasi, A.KONDISI,  A.Uraian, A.Keterangan, A.Kd_Pemilik




GO
