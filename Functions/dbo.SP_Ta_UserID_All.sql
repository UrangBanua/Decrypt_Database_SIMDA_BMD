USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** SP_Ta_UserID_All - 19062015 - Modified for Ver 2.0.7 [demi@simda.id] ***/

CREATE PROCEDURE [dbo].[SP_Ta_UserID_All]
WITH ENCRYPTION
AS

SELECT User_ID, Pwd, Kd_Level, Full_Name, Keterangan, V_Group_ID
FROM Ta_UserID

GO
