USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[fn_KdLokasi2_108] (@K1 varchar(2), @K3 varchar(2), @K4 varchar(2), @K5 varchar(2), @K6 varchar(2), @K7 varchar(3), @K8 varchar(10)) 
RETURNS varchar(30)
WITH ENCRYPTION
AS 
BEGIN
	RETURN (RIGHT('0' + @K1, 2) + '.' + RIGHT('0' + @K3, 2) + '.' + RIGHT('0' + @K4, 2) + '.' + RIGHT('0' + @K5, 2) + '.' + RIGHT('0' + @K6, 2) + '.' + RIGHT('0' + @K7, 3) + '.' + RIGHT('0' + CASE @K8 WHEN '%' THEN '0' ELSE @K8 END, 3) )
END










GO
