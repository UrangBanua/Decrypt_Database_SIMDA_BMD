USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/****** Object : SP_Ref_Menu  First Created : 15/03/2006 10:00:00 By [Herry - 0852 1821 9951] ******/

CREATE PROCEDURE [dbo].[SP_Ref_Menu] @User_ID varchar(50)
WITH ENCRYPTION
AS
/*
DECLARE @User_ID varchar(50)
SET @User_ID = '' 
*/

SELECT User_ID, ID_Menu, Otoritas
FROM Ref_Menu
WHERE User_ID = @User_ID





GO
