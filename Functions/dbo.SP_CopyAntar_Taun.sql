USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** SP_Par_Sub_Unit - 09042020 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE [dbo].[SP_CopyAntar_Taun] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Tahun2 varchar(4)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Tahun2 varchar(4) 
SET @Tahun = '2020'
SET @Kd_Prov = '9'
SET @Kd_Kab_Kota = '1'
SET @Kd_Bidang = '2'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '3'
SET @Tahun2 = '2019'
*/
	DECLARE @ErrD varchar(255)
	SET @ErrD = ''
	
	IF ISNULL(@Kd_Prov, '') = '' SET @Kd_Prov = '%'
	IF ISNULL(@Kd_Kab_Kota, '') = '' SET @Kd_Kab_Kota = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

	BEGIN TRANSACTION
	
	DELETE	Ta_Ruang
	WHERE	(Tahun = @Tahun) AND (Kd_Prov LIKE @Kd_Prov) AND (Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (KD_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) 

	DELETE	Ta_UPB
	WHERE	(Tahun = @Tahun) AND (Kd_Prov LIKE @Kd_Prov) AND (Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (KD_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)  

	DELETE	Ta_Sub_Unit
	WHERE	(Tahun = @Tahun) AND (Kd_Prov LIKE @Kd_Prov) AND (Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (KD_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub)  

	DELETE	Ta_Pemda
	WHERE	(Tahun = @Tahun) AND (Kd_Prov LIKE @Kd_Prov) AND (Kd_Kab_Kota LIKE @Kd_Kab_Kota)

	DELETE Ta_KA
	WHERE	(Tahun = @Tahun) AND (Kd_Prov LIKE @Kd_Prov) AND (Kd_Kab_Kota LIKE @Kd_Kab_Kota)

	DELETE Ta_KA2
	WHERE	(Tahun = @Tahun) AND (Kd_Prov LIKE @Kd_Prov) AND (Kd_Kab_Kota LIKE @Kd_Kab_Kota)

	DELETE Ref_Penyusutan
	WHERE	(Tahun = @Tahun) 
	
	IF (@@ERROR <> 0) AND (@ErrD = '') SET @ErrD = 'DELETE Parameter error.'
	
	IF (@ErrD = '')
	BEGIN

		INSERT INTO	Ta_Pemda(Tahun, Kd_Prov, Kd_Kab_Kota, Nm_PimpDaerah, Jab_PimpDaerah, Nm_Sekda, NIP_Sekda, Jbt_Sekda, Nm_Ka_Umum,
					NIP_Ka_Umum, Jbt_Ka_Umum, Nm_Ka_Keu, NIP_Ka_Keu, Jbt_Ka_Keu)
		SELECT		@Tahun, Kd_Prov, Kd_Kab_Kota, Nm_PimpDaerah, Jab_PimpDaerah, Nm_Sekda, NIP_Sekda, Jbt_Sekda, Nm_Ka_Umum,
				NIP_Ka_Umum, Jbt_Ka_Umum, Nm_Ka_Keu, NIP_Ka_Keu, Jbt_Ka_Keu
		FROM		Ta_Pemda
		WHERE		(Tahun = @Tahun2) AND (Kd_Prov LIKE @Kd_Prov) AND (Kd_Kab_Kota LIKE @Kd_Kab_Kota)

		INSERT INTO	Ta_Sub_Unit(Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Alamat)
		SELECT		@Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Alamat
		FROM		Ta_Sub_Unit
		WHERE		(Tahun = @Tahun2) AND (Kd_Prov LIKE @Kd_Prov) AND (Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (KD_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) 

		INSERT INTO	Ta_UPB(Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Nm_Pimpinan, NIP_Pimpinan, Jbt_Pimpinan,
					Nm_Pengurus, NIP_Pengurus, Jbt_Pengurus, Nm_Penyimpan, NIP_Penyimpan, Jbt_Penyimpan, Alamat)
		SELECT		@Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Nm_Pimpinan, NIP_Pimpinan, Jbt_Pimpinan,
				Nm_Pengurus, NIP_Pengurus, Jbt_Pengurus, Nm_Penyimpan, NIP_Penyimpan, Jbt_Penyimpan, Alamat
		FROM		Ta_UPB
		WHERE		(Tahun = @Tahun2) AND (Kd_Prov LIKE @Kd_Prov) AND (Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (KD_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub)AND (Kd_UPB LIKE @Kd_UPB)

		INSERT INTO	Ta_Ruang(Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Ruang, Nm_Ruang, Nm_Pngjwb, Nip_Pngjwb, Jbt_Pngjwb, Kd_Bidang1, Kd_Unit1,
					Kd_Sub1, Kd_UPB1, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik)
				
		SELECT		@Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Ruang, Nm_Ruang, Nm_Pngjwb, Nip_Pngjwb, Jbt_Pngjwb, Kd_Bidang1, Kd_Unit1,
				Kd_Sub1, Kd_UPB1, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik
		FROM		Ta_Ruang
		WHERE		(Tahun = @Tahun2) AND (Kd_Prov LIKE @Kd_Prov) AND (Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (KD_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub)AND (Kd_UPB LIKE @Kd_UPB)

		INSERT INTO	Ta_KA(Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Aset1, Kd_Aset2, Kd_Aset3, MinSatuan, MinTotal, ThnPenyusutan, Kd_KA, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83)
		SELECT 	 	@Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Aset1, Kd_Aset2, Kd_Aset3, MinSatuan, MinTotal, ThnPenyusutan, Kd_KA, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83
		FROM		Ta_KA
		WHERE 		(Tahun = @Tahun2)

		INSERT INTO	Ta_KA2(Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83)
		SELECT		@Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83
		FROM		Ta_KA2
		WHERE		(Tahun = @Tahun2)

		INSERT INTO	Ref_Penyusutan(Tahun, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Metode, Umur, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84)
		SELECT		@Tahun, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Metode, Umur, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84
		FROM		Ref_Penyusutan
		WHERE 		(Tahun = @Tahun2)
		
	END

	IF @ErrD = ''
	COMMIT TRANSACTION
	ELSE
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR(@ErrD, 16, 1)
	END






GO
