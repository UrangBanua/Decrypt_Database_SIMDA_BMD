USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** RptDHP - 12122015 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE [dbo].[RptDHP] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4), @D1 datetime, @D2 datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4), @D1 datetime, @D2 datetime
SET @Tahun = '2013'
SET @Kd_Prov = '99'
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @D1 = '20130101'
SET @D2 = '20131231'
*/
	IF ISNULL(@Kd_Prov, '') = '' SET @Kd_Prov = '%'
	IF ISNULL(@Kd_Kab_Kota, '') = '' SET @Kd_Kab_Kota = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

	DECLARE @Ta_Pemeliharaan_Rinc TABLE(Tahun smallint, No_SP2D varchar(50),  Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB smallint,
				Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, Kd_Pemilik tinyint, Tgl_Perolehan datetime, Tgl_Pembukuan datetime,
				Jns_Pemeliharaan varchar(50), Biaya money, Keterangan varchar(255))

	INSERT INTO @Ta_Pemeliharaan_Rinc (Tahun, No_SP2D, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5,
				No_Register, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Jns_Pemeliharaan, Biaya, Keterangan)
	SELECT A.Tahun, A.No_SP2D, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.No_Register, A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, B.Nm_Riwayat AS Jns_Pemeliharaan, A.Harga AS Biaya, A.Keterangan
	FROM Ta_KIBAR A INNER JOIN
		Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
	WHERE A.Kd_Riwayat IN(5,6)

	INSERT INTO @Ta_Pemeliharaan_Rinc (Tahun, No_SP2D, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5,
				No_Register, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Jns_Pemeliharaan, Biaya, Keterangan)
	SELECT A.Tahun, A.No_SP2D, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.No_Register, A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, B.Nm_Riwayat AS Jns_Pemeliharaan, A.Harga AS Biaya, A.Keterangan
	FROM Ta_KIBBR A INNER JOIN
		Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
	WHERE A.Kd_Riwayat IN(5,6)	

	
	INSERT INTO @Ta_Pemeliharaan_Rinc (Tahun, No_SP2D, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5,
				No_Register, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Jns_Pemeliharaan, Biaya, Keterangan)
	SELECT A.Tahun, A.No_SP2D, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.No_Register, A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, B.Nm_Riwayat AS Jns_Pemeliharaan, A.Harga AS Biaya, A.Keterangan
	FROM Ta_KIBCR A INNER JOIN
		Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
	WHERE A.Kd_Riwayat IN(5,6)

	INSERT INTO @Ta_Pemeliharaan_Rinc (Tahun, No_SP2D, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5,
				No_Register, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Jns_Pemeliharaan, Biaya, Keterangan)
	SELECT A.Tahun, A.No_SP2D, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.No_Register, A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, B.Nm_Riwayat AS Jns_Pemeliharaan, A.Harga AS Biaya, A.Keterangan
	FROM Ta_KIBDR A INNER JOIN
		Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
	WHERE A.Kd_Riwayat IN(5,6)

	INSERT INTO @Ta_Pemeliharaan_Rinc (Tahun, No_SP2D, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5,
				No_Register, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Jns_Pemeliharaan, Biaya, Keterangan)
	SELECT A.Tahun, A.No_SP2D, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.No_Register, A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, B.Nm_Riwayat AS Jns_Pemeliharaan, A.Harga AS Biaya, A.Keterangan
	FROM Ta_KIBER A INNER JOIN
		Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
	WHERE A.Kd_Riwayat IN(5,6)
	

	SELECT E.Kd_ProvA, E.Kd_Kab_KotaA, E.Kd_BidangA, E.Kd_UnitA, E.Kd_SubA,
		E.Nm_Provinsi, E.Nm_Kab_Kota, E.Nm_Bidang, E.Nm_Unit, E.Nm_Sub_Unit, E.Nm_UPB,
		REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Brg,
		C.Nm_Aset5, B.Tgl_Pemeliharaan, B.Nm_Rekanan, B.Tgl_SP2D, B.No_SP2D,
		RIGHT('0000' + CONVERT(varchar, A.No_Register), 4) AS No_Register, A.Jns_Pemeliharaan, A.Biaya,
		F.Nm_Unit AS Nm_Unit_Pengguna, A.Keterangan,
		E.Nm_Pimpinan, E.Nip_Pimpinan, E.Jbt_Pimpinan, NULL AS Logo
	FROM @Ta_Pemeliharaan_Rinc A INNER JOIN
		Ta_Pemeliharaan B ON A.Tahun = B.Tahun AND A.No_SP2D = B.No_SP2D INNER JOIN
		Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5 INNER JOIN
		--Ref_Pemda D ON B.Kd_Prov = D.Kd_Prov AND B.Kd_Kab_Kota = D.Kd_Kab_Kota INNER JOIN
		Ref_Unit F ON B.Kd_Bidang = F.Kd_Bidang AND B.Kd_Unit = F.Kd_Unit,
		(
		SELECT @Kd_Prov AS Kd_ProvA, @Kd_Kab_Kota AS Kd_Kab_KotaA, @Kd_Bidang AS Kd_BidangA, @Kd_Unit AS Kd_UnitA, @Kd_Sub AS Kd_SubA, @Kd_UPB AS Kd_UPBA,
			F.Nm_Provinsi, E.Nm_Kab_Kota, D.Nm_Bidang, C.Nm_Unit, B.Nm_Sub_Unit, H.Nm_UPB,
			A.Nm_Pimpinan AS Nm_Pimpinan, A.Nip_Pimpinan AS Nip_Pimpinan, A.Jbt_Pimpinan AS Jbt_Pimpinan
		FROM Ta_UPB A INNER JOIN
			Ref_UPB H ON A.Kd_Prov = H.Kd_Prov AND A.Kd_Kab_Kota = H.Kd_Kab_Kota AND A.Kd_Bidang = H.Kd_Bidang AND A.Kd_Unit = H.Kd_Unit AND A.Kd_Sub = H.Kd_Sub AND A.Kd_UPB = H.Kd_UPB INNER JOIN
			Ref_Sub_Unit B ON H.Kd_Prov = B.Kd_Prov AND H.Kd_Kab_Kota = B.Kd_Kab_Kota AND H.Kd_Bidang = B.Kd_Bidang AND H.Kd_Unit = B.Kd_Unit AND H.Kd_Sub = B.Kd_Sub INNER JOIN
			Ref_Unit C ON B.Kd_Prov = C.Kd_Prov AND B.Kd_Kab_Kota = C.Kd_Kab_Kota AND B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit INNER JOIN
			Ref_Bidang D ON C.Kd_Bidang = D.Kd_Bidang INNER JOIN
			Ref_Kab_Kota E ON A.Kd_Prov = E.Kd_Prov AND A.Kd_Kab_Kota = E.Kd_Kab_Kota INNER JOIN
			Ref_Provinsi F ON E.Kd_Prov = F.Kd_Prov INNER JOIN
			(
			SELECT TOP 1 A.Tahun, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
			FROM Ta_UPB A
			WHERE (A.Tahun = @Tahun) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
			ORDER BY A.Tahun, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
			) G ON A.Tahun = G.Tahun AND A.Kd_Prov = G.Kd_Prov AND A.Kd_Kab_Kota = G.Kd_Kab_Kota AND A.Kd_Bidang = G.Kd_Bidang AND A.Kd_Unit = G.Kd_Unit AND A.Kd_Sub = G.Kd_Sub AND A.Kd_UPB = G.Kd_UPB
		) E
	WHERE (B.Tgl_SP2D BETWEEN @D1 AND @D2) AND (B.Tahun = @Tahun) AND (B.Kd_Prov LIKE @Kd_Prov) AND (B.Kd_Kab_Kota LIKE @Kd_Kab_Kota)
		AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
	ORDER BY B.Tgl_SP2D, B.No_SP2D, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5

GO
