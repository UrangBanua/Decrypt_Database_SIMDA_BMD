USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Ta_Akses_Data_Check -13082019 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Ta_Akses_Data_Check @Tahun varchar(4), @IDPemda varchar(17), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @Reg varchar(4), @Status varchar(1)
WITH ENCRYPTION
AS
/*	
DECLARE @Tahun varchar(4), @IDPemda varchar(17), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @Reg varchar(4), @Status varchar(1)
SET @Tahun     = '2019' 
SET @Kd_Prov   = '99'
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang = '4' 
SET @Kd_Unit   = '1' 
SET @Kd_Sub    = '1'
SET @Kd_UPB    = '1'
SET @Kd_Aset   = '3'
SET @Kd_Aset0  = '1'
SET @Kd_Aset1  = '1'
SET @Kd_Aset2  = '1'
SET @Kd_Aset3  = '1'
SET @Kd_Aset4  = '1'
SET @Kd_Aset5  = '1'
SET @Status    = '0'
*/

	SELECT A.Tahun, A.No_Akses, B.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		B.Kd_Aset8, B.Kd_Aset80, B.Kd_Aset81, B.Kd_Aset82, B.Kd_Aset83, B.Kd_Aset84, B.Kd_Aset85, B.No_Reg8
	FROM Ta_Akses_Data A INNER JOIN Ta_Akses_Data_Rinc B ON A.Tahun = B.Tahun AND A.No_Akses = B.No_Akses
	WHERE A.Tahun = @Tahun AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB 
		AND B.Kd_Aset8 = @Kd_Aset 
		AND B.Kd_Aset80 = @Kd_Aset0 
		AND B.Kd_Aset81 = @Kd_Aset1 
		AND B.Kd_Aset82 = @Kd_Aset2 
		AND B.Kd_Aset83 = @Kd_Aset3 
		AND B.Kd_Aset84 = @Kd_Aset4 
		AND B.Kd_Aset85 = @Kd_Aset5
		AND B.No_Reg8 = @Reg 
		AND A.Status = @Status
	ORDER BY A.Tahun, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85




GO
