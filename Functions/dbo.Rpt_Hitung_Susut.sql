USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** Rpt_Hitung_Susut - 13022017 - Modified for Ver 2.0.7 [demi@simda.id] ****/
CREATE PROCEDURE Rpt_Hitung_Susut @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
                 @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4), @D2 Datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4), @Kd_KIB varchar(1), @D2 Datetime

SET @Tahun = '2016'
SET @Kd_Prov	= '10'
SET @Kd_Kab_Kota= '1'
SET @Kd_Bidang	= '1'
SET @Kd_Unit	= '1'
SET @Kd_Sub	= '1'
SET @Kd_UPB	= '1'
SET @Kd_Aset1	= '2'
SET @Kd_Aset2	= '3'
SET @Kd_Aset3	= '1'
SET @Kd_Aset4	= '1'
SET @Kd_Aset5	= '2'
SET @No_Register = '12'
SET @Kd_KIB = 'B' 
SET @D2	 = '20161231'
*/

DECLARE @Kd_KIB varchar(1)
DECLARE @tmp1 TABLE(No_urut smallint, Akum money, Susut money, Sisa money, HP money, Sisa_Umur smallint, Sisa_Umur_Asli smallint, 
                    Umur smallint, Umur_Pakai smallint, Tgl datetime, Riwayat smallint)
DECLARE @pindah TABLE(IDPemda varchar(17),Tgl_Perolehan datetime, Kd_ID Int)
DECLARE @Tahun1 varchar(6), @Thn1 varchar(6), @Harga1 money, @Masa_Manfaat1 smallint, @Tgl1 datetime, @Kd_Riwayat1 smallint, @kawal1 smallint,
        @Tahun2 varchar(6), @Thn2 varchar(6), @Harga2 money, @Masa_Manfaat2 smallint, @Tgl2 datetime, @Kd_Riwayat2 smallint, @kawal2 smallint,
        @SMM smallint, @NSusut money, @NSisa money, @Akum money, @HP money, @Umur smallint, @Umur_Pakai smallint, @Tgl datetime,
        @Hitung_Susut money, @Hitung_Umur smallint, @SMMA smallint, @Riwayat smallint, @No smallint, @IDPemda Varchar(17), @kawal smallint

	IF @Kd_Aset1 = '1' SET @Kd_KIB = 'A'
	IF @Kd_Aset1 = '2' SET @Kd_KIB = 'B'
	IF @Kd_Aset1 = '3' SET @Kd_KIB = 'C'
	IF @Kd_Aset1 = '4' SET @Kd_KIB = 'D'
	IF @Kd_Aset1 = '5' SET @Kd_KIB = 'E'

