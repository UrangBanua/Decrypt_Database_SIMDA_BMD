USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Hitung_Umur_D - 31082019 - Modified for Ver 2.0.7.11 [demi@simda.id] ***/
CREATE PROCEDURE SP_Hitung_Umur_D @Kd_Pemilik Varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
                 @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4), @Tanggal datetime, @Nilai money,
                 @TipeA Tinyint, @TipeB Tinyint, @TipeC Tinyint
WITH ENCRYPTION
AS

/*
DECLARE @Kd_Pemilik Varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4), @Tanggal datetime, @Nilai money, 
	@TipeA Tinyint, @TipeB Tinyint, @TipeC Tinyint

SET @Kd_Pemilik	= '12'
SET @Kd_Prov	= '30'
SET @Kd_Kab_Kota= '2'
SET @Kd_Bidang	= '5'
SET @Kd_Unit	= '1'
SET @Kd_Sub	= '1'
SET @Kd_UPB	= '1'
SET @Kd_Aset 	= '3'
SET @Kd_Aset0	= '3'
SET @Kd_Aset1	= '4'
SET @Kd_Aset2	= '13'
SET @Kd_Aset3	= '1'
SET @Kd_Aset4	= '3'
SET @Kd_Aset5	= '5'
SET @No_Register = '2'
SET @Tanggal = '20180705'
SET @Nilai = 1000000000
SET @TipeA = 1 
SET @TipeB = 1
SET @TipeC = 1 
*/

DECLARE @tmp1 TABLE(No_urut smallint, Akum money, Susut money, Sisa money, HP money, Sisa_Umur smallint, Sisa_Umur_Asli smallint, 
                    Umur smallint, Umur_Pakai smallint, Tgl datetime, Riwayat smallint)
DECLARE @pindah TABLE(IDPemda varchar(17),Tgl_Perolehan datetime, Kd_ID Int)
DECLARE @Tahun1 varchar(6), @Thn1 varchar(6), @Harga1 money, @Masa_Manfaat1 smallint, @Tgl1 datetime, @Kd_Riwayat1 smallint,
        @Tahun2 varchar(6), @Thn2 varchar(6), @Harga2 money, @Masa_Manfaat2 smallint, @Tgl2 datetime, @Kd_Riwayat2 smallint,
        @SMM smallint, @NSusut money, @NSisa money, @Akum money, @HP money, @Umur smallint, @Umur_Pakai smallint, @Tgl datetime,
        @Hitung_Susut money, @Hitung_Umur smallint, @SMMA smallint, @Riwayat smallint, @No smallint, @IDPemda Varchar(17), @TypeBV Tinyint

        SET @IDPemda = (
                        SELECT IDPemda FROM Ta_KIB_D
                        WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND 
                              Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND Kd_Aset8 LIKE @Kd_Aset AND Kd_Aset80 LIKE @Kd_Aset0 AND Kd_Aset81 LIKE @Kd_Aset1 AND Kd_Aset82 LIKE @Kd_Aset2 AND 
                              Kd_Aset83 LIKE @Kd_Aset3 AND Kd_Aset84 LIKE @Kd_Aset4 AND Kd_Aset85 LIKE @Kd_Aset5 AND No_Reg8 LIKE @No_Register 
                       )

        INSERT INTO @pindah
        SELECT A.IDPemda, A.Tgl_Perolehan, A.Kd_ID
        FROM
            (SELECT A.IDPemda, MIN(A.Tgl_Perolehan) AS Tgl_Perolehan, MIN(A.Kd_ID) AS Kd_ID
             FROM Ta_KIBDR A
             WHERE A.Kd_Riwayat = 3 AND 
--merubah @tahun menjadi @Tanggal
                   A.Tgl_Perolehan <= @Tanggal 
                   AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND 
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
        	
	DECLARE c2 CURSOR FOR

        SELECT LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6) AS Tahun, A.Harga, 
               CASE A.Kondisi WHEN 3 THEN 0 ELSE ISNULL(A.Masa_Manfaat, 0) END AS Masa_Manfaat, 
               A.Tgl_Perolehan, 
               CASE A.Kondisi WHEN 3 THEN 1 ELSE 0 END AS Kd_Riwayat
        FROM Ta_KIB_D A LEFT OUTER JOIN @pindah B ON A.IDPemda = B.IDPemda
        WHERE B.IDPemda IS NULL AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND 
