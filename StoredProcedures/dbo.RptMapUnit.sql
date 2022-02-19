USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE dbo.RptMapUnit
WITH ENCRYPTION
AS
	SELECT 
		RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + 
		CASE WHEN LEN(A.Kd_Sub)< 3 THEN RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) 
			 WHEN LEN(A.Kd_Sub)= 3 THEN RIGHT('00' + CONVERT(varchar, A.Kd_Sub), 3) END
		AS Kd_Gab_1,
		CONVERT(varchar, B.Kd_UrusanS) + '.' + RIGHT('0' + CONVERT(varchar, B.Kd_BidangS), 2) + '.' + RIGHT('0' + CONVERT(varchar, B.Kd_UnitS), 2) + '.' + 
		CASE WHEN LEN(B.Kd_SubS)< 3 THEN RIGHT('0' + CONVERT(varchar, B.Kd_SubS), 2) 
			 WHEN LEN(B.Kd_SubS)= 3 THEN RIGHT('00' + CONVERT(varchar, B.Kd_SubS), 3) END AS Kd_Gab_2,
		A.Nm_Sub_Unit, B.Nm_Sub_Unit AS Nm_S_Sub_Unit, C.Nm_Pemda, C.Logo
	FROM Ref_Sub_Unit A LEFT OUTER JOIN
		(
		SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UrusanS, A.Kd_BidangS, A.Kd_UnitS, A.Kd_SubS, B.Nm_Sub_Unit
		FROM Ref_Map_Unit A INNER JOIN
			Ref_S_Sub_Unit B ON A.Kd_UrusanS = B.Kd_Urusan AND A.Kd_BidangS = B.Kd_Bidang AND A.Kd_UnitS = B.Kd_Unit AND A.Kd_SubS = B.Kd_Sub
		) B ON A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub, 
		Ref_Pemda C
	ORDER BY CASE ISNULL(B.Kd_Bidang, 0) WHEN 0 THEN 0 ELSE 1 END,
		A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub






GO
