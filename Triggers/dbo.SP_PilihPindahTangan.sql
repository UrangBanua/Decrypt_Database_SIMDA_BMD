USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_PilihPindahTangan] @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), --@No_BA varchar(50),
	@Aset1 varchar(2), @Aset2 varchar(3), @Aset3 varchar(3), @Aset4 varchar(3), @Aset5 varchar(3), @Reg varchar(3), @KIB varchar(1)
WITH ENCRYPTION
AS

/*
DECLARE  @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @SK_Guna varchar(50),
	@Aset1 varchar(2), @Aset2 varchar(3), @Aset3 varchar(3), @Aset4 varchar(3), @Aset5 varchar(3), @Reg varchar(3), @KIB varchar(1)

SET @Kd_Prov   = '99'
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang = '1' 
SET @Kd_Unit   = '1' 
SET @Kd_Sub    = '1'
SET @Kd_UPB    = '1'
SET @No_BA = ''
SET @Aset1 = ''
SET @Aset2 = ''
SET @Aset3 = ''
SET @Aset4 = ''
SET @Aset5 = ''
SET @Reg = ''
SET @KIB = 'A'
*/

IF @KIB = 'A'
BEGIN
	UPDATE Ta_KIBAHapus
	SET Flag = 1
	FROM Ta_KIBAHapus A
	WHERE  A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kd_Aset1 = @Aset1 AND A.Kd_ASet2 = @Aset2 AND A.Kd_Aset3 = @Aset3 AND A.Kd_Aset4 = @Aset4 AND A.Kd_Aset5 = @Aset5 AND A.No_Register = @Reg

	SELECT *
	FROM Ta_KIBAHapus
	WHERE Flag = 1 
END

IF @KIB = 'B'
BEGIN
	UPDATE Ta_KIBBHapus
	SET Flag = 1
	FROM Ta_KIBBHapus A
	WHERE  A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kd_Aset1 = @Aset1 AND A.Kd_ASet2 = @Aset2 AND A.Kd_Aset3 = @Aset3 AND A.Kd_Aset4 = @Aset4 AND A.Kd_Aset5 = @Aset5 AND A.No_Register = @Reg

	SELECT *
	FROM Ta_KIBBHapus
	WHERE Flag = 1 
END

IF @KIB = 'C'
BEGIN
	UPDATE Ta_KIBCHapus
	SET Flag = 1
	FROM Ta_KIBCHapus A
	WHERE  A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kd_Aset1 = @Aset1 AND A.Kd_ASet2 = @Aset2 AND A.Kd_Aset3 = @Aset3 AND A.Kd_Aset4 = @Aset4 AND A.Kd_Aset5 = @Aset5 AND A.No_Register = @Reg

	SELECT *
	FROM Ta_KIBCHapus
	WHERE Flag = 1 
END

IF @KIB = 'D'
BEGIN
	UPDATE Ta_KIBDHapus
	SET Flag = 1
	FROM Ta_KIBDHapus A
	WHERE  A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kd_Aset1 = @Aset1 AND A.Kd_ASet2 = @Aset2 AND A.Kd_Aset3 = @Aset3 AND A.Kd_Aset4 = @Aset4 AND A.Kd_Aset5 = @Aset5 AND A.No_Register = @Reg

	SELECT *
	FROM Ta_KIBDHapus
	WHERE Flag = 1 
END

IF @KIB = 'E'
BEGIN
	UPDATE Ta_KIBEHapus
	SET Flag = 1
	FROM Ta_KIBEHapus A
	WHERE  A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kd_Aset1 = @Aset1 AND A.Kd_ASet2 = @Aset2 AND A.Kd_Aset3 = @Aset3 AND A.Kd_Aset4 = @Aset4 AND A.Kd_Aset5 = @Aset5 AND A.No_Register = @Reg

	SELECT *
	FROM Ta_KIBEHapus
	WHERE Flag = 1 
END




GO
