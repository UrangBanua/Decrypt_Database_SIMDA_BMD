USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CopyKebijakan] @Tahun varchar(4), @Tahun1 varchar(4)
WITH ENCRYPTION
AS

/*
DECLARE @Tahun varchar(4), @Tahun1 varchar(4)
SET @Tahun = '2011'
SET @Tahun1 = '2012'
*/

DELETE FROM Ref_Penyusutan
WHERE Tahun = @Tahun

DELETE FROM Ta_KA
WHERE Tahun = @Tahun

INSERT INTO Ref_Penyusutan (Tahun, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Metode, Umur, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84)
SELECT @Tahun, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Metode, Umur, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84
FROM Ref_Penyusutan
WHERE Tahun = @Tahun1

INSERT INTO Ta_KA (Tahun, Kd_Prov, Kd_Kab_Kota, MinSatuan, MinTotal, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_KA, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83)
SELECT @Tahun, Kd_Prov, Kd_Kab_Kota, MinSatuan, MinTotal, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_KA, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83
FROM Ta_KA
WHERE Tahun = @Tahun1

GO
