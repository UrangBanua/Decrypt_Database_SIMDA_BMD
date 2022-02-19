USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Ref_Setup - 08112016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Ref_Setup @Tahun varchar(4)
WITH ENCRYPTION
AS
	/*
	DECLARE @Tahun varchar(4)
	SET @Tahun = '2011'
	*/

	SELECT Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Penyebut, Kd_Penambahan, Kd_Batasan 
	FROM Ref_Setup
	WHERE Tahun = @Tahun


GO
