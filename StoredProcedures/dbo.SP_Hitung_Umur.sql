USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Hitung_Umur - 31082019 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Hitung_Umur @Kd_Pemilik Varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
                 @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4), @Tanggal datetime, @Nilai money,
                 @TipeA Tinyint, @TipeB Tinyint, @TipeC Tinyint, @TipeKIB varchar(1) 
WITH ENCRYPTION
AS

/*
DECLARE @Kd_Pemilik Varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4), @Tanggal datetime, @Nilai money, 
	@TipeA Tinyint, @TipeB Tinyint, @TipeC Tinyint, @TipeKIB varchar(1)

SET @Kd_Pemilik	= '12'
SET @Kd_Prov	= '19'
SET @Kd_Kab_Kota= '11'
SET @Kd_Bidang	= '1'
SET @Kd_Unit	= '3'
SET @Kd_Sub	= '1'
SET @Kd_UPB	= '1'
SET @Kd_Aset 	= '3'
SET @Kd_Aset0	= '3'
SET @Kd_Aset1	= '3'
SET @Kd_Aset2	= '11'
SET @Kd_Aset3	= '1'
SET @Kd_Aset4	= '1'
SET @Kd_Aset5	= '1'
SET @No_Register = '20'
SET @Tanggal = '20151201'
SET @Nilai = 200000000
SET @TipeA = 1 
SET @TipeB = 2 
SET @TipeC = 1 
SET @TipeKIB = 'C'
*/

IF @TipeKIB = 'B'
begin
  EXEC SP_Hitung_Umur_B @Kd_Pemilik, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset, @Kd_Aset0, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @No_Register, @Tanggal, @Nilai, @TipeA, @TipeB, @TipeC
end

IF @TipeKIB = 'C'
begin
  EXEC SP_Hitung_Umur_C @Kd_Pemilik, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset, @Kd_Aset0, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @No_Register, @Tanggal, @Nilai, @TipeA, @TipeB, @TipeC
end

IF @TipeKIB = 'D'
begin
  EXEC SP_Hitung_Umur_D @Kd_Pemilik, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset, @Kd_Aset0, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @No_Register, @Tanggal, @Nilai, @TipeA, @TipeB, @TipeC
end

IF @TipeKIB = 'E'
begin
  EXEC SP_Hitung_Umur_E @Kd_Pemilik, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset, @Kd_Aset0, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @No_Register, @Tanggal, @Nilai, @TipeA, @TipeB, @TipeC
end



GO
