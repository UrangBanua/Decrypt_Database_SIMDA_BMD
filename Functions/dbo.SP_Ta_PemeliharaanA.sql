USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_PemeliharaanA] @Tahun varchar(4), @No_SP2D varchar(50)
WITH ENCRYPTION
AS

/*
DECLARE @Tahun varchar(4), @No_SP2D varchar(50)
SET @Tahun = '2009'
SET @No_SP2D = ''
*/

SELECT IDPemda, Kd_Riwayat, Kd_Id, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
	Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Luas_M2, Alamat, Hak_Tanah, Sertifikat_Tanggal, Sertifikat_Nomor, Penggunaan,
	Asal_usul, Harga, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1,
	No_Register1, Kd_Penyusutan, Invent, No_SKGuna, 
	REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang
FROM Ta_KIBAR A
WHERE Tahun = @Tahun AND No_SP2D = @No_SP2D
GO
