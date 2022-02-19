USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.Rpt108Perbedaan17 @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), 
	@Kd_Sub varchar(3), @Kd_UPB varchar(3), @D2 datetime, @Kd_KIB varchar(1)
WITH ENCRYPTION
AS
--rpt rincian aset pindah golongan


/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), @D2 Datetime, @Kd_KIB varchar(1)
SET @Tahun = '2019'
SET @Kd_Prov = '30'
SET @Kd_Kab_Kota = '5'
SET @Kd_Bidang ='5'
SET @Kd_Unit ='1' 
SET @Kd_Sub ='1'
SET @Kd_UPB ='1' 
SET @D2 = '20191231'
SET @Kd_KIB = 'D'
--*/

---------------------------
	
	DECLARE @tmpKIB TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, 
		Kd_Aset tinyint,Kd_Aset0 tinyint,Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 smallint, No_Register int, Tgl_Perolehan datetime,
		Harga money,MutasiB money, MutasiC money, MutasiD money, MutasiE money , Lainnya money, 
		MutasikeB money, MutasikeC money, MutasikeD money, MutasikeE money, 
		KD1 tinyint,KD2 tinyint, KD3 tinyint, KD4 tinyint, KD5 tinyint, No_Reg17 int, Tgl17 datetime,
		Akum_susut money)

	DECLARE @JLap Tinyint	
	SET @JLap = 1	
	

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'




-------------------------------------------------------B
IF @Kd_KIB = 'B' 
BEGIN

	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			SUM(A.Harga) AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgB1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND (A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 2)
		      AND (A.Tahun = @Tahun)
		    
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutB C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
	    WHERE C.Tahun = @Tahun
	    GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		      A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		     ,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		     ,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		     ,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		     ,C.Akum_Susut



	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			0 AS Harga,  0 AS MutasiB, SUM(A.Harga) AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgC1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) 
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 2) OR (B.KD_ASET1 = 2))
		      AND (A.Tahun = @Tahun)
		     
		GROUP BY A.IDPemda,
			A.IDPemda,A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutC C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

	
	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, SUM(A.Harga) AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgD1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
			--INNER JOIN Ta_SusutD C ON A.IDPemda = C.IDPemda
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END)  
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 2) OR (B.KD_ASET1 = 2))
		      AND (A.Tahun = @Tahun)
		     
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutD C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
        WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

	
	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda,A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, SUM(A.Harga) AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgE1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 2) OR (B.KD_ASET1 = 2))
		      AND (A.Tahun = @Tahun)
		      
		GROUP BY A.IDPemda,  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutE C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut
		

	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, SUM(A.Harga) AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgB1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 3) OR (B.KD_ASET1 = 3))
		      AND (A.Tahun = @Tahun)
		     -- AND (C.Tahun = @Tahun)
		GROUP BY A.IDPemda,  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutB C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun =@Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan 
			,0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, SUM(A.Harga) AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgB1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
			--INNER JOIN Ta_SusutB C ON A.IDPemda = C.IDPemda
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 4) OR (B.KD_ASET1 = 4))
		      AND (A.Tahun = @Tahun)
		    --  AND (C.Tahun = @Tahun)
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			--B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5
	) A LEFT OUTER JOIN Ta_SusutB C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut
		
	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda,A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, SUM(A.Harga) AS MutasikeE

		FROM fn_Kartu108_BrgB1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 5)OR (B.KD_ASET1 = 5))
		      AND (A.Tahun = @Tahun)
		      --AND (C.Tahun = @Tahun)
		GROUP BY A.IDPemda,  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			--B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5
	) A LEFT OUTER JOIN Ta_SusutB C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut


END
---------------------------------------------------C
IF @Kd_KIB = 'C' 
BEGIN
	
	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			SUM(A.Harga) AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
		FROM fn_Kartu108_BrgC1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND (A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 3)
		      AND (A.Tahun = @Tahun)
		   
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutC C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

	
	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			0 AS Harga,  SUM(A.Harga)AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgB1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) 
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 3) OR (B.KD_ASET1 = 3))
		      AND (A.Tahun = @Tahun)
		   
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutB C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut
	

	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, SUM(A.Harga) AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgD1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END)  
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 3) OR (B.KD_ASET1 = 3))
		      AND (A.Tahun = @Tahun)
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutD C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

