USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** RptRekapBarangPerSKPD - 29012016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE RptRekapBarangPerSKPD @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), @D2 Datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @D2 datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10)
SET @Tahun = '2011'
SET @Kd_Prov = '7'
SET @Kd_Kab_Kota = '4'
SET @D2 = '20111231'
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @Kd_UPB = ''
*/
	
	DECLARE @tmpRekap TABLE(Kd_Bidang tinyint, Kd_Unit smallint, Kd_Asset1 tinyint, Tanah Money, Alat Money, Gedung Money, Jalan Money, Lainnya Money, KDP Money)
	DECLARE @JLap Tinyint	
	SET @JLap = 1	

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1, A.Tanah, 0 As Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP
	FROM
		(
		SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1, SUM(A.Harga) AS Tanah
		FROM fn_Kartu_BrgA(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
					(Select * from Ta_KIBAR where (Kd_Riwayat IN(10,11,12,13)) AND (Tgl_Dokumen <= @D2) ) B
						ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				      			A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND
				      			A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END) 
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1) AND (B.Kd_Prov is NULL)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1) A

	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1, 0 As Tanah, A.Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP
	FROM
		(
		SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1, SUM(A.Harga) AS Alat
		FROM fn_Kartu_BrgB(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
				(Select * from Ta_KIBBR where (Kd_Riwayat IN(10,11,12,13)) AND (Tgl_Dokumen <= @D2) ) B 
					ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				      		A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND
				      		A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END)  AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)AND (B.Kd_Prov is NULL)  
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1) A

	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1, 0 As Tanah, 0 As Alat, A.Gedung, 0 As Jalan, 0 As Lainnya, 0 As KDP
	FROM
		(
		SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1, SUM(A.Harga) AS Gedung
		FROM fn_Kartu_BrgC(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
				(Select * from Ta_KIBCR where (Kd_Riwayat IN(10,11,12,13)) AND (Tgl_Dokumen <= @D2) ) B 
					ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				      		A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND
				      		A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END)  AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)AND (B.Kd_Prov is NULL)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1) A
	
	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1, 0 As Tanah, 0 As Alat, 0 AS Gedung, A.Jalan, 0 As Lainnya, 0 As KDP
	FROM
		(
		SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1, SUM(A.Harga) AS Jalan
		FROM fn_Kartu_BrgD(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A  LEFT OUTER JOIN
				(Select * from Ta_KIBDR where (Kd_Riwayat IN(10,11,12,13)) AND (Tgl_Dokumen <= @D2) ) B 
					ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				      		A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND
				      		A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END)  AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)AND (B.Kd_Prov is NULL)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1) A
	
	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1, 0 As Tanah, 0 As Alat, 0 AS Gedung, 0 As Jalan, A.Lainnya, 0 As KDP
	FROM
		(
		SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1, SUM(A.Harga) AS Lainnya
		FROM fn_Kartu_BrgE(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END)  AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1) A
	

	INSERT INTO @tmpRekap
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1, 0 As Tanah, 0 As Alat, 0 AS Gedung, 0 As Jalan, 0 As Lainnya, A.KDP
	FROM
		(
		SELECT	A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1, SUM(A.Harga) AS KDP
		FROM	fn_Kartu_BrgF(@D2, @Kd_prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	              AND (A.Kd_Pemilik = CASE @Kd_Kab_Kota WHEN 0 THEN 11 ELSE 12 END)  AND (A.KONDISI < 3)
		      AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
		GROUP BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Aset1) A
	
	
	SELECT 	A.Kd_Unit, A.Kd_Unit_Gab, A.Nm_Unit, A.Tanah, A.Alat, A.Gedung, A.Jalan, A.Lainnya, A.KDP,
		( A.Tanah + A.Alat + A.Gedung + A.Jalan + A.Lainnya + A.KDP) As Jumlah, C.Nm_Pemda, NULL AS Logo
	FROM 
		(
		SELECT A.Kd_Bidang, A.Kd_Unit,  
			convert(varchar, A.Kd_Bidang) + '.' + convert(varchar, A.Kd_Unit) As Kd_Unit_Gab,
			MAX(B.Nm_Unit) AS Nm_Unit, SUM(A.Tanah) AS Tanah, SUM(A.Alat) AS Alat, 
			SUM(A.Gedung) AS Gedung, SUM(A.Jalan) AS Jalan, SUM(A.Lainnya) AS Lainnya, SUM(A.KDP) AS KDP
		FROM @tmpRekap A inner join 
		     Ref_Unit B On A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit
		GROUP BY A.Kd_Bidang, A.Kd_Unit
		) A,
		(
		SELECT UPPER(B.Nm_Pemda) AS Nm_Pemda, NULL AS Logo
		FROM Ta_Pemda A INNER JOIN
		     Ref_PEMDA B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota
		WHERE A.Tahun = @Tahun AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota 
		) C
		ORDER BY  A.Kd_Bidang, A.Kd_Unit








GO
