USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[fn_KdLokasi] (@K1 varchar(2), @K2 varchar(2), @K3 varchar(2), @K4 varchar(2), @K5 varchar(2), @K6 varchar(3), @K7 varchar(10), @Thn varchar(4)) 
RETURNS varchar(25)
WITH ENCRYPTION
AS 
BEGIN
	RETURN (RIGHT('0' + @K1, 2) + '.' + RIGHT('0' + @K2, 2) + '.' + RIGHT('0' + @K3, 2) + '.' + RIGHT('0' + @K4, 2) + '.' + RIGHT('0' + @K5, 2) + '.' + RIGHT(@Thn, 2) + '.' + RIGHT('0' + @K6, 3) + '.' + RIGHT('0' + CASE @K7 WHEN '%' THEN '0' ELSE @K7 END, 3))
END






GO
