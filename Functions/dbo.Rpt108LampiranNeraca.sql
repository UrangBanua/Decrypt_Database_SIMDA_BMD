USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.Rpt108LampiranNeraca @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), 
					 @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @D2 datetime 
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), 
	@Kd_Aset varchar(3),@Kd_Aset0 varchar(3),@Kd_Aset1 varchar(3), @D2 datetime
SET @Tahun = '2019'
SET @Kd_Prov = '3'
SET @Kd_Kab_Kota = '19'
SET @Kd_Bidang = '11'
SET @Kd_Unit = '4'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset = '1'
SET @Kd_Aset0 = '5'
SET @Kd_Aset1 = ''
SET @D2 = '20191231'
--*/
	DECLARE @tmpBI TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 int, 
		Kd_Pemilik tinyint, No_Register int, Tgl_Perolehan datetime, Tgl_Pembukuan datetime, Harga money, Alamat varchar(255), Luas float)
	DECLARE @tmpBIA TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 int, 
		Kd_Pemilik tinyint, No_Register int, Tgl_Perolehan datetime, Tgl_Pembukuan datetime, Harga money, Alamat varchar(255), Luas float)
	DECLARE @tmpBIC TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 int, 
		Kd_Pemilik tinyint, No_Register int, Tgl_Perolehan datetime, Tgl_Pembukuan datetime, Harga money, Alamat varchar(255), Luas float)

	DECLARE @JLap Tinyint

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	


	IF @Kd_Aset = '1' AND @Kd_Aset0 = '3' AND @Kd_Aset1 = '1'
	BEGIN
		SET @JLap = 0
		INSERT INTO @tmpBI
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Alamat, A.Luas_M2
		FROM fn_Kartu108_BrgA1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
			WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
			WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11	ELSE 12 END)  
	      		AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) 
	      		AND (A.KD_ASET LIKE @KD_ASET) AND (A.KD_ASET0 LIKE @KD_ASET0) AND (A.KD_ASET1 LIKE @KD_ASET1)
			AND A.Tahun = @Tahun
	END

	ELSE 
	IF @Kd_Aset = '1' AND @Kd_Aset0 = '3' AND @Kd_Aset1 = '2'
	BEGIN

		SET @JLap = 1
		INSERT INTO @tmpBI
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, NULL, NULL
		FROM fn_Kartu108_BrgB1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
			WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
			WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)  
	      		AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) --AND (A.Kondisi < 3)
			AND (A.KD_ASET LIKE @KD_ASET) AND (A.KD_ASET0 LIKE @KD_ASET0) AND (A.KD_ASET1 LIKE @KD_ASET1)
			AND A.Tahun = @Tahun

		UNION ALL
	
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga,  A.Lokasi, A.Luas_Lantai
		FROM fn_Kartu108_BrgC1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
			WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
			WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11	ELSE 12 END)  
	      		AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) --AND (A.Kondisi < 3)
			AND (A.KD_ASET LIKE @KD_ASET) AND (A.KD_ASET0 LIKE @KD_ASET0) AND (A.KD_ASET1 LIKE @KD_ASET1)	
			AND A.Tahun = @Tahun

		UNION ALL

		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga,  NULL, NULL
		FROM fn_Kartu108_BrgE1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
			WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
			WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)  
	      		AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) --AND (A.Kondisi < 3)
	      		AND (A.KD_ASET LIKE @KD_ASET) AND (A.KD_ASET0 LIKE @KD_ASET0) AND (A.KD_ASET1 LIKE @KD_ASET1)
			AND A.Tahun = @Tahun


	END

	ELSE 
	IF @Kd_Aset = '1' AND @Kd_Aset0 = '3' AND @Kd_Aset1 = '3'
	BEGIN
		SET @JLap = 0
		INSERT INTO @tmpBI
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga,  A.Lokasi, A.Luas_Lantai
		FROM fn_Kartu108_BrgC1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
			WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
			WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11	ELSE 12 END)  
	      		AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) --AND (A.Kondisi < 3)
			AND (A.KD_ASET LIKE @KD_ASET) AND (A.KD_ASET0 LIKE @KD_ASET0) AND (A.KD_ASET1 LIKE @KD_ASET1)
			AND A.Tahun = @Tahun

		UNION ALL

		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga,  A.Lokasi, A.Luas
		FROM fn_Kartu108_BrgD1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
			WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
			WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)  
	      		AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) --AND (A.Kondisi < 3)
	      		AND (A.KD_ASET LIKE @KD_ASET) AND (A.KD_ASET0 LIKE @KD_ASET0) AND (A.KD_ASET1 LIKE @KD_ASET1)
			AND A.Tahun = @Tahun
	      		
	END

	ELSE IF @Kd_Aset = '1' AND @Kd_Aset0 = '3' AND @Kd_Aset1 = '4'
	BEGIN
		SET @JLap = 0
		INSERT INTO @tmpBI
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga,  A.Lokasi, A.Luas
		FROM fn_Kartu108_BrgD1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
			WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
			WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)  
	      		AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22)--- AND (A.Kondisi < 3)
	      		AND (A.KD_ASET LIKE @KD_ASET) AND (A.KD_ASET0 LIKE @KD_ASET0) AND (A.KD_ASET1 LIKE @KD_ASET1)
			AND A.Tahun = @Tahun

		UNION ALL

		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga,  A.Lokasi, A.Luas_Lantai
		FROM fn_Kartu108_BrgC1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
			WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
			WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11	ELSE 12 END)  
	      		AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) --AND (A.Kondisi < 3)
			AND (A.KD_ASET LIKE @KD_ASET) AND (A.KD_ASET0 LIKE @KD_ASET0) AND (A.KD_ASET1 LIKE @KD_ASET1)
			AND A.Tahun = @Tahun

		

	  END

	ELSE IF @Kd_Aset = '1' AND @Kd_Aset0 = '3' AND @Kd_Aset1 = '5'
	BEGIN
		SET @JLap = 1
		INSERT INTO @tmpBI
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga,  NULL, NULL
		FROM fn_Kartu108_BrgE1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
			WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
			WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)  
	      		AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) --AND (A.Kondisi < 3)
	      		AND (A.KD_ASET LIKE @KD_ASET) AND (A.KD_ASET0 LIKE @KD_ASET0) AND (A.KD_ASET1 LIKE @KD_ASET1)
			AND A.Tahun = @Tahun
	      		
	END

	ELSE 
	IF @Kd_Aset = '1' AND @Kd_Aset0 = '3' AND @Kd_Aset1 = '6'
	BEGIN
		SET @JLap = 0
		INSERT INTO @tmpBI
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Lokasi, A.Luas_Lantai
		FROM fn_Kartu108_BrgF1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%','%','%',@JLap)  A
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
			WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
			WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)  
	      		AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) 
	      		AND (A.KD_ASET LIKE @KD_ASET) AND (A.KD_ASET0 LIKE @KD_ASET0) AND (A.KD_ASET1 LIKE @KD_ASET1)
			AND A.Tahun = @Tahun

		
	END

	ELSE 
	IF @Kd_Aset = '1' AND @Kd_Aset0 = '5' AND @Kd_Aset1 = ''
	BEGIN
		SET @JLap = 0
		INSERT INTO @tmpBI
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, NULL, NULL
		FROM fn_Kartu108_BrgB1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%','%','%',@JLap)  A
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
			WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
			WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)  
	      		AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) --AND (A.Kondisi >= 3)
	      		AND (A.KD_ASET LIKE @KD_ASET) AND (A.KD_ASET0 LIKE @KD_ASET0) AND (A.KD_ASET1 IN (2,3,4))
			AND (A.Tahun = @Tahun)

		UNION ALL		
	
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga,A.Lokasi, A.Luas_Lantai
		FROM fn_Kartu108_BrgC1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%','%','%',@JLap)  A
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
			WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
			WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)  
	      		AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22)--AND (A.Kondisi >= 3)
	      		AND (A.KD_ASET LIKE @KD_ASET) AND (A.KD_ASET0 LIKE @KD_ASET0) AND (A.KD_ASET1 IN (2,3,4))
			AND (A.Tahun = @Tahun)

		UNION ALL		
	
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga,A.Lokasi, A.Luas
		FROM fn_Kartu108_BrgD1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%','%','%',@JLap)  A
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
			WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
			WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)  
	      		AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) --AND (A.Kondisi >= 3)
	      		AND (A.KD_ASET LIKE @KD_ASET) AND (A.KD_ASET0 LIKE @KD_ASET0) AND (A.KD_ASET1 IN (2,3,4))
			AND (A.Tahun = @Tahun)

		UNION ALL		
	
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, NULL, NULL
		FROM fn_Kartu108_BrgE1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%','%','%',@JLap)  A
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
			WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
			WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)  
	      		AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) --AND (A.Kondisi >= 3)
	      		AND (A.KD_ASET LIKE @KD_ASET) AND (A.KD_ASET0 LIKE @KD_ASET0) AND (A.KD_ASET1 IN (2,3,4))
			AND (A.Tahun = @Tahun)

		UNION ALL

		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
	       		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, NULL AS Lokasi, NULL AS Luas_Lantai
		FROM fn_Kartu108_BrgL1(@Tahun,@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%', @JLap)  A 
		WHERE  (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
			WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
			WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)  
	      		AND (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) --AND (A.Kondisi < 3)
	      		AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)
			AND (A.KD_ASET LIKE @KD_ASET) AND (A.KD_ASET0 LIKE @KD_ASET0) AND (A.KD_ASET1 IN (3))
			AND (A.Tahun = @Tahun)
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
	       		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga
	END


