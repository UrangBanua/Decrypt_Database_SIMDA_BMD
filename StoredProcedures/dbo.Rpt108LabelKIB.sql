USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.Rpt108LabelKIB @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @KdKIB varchar(1), @D1 datetime, @D2 datetime
WITH ENCRYPTION
AS
/*
DECLARE @D1 datetime, @D2 datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @KdKIB varchar(1)
SET @D1 = '20001201'
SET @D2 = '20181231'
SET @Kd_Prov = '23'
SET @Kd_Kab_Kota = '8'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @KdKIB = 'E'
--*/
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
        IF ISNULL(@D1, '') = '' SET @D1 = '20190131' --'19000101'

	DECLARE @JLap Tinyint SET @JLap = 1




	IF @KdKIB = 'A'
	BEGIN
		SELECT
			dbo.fn_KdLokasi_108(A.Kd_Pemilik, A.Kd_KA, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi, 
			REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') + '.' + RIGHT('000000' + CONVERT(varchar, A.No_Register), 6) AS Kd_Gab_Brg,
			B.Logo, B.Nm_Pemda, 0 as Kd_Ruang, C.Nm_Aset5
		FROM fn_Kartu108_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A INNER JOIN 
			Ref_Pemda B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota
			INNER JOIN Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5

		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
                      AND (A.Tgl_Pembukuan BETWEEN @D1 AND @D2)
		      AND (A.Kd_Aset = 1 AND A.Kd_Aset0 = 3)
	END
	ELSE IF @KdKIB = 'B'
	BEGIN
		SELECT
			dbo.fn_KdLokasi_108(A.Kd_Pemilik, A.Kd_KA, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi, 
			REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') + '.' + RIGHT('000000' + CONVERT(varchar, A.No_Register), 6) AS Kd_Gab_Brg,
			B.Logo, B.Nm_Pemda, isnull(A.Kd_Ruang,0) as Kd_Ruang, C.Nm_Aset5
		FROM fn_Kartu108_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A INNER JOIN 
			Ref_Pemda B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota
			INNER JOIN Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5

		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
                      AND (A.Tgl_Pembukuan BETWEEN @D1 AND @D2)
		      AND (A.Kd_Aset = 1 AND A.Kd_Aset0 = 3)

	END
	ELSE IF @KdKIB = 'C'
	BEGIN
		SELECT
			dbo.fn_KdLokasi_108(A.Kd_Pemilik, A.Kd_KA, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi, 
			REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') + '.' + RIGHT('000000' + CONVERT(varchar, A.No_Register), 6) AS Kd_Gab_Brg,
			B.Logo, B.Nm_Pemda, 0 as Kd_Ruang, C.Nm_Aset5
		FROM fn_Kartu108_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A INNER JOIN 
			Ref_Pemda B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota
			INNER JOIN Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5

		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
                      AND (A.Tgl_Pembukuan BETWEEN @D1 AND @D2)
		      AND (A.Kd_Aset = 1 AND A.Kd_Aset0 = 3)
	END
	ELSE IF @KdKIB = 'D'
	BEGIN
		SELECT
			dbo.fn_KdLokasi_108(A.Kd_Pemilik, A.Kd_KA, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi, 
			REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') + '.' + RIGHT('000000' 
+ CONVERT(varchar, A.No_Register), 6) AS Kd_Gab_Brg,
			B.Logo, B.Nm_Pemda, 0 as Kd_Ruang, C.Nm_Aset5
		FROM fn_Kartu108_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A INNER JOIN 
			Ref_Pemda B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota
			INNER JOIN Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5

		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
                      AND (A.Tgl_Pembukuan BETWEEN @D1 AND @D2)
		      AND (A.Kd_Aset = 1 AND A.Kd_Aset0 = 3)

	END
	ELSE IF @KdKIB = 'E'
	BEGIN
		SELECT
			dbo.fn_KdLokasi_108(A.Kd_Pemilik, A.Kd_KA, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi, 
			REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') + '.' + RIGHT('000000' + CONVERT(varchar, A.No_Register), 6) AS Kd_Gab_Brg,
			B.Logo, B.Nm_Pemda, isnull(A.Kd_Ruang,0) as Kd_Ruang, C.Nm_Aset5
		FROM fn_Kartu108_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A INNER JOIN 
			Ref_Pemda B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota
			INNER JOIN Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5

		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
                      AND (A.Tgl_Pembukuan BETWEEN @D1 AND @D2)
		      AND (A.Kd_Aset = 1 AND A.Kd_Aset0 = 3)
	END
	ELSE
	BEGIN
		SELECT '' AS Kd_Lokasi, '' AS Kd_Gab_Brg
		WHERE 1 = 2
	END 















GO