--merubah @Tahun menjadi @Tanggal 
              A.Tgl_Perolehan <= @Tanggal 
              AND A.Kd_Data <> 3 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND 
              A.IDPemda = @IDPemda
              
        UNION ALL

        SELECT LEFT(CONVERT(varchar, A.Tgl_Perolehan, 112), 6) AS Tahun, A.Harga, 
               CASE A.Kondisi WHEN 3 THEN 0 ELSE ISNULL(A.Masa_Manfaat, 0) END AS Masa_Manfaat, 
               A.Tgl_Perolehan, 33 
        FROM Ta_KIBDR A INNER JOIN @pindah B ON A.IDPemda = B.IDPemda AND A.Tgl_Perolehan = B.Tgl_Perolehan AND A.Kd_ID = B.Kd_ID 
        WHERE A.IDPemda = @IDPemda 

        UNION ALL

        SELECT LEFT(CONVERT(varchar, Tgl_Dokumen, 112), 6) AS Tahun, 
               CASE Kd_Riwayat WHEN 7 THEN -Harga WHEN 1 THEN 0 WHEN 3 THEN 0 WHEN 20 THEN 0 ELSE Harga END, 
               CASE Kd_Riwayat WHEN 2 THEN ISNULL(Masa_Manfaat, 0) ELSE 0 END, 
               Tgl_Dokumen, Kd_Riwayat
        FROM Ta_KIBDR
        WHERE IDPemda = @IDPemda AND 
--merubah @Tahun menjadi @Tanggal 
              Tgl_Dokumen <= @Tanggal 
              AND Kd_Riwayat IN(1,2,7,21) AND Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END       

        UNION ALL

        SELECT LEFT(CONVERT(varchar, Tgl_SK, 112), 6) AS Tahun, 0 AS Harga, 0 AS Masa_Manfaat, Tgl_SK, 25 AS Kd_Riwayat 
	FROM Ta_KIBDHapus  
	WHERE IDPemda = @IDPemda AND 
--merubah @Tahun menjadi @Bulan
              Tgl_SK <= @Tanggal 
              AND Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END 

        UNION ALL

        SELECT LEFT(CONVERT(varchar, @Tanggal, 112), 6) AS Tahun, 0, 0, @Tanggal, 37

        ORDER BY Tahun
	
	OPEN c2
	
	FETCH NEXT FROM c2 INTO @Thn1, @Harga1, @Masa_Manfaat1, @Tgl1, @Kd_Riwayat1
	SET @SMM = @Masa_Manfaat1
        SET @Riwayat = @Kd_Riwayat1
        SET @NSisa = @Harga1
        SET @HP = @Harga1
        SET @Umur = @Masa_Manfaat1 
        SET @Tgl = @Tgl1
                        		
	FETCH NEXT FROM c2 INTO @Thn2, @Harga2, @Masa_Manfaat2, @Tgl2, @Kd_Riwayat2
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

----->>>cek lagi dng case 16, 17

                IF @NSisa - @Hitung_Susut + @Harga2 < 0 AND (@Hitung_Umur < @SMM)
                BEGIN  
                        SET @NSusut = @NSisa + @Harga2
                        SET @Umur_Pakai = @Hitung_Umur
                END
---->>>Test
---->>> Terkait script di 'test' cek lagi klu ada penghapusan dan ubah kondisi klu msh ada  
                IF @SMM = 0 AND @NSisa <> 0 AND (@Riwayat NOT IN(1,25))
                BEGIN
                        SET @NSusut = @NSisa
                END

