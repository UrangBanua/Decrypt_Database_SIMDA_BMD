USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** SP_Ta_KIBA_Hps - 06112015 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Ta_KIBA_Hps @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), 
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @Reg varchar(4),
	@D2 Datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), 
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @Reg varchar(4), 
	@D2 Datetime

SET @Tahun     = '2015' 
SET @D2 = '20151231'
SET @Kd_Prov   = '99'
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang = '1' 
SET @Kd_Unit   = '1' 
SET @Kd_Sub    = '1'
SET @Kd_UPB    = '1'
SET @Kd_Aset1	= ''
SET @Kd_Aset2	= ''
SET @Kd_Aset3	= ''
SET @Kd_Aset4	= ''
SET @Kd_Aset5	= ''
SET @Reg = ''
*/
	DECLARE @JLap tinyint SET @JLap = 1

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
	IF ISNULL(@Reg, '') = '' SET @Reg = '%'
	

	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85,
		A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
		A.No_Register, A.Kd_Pemilik,
		A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Luas_M2, A.Alamat, A.Hak_Tanah, A.Sertifikat_Tanggal, A.Sertifikat_Nomor, A.Penggunaan, A.Asal_usul, 
		ISNULL(B.Harga, A.Harga) AS Harga, A.Harga AS Harga_A, A.Keterangan,  
		A.Tahun, A.No_SP2D, A.No_Id,  A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, Log_User, Log_entry,
		REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang, 
		REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang_108,
		A.Kd_Hapus
	FROM Ta_KIB_A A LEFT OUTER JOIN 
		fn_Kartu_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @Reg, @JLap) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
			AND A.No_Register = B.No_Register
	WHERE  A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kd_Data <> 3 
	ORDER BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
GO
