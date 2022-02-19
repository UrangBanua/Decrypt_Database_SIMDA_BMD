USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** SP_KIBLainnyaHapus - 14032018 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_KIBLainnyaHapus @No_SK varchar(50)
WITH ENCRYPTION
AS

/*
DECLARE @No_SK varchar(50)
SET @No_SK = ''
*/

IF ISNULL(@No_SK, '') = '' SET @No_SK = '%'

SELECT IDPemda, No_SK, Tgl_SK, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
	Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 
	Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85,
	Kd_Ruang, Kd_Pemilik, Tgl_Perolehan, Judul, Pencipta, Bahan, Ukuran, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, 
	No_SP2D, No_ID, Tgl_Pembukuan, Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Alasan, Kd_Data, Log_User, Log_entry, Kd_KA, Umur, Dev_Id,
	REPLACE(dbo.fn_GabBarang(Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5), ' . ', '.')  AS GabBarang,
	REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS GabBarang108,
	REPLACE(dbo.fn_GabUPB(Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB), ' . ', '.')  AS GabUPB
FROM Ta_LainnyaHapus
WHERE No_SK LIKE @No_SK



GO
