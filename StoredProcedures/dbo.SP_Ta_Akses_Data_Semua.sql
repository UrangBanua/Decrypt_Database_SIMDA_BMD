USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Ta_Akses_Data_Semua -17022017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Ta_Akses_Data_Semua @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Status varchar(1)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Status varchar(1)
SET @Tahun     = '2017' 
SET @Kd_Prov   = '99'
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang = '1' 
SET @Kd_Unit   = '1' 
SET @Kd_Sub    = '1'
SET @Kd_UPB    = '1'
SET @Status    = '1'
*/	
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	IF ISNULL(@Status, '') = '' SET @Status = '%'

	SELECT A.Tahun, A.No_Akses, B.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Akses, A.Status,
		B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.No_Register, B.Keterangan,
		REPLACE(dbo.fn_GabUPB(A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB), ' . ', '.') AS Kd_Gab_UPB,
		REPLACE(dbo.fn_GabBarang(B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang
	FROM Ta_Akses_Data A INNER JOIN Ta_Akses_Data_Rinc B ON A.Tahun = B.Tahun AND A.No_Akses = B.No_Akses
	WHERE A.Tahun = @Tahun AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND A.Status = @Status
	ORDER BY A.Tahun, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5



GO
