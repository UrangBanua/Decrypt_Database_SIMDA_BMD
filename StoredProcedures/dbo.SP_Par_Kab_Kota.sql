USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[SP_Par_Kab_Kota] @Kd_Prov varchar(2), @Kd_Kab_Kota varchar(2), @StsSatker varchar(3), @UserID Varchar(50)--,@Nm_Kab_Kota varchar(50)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Prov varchar(2), @Kd_Kab_Kota varchar(2),@Nm_Kab_Kota varchar(50), @StsSatker varchar(3), @UserID Varchar(50)
SET @Kd_Prov   = '9'
SET @Kd_Kab_Kota = '%'
SET @Nm_Kab_Kota   = '%'
SET @UserID    = '%'
*/
	IF EXISTS(SELECT * FROM Ta_User_Satker WHERE User_ID = @UserID)
	BEGIN	
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Nm_Kab_Kota
		FROM Ref_Kab_Kota A INNER JOIN
			Ta_User_Satker B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota 	
		WHERE B.User_ID = @UserID AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota --AND A.Nm_Kab_Kota LIKE @Nm_Kab_Kota
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Nm_Kab_Kota
		ORDER BY A.Kd_Prov, A.Kd_Kab_Kota, A.Nm_Kab_Kota
	END
	ELSE
	BEGIN
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Nm_Kab_Kota
		FROM Ref_Kab_Kota A
		WHERE (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) --AND (A.Nm_Kab_Kota LIKE '%' + @Nm_Kab_Kota + '%')
	END





GO
