﻿USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Par_Bidang]
WITH ENCRYPTION
AS
	SELECT Kd_Bidang, Nm_Bidang
	FROM Ref_Bidang




GO