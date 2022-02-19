USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Ref_Kap_Umur - 08112016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Ref_Kap_Umur @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3)
WITH ENCRYPTION
AS

	IF ISNULL(@Kd_Aset1, '') = '' SET @Kd_Aset1 = '%'
	IF ISNULL(@Kd_Aset2, '') = '' SET @Kd_Aset2 = '%'
	IF ISNULL(@Kd_Aset3, '') = '' SET @Kd_Aset3 = '%'

	SELECT Kd_Aset1, Kd_Aset2, Kd_Aset3, No_Urut, Bts_Bawah, Bts_Atas, Masa_Manfaat, Jn_Kap,
	Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83,
		'0' + CONVERT(varchar, Kd_Aset1) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset3), 2) AS Kd_Gab,
		CONVERT(varchar, Kd_Aset8) + '.' + RIGHT(CONVERT(varchar, Kd_Aset80), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset81), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset82), 2) + '.' + RIGHT('0' + CONVERT(varchar, Kd_Aset83), 2) AS Kd_Gab_108
	FROM Ref_Kap_Umur
	WHERE (Kd_Aset81 LIKE @Kd_Aset1) AND (Kd_Aset82 LIKE @Kd_Aset2) AND (Kd_Aset83 LIKE @Kd_Aset3)
	ORDER BY Kd_Aset81, Kd_Aset82, Kd_Aset83, No_Urut

GO
