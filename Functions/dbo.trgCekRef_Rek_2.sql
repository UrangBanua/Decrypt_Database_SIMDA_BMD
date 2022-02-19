﻿USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
 
CREATE TRIGGER trgCekRef_Rek_2 ON dbo.Ref_Rek_2
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
