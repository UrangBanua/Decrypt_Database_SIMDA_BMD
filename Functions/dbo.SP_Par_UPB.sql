USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Par_UPB - 27012017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Par_UPB @Kd_Prov varchar(2), @Kd_Kab_Kota varchar(2), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @UserID Varchar(50)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Prov varchar(2), @Kd_Kab_Kota varchar(2), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @UserID Varchar(50)
SET @Kd_Prov = '99'
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang = '8'
SET @Kd_Unit = '1'
SET @Kd_Sub = '2'
SET @UserID    = '├ÐÏ═á'
*/
	DECLARE @sKd_Sub varchar(1) 
	SELECT @sKd_Sub = Kd_Sub FROM Ta_User_Satker
	WHERE (User_ID = @UserID) AND (Kd_Prov LIKE @Kd_Prov) AND (Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) 
        AND (Kd_Unit LIKE @Kd_Unit)

	DECLARE @sKd_UPB varchar(1)
	IF (@sKd_Sub = '0')
	BEGIN
		SELECT @sKd_UPB = Kd_UPB FROM Ta_User_Satker
		WHERE (User_ID = @UserID) AND (Kd_Prov LIKE @Kd_Prov) AND (Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) 
        	AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @sKd_Sub)
	END ELSE
	BEGIN
		SELECT @sKd_UPB = Kd_UPB FROM Ta_User_Satker
		WHERE (User_ID = @UserID) AND (Kd_Prov LIKE @Kd_Prov) AND (Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) 
        	AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub)
	END

	IF EXISTS(SELECT * FROM Ta_User_Satker WHERE User_ID = @UserID)
	BEGIN	
		IF (@sKd_Sub = '0')
		BEGIN
			IF (@sKd_UPB = '0')
			BEGIN
				SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Nm_UPB, Kd_Kecamatan, Kd_Desa
				FROM Ref_UPB A INNER JOIN
					Ta_User_Satker B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang 
					AND A.Kd_Unit = B.Kd_Unit
				WHERE (B.User_ID = @UserID) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) 
					AND (A.Kd_Unit LIKE @Kd_Unit) AND(A.Kd_Sub LIKE @Kd_Sub)
				GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Nm_UPB, Kd_Kecamatan, Kd_Desa
				ORDER BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
			END ELSE
			BEGIN
				SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Nm_UPB, Kd_Kecamatan, Kd_Desa
				FROM Ref_UPB A INNER JOIN
					Ta_User_Satker B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang 
					AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub 
				WHERE (B.User_ID = @UserID) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) 
					AND (A.Kd_Unit LIKE @Kd_Unit) AND(A.Kd_Sub LIKE @Kd_Sub)
				GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Nm_UPB, Kd_Kecamatan, Kd_Desa
				ORDER BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
			END
		END ELSE
		BEGIN
			SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Nm_UPB, Kd_Kecamatan, Kd_Desa
			FROM Ref_UPB A INNER JOIN
				Ta_User_Satker B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang 
				AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			WHERE (B.User_ID = @UserID) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) 
				AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub)
			GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Nm_UPB, Kd_Kecamatan, Kd_Desa
			ORDER BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
		END
	END
	ELSE
	BEGIN
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Nm_UPB, A.Kd_Kecamatan, A.Kd_Desa
		FROM	Ref_UPB A
		WHERE	(A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit)
			 AND (A.Kd_Sub LIKE @Kd_Sub)
		ORDER BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
	END
	




GO
