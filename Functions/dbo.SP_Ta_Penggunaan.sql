USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[SP_Ta_Penggunaan] @Tahun varchar(4)
WITH ENCRYPTION
AS
	SELECT Tahun, No_SKGuna, Tgl_SKGuna, Keterangan
	FROM Ta_Penggunaan
	WHERE Tahun = @Tahun



GO
