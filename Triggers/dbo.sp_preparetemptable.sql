USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_preparetemptable]
WITH ENCRYPTION
AS
	SET NOCOUNT ON

	if not exists (select * from tempdb..sysobjects where name = '##tmp')
	BEGIN	
		CREATE TABLE ##tmp(NoReg int)
		
		DECLARE @i int
		
		SET @i = 1
		
		WHILE (@i < 10000)
		BEGIN
			INSERT INTO ##tmp VALUES(@i)
			SET @i = @i + 1
		END
	END





GO
