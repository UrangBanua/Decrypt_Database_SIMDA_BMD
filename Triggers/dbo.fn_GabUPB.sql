USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO





CREATE FUNCTION [dbo].[fn_GabUPB] (@K1 varchar(2), @K2 varchar(2), @K3 varchar(3), @K4 varchar(3)) 
RETURNS varchar(20)
WITH ENCRYPTION
AS 
BEGIN
	RETURN (RIGHT('0' + @K1, 2) + '.' + RIGHT('0' + @K2, 2) + '.' + RIGHT('00' + @K3, 3) + '.' + RIGHT('00' + @K4, 3))
END









GO
