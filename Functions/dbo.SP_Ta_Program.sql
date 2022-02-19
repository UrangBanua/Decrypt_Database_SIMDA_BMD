USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_Program] @Tahun varchar(4), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3)
SET @Tahun     = '' 
SET @Kd_Bidang = '' 
SET @Kd_Unit   = '' 
SET @Kd_Sub    = ''
*/
	SELECT Tahun, Kd_Urusan, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_Prog, ID_Prog, Ket_Program, Target_Angka, Target_Uraian, Tolak_Ukur, Kd_Urusan1, Kd_Bidang1
	FROM Ta_Program
	WHERE Tahun=@Tahun AND Kd_Bidang=@Kd_Bidang AND Kd_Unit=@Kd_Unit AND Kd_Sub=@Kd_Sub AND Kd_Prog <> 0





GO