IF @Kd_KIB = 'B' 
BEGIN
        SET @IDPemda = (
                        SELECT IDPemda FROM Ta_KIB_B
                        WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND 
                              Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND 
                              Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register 
                       )

        INSERT INTO @pindah
        SELECT A.IDPemda, A.Tgl_Perolehan, A.Kd_ID
        FROM
            (SELECT A.IDPemda, MIN(A.Tgl_Perolehan) AS Tgl_Perolehan, MIN(A.Kd_ID) AS Kd_ID
             FROM Ta_KIBBR A
             WHERE A.Kd_Riwayat = 3 AND YEAR(A.Tgl_Perolehan) <= @Tahun AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND 
                   A.Kd_Data <> 3 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)  
             GROUP BY A.IDPemda
            ) A
        GROUP BY A.IDPemda, A.Tgl_Perolehan, A.Kd_ID

        SET @Thn1 = NULL
	SET @Harga1 = NULL
	SET @Masa_Manfaat1 = NULL
        SET @Tgl1 = NULL
        SET @Kd_Riwayat1 = NULL
        SET @Riwayat = NULL
        SET @HP = 0
        SET @Akum = 0
        Set @Umur = 0
        SET @Umur_Pakai = 0
        SET @Hitung_Susut = 0       
        SET @Hitung_Umur = 0
        SET @No = 0
        SET @kawal = 0
        	
	DECLARE c2 CURSOR FOR

        SELECT LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6) AS Tahun, A.Harga, 
               CASE A.Kondisi WHEN 3 THEN 0 ELSE ISNULL(A.Masa_Manfaat, 0) /* 12*/ END AS Masa_Manfaat, 
               A.Tgl_Perolehan, 
               CASE A.Kondisi WHEN 3 THEN 1 ELSE 0 END AS Kd_Riwayat,
               CASE A.Masa_Manfaat WHEN NULL THEN 0 WHEN 0 THEN 0 ELSE 1 END AS Kawal
        FROM Ta_KIB_B A LEFT OUTER JOIN @pindah B ON A.IDPemda = B.IDPemda
        WHERE B.IDPemda IS NULL AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND YEAR(A.Tgl_Perolehan) <= @Tahun AND 
              A.Kd_Data <> 3 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND 
              A.IDPemda = @IDPemda
              
        UNION ALL

        SELECT LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6) AS Tahun, A.Harga, 
               CASE A.Kondisi WHEN 3 THEN 0 ELSE ISNULL(A.Masa_Manfaat, 0) /* 12*/ END AS Masa_Manfaat, 
               A.Tgl_Perolehan, 33,
               CASE A.Masa_Manfaat WHEN NULL THEN 0 WHEN 0 THEN 0 ELSE 1 END AS Kawal
        FROM Ta_KIBBR A INNER JOIN @pindah B ON A.IDPemda = B.IDPemda AND A.Tgl_Perolehan = B.Tgl_Perolehan AND A.Kd_ID = B.Kd_ID 
        WHERE A.IDPemda = @IDPemda

        UNION ALL

        SELECT LEFT(CONVERT(varchar, Tgl_Dokumen, 112), 6) AS Tahun, 
               CASE Kd_Riwayat WHEN 7 THEN -Harga WHEN 1 THEN 0 WHEN 3 THEN 0 WHEN 20 THEN 0 ELSE Harga END, 
               CASE Kd_Riwayat WHEN 2 THEN ISNULL(Masa_Manfaat, 0) ELSE 0 END /* 12*/, 
               Tgl_Dokumen, Kd_Riwayat, 0 AS Kawal
        FROM Ta_KIBBR
        WHERE IDPemda = @IDPemda AND LEFT(CONVERT(varchar, Tgl_Dokumen, 112), 6) <= CONVERT(Varchar,@Tahun)+ '12' AND
              Kd_Riwayat IN(1,2,7,21) AND Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END       

        UNION ALL

        SELECT LEFT(CONVERT(varchar, Tgl_SK, 112), 6) AS Tahun, 0 AS Harga, 0 AS Masa_Manfaat, Tgl_SK, 25 AS Kd_Riwayat, 0 AS Kawal 
	FROM Ta_KIBBHapus  
	WHERE IDPemda = @IDPemda AND LEFT(CONVERT(varchar, Tgl_SK, 112), 6) <= CONVERT(Varchar,@Tahun)+ '12' AND 
              Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END 

        UNION ALL

        SELECT CONVERT(Varchar,(@Tahun)) + '01', 0, 0, CONVERT(Varchar,(@Tahun-1)) + '1231', 34, 0
        
        UNION ALL

        SELECT CONVERT(Varchar,@Tahun) + '07', 0, 0, CONVERT(Varchar, @Tahun) + '0630', 35, 0

        UNION ALL

        SELECT CONVERT(Varchar, @Tahun+1) + '01', 0, 0, CONVERT(Varchar, @Tahun) + '1231', 36, 0
	
        ORDER BY Tahun
	
	OPEN c2
	
	FETCH NEXT FROM c2 INTO @Thn1, @Harga1, @Masa_Manfaat1, @Tgl1, @Kd_Riwayat1, @kawal1
	SET @SMM = @Masa_Manfaat1
        SET @Riwayat = @Kd_Riwayat1
        SET @NSisa = @Harga1
        SET @HP = @Harga1
        SET @Umur = @Masa_Manfaat1 
        SET @Tgl = @Tgl1
        SET @kawal = @kawal1
                        		
	FETCH NEXT FROM c2 INTO @Thn2, @Harga2, @Masa_Manfaat2, @Tgl2, @Kd_Riwayat2, @kawal2
	WHILE @@FETCH_STATUS = 0
	BEGIN

                IF @SMM > 0 
                BEGIN
                        SET @Hitung_Susut = ROUND((@NSisa / @SMM) * (DATEDIFF(mm, @Thn1 + '01', @Thn2 + '01')), 0)
                        SET @Hitung_Umur = (DATEDIFF(mm, @Thn1 + '01', @Thn2 + '01'))
                END
                ELSE
                BEGIN
                        SET @Hitung_Susut = 0
                        SET @Hitung_Umur = 0
                END

                IF (@Hitung_Umur < @SMM) AND (@SMM > 0) AND ((@NSisa - @Hitung_Susut + @Harga2) > 0)
		BEGIN
			SET @NSusut = @Hitung_Susut
                        SET @Umur_pakai = @Hitung_Umur
		END
		ELSE
		BEGIN
                        IF @SMM = 0 SET @NSusut = 0 ELSE
			SET @NSusut = ROUND((@NSisa / @SMM) * @SMM, 0)
                        SET @Umur_Pakai = @SMM
		END

                IF @NSisa - @Hitung_Susut + @Harga2 < 0 AND (@Hitung_Umur < @SMM)
                BEGIN  
                        SET @NSusut = @NSisa + @Harga2
                        SET @Umur_Pakai = @Hitung_Umur
                END

                IF @SMM = 0 AND @NSisa <> 0 AND @kawal = 1 --AND @Riwayat IN (2,7,21)
                BEGIN
                        SET @NSusut = @NSisa
                END

                IF (@Hitung_Umur < @SMM) AND (@SMM > 0) AND (@Kd_Riwayat2 NOT IN(1,25))
		BEGIN
                        SET @SMMA = @SMM - @Hitung_Umur
			SET @SMM = @SMM - @Hitung_Umur
                END
		ELSE
		BEGIN
                        IF (@Hitung_Umur > @SMM) AND (@Kd_Riwayat2 NOT IN(1,25)) SET @SMMA = 0
                        ELSE
                        SET @SMMA = @SMM - @Hitung_Umur 
                     	SET @SMM = 0                        
		END

                IF @Riwayat = 25 
                BEGIN   
                        SET @Kd_Riwayat2 = 25
                END
                ELSE
                BEGIN
                        IF @Riwayat = 1 SET @Kd_Riwayat2 = 1
                        ELSE
                        SET @Kd_Riwayat2 = @Kd_Riwayat2
                END

                SET @Akum = @Akum + @NSusut	
                SET @NSisa = @NSisa - @NSusut
                SET @No = @No + 1
                
                SET @Riwayat = @Kd_Riwayat2
                SET @HP = @Harga2
                SET @Umur = @Masa_Manfaat2
                SET @Tgl = @Tgl2
                		
		SET @NSisa = @NSisa + @Harga2
		SET @SMM = @SMM + @Masa_Manfaat2                            	
                SET @SMMA = @SMMA + @Masa_Manfaat2
                SET @kawal = @kawal + @kawal2

		SET @Thn1 = @Thn2
		SET @Harga1 = @Harga2
		SET @Masa_Manfaat1 = @Masa_Manfaat2
                SET @Tgl1 = @Tgl2
                SET @kawal1 = @kawal2

        INSERT INTO @tmp1
	SELECT @No, @Akum, @NSusut, @NSisa, @HP, @SMM, @SMMA, @Umur, @Umur_Pakai, @Tgl, @Riwayat

	FETCH NEXT FROM c2 INTO @Thn2, @Harga2, @Masa_Manfaat2, @Tgl2, @Kd_Riwayat2, @kawal2
		
        END
	CLOSE c2
	DEALLOCATE c2

SELECT B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Nm_Bidang, B.Nm_Unit, B.Nm_Sub_Unit, B.Nm_UPB, 
	CONVERT(varchar, B.Kd_Aset1) + '.' + CONVERT(varchar, B.Kd_Aset2) + '.' + CONVERT(varchar, B.Kd_Aset3) + '.' + CONVERT(varchar, B.Kd_Aset4) + '.' + CONVERT(varchar, B.Kd_Aset5)  AS Kd_Asetgab, 
	B.No_Register, B.Nm_Aset5,A.Bulan,A.Nilai_Perolehan, A.Nilai_dasar, A.Umur_Pakai, A.Umur, A.Susut, A.Akum, A.Nilai_Buku
FROM
	(
	SELECT A.Bulan, B.Nilai_Perolehan, B.Nilai_Dasar, B.Umur_Pakai, B.Umur, B.Susut, B.Akum, B.Nilai_Buku
	FROM
	    (
 	    SELECT (LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6)) AS bulan 
 	    FROM Ta_KIB_B A LEFT OUTER JOIN @pindah B ON A.IDPemda = B.IDPemda
 	    WHERE B.IDPemda IS NULL AND A.IDPemda = @IDPemda
  	   UNION ALL
  	   SELECT (LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6)) 
  	   FROM @pindah A 
  	   WHERE A.IDPemda = @IDPemda
  	  ) A, 
        (
         SELECT (Akum+Sisa-HP) AS Nilai_perolehan, 0 AS Nilai_Dasar, 0 AS Umur_Pakai, 0 AS Umur, 0 AS Susut, 0 AS Akum, 
                (Akum+Sisa-HP) AS Nilai_Buku   
         FROM @tmp1 
         WHERE No_urut = 1
        ) B
	UNION ALL

	SELECT (LEFT(CONVERT(varchar, Tgl, 112), 6)), (Akum+Sisa), Sisa+Susut-HP , Umur_Pakai, (Sisa_Umur_Asli+Umur_Pakai-Umur), Susut,
	       Akum, Sisa
	FROM @tmp1

	) A, 
	(SELECT A.KD_BIDANG, A.KD_UNIT, A.KD_SUB, A.KD_UPB, B.Nm_Bidang, C.NM_UNIT, D.Nm_Sub_Unit, E.NM_UPB,
		A.KD_ASET1, A.KD_ASET2, A.KD_ASET3, A.KD_ASET4, A.KD_ASET5, A.NO_REGISTER, F.NM_ASET5
	FROM TA_KIB_B A INNER JOIN
		REF_BIDANG B ON A.KD_BIDANG = B.KD_BIDANG INNER JOIN
		REF_UNIT C ON A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT INNER JOIN
		REF_SUB_UNIT D ON A.KD_BIDANG = D.KD_BIDANG AND A.KD_UNIT = D.KD_UNIT AND A.KD_SUB = D.KD_SUB INNER JOIN
		REF_UPB E ON A.KD_BIDANG = E.KD_BIDANG AND A.KD_UNIT = E.KD_UNIT AND A.KD_SUB = E.KD_SUB AND A.KD_UPB = E.KD_UPB INNER JOIN
 		REF_REK_ASET5 F ON A.KD_ASET1 = F.KD_ASET1 AND  A.KD_ASET2 = F.KD_ASET2 AND  A.KD_ASET3 = F.KD_ASET3 AND  A.KD_ASET4 = F.KD_ASET4 AND  A.KD_ASET5 = F.KD_ASET5 
	WHERE A.KD_BIDANG = @KD_BIDANG AND A.KD_UNIT = @KD_UNIT AND A.KD_SUB = @KD_SUB AND A.KD_UPB = @KD_UPB  
		AND A.KD_ASET1 = @KD_ASET1 AND A.KD_ASET2 = @KD_ASET2 AND A.KD_ASET3 = @KD_ASET3 AND A.KD_ASET4 = @KD_ASET4 AND A.KD_ASET5 = @KD_ASET5 AND A.NO_REGISTER = @NO_REGISTER
	) B

