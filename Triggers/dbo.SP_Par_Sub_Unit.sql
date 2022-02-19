USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** SP_Par_Sub_Unit - 08042020 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE  PROCEDURE [dbo].[SP_Par_Sub_Unit] @Kd_Prov varchar(2), @Kd_Kab_Kota varchar(2), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Nm_Sub_Unit varchar(50), @UserID Varchar(50)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Prov varchar(2), @Kd_Kab_Kota varchar(2), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @UserID Varchar(50)
SET @Kd_Prov = '11'
SET @Kd_Kab_Kota = '28'
SET @Kd_Bidang = '%'
SET @Kd_Unit   = '%'
SET @Kd_Sub = '%'
SET @UserID    = '???'
*/
	IF ISNULL(@Nm_Sub_Unit, '') = '' SET @Nm_Sub_Unit = '%'

	DECLARE @sKd_Sub varchar(1)
	SELECT @sKd_Sub = Kd_Sub FROM Ta_User_Satker
	WHERE (User_ID = @UserID) AND (Kd_Prov LIKE @Kd_Prov) AND (Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit)

	IF EXISTS(SELECT * FROM Ta_User_Satker WHERE User_ID = @UserID)
	BEGIN	
		IF (@sKd_Sub = '0')
		BEGIN
			SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Nm_Sub_Unit
			FROM Ref_Sub_Unit A INNER JOIN
				Ta_User_Satker B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang 
                                            	AND A.Kd_Unit = B.Kd_Unit 
			WHERE (B.User_ID = @UserID) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) 
				AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Nm_Sub_Unit LIKE '%' + @Nm_Sub_Unit + '%')
			GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Nm_Sub_Unit
			ORDER BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub
		END ELSE
		BEGIN
			SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Nm_Sub_Unit
			FROM Ref_Sub_Unit A INNER JOIN
				Ta_User_Satker B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang 
                                            	AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub 
			WHERE (B.User_ID = @UserID) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) 
				AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Nm_Sub_Unit LIKE '%' + @Nm_Sub_Unit + '%')
			GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Nm_Sub_Unit
			ORDER BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub
		END
	END
	ELSE
	BEGIN
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Nm_Sub_Unit
		FROM	Ref_Sub_Unit A
		WHERE	(A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) 
			AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Nm_Sub_Unit LIKE '%' + @Nm_Sub_Unit + '%')
			--AND (A.Kd_Sub LIKE @Kd_Sub)
	END








GO
