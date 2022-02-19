USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn108_NmBarang] (@K1 varchar(2), @K2 varchar(2), @K3 varchar(2), @K4 varchar(2), @K5 varchar(3), @K6 varchar(3), @K7 varchar(3)) 
RETURNS varchar(255)
WITH ENCRYPTION
AS 
BEGIN
	RETURN (SELECT Nm_Aset5 FROM Ref_Rek5_108 WHERE Kd_Aset=@K1 AND Kd_Aset0=@K2 AND Kd_Aset1=@K3 AND Kd_Aset2=@K4 AND Kd_Aset3=@K5 AND Kd_Aset4=@K6 AND Kd_Aset5=@K7)
END













GO
