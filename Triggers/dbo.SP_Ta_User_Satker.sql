USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** SP_Ta_User_Satker - 19062015 - Modified for Ver 2.0.7 [demi@simda.id] ***/

CREATE PROCEDURE [dbo].[SP_Ta_User_Satker] @User_ID varchar(50)
WITH ENCRYPTION
AS

SELECT User_ID, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
FROM Ta_User_Satker
WHERE User_ID = @User_ID

GO
