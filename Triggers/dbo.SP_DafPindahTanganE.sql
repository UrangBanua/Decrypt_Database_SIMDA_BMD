USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE SP_DafPindahTanganE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), 
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @Reg varchar(4),
	@D2 Datetime
WITH ENCRYPTION
AS

/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @Reg varchar(4),
	@D2 Datetime

SET @Tahun     = '2013' 
SET @D2 = '20131231'
SET @Kd_Prov   = '5'
SET @Kd_Kab_Kota = '1'
SET @Kd_Bidang = '5' 
SET @Kd_Unit   = '' 
SET @Kd_Sub    = ''
SET @Kd_UPB    = ''
SET @Kd_Aset1	= ''
SET @Kd_Aset2	= ''
SET @Kd_Aset3	= ''
SET @Kd_Aset4	= ''
SET @Kd_Aset5	= ''
SET @Reg 	= ''

*/	
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

	DECLARE @JLap tinyint SET @JLap = 0


UPDATE Ta_KIBEHapus
SET Flag = 0

SELECT A.No_SK, A.Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
	A.Kd_Ruang, A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, A.Kondisi, 
	B.Harga, A.Masa_Manfaat, A.Nilai_Sisa,
	A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.Kd_Alasan, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, A.No_SKGuna, 
	A.Log_User, A.Log_entry, A.No_BA, A.Flag,
	REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.')  AS GabBarang,
	REPLACE(dbo.fn_GabUPB(A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB), ' . ', '.')  AS GabUPB
FROM Ta_KIBEHapus A INNER JOIN
	fn_Kartu_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @Reg, @JLap) B ON
		A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
		AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
		AND A.No_Register = B.No_Register
WHERE A.No_BA IS NULL

GO
