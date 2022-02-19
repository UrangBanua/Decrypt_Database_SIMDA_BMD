USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE SP_SaveOtoritasMenuG @v_group_id varchar(20), @id_menu varchar(10), @otoritas varchar(10)
WITH ENCRYPTION
AS
	
	IF EXISTS(SELECT V_Group_ID FROM Ta_User_G_Menu WHERE V_Group_ID = @v_group_id AND ID_Menu = @id_menu)
	BEGIN
		UPDATE Ta_User_G_Menu
		SET Otoritas = @otoritas
		WHERE  V_Group_ID = @v_group_id AND ID_Menu = @id_menu
	END
	ELSE
	BEGIN
		INSERT INTO Ta_User_G_Menu(V_Group_ID, ID_Menu, Otoritas)
		VALUES(@v_group_id, @id_menu, @otoritas)
	END

GO
