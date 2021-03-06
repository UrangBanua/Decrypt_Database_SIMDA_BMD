USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_KIB_C] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3)
SET @Tahun     = '2009' 
SET @Kd_Prov   = '13'
SET @Kd_Kab_Kota = '4'
SET @Kd_Bidang = '5' 
SET @Kd_Unit   = '1' 
SET @Kd_Sub    = '1'
SET @Kd_UPB    = '1'
*/
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,		 
		A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Bertingkat_Tidak, A.Beton_tidak, A.Luas_Lantai,  A.Lokasi, A.Dokumen_Tanggal,
		A.Dokumen_Nomor, A.Status_Tanah, A.Kd_Tanah, A.Kd_Tanah0, A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_usul,		 
		A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_Id, A.Kd_Kecamatan, A.Kd_Desa, A.Invent,
		A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, A.Log_User, A.Log_entry, A.Kd_Hapus,
		REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
		REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang_108
	FROM Ta_KIB_C A 
	WHERE  A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
		AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
	ORDER BY A.Tgl_Pembukuan, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8
GO
