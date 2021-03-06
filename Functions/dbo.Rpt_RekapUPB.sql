USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** Rpt_RekapUPB - 05012016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE dbo.Rpt_RekapUPB @Tahun varchar(4), @Kd_Pemilik Varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D2 Datetime
WITH ENCRYPTION
AS
/*
DECLARE  @Tahun varchar(4), @Kd_Pemilik Varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D2 Datetime
SET @Tahun = '2009'
SET @Kd_Pemilik	= ''
SET @Kd_Prov	= '13'
SET @Kd_Kab_Kota= '4'
SET @Kd_Bidang	= '1'
SET @Kd_Unit	= ''
SET @Kd_Sub	= ''
SET @Kd_UPB	= ''
SET @D2 = '20111231'
*/

	IF ISNULL(@Kd_Pemilik, '') = '' SET @Kd_Pemilik = '%'
	IF ISNULL(@Kd_Prov, '') = '' SET @Kd_Prov = '%'
	IF ISNULL(@Kd_Kab_Kota, '') = '' SET @Kd_Kab_Kota = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'


	DECLARE @tmpRekapUPB TABLE (Kd_Pemilik tinyint, Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB smallint, 
				Tanah Money, Peralatan Money, Gedung Money, Jalan Money, Lain Money, Kdp Money)

	DECLARE @JLap Tinyint SET @JLap = 1

	INSERT INTO @tmpRekapUPB
	SELECT A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, SUM (A.Harga) AS Tanah, 0 AS Peralatan, 0 AS Gedung, 0 AS Jalan, 0 AS Lain, 0 AS Kdp
	FROM fn_Kartu_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%','%','%','%',@JLap)  A
	WHERE A.Kd_Pemilik LIKE @Kd_Pemilik AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit
		AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	GROUP BY A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
	ORDER BY A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
	
	INSERT INTO @tmpRekapUPB
	SELECT A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 0 AS Tanah, SUM (A.Harga) AS Peralatan, 0 AS Gedung, 0 AS Jalan, 0 AS Lain, 0 AS Kdp
	FROM fn_Kartu_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%','%','%','%',@JLap)  A
	WHERE A.Kd_Pemilik LIKE @Kd_Pemilik AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit
		AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	GROUP BY A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
	ORDER BY A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB

	INSERT INTO @tmpRekapUPB
	SELECT A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 0 AS Tanah, 0 AS Peralatan, SUM (A.Harga) AS Gedung, 0 AS Jalan, 0 AS Lain, 0 AS Kdp
	FROM fn_Kartu_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%','%','%','%',@JLap)  A
	WHERE A.Kd_Pemilik LIKE @Kd_Pemilik AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit
		AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	GROUP BY A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
	ORDER BY A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB

	INSERT INTO @tmpRekapUPB
	SELECT A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 0 AS Tanah, 0 AS Peralatan, 0 AS Gedung, SUM (A.Harga) AS Jalan, 0 AS Lain, 0 AS Kdp
	FROM fn_Kartu_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%','%','%','%',@JLap)  A
	WHERE A.Kd_Pemilik LIKE @Kd_Pemilik AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit
		AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	GROUP BY A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
	ORDER BY A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB

	INSERT INTO @tmpRekapUPB
	SELECT A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 0 AS Tanah, 0 AS Peralatan, 0 AS Gedung, 0 AS Jalan, SUM (A.Harga) AS Lain, 0 AS Kdp
	FROM fn_Kartu_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%','%','%','%',@JLap)  A
	WHERE A.Kd_Pemilik LIKE @Kd_Pemilik AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit
		AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	GROUP BY A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
	ORDER BY A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB

	INSERT INTO @tmpRekapUPB
	SELECT A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 0 AS Tanah, 0 AS Peralatan, 0 AS Gedung, 0 AS Jalan, 0 AS Lain, SUM (A.Harga) AS Kdp
	FROM fn_Kartu_BrgF(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%','%','%','%',@JLap)  A
	WHERE A.Kd_Pemilik LIKE @Kd_Pemilik AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit
		AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	GROUP BY A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
	ORDER BY A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB


	SELECT  RIGHT('0' + A.Kd_Pemilik,2) AS Kd_Pemilik,
		RIGHT('0' + A.Kd_Pemilik,2)+'.'+RIGHT('0' + A.Kd_Prov,2) AS Kd_Prov, 
		RIGHT('0' + A.Kd_Pemilik,2)+'.'+RIGHT('0' + A.Kd_Prov,2)+'.'+RIGHT('0' + A.Kd_Kab_Kota,2) AS Kd_Kab_Kota_Gab,
		RIGHT('0' + A.Kd_Pemilik,2)+'.'+RIGHT('0' + A.Kd_Bidang,2) AS Kd_Bidang,
		RIGHT('0' + A.Kd_Pemilik,2)+'.'+RIGHT('0' + A.Kd_Bidang,2) +'.'+ RIGHT('000' + A.Kd_Unit,3)AS Kd_Unit_Gab,
		RIGHT('0' + A.Kd_Pemilik,2)+'.'+RIGHT('0' + A.Kd_Bidang,2) +'.'+ RIGHT('000' + A.Kd_Unit,3)+'.'+RIGHT('000' + A.Kd_Sub,3) AS Kd_Sub_Gab,
		RIGHT('0' + A.Kd_Pemilik,2)+'.'+RIGHT('0' + A.Kd_Bidang,2) +'.'+ RIGHT('000' + A.Kd_Unit,3)+'.'+RIGHT('000' + A.Kd_Sub,3)+'.'+ RIGHT('0000' + A.Kd_UPB,4) AS Kd_UPB_Gab,
		A.Tanah, A.Peralatan, A.Gedung, A.Jalan, A.Lain, A.KDP, A.Total,
		A.Nm_Pemilik, A.Nm_Bidang, A.Nm_Unit, A.Nm_Sub_Unit, A.Nm_UPB, A.Nm_Pemda, A.Nm_Provinsi
	FROM
	(
	SELECT RIGHT('0' + A.Kd_Pemilik,2) AS Kd_Pemilik, RIGHT('0' + A.Kd_Prov,2) AS Kd_Prov, RIGHT('0' + A.Kd_Kab_Kota,2) AS Kd_Kab_Kota, RIGHT('0' + A.Kd_Bidang,2) AS Kd_Bidang, RIGHT('000' + A.Kd_Unit,3) AS Kd_Unit, RIGHT('000' + A.Kd_Sub,3) AS Kd_Sub, RIGHT('000' + A.Kd_UPB,4) AS Kd_UPB, 
		SUM(A.Tanah) AS Tanah, SUM(A.Peralatan) AS Peralatan, SUM(A.Gedung) AS Gedung, SUM(A.Jalan) AS Jalan, SUM(A.Lain) AS Lain, SUM(A.Kdp) AS KDP,
		SUM(A.Tanah + A.Peralatan + A.Gedung + A.Jalan + A.Lain + A.KDP) AS Total,
		G.Nm_UPB, H.Nm_Sub_Unit, I.Nm_Unit, J.Nm_Bidang,   K.Nm_Pemda, M.Nm_Provinsi, L.Nm_Pemilik
	FROM @tmpRekapUPB A INNER JOIN
	Ref_UPB G ON A.Kd_Prov = G.Kd_Prov AND A.Kd_Kab_Kota = G.Kd_Kab_Kota AND A.Kd_Bidang = G.Kd_bidang AND A.Kd_Unit = G.Kd_Unit AND A.Kd_Sub = G.Kd_Sub AND A.Kd_UPB = G.Kd_UPB INNER JOIN	
	Ref_Sub_Unit H ON H.Kd_Prov = G.Kd_Prov AND H.Kd_Kab_Kota = G.Kd_Kab_Kota AND H.Kd_Bidang = G.Kd_Bidang AND H.Kd_Unit = G.Kd_Unit AND H.Kd_Sub = G.Kd_Sub INNER JOIN
	Ref_Unit I ON H.Kd_Prov = I.Kd_Prov AND H.Kd_Kab_Kota = I.Kd_Kab_Kota AND H.Kd_Bidang = I.Kd_Bidang AND H.Kd_Unit = I.Kd_Unit INNER JOIN
	Ref_Bidang J ON I.Kd_Bidang = J.Kd_Bidang INNER JOIN
	Ref_PEMDA K ON A.Kd_Prov = K.Kd_Prov AND A.Kd_Kab_Kota = K.Kd_Kab_Kota INNER JOIN
	Ref_Pemilik L ON A.kd_Pemilik = L.Kd_Pemilik INNER JOIN
	Ref_Provinsi M ON A.Kd_Prov = M.Kd_Prov
	GROUP BY A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
	G.Nm_UPB, H.Nm_Sub_Unit, I.Nm_Unit, J.Nm_Bidang,   K.Nm_Pemda, M.Nm_Provinsi, L.Nm_Pemilik
	) A
	GROUP BY A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Nm_UPB,
	A.Tanah, A.Peralatan, A.Gedung, A.Jalan, A.Lain, A.KDP, A.Total,
	A.Nm_Pemilik, A.Nm_Bidang, A.Nm_Unit, A.Nm_Sub_Unit, A.Nm_UPB, A.Nm_Pemda, A.Nm_Provinsi
	ORDER BY A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB




GO
