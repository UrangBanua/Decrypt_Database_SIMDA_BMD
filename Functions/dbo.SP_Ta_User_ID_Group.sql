USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** SP_Ta_User_ID_Group - 19062015 - Modified for Ver 2.0.7 [demi@simda.id] ***/

CREATE PROCEDURE SP_Ta_User_ID_Group @User_ID varchar(50), @V_Group_ID varchar(30)
WITH ENCRYPTION
AS
/*
DECLARE @User_ID varchar(50), @V_Group_ID varchar(30)
SET @User_ID = '' 
*/

UPDATE Ta_UserID
SET V_Group_ID = @V_Group_ID
WHERE V_Group_ID IS NULL

GO
