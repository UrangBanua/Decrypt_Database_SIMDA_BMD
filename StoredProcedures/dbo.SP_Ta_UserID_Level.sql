USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO



/*** SP_Ta_UserID_Level - 19062015 - Modified for Ver 2.0.7 [demi@simda.id] ***/

CREATE PROCEDURE [dbo].[SP_Ta_UserID_Level] @User_ID varchar(50), @User_Pwd varchar(50), @Kd_Level varchar(25)
WITH ENCRYPTION
AS
/*
DECLARE @User_ID varchar(50)
SET @User_ID = '' 
*/

SELECT User_ID, Pwd, Kd_Level, Full_Name, Keterangan, V_Group_ID
FROM Ta_UserID
WHERE User_ID = @User_ID AND Pwd = @User_Pwd AND Kd_Level = @Kd_Level

GO
