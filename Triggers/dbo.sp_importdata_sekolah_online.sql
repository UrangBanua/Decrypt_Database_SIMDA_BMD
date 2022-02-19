USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** sp_importdata_sekolah_online - 11102017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE sp_importdata_sekolah_online @Tahun varchar(4), 
	@Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), 
	@Kd_ProvTo varchar(3), @Kd_Kab_KotaTo varchar(3), @Kd_BidangTo varchar(3), @Kd_UnitTo varchar(3), @Kd_SubTo varchar(3), @Kd_UPBTo varchar(10), @jenis varchar(50), @No_BAST varchar(50), @kdServer varchar(50)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), 
	@Kd_ProvTo varchar(3), @Kd_Kab_KotaTo varchar(3), @Kd_BidangTo varchar(3), @Kd_UnitTo varchar(3), @Kd_SubTo varchar(3), @Kd_UPBTo varchar(10), @jenis varchar(50), @No_BAST varchar(50), @kdServer varchar(50)
SET @Tahun = '2017'
SET @Kd_Prov = '99'
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang = '8'
SET @Kd_Unit = '1'
SET @Kd_Sub = '18'
SET @Kd_UPB = '5'
SET @Kd_ProvTo = '99'
SET @Kd_Kab_KotaTo = '99'
SET @Kd_BidangTo = '8'
SET @Kd_UnitTo = '1'
SET @Kd_SubTo = '1'
SET @Kd_UPBTo = '107'
SET @jenis = '11'
SET @No_BAST = 'BASTProv2017' 
SET @kdServer = '20171231' --Tanggal BAST
*/
	DECLARE @sOLE varchar(50), @sServer varchar(50), @sDB varchar(50), @sUser varchar(50), @sPass varchar(50), @sOpenRow varchar(255)
	SET @sOLE    ='SQLOLEDB'
	SET @sServer = ''
	SET @sDB     = ''
	SET @sUser   = ''
	SET @sPass   = ''

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	
	DECLARE @JLap tinyint SET @JLap = 1
	DECLARE @D2 Datetime SET @D2 = @kdServer
	DECLARE @ErrD varchar(255)
	SET @ErrD = ''

	DECLARE @Kd_Kab_Kota_Asal varchar(3)
	SELECT TOP 1 @Kd_Kab_Kota_Asal = Kd_Kab_Kota FROM BMD_KAB.dbo.Ref_Pemda

	IF NOT EXISTS (SELECT Kd_Prov FROM Ref_UPB WHERE (Kd_Prov = @Kd_ProvTo) AND (Kd_Kab_Kota = @Kd_Kab_KotaTo) AND (Kd_Bidang LIKE @Kd_BidangTo) AND (Kd_Unit LIKE @Kd_UnitTo) AND (Kd_Sub LIKE @Kd_SubTo) AND (Kd_UPB LIKE @Kd_UPBTo))
	BEGIN 	
		INSERT INTO Ref_UPB(Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Nm_UPB, Kd_Kecamatan, Kd_Desa)
		SELECT A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo AS Kd_Bidang, @Kd_UnitTo AS Kd_Unit, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Nm_UPB, A.Kd_Kecamatan, A.Kd_Desa
		FROM BMD_KAB.dbo.Ref_UPB A 	
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'INSERT UPB error.'
	END

	IF NOT EXISTS (SELECT Tahun FROM Ta_Sub_Unit WHERE (Kd_Prov = @Kd_ProvTo) AND (Kd_Kab_Kota = @Kd_Kab_KotaTo) AND (Kd_Bidang LIKE @Kd_BidangTo) AND (Kd_Unit LIKE @Kd_UnitTo) AND (Kd_Sub LIKE @Kd_SubTo))
	BEGIN 
		INSERT INTO Ta_Sub_Unit(Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Alamat)
		SELECT @Tahun, A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo AS Kd_Bidang, @Kd_UnitTo AS Kd_Unit, @Kd_SubTo AS Kd_Sub, A.Alamat
		FROM BMD_KAB.dbo.Ta_Sub_Unit A
		WHERE A.Tahun = (SELECT Max(Tahun) FROM BMD_KAB.dbo.Ta_Sub_Unit) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub)
		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'INSERT Sub Unit error.'
	END
	
	IF NOT EXISTS (SELECT Tahun FROM Ta_UPB WHERE (Kd_Prov = @Kd_ProvTo) AND (Kd_Kab_Kota = @Kd_Kab_KotaTo) AND (Kd_Bidang LIKE @Kd_BidangTo) AND (Kd_Unit LIKE @Kd_UnitTo) AND (Kd_Sub LIKE @Kd_SubTo) AND (Kd_UPB LIKE @Kd_UPBTo))
	BEGIN 
		INSERT INTO Ta_UPB(Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Nm_Pimpinan, Nip_Pimpinan, Jbt_Pimpinan, Nm_Pengurus, Nip_Pengurus, Jbt_Pengurus, Nm_Penyimpan, Nip_Penyimpan, Jbt_Penyimpan)
		SELECT @Tahun, A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo AS Kd_Bidang, @Kd_UnitTo AS Kd_Unit, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Nm_Pimpinan, A.Nip_Pimpinan, A.Jbt_Pimpinan, A.Nm_Pengurus, A.Nip_Pengurus, A.Jbt_Pengurus, A.Nm_Penyimpan, A.Nip_Penyimpan, A.Jbt_Penyimpan
		FROM BMD_KAB.dbo.Ta_UPB A 	
		WHERE A.Tahun = (SELECT Max(Tahun) FROM BMD_KAB.dbo.Ta_UPB) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'INSERT Data Umum UPB error.'
	END
	
	IF NOT EXISTS (SELECT Tahun FROM Ta_Ruang WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_ProvTo) AND (Kd_Kab_Kota = @Kd_Kab_KotaTo) AND (Kd_Bidang LIKE @Kd_BidangTo) AND (Kd_Unit LIKE @Kd_UnitTo) AND (Kd_Sub LIKE @Kd_SubTo) AND (Kd_UPB LIKE @Kd_UPBTo))
	BEGIN 
		INSERT INTO Ta_Ruang(Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Ruang, Nm_Ruang, Nm_Pngjwb, Nip_Pngjwb, Jbt_Pngjwb, Kd_Bidang1, Kd_Unit1,
			Kd_Sub1, Kd_UPB1, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik)
		SELECT @Tahun, A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo AS Kd_Bidang, @Kd_UnitTo AS Kd_Unit, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Ruang, A.Nm_Ruang, A.Nm_Pngjwb, A.Nip_Pngjwb, A.Jbt_Pngjwb, A.Kd_Bidang1, A.Kd_Unit1,
			A.Kd_Sub1, A.Kd_UPB1, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik
		FROM BMD_KAB.dbo.Ta_Ruang A 
		WHERE A.Tahun = (SELECT Max(Tahun) FROM BMD_KAB.dbo.Ta_Ruang) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		GROUP BY A.Tahun, A.Kd_Prov, A.Kd_Bidang, A.Kd_Unit, A.Kd_Ruang, A.Nm_Ruang, A.Nm_Pngjwb, A.Nip_Pngjwb, A.Jbt_Pngjwb, A.Kd_Bidang1, A.Kd_Unit1,
			A.Kd_Sub1, A.Kd_UPB1, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik

		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'INSERT Ruang error.'
	END

	IF EXISTS (SELECT Kd_Prov FROM Ta_P3D WHERE (No_BAST = @No_BAST))
	BEGIN 
		UPDATE Ta_P3D 
		SET Kd_Prov = A.Kd_Prov, Kd_Kab_Kota = A.Kd_Kab_Kota, Nm_Kab_Kota = A.Nm_Pemda
		FROM BMD_KAB.dbo.Ref_Pemda A
		WHERE No_BAST = @No_BAST

		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'INSERT P3D error.'
	END

	BEGIN TRANSACTION

	IF (CHARINDEX('4', @jenis) > 0) AND (@ErrD = '')
	BEGIN
		INSERT INTO Ref_Rek_Aset2(Kd_Aset1, Kd_Aset2, Nm_Aset2)
		SELECT B.Kd_Aset1, B.Kd_Aset2, (B.Nm_Aset2 + ' - ' + IsNull(@Kd_Kab_Kota_Asal,'')) AS Nm_Aset2
		FROM Ref_Rek_Aset2 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset2 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 1

		INSERT INTO Ref_Rek_Aset3(Kd_Aset1, Kd_Aset2, Kd_Aset3, Nm_Aset3)
		SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, (B.Nm_Aset3 + ' - ' + IsNull(@Kd_Kab_Kota_Asal,'')) AS Nm_Aset3
		FROM Ref_Rek_Aset3 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset3 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 1

		INSERT INTO Ref_Rek_Aset4(Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Nm_Aset4)
		SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, (B.Nm_Aset4 + ' - ' + IsNull(@Kd_Kab_KotaTo,'')) AS Nm_Aset4
		FROM Ref_Rek_Aset4 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset4 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 1

		INSERT INTO Ref_Rek_Aset5(Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Nm_Aset5)
		SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, (B.Nm_Aset5 + ' - ' + @Kd_Kab_KotaTo) AS Nm_Aset5
		FROM Ref_Rek_Aset5 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset5 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 1

		DELETE Ta_P3D_Rinc
		WHERE (No_BAST = @No_BAST) AND (Kd_Bidang = @Kd_BidangTo) AND (Kd_Unit = @Kd_UnitTo) AND (Kd_Sub = @Kd_SubTo) AND (Kd_UPB = @Kd_UPBTo)
		AND SubString(IDPemda,11,1) = '1'

		DELETE Ta_FotoA
		FROM Ta_FotoA A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_A B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_KotaTo AND A.Kd_Bidang = @Kd_BidangTo AND A.Kd_Unit = @Kd_UnitTo AND A.Kd_Sub = @Kd_SubTo AND A.Kd_UPB = @Kd_UPBTo
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		DELETE Ta_KIBAR
		FROM Ta_KIBAR A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_A B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_KotaTo AND A.Kd_Bidang = @Kd_BidangTo AND A.Kd_Unit = @Kd_UnitTo AND A.Kd_Sub = @Kd_SubTo AND A.Kd_UPB = @Kd_UPBTo
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		DELETE Ta_KIBAHapus
		FROM Ta_KIBAHapus A INNER JOIN
			BMD_KAB.dbo.Ta_KIBAHapus B ON A.No_SK = B.No_SK

		DELETE Ta_KIB_A
		FROM Ta_KIB_A A INNER JOIN
			BMD_KAB.dbo.Ta_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_KotaTo AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_SubTo AND A.Kd_UPB = @Kd_UPBTo
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'DELETE KIB A error.'

		SELECT IDENTITY(int, 1, 1) AS NoId, IDPemda
		INTO tmpTa_KIB_A
		FROM BMD_KAB.dbo.Ta_KIB_A
		WHERE (Kd_Prov = @Kd_Prov) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)

		INSERT INTO Ta_P3D_Rinc(No_BAST, IDPemda, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB)
		SELECT @No_BAST, RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, B.NoId), 4) AS IDPemda, 
			@Kd_BidangTo  AS Kd_Bidang, @Kd_UnitTo AS Kd_Unit, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB
		FROM BMD_KAB.dbo.Ta_KIB_A A INNER JOIN tmpTa_KIB_A B ON A.IDPemda = B.IDPemda
		WHERE (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

		INSERT INTO Ta_KIB_A(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Luas_M2, Alamat, Hak_Tanah, Sertifikat_Tanggal, Sertifikat_Nomor, Penggunaan, Asal_usul, Harga, Keterangan,
			Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus, No_SIPPT)
		SELECT RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1)
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, B.NoId), 4) AS IDPemda, 
			A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo, @Kd_UnitTo, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			11 AS Kd_Pemilik, A.Tgl_Perolehan, @D2, A.Luas_M2, A.Alamat, A.Hak_Tanah, A.Sertifikat_Tanggal, A.Sertifikat_Nomor, A.Penggunaan, A.Asal_usul, C.Harga, A.Keterangan AS Keterangan,
			A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, 9 AS Kd_Data, A.Kd_KA, A.Log_User, A.Log_Entry, A.Kd_Hapus, '(P3D : '+@Kd_Kab_Kota_Asal+'.'+A.IDPemda+')' AS No_SIPPT
		FROM BMD_KAB.dbo.Ta_KIB_A A INNER JOIN 
			tmpTa_KIB_A B ON A.IDPemda = B.IDPemda INNER JOIN
			BMD_KAB.dbo.fn_Kartu_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota_Asal, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%', '%', '%', '%', @JLap) C ON
				A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
				AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
				AND A.No_Register = C.No_Register
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		
		/*
		INSERT INTO Ta_FotoA(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, No_Id,
			Foto_Aset, Nama_foto, Keterangan, Kd_Kecamatan, Kd_Desa, Log_User, Log_entry)
		SELECT RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, A.IDPemda), 4) AS IDPemda,
			A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo, @Kd_UnitTo, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.No_Id,
			A.Foto_Aset, A.Nama_foto, A.Keterangan, A.Kd_Kecamatan, A.Kd_Desa, A.Log_User, A.Log_entry
		FROM BMD_KAB.dbo.Ta_FotoA A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_A B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
		
		INSERT INTO Ta_KIBAR(IDPemda, Kd_Riwayat, Kd_Id, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Luas_M2, Alamat, Hak_Tanah, Sertifikat_Tanggal, Sertifikat_Nomor, Penggunaan,
			Asal_usul, Harga, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, 
			No_Register1, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_Alasan, Log_User, Log_entry, Nm_Rekanan, Alamat_Reakanan, Tgl_Mulai, Tgl_Selesai, Kd_KA)
		SELECT RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, C.NoId), 4) AS IDPemda,
			A.Kd_Riwayat, A.Kd_Id, A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo, @Kd_UnitTo, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			11 AS Kd_Pemilik, A.Tgl_Dokumen, A.No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Luas_M2, A.Alamat, A.Hak_Tanah, A.Sertifikat_Tanggal, A.Sertifikat_Nomor, A.Penggunaan,
			A.Asal_usul, A.Harga, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, 
			A.No_Register1, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, 9 AS Kd_Data, A.Kd_Alasan, A.Log_User, A.Log_entry, A.Nm_Rekanan, A.Alamat_Reakanan, A.Tgl_Mulai, A.Tgl_Selesai, A.Kd_KA
		FROM BMD_KAB.dbo.Ta_KIBAR A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_A B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register INNER JOIN 
			tmpTa_KIB_A C ON B.IDPemda = C.IDPemda
		WHERE A.Kd_Riwayat NOT IN (5,6)
		AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
		*/

		if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmpTa_KIB_A]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
		drop table [dbo].[tmpTa_KIB_A]

		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'INSERT KIB A error.'
	END
		
	IF (CHARINDEX('5', @jenis) > 0) AND (@ErrD = '')
	BEGIN
		INSERT INTO Ref_Rek_Aset2(Kd_Aset1, Kd_Aset2, Nm_Aset2)
		SELECT B.Kd_Aset1, B.Kd_Aset2, (B.Nm_Aset2 + ' - ' + IsNull(@Kd_Kab_Kota_Asal,'')) AS Nm_Aset2
		FROM Ref_Rek_Aset2 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset2 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 2

		INSERT INTO Ref_Rek_Aset3(Kd_Aset1, Kd_Aset2, Kd_Aset3, Nm_Aset3)
		SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, (B.Nm_Aset3 + ' - ' + IsNull(@Kd_Kab_Kota_Asal,'')) AS Nm_Aset3
		FROM Ref_Rek_Aset3 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset3 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 2

		INSERT INTO Ref_Rek_Aset4(Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Nm_Aset4)
		SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, (B.Nm_Aset4 + ' - ' + IsNull(@Kd_Kab_KotaTo,'')) AS Nm_Aset4
		FROM Ref_Rek_Aset4 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset4 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 2

		INSERT INTO Ref_Rek_Aset5(Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Nm_Aset5)
		SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, (B.Nm_Aset5 + ' - ' + @Kd_Kab_KotaTo) AS Nm_Aset5
		FROM Ref_Rek_Aset5 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset5 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 2

		DELETE Ta_P3D_Rinc
		WHERE (No_BAST = @No_BAST) AND (Kd_Bidang = @Kd_BidangTo) AND (Kd_Unit = @Kd_UnitTo) AND (Kd_Sub = @Kd_SubTo) AND (Kd_UPB = @Kd_UPBTo)
		AND SubString(IDPemda,11,1) = '2'

		DELETE Ta_SusutB
		FROM Ta_SusutB A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_B B ON A.IDPemda = B.IDPemda
		WHERE (A.Tahun = @Tahun) AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		DELETE Ta_KIBBR
		FROM Ta_KIBBR A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_B B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_KotaTo AND A.Kd_Bidang = @Kd_BidangTo AND A.Kd_Unit = @Kd_UnitTo AND A.Kd_Sub = @Kd_SubTo AND A.Kd_UPB = @Kd_UPBTo
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		DELETE Ta_FotoB
		FROM Ta_FotoB A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_B B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_KotaTo AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_SubTo AND A.Kd_UPB = @Kd_UPBTo
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		DELETE Ta_KIBBHapus
		FROM Ta_KIBBHapus A INNER JOIN
			BMD_KAB.dbo.Ta_KIBBHapus B ON A.No_SK = B.No_SK

		DELETE Ta_KIB_B
		FROM Ta_KIB_B A INNER JOIN
			BMD_KAB.dbo.Ta_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_KotaTo AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_SubTo AND A.Kd_UPB = @Kd_UPBTo
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)
		
		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'DELETE KIB B error.'

		SELECT IDENTITY(int, 1, 1) AS NoId, IDPemda
		INTO tmpTa_KIB_B
		FROM BMD_KAB.dbo.Ta_KIB_B
		WHERE (Kd_Prov = @Kd_Prov) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)

		INSERT INTO Ta_P3D_Rinc(No_BAST, IDPemda, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB)
		SELECT @No_BAST, RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar,A. Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, B.NoId), 4) AS IDPemda, 
			@Kd_BidangTo  AS Kd_Bidang, @Kd_UnitTo AS Kd_Unit, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB
		FROM BMD_KAB.dbo.Ta_KIB_B A INNER JOIN tmpTa_KIB_B B ON A.IDPemda = B.IDPemda
		WHERE (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
			
		INSERT INTO Ta_KIB_B(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Ruang, Kd_Pemilik, Merk, Type, CC, Bahan, Tgl_Perolehan, Tgl_Pembukuan, Nomor_Pabrik, Nomor_Rangka, Nomor_Mesin, Nomor_Polisi, Nomor_BPKB, 
			Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan,
			Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus, No_SIPPT)
		SELECT RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, B.NoId), 4) AS IDPemda,
			A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo, @Kd_UnitTo, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			A.Kd_Ruang, 11 AS Kd_Pemilik, A.Merk, A.Type, A.CC, A.Bahan, A.Tgl_Perolehan, @D2, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, A.Nomor_BPKB, 
			A.Asal_usul, C.Kondisi, C.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan AS Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan,
			9 AS Kd_Data, A.Kd_KA, A.Log_User, A.Log_Entry, A.Kd_Hapus, '(P3D : '+@Kd_Kab_Kota_Asal+'.'+A.IDPemda+')' AS No_SIPPT
		FROM BMD_KAB.dbo.Ta_KIB_B A INNER JOIN 
			tmpTa_KIB_B B ON A.IDPemda = B.IDPemda INNER JOIN
			BMD_KAB.dbo.fn_Kartu_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota_Asal, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%', '%', '%', '%', @JLap) C ON
				A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
				AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
				AND A.No_Register = C.No_Register
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
 	
		/*INSERT INTO Ta_FotoB(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, No_Id,
			Foto_Aset, Nama_foto, Keterangan, Kd_Kecamatan, Kd_Desa, Log_User, Log_Entry)
		SELECT RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, A.IDPemda), 4) AS IDPemda,
			A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo, @Kd_UnitTo, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.No_Id,
			A.Foto_Aset, A.Nama_foto, A.Keterangan, A.Kd_Kecamatan, A.Kd_Desa, A.Log_User, A.Log_Entry
		FROM BMD_KAB.dbo.Ta_FotoB A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_B B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
		
		INSERT INTO Ta_KIBBR(IDPemda, Kd_Riwayat, Kd_Id, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Ruang, Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Merk, Type, CC, Bahan, Nomor_Pabrik, Nomor_Rangka, Nomor_Mesin, Nomor_Polisi, Nomor_BPKB,
			Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1,
			No_Register1, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_Alasan, Log_User, Log_entry, Nm_Rekanan, Alamat_Reakanan, Tgl_Mulai, Tgl_Selesai, Kd_KA)
		SELECT RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, C.NoId), 4) AS IDPemda,
			A.Kd_Riwayat, A.Kd_Id, A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo, @Kd_UnitTo, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			A.Kd_Ruang, 11 AS Kd_Pemilik, A.Tgl_Dokumen, A.No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Merk, A.Type, A.CC, A.Bahan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, A.Nomor_BPKB,
			A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1,
			A.No_Register1, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, 9 AS Kd_Data, A.Kd_Alasan, A.Log_User, A.Log_entry, A.Nm_Rekanan, A.Alamat_Reakanan, A.Tgl_Mulai, A.Tgl_Selesai, A.Kd_KA
		FROM BMD_KAB.dbo.Ta_KIBBR A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_B B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register INNER JOIN 
			tmpTa_KIB_B C ON B.IDPemda = C.IDPemda
		WHERE A.Kd_Riwayat NOT IN (5,6)
		AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
		*/

		if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmpTa_KIB_B]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
		drop table [dbo].[tmpTa_KIB_B]
	
		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'INSERT KIB B error.'
	END
		
	IF (CHARINDEX('6', @jenis) > 0) AND (@ErrD = '')
	BEGIN
		INSERT INTO Ref_Rek_Aset2(Kd_Aset1, Kd_Aset2, Nm_Aset2)
		SELECT B.Kd_Aset1, B.Kd_Aset2, (B.Nm_Aset2 + ' - ' + IsNull(@Kd_Kab_Kota_Asal,'')) AS Nm_Aset2
		FROM Ref_Rek_Aset2 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset2 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 3

		INSERT INTO Ref_Rek_Aset3(Kd_Aset1, Kd_Aset2, Kd_Aset3, Nm_Aset3)
		SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, (B.Nm_Aset3 + ' - ' + IsNull(@Kd_Kab_Kota_Asal,'')) AS Nm_Aset3
		FROM Ref_Rek_Aset3 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset3 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 3

		INSERT INTO Ref_Rek_Aset4(Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Nm_Aset4)
		SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, (B.Nm_Aset4 + ' - ' + IsNull(@Kd_Kab_KotaTo,'')) AS Nm_Aset4
		FROM Ref_Rek_Aset4 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset4 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 3

		INSERT INTO Ref_Rek_Aset5(Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Nm_Aset5)
		SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, (B.Nm_Aset5 + ' - ' + @Kd_Kab_KotaTo) AS Nm_Aset5
		FROM Ref_Rek_Aset5 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset5 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 3

		DELETE Ta_P3D_Rinc
		WHERE (No_BAST = @No_BAST) AND (Kd_Bidang = @Kd_BidangTo) AND (Kd_Unit = @Kd_UnitTo) AND (Kd_Sub = @Kd_SubTo) AND (Kd_UPB = @Kd_UPBTo)
		AND SubString(IDPemda,11,1) = '3'

		DELETE Ta_SusutC
		FROM Ta_SusutC A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_C B ON A.IDPemda = B.IDPemda
		WHERE (A.Tahun = @Tahun) AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		DELETE Ta_FotoC
		FROM Ta_FotoC A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_C B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_KotaTo AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_SubTo AND A.Kd_UPB = @Kd_UPBTo
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		DELETE Ta_KIBCR
		FROM Ta_KIBCR A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_C B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_KotaTo AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_SubTo AND A.Kd_UPB = @Kd_UPBTo
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		DELETE Ta_KIBCHapus
		FROM Ta_KIBCHapus A INNER JOIN
			BMD_KAB.dbo.Ta_KIBCHapus B ON A.No_SK = B.No_SK 

		DELETE Ta_KIB_C
		FROM Ta_KIB_C A INNER JOIN
			BMD_KAB.dbo.Ta_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_KotaTo AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_SubTo AND A.Kd_UPB = @Kd_UPBTo
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_KotaTo) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'DELETE KIB B error.'

		SELECT IDENTITY(int, 1, 1) AS NoId, IDPemda
		INTO tmpTa_KIB_C
		FROM BMD_KAB.dbo.Ta_KIB_C
		WHERE (Kd_Prov = @Kd_Prov) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)

		INSERT INTO Ta_P3D_Rinc(No_BAST, IDPemda, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB)
		SELECT @No_BAST, RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, B.NoId), 4) AS IDPemda, 
			@Kd_BidangTo  AS Kd_Bidang, @Kd_UnitTo AS Kd_Unit, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB
		FROM BMD_KAB.dbo.Ta_KIB_C A INNER JOIN tmpTa_KIB_C B ON A.IDPemda = B.IDPemda
		WHERE (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)

		INSERT INTO Ta_KIB_C(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Bertingkat_Tidak, Beton_tidak, Luas_Lantai, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, Kd_Tanah1,
			Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID,
			Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus, No_SIPPT)
		SELECT RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, B.NoId), 4) AS IDPemda,
			A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo, @Kd_UnitTo, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			11 AS Kd_Pemilik, A.Tgl_Perolehan, @D2, A.Bertingkat_Tidak, A.Beton_tidak, A.Luas_Lantai, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah, A.Kd_Tanah1,
			A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_usul, C.Kondisi, C.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan AS Keterangan, A.Tahun, A.No_SP2D, A.No_ID,
			A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, 9 AS Kd_Data, A.Kd_KA, A.Log_User, A.Log_Entry, A.Kd_Hapus, '(P3D : '+@Kd_Kab_Kota_Asal+'.'+A.IDPemda+')' AS No_SIPPT
		FROM BMD_KAB.dbo.Ta_KIB_C A INNER JOIN 
			tmpTa_KIB_C B ON A.IDPemda = B.IDPemda INNER JOIN
			BMD_KAB.dbo.fn_Kartu_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota_Asal, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%', '%', '%', '%', @JLap) C ON
				A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
				AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
				AND A.No_Register = C.No_Register
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		
		/*
		INSERT INTO Ta_FotoC(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, No_Id,
			Foto_Aset, Nama_foto, Keterangan, Kd_Kecamatan, Kd_Desa, Log_User, Log_entry)
		SELECT RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, A.IDPemda), 4) AS IDPemda,
			A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo, @Kd_UnitTo, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.No_Id,
			A.Foto_Aset, A.Nama_foto, A.Keterangan, A.Kd_Kecamatan, A.Kd_Desa, A.Log_User, A.Log_entry
		FROM BMD_KAB.dbo.Ta_FotoC A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_C B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
		
		INSERT INTO Ta_KIBCR(IDPemda, Kd_Riwayat, Kd_Id, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Bertingkat_Tidak, Beton_tidak, Luas_Lantai, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, Kd_Tanah1,
			Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa,
			Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_Alasan, Log_User, Log_entry, Nm_Rekanan,
			Alamat_Reakanan, Tgl_Mulai, Tgl_Selesai, Kd_KA)
		SELECT RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, C.NoId), 4) AS IDPemda,
			A.Kd_Riwayat, A.Kd_Id, A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo, @Kd_UnitTo, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			11 AS Kd_Pemilik, A.Tgl_Dokumen, A.No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Bertingkat_Tidak, A.Beton_tidak, A.Luas_Lantai, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah, A.Kd_Tanah1,
			A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa,
			A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, A.No_Register1, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, 9 AS Kd_Data, A.Kd_Alasan, A.Log_User, A.Log_entry, A.Nm_Rekanan,
			A.Alamat_Reakanan, A.Tgl_Mulai, A.Tgl_Selesai, A.Kd_KA
		FROM BMD_KAB.dbo.Ta_KIBCR A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_C B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register INNER JOIN 
			tmpTa_KIB_C C ON B.IDPemda = C.IDPemda
		WHERE A.Kd_Riwayat NOT IN (5,6)
		AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
		*/

		if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmpTa_KIB_C]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
		drop table [dbo].[tmpTa_KIB_C]

		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'INSERT KIB C error.'
	END

	IF (CHARINDEX('7', @jenis) > 0) AND (@ErrD = '')
	BEGIN
		INSERT INTO Ref_Rek_Aset2(Kd_Aset1, Kd_Aset2, Nm_Aset2)
		SELECT B.Kd_Aset1, B.Kd_Aset2, (B.Nm_Aset2 + ' - ' + IsNull(@Kd_Kab_Kota_Asal,'')) AS Nm_Aset2
		FROM Ref_Rek_Aset2 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset2 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 4

		INSERT INTO Ref_Rek_Aset3(Kd_Aset1, Kd_Aset2, Kd_Aset3, Nm_Aset3)
		SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, (B.Nm_Aset3 + ' - ' + IsNull(@Kd_Kab_Kota_Asal,'')) AS Nm_Aset3
		FROM Ref_Rek_Aset3 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset3 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 4

		INSERT INTO Ref_Rek_Aset4(Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Nm_Aset4)
		SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, (B.Nm_Aset4 + ' - ' + IsNull(@Kd_Kab_KotaTo,'')) AS Nm_Aset4
		FROM Ref_Rek_Aset4 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset4 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 4

		INSERT INTO Ref_Rek_Aset5(Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Nm_Aset5)
		SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, (B.Nm_Aset5 + ' - ' + @Kd_Kab_KotaTo) AS Nm_Aset5
		FROM Ref_Rek_Aset5 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset5 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 4

		DELETE Ta_P3D_Rinc
		WHERE (No_BAST = @No_BAST) AND (Kd_Bidang = @Kd_BidangTo) AND (Kd_Unit = @Kd_UnitTo) AND (Kd_Sub = @Kd_SubTo) AND (Kd_UPB = @Kd_UPBTo)
		AND SubString(IDPemda,11,1) = '4'

		DELETE Ta_SusutD
		FROM Ta_SusutD A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_D B ON A.IDPemda = B.IDPemda
		WHERE (A.Tahun = @Tahun) AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)

		DELETE Ta_FotoD
		FROM Ta_FotoD A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_D B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_KotaTo AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_SubTo AND A.Kd_UPB = @Kd_UPBTo
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		DELETE Ta_KIBDR
		FROM Ta_KIBDR A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_D B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_KotaTo AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_SubTo AND A.Kd_UPB = @Kd_UPBTo
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		DELETE Ta_KIBDHapus
		FROM Ta_KIBDHapus A INNER JOIN
			BMD_KAB.dbo.Ta_KIBDHapus B ON A.No_SK = B.No_SK

		DELETE Ta_KIB_D
		FROM Ta_KIB_D A INNER JOIN
			BMD_KAB.dbo.Ta_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_KotaTo AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_SubTo AND A.Kd_UPB = @Kd_UPBTo
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'DELETE KIB B error.'

		SELECT IDENTITY(int, 1, 1) AS NoId, IDPemda
		INTO tmpTa_KIB_D
		FROM BMD_KAB.dbo.Ta_KIB_D
		WHERE (Kd_Prov = @Kd_Prov) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)

		INSERT INTO Ta_P3D_Rinc(No_BAST, IDPemda, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB)
		SELECT @No_BAST, RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, B.NoId), 4) AS IDPemda, 
			@Kd_BidangTo  AS Kd_Bidang, @Kd_UnitTo AS Kd_Unit, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB
		FROM BMD_KAB.dbo.Ta_KIB_D A INNER JOIN tmpTa_KIB_D B ON A.IDPemda = B.IDPemda
		WHERE (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

		INSERT INTO Ta_KIB_D(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Konstruksi, Panjang, Lebar, Luas, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, Kd_Tanah1, Kd_Tanah2,
			Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan,
			Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus, No_SIPPT)
		SELECT RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, B.NoId), 4) AS IDPemda,
			A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo, @Kd_UnitTo, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			11 AS Kd_Pemilik, A.Tgl_Perolehan, @D2, A.Konstruksi, A.Panjang, A.Lebar, A.Luas, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah, A.Kd_Tanah1, A.Kd_Tanah2,
			A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_usul, C.Kondisi, C.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan AS Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan,
			A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, 9 AS Kd_Data, A.Kd_KA, A.Log_User, A.Log_Entry, A.Kd_Hapus, '(P3D : '+@Kd_Kab_Kota_Asal+'.'+A.IDPemda+')' AS No_SIPPT
		FROM BMD_KAB.dbo.Ta_KIB_D A INNER JOIN 
			tmpTa_KIB_D B ON A.IDPemda = B.IDPemda INNER JOIN
			BMD_KAB.dbo.fn_Kartu_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota_Asal, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%', '%', '%', '%', @JLap) C ON
				A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
				AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
				AND A.No_Register = C.No_Register
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

		
		/*INSERT INTO Ta_FotoD(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, No_Id,
			Foto_Aset, Nama_foto, Keterangan, Kd_Kecamatan, Kd_Desa, Log_User, Log_entry)
		SELECT RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, A.IDPemda), 4) AS IDPemda,
			A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo, @Kd_UnitTo, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.No_Id,
			A.Foto_Aset, A.Nama_foto, A.Keterangan, A.Kd_Kecamatan, A.Kd_Desa, A.Log_User, A.Log_entry
		FROM BMD_KAB.dbo.Ta_FotoD A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_D B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
		
		INSERT INTO Ta_KIBDR(IDPemda, Kd_Riwayat, Kd_Id, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Konstruksi, Panjang, Lebar, Luas, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, Kd_Tanah1,
			Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa,
			Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_Alasan,
			Log_User, Log_entry, Nm_Rekanan, Alamat_Reakanan, Tgl_Mulai, Tgl_Selesai, Kd_KA)
		SELECT RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
   			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, C.NoId), 4) AS IDPemda,
			A.Kd_Riwayat, A.Kd_Id, A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo, @Kd_UnitTo, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			11 AS Kd_Pemilik, A.Tgl_Dokumen, A.No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Konstruksi, A.Panjang, A.Lebar, A.Luas, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah, A.Kd_Tanah1,
			A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa,
			A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, A.No_Register1, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, 9 AS Kd_Data, A.Kd_Alasan,
			A.Log_User, A.Log_entry, A.Nm_Rekanan, A.Alamat_Reakanan, A.Tgl_Mulai, A.Tgl_Selesai, A.Kd_KA
		FROM BMD_KAB.dbo.Ta_KIBDR A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_D B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register INNER JOIN 
			tmpTa_KIB_D C ON B.IDPemda = C.IDPemda
		WHERE A.Kd_Riwayat NOT IN (5,6)
		AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
		*/

		if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmpTa_KIB_D]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
		drop table [dbo].[tmpTa_KIB_D]

		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'INSERT KIB D error.'
	END

	IF (CHARINDEX('8', @jenis) > 0) AND (@ErrD = '')
	BEGIN
   		INSERT INTO Ref_Rek_Aset2(Kd_Aset1, Kd_Aset2, Nm_Aset2)
		SELECT B.Kd_Aset1, B.Kd_Aset2, (B.Nm_Aset2 + ' - ' + IsNull(@Kd_Kab_Kota_Asal,'')) AS Nm_Aset2
		FROM Ref_Rek_Aset2 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset2 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 5

		INSERT INTO Ref_Rek_Aset3(Kd_Aset1, Kd_Aset2, Kd_Aset3, Nm_Aset3)
		SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, (B.Nm_Aset3 + ' - ' + IsNull(@Kd_Kab_Kota_Asal,'')) AS Nm_Aset3
		FROM Ref_Rek_Aset3 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset3 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 5

		INSERT INTO Ref_Rek_Aset4(Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Nm_Aset4)
		SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, (B.Nm_Aset4 + ' - ' + IsNull(@Kd_Kab_KotaTo,'')) AS Nm_Aset4
		FROM Ref_Rek_Aset4 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset4 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 5

		INSERT INTO Ref_Rek_Aset5(Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Nm_Aset5)
		SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, (B.Nm_Aset5 + ' - ' + @Kd_Kab_KotaTo) AS Nm_Aset5
		FROM Ref_Rek_Aset5 A FULL OUTER JOIN BMD_KAB.dbo.Ref_Rek_Aset5 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
		WHERE A.Kd_Aset1 IS NULL AND B.Kd_Aset1 = 5

		DELETE Ta_P3D_Rinc
		WHERE (No_BAST = @No_BAST) AND (Kd_Bidang = @Kd_BidangTo) AND (Kd_Unit = @Kd_UnitTo) AND (Kd_Sub = @Kd_SubTo) AND (Kd_UPB = @Kd_UPBTo)
		AND SubString(IDPemda,11,1) = '5'

		DELETE Ta_SusutE
		FROM Ta_SusutE A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_E B ON A.IDPemda = B.IDPemda
		WHERE (A.Tahun = @Tahun) AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		DELETE Ta_FotoE
		FROM Ta_FotoE A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_E B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_KotaTo AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_SubTo AND A.Kd_UPB = @Kd_UPBTo
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		DELETE Ta_KIBER
		FROM Ta_KIBER A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_E B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_KotaTo AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_SubTo AND A.Kd_UPB = @Kd_UPBTo
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		DELETE Ta_KIBEHapus
		FROM Ta_KIBEHapus A INNER JOIN
			BMD_KAB.dbo.Ta_KIBEHapus B ON A.No_SK = B.No_SK

		DELETE Ta_KIB_E
		FROM Ta_KIB_E A INNER JOIN
			BMD_KAB.dbo.Ta_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_KotaTo AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_SubTo AND A.Kd_UPB = @Kd_UPBTo
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_BidangTo) AND (B.Kd_Unit LIKE @Kd_UnitTo) AND (B.Kd_Sub LIKE @Kd_SubTo) AND (B.Kd_UPB LIKE @Kd_UPBTo)

		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'DELETE KIB B error.'

		SELECT IDENTITY(int, 1, 1) AS NoId, IDPemda
		INTO tmpTa_KIB_E
		FROM BMD_KAB.dbo.Ta_KIB_E
		WHERE (Kd_Prov = @Kd_Prov) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)

		INSERT INTO Ta_P3D_Rinc(No_BAST, IDPemda, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB)
		SELECT @No_BAST, RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, B.NoId), 4) AS IDPemda, 
			@Kd_BidangTo  AS Kd_Bidang, @Kd_UnitTo AS Kd_Unit, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB
		FROM BMD_KAB.dbo.Ta_KIB_E A INNER JOIN tmpTa_KIB_E B ON A.IDPemda = B.IDPemda
		WHERE (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)

		INSERT INTO Ta_KIB_E(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 
			Kd_Ruang, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Judul, Pencipta, Bahan, Ukuran, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan,
			Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus, No_SIPPT)
		SELECT RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, B.NoId), 4) AS IDPemda,
			A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo, @Kd_UnitTo, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
			A.Kd_Ruang, 11 AS Kd_Pemilik, A.Tgl_Perolehan, @D2, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, C.Kondisi, C.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan AS Keterangan,
			A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, 9 AS Kd_Data, A.Kd_KA, A.Log_User, A.Log_Entry, A.Kd_Hapus, '(P3D : '+@Kd_Kab_Kota_Asal+'.'+A.IDPemda+')' AS No_SIPPT
		FROM BMD_KAB.dbo.Ta_KIB_E A INNER JOIN 
			tmpTa_KIB_E B ON A.IDPemda = B.IDPemda INNER JOIN
			BMD_KAB.dbo.fn_Kartu_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota_Asal, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%', '%', '%', '%', @JLap) C ON
				A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
				AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
				AND A.No_Register = C.No_Register
		WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		
		/*
		INSERT INTO Ta_FotoE(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, No_Id,
			Foto_Aset, Nama_foto, Keterangan, Kd_Kecamatan, Kd_Desa, Log_User, Log_entry)
		SELECT RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, A.IDPemda), 4) AS IDPemda,
			A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo, @Kd_Unit, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.No_Id,
			A.Foto_Aset, A.Nama_foto, A.Keterangan, A.Kd_Kecamatan, A.Kd_Desa, A.Log_User, A.Log_entry
		FROM BMD_KAB.dbo.Ta_FotoE A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_E B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
		
		INSERT INTO Ta_KIBER(IDPemda, Kd_Riwayat, Kd_Id, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Ruang, Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Judul, Pencipta, Bahan, Ukuran, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan,
			Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_Alasan,
			Log_User, Log_entry, Nm_Rekanan, Alamat_Reakanan, Tgl_Mulai, Tgl_Selesai, Kd_KA)
		SELECT RIGHT('0' + CONVERT(varchar, @Kd_BidangTo), 2) + RIGHT('0' + CONVERT(varchar, @Kd_UnitTo), 2) 
			+ RIGHT('00' + CONVERT(varchar, @Kd_SubTo), 3) + RIGHT('00' + CONVERT(varchar, @Kd_UPBTo), 3) 
			+ CONVERT(varchar, A.Kd_Aset1) 
			+ RIGHT('0' + CONVERT(varchar, @Kd_Bidang), 2) + RIGHT('000000' + CONVERT(varchar, C.NoId), 4) AS IDPemda,
			A.Kd_Riwayat, A.Kd_Id, A.Kd_Prov, @Kd_Kab_KotaTo AS Kd_Kab_Kota, @Kd_BidangTo, @Kd_UnitTo, @Kd_SubTo AS Kd_Sub, @Kd_UPBTo AS Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			A.Kd_Ruang, 11 AS Kd_Pemilik, A.Tgl_Dokumen, A.No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan,
			A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, A.No_Register1, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, 9 AS Kd_Data, A.Kd_Alasan,
			A.Log_User, A.Log_entry, A.Nm_Rekanan, A.Alamat_Reakanan, A.Tgl_Mulai, A.Tgl_Selesai, A.Kd_KA
		FROM BMD_KAB.dbo.Ta_KIBER A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_E B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register INNER JOIN 
			tmpTa_KIB_E C ON B.IDPemda = C.IDPemda
		WHERE A.Kd_Riwayat NOT IN (5,6)
		AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
		*/

		if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmpTa_KIB_E]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
		drop table [dbo].[tmpTa_KIB_E]

		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'INSERT KIB E error.'
	END

	IF (CHARINDEX('999', @jenis) > 0) AND (@ErrD = '')
	BEGIN
		DELETE Ta_FotoA
		FROM Ta_FotoA A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_A B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) --AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
			AND B.Kd_Data = 3

		DELETE Ta_FotoB
		FROM Ta_FotoB A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_B B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) --AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
			AND B.Kd_Data = 3

		DELETE Ta_FotoC
		FROM Ta_FotoC A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_C B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) --AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
			AND B.Kd_Data = 3

		DELETE Ta_FotoD
		FROM Ta_FotoD A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_D B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) --AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
			AND B.Kd_Data = 3

		DELETE Ta_FotoE
		FROM Ta_FotoE A INNER JOIN
			BMD_KAB.dbo.Ta_KIB_E B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
					AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
					AND A.No_Register = B.No_Register
		WHERE (B.Kd_Prov = @Kd_Prov) --AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
			AND B.Kd_Data = 3

		DELETE Ta_KIB_A
		FROM Ta_KIB_A A INNER JOIN
			BMD_KAB.dbo.Ta_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		WHERE (B.Kd_Prov = @Kd_Prov) --AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
			AND A.Kd_Data = 3
		
		DELETE Ta_KIB_B
		FROM Ta_KIB_B A INNER JOIN
			BMD_KAB.dbo.Ta_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
		WHERE (B.Kd_Prov = @Kd_Prov) --AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
			AND A.Kd_Data = 3

		DELETE Ta_KIB_C
		FROM Ta_KIB_C A INNER JOIN
			BMD_KAB.dbo.Ta_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
			AND A.Kd_Data = 3

		DELETE Ta_KIB_D
		FROM Ta_KIB_D A INNER JOIN
			BMD_KAB.dbo.Ta_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
			AND A.Kd_Data = 3

		DELETE Ta_KIB_E
		FROM Ta_KIB_E A INNER JOIN
			BMD_KAB.dbo.Ta_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
		WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)
			AND A.Kd_Data = 3

		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'DELETE KIB B error.'

		INSERT INTO Ta_KIB_A(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Luas_M2, Alamat, Hak_Tanah, Sertifikat_Tanggal, Sertifikat_Nomor, Penggunaan, Asal_usul, Harga, Keterangan,
			Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus)
		SELECT IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Luas_M2, Alamat, Hak_Tanah, Sertifikat_Tanggal, Sertifikat_Nomor, Penggunaan, Asal_usul, Harga, Keterangan,
			Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus
		FROM BMD_KAB.dbo.Ta_KIB_A
		WHERE (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			AND Kd_Data IN (3)

		INSERT INTO Ta_KIB_B(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Ruang, Kd_Pemilik, Merk, Type, CC, Bahan, Tgl_Perolehan, Tgl_Pembukuan, Nomor_Pabrik, Nomor_Rangka, Nomor_Mesin, Nomor_Polisi, Nomor_BPKB, 
			Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan,
			Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus)
		SELECT IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Ruang, Kd_Pemilik, Merk, Type, CC, Bahan, Tgl_Perolehan, Tgl_Pembukuan, Nomor_Pabrik, Nomor_Rangka, Nomor_Mesin, Nomor_Polisi, Nomor_BPKB, 
			Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan,
			Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus
		FROM BMD_KAB.dbo.Ta_KIB_B
		WHERE (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			AND Kd_Data IN (3)
 			
		INSERT INTO Ta_KIB_C(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Bertingkat_Tidak, Beton_tidak, Luas_Lantai, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, Kd_Tanah1,
			Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID,
			Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus)
		SELECT IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Bertingkat_Tidak, Beton_tidak, Luas_Lantai, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, Kd_Tanah1,
			Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID,
			Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus
		FROM BMD_KAB.dbo.Ta_KIB_C
		WHERE (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			AND Kd_Data IN (3)

		INSERT INTO Ta_KIB_D(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Konstruksi, Panjang, Lebar, Luas, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, Kd_Tanah1, Kd_Tanah2,
			Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan,
			Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus)
		SELECT IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Konstruksi, Panjang, Lebar, Luas, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, Kd_Tanah1, Kd_Tanah2,
			Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan,
			Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus
		FROM BMD_KAB.dbo.Ta_KIB_D
		WHERE (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			AND Kd_Data IN (3)

		INSERT INTO Ta_KIB_E(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 
			Kd_Ruang, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Judul, Pencipta, Bahan, Ukuran, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan,
			Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus)
		SELECT IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 
			Kd_Ruang, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Judul, Pencipta, Bahan, Ukuran, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan,
			Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus
		FROM BMD_KAB.dbo.Ta_KIB_E
		WHERE (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			AND Kd_Data IN (3)		

		IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'INSERT KIB F error.'
	END

	

	IF @ErrD = ''
		COMMIT TRANSACTION
	ELSE
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR(@ErrD, 16, 1)
	END








GO
