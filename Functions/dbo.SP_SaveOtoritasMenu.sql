USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/***
Deskripsi Store Procedure :
Nama		: SP_SaveOtoritasMenu
Form		: F_Usermaintenance
Keterangan	: Di gunakan untuk Update dan Insert Otoritas User Menu
Dibuat		: 10/08/2006 10:00:00
Oleh		: Iman
***/

CREATE PROCEDURE [dbo].[SP_SaveOtoritasMenu] @user_id varchar(20), @id_menu varchar(10), @otoritas varchar(10)
WITH ENCRYPTION
AS
	
	IF EXISTS(SELECT user_id FROM Ref_Menu WHERE user_id = @user_id AND id_menu = @id_menu)
	BEGIN
		UPDATE Ref_Menu
		SET otoritas = @otoritas
		WHERE  user_id = @user_id AND id_menu = @id_menu
	END
	ELSE
	BEGIN
		INSERT INTO Ref_Menu(user_id, id_menu, otoritas)
		VALUES(@user_id, @id_menu, @otoritas)
	END





GO