GROUP BY  B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Nm_Bidang, B.Nm_Unit, B.Nm_Sub_Unit, B.Nm_UPB, 
	B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.No_Register, B.Nm_Aset5,
	A.Bulan, A.Nilai_Perolehan, A.Nilai_dasar, A.Umur_Pakai, A.Umur, A.Susut, A.Akum, A.Nilai_Buku


END

---------------------------------------------------------

IF @Kd_KIB = 'C' 
BEGIN
        SET @IDPemda = (
                        SELECT IDPemda FROM Ta_KIB_C
                        WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND 
                              Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND 
                              Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register 
                       )

        INSERT INTO @pindah
        SELECT A.IDPemda, A.Tgl_Perolehan, A.Kd_ID
        FROM
            (SELECT A.IDPemda, MIN(A.Tgl_Perolehan) AS Tgl_Perolehan, MIN(A.Kd_ID) AS Kd_ID
             FROM Ta_KIBCR A
             WHERE A.Kd_Riwayat = 3 AND YEAR(A.Tgl_Perolehan) <= @Tahun AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND 
                   A.Kd_Data <> 3 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)  
             GROUP BY A.IDPemda
            ) A
        GROUP BY A.IDPemda, A.Tgl_Perolehan, A.Kd_ID

        SET @Thn1 = NULL
	SET @Harga1 = NULL
	SET @Masa_Manfaat1 = NULL
        SET @Tgl1 = NULL
        SET @Kd_Riwayat1 = NULL
        SET @Riwayat = NULL
        SET @HP = 0
        SET @Akum = 0
        Set @Umur = 0
        SET @Umur_Pakai = 0
        SET @Hitung_Susut = 0       
        SET @Hitung_Umur = 0
        SET @No = 0
        SET @kawal = 0
        	
	DECLARE c2 CURSOR FOR

        SELECT LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6) AS Tahun, A.Harga, 
               CASE A.Kondisi WHEN 3 THEN 0 ELSE ISNULL(A.Masa_Manfaat, 0) /* 12*/ END AS Masa_Manfaat, 
               A.Tgl_Perolehan, 
               CASE A.Kondisi WHEN 3 THEN 1 ELSE 0 END AS Kd_Riwayat,
               CASE A.Masa_Manfaat WHEN NULL THEN 0 WHEN 0 THEN 0 ELSE 1 END AS Kawal
        FROM Ta_KIB_C A LEFT OUTER JOIN @pindah B ON A.IDPemda = B.IDPemda
        WHERE B.IDPemda IS NULL AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND YEAR(A.Tgl_Perolehan) <= @Tahun AND 
              A.Kd_Data <> 3 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND 
              A.IDPemda = @IDPemda
              
        UNION ALL

        SELECT LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6) AS Tahun, A.Harga, 
               CASE A.Kondisi WHEN 3 THEN 0 ELSE ISNULL(A.Masa_Manfaat, 0) /* 12*/ END AS Masa_Manfaat, 
               A.Tgl_Perolehan, 33,
               CASE A.Masa_Manfaat WHEN NULL THEN 0 WHEN 0 THEN 0 ELSE 1 END AS Kawal
        FROM Ta_KIBCR A INNER JOIN @pindah B ON A.IDPemda = B.IDPemda AND A.Tgl_Perolehan = B.Tgl_Perolehan AND A.Kd_ID = B.Kd_ID 
        WHERE A.IDPemda = @IDPemda

        UNION ALL

        SELECT LEFT(CONVERT(varchar, Tgl_Dokumen, 112), 6) AS Tahun, 
               CASE Kd_Riwayat WHEN 7 THEN -Harga WHEN 1 THEN 0 WHEN 3 THEN 0 WHEN 20 THEN 0 ELSE Harga END, 
               CASE Kd_Riwayat WHEN 2 THEN ISNULL(Masa_Manfaat, 0) ELSE 0 END /* 12*/, 
               Tgl_Dokumen, Kd_Riwayat, 0 AS Kawal
        FROM Ta_KIBCR
        WHERE IDPemda = @IDPemda AND LEFT(CONVERT(varchar, Tgl_Dokumen, 112), 6) <= CONVERT(Varchar,@Tahun)+ '12' AND
              Kd_Riwayat IN(1,2,7,21) AND Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END       

        UNION ALL

        SELECT LEFT(CONVERT(varchar, Tgl_SK, 112), 6) AS Tahun, 0 AS Harga, 0 AS Masa_Manfaat, Tgl_SK, 25 AS Kd_Riwayat, 0 AS Kawal 
	FROM Ta_KIBCHapus  
	WHERE IDPemda = @IDPemda AND LEFT(CONVERT(varchar, Tgl_SK, 112), 6) <= CONVERT(Varchar,@Tahun)+ '12' AND 
              Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END 

        UNION ALL

        SELECT CONVERT(Varchar,(@Tahun)) + '01', 0, 0, CONVERT(Varchar,(@Tahun-1)) + '1231', 34, 0
        
        UNION ALL

        SELECT CONVERT(Varchar,@Tahun) + '07', 0, 0, CONVERT(Varchar, @Tahun) + '0630', 35, 0

        UNION ALL

        SELECT CONVERT(Varchar, @Tahun+1) + '01', 0, 0, CONVERT(Varchar, @Tahun) + '1231', 36, 0
	
        ORDER BY Tahun
	
	OPEN c2
	
	FETCH NEXT FROM c2 INTO @Thn1, @Harga1, @Masa_Manfaat1, @Tgl1, @Kd_Riwayat1, @kawal1
	SET @SMM = @Masa_Manfaat1
        SET @Riwayat = @Kd_Riwayat1
        SET @NSisa = @Harga1
        SET @HP = @Harga1
        SET @Umur = @Masa_Manfaat1 
        SET @Tgl = @Tgl1
        SET @kawal = @kawal1
                        		
	FETCH NEXT FROM c2 INTO @Thn2, @Harga2, @Masa_Manfaat2, @Tgl2, @Kd_Riwayat2, @kawal2
	WHILE @@FETCH_STATUS = 0
	BEGIN

                IF @SMM > 0 
                BEGIN
                        SET @Hitung_Susut = ROUND((@NSisa / @SMM) * (DATEDIFF(mm, @Thn1 + '01', @Thn2 + '01')), 0)
                        SET @Hitung_Umur = (DATEDIFF(mm, @Thn1 + '01', @Thn2 + '01'))
                END
                ELSE
                BEGIN
                        SET @Hitung_Susut = 0
                        SET @Hitung_Umur = 0
                END

                IF (@Hitung_Umur < @SMM) AND (@SMM > 0) AND ((@NSisa - @Hitung_Susut + @Harga2) > 0)
		BEGIN
			SET @NSusut = @Hitung_Susut
                        SET @Umur_pakai = @Hitung_Umur
		END
		ELSE
		BEGIN
                        IF @SMM = 0 SET @NSusut = 0 ELSE
			SET @NSusut = ROUND((@NSisa / @SMM) * @SMM, 0)
                        SET @Umur_Pakai = @SMM
		END

                IF @NSisa - @Hitung_Susut + @Harga2 < 0 AND (@Hitung_Umur < @SMM)
                BEGIN  
                        SET @NSusut = @NSisa + @Harga2
                        SET @Umur_Pakai = @Hitung_Umur
                END

                IF @SMM = 0 AND @NSisa <> 0 AND @kawal = 1 --AND @Riwayat IN (2,7,21)
                BEGIN
                        SET @NSusut = @NSisa
                END

                IF (@Hitung_Umur < @SMM) AND (@SMM > 0) AND (@Kd_Riwayat2 NOT IN(1,25))
		BEGIN
                        SET @SMMA = @SMM - @Hitung_Umur
			SET @SMM = @SMM - @Hitung_Umur
                END
		ELSE
		BEGIN
                        IF (@Hitung_Umur > @SMM) AND (@Kd_Riwayat2 NOT IN(1,25)) SET @SMMA = 0
                        ELSE
                        SET @SMMA = @SMM - @Hitung_Umur 
                     	SET @SMM = 0                        
		END

                IF @Riwayat = 25 
                BEGIN   
                        SET @Kd_Riwayat2 = 25
                END
                ELSE
                BEGIN
                        IF @Riwayat = 1 SET @Kd_Riwayat2 = 1
                        ELSE
                        SET @Kd_Riwayat2 = @Kd_Riwayat2
                END

                SET @Akum = @Akum + @NSusut	
                SET @NSisa = @NSisa - @NSusut
                SET @No = @No + 1
                
                SET @Riwayat = @Kd_Riwayat2
                SET @HP = @Harga2
                SET @Umur = @Masa_Manfaat2
                SET @Tgl = @Tgl2
                		
		SET @NSisa = @NSisa + @Harga2
		SET @SMM = @SMM + @Masa_Manfaat2                            	
                SET @SMMA = @SMMA + @Masa_Manfaat2
                SET @kawal = @kawal + @kawal2

		SET @Thn1 = @Thn2
		SET @Harga1 = @Harga2
		SET @Masa_Manfaat1 = @Masa_Manfaat2
                SET @Tgl1 = @Tgl2
                SET @kawal1 = @kawal2

        INSERT INTO @tmp1
	SELECT @No, @Akum, @NSusut, @NSisa, @HP, @SMM, @SMMA, @Umur, @Umur_Pakai, @Tgl, @Riwayat

	FETCH NEXT FROM c2 INTO @Thn2, @Harga2, @Masa_Manfaat2, @Tgl2, @Kd_Riwayat2, @kawal2
		
        END
	CLOSE c2
	DEALLOCATE c2

