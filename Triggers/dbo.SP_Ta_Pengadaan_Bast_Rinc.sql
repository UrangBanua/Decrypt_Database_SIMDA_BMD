USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Ta_Pengadaan_Bast_Rinc] @Tahun varchar(4), @No_Bast varchar(50), @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @No_Bast varchar(50), @Kd_Aset1 varchar(3)
SET @Tahun     = '2009' 
SET @No_Bast   = 'NoBast'
SET @Kd_Aset1 = '4'
*/	
	IF ISNULL(@Kd_Aset1, '') = '' SET @Kd_Aset1 = '%'

	SELECT A.Tahun, A.No_BAST, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85,
	REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
	dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85) AS Rek_GabAset108,
	A.No_Register, A.Kd_Pemilik, A.Kd_Ruang,
	A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Judul, A.Type, A.CC, A.Bahan, A.Nomor_Pabrik, A.Nomor_Rangka, 
	A.Nomor_Mesin, A.Nomor_Polisi, A.Nomor_BPKB, A.Luas_Lantai, A.Panjang, A.Lebar, A.Lokasi, 
	A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Hak_Tanah, A.Penggunaan, A.Konstruksi, A.Bertingkat_Tidak, 
	A.Beton_Tidak, A.Pencipta, A.Ukuran, A.Asal_Usul, A.Kondisi, A.Harga, A.Masa_Manfaat, 
	A.Nilai_Sisa, A.Keterangan, A.No_SP2D, A.No_ID, A.Invent, A.Kd_Penyusutan, A.Kd_Data, 
	A.Log_User, A.Log_entry, A.Kd_KA, A.Kd_Hapus 
	FROM Ta_Pengadaan_Bast_Rinc A
	WHERE  A.Tahun = @Tahun AND A.No_BAST = @No_Bast 
	AND A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1
	ORDER BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Pembukuan



GO