---->>>Test
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
---->test2 utk menentukan klu @Kd_Riwayat2 IN(1,25) maka seterusnya @Riwayatnya IN(1,25)  
--                SET @Riwayat = @Kd_Riwayat2

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
----->test2
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

		SET @Thn1 = @Thn2
		SET @Harga1 = @Harga2
		SET @Masa_Manfaat1 = @Masa_Manfaat2
                SET @Tgl1 = @Tgl2

        INSERT INTO @tmp1
	SELECT @No, @Akum, @NSusut, @NSisa, @HP, @SMM, @SMMA, @Umur, @Umur_Pakai, @Tgl, @Riwayat

	FETCH NEXT FROM c2 INTO @Thn2, @Harga2, @Masa_Manfaat2, @Tgl2, @Kd_Riwayat2
		
        END
	CLOSE c2
	DEALLOCATE c2

	SET @TypeBV = (SELECT COUNT(Tgl) 
               FROM
                   (
                    SELECT Tgl, Umur, Riwayat 
                    FROM @tmp1 
                    WHERE YEAR(Tgl) = YEAR(@Tanggal) AND Umur > 0 AND Riwayat <> 37
                    UNION ALL
                    SELECT A.Tgl_Perolehan, A.Masa_Manfaat AS Umur, A.Riwayat
                    FROM  
                        (
                         SELECT A.Tgl_Perolehan, A.Masa_Manfaat, 0 AS Riwayat 
                         FROM Ta_KIB_D A LEFT OUTER JOIN @pindah B ON A.IDPemda = B.IDPemda
                         WHERE B.IDPemda IS NULL AND A.IDPemda = @IDPemda
                         UNION ALL
                         SELECT A.Tgl_Perolehan, A.Masa_Manfaat, 0  
                         FROM Ta_KIBDR A INNER JOIN @pindah B ON A.IDPemda = B.IDPemda AND A.Kd_ID = B.Kd_ID
                         WHERE A.IDPemda = @IDPemda
                        ) A
                    WHERE YEAR(A.Tgl_Perolehan) = YEAR(@Tanggal) AND A.Masa_Manfaat > 0 AND Riwayat <> 37 
                   ) A
              ) 



                     
SELECT A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Tgl, A.Nilai_Perolehan, A.Nilai_Perolehan_Akhir, A.Nilai_Buku, A.Sisa_umur, A.Rasio, A.Masa_Manfaat_Awal,
	CASE WHEN A.Masa_Manfaat_Rill < 0 THEN 0
		 WHEN A.Masa_Manfaat_Rill > 0 AND A.Masa_Manfaat_Rill = A.Masa_Manfaat_Tambahan THEN A.Masa_Manfaat_Rill
	     WHEN A.Masa_Manfaat_Rill > 0 AND A.Masa_Manfaat_Rill < A.Masa_Manfaat_Tambahan THEN A.Masa_Manfaat_Rill
         WHEN A.Masa_Manfaat_Rill > 0 AND A.Masa_Manfaat_Rill > A.Masa_Manfaat_Tambahan THEN A.Masa_Manfaat_Tambahan
	     ELSE 0 END AS Masa_Manfaat_Tambahan