SELECT B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Nm_Bidang, B.Nm_Unit, B.Nm_Sub_Unit, B.Nm_UPB, 
	CONVERT(varchar, B.Kd_Aset1) + '.' + CONVERT(varchar, B.Kd_Aset2) + '.' + CONVERT(varchar, B.Kd_Aset3) + '.' + CONVERT(varchar, B.Kd_Aset4) + '.' + CONVERT(varchar, B.Kd_Aset5)  AS Kd_Asetgab, 
	B.No_Register, B.Nm_Aset5,A.Bulan, A.Nilai_Perolehan,A.Nilai_dasar, A.Umur_Pakai, A.Umur, A.Susut, A.Akum, A.Nilai_Buku
FROM
	(
	SELECT A.Bulan, B.Nilai_Perolehan, B.Nilai_Dasar, B.Umur_Pakai, B.Umur, B.Susut, B.Akum, B.Nilai_Buku
	FROM
	    (
 	    SELECT (LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6)) AS bulan 
 	    FROM Ta_KIB_C A LEFT OUTER JOIN @pindah B ON A.IDPemda = B.IDPemda
 	    WHERE B.IDPemda IS NULL AND A.IDPemda = @IDPemda
  	   UNION ALL
  	   SELECT (LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6)) 
  	   FROM @pindah A 
  	   WHERE A.IDPemda = @IDPemda
  	  ) A, 
        (
         SELECT (Akum+Sisa-HP) AS Nilai_perolehan, 0 AS Nilai_Dasar, 0 AS Umur_Pakai, 0 AS Umur, 0 AS Susut, 0 AS Akum, 
                (Akum+Sisa-HP) AS Nilai_Buku   
         FROM @tmp1 
         WHERE No_urut = 1
        ) B
	UNION ALL

	SELECT (LEFT(CONVERT(varchar, Tgl, 112), 6)), (Akum+Sisa), Sisa+Susut-HP , Umur_Pakai, (Sisa_Umur_Asli+Umur_Pakai-Umur), Susut,
	       Akum, Sisa
	FROM @tmp1

	) A, 
	(SELECT A.KD_BIDANG, A.KD_UNIT, A.KD_SUB, A.KD_UPB, B.Nm_Bidang, C.NM_UNIT, D.Nm_Sub_Unit, E.NM_UPB,
		A.KD_ASET1, A.KD_ASET2, A.KD_ASET3, A.KD_ASET4, A.KD_ASET5, A.NO_REGISTER, F.NM_ASET5
	FROM TA_KIB_C A INNER JOIN
		REF_BIDANG B ON A.KD_BIDANG = B.KD_BIDANG INNER JOIN
		REF_UNIT C ON A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT INNER JOIN
		REF_SUB_UNIT D ON A.KD_BIDANG = D.KD_BIDANG AND A.KD_UNIT = D.KD_UNIT AND A.KD_SUB = D.KD_SUB INNER JOIN
		REF_UPB E ON A.KD_BIDANG = E.KD_BIDANG AND A.KD_UNIT = E.KD_UNIT AND A.KD_SUB = E.KD_SUB AND A.KD_UPB = E.KD_UPB INNER JOIN
 		REF_REK_ASET5 F ON A.KD_ASET1 = F.KD_ASET1 AND  A.KD_ASET2 = F.KD_ASET2 AND  A.KD_ASET3 = F.KD_ASET3 AND  A.KD_ASET4 = F.KD_ASET4 AND  A.KD_ASET5 = F.KD_ASET5 
	WHERE A.KD_BIDANG = @KD_BIDANG AND A.KD_UNIT = @KD_UNIT AND A.KD_SUB = @KD_SUB AND A.KD_UPB = @KD_UPB  
		AND A.KD_ASET1 = @KD_ASET1 AND A.KD_ASET2 = @KD_ASET2 AND A.KD_ASET3 = @KD_ASET3 AND A.KD_ASET4 = @KD_ASET4 AND A.KD_ASET5 = @KD_ASET5 AND A.NO_REGISTER = @NO_REGISTER
	) B

