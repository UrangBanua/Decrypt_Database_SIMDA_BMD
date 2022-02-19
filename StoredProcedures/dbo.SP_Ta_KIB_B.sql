USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_KIB_B] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Data varchar(3)
SET @Tahun	= '2011' 
SET @Kd_Prov	= '99'
SET @Kd_Kab_Kota= '99'
SET @Kd_Bidang	= '1' 
SET @Kd_Unit	= '1' 
SET @Kd_Sub	= '1'
SET @Kd_UPB	= '1'
*/

	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Ruang,
		A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, 
		A.Merk, A.Type, A.CC, A.Bahan, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, 
		A.Nomor_Polisi, A.Nomor_BPKB, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan,  
		A.Tahun, A.No_SP2D, A.No_Id, A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, A.Log_User, A.Log_entry, A.Kd_Hapus,
		REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
		REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang_108
	FROM Ta_KIB_B A
	WHERE  A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		 --AND A.Kd_Data IN (1,2)
    ORDER BY A.Tgl_Pembukuan, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8
GO
