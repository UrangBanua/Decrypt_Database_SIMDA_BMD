USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_Qry_NoReg_A] (@Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), 
		@Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3))
RETURNS INT
WITH ENCRYPTION
AS  
BEGIN 
/*
DECLARE @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3)
SET @Kd_Prov = '99'
SET @Kd_KAb_Kota = '99'
SET @Kd_Bidang = '1' 
SET @Kd_Unit   = '1' 
SET @Kd_Sub    = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset1 = '2'
SET @Kd_Aset2 = '6'
SET @Kd_Aset3 = '2'
SET @Kd_Aset4 = '1'
SET @Kd_Aset5 = '30'
*/

	DECLARE @sNo_Register int

	SELECT @sNo_Register = (ISNULL(MAX(A.No_Register), 0) + 1)
	FROM	(

	SELECT A.No_Reg8 AS No_Register
	FROM Ta_KIB_A A
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota
		AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
		AND Kd_Aset8 = @Kd_Aset AND Kd_Aset80 = @Kd_Aset0 AND Kd_Aset81 = @Kd_Aset1 AND Kd_Aset82 = @Kd_Aset2 AND Kd_Aset83 = @Kd_Aset3
		AND Kd_Aset84 = @Kd_Aset4 AND Kd_Aset85 = @Kd_Aset5

	UNION ALL

	SELECT A.No_Register
	FROM Ta_KIBAHapus A INNER JOIN Ta_KIB_A B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota
		AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND B.Kd_Aset8 = @Kd_Aset AND B.Kd_Aset80 = @Kd_Aset0 AND B.Kd_Aset81 = @Kd_Aset1 AND B.Kd_Aset82 = @Kd_Aset2 AND B.Kd_Aset83 = @Kd_Aset3
		AND B.Kd_Aset84 = @Kd_Aset4 AND B.Kd_Aset85 = @Kd_Aset5

	UNION ALL

	SELECT A.No_Register
	FROM Ta_KIBAR A INNER JOIN Ta_KIB_A B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota
		AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND B.Kd_Aset8 = @Kd_Aset AND B.Kd_Aset80 = @Kd_Aset0 AND B.Kd_Aset81 = @Kd_Aset1 AND B.Kd_Aset82 = @Kd_Aset2 AND B.Kd_Aset83 = @Kd_Aset3
		AND B.Kd_Aset84 = @Kd_Aset4 AND B.Kd_Aset85 = @Kd_Aset5
		AND A.Kd_Riwayat = 3
	) A

	RETURN @sNo_Register
END


GO
