USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Par_Desa] @Kd_Prov varchar(2), @Kd_Kab_Kota varchar(2), @Kd_Kecamatan varchar(3)
WITH ENCRYPTION
AS

/*
DECLARE  @Kd_Prov varchar(2), @Kd_Kab_Kota varchar(2), @Kd_Kecamatan varchar(3)
SET @Kd_Prov = '13'
SET @Kd_Kab_Kota = '4'
SET @Kd_Kecamatan = '%'
*/


	SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Kecamatan, A.Kd_Desa, A.Nm_Desa
	FROM	Ref_Desa A
	WHERE	(A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Kecamatan LIKE @Kd_Kecamatan) 
	ORDER BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Kecamatan, A.Kd_Desa





GO
