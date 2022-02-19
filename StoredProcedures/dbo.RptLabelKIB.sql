USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[RptLabelKIB] @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @KdKIB varchar(1), @D1 datetime, @D2 datetime
WITH ENCRYPTION
AS
/*
DECLARE @D1 datetime, @D2 datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @KdKIB varchar(1)
SET @D1 = ''
SET @D2 = '20101231'
SET @Kd_Prov = '11'
SET @Kd_Kab_Kota = '28'
SET @Kd_Bidang = '4'
SET @Kd_Unit = '1'
SET @Kd_Sub = '3'
SET @Kd_UPB = '1'
SET @KdKIB = 'B'
*/
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
        IF ISNULL(@D1, '') = '' SET @D1 = '19000101'

	IF @KdKIB = 'A'
	BEGIN
		SELECT
			dbo.fn_KdLokasi(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi,
			REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') + '.' + RIGHT('0000' + CONVERT(varchar, A.No_Register), 4) AS Kd_Gab_Brg
			, B.Logo, B.Nm_Pemda,D.Nm_Aset5,
			'-' as Kd_Ruang
		FROM fn_Kartu_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',1)  A INNER JOIN 
			Ref_Pemda B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota INNER JOIN
			Ref_Rek_Aset5 D ON A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
                      AND (A.Tgl_Pembukuan BETWEEN @D1 AND @D2) 
	END
	ELSE IF @KdKIB = 'B'
	BEGIN
		SELECT
			dbo.fn_KdLokasi(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi,
			REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') + '.' + RIGHT('0000' + CONVERT(varchar, A.No_Register), 4) As Kd_Gab_Brg
			--+ '.' + (case  when A.Kd_Ruang is null then '000' else RIGHT('000' + CONVERT(varchar, A.Kd_Ruang), 3)end ) AS Kd_Gab_Brg --dari akur
			, B.Logo, B.Nm_Pemda, D.Nm_Aset5,
			case  when A.Kd_Ruang is null then '000' else RIGHT('000' + CONVERT(varchar, A.Kd_Ruang), 3)end as Kd_Ruang
		FROM fn_Kartu_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',1)  A INNER JOIN 
			Ref_Pemda B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota INNER JOIN
			Ref_Rek_Aset5 D ON A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
                      AND (A.Tgl_Pembukuan BETWEEN @D1 AND @D2)
			ORDER BY A.Kd_Ruang
	END
	ELSE IF @KdKIB = 'C'
	BEGIN
		SELECT
			dbo.fn_KdLokasi(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi,
			REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') + '.' + RIGHT('0000' + CONVERT(varchar, A.No_Register), 4) AS Kd_Gab_Brg
			, B.Logo, B.Nm_Pemda,D.Nm_Aset5,'-' as Kd_Ruang
		FROM fn_Kartu_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',1)  A INNER JOIN 
			Ref_Pemda B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota INNER JOIN
			Ref_Rek_Aset5 D ON A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
                      AND (A.Tgl_Pembukuan BETWEEN @D1 AND @D2) 
	END
	ELSE IF @KdKIB = 'D'
	BEGIN
		SELECT
			dbo.fn_KdLokasi(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi,
			REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') + '.' + RIGHT('0000' + CONVERT(varchar, A.No_Register), 4) AS Kd_Gab_Brg
			, B.Logo, B.Nm_Pemda,D.Nm_Aset5,'-' as Kd_Ruang
		FROM fn_Kartu_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',1)  A INNER JOIN 
			Ref_Pemda B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota INNER JOIN
			Ref_Rek_Aset5 D ON A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
                      AND (A.Tgl_Pembukuan BETWEEN @D1 AND @D2)
	END
	ELSE IF @KdKIB = 'E'
	BEGIN
		SELECT
			dbo.fn_KdLokasi(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi,
			REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') + '.' + RIGHT('0000' + CONVERT(varchar, A.No_Register), 4) + '.' + (case  when A.Kd_Ruang is null then '000' else RIGHT('000' + CONVERT(varchar, A.Kd_Ruang), 3)end )  AS Kd_Gab_Brg
			, B.Logo, B.Nm_Pemda,D.Nm_Aset5,
			case  when A.Kd_Ruang is null then '000' else RIGHT('000' + CONVERT(varchar, A.Kd_Ruang), 3)end as Kd_Ruang
		FROM fn_Kartu_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',1)  A INNER JOIN 
			Ref_Pemda B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota INNER JOIN
			Ref_Rek_Aset5 D ON A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
                      AND (A.Tgl_Pembukuan BETWEEN @D1 AND @D2)
		ORDER BY A.Kd_Ruang
	END
	ELSE
	BEGIN
		SELECT '' AS Kd_Lokasi, '' AS Kd_Gab_Brg, '' AS Nm_Aset5, '' AS Kd_Ruang
		WHERE 1 = 2
	END 


GO
