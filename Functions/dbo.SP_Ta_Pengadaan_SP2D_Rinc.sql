USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_Pengadaan_SP2D_Rinc] @Tahun varchar(4), @No_Kontrak varchar(50), @No_SP2D varchar(50), @Jn_SP2D varchar(1)
WITH ENCRYPTION
AS
	SELECT Tahun, No_Kontrak, No_SP2D, Jn_SP2D, No_ID, Kd_Rek_1, Kd_Rek_2, Kd_Rek_3, Kd_Rek_4, Kd_Rek_5, Nilai,
		dbo.fn_GabRekening(Kd_Rek_1, Kd_Rek_2, Kd_Rek_3, Kd_Rek_4, Kd_Rek_5) AS Kd_Gab
	FROM Ta_Pengadaan_SP2D_Rinc
	WHERE (Tahun = @Tahun) AND (No_Kontrak = @No_Kontrak) AND (No_SP2D = @No_SP2D) AND (Jn_SP2D = @Jn_SP2D)





GO
