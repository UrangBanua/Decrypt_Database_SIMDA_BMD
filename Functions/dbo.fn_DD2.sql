USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[fn_DD2] (@NP money, @NS money, @MM float, @n float, @Metode tinyint)  
RETURNS money
WITH ENCRYPTION
AS  
BEGIN
	DECLARE @AK money

	IF @Metode = 1
	BEGIN
		IF @n < 1
			SET @AK = 0
		ELSE IF @n > @MM
			SET @AK = ROUND(CONVERT(money, (@NP - @NS) / @MM), 2) * @MM
		ELSE
			SET @AK = ROUND(CONVERT(money, (@NP - @NS) / @MM), 2) * @n
	END
	ELSE
	BEGIN
		IF @n = 1
			SET @AK = dbo.fn_DD1(@NP, @NS, @MM, @n, @Metode)
		ELSE IF @n > 1
			SET @AK = dbo.fn_DD2(@NP, @NS, @MM, @n-1, @Metode) + dbo.fn_DD1(@NP, @NS, @MM, @n, @Metode)
		ELSE
			SET @AK = 0
	END

	RETURN(@AK)		
END






GO
