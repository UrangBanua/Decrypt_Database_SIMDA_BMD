USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.RptKIB_E @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D2 Datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3)
SET @Tahun = '2011'
SET @D2 = '20111201'
SET @Kd_Prov = '22'
SET @Kd_Kab_Kota = '16'
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @Kd_UPB = ''
*/

    DECLARE @Ta_KIB_E TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB bigint, Kd_Pemilik tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, Reg1 int, Reg2 int, JudulPencipta varchar(500), Spesifikasi varchar(50), AsalDaerah varchar(50), Tahun smallint, Pencipta varchar(50), Bahan varchar(50), Jenis varchar(50), Ukuran varchar(10), Satuan varchar(50), Asal_usul varchar(50), Harga money, Total int, Keterangan varchar(255))
	DECLARE @Kd_Prov1 tinyint, @Kd_Kab_Kota1 tinyint, @Kd_Bidang1 tinyint, @Kd_Unit1 smallint, @Kd_Sub1 smallint, @Kd_UPB1 bigint, @Kd_Pemilik1 tinyint, @Kd_Aset11 tinyint, @Kd_Aset21 tinyint, @Kd_Aset31 tinyint, @Kd_Aset41 tinyint, @Kd_Aset51 tinyint, @No_Register1 int, @JudulPencipta1 varchar(500), @Spesifikasi1 varchar(50), @AsalDaerah1 varchar(50), @Tahun1 smallint, @Pencipta1 varchar(50), @Bahan1 varchar(50), @Jenis1 varchar(50), @Ukuran1 varchar(10), @Satuan1 varchar(50), @Asal_usul1 varchar(50), @Harga1 money, @Keterangan1 varchar(255)
	DECLARE @Kd_Prov2 tinyint, @Kd_Kab_Kota2 tinyint, @Kd_Bidang2 tinyint, @Kd_Unit2 smallint, @Kd_Sub2 smallint, @Kd_UPB2 bigint, @Kd_Pemilik2 tinyint, @Kd_Aset12 tinyint, @Kd_Aset22 tinyint, @Kd_Aset32 tinyint, @Kd_Aset42 tinyint, @Kd_Aset52 tinyint, @JudulPencipta2 varchar(500), @Spesifikasi2 varchar(50), @AsalDaerah2 varchar(50), @Tahun2 smallint, @Pencipta2 varchar(50), @Bahan2 varchar(50), @Jenis2 varchar(50), @Ukuran2 varchar(20), @Satuan2 varchar(50), @Asal_usul2 varchar(50), @Keterangan2 varchar(255)
	DECLARE @Reg1 int, @Reg2 int, @Jumlah int, @Harga2 money
	DECLARE @JLap Tinyint SET @JLap = 0

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

	DECLARE c1 CURSOR FOR
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Pemilik, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		CASE A.Kd_Aset2
		WHEN 17 THEN
			CASE
			WHEN (ISNULL(A.Judul, '') <> '') AND (ISNULL(A.Pencipta, '') <> '') THEN A.Judul + ' / ' + A.Pencipta
			WHEN (ISNULL(A.Judul, '') <> '') THEN A.Judul
			WHEN (ISNULL(A.Pencipta, '') <> '') THEN A.Pencipta
			ELSE '-'
			END
		ELSE '-'
		END AS JudulPencipta, 
		CASE A.Kd_Aset2
		WHEN 17 THEN ISNULL(A.Bahan, '')
		ELSE '-'
		END AS Spesifikasi, 
		CASE A.Kd_Aset2
		WHEN 18 THEN ISNULL(A.Judul, '')
		ELSE '-'
		END AS AsalDaerah, 
		YEAR(A.Tgl_Perolehan) AS Tahun, 
		CASE A.Kd_Aset2
		WHEN 18 THEN ISNULL(A.Pencipta, '')
		ELSE '-'
		END AS Pencipta,
		CASE A.Kd_Aset2
		WHEN 18 THEN ISNULL(A.Bahan, '')
		ELSE '-'
		END AS Bahan,
		CASE A.Kd_Aset2
		WHEN 19 THEN ISNULL(A.Judul, '')
		ELSE '-'
		END AS Jenis,
		ISNULL(CONVERT(varchar, A.Ukuran), '') AS Ukuran,
		CASE A.Kd_Aset2
		WHEN 19 THEN ISNULL(A.Bahan, '')
		ELSE ''
		END AS Satuan,
		ISNULL(A.Asal_Usul, '') AS Asal_Usul, A.Harga, ISNULL(A.Keterangan, '')
	FROM fn_Kartu_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A 
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

	OPEN c1

	FETCH NEXT FROM c1 INTO @Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @Kd_Pemilik1, @Kd_Aset11, @Kd_Aset21, @Kd_Aset31, @Kd_Aset41, @Kd_Aset51, @No_Register1, @JudulPencipta1, @Spesifikasi1, @AsalDaerah1, @Tahun1, @Pencipta1, @Bahan1, @Jenis1, @Ukuran1, @Satuan1, @Asal_usul1, @Harga1, @Keterangan1

	SET @Kd_Prov2 = @Kd_Prov1
	SET @Kd_Kab_Kota2 = @Kd_Kab_Kota1
	SET @Kd_Bidang2 = @Kd_Bidang1
	SET @Kd_Unit2 = @Kd_Unit1
	SET @Kd_Sub2 = @Kd_Sub1
	SET @Kd_UPB2 = @Kd_UPB1
	SET @Kd_Pemilik2 = @Kd_Pemilik1
	SET @Kd_Aset12 = @Kd_Aset11
	SET @Kd_Aset22 = @Kd_Aset21
	SET @Kd_Aset32 = @Kd_Aset31
	SET @Kd_Aset42 = @Kd_Aset41
	SET @Kd_Aset52 = @Kd_Aset51
	SET @JudulPencipta2 = @JudulPencipta1
	SET @Spesifikasi2 = @Spesifikasi1
	SET @AsalDaerah2 = @AsalDaerah1
	SET @Tahun2 = @Tahun1
	SET @Pencipta2 = @Pencipta1
	SET @Bahan2 = @Bahan1
	SET @Jenis2 = @Jenis1
	SET @Ukuran2 = @Ukuran1
	SET @Satuan2 = @Satuan1
	SET @Asal_usul2 = @Asal_usul1
	SET @Reg1 = @No_Register1
	SET @Reg2 = @No_Register1
	SET @Harga2 = 0
	SET @Jumlah = 0
	SET @Keterangan2 = @Keterangan1

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@Kd_Prov2 = @Kd_Prov1) AND (@Kd_Kab_Kota2 = @Kd_Kab_Kota1) AND (@Kd_Bidang2 = @Kd_Bidang1) AND (@Kd_Unit2 = @Kd_Unit1) AND (@Kd_Sub2 = @Kd_Sub1) AND (@Kd_UPB2 = @Kd_UPB1) AND (@Kd_Pemilik2 = @Kd_Pemilik1) AND (@Kd_Aset12 = @Kd_Aset11) AND (@Kd_Aset22 = @Kd_Aset21) AND (@Kd_Aset32 = @Kd_Aset31) AND (@Kd_Aset42 = @Kd_Aset41) AND (@Kd_Aset52 = @Kd_Aset51) AND (@JudulPencipta2 = @JudulPencipta1) AND (@Spesifikasi2 = @Spesifikasi1) AND (@AsalDaerah2 = @AsalDaerah1) AND (@Tahun2 = @Tahun1) AND (@Pencipta2 = @Pencipta1) AND (@Bahan2 = @Bahan1) AND (@Jenis2 = @Jenis1) AND (@Ukuran2 = @Ukuran1) AND (@Satuan2 = @Satuan1) AND (@Asal_usul2 = @Asal_usul1) AND (@Keterangan2 = @Keterangan1)
		BEGIN
			SET @Reg2 = @No_Register1
			SET @Harga2 = @Harga2 + @Harga1
			SET @Jumlah = @Jumlah + 1
		END
		ELSE
		BEGIN
			INSERT INTO @Ta_KIB_E
			SELECT @Kd_Prov2, @Kd_Kab_Kota2, @Kd_Bidang2, @Kd_Unit2, @Kd_Sub2, @Kd_UPB2, @Kd_Pemilik2, @Kd_Aset12, @Kd_Aset22, @Kd_Aset32, @Kd_Aset42, @Kd_Aset52, @Reg1, @Reg2, @JudulPencipta2, @Spesifikasi2, @AsalDaerah2, @Tahun2, @Pencipta2, @Bahan2, @Jenis2, @Ukuran2, @Satuan2, @Asal_usul2, @Harga2, @Jumlah, @Keterangan2

			SET @Kd_Prov2 = @Kd_Prov1
			SET @Kd_Kab_Kota2 = @Kd_Kab_Kota1
			SET @Kd_Bidang2 = @Kd_Bidang1
			SET @Kd_Unit2 = @Kd_Unit1
			SET @Kd_Sub2 = @Kd_Sub1
			SET @Kd_UPB2 = @Kd_UPB1
			SET @Kd_Pemilik2 = @Kd_Pemilik1
			SET @Kd_Aset12 = @Kd_Aset11
			SET @Kd_Aset22 = @Kd_Aset21
			SET @Kd_Aset32 = @Kd_Aset31
			SET @Kd_Aset42 = @Kd_Aset41
			SET @Kd_Aset52 = @Kd_Aset51
			SET @JudulPencipta2 = @JudulPencipta1
			SET @Spesifikasi2 = @Spesifikasi1
			SET @AsalDaerah2 = @AsalDaerah1
			SET @Tahun2 = @Tahun1
			SET @Pencipta2 = @Pencipta1
			SET @Bahan2 = @Bahan1
			SET @Jenis2 = @Jenis1
			SET @Ukuran2 = @Ukuran1
			SET @Satuan2 = @Satuan1
			SET @Asal_usul2 = @Asal_usul1
			SET @Reg1 = @No_Register1
			SET @Reg2 = @No_Register1
			SET @Harga2 = @Harga1
			SET @Jumlah = 1
			SET @Keterangan2 = @Keterangan1
		END

		FETCH NEXT FROM c1 INTO @Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @Kd_Pemilik1, @Kd_Aset11, @Kd_Aset21, @Kd_Aset31, @Kd_Aset41, @Kd_Aset51, @No_Register1, @JudulPencipta1, @Spesifikasi1, @AsalDaerah1, @Tahun1, @Pencipta1, @Bahan1, @Jenis1, @Ukuran1, @Satuan1, @Asal_usul1, @Harga1, @Keterangan1
	END

	INSERT INTO @Ta_KIB_E
	SELECT @Kd_Prov2, @Kd_Kab_Kota2, @Kd_Bidang2, @Kd_Unit2, @Kd_Sub2, @Kd_UPB2, @Kd_Pemilik2, @Kd_Aset12, @Kd_Aset22, @Kd_Aset32, @Kd_Aset42, @Kd_Aset52, @Reg1, @Reg2, @JudulPencipta2, @Spesifikasi2, @AsalDaerah2, @Tahun2, @Pencipta2, @Bahan2, @Jenis2, @Ukuran2, @Satuan2, @Asal_usul2, @Harga2, @Jumlah, @Keterangan2

	CLOSE c1
	DEALLOCATE c1

	SELECT J.Kd_UPBA, I.Nm_Provinsi, H.Nm_Kab_Kota,  
		F.Nm_Bidang, E.Nm_Unit, D.Nm_Sub_Unit, J.Nm_UPB_Gab,
		dbo.fn_KdLokasi(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tahun) AS Kd_Lokasi,
		dbo.fn_KdLokasi3(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tahun) AS Kd_Lokasi_Grp,
		B.Nm_Aset5, REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Brg,
		CASE
		WHEN A.Total = 1 THEN RIGHT('000000' + CONVERT(varchar, A.Reg1), 6)
		ELSE RIGHT('000000' + CONVERT(varchar, A.Reg1), 6) + ' s/d ' + RIGHT('000000' + CONVERT(varchar, A.Reg2), 6)
		END AS No_Register, 
		A.JudulPencipta, A.Spesifikasi, A.AsalDaerah, A.Pencipta, A.Bahan, A.Jenis, A.Ukuran,
		A.Satuan, A.Total, A.Tahun, A.Asal_usul, A.Harga / 1000 AS Harga, A.Keterangan, 
		J.Nm_Pimpinan, J.Nip_Pimpinan, J.Jbt_Pimpinan, J.Nm_Pengurus, J.Nip_Pengurus, J.Jbt_Pengurus
	FROM @Ta_KIB_E A INNER JOIN
		Ref_Rek_Aset5 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
		Ref_Sub_Unit D ON A.Kd_Prov = D.Kd_Prov AND A.Kd_Kab_Kota = D.Kd_Kab_Kota AND A.Kd_Bidang = D.Kd_Bidang AND A.Kd_Unit = D.Kd_Unit AND A.Kd_Sub = D.Kd_Sub INNER JOIN
		Ref_Unit E ON D.Kd_Prov = E.Kd_Prov AND D.Kd_Kab_Kota = E.Kd_Kab_Kota AND D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
		Ref_Bidang F ON E.Kd_Bidang = F.Kd_Bidang INNER JOIN
		Ref_Kab_Kota H ON A.Kd_Prov = H.Kd_Prov AND A.Kd_Kab_Kota = H.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi I ON H.Kd_Prov = I.Kd_Prov,
		(
		SELECT @Kd_UPB AS Kd_UPBA, 
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) + '.' + RIGHT('00' + @Kd_Sub, 3) + '.' + RIGHT('00' + @Kd_UPB, 3) AS Kd_UPB_Gab,
			B.Nm_UPB AS Nm_UPB_Gab, A.Nm_Pimpinan, A.Nip_Pimpinan, A.Jbt_Pimpinan,
			A.Nm_Pengurus, A.Nip_Pengurus, A.Jbt_Pengurus
		FROM Ta_UPB A INNER JOIN
			Ref_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
			(
			SELECT TOP 1 Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			FROM Ta_UPB
			WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			ORDER BY Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			) C ON A.Tahun = C.Tahun AND A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
		) J
	ORDER BY Kd_Lokasi_Grp, Kd_Gab_Brg, No_Register






GO