FROM (
SELECT A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Tgl, A.Nilai_Perolehan, A.Nilai_Perolehan_Akhir, A.Nilai_Buku, A.Sisa_umur, A.Masa_Manfaat_Awal, 
       A.Rasio, B.Masa_Manfaat_Tambahan,
       CASE WHEN (@TipeB = 1 OR (@TipeB = 2 AND @TypeBV = 0)) AND @TipeC = 1 AND A.Sisa_umur+B.Masa_Manfaat_Tambahan > A.Masa_Manfaat_Awal THEN A.Masa_Manfaat_Awal- A.Sisa_Umur
            WHEN (@TipeB = 1 OR (@TipeB = 2 AND @TypeBV = 0)) AND @TipeC = 2 AND A.Sisa_umur+B.Masa_Manfaat_Tambahan > A.Masa_Manfaat_Awal THEN B.Masa_Manfaat_Tambahan
            WHEN (@TipeB = 1 OR (@TipeB = 2 AND @TypeBV = 0)) AND @TipeC = 1 AND A.Sisa_umur+B.Masa_Manfaat_Tambahan <= A.Masa_Manfaat_Awal THEN B.Masa_Manfaat_Tambahan
            ELSE 0 END AS Masa_Manfaat_Rill          
FROM
     (
      SELECT @Kd_Aset AS Kd_Aset8, @Kd_Aset0 AS Kd_Aset80, @Kd_Aset1 AS Kd_Aset81, @Kd_Aset2 AS Kd_Aset82, @Kd_Aset3 AS Kd_Aset83, A.Tgl, B.Harga AS Nilai_Perolehan, (A.Akum + A.Sisa) AS Nilai_Perolehan_Akhir, 
             A.Sisa AS Nilai_Buku, A.Sisa_umur, B.Masa_Manfaat AS Masa_Manfaat_Awal, 
             CASE WHEN @TipeA = 1 AND (A.Akum + A.Sisa) > 0 THEN @Nilai/(A.Akum + A.Sisa)*100 
                  WHEN @TipeA = 2 AND B.Harga > 0 THEN @Nilai/B.Harga*100
                  WHEN @TipeA = 3 AND A.Sisa > 0 THEN @Nilai/A.Sisa*100
                  ELSE 0
                  END AS Rasio
      FROM
           (
            SELECT Tgl, Akum, Sisa, Sisa_Umur
            FROM @tmp1 
            WHERE Tgl = @Tanggal
           ) A,
              (
               SELECT A.Harga, A.Masa_Manfaat AS Masa_Manfaat
               FROM Ta_KIB_D A LEFT OUTER JOIN @pindah B ON A.IDPemda = B.IDPemda
               WHERE B.IDPemda IS NULL AND A.IDPemda = @IDPemda
               UNION ALL
               SELECT A.Harga, A.Masa_Manfaat
               FROM Ta_KIBDR A INNER JOIN @pindah B ON A.IDPemda = B.IDPemda AND A.Tgl_Perolehan = B.Tgl_Perolehan AND A.Kd_ID = B.Kd_ID
               WHERE A.IDPemda = @IDPemda 
              ) B
     )A INNER JOIN 
        (   
         SELECT Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, No_Urut, Bts_Bawah, Bts_Atas, Masa_Manfaat*12 AS Masa_Manfaat_Tambahan
         FROM Ref_Kap_Umur
         WHERE Kd_Aset8 = @Kd_Aset AND Kd_Aset80 = @Kd_Aset0 AND Kd_Aset81 = @Kd_Aset1 AND Kd_Aset82 = @Kd_Aset2 AND Kd_Aset83 = @Kd_Aset3
        ) B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83
WHERE A.Rasio > B.Bts_Bawah AND A.Rasio <= B.Bts_Atas
) A

UNION ALL 

SELECT A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Tgl, A.Nilai_Perolehan, A.Nilai_Perolehan_Akhir, A.Nilai_Buku, A.Sisa_umur, A.Rasio, A.Masa_Manfaat_Awal,
	CASE WHEN A.Masa_Manfaat_Rill < 0 THEN 0
		 WHEN A.Masa_Manfaat_Rill > 0 AND A.Masa_Manfaat_Rill = A.Masa_Manfaat_Tambahan THEN A.Masa_Manfaat_Rill
	     WHEN A.Masa_Manfaat_Rill > 0 AND A.Masa_Manfaat_Rill < A.Masa_Manfaat_Tambahan THEN A.Masa_Manfaat_Rill
         WHEN A.Masa_Manfaat_Rill > 0 AND A.Masa_Manfaat_Rill > A.Masa_Manfaat_Tambahan THEN A.Masa_Manfaat_Tambahan
	     ELSE 0 END AS Masa_Manfaat_Tambahan
