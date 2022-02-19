USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/** fn_Qry_NoReg_108 - 20022020 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE FUNCTION dbo.fn_Qry_NoReg_108 (@Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @Kd_KIB varchar(3)) 
RETURNS INT
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3)
SET @Kd_Prov = '5'
SET @Kd_KAb_Kota = '1'
SET @Kd_Bidang = '5' 
SET @Kd_Unit   = '1' 
SET @Kd_Sub    = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset = '1'
SET @Kd_Aset0 = '3'
SET @Kd_Aset1 = '4'
SET @Kd_Aset2 = '1'
SET @Kd_Aset3 = '1'
SET @Kd_Aset4 = '3'
SET @Kd_Aset5 = '1'
*/
BEGIN
	DECLARE @sNo_Register int
	
	IF @Kd_KIB = 'A'
	BEGIN
		--INSERT INTO @sNo_Register
		SELECT @sNo_Register = ISNULL(MAX(A.No_Register), 0) + 1
		FROM	(
			SELECT A.No_Reg8 AS No_Register
			FROM Ta_KIB_A A 
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
	
			UNION ALL 

			SELECT A.No_Register
			FROM Ta_KIBAHapus A 
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
	
			UNION ALL 

			SELECT A.No_Register
			FROM Ta_KIBAR A
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
				AND A.Kd_Riwayat = 3
		) A
	END
	
	IF @Kd_KIB = 'B'
	BEGIN
		--INSERT INTO @sNo_Register
		SELECT @sNo_Register = ISNULL(MAX(A.No_Register), 0) + 1
		FROM	(
			SELECT A.No_Reg8 AS No_Register
			FROM Ta_KIB_B A 
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
	
			UNION ALL 

			SELECT A.No_Register
			FROM Ta_KIBBHapus A 
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
	
			UNION ALL 

			SELECT A.No_Register
			FROM Ta_KIBBR A
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
				AND A.Kd_Riwayat = 3
		) A
	END
	
	IF @Kd_KIB = 'C'
	BEGIN
		--INSERT INTO @sNo_Register
		SELECT @sNo_Register = ISNULL(MAX(A.No_Register), 0) + 1
		FROM	(
			SELECT A.No_Reg8 AS No_Register
			FROM Ta_KIB_C A 
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
	
			UNION ALL 

			SELECT A.No_Register
			FROM Ta_KIBCHapus A 
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
	
			UNION ALL 

			SELECT A.No_Register
			FROM Ta_KIBCR A
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
				AND A.Kd_Riwayat = 3
		) A
	END
	
	IF @Kd_KIB = 'D'
	BEGIN
		--INSERT INTO @sNo_Register
		SELECT @sNo_Register = ISNULL(MAX(A.No_Register), 0) + 1
		FROM	(
			SELECT A.No_Reg8 AS No_Register
			FROM Ta_KIB_D A 
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
	
			UNION ALL 

			SELECT A.No_Register
			FROM Ta_KIBDHapus A 
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
	
			UNION ALL 

			SELECT A.No_Register
			FROM Ta_KIBDR A
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
				AND A.Kd_Riwayat = 3
		) A
	END
	
	IF @Kd_KIB = 'E'
	BEGIN
		--INSERT INTO @sNo_Register
		SELECT @sNo_Register = ISNULL(MAX(A.No_Register), 0) + 1
		FROM	(
			SELECT A.No_Reg8 AS No_Register
			FROM Ta_KIB_E A 
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
	
			UNION ALL 

			SELECT A.No_Register
			FROM Ta_KIBEHapus A 
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
	
			UNION ALL 

			SELECT A.No_Register
			FROM Ta_KIBER A
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
				AND A.Kd_Riwayat = 3
		) A
	END
	
	IF @Kd_KIB = 'L'
	BEGIN
		--INSERT INTO @sNo_Register
		SELECT @sNo_Register = ISNULL(MAX(A.No_Register), 0) + 1
		FROM	(
			SELECT A.No_Reg8 AS No_Register
			FROM Ta_Lainnya A 
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
	
			UNION ALL 

			SELECT A.No_Register
			FROM Ta_KILHapus A 
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
	
			UNION ALL 

			SELECT A.No_Register
			FROM Ta_KILER A
			WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
				AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
				AND A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5
				AND A.Kd_Riwayat = 3
		) A
	END

	RETURN @sNo_Register
END





GO