---KDP

INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		, 6 AS KD1, 20 AS KD2, 1 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5 
		,B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,0 AS Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, SUM(A.Harga) AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgF1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END)  
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND (B.Kd_Aset8 = 1 AND B.Kd_Aset80 = 3 AND B.Kd_Aset81 = 3) 
		      AND (A.Tahun = @Tahun)
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A --LEFT OUTER JOIN Ta_SusutD C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
	--WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		--,C.Akum_Susut


INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
			, 6 AS KD1, 20 AS KD2, 1 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5 
		, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,0 AS Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, SUM(A.Harga) AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgF1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END)  
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND (B.Kd_Aset8 = 1 AND B.Kd_Aset80 = 3 AND B.Kd_Aset81 = 4) 
		      AND (A.Tahun = @Tahun)
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A --LEFT OUTER JOIN Ta_SusutD C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
	--WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		--,C.Akum_Susut
------

	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, SUM(A.Harga) AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgE1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 3) OR (B.KD_ASET1 = 3))
		      AND (A.Tahun = @Tahun)
		      
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutE C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

	
	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
		A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,SUM(A.Harga) AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgC1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 2) OR (B.KD_ASET1 = 2))
		      AND (A.Tahun = @Tahun)
		    
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutC C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, SUM(A.Harga) AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgC1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 4) OR (B.KD_ASET1 = 4))
		      AND (A.Tahun = @Tahun)
		   
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutC C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut
		
	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, SUM(A.Harga) AS MutasikeE
			
		FROM fn_Kartu108_BrgC1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 5) OR (B.KD_ASET1 = 5))
		      AND (A.Tahun = @Tahun)
		     
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutC C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

END
-----------------------------------------------D

IF @Kd_KIB = 'D' 
BEGIN
	
	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			SUM(A.Harga) AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgD1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND (A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 4)
		      AND (A.Tahun = @Tahun)
		      
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutD C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
		A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			0 AS Harga,  SUM(A.Harga) AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgB1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) 
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 4)  OR (B.KD_ASET1 = 4))
		      AND (A.Tahun = @Tahun)
			
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutB C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut
		

	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
			0 AS Harga, 0 AS MutasiB, SUM(A.Harga) AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgC1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END)  
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 4)  OR (B.KD_ASET1 = 4))
		      AND (A.Tahun = @Tahun)
			
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutC C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

		
	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, SUM(A.Harga) AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgE1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 4)  OR (B.KD_ASET1 = 4))
		      AND (A.Tahun = @Tahun)
			
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutE C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

		
	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,SUM(A.Harga) AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgD1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 2)  OR (B.KD_ASET1 = 2))
		      AND (A.Tahun = @Tahun)
			 
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutD C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

		
	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, SUM(A.Harga) AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgD1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 3)  OR (B.KD_ASET1 = 3))
		      AND (A.Tahun = @Tahun)
			
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutD C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

-------KDP

	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		, 6 AS KD1, 20 AS KD2, 1 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5 
		,B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,0 AS Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, SUM(A.Harga) AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgF1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND (B.Kd_Aset8 = 1 AND B.Kd_Aset80 = 3 AND B.Kd_Aset81 = 3) 
		      AND (A.Tahun = @Tahun)
			
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A --LEFT OUTER JOIN Ta_SusutD C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
	--WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		--,C.Akum_Susut

	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		, 6 AS KD1, 20 AS KD2, 1 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5 
		,B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,0 AS Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, SUM(A.Harga) AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgF1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND (B.Kd_Aset8 = 1 AND B.Kd_Aset80 = 3 AND B.Kd_Aset81 = 4) 
		      AND (A.Tahun = @Tahun)
			
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A --LEFT OUTER JOIN Ta_SusutD C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
	--WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		--,C.Akum_Susut
		
-----------------------

		
	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
		A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan 
			,0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, SUM(A.Harga) AS MutasikeE
			
		FROM fn_Kartu108_BrgD1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 5)  OR (B.KD_ASET1 = 5))
		      AND (A.Tahun = @Tahun)
			
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutD C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

END

-------------------------------------------------E

