USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** SP_Ta_KIB_Hps - 10112015 - Modified for Ver 2.0.7 [demi@simda.id] ***/

CREATE PROCEDURE SP_Ta_KIB_Hps @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @IDUser varchar(20)
WITH ENCRYPTION
AS

/*
DECLARE @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @IDUser varchar(20)
SET @Kd_Prov   = '99'
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang = '1' 
SET @Kd_Unit   = '1' 
SET @Kd_Sub    = '1'
SET @Kd_UPB    = '1'
SET @IDUser    = 'admin'
*/

SELECT IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Barang, No_Register, Nm_Aset, Harga
FROM Ta_KIB_Hps
WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota 
      AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
      AND IDUser = @IDUser


GO
