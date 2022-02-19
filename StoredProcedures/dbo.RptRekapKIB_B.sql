USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** RptRekapKIB_B - 05012016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE dbo.RptRekapKIB_B @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), @D2 Datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10)
SET @Tahun = '2011'
SET @D2 = '20111231'
SET @Kd_Prov = '22'
SET @Kd_Kab_Kota = '16'
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @Kd_UPB = ''
*/

    	DECLARE @Ta_KIB_B TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB bigint, Kd_Pemilik tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, Reg1 int, Reg2 int, MerkType varchar(100), CC varchar(50), Bahan varchar(50), Tahun smallint, Nomor_Pabrik varchar(50), Nomor_Rangka varchar(50), Nomor_Mesin varchar(50), Nomor_Polisi varchar(10), Nomor_BPKB varchar(50), Asal_usul varchar(50), Harga money, Total int, Keterangan varchar(255))
	DECLARE @Kd_Prov1 tinyint, @Kd_Kab_Kota1 tinyint, @Kd_Bidang1 tinyint, @Kd_Unit1 smallint, @Kd_Sub1 smallint, @Kd_UPB1 bigint, @Kd_Pemilik1 tinyint, @Kd_Aset11 tinyint, @Kd_Aset21 tinyint, @Kd_Aset31 tinyint, @Kd_Aset41 tinyint, @Kd_Aset51 tinyint, @No_Register1 int, @MerkType1 varchar(100), @CC1 varchar(50), @Bahan1 varchar(50), @Tahun1 smallint, @Nomor_Pabrik1 varchar(50), @Nomor_Rangka1 varchar(50), @Nomor_Mesin1 varchar(50), @Nomor_Polisi1 varchar(10), @Nomor_BPKB1 varchar(50), @Asal_usul1 varchar(50), @Harga1 money, @Keterangan1 varchar(255)
	DECLARE @Kd_Prov2 tinyint, @Kd_Kab_Kota2 tinyint, @Kd_Bidang2 tinyint, @Kd_Unit2 smallint, @Kd_Sub2 smallint, @Kd_UPB2 bigint, @Kd_Pemilik2 tinyint, @Kd_Aset12 tinyint, @Kd_Aset22 tinyint, @Kd_Aset32 tinyint, @Kd_Aset42 tinyint, @Kd_Aset52 tinyint, @MerkType2 varchar(200), @CC2 varchar(50), @Bahan2 varchar(50), @Tahun2 smallint, @Nomor_Pabrik2 varchar(50), @Nomor_Rangka2 varchar(50), @Nomor_Mesin2 varchar(50), @Nomor_Polisi2 varchar(20), @Nomor_BPKB2 varchar(50), @Asal_usul2 varchar(50), @Keterangan2 varchar(255)
	DECLARE @Reg1 int, @Reg2 int, @Jumlah int, @Harga2 money

	DECLARE @JLap Tinyint SET @JLap = 0

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

	DECLARE c1 CURSOR FOR
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Pemilik,
		A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		CASE
		WHEN (ISNULL(A.Merk, '') <> '') AND (ISNULL(A.Type, '') <> '') THEN A.Merk + ' / ' + A.Type
		WHEN (ISNULL(A.Merk, '') <> '') THEN A.Merk
		WHEN (ISNULL(A.Type, '') <> '') THEN A.Type
		ELSE '-'
		END AS MerkType, ISNULL(A.CC, ''), ISNULL(A.Bahan, ''), YEAR(A.Tgl_Perolehan) AS Tahun,
		ISNULL(A.Nomor_Pabrik, ''), ISNULL(A.Nomor_Rangka, ''),
		ISNULL(A.Nomor_Mesin, ''), ISNULL(A.Nomor_Polisi, ''), ISNULL(A.Nomor_BPKB, ''), ISNULL(A.Asal_Usul, ''), A.Harga, ISNULL(A.Keterangan, '')
	FROM fn_Kartu_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A /*LEFT OUTER JOIN
		fn_Penghapusan(@Tahun, '2') B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
			A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND 
			A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register*/
	WHERE A.Tgl_Pembukuan <= @D2 AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		/*AND (B.Kd_Prov IS NULL)*/

	OPEN c1

	FETCH NEXT FROM c1 INTO @Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @Kd_Pemilik1, @Kd_Aset11, @Kd_Aset21, @Kd_Aset31, @Kd_Aset41, @Kd_Aset51, @No_Register1, @MerkType1, @CC1, @Bahan1, @Tahun1, @Nomor_Pabrik1, @Nomor_Rangka1, @Nomor_Mesin1, @Nomor_Polisi1, @Nomor_BPKB1, @Asal_usul1, @Harga1, @Keterangan1

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
	SET @MerkType2 = @MerkType1
	SET @CC2 = @CC1
	SET @Bahan2 = @Bahan1
	SET @Tahun2 = @Tahun1
	SET @Nomor_Pabrik2 = @Nomor_Pabrik1
	SET @Nomor_Rangka2 = @Nomor_Rangka1
	SET @Nomor_Mesin2 = @Nomor_Mesin1
	SET @Nomor_Polisi2 = @Nomor_Polisi1
	SET @Nomor_BPKB2 = @Nomor_BPKB1
	SET @Asal_usul2 = @Asal_usul1
	SET @Reg1 = @No_Register1
	SET @Reg2 = @No_Register1
	SET @Harga2 = 0
	SET @Jumlah = 0
	SET @Keterangan2 = @Keterangan1

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@Kd_Prov2 = @Kd_Prov1) AND (@Kd_Kab_Kota2 = @Kd_Kab_Kota1) AND (@Kd_Bidang2 = @Kd_Bidang1) AND (@Kd_Unit2 = @Kd_Unit1) AND (@Kd_Sub2 = @Kd_Sub1) AND (@Kd_UPB2 = @Kd_UPB1) AND (@Kd_Pemilik2 = @Kd_Pemilik1) AND (@Kd_Aset12 = @Kd_Aset11) AND (@Kd_Aset22 = @Kd_Aset21) AND (@Kd_Aset32 = @Kd_Aset31) AND (@Kd_Aset42 = @Kd_Aset41) AND (@Kd_Aset52 = @Kd_Aset51) AND (@MerkType2 = @MerkType1) AND (@CC2 = @CC1) AND (@Bahan2 = @Bahan1) AND (@Tahun2 = @Tahun1) AND (@Nomor_Pabrik2 = @Nomor_Pabrik1) AND (@Nomor_Rangka2 = @Nomor_Rangka1) AND (@Nomor_Mesin2 = @Nomor_Mesin1) AND (@Nomor_Polisi2 = @Nomor_Polisi1) AND (@Nomor_BPKB2 = @Nomor_BPKB1) AND (@Asal_usul2 = @Asal_usul1) AND (@Keterangan2 = @Keterangan1)
		BEGIN
			SET @Reg2 = @No_Register1
			SET @Harga2 = @Harga2 + @Harga1
			SET @Jumlah = @Jumlah + 1
		END
		ELSE
		BEGIN
			INSERT INTO @Ta_KIB_B
			SELECT @Kd_Prov2, @Kd_Kab_Kota2, @Kd_Bidang2, @Kd_Unit2, @Kd_Sub2, @Kd_UPB2, @Kd_Pemilik2, @Kd_Aset12, @Kd_Aset22, @Kd_Aset32, @Kd_Aset42, @Kd_Aset52, @Reg1, @Reg2, @MerkType2, @CC2, @Bahan2, @Tahun2, @Nomor_Pabrik2, @Nomor_Rangka2, @Nomor_Mesin2, @Nomor_Polisi2, @Nomor_BPKB2, @Asal_usul2, @Harga2, @Jumlah, @Keterangan2

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
			SET @MerkType2 = @MerkType1
			SET @CC2 = @CC1
			SET @Bahan2 = @Bahan1
			SET @Tahun2 = @Tahun1
			SET @Nomor_Pabrik2 = @Nomor_Pabrik1
			SET @Nomor_Rangka2 = @Nomor_Rangka1
			SET @Nomor_Mesin2 = @Nomor_Mesin1
			SET @Nomor_Polisi2 = @Nomor_Polisi1
			SET @Nomor_BPKB2 = @Nomor_BPKB1
			SET @Asal_usul2 = @Asal_usul1
			SET @Reg1 = @No_Register1
			SET @Reg2 = @No_Register1
			SET @Keterangan2 = @Keterangan1
			SET @Harga2 = @Harga1
			SET @Jumlah = 1
		END

		FETCH NEXT FROM c1 INTO @Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @Kd_Pemilik1, @Kd_Aset11, @Kd_Aset21, @Kd_Aset31, @Kd_Aset41, @Kd_Aset51, @No_Register1, @MerkType1, @CC1, @Bahan1, @Tahun1, @Nomor_Pabrik1, @Nomor_Rangka1, @Nomor_Mesin1, @Nomor_Polisi1, @Nomor_BPKB1, @Asal_usul1, @Harga1, @Keterangan1
	END

	INSERT INTO @Ta_KIB_B
	SELECT @Kd_Prov2, @Kd_Kab_Kota2, @Kd_Bidang2, @Kd_Unit2, @Kd_Sub2, @Kd_UPB2, @Kd_Pemilik2, @Kd_Aset12, @Kd_Aset22, @Kd_Aset32, @Kd_Aset42, @Kd_Aset52, @Reg1, @Reg2, @MerkType2, @CC2, @Bahan2, @Tahun2, @Nomor_Pabrik2, @Nomor_Rangka2, @Nomor_Mesin2, @Nomor_Polisi2, @Nomor_BPKB2, @Asal_usul2, @Harga2, @Jumlah, @Keterangan2

	CLOSE c1
	DEALLOCATE c1

	SELECT J.Kd_UPBA, I.Nm_Provinsi, H.Nm_Kab_Kota, 
		F.Nm_Bidang, E.Nm_Unit, D.Nm_Sub_Unit, J.Nm_UPB_Gab,
		dbo.fn_KdLokasi2(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB) AS Kd_Lokasi,
		dbo.fn_KdLokasi2(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB) AS Kd_Lokasi_Grp,
		B.Nm_Aset5, REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Brg,
		CASE
		WHEN A.Total = 1 THEN RIGHT('0000' + CONVERT(varchar, A.Reg1), 4)
		ELSE RIGHT('0000' + CONVERT(varchar, A.Reg1), 4) + ' s/d ' + RIGHT('0000' + CONVERT(varchar, A.Reg2), 4)
		END AS No_Register, 
		A.MerkType, A.CC, A.Bahan, A.Tahun, 
		A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, A.Nomor_BPKB, A.Keterangan,
		A.Asal_usul, A.Harga / 1000 AS Harga, 
		J.Nm_Pimpinan, J.Nip_Pimpinan, J.Jbt_Pimpinan, J.Nm_Pengurus, J.Nip_Pengurus, J.Jbt_Pengurus
	FROM @Ta_KIB_B A INNER JOIN
		Ref_Rek_Aset5 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
		Ref_Sub_Unit D ON A.Kd_Prov = D.Kd_Prov AND A.Kd_Kab_Kota = D.Kd_Kab_Kota AND A.Kd_Bidang = D.Kd_Bidang AND A.Kd_Unit = D.Kd_Unit AND A.Kd_Sub = D.Kd_Sub INNER JOIN
		Ref_Unit E ON D.Kd_Prov = E.Kd_Prov AND D.Kd_Kab_Kota = E.Kd_Kab_Kota AND D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
		Ref_Bidang F ON E.Kd_Bidang = F.Kd_Bidang INNER JOIN
		Ref_Kab_Kota H ON A.Kd_Prov = H.Kd_Prov AND A.Kd_Kab_Kota = H.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi I ON H.Kd_Prov = I.Kd_Prov,
		(
		SELECT @Kd_UPB AS Kd_UPBA, 
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) + '.' + RIGHT('0' + @Kd_Sub, 2) + '.' + RIGHT('0' + @Kd_UPB, 2) AS Kd_UPB_Gab,
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
	ORDER BY Kd_Lokasi_Grp, Kd_Gab_Brg, No_Register, A.Tahun



GO
