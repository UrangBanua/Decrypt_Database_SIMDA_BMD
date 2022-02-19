USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_Ta_Lainnya] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4), @Kd_Aset2 varchar(3)
WITH ENCRYPTION
AS

	IF ISNULL(@Kd_Aset2, '') = '' SET @Kd_Aset2 = '%'

	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Ruang, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
		A.No_Register, A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, A.Kondisi, A.Harga,
		A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_Id, A.Kd_Kecamatan, A.Kd_Desa,
		A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, A.Log_User, A.Log_entry, Kd_Hapus,
		REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
		REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang_108
	FROM Ta_Lainnya A 
	WHERE  A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang
		AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kd_Data <> 3
		AND A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 5 AND A.Kd_Aset81 = 3 AND A.Kd_Aset82 = 1 AND A.Kd_Aset83 = 1 AND A.Kd_Aset84 LIKE @Kd_Aset2
	ORDER BY A.Tgl_Pembukuan, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register

GO