--------------------------------------------------


	SELECT J.Kd_BidangA, J.Kd_UnitA, J.Kd_SubA, J.Kd_UPBA, E.Nm_Provinsi, D.Nm_Kab_Kota,
		J.Nm_Bidang_Gab, J.Nm_Unit_Gab, J.Nm_Sub_Unit_Gab, J.Nm_UPB_Gab, 
		CASE WHEN (A.KD_ASET = 1 AND A.KD_ASET0 = 5) THEN 'ASET LAINNYA' ELSE 
		UPPER(H.Nm_Aset1) END AS Judul,
		
		RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 3) AS Kd_Gab_Sub,
		RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 3) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_UPB), 3) AS Kd_UPB,
		--A.Kd_UPB, 
		G.Nm_UPB, 
		--A.Kd_Aset2, 
		CONVERT(varchar, A.Kd_Aset) + '.' + CONVERT(varchar, A.Kd_Aset0) + '.' + CONVERT(varchar, A.Kd_Aset1) + '.' + CONVERT(varchar, A.Kd_Aset2) AS Kd_Aset2, 
		I.Nm_Aset2, F.Nm_Aset4,
		B.Nm_Aset5, A.Alamat, A.Luas, A.Total, ISNULL(A.Harga, 0) AS Harga, D.Nm_Kab_Kota AS Nm_Pemda,
		J.Nm_Pimpinan, J.Nip_Pimpinan, J.Jbt_Pimpinan, J.Nm_Pengurus, J.Nip_Pengurus, J.Jbt_Pengurus
	FROM
		(
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Alamat, A.Luas,
			SUM(A.Harga) AS Harga, SUM(A.Total) AS Total
		FROM
			(
			SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
				A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, YEAR(A.Tgl_Perolehan) AS Tahun,
				SUM(A.Harga) AS Harga, A.Alamat, A.Luas, COUNT(*) AS Total
			 FROM @tmpBI A 
			 GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				  A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Pemilik, YEAR(A.Tgl_Perolehan), A.Alamat, A.Luas
			) A
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Alamat, A.Luas
		) A INNER JOIN
		Ref_Rek5_108 B ON A.Kd_Aset = B.Kd_Aset AND A.Kd_Aset0 = B.Kd_Aset0 AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
		Ref_Rek4_108 F ON A.Kd_Aset = F.Kd_Aset AND A.Kd_Aset0 = F.Kd_Aset0 AND B.Kd_Aset1 = F.Kd_Aset1 AND B.Kd_Aset2 = F.Kd_Aset2 AND B.Kd_Aset3 = F.Kd_Aset3 AND B.Kd_Aset4 = F.Kd_Aset4 INNER JOIN
		Ref_Rek1_108 H ON A.Kd_Aset = H.Kd_Aset AND A.Kd_Aset0 = H.Kd_Aset0 AND A.Kd_Aset1 = H.Kd_Aset1 INNER JOIN --AND A.Kd_Aset2 = H.Kd_Aset2 AND A.Kd_Aset3 = H.Kd_Aset3 INNER JOIN
		Ref_Rek2_108 I ON A.Kd_Aset = I.Kd_Aset AND A.Kd_Aset0 = I.Kd_Aset0 AND A.Kd_Aset1 = I.Kd_Aset1 AND A.Kd_Aset2 = I.Kd_Aset2 INNER JOIN
		Ref_Kab_Kota D ON A.Kd_Prov = D.Kd_Prov AND A.Kd_Kab_Kota = D.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi E ON D.Kd_Prov = E.Kd_Prov INNER JOIN
		Ref_UPB G ON A.Kd_Prov = G.Kd_Prov AND A.Kd_Kab_Kota = G.Kd_Kab_Kota AND A.Kd_Bidang = G.Kd_Bidang AND A.Kd_Unit = G.Kd_Unit AND A.Kd_Sub = G.Kd_Sub AND A.Kd_UPB = G.Kd_UPB,
		(
		SELECT @Kd_Bidang AS Kd_BidangA, @Kd_Unit AS Kd_UnitA, @Kd_Sub AS Kd_SubA, @Kd_UPB AS Kd_UPBA, 
			RIGHT('0' + @Kd_Bidang, 2) AS Kd_Bidang_Gab,
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) AS Kd_Unit_Gab,
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) + '.' + RIGHT('0' + @Kd_Sub, 3) AS Kd_Sub_Gab,
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) + '.' + RIGHT('0' + @Kd_Sub, 3) + '.' + RIGHT('0' + @Kd_UPB, 3) AS Kd_UPB_Gab,
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
			WHERE (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			ORDER BY Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			) F ON A.Tahun = F.Tahun AND A.Kd_Prov = F.Kd_Prov AND A.Kd_Kab_Kota = F.Kd_Kab_Kota AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB
		) J
	GROUP BY J.Kd_BidangA, J.Kd_UnitA, J.Kd_SubA, J.Kd_UPBA, E.Nm_Provinsi, D.Nm_Kab_Kota,
			J.Nm_Bidang_Gab, J.Nm_Unit_Gab, J.Nm_Sub_Unit_Gab, J.Nm_UPB_Gab, H.Nm_Aset1, I.Nm_Aset2,
			A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1,A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_UPB, G.Nm_UPB, F.Nm_Aset4, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub,
			B.Nm_Aset5, A.Alamat, A.Luas, A.Total, D.Nm_Kab_Kota, A.Harga,
			J.Nm_Pimpinan, J.Nip_Pimpinan, J.Jbt_Pimpinan, J.Nm_Pengurus, J.Nip_Pengurus, J.Jbt_Pengurus
	ORDER BY A.Kd_Bidang, A.Kd_Unit, Kd_Gab_Sub, Kd_UPB, A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5

GO
