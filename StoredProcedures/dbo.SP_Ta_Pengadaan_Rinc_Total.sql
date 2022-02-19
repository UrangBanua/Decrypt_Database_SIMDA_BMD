USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_Pengadaan_Rinc_Total] @Tahun varchar(4), @No_Kontrak varchar(50)
WITH ENCRYPTION
AS
	SELECT A.Tahun, A.No_Kontrak, SUM(A.Total) AS Total
	FROM
		(
		SELECT A.Tahun, A.No_Kontrak, (A.Jumlah * A.Harga) AS Total
		FROM Ta_Pengadaan_Rinc A
		WHERE (A.Tahun = @Tahun) AND (A.No_Kontrak = @No_Kontrak)
	
		UNION ALL
	
		SELECT @Tahun, @No_Kontrak, 0 AS Total
		) A
	GROUP BY A.Tahun, A.No_Kontrak





GO
