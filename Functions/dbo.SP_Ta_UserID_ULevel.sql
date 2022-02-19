USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** SP_Ta_UserID_ULevel - 19062015 - Modified for Ver 2.0.7 [demi@simda.id] ***/

CREATE PROCEDURE [dbo].[SP_Ta_UserID_ULevel] @User_ID varchar(50), @Kd_Level varchar(50), @Full_Name varchar(50), @Keterangan varchar(50)
WITH ENCRYPTION
AS
/*
DECLARE @User_ID varchar(50)
SET @User_ID = '' 
*/

UPDATE Ta_UserID
SET Kd_Level = @Kd_Level, Full_Name = @Full_Name, Keterangan = @Keterangan
WHERE User_ID = @User_ID

GO
