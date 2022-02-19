USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_NmBarang] (@K1 varchar(2), @K2 varchar(2), @K3 varchar(2), @K4 varchar(2), @K5 varchar(3)) 
RETURNS varchar(255)
WITH ENCRYPTION
AS 
BEGIN
	RETURN (SELECT Nm_Aset5 FROM Ref_Rek_Aset5 WHERE Kd_Aset1=@K1 AND Kd_Aset2=@K2 AND Kd_Aset3=@K3 AND Kd_Aset4=@K4 AND Kd_Aset5=@K5)
END











GO