FROM (
SELECT A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Tgl, A.Nilai_Perolehan, A.Nilai_Perolehan_Akhir, A.Nilai_Buku, A.Sisa_umur, A.Masa_Manfaat_Awal, 
       A.Rasio, B.Masa_Manfaat_Tambahan,
       CASE WHEN (@TipeB = 1 OR (@TipeB = 2 AND @TypeBV = 0)) AND @TipeC = 1 AND A.Sisa_umur+B.Masa_Manfaat_Tambahan > A.Masa_Manfaat_Awal THEN A.Masa_Manfaat_Awal- A.Sisa_Umur
            WHEN (@TipeB = 1 OR (@TipeB = 2 AND @TypeBV = 0)) AND @TipeC = 2 AND A.Sisa_umur+B.Masa_Manfaat_Tambahan > A.Masa_Manfaat_Awal THEN B.Masa_Manfaat_Tambahan
            WHEN (@TipeB = 1 OR (@TipeB = 2 AND @TypeBV = 0)) AND @TipeC = 1 AND A.Sisa_umur+B.Masa_Manfaat_Tambahan <= A.Masa_Manfaat_Awal THEN B.Masa_Manfaat_Tambahan
            ELSE 0 END AS Masa_Manfaat_Rill          
FROM
     (
      SELECT @Kd_Aset AS Kd_Aset8, @Kd_Aset0 AS Kd_Aset80, @Kd_Aset1 AS Kd_Aset81, @Kd_Aset2 AS Kd_Aset82, @Kd_Aset3 AS Kd_Aset83, A.Tgl, B.Harga AS Nilai_Perolehan, (A.Akum + A.Sisa) AS Nilai_Perolehan_Akhir, 
             A.Sisa AS Nilai_Buku, A.Sisa_umur, B.Masa_Manfaat AS Masa_Manfaat_Awal, 
             CASE WHEN @TipeA = 1 AND (A.Akum + A.Sisa) > 0 THEN @Nilai/(A.Akum + A.Sisa)*100 
                  WHEN @TipeA = 2 AND B.Harga > 0 THEN @Nilai/B.Harga*100
                  WHEN @TipeA = 3 AND A.Sisa > 0 THEN @Nilai/A.Sisa*100
                  ELSE 0
                  END AS Rasio
      FROM
           (
            SELECT Tgl, Akum, Sisa, Sisa_Umur
            FROM @tmp1 
            WHERE Tgl = @Tanggal
           ) A,
              (
               SELECT A.Harga, A.Masa_Manfaat AS Masa_Manfaat
               FROM Ta_KIB_D A LEFT OUTER JOIN @pindah B ON A.IDPemda = B.IDPemda
               WHERE B.IDPemda IS NULL AND A.IDPemda = @IDPemda
               UNION ALL
               SELECT A.Harga, A.Masa_Manfaat
               FROM Ta_KIBDR A INNER JOIN @pindah B ON A.IDPemda = B.IDPemda AND A.Tgl_Perolehan = B.Tgl_Perolehan AND A.Kd_ID = B.Kd_ID
               WHERE A.IDPemda = @IDPemda 
              ) B
     )A INNER JOIN 
        (   
         SELECT Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, No_Urut, Bts_Bawah, Bts_Atas, Masa_Manfaat*12 AS Masa_Manfaat_Tambahan
         FROM Ref_Kap_Umur
         WHERE Kd_Aset8 = @Kd_Aset AND Kd_Aset80 = @Kd_Aset0 AND Kd_Aset81 = @Kd_Aset1 AND Kd_Aset82 = @Kd_Aset2 AND Kd_Aset83 = @Kd_Aset3
		 AND Bts_Atas = (SELECT MAX(Bts_Atas) FROM Ref_Kap_Umur WHERE Kd_Aset8 = @Kd_Aset AND Kd_Aset80 = @Kd_Aset0 AND Kd_Aset81 = @Kd_Aset1 AND Kd_Aset82 = @Kd_Aset2 AND Kd_Aset83 = @Kd_Aset3)
        ) B ON A.Kd_Aset8 = B.Kd_Aset8 AND A.Kd_Aset80 = B.Kd_Aset80 AND A.Kd_Aset81 = B.Kd_Aset81 AND A.Kd_Aset82 = B.Kd_Aset82 AND A.Kd_Aset83 = B.Kd_Aset83
WHERE A.Rasio >= B.Bts_Atas
) A



GO
