USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_GunaKIBD] @SK_Guna varchar(50)
WITH ENCRYPTION
AS

/*
DECLARE @SK_Guna varchar(50)
SET @SK_GUna = ''
*/

--IF ISNULL(@SK_Guna, '') = '' SET @SK_Guna = '%'
	
SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
	Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Konstruksi, Panjang, Lebar, Luas, Lokasi, Dokumen_Tanggal, Dokumen_Nomor,
	Status_Tanah, Kd_Tanah1, Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, Masa_Manfaat,
	Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan,
	REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.')  AS GabBarang,
	REPLACE(dbo.fn_GabUPB(A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB), ' . ', '.')  AS GabUPB
FROM Ta_KIB_D A
WHERE No_SKGuna LIKE @SK_Guna





GO
