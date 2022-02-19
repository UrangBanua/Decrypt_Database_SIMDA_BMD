USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
 
CREATE TRIGGER trgCekRef_Sub_Unit ON dbo.Ref_Sub_Unit
WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE
AS
	DECLARE @Str varchar(255)
	SET @Str = APP_NAME()
 
	IF (@Str LIKE 'MS SQLEM%') OR (@Str LIKE 'SQL Query%') OR (@Str LIKE '%SQL Server Management Studio%')
	BEGIN
		RAISERROR('Property cannot be updated or deleted. [BMD 2.0.7.11]', 16, 1)
		ROLLBACK TRANSACTION
	END
GO
