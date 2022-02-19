USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Ref_Map5_17_108] @Filter varchar(50)
WITH ENCRYPTION
AS
	SELECT [Kd1], [Kd2], [Kd3], [kd4], [Kd5], [Nm_Aset5_17], 
	[Kd_Aset], [Kd_Aset0], [Kd_Aset1], [Kd_Aset2], [Kd_Aset3], [Kd_Aset4], [Kd_Aset5], [Nm_Aset5], 
	[Kd_Sts]
	FROM [Ref_Map5_17_108]
	WHERE ((Nm_Aset5 LIKE '%' + @Filter + '%') OR (Nm_Aset5_17 LIKE '%' + @Filter + '%'))


GO
