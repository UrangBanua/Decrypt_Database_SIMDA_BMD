USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** SP_Ta_User_G - 19062015 - Modified for Ver 2.0.7 [demi@simda.id] ***/

CREATE PROCEDURE SP_Ta_User_G
WITH ENCRYPTION
AS

SELECT V_Group_ID, V_Group_Nm, V_Group_Level
FROM Ta_User_G

GO
