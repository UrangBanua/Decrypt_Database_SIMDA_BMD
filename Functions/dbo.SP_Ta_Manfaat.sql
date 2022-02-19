USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** SP_Ta_Manfaat - 06042016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Ta_Manfaat @Riwayat varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Riwayat tinyint
SET @Riwayat = '10'
*/

IF ISNULL (@Riwayat,'') = '' SET @Riwayat = '%'

SELECT No_MOU, No_MOURek, Tgl_MOU, Kd_Riwayat, Keterangan
FROM Ta_Manfaat
WHERE Kd_Riwayat LIKE @Riwayat
GO