GROUP BY  B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Nm_Bidang, B.Nm_Unit, B.Nm_Sub_Unit, B.Nm_UPB, 
	B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.No_Register, B.Nm_Aset5,
	A.Bulan, A.Nilai_Perolehan, A.Nilai_dasar, A.Umur_Pakai, A.Umur, A.Susut, A.Akum, A.Nilai_Buku

END

----------------------------------------------------------

IF @Kd_KIB = 'D' 
BEGIN
        SET @IDPemda = (
                        SELECT IDPemda FROM Ta_KIB_D
                        WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND 
                              Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND 
                              Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register 
                       )

        INSERT INTO @pindah
        SELECT A.IDPemda, A.Tgl_Perolehan, A.Kd_ID
        FROM
            (SELECT A.IDPemda, MIN(A.Tgl_Perolehan) AS Tgl_Perolehan, MIN(A.Kd_ID) AS Kd_ID
             FROM Ta_KIBDR A
             WHERE A.Kd_Riwayat = 3 AND YEAR(A.Tgl_Perolehan) <= @Tahun AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND 
                   A.Kd_Data <> 3 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)  
             GROUP BY A.IDPemda
            ) A
        GROUP BY A.IDPemda, A.Tgl_Perolehan, A.Kd_ID

        SET @Thn1 = NULL
	SET @Harga1 = NULL
	SET @Masa_Manfaat1 = NULL
        SET @Tgl1 = NULL
        SET @Kd_Riwayat1 = NULL
        SET @Riwayat = NULL
        SET @HP = 0
        SET @Akum = 0
        Set @Umur = 0
        SET @Umur_Pakai = 0
        SET @Hitung_Susut = 0       
        SET @Hitung_Umur = 0
        SET @No = 0
        SET @kawal = 0
        	
	DECLARE c2 CURSOR FOR

        SELECT LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6) AS Tahun, A.Harga, 
               CASE A.Kondisi WHEN 3 THEN 0 ELSE ISNULL(A.Masa_Manfaat, 0) /* 12*/ END AS Masa_Manfaat, 
               A.Tgl_Perolehan, 
               CASE A.Kondisi WHEN 3 THEN 1 ELSE 0 END AS Kd_Riwayat,
               CASE A.Masa_Manfaat WHEN NULL THEN 0 WHEN 0 THEN 0 ELSE 1 END AS Kawal
        FROM Ta_KIB_D A LEFT OUTER JOIN @pindah B ON A.IDPemda = B.IDPemda
        WHERE B.IDPemda IS NULL AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND YEAR(A.Tgl_Perolehan) <= @Tahun AND 
              A.Kd_Data <> 3 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND 
              A.IDPemda = @IDPemda
              
        UNION ALL

        SELECT LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6) AS Tahun, A.Harga, 
               CASE A.Kondisi WHEN 3 THEN 0 ELSE ISNULL(A.Masa_Manfaat, 0) /* 12*/ END AS Masa_Manfaat, 
               A.Tgl_Perolehan, 33,
               CASE A.Masa_Manfaat WHEN NULL THEN 0 WHEN 0 THEN 0 ELSE 1 END AS Kawal
        FROM Ta_KIBDR A INNER JOIN @pindah B ON A.IDPemda = B.IDPemda AND A.Tgl_Perolehan = B.Tgl_Perolehan AND A.Kd_ID = B.Kd_ID 
        WHERE A.IDPemda = @IDPemda

        UNION ALL

        SELECT LEFT(CONVERT(varchar, Tgl_Dokumen, 112), 6) AS Tahun, 
               CASE Kd_Riwayat WHEN 7 THEN -Harga WHEN 1 THEN 0 WHEN 3 THEN 0 WHEN 20 THEN 0 ELSE Harga END, 
               CASE Kd_Riwayat WHEN 2 THEN ISNULL(Masa_Manfaat, 0) ELSE 0 END /* 12*/, 
               Tgl_Dokumen, Kd_Riwayat, 0 AS Kawal
        FROM Ta_KIBDR
        WHERE IDPemda = @IDPemda AND LEFT(CONVERT(varchar, Tgl_Dokumen, 112), 6) <= CONVERT(Varchar,@Tahun)+ '12' AND
              Kd_Riwayat IN(1,2,7,21) AND Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END       

        UNION ALL

        SELECT LEFT(CONVERT(varchar, Tgl_SK, 112), 6) AS Tahun, 0 AS Harga, 0 AS Masa_Manfaat, Tgl_SK, 25 AS Kd_Riwayat, 0 AS Kawal 
	FROM Ta_KIBDHapus  
	WHERE IDPemda = @IDPemda AND LEFT(CONVERT(varchar, Tgl_SK, 112), 6) <= CONVERT(Varchar,@Tahun)+ '12' AND 
              Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END 

        UNION ALL

        SELECT CONVERT(Varchar,(@Tahun)) + '01', 0, 0, CONVERT(Varchar,(@Tahun-1)) + '1231', 34, 0
        
        UNION ALL

        SELECT CONVERT(Varchar,@Tahun) + '07', 0, 0, CONVERT(Varchar, @Tahun) + '0630', 35, 0

        UNION ALL

        SELECT CONVERT(Varchar, @Tahun+1) + '01', 0, 0, CONVERT(Varchar, @Tahun) + '1231', 36, 0
	
        ORDER BY Tahun
	
	OPEN c2
	
	FETCH NEXT FROM c2 INTO @Thn1, @Harga1, @Masa_Manfaat1, @Tgl1, @Kd_Riwayat1, @kawal1
	SET @SMM = @Masa_Manfaat1
        SET @Riwayat = @Kd_Riwayat1
        SET @NSisa = @Harga1
        SET @HP = @Harga1
        SET @Umur = @Masa_Manfaat1 
        SET @Tgl = @Tgl1
        SET @kawal = @kawal1
                        		
	FETCH NEXT FROM c2 INTO @Thn2, @Harga2, @Masa_Manfaat2, @Tgl2, @Kd_Riwayat2, @kawal2
	WHILE @@FETCH_STATUS = 0
	BEGIN

                IF @SMM > 0 
                BEGIN
                        SET @Hitung_Susut = ROUND((@NSisa / @SMM) * (DATEDIFF(mm, @Thn1 + '01', @Thn2 + '01')), 0)
                        SET @Hitung_Umur = (DATEDIFF(mm, @Thn1 + '01', @Thn2 + '01'))
                END
                ELSE
                BEGIN
                        SET @Hitung_Susut = 0
                        SET @Hitung_Umur = 0
                END

                IF (@Hitung_Umur < @SMM) AND (@SMM > 0) AND ((@NSisa - @Hitung_Susut + @Harga2) > 0)
		BEGIN
			SET @NSusut = @Hitung_Susut
                        SET @Umur_pakai = @Hitung_Umur
		END
		ELSE
		BEGIN
                        IF @SMM = 0 SET @NSusut = 0 ELSE
			SET @NSusut = ROUND((@NSisa / @SMM) * @SMM, 0)
                        SET @Umur_Pakai = @SMM
		END

                IF @NSisa - @Hitung_Susut + @Harga2 < 0 AND (@Hitung_Umur < @SMM)
                BEGIN  
                        SET @NSusut = @NSisa + @Harga2
                        SET @Umur_Pakai = @Hitung_Umur
                END

                IF @SMM = 0 AND @NSisa <> 0 AND @kawal = 1 --AND @Riwayat IN (2,7,21)
                BEGIN
                        SET @NSusut = @NSisa
                END

                IF (@Hitung_Umur < @SMM) AND (@SMM > 0) AND (@Kd_Riwayat2 NOT IN(1,25))
		BEGIN
                        SET @SMMA = @SMM - @Hitung_Umur
			SET @SMM = @SMM - @Hitung_Umur
                END
		ELSE
		BEGIN
                        IF (@Hitung_Umur > @SMM) AND (@Kd_Riwayat2 NOT IN(1,25)) SET @SMMA = 0
                        ELSE
                        SET @SMMA = @SMM - @Hitung_Umur 
                     	SET @SMM = 0                        
		END

                IF @Riwayat = 25 
                BEGIN   
                        SET @Kd_Riwayat2 = 25
                END
                ELSE
                BEGIN
                        IF @Riwayat = 1 SET @Kd_Riwayat2 = 1
                        ELSE
                        SET @Kd_Riwayat2 = @Kd_Riwayat2
                END

                SET @Akum = @Akum + @NSusut	
                SET @NSisa = @NSisa - @NSusut
                SET @No = @No + 1
                
                SET @Riwayat = @Kd_Riwayat2
                SET @HP = @Harga2
                SET @Umur = @Masa_Manfaat2
                SET @Tgl = @Tgl2
                		
		SET @NSisa = @NSisa + @Harga2
		SET @SMM = @SMM + @Masa_Manfaat2                            	
                SET @SMMA = @SMMA + @Masa_Manfaat2
                SET @kawal = @kawal + @kawal2

		SET @Thn1 = @Thn2
		SET @Harga1 = @Harga2
		SET @Masa_Manfaat1 = @Masa_Manfaat2
                SET @Tgl1 = @Tgl2
                SET @kawal1 = @kawal2

        INSERT INTO @tmp1
	SELECT @No, @Akum, @NSusut, @NSisa, @HP, @SMM, @SMMA, @Umur, @Umur_Pakai, @Tgl, @Riwayat

	FETCH NEXT FROM c2 INTO @Thn2, @Harga2, @Masa_Manfaat2, @Tgl2, @Kd_Riwayat2, @kawal2
		
        END
	CLOSE c2
	DEALLOCATE c2


