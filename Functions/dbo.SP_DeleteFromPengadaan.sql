USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_DeleteFromPengadaan] @Tahun varchar(4), @No_SP2D varchar(50)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @No_SP2D varchar(50), @No_Id varchar(5)
SET @Tahun = '2007'
SET @No_SP2D = '0001/SP2D/07'
SET @No_ID = '1'
*/
	---KIB
	DELETE Ta_KIB_A
	WHERE (Tahun = @Tahun) AND (No_SP2D = @No_SP2D)

	DELETE Ta_KIB_B
	WHERE (Tahun = @Tahun) AND (No_SP2D = @No_SP2D)

	DELETE Ta_KIB_C
	WHERE (Tahun = @Tahun) AND (No_SP2D = @No_SP2D)

	DELETE Ta_KIB_D
	WHERE (Tahun = @Tahun) AND (No_SP2D = @No_SP2D)

	DELETE Ta_KIB_E
	WHERE (Tahun = @Tahun) AND (No_SP2D = @No_SP2D)

	---Penunjang
	DELETE Ta_PENA
	WHERE  (No_Kontrak = @No_SP2D)

	DELETE Ta_PENB
	WHERE  (No_Kontrak = @No_SP2D)

	DELETE Ta_PENC
	WHERE  (No_Kontrak = @No_SP2D)

	DELETE Ta_PEND
	WHERE  (No_Kontrak = @No_SP2D)

	DELETE Ta_PENE
	WHERE  (No_Kontrak = @No_SP2D)





GO