IF @Kd_KIB = 'E' 
BEGIN
	
	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
		A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			SUM(A.Harga) AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgE1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND (A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 5)
		      AND (A.Tahun = @Tahun)
		     
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutE C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17  
		,C.Akum_Susut
	FROM
	(

		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
			0 AS Harga,  SUM(A.Harga) AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgB1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) 
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 5)  OR (B.KD_ASET1 = 5))
		      AND (A.Tahun = @Tahun)
		   
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutB C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
			0 AS Harga, 0 AS MutasiB, SUM(A.Harga) AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgC1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END)  
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 5)  OR (B.KD_ASET1 = 5))
		      AND (A.Tahun = @Tahun)
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutC C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
		A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
			0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, SUM(A.Harga) AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgD1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 5)  OR (B.KD_ASET1 = 5))
		      AND (A.Tahun = @Tahun)
			
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutD C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut	

	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan 
			,0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,SUM(A.Harga) AS MutasikeB, 0 AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgE1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 2)  OR (B.KD_ASET1 = 2))
		      AND (A.Tahun = @Tahun)
		       
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutE C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut


	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan 
			,0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, SUM(A.Harga) AS MutasikeC, 0 AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgE1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 3)  OR (B.KD_ASET1 = 3))
		      AND (A.Tahun = @Tahun)
		      
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutE C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

	INSERT INTO @tmpKIB
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan,
		A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1 AS KD1, B.Kd_Aset2 AS KD2, B.Kd_Aset3 AS KD3, B.Kd_Aset4 AS KD4, B.Kd_Aset5 AS KD5, B.No_Register AS No_Reg17, B.Tgl_Perolehan AS Tgl17 
		,C.Akum_Susut
	FROM
	(
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan 
			,0 AS Harga, 0 AS MutasiB, 0 AS MutasiC, 0 AS MutasiD, 0 AS MutasiE, 0 AS Lainnya
			,0 AS MutasikeB, 0 AS MutasikeC, SUM(A.Harga) AS MutasikeD, 0 AS MutasikeE
			
		FROM fn_Kartu108_BrgE1(@Tahun, @D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
			LEFT OUTER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
			
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) -- AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		      AND ((A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 4)  OR (B.KD_ASET1 = 4))
		      AND (A.Tahun = @Tahun)
			
		GROUP BY A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset, A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
			
	) A LEFT OUTER JOIN Ta_SusutE C ON A.IDPemda = C.IDPemda
	    LEFT OUTER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
	WHERE C.Tahun = @Tahun
	GROUP BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan
		,A.Harga, A.MutasiB, A.MutasiC, A.MutasiD, A.MutasiE, A.Lainnya
		,A.MutasikeB, A.MutasikeC, A.MutasikeD, A.MutasikeE
		,B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5, B.No_Register, B.Tgl_Perolehan
		,C.Akum_Susut

END


