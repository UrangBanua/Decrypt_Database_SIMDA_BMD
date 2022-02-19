USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** RptJenisBarangPerUPB - 29012016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE RptJenisBarangPerUPB @Tahun Varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @Kd_Pemilik Varchar(3), @Asal varchar(50), @D2 Datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun Varchar(4), @D2 Datetime,  @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @Kd_Pemilik Varchar(3), @Asal varchar(50)
SET @Tahun = '2016'
SET @D2 = '20161231'
SET @Kd_Pemilik	= '12'
SET @Kd_Prov = '30'
SET @Kd_Kab_Kota = '2'
SET @Kd_Bidang = '8'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset1 = '5'
SET @Kd_Aset2 = '' 
SET @Kd_Aset3 = ''
SET @Kd_Aset4 = ''
SET @Kd_Aset5 = ''
SET @Asal = ''
*/
	DECLARE @tmpBI TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, Kd_Pemilik tinyint, 
	Asal_Usul varchar(50), Kondisi varchar(20), Tgl_Perolehan datetime, Tgl_Pembukuan datetime, No_Dokumen varchar(255), Harga money, Keterangan varchar(255))

	DECLARE @JLap Tinyint SET @JLap = 0

	IF ISNULL(@Kd_Pemilik, '') = '' SET @Kd_Pemilik = '%'
	IF ISNULL(@Kd_Prov, '') = '' SET @Kd_Prov = '%'
	IF ISNULL(@Kd_Kab_Kota, '') = '' SET @Kd_Kab_Kota = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	IF ISNULL(@Kd_Aset1, '') = '' SET @Kd_Aset1 = '%'
	IF ISNULL(@Kd_Aset2, '') = '' SET @Kd_Aset2 = '%'
	IF ISNULL(@Kd_Aset3, '') = '' SET @Kd_Aset3 = '%'
	IF ISNULL(@Kd_Aset4, '') = '' SET @Kd_Aset4 = '%'
	IF ISNULL(@Kd_Aset5, '') = '' SET @Kd_Aset5 = '%'
	IF ISNULL(@Asal, '') = '' SET @Asal = '%'


	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, 'Baik' AS Kondisi, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Sertifikat_Nomor AS No_Dokumen, A.Harga, A.Keterangan
	FROM fn_Kartu_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      AND (A.Kd_Pemilik LIKE @Kd_Pemilik) AND A.Asal_usul LIKE @Asal
	      AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, C.Uraian AS Kondisi, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Polisi AS No_Dokumen, A.Harga, A.Keterangan
	FROM fn_Kartu_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
		Ref_Kondisi C ON A.Kondisi = C.Kd_Kondisi
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      AND (A.Kd_Pemilik LIKE @Kd_Pemilik) AND A.Asal_usul LIKE @Asal
	      AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5

	INSERT INTO @tmpBI

	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, C.Uraian AS Kondisi, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Dokumen_Nomor AS No_Dokumen, A.Harga, A.Keterangan
	FROM fn_Kartu_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
		Ref_Kondisi C ON A.Kondisi = C.Kd_Kondisi
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      AND (A.Kd_Pemilik LIKE @Kd_Pemilik) AND A.Asal_usul LIKE @Asal
	      AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, C.Uraian AS Kondisi, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Dokumen_Nomor AS No_Dokumen, A.Harga, A.Keterangan
	FROM fn_Kartu_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
		Ref_Kondisi C ON A.Kondisi = C.Kd_Kondisi
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      AND (A.Kd_Pemilik LIKE @Kd_Pemilik) AND A.Asal_usul LIKE @Asal
		AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, C.Uraian AS Kondisi, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Judul AS No_Dokumen, 
		A.Harga, A.Keterangan
	FROM fn_Kartu_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
		Ref_Kondisi C ON A.Kondisi = C.Kd_Kondisi
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      AND (A.Kd_Pemilik LIKE @Kd_Pemilik) AND A.Asal_usul LIKE @Asal
	      AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Kd_Pemilik, A.Asal_usul, C.Uraian AS Kondis, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Dokumen_Nomor AS No_Dokumen, A.Harga, A.Keterangan
	FROM fn_Kartu_BrgF(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
		Ref_Kondisi C ON A.Kondisi = C.Kd_Kondisi
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	      AND (A.Kd_Pemilik LIKE @Kd_Pemilik) AND A.Asal_usul LIKE @Asal
	      AND @Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5


	SELECT M.Nm_Pemda, L.Nm_Provinsi, K.Nm_Kab_KOta, J.Nm_Bidang, I.Nm_Unit, H.Nm_Sub_Unit, G.Nm_UPB, 
		A.Kd_Prov, A.Kd_Kab_Kota,
		RIGHT('00' + CONVERT(varchar, A.Kd_Prov),2) AS Kd_GabProv,
		RIGHT('00' + CONVERT(varchar, A.Kd_Prov),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Kab_Kota),2) AS Kd_Gabkab, 
		A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
		RIGHT('00' + CONVERT(varchar, A.Kd_Bidang),2) AS Kd_Gabbidang,
		RIGHT('00' + CONVERT(varchar, A.Kd_Bidang),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Unit),2) AS Kd_Gabunit,
		RIGHT('00' + CONVERT(varchar, A.Kd_Bidang),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Unit),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Sub),2) AS Kd_Gabsub,
		RIGHT('00' + CONVERT(varchar, A.Kd_Bidang),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Unit),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Sub),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_UPB),3) AS Kd_GabUPB, 
		A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		RIGHT('00' + CONVERT(varchar, A.Kd_Aset1),2) AS Kd_Gab1,
		RIGHT('00' + CONVERT(varchar, A.Kd_Aset1),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset2),2) AS Kd_Gab2,
		RIGHT('00' + CONVERT(varchar, A.Kd_Aset1),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset2),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset3),2) AS Kd_Gab3,
		RIGHT('00' + CONVERT(varchar, A.Kd_Aset1),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset2),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset3),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset4),3) AS Kd_Gab4,
		RIGHT('00' + CONVERT(varchar, A.Kd_Aset1),2) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset2),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset3),2)+ ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset4),3) + ' . ' + RIGHT('00' + CONVERT(varchar, A.Kd_Aset5),3)AS Kd_Gab5, 
		A.No_Register, B.Nm_Aset1, C.Nm_Aset2, D.Nm_Aset3, E.Nm_Aset4, F.Nm_Aset5, 
		A.Kd_Pemilik, A.Asal_usul, A.Kondisi, A.Tgl_Perolehan, A.No_Dokumen, A.Harga, A.Keterangan,
		N.Nm_Pimpinan, N.Nip_Pimpinan, N.Jbt_Pimpinan, N.Nm_Pengurus, N.Nip_Pengurus, N.Jbt_Pengurus
	FROM @tmpBI A INNER JOIN
		Ref_Rek_Aset5 F ON A.Kd_Aset1 = F.Kd_Aset1 AND A.Kd_Aset2 = F.Kd_Aset2 AND A.Kd_Aset3 = F.Kd_Aset3 AND A.Kd_Aset4 = F.Kd_Aset4  AND A.Kd_Aset5 = F.Kd_Aset5 INNER JOIN
		Ref_Rek_Aset4 E ON F.Kd_Aset1 = E.Kd_Aset1 AND F.Kd_Aset2 = E.Kd_Aset2 AND F.Kd_Aset3 = E.Kd_Aset3 AND F.Kd_Aset4 = E.Kd_Aset4 INNER JOIN
		Ref_Rek_Aset3 D ON E.Kd_Aset1 = D.Kd_Aset1 AND E.Kd_Aset2 = D.Kd_Aset2 AND E.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
		Ref_Rek_Aset2 C ON D.Kd_Aset1 = C.Kd_Aset1 AND D.Kd_Aset2 = C.Kd_Aset2 INNER JOIN
		Ref_Rek_Aset1 B ON C.Kd_Aset1 = B.Kd_Aset1 INNER JOIN
		Ref_UPB G ON A.Kd_Prov = G.Kd_Prov AND A.Kd_Kab_Kota = G.Kd_Kab_Kota AND A.Kd_Bidang = G.Kd_Bidang AND A.Kd_Unit = G.Kd_Unit AND A.Kd_Sub = G.Kd_Sub AND A.Kd_UPB = G.Kd_UPB INNER JOIN
		Ref_Sub_Unit H ON G.Kd_Prov = H.Kd_Prov AND G.Kd_Kab_Kota = H.Kd_Kab_Kota AND G.Kd_Bidang = H.Kd_Bidang AND G.Kd_Unit = H.Kd_Unit AND G.Kd_Sub = H.Kd_Sub INNER JOIN
		Ref_Unit I ON H.Kd_Prov = I.Kd_Prov AND H.Kd_Kab_Kota = I.Kd_Kab_Kota AND H.Kd_Bidang = I.Kd_Bidang AND H.Kd_Unit = I.Kd_Unit INNER JOIN
		Ref_Bidang J ON I.Kd_Bidang = J.Kd_Bidang INNER JOIN
		Ref_Kab_Kota K ON A.Kd_Prov = K.Kd_Prov AND A.Kd_Kab_Kota = K.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi L ON K.Kd_Prov = L.Kd_Prov INNER JOIN
		Ref_Pemda M ON K.Kd_Prov = M.Kd_Prov AND K.Kd_Kab_Kota = M.Kd_Kab_Kota,
		(
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Nm_Pimpinan, A.Nip_Pimpinan, A.Jbt_Pimpinan,
			A.Nm_Pengurus, A.Nip_Pengurus, A.Jbt_Pengurus
		FROM Ta_UPB A INNER JOIN
			(
			SELECT TOP 1 Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			FROM Ta_UPB
			WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			ORDER BY Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			) B ON A.Tahun = B.Tahun AND A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
		) N


GO