SELECT B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Nm_Bidang, B.Nm_Unit, B.Nm_Sub_Unit, B.Nm_UPB, 
	CONVERT(varchar, B.Kd_Aset1) + '.' + CONVERT(varchar, B.Kd_Aset2) + '.' + CONVERT(varchar, B.Kd_Aset3) + '.' + CONVERT(varchar, B.Kd_Aset4) + '.' + CONVERT(varchar, B.Kd_Aset5)  AS Kd_Asetgab, 
	B.No_Register, B.Nm_Aset5,A.Bulan,  A.Nilai_Perolehan, A.Nilai_dasar, A.Umur_Pakai, A.Umur, A.Susut, A.Akum, A.Nilai_Buku
FROM
	(
	SELECT A.Bulan, B.Nilai_Perolehan, B.Nilai_Dasar, B.Umur_Pakai, B.Umur, B.Susut, B.Akum, B.Nilai_Buku
	FROM
	    (
 	    SELECT (LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6)) AS bulan 
 	    FROM Ta_KIB_D A LEFT OUTER JOIN @pindah B ON A.IDPemda = B.IDPemda
 	    WHERE B.IDPemda IS NULL AND A.IDPemda = @IDPemda
  	   UNION ALL
  	   SELECT (LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6)) 
  	   FROM @pindah A 
  	   WHERE A.IDPemda = @IDPemda
  	  ) A, 
        (
         SELECT (Akum+Sisa-HP) AS Nilai_perolehan, 0 AS Nilai_Dasar, 0 AS Umur_Pakai, 0 AS Umur, 0 AS Susut, 0 AS Akum, 
                (Akum+Sisa-HP) AS Nilai_Buku   
         FROM @tmp1 
         WHERE No_urut = 1
        ) B
	UNION ALL

	SELECT (LEFT(CONVERT(varchar, Tgl, 112), 6)), (Akum+Sisa), Sisa+Susut-HP , Umur_Pakai, (Sisa_Umur_Asli+Umur_Pakai-Umur), Susut,
	       Akum, Sisa
	FROM @tmp1

	) A, 
	(SELECT A.KD_BIDANG, A.KD_UNIT, A.KD_SUB, A.KD_UPB, B.Nm_Bidang, C.NM_UNIT, D.Nm_Sub_Unit, E.NM_UPB,
		A.KD_ASET1, A.KD_ASET2, A.KD_ASET3, A.KD_ASET4, A.KD_ASET5, A.NO_REGISTER, F.NM_ASET5
	FROM TA_KIB_D A INNER JOIN
		REF_BIDANG B ON A.KD_BIDANG = B.KD_BIDANG INNER JOIN
		REF_UNIT C ON A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT INNER JOIN
		REF_SUB_UNIT D ON A.KD_BIDANG = D.KD_BIDANG AND A.KD_UNIT = D.KD_UNIT AND A.KD_SUB = D.KD_SUB INNER JOIN
		REF_UPB E ON A.KD_BIDANG = E.KD_BIDANG AND A.KD_UNIT = E.KD_UNIT AND A.KD_SUB = E.KD_SUB AND A.KD_UPB = E.KD_UPB INNER JOIN
 		REF_REK_ASET5 F ON A.KD_ASET1 = F.KD_ASET1 AND  A.KD_ASET2 = F.KD_ASET2 AND  A.KD_ASET3 = F.KD_ASET3 AND  A.KD_ASET4 = F.KD_ASET4 AND  A.KD_ASET5 = F.KD_ASET5 
	WHERE A.KD_BIDANG = @KD_BIDANG AND A.KD_UNIT = @KD_UNIT AND A.KD_SUB = @KD_SUB AND A.KD_UPB = @KD_UPB  
		AND A.KD_ASET1 = @KD_ASET1 AND A.KD_ASET2 = @KD_ASET2 AND A.KD_ASET3 = @KD_ASET3 AND A.KD_ASET4 = @KD_ASET4 AND A.KD_ASET5 = @KD_ASET5 AND A.NO_REGISTER = @NO_REGISTER
	) B

