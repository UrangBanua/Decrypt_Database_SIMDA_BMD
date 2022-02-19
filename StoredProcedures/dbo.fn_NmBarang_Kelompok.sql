USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_NmBarang_Kelompok] (@K1 varchar(2), @K2 varchar(2), @K3 varchar(2)) 
RETURNS varchar(255)
WITH ENCRYPTION
AS 
BEGIN
	RETURN (SELECT Nm_Aset3 FROM Ref_Rek_Aset3 WHERE Kd_Aset1=@K1 AND Kd_Aset2=@K2 AND Kd_Aset3=@K3)
END













GO
