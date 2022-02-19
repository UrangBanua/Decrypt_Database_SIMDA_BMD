USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE SP_PindahTanganA @No_BA varchar(50)
WITH ENCRYPTION
AS
/*
DECLARE @No_BA varchar(50)
SET @No_BA = ''
*/

SELECT A.No_SK, A.Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
	A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Luas_M2, A.Alamat, A.Hak_Tanah, A.Sertifikat_Tanggal, A.Sertifikat_Nomor, A.Penggunaan, A.Asal_usul, A.Harga,
	A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.Kd_Alasan, A.Kd_Penyusutan, A.No_SKGuna, A.Kd_Data, A.Kd_KA, A.Log_User, A.Log_entry,
	A.No_BA, A.Flag,
	REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.')  AS GabBarang,
	REPLACE(dbo.fn_GabUPB(A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB), ' . ', '.')  AS GabUPB
FROM Ta_KIBAHapus A
WHERE No_BA LIKE @No_BA




GO
