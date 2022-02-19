USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_HapusGuna] @Kd_Prov varchar(3), @Kd_Kab varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10),
	@Kd_Aset1 varchar(2), @Kd_Aset2 varchar(2), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(4), @No_Reg varchar(4), 
	@KIB varchar(1)
WITH ENCRYPTION
AS

/*
DECLARE @Kd_Prov varchar(3), @Kd_Kab varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10),
	@Kd_Aset1 varchar(2), @Kd_Aset2 varchar(2), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(4), @No_Reg varchar(4), 
	@KIB varchar(1)

SET @Kd_Prov = '11'
SET @Kd_Kab = '28'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset1 = '1'
SET @Kd_Aset2 = '1'
SET @Kd_Aset3 = '11'
SET @Kd_Aset4 = '1'
SET @Kd_Aset5 = '1'
SET @No_Reg = '1'
SET @KIB = 'A'
*/

IF @KIB = 'A'
BEGIN
	ALTER TABLE Ta_KIB_A DISABLE TRIGGER ALL
	UPDATE Ta_KIB_A
	SET No_SKGuna = 'NULL'
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub 
		AND Kd_UPB = @Kd_UPB AND Kd_Aset1 = @Kd_Aset1 AND Kd_Aset2 = @Kd_Aset2
		AND Kd_Aset3 = @Kd_Aset3 AND Kd_Aset4 = @Kd_Aset4 AND Kd_Aset5 = @Kd_Aset5 AND No_Register = @No_Reg
	ALTER TABLE Ta_KIB_A ENABLE TRIGGER ALL
END

IF @KIB = 'B'
BEGIN
	UPDATE Ta_KIB_B
	SET No_SKGuna = 'NULL'
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub 
		AND Kd_UPB = @Kd_UPB AND Kd_Aset1 = @Kd_Aset1 AND Kd_Aset2 = @Kd_Aset2
		AND Kd_Aset3 = @Kd_Aset3 AND Kd_Aset4 = @Kd_Aset4 AND Kd_Aset5 = @Kd_Aset5 AND No_Register = @No_Reg

END

IF @KIB = 'C'
BEGIN
	UPDATE Ta_KIB_C
	SET No_SKGuna = 'NULL'
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub 
		AND Kd_UPB = @Kd_UPB AND Kd_Aset1 = @Kd_Aset1 AND Kd_Aset2 = @Kd_Aset2
		AND Kd_Aset3 = @Kd_Aset3 AND Kd_Aset4 = @Kd_Aset4 AND Kd_Aset5 = @Kd_Aset5 AND No_Register = @No_Reg

END

IF @KIB = 'D'
BEGIN
	UPDATE Ta_KIB_D
	SET No_SKGuna = 'NULL'
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub 
		AND Kd_UPB = @Kd_UPB AND Kd_Aset1 = @Kd_Aset1 AND Kd_Aset2 = @Kd_Aset2
		AND Kd_Aset3 = @Kd_Aset3 AND Kd_Aset4 = @Kd_Aset4 AND Kd_Aset5 = @Kd_Aset5 AND No_Register = @No_Reg

END

IF @KIB = 'E'
BEGIN
	UPDATE Ta_KIB_E
	SET No_SKGuna = 'NULL'
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub 
		AND Kd_UPB = @Kd_UPB AND Kd_Aset1 = @Kd_Aset1 AND Kd_Aset2 = @Kd_Aset2
		AND Kd_Aset3 = @Kd_Aset3 AND Kd_Aset4 = @Kd_Aset4 AND Kd_Aset5 = @Kd_Aset5 AND No_Register = @No_Reg

END





GO
