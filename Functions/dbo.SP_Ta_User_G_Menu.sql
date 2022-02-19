USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** SP_Ta_User_G_Menu - 19062015 - Modified for Ver 2.0.7 [demi@simda.id] ***/

CREATE PROCEDURE SP_Ta_User_G_Menu @Group_ID varchar(30)
WITH ENCRYPTION
AS

/*
DECLARE @User_ID varchar(50)
SET @User_ID = '' 
*/

SELECT V_Group_ID, ID_Menu, Otoritas
FROM Ta_User_G_Menu
WHERE V_Group_ID = @Group_ID

GO
