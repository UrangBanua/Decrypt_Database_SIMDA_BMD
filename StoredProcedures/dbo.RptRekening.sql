USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[RptRekening] @Tahun varchar(4), @Level tinyint
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Level tinyint
SET @Tahun = '2007'
SET @Level = 5
*/
	DECLARE @tmpHasil TABLE(Tingkat tinyint, Kd_Rek_1 tinyint, Kd_Rek_2 tinyint, Kd_Rek_3 tinyint, Kd_Rek_4 tinyint, Kd_Rek_5 tinyint, Kd_Rek varchar(30), Nm_Rek varchar(255))
		
	INSERT INTO @tmpHasil
	SELECT 1 AS Tingkat, A.Kd_Rek_1, 0 AS Kd_Rek_2, 0 AS Kd_Rek_3, 0 AS Kd_Rek_4, 0 AS Kd_Rek_5,
		CONVERT(varchar, A.Kd_Rek_1) AS Kd_Rek,
		A.Nm_Rek_1 AS Nm_Rek
	FROM Ref_Rek_1 A

	IF @Level > 1
	BEGIN
		INSERT INTO @tmpHasil
		SELECT 2 AS Tingkat, A.Kd_Rek_1, A.Kd_Rek_2, 0 AS Kd_Rek_3, 0 AS Kd_Rek_4, 0 AS Kd_Rek_5,
			CONVERT(varchar, A.Kd_Rek_1) + ' . ' + CONVERT(varchar, A.Kd_Rek_2) AS Kd_Rek,
			A.Nm_Rek_2 AS Nm_Rek
		FROM Ref_Rek_2 A
	END

	IF @Level > 2
	BEGIN
		INSERT INTO @tmpHasil
		SELECT 3 AS Tingkat, A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, 0 AS Kd_Rek_4, 0 AS Kd_Rek_5,
			CONVERT(varchar, A.Kd_Rek_1) + ' . ' + CONVERT(varchar, A.Kd_Rek_2) + ' . ' + CONVERT(varchar, A.Kd_Rek_3) AS Kd_Rek,
			A.Nm_Rek_3 AS Nm_Rek
		FROM Ref_Rek_3 A
	END

	IF @Level > 3
	BEGIN
		INSERT INTO @tmpHasil
		SELECT 4 AS Tingkat, A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, 0 AS Kd_Rek_5,
			CONVERT(varchar, A.Kd_Rek_1) + ' . ' + CONVERT(varchar, A.Kd_Rek_2) + ' . ' + CONVERT(varchar, A.Kd_Rek_3) + ' . ' + CONVERT(varchar, A.Kd_Rek_4) AS Kd_Rek,
			A.Nm_Rek_4 AS Nm_Rek
		FROM Ref_Rek_4 A
	END

	IF @Level = 5
	BEGIN
		INSERT INTO @tmpHasil
		SELECT 5 AS Tingkat, A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5,
			CONVERT(varchar, A.Kd_Rek_1) + ' . ' + CONVERT(varchar, A.Kd_Rek_2) + ' . ' + CONVERT(varchar, A.Kd_Rek_3) + ' . ' + CONVERT(varchar, A.Kd_Rek_4) + ' . ' + CONVERT(varchar, A.Kd_Rek_5) AS Kd_Rek,
			A.Nm_Rek_5 AS Nm_Rek
		FROM Ref_Rek_5 A
	END

	
		SELECT A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5,
			A.Kd_Rek, A.Nm_Rek, A.Tingkat,
			A.MaxTingkat, D.Nm_Pemda, D.Logo
		FROM 
			(
			SELECT A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5,
				A.Kd_Rek, A.Nm_Rek, A.Tingkat, @Level AS MaxTingkat				
			FROM @tmpHasil A
			) A,
			Ref_Pemda D
		ORDER BY A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5, A.Tingkat





GO
