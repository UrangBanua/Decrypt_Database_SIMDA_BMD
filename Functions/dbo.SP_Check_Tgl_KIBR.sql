USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE SP_Check_Tgl_KIBR @JenisKIB varchar(3), @IDPemda varchar(17)
WITH ENCRYPTION
AS

/*
DECLARE @JenisKIB varchar(3), @IDPemda varchar(3)
SET @JenisKIB = ''
SET @IDPemda  = ''
*/

IF @JenisKIB = 'A'
BEGIN
  SELECT TOP 1 A.Tgl_Dokumen
  FROM Ta_KIBAR A 
  WHERE IDPemda = @IDPemda
  ORDER BY A.Tgl_Dokumen ASC
END

ELSE IF @JenisKIB = 'B'
BEGIN
  SELECT TOP 1 A.Tgl_Dokumen
  FROM Ta_KIBBR A 
  WHERE IDPemda = @IDPemda
  ORDER BY A.Tgl_Dokumen ASC
END

ELSE IF @JenisKIB = 'C'
BEGIN
  SELECT TOP 1 A.Tgl_Dokumen
  FROM Ta_KIBCR A 
  WHERE IDPemda = @IDPemda
  ORDER BY A.Tgl_Dokumen ASC
END

ELSE IF @JenisKIB = 'D'
BEGIN
  SELECT TOP 1 A.Tgl_Dokumen
  FROM Ta_KIBDR A 
  WHERE IDPemda = @IDPemda
  ORDER BY A.Tgl_Dokumen ASC
END

ELSE IF @JenisKIB = 'E'
BEGIN
  SELECT TOP 1 A.Tgl_Dokumen
  FROM Ta_KIBER A 
  WHERE IDPemda = @IDPemda
  ORDER BY A.Tgl_Dokumen ASC
END


GO
