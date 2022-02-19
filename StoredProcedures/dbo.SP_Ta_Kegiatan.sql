USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_Kegiatan] @Tahun varchar(4), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_Prog varchar(3), @ID_Prog varchar(5)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_Prog varchar(3), @ID_Prog varchar(5)
SET @Tahun     = '' 
SET @Kd_Bidang = '' 
SET @Kd_Unit   = '' 
SET @Kd_Sub    = ''
SET @Kd_Prog   = ''
SET @Id_Prog   = ''
*/
	SELECT Tahun, Kd_Urusan, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_Prog, ID_Prog, Kd_Keg, Ket_Kegiatan, Lokasi, Kelompok_Sasaran,  Status_Kegiatan, Pagu_Anggaran, Waktu_Pelaksanaan, Kd_Sumber
	FROM Ta_Kegiatan
	WHERE Tahun=@Tahun AND Kd_Bidang=@Kd_Bidang AND Kd_Unit=@Kd_Unit AND Kd_Sub=@Kd_Sub AND Kd_Prog=@Kd_Prog  AND ID_Prog=@ID_Prog AND Kd_Keg <> 0





GO
