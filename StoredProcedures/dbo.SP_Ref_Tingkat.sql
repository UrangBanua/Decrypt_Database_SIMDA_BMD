USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/****** Object : SP_Ref_Tingkat  First Created : 15/03/2006 10:00:00 By [Herry - 0852 1821 9951] ******/

CREATE PROCEDURE [dbo].[SP_Ref_Tingkat]
WITH ENCRYPTION
AS

SELECT Kd_Level, Nm_Level
FROM Ref_Tingkat




GO
