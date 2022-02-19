USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** RptRekapBarangPerUPB - 05012016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE dbo.RptRekapBarangPerUPB @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), @D2 Datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), @D2 Datetime
SET @Tahun = '2011'
SET @Kd_Prov = '7'
SET @Kd_Kab_Kota = '4'
SET @D2 = '20111231'
*/

	DECLARE @Hrg1 money, @Hrg2 money

	SET @Hrg1 = 0
	SET @Hrg2 = 0

	SELECT @Hrg1 = MinSatuan, @Hrg2 = MinTotal
	FROM Ta_KA
	WHERE (Tahun = @Tahun)

	DECLARE @tmpRekap TABLE(Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub Smallint, Kd_UPB smallint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Tanah money, Alat money, Gedung money, Jalan money, Lainnya money, KDP Money, EK Money, RB Money)
	DECLARE @JLap tinyint SET @JLap = 1

	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Tanah) AS Tanah, 0 As Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP, 0 As EK, 0 AS RB
	FROM
		(
		SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS Tanah
		FROM fn_Kartu_BrgA(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22)  AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1) 
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		
	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 As Tanah, SUM(A.Alat) AS Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP, 0 As EK, 0 AS RB
	FROM
		(
		SELECT	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS Alat
		FROM fn_Kartu_BrgB(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22)  AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1) AND (A.KONDISI < 3)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
	
	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 As Tanah, 0 As Alat, SUM(A.Gedung) AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP, 0 As EK, 0 AS RB
	FROM
		(
		SELECT	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS Gedung
		FROM fn_Kartu_BrgC(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22) AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1) AND (A.KONDISI < 3)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3

	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 As Tanah, 0 As Alat, 0 AS Gedung, SUM(A.Jalan) AS Jalan, 0 As Lainnya, 0 As KDP, 0 As EK, 0 AS RB
	FROM
		(
		SELECT	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS Jalan
		FROM fn_Kartu_BrgD(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22)  AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1) AND (A.KONDISI < 3)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A	
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
	
	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 As Tanah, 0 As Alat, 0 AS Gedung, 0 As Jalan, SUM(A.Lainnya) AS Lainnya, 0 As KDP, 0 As EK, 0 AS RB
	FROM
		(
		SELECT	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS Lainnya
		FROM fn_Kartu_BrgE(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22) AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1) AND (A.KONDISI < 3)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
	
	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 As Tanah, 0 As Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, A.KDP, 0 As EK, 0 AS RB
	FROM
		(SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS KDP
		FROM fn_Kartu_BrgF(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22) AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1) AND (A.KONDISI < 3)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.KDP
	
-----------------
--EKSTRAKOM

	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 as Tanah, 0 As Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP, SUM(A.EK) AS EK, 0 AS RB
	FROM
		(
		SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS EK
		FROM fn_Kartu_BrgA(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22) AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 0)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3


	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 as Tanah, 0 As Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP, SUM(A.EK) AS EK, 0 AS RB
	FROM
		(
		SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS EK
		FROM fn_Kartu_BrgB(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22) AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 0)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3


	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 as Tanah, 0 As Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP, SUM(A.EK) AS EK, 0 AS RB
	FROM
		(
		SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS EK
		FROM fn_Kartu_BrgC(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22) AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 0)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3

	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 as Tanah, 0 As Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP, SUM(A.EK) AS EK, 0 AS RB
	FROM
		(
		SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS EK
		FROM fn_Kartu_BrgD(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22) AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 0)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3

	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 as Tanah, 0 As Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP, SUM(A.EK) AS EK, 0 AS RB
	FROM
		(
		SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS EK
		FROM fn_Kartu_BrgE(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22) AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 0)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3



--LAINNYA

	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 As Tanah, 0 AS Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP, 0 As EK, SUM(A.RB) AS RB
	FROM
		(
		SELECT	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS RB
		FROM fn_Kartu_BrgB(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22) AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1) AND (A.KONDISI >= 3)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3


	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 As Tanah, 0 AS Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP, 0 As EK, SUM(A.RB) AS RB
	FROM
		(
		SELECT	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS RB
		FROM fn_Kartu_BrgC(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22) AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1) AND (A.KONDISI >= 3)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3

	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 As Tanah, 0 AS Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP, 0 As EK, SUM(A.RB) AS RB
	FROM
		(
		SELECT	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS RB
		FROM fn_Kartu_BrgD(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22) AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1) AND (A.KONDISI >= 3)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3

	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 As Tanah, 0 AS Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP, 0 As EK, SUM(A.RB) AS RB
	FROM
		(
		SELECT	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS RB
		FROM fn_Kartu_BrgE(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22) AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1) AND (A.KONDISI >= 3)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3


	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 As Tanah, 0 AS Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP, 0 As EK, SUM(A.RB) AS RB
	FROM
		(
		SELECT	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS RB
		FROM fn_Kartu_BrgF(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22) AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1) AND (A.KONDISI >= 3)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3


	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 As Tanah, 0 AS Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP, 0 As EK, SUM(A.RB) AS RB
	FROM
		(
		SELECT	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, SUM(A.Harga) AS RB
		FROM fn_Kartu_BrgL(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Tgl_Pembukuan <= @D2) AND (A.KD_BIDANG <> 22) AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) AND (A.Kd_KA = 1) 
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3
		) A
	GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3



	SELECT	A.Kd_UPB, A.Kd_UPB_Gab,
		A.Nm_UPB, A.Tanah, A.Alat, 
		A.Gedung, A.Jalan, A.Lainnya, A.KDP, A.RB, A.EK,
		( A.Tanah + A.Alat + A.Gedung + A.Jalan + A.Lainnya + A.KDP) As Jumlah, C.Nm_Pemda, C.Logo
	FROM 
		(
		SELECT	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
			convert(varchar, A.Kd_Bidang) + '.' + convert(varchar, A.Kd_Unit) + '.' + convert(varchar, A.Kd_Sub) + '.' + convert(varchar, A.Kd_UPB) As Kd_UPB_Gab,
			MAX(B.Nm_UPB) As Nm_UPB, MAX(A.Tanah) As Tanah, MAX(A.Alat) As Alat, 
			MAX(A.Gedung) As Gedung, MAX(A.Jalan) As Jalan, MAX(A.Lainnya) As Lainnya, MAX(A.KDP) As KDP, MAX(A.RB) AS RB, MAX(A.EK) AS EK
		FROM 	
			(
			SELECT	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, SUM(A.Tanah) As Tanah, SUM(A.Alat) As Alat, 
				SUM(A.Gedung) As Gedung, SUM(A.Jalan) As Jalan, SUM(A.Lainnya) As Lainnya, SUM(A.KDP) As KDP, SUM(A.RB) As RB, SUM(A.EK) As EK
			FROM 	@tmpRekap A
			GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
			) A inner join 
			Ref_UPB B On A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_SUB = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
		) A,
		(
		SELECT UPPER(B.Nm_Pemda) AS Nm_Pemda, B.Logo
		FROM Ta_Pemda A INNER JOIN
		     Ref_PEMDA B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota
		WHERE A.Tahun = @Tahun AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota 
		) C
	ORDER BY  A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB











GO
