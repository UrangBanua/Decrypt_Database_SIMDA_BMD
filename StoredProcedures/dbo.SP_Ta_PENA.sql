USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Ta_PENA - 01082019 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE [dbo].[SP_Ta_PENA] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4)
WITH ENCRYPTION
AS
/*
DECLARE  @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3)
SET @Tahun     = '2012' 
SET @Kd_Prov   = '13'
SET @Kd_Kab_Kota = '4'
SET @Kd_Bidang = '5' 
SET @Kd_Unit   = '1' 
SET @Kd_Sub    = '1'
SET @Kd_UPB    = '1'
*/

	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Aset8 AS Kd_Aset8, A.Kd_Aset80 AS Kd_Aset80, A.Kd_Aset81 AS Kd_Aset81, A.Kd_Aset82 AS Kd_Aset82, A.Kd_Aset83 AS Kd_Aset83, A.Kd_Aset84 AS Kd_Aset84, A.Kd_Aset85 AS Kd_Aset85,
		A.No_Register, A.No_Reg8, A.Harga, A.No_Kontrak, A.Tgl_Kontrak, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Log_User, A.Log_entry,
		REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang	
	FROM Ta_PenA A 
	WHERE  A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
	ORDER BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
GO
