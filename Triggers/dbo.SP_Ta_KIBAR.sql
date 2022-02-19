USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE SP_Ta_KIBAR @Riwayat varchar(3), @IDPemda varchar(17), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Aset1 varchar(2), @Aset2 varchar(3), @Aset3 varchar(3), @Aset4 varchar(3), @Aset5 varchar(3), @Reg varchar(5)
WITH ENCRYPTION
AS

/*
DECLARE @Riwayat varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Aset1 varchar(2), @Aset2 varchar(3), @Aset3 varchar(3), @Aset4 varchar(3), @Aset5 varchar(3), @Reg varchar(5)
SET @Kd_Prov = ''
SET @Kd_Kab_Kota = ''
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @Kd_UPB = ''
SET @Riwayat = ''
SEt @Aset1 = ''
SEt @Aset2 = ''
SEt @Aset3 = ''
SEt @Aset4 = ''
SEt @Aset5 = ''
SEt @Reg = ''
*/

SELECT A.IDPemda, A.No_Urut, A.Kd_Riwayat, A.Kd_ID, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
	A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85,
	A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Tgl_Dokumen, A.No_Dokumen, A.Luas_M2, A.Alamat, A.Hak_Tanah, A.Sertifikat_Tanggal, A.Sertifikat_Nomor, A.Penggunaan, A.Asal_usul, A.Harga, A.Keterangan,
	A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, 
	REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
	REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang_108,
	REPLACE(dbo.fn_GabUPB(A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB), ' . ', '.')  AS GabUPB,
	A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, A.No_Register1, A.Kd_Penyusutan, Kd_Data, A.Invent, A.No_SKGuna, A.Kd_Alasan, Log_User, Log_entry,
	A.Nm_Rekanan, A.Alamat_Reakanan, A.Tgl_Mulai, A.Tgl_Selesai, A.Kd_KA, Kd_Koreksi
FROM Ta_KIBAR A
WHERE A.Kd_Riwayat = @Riwayat AND A.IDPemda = @IDPemda
	--AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKe @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	--AND A.Kd_Aset1 = @Aset1 AND A.Kd_ASet2 = @Aset2 AND A.Kd_Aset3 = @Aset3 AND A.Kd_Aset4 = @Aset4 AND A.Kd_Aset5 = @Aset5 AND A.No_Register = @Reg
ORDER BY A.IDPemda, A.Kd_ID

GO
