USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.SP_Ref_Map_Unit
WITH ENCRYPTION
AS
	SELECT Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UrusanS, Kd_BidangS, Kd_UnitS, Kd_SubS,
		RIGHT('0' + CONVERT(varchar, Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Unit), 2) + '.' + 
		CASE WHEN LEN(Kd_Sub)< 3 then RIGHT('0' + CONVERT(varchar, Kd_Sub), 2) 
			 WHEN LEN(Kd_Sub)= 3 THEN RIGHT('00' + CONVERT(varchar, Kd_Sub), 3) END
		AS Kd_Gab_1,
		CONVERT(varchar, Kd_UrusanS) + '.' + RIGHT('0' + CONVERT(varchar, Kd_BidangS), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_UnitS), 2) + '.' + 
		CASE WHEN LEN(Kd_SubS)< 3 then RIGHT('0' + CONVERT(varchar, Kd_SubS), 2) 
			 WHEN LEN(Kd_SubS)= 3 THEN RIGHT('00' + CONVERT(varchar, Kd_SubS), 3) END
		AS Kd_Gab_2
		
	FROM Ref_Map_Unit


GO
