USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Ta_Penghapusan_Rinc] @Tahun varchar(4), @No_SK varchar(50)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @No_SK varchar(50)
SET @Tahun = '2009'
SET @No_SK = 'xxx'
*/
	SELECT Tahun, No_SK, No_ID, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kondisi, Kd_Alasan, Alasan, Keterangan, Kd_Pemilik, Tgl_Perolehan,
		REPLACE(dbo.fn_GabBarang(Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5), ' . ', '.') AS Rek_GabAset,
		dbo.fn_KdLokasi(Kd_Pemilik, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, YEAR(Tgl_Perolehan)) AS Kd_Lokasi, Harga
	FROM Ta_Penghapusan_Rinc
	WHERE (Tahun = @Tahun) AND (No_SK = @No_SK)



GO
