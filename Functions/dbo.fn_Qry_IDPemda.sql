USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/** fn_Qry_IDPemda - 01042017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE FUNCTION dbo.fn_Qry_IDPemda (@Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), @Kd_Aset1 varchar(3)) 
RETURNS int
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3)
SET @Kd_Prov = '99'
SET @Kd_KAb_Kota = '99'
SET @Kd_Bidang = '1' 
SET @Kd_Unit   = '1' 
SET @Kd_Sub    = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset1 = '2'
*/
BEGIN
	DECLARE @intIDPemda int
	IF @Kd_Aset1 = '2'
	BEGIN
		SELECT @intIDPemda = ISNULL(Max(SubString(Convert(varchar,IDPemda),12,6)), 0) + 1 FROM Ta_KIB_B
    				WHERE SubString(IDPemda,1,2) LIKE @Kd_Bidang
    				AND SubString(IDPemda,3,2) LIKE @Kd_Unit
    				AND SubString(IDPemda,5,3) LIKE @Kd_Sub
    				AND SubString(IDPemda,8,3) LIKE @Kd_UPB
    				AND SubString(IDPemda,11,1) = @Kd_Aset1
	END

	RETURN @intIDPemda
END




GO
