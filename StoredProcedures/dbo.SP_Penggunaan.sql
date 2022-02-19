USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Penggunaan] @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @SK_Guna varchar(50),
	@Aset1 varchar(2), @Aset2 varchar(3), @Aset3 varchar(3), @Aset4 varchar(3), @Aset5 varchar(3), @Reg varchar(3), @KIB varchar(1)
WITH ENCRYPTION
AS

/*
DECLARE  @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @SK_Guna varchar(50),
	@Aset1 varchar(2), @Aset2 varchar(3), @Aset3 varchar(3), @Aset4 varchar(3), @Aset5 varchar(3), @Reg varchar(3), @KIB varchar(1)

SET @Kd_Prov   = '13'
SET @Kd_Kab_Kota = '4'
SET @Kd_Bidang = '5' 
SET @Kd_Unit   = '1' 
SET @Kd_Sub    = '1'
SET @Kd_UPB    = '1'
SET @SK_GUna = ''
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
	UPDATE Ta_KIB_A
	SET No_SKGuna = @SK_Guna
	FROM Ta_KIB_A A
	WHERE  A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kd_Aset1 = @Aset1 AND A.Kd_ASet2 = @Aset2 AND A.Kd_Aset3 = @Aset3 AND A.Kd_Aset4 = @Aset4 AND A.Kd_Aset5 = @Aset5 AND A.No_Register = @Reg

	SELECT *
	FROM Ta_KIB_A
	WHERE No_SKGuna = @SK_Guna 
END

IF @KIB = 'B'
BEGIN
	UPDATE Ta_KIB_B
	SET No_SKGuna = @SK_Guna
	FROM Ta_KIB_B A
	WHERE  A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kd_Aset1 = @Aset1 AND A.Kd_ASet2 = @Aset2 AND A.Kd_Aset3 = @Aset3 AND A.Kd_Aset4 = @Aset4 AND A.Kd_Aset5 = @Aset5 AND A.No_Register = @Reg

	SELECT *
	FROM Ta_KIB_B
	WHERE No_SKGuna = @SK_Guna 
END

IF @KIB = 'C'
BEGIN
	UPDATE Ta_KIB_C
	SET No_SKGuna = @SK_Guna
	FROM Ta_KIB_C A
	WHERE  A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kd_Aset1 = @Aset1 AND A.Kd_ASet2 = @Aset2 AND A.Kd_Aset3 = @Aset3 AND A.Kd_Aset4 = @Aset4 AND A.Kd_Aset5 = @Aset5 AND A.No_Register = @Reg

	SELECT *
	FROM Ta_KIB_C
	WHERE No_SKGuna = @SK_Guna 
END

IF @KIB = 'D'
BEGIN
	UPDATE Ta_KIB_D
	SET No_SKGuna = @SK_Guna
	FROM Ta_KIB_D A
	WHERE  A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kd_Aset1 = @Aset1 AND A.Kd_ASet2 = @Aset2 AND A.Kd_Aset3 = @Aset3 AND A.Kd_Aset4 = @Aset4 AND A.Kd_Aset5 = @Aset5 AND A.No_Register = @Reg

	SELECT *
	FROM Ta_KIB_D
	WHERE No_SKGuna = @SK_Guna 
END

IF @KIB = 'E'
BEGIN
	UPDATE Ta_KIB_E
	SET No_SKGuna = @SK_Guna
	FROM Ta_KIB_E A
	WHERE  A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kd_Aset1 = @Aset1 AND A.Kd_ASet2 = @Aset2 AND A.Kd_Aset3 = @Aset3 AND A.Kd_Aset4 = @Aset4 AND A.Kd_Aset5 = @Aset5 AND A.No_Register = @Reg

	SELECT *
	FROM Ta_KIB_E
	WHERE No_SKGuna = @SK_Guna 
END





GO
