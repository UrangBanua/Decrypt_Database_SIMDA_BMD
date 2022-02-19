USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SP_LockInvent] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @KIB varchar(1), @Invent varchar(1)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @KIB varchar(1), @Invent varchar(1)
SET @Tahun = '2009'
SET @Kd_Prov = '13'
SET @Kd_Kab_Kota = '4'
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @Kd_UPB = ''
SET @KIB = 'A'
SET @Invent = '1'


	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
*/

IF @KIB = 'A' 
BEGIN
	UPDATE Ta_KIB_A
	SET Invent = @Invent
	FROM Ta_KIB_A A
	WHERE YEAR(A.Tgl_Pembukuan) = @Tahun AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota 
		AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
END

IF @KIB = 'B' 
BEGIN
	UPDATE Ta_KIB_B
	SET Invent = @Invent
	FROM Ta_KIB_B A
	WHERE YEAR(A.Tgl_Pembukuan) = @Tahun AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota 
		AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
END

IF @KIB = 'C' 
BEGIN
	UPDATE Ta_KIB_C
	SET Invent = @Invent
	FROM Ta_KIB_C A
	WHERE YEAR(A.Tgl_Pembukuan) = @Tahun AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota 
		AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
END

IF @KIB = 'D' 
BEGIN
	UPDATE Ta_KIB_D
	SET Invent = @Invent
	FROM Ta_KIB_D A
	WHERE YEAR(A.Tgl_Pembukuan) = @Tahun AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota 
		AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
END

IF @KIB = 'E' 
BEGIN
	UPDATE Ta_KIB_E
	SET Invent = @Invent
	FROM Ta_KIB_E A
	WHERE YEAR(A.Tgl_Pembukuan) = @Tahun AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota 
		AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
END
GO
