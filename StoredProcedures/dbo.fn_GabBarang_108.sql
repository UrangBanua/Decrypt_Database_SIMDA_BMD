USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_GabBarang_108] (@K1 varchar(1), @K2 varchar(1), @K3 varchar(3), @K4 varchar(2), @K5 varchar(3), @K6 varchar(3), @K7 varchar(3)) 
RETURNS varchar(33)
WITH ENCRYPTION
AS 
BEGIN
	RETURN (@K1 + '.' + @K2 + '.' + @K3 + '.' + RIGHT('0' + @K4, 2) + '.' + RIGHT('00' + @K5, 3) + '.' + RIGHT('00' + @K6, 3) + '.' + RIGHT('00' + @K7, 3) )
END



















GO
