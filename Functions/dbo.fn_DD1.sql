USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[fn_DD1] (@NP money, @NS money, @MM float, @n float, @Metode tinyint) 
RETURNS money
WITH ENCRYPTION
AS  
BEGIN 
	DECLARE @Hasil money

	IF @Metode = 1
	BEGIN
		IF @n = 0
			SET @Hasil = 0
		ELSE IF @n > @MM
			SET @Hasil = 0
		ELSE
			SET @Hasil = ROUND(CONVERT(money, (@NP - @NS) / @MM), 2)
	END
	ELSE
	BEGIN
		
		IF @n = 0
			SET @Hasil = 0
		ELSE IF @n = @MM
			SET @Hasil = ROUND(CONVERT(money, @MM * POWER((@MM-2)/@MM, (@n-1)) * ((@NP-@NS)/@MM)), 2)
		ELSE IF @n < @MM
			SET @Hasil = ROUND(CONVERT(money, 2 * POWER((@MM-2)/@MM, (@n-1)) * ((@NP-@NS)/@MM)), 2)
		ELSE
			SET @Hasil = 0
	END

	RETURN(@Hasil)
END







GO
