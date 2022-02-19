USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Par_Kecamatan] @Kd_Prov varchar(2), @Kd_Kab_Kota varchar(2)
WITH ENCRYPTION
AS

/*
DECLARE  @Kd_Prov varchar(2), @Kd_Kab_Kota varchar(2)
SET @Kd_Prov = '13'
SET @Kd_Kab_Kota = '4'
SET @Kd_Kecamatan = '%'
*/

	SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Kecamatan, A.Nm_Kecamatan
	FROM	Ref_Kecamatan A
	WHERE	(A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) 
	ORDER BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Kecamatan




GO
