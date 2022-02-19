USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RptRKBU] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4), @Renc varchar(1)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4), @Renc varchar(1)
SET @Tahun = '2020'
SET @Kd_Prov = '99'
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
--SET @Renc = '0'
---*/
	IF ISNULL(@Kd_Prov, '') = '' SET @Kd_Prov = '%'
	IF ISNULL(@Kd_Kab_Kota, '') = '' SET @Kd_Kab_Kota = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'


--SELECT * FROM Ta_RKBU

	SELECT D.Kd_ProvA, D.Kd_Kab_KotaA, D.Kd_BidangA, D.Kd_UnitA, D.Kd_SubA, D.Kd_UPBA,
		D.Nm_Provinsi, D.Nm_Kab_Kota, D.Nm_Bidang, D.Nm_Unit, D.Nm_Sub_Unit, D.Nm_UPB,
		CASE @Renc
		WHEN '0' THEN
			CASE @Kd_Bidang
			WHEN '%' THEN 'DAFTAR RENCANA KEBUTUHAN BARANG DAERAH (DRKBD)'
			ELSE 'DAFTAR RENCANA KEBUTUHAN BARANG UNIT (DRKBU)'
			END
		ELSE
			CASE @Kd_Bidang
			WHEN '%' THEN 'DAFTAR KEBUTUHAN BARANG DAERAH (DKBD)'
			ELSE 'DAFTAR KEBUTUHAN BARANG UNIT (DKBU)'
			END
		END AS Judul,
		CASE
		WHEN ISNULL(A.Merk, '') = '' AND ISNULL(A.Type, '') = '' AND ISNULL(A.Ukuran, '') = '' THEN ''
		WHEN ISNULL(A.Merk, '') = '' AND ISNULL(A.Type, '') = '' THEN A.Ukuran
		WHEN ISNULL(A.Merk, '') = '' AND ISNULL(A.Ukuran, '') = '' THEN A.Type
		WHEN ISNULL(A.Type, '') = '' AND ISNULL(A.Ukuran, '') = '' THEN A.Merk
		WHEN ISNULL(A.Merk, '') = '' THEN A.Type + CHAR(13) + CHAR(10) + A.Ukuran
		WHEN ISNULL(A.Type, '') = '' THEN A.Merk + CHAR(13) + CHAR(10) + A.Ukuran
		WHEN ISNULL(A.Ukuran, '') = '' THEN A.Merk + '/' + A.Type
		ELSE A.Merk + '/' + A.Type + CHAR(13) + CHAR(10) + A.Ukuran
		END AS Merk,
		B.Nm_Aset5, A.Jumlah, A.Harga, A.Jumlah * A.Harga AS Total,
		dbo.fn_GabRekening(A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5) AS Kd_Gab_Rek, A.Keterangan,
		D.Nm_Pimpinan, D.Nip_Pimpinan, D.Jbt_Pimpinan, NULL AS Logo
	FROM Ta_RKBU A INNER JOIN
		Ref_Rek5_108 B ON A.Kd_Aset8 = B.Kd_Aset AND  A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5, --INNER JOIN
		--Ref_Pemda C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota,
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
		) D
	WHERE (A.Tahun = @Tahun) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota)
		AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)







GO
