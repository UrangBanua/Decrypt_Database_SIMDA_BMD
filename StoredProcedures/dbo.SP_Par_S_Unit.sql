USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[SP_Par_S_Unit] @Kd_Urusan varchar(1), @Kd_Bidang varchar(2), @Nm_Unit varchar(50)
WITH ENCRYPTION
AS
	SELECT Kd_Urusan, Kd_Bidang, Kd_Unit, Nm_Unit
	FROM Ref_S_Unit
	WHERE (Kd_Urusan LIKE @Kd_Urusan) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Nm_Unit LIKE @Nm_Unit)





GO
