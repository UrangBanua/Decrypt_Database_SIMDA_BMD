USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** RptBarang - 12122015 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE [dbo].[RptBarang] @Tahun varchar(4), @Level tinyint
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Level tinyint
SET @Tahun = '2007'
SET @Level = 5
*/
	DECLARE @tmpHasil TABLE(Tingkat tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, Kd_Rek varchar(30), Nm_Rek varchar(255))
		
	INSERT INTO @tmpHasil
	SELECT 1 AS Tingkat, A.Kd_Aset1, 0 AS Kd_Aset2, 0 AS Kd_Aset3, 0 AS Kd_Aset4, 0 AS Kd_Aset5,
		CONVERT(varchar, A.Kd_Aset1) AS Kd_Rek,
		A.Nm_Aset1 AS Nm_Rek
	FROM Ref_Rek_Aset1 A

	IF @Level > 1
	BEGIN
		INSERT INTO @tmpHasil
		SELECT 2 AS Tingkat, A.Kd_Aset1, A.Kd_Aset2, 0 AS Kd_Aset3, 0 AS Kd_Aset4, 0 AS Kd_Aset5,
			CONVERT(varchar, A.Kd_Aset1) + ' . ' + CONVERT(varchar, A.Kd_Aset2) AS Kd_Rek,
			A.Nm_Aset2 AS Nm_Rek
		FROM Ref_Rek_Aset2 A
	END

	IF @Level > 2
	BEGIN
		INSERT INTO @tmpHasil
		SELECT 3 AS Tingkat, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, 0 AS Kd_Aset4, 0 AS Kd_Aset5,
			CONVERT(varchar, A.Kd_Aset1) + ' . ' + CONVERT(varchar, A.Kd_Aset2) + ' . ' + CONVERT(varchar, A.Kd_Aset3) AS Kd_Rek,
			A.Nm_Aset3 AS Nm_Rek
		FROM Ref_Rek_Aset3 A
	END

	IF @Level > 3
	BEGIN
		INSERT INTO @tmpHasil
		SELECT 4 AS Tingkat, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, 0 AS Kd_Aset5,
			CONVERT(varchar, A.Kd_Aset1) + ' . ' + CONVERT(varchar, A.Kd_Aset2) + ' . ' + CONVERT(varchar, A.Kd_Aset3) + ' . ' + CONVERT(varchar, A.Kd_Aset4) AS Kd_Rek,
			A.Nm_Aset4 AS Nm_Rek
		FROM Ref_Rek_Aset4 A
	END

	IF @Level = 5
	BEGIN
		INSERT INTO @tmpHasil
		SELECT 5 AS Tingkat, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			CONVERT(varchar, A.Kd_Aset1) + ' . ' + CONVERT(varchar, A.Kd_Aset2) + ' . ' + CONVERT(varchar, A.Kd_Aset3) + ' . ' + CONVERT(varchar, A.Kd_Aset4) + ' . ' + CONVERT(varchar, A.Kd_Aset5) AS Kd_Rek,
			A.Nm_Aset5 AS Nm_Rek
		FROM Ref_Rek_Aset5 A
	END

	
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
			A.Kd_Rek, A.Nm_Rek, A.Tingkat,
			A.MaxTingkat, D.Nm_Pemda, NULL AS Logo
		FROM 
			(
			SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
				A.Kd_Rek, A.Nm_Rek, A.Tingkat, @Level AS MaxTingkat				
			FROM @tmpHasil A
			) A,
			Ref_Pemda D
		ORDER BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Tingkat

GO
