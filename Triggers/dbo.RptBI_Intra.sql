USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.RptBI_Intra @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D2 Datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D2 Datetime
SET @Tahun = '2016'
SET @Kd_Prov = '31'
SET @Kd_Kab_Kota = '9'
SET @Kd_Bidang = '8'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @D2 = '20161231'
*/
	DECLARE @tmpBI TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, Kd_Pemilik tinyint, No_Register int, 
		Tgl_Perolehan datetime, Tgl_Pembukuan datetime, Merk varchar(50), Type varchar(50), No_Sertifikat varchar(75), Bahan varchar(50), Asal_Usul varchar(50), Ukuran varchar(50), Satuan varchar(50), Kondisi varchar(2), Harga money)
	DECLARE @JLap Tinyint SET @JLap = 1
	
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'	

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
	       A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Sertifikat_Nomor, '-'), '', A.Asal_usul, A.Luas_M2, 'M2', 'B', A.Harga
	FROM fn_Kartu_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap) A 
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		 AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
									WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
									WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
								ELSE 12 END) 
		AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Merk, A.Type,
		CASE
		WHEN (ISNULL(REPLACE(A.Nomor_Pabrik, '-', ''), '') = '') AND (ISNULL(REPLACE(A.Nomor_Rangka, '-', ''), '') = '') AND (ISNULL(REPLACE(A.Nomor_Mesin, '-', ''), '') = '') THEN '-'
		WHEN (ISNULL(REPLACE(A.Nomor_Pabrik, '-', ''), '') = '') AND (ISNULL(REPLACE(A.Nomor_Rangka, '-', ''), '') = '') THEN A.Nomor_Mesin
		WHEN (ISNULL(REPLACE(A.Nomor_Pabrik, '-', ''), '') = '') AND (ISNULL(REPLACE(A.Nomor_Mesin, '-', ''), '') = '') THEN A.Nomor_Rangka
		WHEN (ISNULL(REPLACE(A.Nomor_Rangka, '-', ''), '') = '') AND (ISNULL(REPLACE(A.Nomor_Mesin, '-', ''), '') = '') THEN A.Nomor_Pabrik
		WHEN (ISNULL(REPLACE(A.Nomor_Pabrik, '-', ''), '') = '') THEN A.Nomor_Rangka + CHAR(13) + A.Nomor_Mesin
		WHEN (ISNULL(REPLACE(A.Nomor_Rangka, '-', ''), '') = '') THEN A.Nomor_Pabrik + CHAR(13) + A.Nomor_Mesin
		WHEN (ISNULL(REPLACE(A.Nomor_Mesin, '-', ''), '') = '') THEN A.Nomor_Pabrik + CHAR(13) + A.Nomor_Rangka
		ELSE A.Nomor_Pabrik + CHAR(13) + A.Nomor_Rangka + CHAR(13) + A.Nomor_Mesin
		END,
		A.Bahan, A.Asal_usul, A.CC, '', A.Kondisi, A.Harga
	FROM fn_Kartu_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap) A 
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
									WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
									WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
								ELSE 12 END) 
		AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1) AND A.KONDISI < 3

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
	       A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Dokumen_Nomor, '-'), REPLACE(A.Beton_Tidak, 'Tidak', ''), A.Asal_usul, A.Luas_Lantai, 'M2', A.Kondisi, A.Harga
	FROM fn_Kartu_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap) A 
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		 AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
									WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
									WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
								ELSE 12 END)
		AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1) AND A.KONDISI < 3

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
               A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Dokumen_Nomor, '-'), A.Konstruksi, A.Asal_usul, A.Luas, 'M2', A.Kondisi, A.Harga
	FROM fn_Kartu_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap) A 
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		 AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
									WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
									WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
								ELSE 12 END) 
		AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1) AND A.KONDISI < 3

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', '-',
		CASE A.Kd_Aset2
		WHEN 18 THEN A.Bahan
		WHEN 17 THEN A.Bahan
		ELSE '-'
		END, A.Asal_usul, A.Ukuran,
		CASE A.Kd_Aset2
		WHEN 19 THEN A.Bahan
		ELSE ''
		END, A.Kondisi, A.Harga
	FROM fn_Kartu_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap) A 
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		 AND (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
									WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
									WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
								ELSE 12 END) 
		AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1) AND A.KONDISI < 3

	INSERT INTO @tmpBI
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 6, 20, 1, 1, 1,
		A.Kd_Pemilik, A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, '', '', ISNULL(A.Dokumen_Nomor, '-'), REPLACE(A.Beton_Tidak, 'Tidak', ''), A.Asal_usul, A.Kondisi, '', 'B', A.Harga
	FROM fn_Kartu_BrgF(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap) A
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND (A.KD_BIDANG <> 22) AND (A.Kd_KA = 1)


	SELECT J.Kd_BidangA, J.Kd_UnitA, J.Kd_SubA, J.Kd_UPBA, I.Nm_Provinsi, H.Nm_Kab_Kota,
		J.Nm_Bidang_Gab, J.Nm_Unit_Gab, J.Nm_Sub_Unit_Gab, J.Nm_UPB_Gab,
		B.Nm_Aset5, REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Brg,	
		A.No_Register,	
		CASE
		WHEN (ISNULL(A.Merk, '') <> '') AND (ISNULL(A.Type, '') <> '') THEN A.Merk + ' / ' + A.Type
		WHEN (ISNULL(A.Merk, '') <> '') THEN A.Merk
		WHEN (ISNULL(A.Type, '') <> '') THEN A.Type
		ELSE '-'
		END AS MerkType, 
		A.No_Sertifikat, A.Bahan, A.Asal_Usul, A.Ukuran, A.Satuan, A.Kondisi, YEAR(A.Tgl_Perolehan) AS Tahun,
		1 AS Total, 
		A.Harga, 
		A.Harga AS HrgSat,
		J.Nm_Pimpinan, J.Nip_Pimpinan, J.Jbt_Pimpinan, J.Nm_Pengurus, J.Nip_Pengurus, J.Jbt_Pengurus
	FROM	@tmpBI A INNER JOIN
		Ref_Rek_Aset5 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
		Ref_Kab_Kota H ON A.Kd_Prov = H.Kd_Prov AND A.Kd_Kab_Kota = H.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi I ON H.Kd_Prov = I.Kd_Prov,
		(
		SELECT @Kd_Bidang AS Kd_BidangA, @Kd_Unit AS Kd_UnitA, @Kd_Sub AS Kd_SubA, @Kd_UPB AS Kd_UPBA, 
			RIGHT('0' + @Kd_Bidang, 2) AS Kd_Bidang_Gab,
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) AS Kd_Unit_Gab,
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) + '.' + RIGHT('0' + @Kd_Sub, 2) AS Kd_Sub_Gab,
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) + '.' + RIGHT('0' + @Kd_Sub, 2) + '.' + RIGHT('0' + @Kd_UPB, 2) AS Kd_UPB_Gab,
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
			WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			ORDER BY Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			) F ON A.Tahun = F.Tahun AND A.Kd_Prov = F.Kd_Prov AND A.Kd_Kab_Kota = F.Kd_Kab_Kota AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB
		) J
	
	ORDER BY Kd_Gab_Brg, Tahun, No_Register


GO
