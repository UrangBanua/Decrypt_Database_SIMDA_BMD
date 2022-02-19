USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[SP_Par_S_Sub_Unit] @Kd_Urusan varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Urusan varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3)
SET @Kd_Urusan = '%'
SET @Kd_Bidang   = '%'
SET @Kd_Unit    = '%'
*/

	SELECT A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Nm_Sub_Unit
	FROM Ref_S_Sub_Unit A
	WHERE A.Kd_Urusan = @Kd_Urusan AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit
GO
