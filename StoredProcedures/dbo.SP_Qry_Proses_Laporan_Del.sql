USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/***
Deskripsi Store Procedure :
Nama		: SP_Qry_Proses_Laporan
Form		: F_LaporanAkhir
Keterangan	: Di gunakan di Form F_Up_Rekening untuk cari rekening
Dibuat		: 29/04/2019 23:29:00
Oleh		: HRY
***/

CREATE PROCEDURE [dbo].[SP_Qry_Proses_Laporan_Del] @Kd_KIB varchar(1), @KdTahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_KIB varchar(1), @KdTahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), @D2 Datetime
SET @Kd_KIB      = 'A' 
SET @KdTahun     = '2018'
SET @Kd_Prov     = '99' 
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang   = '1'
SET @Kd_Unit     = '1'
SET @Kd_Sub      = '1'
SET @Kd_UPB      = '1'
SET @D2          = GetDate()
*/

	DECLARE @JLap Tinyint SET @JLap = 0

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

IF @Kd_KIB = 'A'
BEGIN
	BEGIN TRANSACTION
	DELETE Ta_Fn_KIB_A WHERE Tahun = @KdTahun
	AND Kd_Prov LIKE @Kd_Prov AND Kd_Kab_Kota LIKE @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit 
	AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB
	COMMIT
END	

IF @Kd_KIB = 'B'
BEGIN
	BEGIN TRANSACTION
	DELETE Ta_Fn_KIB_B WHERE Tahun = @KdTahun
	AND Kd_Prov LIKE @Kd_Prov AND Kd_Kab_Kota LIKE @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit 
	AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB
	COMMIT
END

IF @Kd_KIB = 'C'
BEGIN
	BEGIN TRANSACTION
	DELETE Ta_Fn_KIB_C WHERE Tahun = @KdTahun
	AND Kd_Prov LIKE @Kd_Prov AND Kd_Kab_Kota LIKE @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit 
	AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB
	COMMIT 
END

IF @Kd_KIB = 'D'
BEGIN
	BEGIN TRANSACTION
	DELETE Ta_Fn_KIB_D WHERE Tahun = @KdTahun
	AND Kd_Prov LIKE @Kd_Prov AND Kd_Kab_Kota LIKE @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit 
	AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB
	COMMIT
END

IF @Kd_KIB = 'E'
BEGIN
	BEGIN TRANSACTION
	DELETE Ta_Fn_KIB_E WHERE Tahun = @KdTahun
	AND Kd_Prov LIKE @Kd_Prov AND Kd_Kab_Kota LIKE @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit 
	AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB
	COMMIT
END

IF @Kd_KIB = 'F'
BEGIN
	BEGIN TRANSACTION
	DELETE Ta_Fn_KIB_F WHERE Tahun = @KdTahun
	AND Kd_Prov LIKE @Kd_Prov AND Kd_Kab_Kota LIKE @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit 
	AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB
	COMMIT
END

IF @Kd_KIB = 'L'
BEGIN
	BEGIN TRANSACTION
	DELETE Ta_Fn_KIB_L WHERE Tahun = @KdTahun	
	AND Kd_Prov LIKE @Kd_Prov AND Kd_Kab_Kota LIKE @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit 
	AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB
	COMMIT
END



GO
