USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_DeleteFromPengadaan_Kap] @Tahun varchar(4), @No_SP2D varchar(50), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Reg varchar(4)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @No_SP2D varchar(50), @No_Id varchar(5), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Reg varchar(4)
SET @Tahun = '2007'
SET @No_SP2D = '0001/SP2D/07'
SET @No_ID = '1'
SET @Kd_Prov = '13'
SET @Kd_Kab_Kota = '4'
SET @Kd_Bidang = '8'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset1 = '3'
SET @Kd_Aset2 = '11'
SET @Kd_Aset3 = '1'
SET @Kd_Aset4 = '1'
SET @Kd_Aset5 = '1'
SET @no_Reg = '';
*/


	DELETE Ta_KIBAR
	WHERE (Tahun = @Tahun) AND (No_SP2D = @No_SP2D) AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
		AND Kd_Aset8 = @Kd_Aset AND Kd_Aset80 = @Kd_Aset0 AND Kd_Aset81 = @Kd_Aset1 AND Kd_Aset82 = @Kd_Aset2 AND Kd_Aset83 = @Kd_Aset3 AND Kd_Aset84 = @Kd_Aset4 AND Kd_Aset85 = @Kd_Aset5 AND No_Register = @No_Reg

	DELETE Ta_KIBBR
	WHERE (Tahun = @Tahun) AND (No_SP2D = @No_SP2D) AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
		AND Kd_Aset8 = @Kd_Aset AND Kd_Aset80 = @Kd_Aset0 AND Kd_Aset81 = @Kd_Aset1 AND Kd_Aset82 = @Kd_Aset2 AND Kd_Aset83 = @Kd_Aset3 AND Kd_Aset84 = @Kd_Aset4 AND Kd_Aset85 = @Kd_Aset5 AND No_Register = @No_Reg

	DELETE Ta_KIBCR
	WHERE (Tahun = @Tahun) AND (No_SP2D = @No_SP2D) AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
		AND Kd_Aset8 = @Kd_Aset AND Kd_Aset80 = @Kd_Aset0 AND Kd_Aset81 = @Kd_Aset1 AND Kd_Aset82 = @Kd_Aset2 AND Kd_Aset83 = @Kd_Aset3 AND Kd_Aset84 = @Kd_Aset4 AND Kd_Aset85 = @Kd_Aset5 AND No_Register = @No_Reg

	DELETE Ta_KIBDR
	WHERE (Tahun = @Tahun) AND (No_SP2D = @No_SP2D) AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
		AND Kd_Aset8 = @Kd_Aset AND Kd_Aset80 = @Kd_Aset0 AND Kd_Aset81 = @Kd_Aset1 AND Kd_Aset82 = @Kd_Aset2 AND Kd_Aset83 = @Kd_Aset3 AND Kd_Aset84 = @Kd_Aset4 AND Kd_Aset85 = @Kd_Aset5 AND No_Register = @No_Reg

	DELETE Ta_KIBER
	WHERE (Tahun = @Tahun) AND (No_SP2D = @No_SP2D) AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
		AND Kd_Aset8 = @Kd_Aset AND Kd_Aset80 = @Kd_Aset0 AND Kd_Aset81 = @Kd_Aset1 AND Kd_Aset82 = @Kd_Aset2 AND Kd_Aset83 = @Kd_Aset3 AND Kd_Aset84 = @Kd_Aset4 AND Kd_Aset85 = @Kd_Aset5 AND No_Register = @No_Reg







GO
