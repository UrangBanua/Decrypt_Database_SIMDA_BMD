USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ref_Setting_Penyusutan]
WITH ENCRYPTION
AS
	SELECT 1 AS Kode, 'Pembulatan Tahun Ke Bawah' AS Nama

	UNION ALL

	SELECT 2 AS Kode, 'Pembulatan Tahun Ke Atas' AS Nama

	UNION ALL

	SELECT 3 AS Kode, 'Pembulatan Semester' AS Nama

	UNION ALL

	SELECT 4 AS Kode, 'Aktual Tanggal' AS Nama





GO
