USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_Pengadaan_SP2D_Total] @Tahun varchar(4), @No_Kontrak varchar(50)
WITH ENCRYPTION
AS
	SELECT A.Tahun, A.No_Kontrak, ISNULL(B.Total, 0) AS Total, ISNULL(C.SP2D, 0) AS SP2D, ISNULL(B.Total, 0) - ISNULL(C.SP2D, 0) AS Sisa, ISNULL(D.SP2D, 0) AS Penunjang
	FROM Ta_Pengadaan A LEFT OUTER JOIN
		(
		SELECT A.Tahun, A.No_Kontrak, SUM(A.Jumlah * A.Harga) AS Total
		FROM Ta_Pengadaan_Rinc A
		GROUP BY A.Tahun, A.No_Kontrak
		) B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak LEFT OUTER JOIN
		(
		SELECT A.Tahun, A.No_Kontrak, SUM(A.Nilai) AS SP2D
		FROM Ta_Pengadaan_SP2D A
		WHERE A.Jn_SP2D = '1'
		GROUP BY A.Tahun, A.No_Kontrak
		) C ON A.Tahun = C.Tahun AND A.No_Kontrak = C.No_Kontrak LEFT OUTER JOIN
		(
		SELECT A.Tahun, A.No_Kontrak, SUM(A.Nilai) AS SP2D
		FROM Ta_Pengadaan_SP2D_Rinc A INNER JOIN
			Ta_Pengadaan_SP2D B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak AND A.No_SP2D = B.No_SP2D
		WHERE B.Jn_SP2D = '2'
		GROUP BY A.Tahun, A.No_Kontrak
		) D ON A.Tahun = D.Tahun AND A.No_Kontrak = D.No_Kontrak
	WHERE (A.Tahun = @Tahun) AND (A.No_Kontrak = @No_Kontrak)





GO
