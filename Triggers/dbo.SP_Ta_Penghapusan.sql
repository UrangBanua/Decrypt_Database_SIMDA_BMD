USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** SP_Ta_Penghapusan - 06112015 - Modified for Ver 2.0.7 [demi@simda.id] ***/

CREATE PROCEDURE [dbo].[SP_Ta_Penghapusan] @Tahun varchar(4), @KdHapus  varchar(1)
WITH ENCRYPTION
AS
	SELECT Tahun, No_SK, Tgl_SK, Keterangan, Kd_Hapus
	FROM Ta_Penghapusan
	WHERE Tahun = @Tahun AND Kd_Hapus = @KdHapus

GO
