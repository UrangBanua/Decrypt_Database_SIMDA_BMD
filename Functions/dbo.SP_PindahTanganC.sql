USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE SP_PindahTanganC @No_BA varchar(50)
WITH ENCRYPTION
AS
/*
DECLARE @No_BA varchar(50)
SET @No_BA = ''
*/

SELECT A.No_SK, A.Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
	A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Bertingkat_Tidak, A.Beton_tidak, A.Luas_Lantai, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah,
	A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun,
	A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.Kd_Alasan, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA,No_SKGuna, A.Log_User, A.Log_entry, A.No_BA, A.Flag,
	REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.')  AS GabBarang,
	REPLACE(dbo.fn_GabUPB(A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB), ' . ', '.')  AS GabUPB
FROM Ta_KIBCHapus A
WHERE No_BA LIKE @No_BA




GO
