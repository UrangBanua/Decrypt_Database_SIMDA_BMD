USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_Pengadaan_SP2D_Rinc_Total] @Tahun varchar(4), @No_Kontrak varchar(50), @No_SP2D varchar(50), @Jn_SP2D varchar(1)
WITH ENCRYPTION
AS
	SELECT A.Tahun, A.No_Kontrak, A.No_SP2D, A.Jn_SP2D, SUM(A.SP2D) AS SP2D
	FROM
		(
		SELECT A.Tahun, A.No_Kontrak, A.No_SP2D, A.Jn_SP2D, SUM(A.Nilai) AS SP2D
		FROM Ta_Pengadaan_SP2D_Rinc A
		WHERE (Tahun = @Tahun) AND (No_Kontrak = @No_Kontrak) AND (No_SP2D = @No_SP2D) AND (Jn_SP2D = @Jn_SP2D)
		GROUP BY A.Tahun, A.No_Kontrak, A.No_SP2D, A.Jn_SP2D
	
		UNION ALL
	
		SELECT @Tahun, @No_Kontrak, @No_SP2D, @Jn_SP2D, 0 AS SP2D
		) A
	GROUP BY A.Tahun, A.No_Kontrak, A.No_SP2D, A.Jn_SP2D





GO
