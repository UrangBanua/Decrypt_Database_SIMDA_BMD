USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_Pengadaan_SP2D] @Tahun varchar(4), @No_Kontrak varchar(50), @Jn_SP2D varchar(1)
WITH ENCRYPTION
AS
	SELECT A.Tahun, A.No_Kontrak, A.No_SP2D, A.Tgl_SP2D, A.Jn_SP2D, A.Nilai, A.Keterangan, A.Kd_Ambil
	FROM Ta_Pengadaan_SP2D A
	WHERE (A.Tahun = @Tahun) AND (A.No_Kontrak = @No_Kontrak) AND (A.Jn_SP2D = @Jn_SP2D)
	ORDER BY Tgl_SP2D, No_SP2D
GO
