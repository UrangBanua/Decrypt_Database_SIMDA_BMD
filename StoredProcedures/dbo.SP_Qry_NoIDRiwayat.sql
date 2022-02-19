﻿USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** SP_Qry_NoIDRiwayat - 20102016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Qry_NoIDRiwayat @IDPemda varchar(18), @Kd_KIB varchar(1)
WITH ENCRYPTION
AS
/*
DECLARE @IDPemda varchar(18), @Kd_KIB varchar(1)
SET @IDPemda = '04010011011000001'
SET @Kd_KIB  = 'A'
*/

	IF @Kd_KIB = 'A'
	BEGIN
		SELECT ISNULL(MAX(Kd_ID),0)+1 AS Kd_ID FROM Ta_KIBAR WHERE IDPemda = @IDPemda 
	END
	ELSE IF @Kd_KIB = 'B'
	BEGIN
		SELECT ISNULL(MAX(Kd_ID),0)+1 AS Kd_ID FROM Ta_KIBBR WHERE IDPemda = @IDPemda 
	END
	ELSE IF @Kd_KIB = 'C'
	BEGIN
		SELECT ISNULL(MAX(Kd_ID),0)+1 AS Kd_ID FROM Ta_KIBCR WHERE IDPemda = @IDPemda 
	END
	ELSE IF @Kd_KIB = 'D'
	BEGIN
		SELECT ISNULL(MAX(Kd_ID),0)+1 AS Kd_ID FROM Ta_KIBDR WHERE IDPemda = @IDPemda 
	END
	ELSE IF @Kd_KIB = 'E'
	BEGIN
		SELECT ISNULL(MAX(Kd_ID),0)+1 AS Kd_ID FROM Ta_KIBER WHERE IDPemda = @IDPemda 
	END






GO
