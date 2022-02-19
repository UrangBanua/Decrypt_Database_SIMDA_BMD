USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



--dibikin JK
--buat pemindahtanganan dan pemusnahan

CREATE PROCEDURE SP_Ta_Pindahtangan @Tahun varchar(4)
WITH ENCRYPTION
AS

SELECT Tahun, No_BA, Tgl_BA, Keterangan, Kd_Musnah
FROM Ta_Pindahtangan
WHERE Tahun = @Tahun




GO