GROUP BY  B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Nm_Bidang, B.Nm_Unit, B.Nm_Sub_Unit, B.Nm_UPB, 
	B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.No_Register, B.Nm_Aset5,
	A.Bulan, A.Nilai_dasar, A.Nilai_Perolehan, A.Umur_Pakai, A.Umur, A.Susut, A.Akum, A.Nilai_Buku

END


--------------------------------------------------------------

IF @Kd_KIB = 'E' 
BEGIN
        SET @IDPemda = (
                        SELECT IDPemda FROM Ta_KIB_E
                        WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND 
                              Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND 
                              Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register 
                       )

        INSERT INTO @pindah
        SELECT A.IDPemda, A.Tgl_Perolehan, A.Kd_ID
        FROM
            (SELECT A.IDPemda, MIN(A.Tgl_Perolehan) AS Tgl_Perolehan, MIN(A.Kd_ID) AS Kd_ID
             FROM Ta_KIBER A
             WHERE A.Kd_Riwayat = 3 AND YEAR(A.Tgl_Perolehan) <= @Tahun AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND 
                   A.Kd_Data <> 3 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)  
             GROUP BY A.IDPemda
            ) A
        GROUP BY A.IDPemda, A.Tgl_Perolehan, A.Kd_ID

        SET @Thn1 = NULL
	SET @Harga1 = NULL
	SET @Masa_Manfaat1 = NULL
        SET @Tgl1 = NULL
        SET @Kd_Riwayat1 = NULL
        SET @Riwayat = NULL
        SET @HP = 0
        SET @Akum = 0
        Set @Umur = 0
        SET @Umur_Pakai = 0
        SET @Hitung_Susut = 0       
        SET @Hitung_Umur = 0
        SET @No = 0
        SET @kawal = 0
        	
	DECLARE c2 CURSOR FOR

        SELECT LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6) AS Tahun, A.Harga, 
               CASE A.Kondisi WHEN 3 THEN 0 ELSE ISNULL(A.Masa_Manfaat, 0) /* 12*/ END AS Masa_Manfaat, 
               A.Tgl_Perolehan, 
               CASE A.Kondisi WHEN 3 THEN 1 ELSE 0 END AS Kd_Riwayat,
               CASE A.Masa_Manfaat WHEN NULL THEN 0 WHEN 0 THEN 0 ELSE 1 END AS Kawal
        FROM Ta_KIB_E A LEFT OUTER JOIN @pindah B ON A.IDPemda = B.IDPemda
        WHERE B.IDPemda IS NULL AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND YEAR(A.Tgl_Perolehan) <= @Tahun AND 
              A.Kd_Data <> 3 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND 
              A.IDPemda = @IDPemda
              
        UNION ALL

        SELECT LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6) AS Tahun, A.Harga, 
               CASE A.Kondisi WHEN 3 THEN 0 ELSE ISNULL(A.Masa_Manfaat, 0) /* 12*/ END AS Masa_Manfaat, 
               A.Tgl_Perolehan, 33,
               CASE A.Masa_Manfaat WHEN NULL THEN 0 WHEN 0 THEN 0 ELSE 1 END AS Kawal
        FROM Ta_KIBER A INNER JOIN @pindah B ON A.IDPemda = B.IDPemda AND A.Tgl_Perolehan = B.Tgl_Perolehan AND A.Kd_ID = B.Kd_ID 
        WHERE A.IDPemda = @IDPemda

        UNION ALL

        SELECT LEFT(CONVERT(varchar, Tgl_Dokumen, 112), 6) AS Tahun, 
               CASE Kd_Riwayat WHEN 7 THEN -Harga WHEN 1 THEN 0 WHEN 3 THEN 0 WHEN 20 THEN 0 ELSE Harga END, 
               CASE Kd_Riwayat WHEN 2 THEN ISNULL(Masa_Manfaat, 0) ELSE 0 END /* 12*/, 
               Tgl_Dokumen, Kd_Riwayat, 0 AS Kawal
        FROM Ta_KIBER
        WHERE IDPemda = @IDPemda AND LEFT(CONVERT(varchar, Tgl_Dokumen, 112), 6) <= CONVERT(Varchar,@Tahun)+ '12' AND
              Kd_Riwayat IN(1,2,7,21) AND Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END       

        UNION ALL

        SELECT LEFT(CONVERT(varchar, Tgl_SK, 112), 6) AS Tahun, 0 AS Harga, 0 AS Masa_Manfaat, Tgl_SK, 25 AS Kd_Riwayat, 0 AS Kawal 
	FROM Ta_KIBEHapus  
	WHERE IDPemda = @IDPemda AND LEFT(CONVERT(varchar, Tgl_SK, 112), 6) <= CONVERT(Varchar,@Tahun)+ '12' AND 
              Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END 

        UNION ALL

        SELECT CONVERT(Varchar,(@Tahun)) + '01', 0, 0, CONVERT(Varchar,(@Tahun-1)) + '1231', 34, 0
        
        UNION ALL

        SELECT CONVERT(Varchar,@Tahun) + '07', 0, 0, CONVERT(Varchar, @Tahun) + '0630', 35, 0

        UNION ALL

        SELECT CONVERT(Varchar, @Tahun+1) + '01', 0, 0, CONVERT(Varchar, @Tahun) + '1231', 36, 0
	
        ORDER BY Tahun
	
	OPEN c2
	
	FETCH NEXT FROM c2 INTO @Thn1, @Harga1, @Masa_Manfaat1, @Tgl1, @Kd_Riwayat1, @kawal1
	SET @SMM = @Masa_Manfaat1
        SET @Riwayat = @Kd_Riwayat1
        SET @NSisa = @Harga1
        SET @HP = @Harga1
        SET @Umur = @Masa_Manfaat1 
        SET @Tgl = @Tgl1
        SET @kawal = @kawal1
                        		
	FETCH NEXT FROM c2 INTO @Thn2, @Harga2, @Masa_Manfaat2, @Tgl2, @Kd_Riwayat2, @kawal2
	WHILE @@FETCH_STATUS = 0
	BEGIN

                IF @SMM > 0 
                BEGIN
                        SET @Hitung_Susut = ROUND((@NSisa / @SMM) * (DATEDIFF(mm, @Thn1 + '01', @Thn2 + '01')), 0)
                        SET @Hitung_Umur = (DATEDIFF(mm, @Thn1 + '01', @Thn2 + '01'))
                END
                ELSE
                BEGIN
                        SET @Hitung_Susut = 0
                        SET @Hitung_Umur = 0
                END

                IF (@Hitung_Umur < @SMM) AND (@SMM > 0) AND ((@NSisa - @Hitung_Susut + @Harga2) > 0)
		BEGIN
			SET @NSusut = @Hitung_Susut
                        SET @Umur_pakai = @Hitung_Umur
		END
		ELSE
		BEGIN
                        IF @SMM = 0 SET @NSusut = 0 ELSE
			SET @NSusut = ROUND((@NSisa / @SMM) * @SMM, 0)
                        SET @Umur_Pakai = @SMM
		END

                IF @NSisa - @Hitung_Susut + @Harga2 < 0 AND (@Hitung_Umur < @SMM)
                BEGIN  
                        SET @NSusut = @NSisa + @Harga2
                        SET @Umur_Pakai = @Hitung_Umur
                END

                IF @SMM = 0 AND @NSisa <> 0 AND @kawal = 1 --AND @Riwayat IN (2,7,21)
                BEGIN
                        SET @NSusut = @NSisa
                END

                IF (@Hitung_Umur < @SMM) AND (@SMM > 0) AND (@Kd_Riwayat2 NOT IN(1,25))
		BEGIN
                        SET @SMMA = @SMM - @Hitung_Umur
			SET @SMM = @SMM - @Hitung_Umur
                END
		ELSE
		BEGIN
                        IF (@Hitung_Umur > @SMM) AND (@Kd_Riwayat2 NOT IN(1,25)) SET @SMMA = 0
                        ELSE
                        SET @SMMA = @SMM - @Hitung_Umur 
                     	SET @SMM = 0                        
		END

                IF @Riwayat = 25 
                BEGIN   
                        SET @Kd_Riwayat2 = 25
                END
                ELSE
                BEGIN
                        IF @Riwayat = 1 SET @Kd_Riwayat2 = 1
                        ELSE
                        SET @Kd_Riwayat2 = @Kd_Riwayat2
                END

                SET @Akum = @Akum + @NSusut	
                SET @NSisa = @NSisa - @NSusut
                SET @No = @No + 1
                
                SET @Riwayat = @Kd_Riwayat2
                SET @HP = @Harga2
                SET @Umur = @Masa_Manfaat2
                SET @Tgl = @Tgl2
                		
		SET @NSisa = @NSisa + @Harga2
		SET @SMM = @SMM + @Masa_Manfaat2                            	
                SET @SMMA = @SMMA + @Masa_Manfaat2
                SET @kawal = @kawal + @kawal2

		SET @Thn1 = @Thn2
		SET @Harga1 = @Harga2
		SET @Masa_Manfaat1 = @Masa_Manfaat2
                SET @Tgl1 = @Tgl2
                SET @kawal1 = @kawal2

        INSERT INTO @tmp1
	SELECT @No, @Akum, @NSusut, @NSisa, @HP, @SMM, @SMMA, @Umur, @Umur_Pakai, @Tgl, @Riwayat

	FETCH NEXT FROM c2 INTO @Thn2, @Harga2, @Masa_Manfaat2, @Tgl2, @Kd_Riwayat2, @kawal2
		
        END
	CLOSE c2
	DEALLOCATE c2


