USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SP_Ta_GunaKIBA] @SK_Guna varchar(50)
WITH ENCRYPTION
AS

/*
DECLARE @SK_Guna varchar(50)
SET @SK_GUna = 'sk/guna'
*/

--IF ISNULL(@SK_Guna, '') = '' SET @SK_Guna = '%'

SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
	Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Luas_M2, Alamat, Hak_Tanah, Sertifikat_Tanggal, Sertifikat_Nomor, Penggunaan,
	Asal_usul, Harga, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan,
	REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.')  AS GabBarang,
	REPLACE(dbo.fn_GabUPB(A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB), ' . ', '.')  AS GabUPB
FROM Ta_KIB_A A
WHERE No_SKGuna = @SK_Guna





GO
