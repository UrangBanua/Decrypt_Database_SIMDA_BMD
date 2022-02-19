USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Ta_Pengadaan_Bast - 1508016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Ta_Pengadaan_Bast @Tahun varchar(4), @No_Kontrak varchar(50)
WITH ENCRYPTION
AS
	SELECT A.Tahun, A.No_Kontrak, A.No_Bast, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_BAST, A.Uraian
	FROM Ta_Pengadaan_Bast A
	WHERE (A.Tahun = @Tahun) AND (A.No_Kontrak = @No_Kontrak)


GO