SELECT B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Nm_Bidang, B.Nm_Unit, B.Nm_Sub_Unit, B.Nm_UPB, 
	CONVERT(varchar, B.Kd_Aset1) + '.' + CONVERT(varchar, B.Kd_Aset2) + '.' + CONVERT(varchar, B.Kd_Aset3) + '.' + CONVERT(varchar, B.Kd_Aset4) + '.' + CONVERT(varchar, B.Kd_Aset5)  AS Kd_Asetgab, 
	B.No_Register, B.Nm_Aset5,A.Bulan,  A.Nilai_Perolehan, A.Nilai_dasar, A.Umur_Pakai, A.Umur, A.Susut, A.Akum, A.Nilai_Buku
FROM
	(
	SELECT A.Bulan, B.Nilai_Perolehan, B.Nilai_Dasar, B.Umur_Pakai, B.Umur, B.Susut, B.Akum, B.Nilai_Buku
	FROM
	    (
 	    SELECT (LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6)) AS bulan 
 	    FROM Ta_KIB_E A LEFT OUTER JOIN @pindah B ON A.IDPemda = B.IDPemda
 	    WHERE B.IDPemda IS NULL AND A.IDPemda = @IDPemda
  	   UNION ALL
  	   SELECT (LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6)) 
  	   FROM @pindah A 
  	   WHERE A.IDPemda = @IDPemda
  	  ) A, 
        (
         SELECT (Akum+Sisa-HP) AS Nilai_perolehan, 0 AS Nilai_Dasar, 0 AS Umur_Pakai, 0 AS Umur, 0 AS Susut, 0 AS Akum, 
                (Akum+Sisa-HP) AS Nilai_Buku   
         FROM @tmp1 
         WHERE No_urut = 1
        ) B
	UNION ALL

	SELECT (LEFT(CONVERT(varchar, Tgl, 112), 6)), (Akum+Sisa), Sisa+Susut-HP , Umur_Pakai, (Sisa_Umur_Asli+Umur_Pakai-Umur), Susut,
	       Akum, Sisa
	FROM @tmp1

	) A, 
	(SELECT A.KD_BIDANG, A.KD_UNIT, A.KD_SUB, A.KD_UPB, B.Nm_Bidang, C.NM_UNIT, D.Nm_Sub_Unit, E.NM_UPB,
		A.KD_ASET1, A.KD_ASET2, A.KD_ASET3, A.KD_ASET4, A.KD_ASET5, A.NO_REGISTER, F.NM_ASET5
	FROM TA_KIB_E A INNER JOIN
		REF_BIDANG B ON A.KD_BIDANG = B.KD_BIDANG INNER JOIN
		REF_UNIT C ON A.KD_BIDANG = C.KD_BIDANG AND A.KD_UNIT = C.KD_UNIT INNER JOIN
		REF_SUB_UNIT D ON A.KD_BIDANG = D.KD_BIDANG AND A.KD_UNIT = D.KD_UNIT AND A.KD_SUB = D.KD_SUB INNER JOIN
		REF_UPB E ON A.KD_BIDANG = E.KD_BIDANG AND A.KD_UNIT = E.KD_UNIT AND A.KD_SUB = E.KD_SUB AND A.KD_UPB = E.KD_UPB INNER JOIN
 		REF_REK_ASET5 F ON A.KD_ASET1 = F.KD_ASET1 AND  A.KD_ASET2 = F.KD_ASET2 AND  A.KD_ASET3 = F.KD_ASET3 AND  A.KD_ASET4 = F.KD_ASET4 AND  A.KD_ASET5 = F.KD_ASET5 
	WHERE A.KD_BIDANG = @KD_BIDANG AND A.KD_UNIT = @KD_UNIT AND A.KD_SUB = @KD_SUB AND A.KD_UPB = @KD_UPB  
		AND A.KD_ASET1 = @KD_ASET1 AND A.KD_ASET2 = @KD_ASET2 AND A.KD_ASET3 = @KD_ASET3 AND A.KD_ASET4 = @KD_ASET4 AND A.KD_ASET5 = @KD_ASET5 AND A.NO_REGISTER = @NO_REGISTER
	) B

GROUP BY  B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Nm_Bidang, B.Nm_Unit, B.Nm_Sub_Unit, B.Nm_UPB, 
	B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.No_Register, B.Nm_Aset5,
	A.Bulan, A.Nilai_dasar, A.Nilai_Perolehan, A.Umur_Pakai, A.Umur, A.Susut, A.Akum, A.Nilai_Buku

END



GO
