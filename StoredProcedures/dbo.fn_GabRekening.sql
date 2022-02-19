USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF
GO





CREATE FUNCTION [dbo].[fn_GabRekening] (@K1 varchar(2), @K2 varchar(2), @K3 varchar(2), @K4 varchar(2), @K5 varchar(3)) 
RETURNS varchar(23)
WITH ENCRYPTION
AS 
BEGIN
	RETURN (@K1 + ' . ' + @K2 + ' . ' + @K3 + ' . ' + RIGHT('0' + @K4, 2) + ' . ' + RIGHT('0' + @K5, 3))
END







GO
