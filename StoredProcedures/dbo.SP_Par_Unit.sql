USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[SP_Par_Unit] @Kd_Prov varchar(2), @Kd_Kab_Kota varchar(2), @Kd_Bidang varchar(2), @Nm_Unit varchar(50), @UserID Varchar(50)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Prov varchar(2), @Kd_Kab_Kota varchar(2), @Kd_Bidang varchar(2), @Nm_Unit varchar(50), @StsSatker varchar(3), @UserID Varchar(50)
SET @Kd_Prov   = '9'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '%'
SET @Nm_Unit   = '%'
SET @UserID    = '%'
*/
	IF EXISTS(SELECT * FROM Ta_User_Satker WHERE User_ID = @UserID)
	BEGIN	
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Nm_Unit
		FROM Ref_Unit A INNER JOIN
			Ta_User_Satker B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit 	
		WHERE B.User_ID = @UserID AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Nm_Unit LIKE @Nm_Unit
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Nm_Unit
		ORDER BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit
	END
	ELSE
	BEGIN
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Nm_Unit
		FROM Ref_Unit A
		WHERE (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (Nm_Unit LIKE '%' + @Nm_Unit + '%')
	END
GO
