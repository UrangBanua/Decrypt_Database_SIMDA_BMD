USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/***
Deskripsi Store Procedure :
Nama		: SP_Qry_Ref_Rek_5
Form		: F_Up_Rekening
Keterangan	: Di gunakan di Form F_Up_Rekening untuk cari rekening
Dibuat		: 22/11/2006 23:29:00
Oleh		: Iman
***/

CREATE PROCEDURE [dbo].[SP_Qry_Ref_Rek_5] @Kd_Rek_1 varchar(3), @Kd_Rek_2 varchar(3), @Filter varchar(50), @Pil varchar(1)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Rek_1 varchar(3), @Kd_Rek_2 varchar(3), @Filter varchar(50)
SET @Kd_Rek_1 = '4' 
SET @Kd_Rek_2 = '4' 
*/
	IF @Pil = '1'
	BEGIN
		SELECT Kd_Rek_1, Kd_Rek_2, Kd_Rek_3, Kd_Rek_4, Kd_Rek_5, Nm_Rek_5
		FROM Ref_Rek_5
		WHERE (Kd_Rek_1 = @Kd_Rek_1) AND (Kd_Rek_2 LIKE @Kd_Rek_2)
			AND (Nm_Rek_5 LIKE '%' + @Filter + '%')
			AND (Kd_Rek_3 = 3)
	END
	ELSE IF @Pil = '2'
	BEGIN
		SELECT Kd_Rek_1, Kd_Rek_2, Kd_Rek_3, Kd_Rek_4, Kd_Rek_5, Nm_Rek_5
		FROM Ref_Rek_5
		WHERE (Kd_Rek_1 = @Kd_Rek_1) AND (Kd_Rek_2 LIKE @Kd_Rek_2)
			AND (Nm_Rek_5 LIKE '%' + @Filter + '%')
			AND (Kd_Rek_3 IN (2, 3))
	END
	ELSE IF @Pil = '3'
	BEGIN
		SELECT Kd_Rek_1, Kd_Rek_2, Kd_Rek_3, Kd_Rek_4, Kd_Rek_5, Nm_Rek_5
		FROM Ref_Rek_5
		WHERE (Kd_Rek_1 = @Kd_Rek_1) AND (Kd_Rek_2 LIKE @Kd_Rek_2)
			AND (Nm_Rek_5 LIKE '%' + @Filter + '%')
			AND (Kd_Rek_3 IN (1, 2))
	END



GO
