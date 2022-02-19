USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/***
Deskripsi Store Procedure :
Nama		: SP_Qry_Ref_Rek5_108
Form		: F_Up_Rekening
Keterangan	: Di gunakan di Form F_Up_Rekening untuk cari rekening aset 108
Dibuat		: 07/02/2019 23:29:00
***/

CREATE PROCEDURE [dbo].[SP_Qry_Ref_Rek5_108] @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Filter varchar(50)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Filter varchar(50)
SET @Kd_Aset  = '4' 
SET @Kd_Aset0 = '4' 
SET @Kd_Aset1 = '4' 
*/

	IF ISNULL(@Kd_Aset, '') = '' SET @Kd_Aset = '%'
	IF ISNULL(@Kd_Aset0, '') = '' SET @Kd_Aset0 = '%'
	IF ISNULL(@Kd_Aset1, '') = '' SET @Kd_Aset1 = '%'

--IF @Kd_Aset <> '' 
--BEGIN
	SELECT Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Nm_Aset5
	FROM Ref_Rek5_108
	WHERE  (Kd_Aset = @Kd_Aset) AND (Kd_Aset0 = @Kd_Aset0) AND (Kd_Aset1 LIKE @Kd_Aset1) AND (Nm_Aset5 LIKE '%' + @Filter + '%')
	AND IDData = dbo.fn_KdLokasi5(Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5)
--END

GO
