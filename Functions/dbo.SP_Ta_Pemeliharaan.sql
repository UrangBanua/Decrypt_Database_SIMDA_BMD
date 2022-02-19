USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_Pemeliharaan] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3)
WITH ENCRYPTION
AS
	SELECT A.Tahun, A.No_SP2D, A.Tgl_SP2D, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
		A.No_Kontrak, A.Tgl_Kontrak, A.Nm_Rekanan, A.Tgl_Pemeliharaan, A.Keterangan
	FROM Ta_Pemeliharaan A
	WHERE (A.Tahun = @Tahun) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota)
		AND (A.Kd_Bidang = @Kd_Bidang) AND (A.Kd_Unit = @Kd_Unit) AND (A.Kd_Sub = @Kd_Sub) AND (A.Kd_UPB = @Kd_UPB) 





GO