------------------------------------------------

	SELECT A.Kd_Prov, B.Nm_Provinsi, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, D.Nm_Bidang, A.Kd_Unit, E.Nm_Unit, A.Kd_Sub, F.Nm_Sub_Unit, A.Kd_UPB, G.Nm_UPB,
		CONVERT(varchar, A.Kd_Bidang) + '.' + CONVERT(varchar, A.Kd_Unit) AS Kd_Unit_Gab,
		CONVERT(varchar, A.Kd_Bidang) + '.' + CONVERT(varchar, A.Kd_Unit) + '.' + CONVERT(varchar, A.Kd_Sub) AS Kd_Sub_Unit_Gab,
		CONVERT(varchar, A.Kd_Bidang) + '.' + CONVERT(varchar, A.Kd_Unit) + '.' + CONVERT(varchar, A.Kd_Sub) + '.' + CONVERT(varchar, A.Kd_UPB) As Kd_UPB_Gab,
		
		CONVERT(varchar, A.KD1)AS Kd_Aset1_Gab17,     
		M.NM_ASET1 AS Nm_Aset1_17,
		CONVERT(varchar, A.Kd_Aset)+'.'+ CONVERT(varchar, A.Kd_Aset0)+'.'+ CONVERT(varchar, A.Kd_Aset1)AS Kd_Aset1_Gab,     
		H.NM_ASET1 AS Nm_Aset1_108,

		CONVERT(varchar, A.KD1)+'.'+ CONVERT(varchar, A.KD2)AS Kd_Aset2_Gab17,     
		N.NM_ASET2 AS Nm_Aset2_17,
		CONVERT(varchar, A.Kd_Aset)+'.'+ CONVERT(varchar, A.Kd_Aset0)+'.'+ CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2) AS Kd_Aset2_Gab,     
		I.NM_ASET2 AS Nm_Aset2_108,

		CONVERT(varchar, A.KD1)+'.'+ CONVERT(varchar, A.KD2)+'.'+ CONVERT(varchar, A.KD3)AS Kd_Aset3_Gab17,     
		O.NM_ASET3 AS Nm_Aset3_17,
		CONVERT(varchar, A.Kd_Aset)+'.'+ CONVERT(varchar, A.Kd_Aset0)+'.'+ CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)AS Kd_Aset3_Gab,     
		J.NM_ASET3 AS Nm_Aset3_108,

		CONVERT(varchar, A.KD1)+'.'+ CONVERT(varchar, A.KD2)+'.'+ CONVERT(varchar, A.KD3)+'.'+ CONVERT(varchar, A.KD4)AS Kd_Aset4_Gab17,     
		P.NM_ASET4 AS Nm_Aset4_17,
		CONVERT(varchar, A.Kd_Aset)+'.'+ CONVERT(varchar, A.Kd_Aset0)+'.'+ CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4) AS Kd_Aset4_Gab,     
		K.NM_ASET4 AS Nm_Aset4_108,

		CONVERT(varchar, A.KD1)+'.'+ CONVERT(varchar, A.KD2)+'.'+ CONVERT(varchar, A.KD3)+'.'+ CONVERT(varchar, A.KD4)+'.'+CONVERT(varchar, A.KD5)AS Kd_Aset5_Gab17,     
		A.No_Reg17, A.Tgl17,
		Q.NM_ASET5 AS Nm_Aset5_17,
		CONVERT(varchar, A.Kd_Aset)+'.'+ CONVERT(varchar, A.Kd_Aset0)+'.'+ CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4)+'.'+CONVERT(varchar, A.Kd_Aset5)AS Kd_Aset5_Gab,     
		A.No_Register, A.Tgl_Perolehan,
		L.NM_ASET5 AS Nm_Aset5_108,
		SUM(A.Harga) AS Harga, 
		SUM(A.MutasiB) AS MutasiB, SUM(A.MutasiC) AS MutasiC, SUM(A.MutasiD) AS MutasiD, SUM(A.MutasiE) AS MutasiE, 0 AS Lainnya,
		SUM (A.MutasikeB) AS MutasikeB, SUM (A.MutasikeC) AS MutasikeC, SUM (A.MutasikeD) AS MutasikeD, SUM (A.MutasikeE) AS MutasikeE, 
		SUM (A.MutasiB - A.MutasikeB ) AS Mutasi_B,
		SUM (A.MutasiC - A.MutasikeC ) AS Mutasi_C,
		SUM (A.MutasiD - A.MutasikeD ) AS Mutasi_D,
		SUM (A.MutasiE - A.MutasikeE ) AS Mutasi_E,
		SUM (A.MutasiB + A.MutasiC + A.MutasiD + A.MutasiE ) AS Jumlah,
		SUM (A.MutasikeB + A.MutasikeC + A.MutasikeD + A.MutasikeE ) AS JumlahPindah
		--,A.IDPemda
		,ISNULL(A.Akum_Susut,0) AS Akum_Susut
		
	FROM @tmpKIB A   
		INNER JOIN Ref_Provinsi B ON A.Kd_Prov = B.Kd_Prov
                INNER JOIN Ref_Kab_Kota C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota
		       INNER JOIN Ref_Bidang D ON A.Kd_Bidang = D.Kd_Bidang 
                       INNER JOIN Ref_Unit E ON A.Kd_Prov = E.Kd_Prov AND A.Kd_Kab_Kota = E.Kd_Kab_Kota AND A.Kd_Bidang = E.Kd_Bidang AND A.Kd_Unit = E.Kd_Unit  
                       INNER JOIN Ref_Sub_Unit F ON A.Kd_Prov = F.Kd_Prov AND A.Kd_Kab_Kota = F.Kd_Kab_Kota AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub 
                       INNER JOIN Ref_UPB G ON A.Kd_Prov = G.Kd_Prov AND A.Kd_Kab_Kota = G.Kd_Kab_Kota AND A.Kd_Bidang = G.Kd_Bidang AND A.Kd_Unit = G.Kd_Unit AND 
                       			A.Kd_Sub = G.Kd_Sub AND A.Kd_UPB = G.Kd_UPB
                      	
		     INNER JOIN REF_REK1_108 H ON A.Kd_Aset = H.Kd_Aset AND A.Kd_Aset0 = H.Kd_Aset0 AND A.Kd_Aset1 = H.Kd_Aset1 
		     INNER JOIN REF_REK2_108 I ON A.Kd_Aset = I.Kd_Aset AND A.Kd_Aset0 = I.Kd_Aset0 AND A.Kd_Aset1 = I.Kd_Aset1 AND A.Kd_Aset2 = I.Kd_Aset2 
		     INNER JOIN REF_REK3_108 J ON A.Kd_Aset = J.Kd_Aset AND A.Kd_Aset0 = J.Kd_Aset0 AND A.Kd_Aset1 = J.Kd_Aset1 AND A.Kd_Aset2 = J.Kd_Aset2 AND 
                				  A.Kd_Aset3 = J.Kd_Aset3 
		     INNER JOIN REF_REK4_108 K ON A.Kd_Aset = K.Kd_Aset AND A.Kd_Aset0 = K.Kd_Aset0 AND A.Kd_Aset1 = K.Kd_Aset1 AND A.Kd_Aset2 = K.Kd_Aset2 AND 
                				  A.Kd_Aset3 = K.Kd_Aset3 AND A.Kd_Aset4 = K.Kd_Aset4 		
		     INNER JOIN REF_REK5_108 L ON A.Kd_Aset = L.Kd_Aset AND A.Kd_Aset0 = L.Kd_Aset0 AND A.Kd_Aset1 = L.Kd_Aset1 AND A.Kd_Aset2 = L.Kd_Aset2 AND 
                				  A.Kd_Aset3 = L.Kd_Aset3 AND A.Kd_Aset4 = L.Kd_Aset4 AND A.Kd_Aset5 = L.Kd_Aset5
		     INNER JOIN REF_REK_ASET1 M ON A.Kd1 = M.Kd_Aset1 
		     INNER JOIN REF_REK_ASET2 N ON A.Kd1 = N.Kd_Aset1 AND A.KD2 = N.Kd_Aset2 
		     INNER JOIN REF_REK_ASET3 O ON A.Kd1 = O.Kd_Aset1 AND A.KD2 = O.Kd_Aset2 AND A.KD3 = O.Kd_Aset3 
		     INNER JOIN REF_REK_ASET4 P ON A.Kd1 = P.Kd_Aset1 AND A.KD2 = P.Kd_Aset2 AND A.KD3 = P.Kd_Aset3 AND A.KD4 = P.Kd_Aset4 
		     INNER JOIN REF_REK_ASET5 Q ON A.Kd1 = Q.Kd_Aset1 AND A.KD2 = Q.Kd_Aset2 AND A.KD3 = Q.Kd_Aset3 AND A.KD4 = Q.Kd_Aset4 AND A.KD5 = Q.Kd_Aset5 
	
	WHERE (A.MutasiB <> 0) OR (A.MutasiC <> 0) OR (A.MutasiD <> 0) OR (A.MutasiE <> 0) 
			OR (A.MutasikeB <> 0)  OR (A.MutasikeC <> 0) OR (A.MutasikeD <> 0) OR (A.MutasikeE <> 0) 
			
	GROUP BY  A.Kd_Prov, B.Nm_Provinsi, A.Kd_Kab_Kota, C.Nm_Kab_Kota, D.Nm_Bidang, E.Nm_Unit,F.Nm_Sub_Unit, M.Nm_Aset1, H.Nm_Aset1,N.Nm_Aset2,I.Nm_Aset2,O.Nm_Aset3,J.Nm_Aset3,P.Nm_Aset4,K.Nm_Aset4,
		A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, G.Nm_UPB, L.Nm_Aset5
		 ,A.KD1,A.KD2,A.KD3,A.KD4,A.KD5, Q.Nm_Aset5
		,A.Akum_Susut, A.No_Register, A.Tgl_Perolehan,A.No_Reg17, A.Tgl17
	ORDER BY Kd_UPB_Gab, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan






GO
