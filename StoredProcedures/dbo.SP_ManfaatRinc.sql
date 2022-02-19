USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE SP_ManfaatRinc @Riwayat varchar(3), @MOU varchar(100)
WITH ENCRYPTION
AS
/*
DECLARE @Riwayat varchar(3), @MOU varchar(100)
SET @Riwayat = '10'
SET @MOU = '0021/MOU-SGU/PEMDA/2012'

SELECT No_MOU, No_MOURek, Tgl_MOU, Kd_Riwayat, Keterangan
FROM Ta_Manfaat
WHERE Kd_Riwayat = @Riwayat AND No_MOU = @MOU
*/
	
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
	    A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.Kd_id,
		A.Tgl_Pembukuan, A.Tgl_Perolehan, A.Sertifikat_Nomor, A.Harga, A.Keterangan, A.Kd_Data, A.Kd_Riwayat,
		REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
		REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang_108
	FROM Ta_KIBAR A
	WHERE A.Kd_Riwayat = @Riwayat AND A.No_Dokumen = @MOU
	
	UNION ALL
	
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.Kd_id,
		A.Tgl_Pembukuan, A.Tgl_Perolehan, A.Nomor_BPKB, A.Harga, A.Keterangan, A.Kd_Data, A.Kd_Riwayat,
		REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
		REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang_108
	FROM Ta_KIBBR A
	WHERE A.Kd_Riwayat = @Riwayat AND A.No_Dokumen = @MOU
	
	UNION ALL
	
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.Kd_id,
		A.Tgl_Pembukuan, A.Tgl_Perolehan, A.Dokumen_Nomor, A.Harga, A.Keterangan, A.Kd_Data, A.Kd_Riwayat,
		REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
		REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang_108
	FROM Ta_KIBCR A
	WHERE A.Kd_Riwayat = @Riwayat AND A.No_Dokumen = @MOU
	
	UNION ALL
	
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.Kd_id,
		A.Tgl_Pembukuan, A.Tgl_Perolehan, A.Dokumen_Nomor, A.Harga, A.Keterangan, A.Kd_Data, A.Kd_Riwayat,
		REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
		REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang_108
	FROM Ta_KIBDR A
	WHERE A.Kd_Riwayat = @Riwayat AND A.No_Dokumen = @MOU






GO
