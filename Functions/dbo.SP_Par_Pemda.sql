USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/****** Object:  SP_Par_Pemda  First Created : 13/03/2006 16:24:54   By [Herry - 0852 1821 9951] ******/

CREATE PROCEDURE [dbo].[SP_Par_Pemda]
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4)
SET @Tahun = '2005'
*/
	SELECT Kd_Prov, Kd_Kab_Kota, Nm_Pemda, Ibukota, Alamat, Logo, Basis, Acc_Name
	FROM Ref_Pemda
GO
