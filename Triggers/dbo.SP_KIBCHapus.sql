USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_KIBCHapus] @No_SK varchar(50)
WITH ENCRYPTION
AS

/*
DECLARE @No_SK varchar(50), @KIB varchar(1)
SET @No_SK = ''
SET @KIB = 'D'
*/

IF ISNULL(@No_SK, '') = '' SET @No_SK = '%'

SELECT  IDPemda, No_SK, Tgl_SK, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
	Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 
	Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85,
	Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Bertingkat_Tidak, Beton_tidak, Luas_Lantai, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah,
	Kd_Tanah1, Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan,
	Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, Kd_Alasan, Kd_Penyusutan, No_SKGuna, Kd_KA,
	REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.')  AS GabBarang,
	REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS GabBarang108,
	REPLACE(dbo.fn_GabUPB(A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB), ' . ', '.')  AS GabUPB
FROM Ta_KIBCHAPUS A
WHERE No_SK LIKE @No_SK


GO
