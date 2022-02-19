USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[RptKebijakanAkuntansi]
WITH ENCRYPTION
AS

SELECT A.Tahun, A.Kd_Prov, A.Kd_Kab_Kota, 
	CONVERT(varchar, A.Kd_Aset8) + '.' + CONVERT(varchar, A.Kd_Aset80) + '.' + '0' + CONVERT(varchar, A.Kd_Aset81) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset82), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset83), 2) + '.' + RIGHT('0' + CONVERT(varchar, B.Kd_Aset4), 2)AS Kd_Gab,
       B.Nm_Aset4, A.MinSatuan, C.*
FROM   Ta_KA A LEFT OUTER JOIN
       Ref_Rek4_108 B ON A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3,
		(
		SELECT TOP 1 Nm_Pemda, NULL AS Logo
		FROM Ref_Pemda
		) C
WHERE A.Kd_Aset81 IN (1, 2, 3, 4, 5)
GROUP BY A.Tahun, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, B.Nm_Aset4, A.MinSatuan, B.Kd_Aset4,
		C.Nm_Pemda, C.Logo
ORDER BY  A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83


GO
