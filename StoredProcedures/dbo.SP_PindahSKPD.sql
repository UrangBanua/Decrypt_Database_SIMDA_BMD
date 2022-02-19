USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_PindahSKPD - 17112015 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_PindahSKPD @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), 
		@Aset1 varchar(2), @Aset2 varchar(3), @Aset3 varchar(3), @Aset4 varchar(3), @Aset5 varchar(3), @Reg varchar(4), @KIB varchar(1), @D2 Datetime
WITH ENCRYPTION
AS

/*
DECLARE @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), 
	@Aset1 varchar(2), @Aset2 varchar(3), @Aset3 varchar(3), @Aset4 varchar(3), @Aset5 varchar(3), @Reg varchar(3), @KIB varchar(1), @D2 Datetime

SET @D2 = '20121231'
SET @Kd_Prov = '17'
SET @Kd_Kab_Kota = '9'
SET @Kd_Bidang = '4'
SET @Kd_Unit = '1'
SET @Kd_Sub = '4'
SET @Kd_UPB = '1'
SET @Aset1 = '1'
SET @Aset2 = '1'
SET @Aset3 = '11'
SET @Aset4 = '4'
SET @Aset5 = '1'
SET @Reg = '1'
SET @KIB = 'A'
*/
	DECLARE @JLap tinyint SET @JLap = 1

IF @KIB = 'A' 
BEGIN
	UPDATE Ta_KIB_A
	SET Kd_Prov = A.Kd_Prov1,
            Kd_Kab_Kota = A.Kd_Kab_Kota1,
            Kd_Bidang = A.Kd_Bidang1,
            Kd_Unit = A.Kd_Unit1,
            Kd_Sub = A.Kd_Sub1,
            Kd_UPB = A.Kd_UPB1,
	    No_Register = A.No_Register1,
	    Tgl_Pembukuan = A.Tgl_Dokumen,
            Harga = B.Harga
        FROM (SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
                     Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
                     Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, Tgl_Dokumen
              FROM Ta_KIBAR 
              WHERE Kd_Riwayat = 3 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset1 = @Aset1 AND Kd_Aset2 = @Aset2 AND Kd_Aset3 = @Aset3 AND Kd_Aset4 = @Aset4 AND Kd_Aset5 = @Aset5 AND No_Register = @Reg
              ) A INNER JOIN
		fn_Kartu_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
			AND A.No_Register = B.No_Register
	WHERE Ta_KIB_A.Kd_Prov = @Kd_Prov AND Ta_KIB_A.Kd_Kab_Kota = @Kd_Kab_Kota AND Ta_KIB_A.Kd_Bidang = @Kd_Bidang AND Ta_KIB_A.Kd_Unit = @Kd_Unit AND Ta_KIB_A.Kd_Sub = @Kd_Sub AND Ta_KIB_A.Kd_UPB = @Kd_UPB
	      AND Ta_KIB_A.Kd_Aset1 = @Aset1 AND Ta_KIB_A.Kd_Aset2 = @Aset2 AND Ta_KIB_A.Kd_Aset3 = @Aset3 AND Ta_KIB_A.Kd_Aset4 = @Aset4 AND Ta_KIB_A.Kd_Aset5 = @Aset5 AND Ta_KIB_A.No_Register = @Reg
END

IF @KIB = 'B'
BEGIN
        UPDATE Ta_KIB_B
	SET Kd_Prov = A.Kd_Prov1,
            Kd_Kab_Kota = A.Kd_Kab_Kota1,
            Kd_Bidang = A.Kd_Bidang1,
            Kd_Unit = A.Kd_Unit1,
            Kd_Sub = A.Kd_Sub1,
            Kd_UPB = A.Kd_UPB1,
	    No_Register = A.No_Register1,
	    Tgl_Pembukuan = A.Tgl_Dokumen,
            Harga = B.Harga
        FROM (SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
                     Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
                     Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, Tgl_Dokumen
              FROM Ta_KIBBR 
              WHERE Kd_Riwayat = 3 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset1 = @Aset1 AND Kd_Aset2 = @Aset2 AND Kd_Aset3 = @Aset3 AND Kd_Aset4 = @Aset4 AND Kd_Aset5 = @Aset5 AND No_Register = @Reg
              ) A INNER JOIN
		fn_Kartu_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
			AND A.No_Register = B.No_Register
	WHERE Ta_KIB_B.Kd_Prov = @Kd_Prov AND Ta_KIB_B.Kd_Kab_Kota = @Kd_Kab_Kota AND Ta_KIB_B.Kd_Bidang = @Kd_Bidang AND Ta_KIB_B.Kd_Unit = @Kd_Unit AND Ta_KIB_B.Kd_Sub = @Kd_Sub AND Ta_KIB_B.Kd_UPB = @Kd_UPB
	AND Ta_KIB_B.Kd_Aset1 = @Aset1 AND Ta_KIB_B.Kd_Aset2 = @Aset2 AND Ta_KIB_B.Kd_Aset3 = @Aset3 AND Ta_KIB_B.Kd_Aset4 = @Aset4 AND Ta_KIB_B.Kd_Aset5 = @Aset5 AND Ta_KIB_B.No_Register = @Reg
END

IF @KIB = 'C'
BEGIN
	UPDATE Ta_KIB_C
	SET Kd_Prov = A.Kd_Prov1,
            Kd_Kab_Kota = A.Kd_Kab_Kota1,
            Kd_Bidang = A.Kd_Bidang1,
            Kd_Unit = A.Kd_Unit1,
            Kd_Sub = A.Kd_Sub1,
            Kd_UPB = A.Kd_UPB1,
	    No_Register = A.No_Register1,
	    Tgl_Pembukuan = A.Tgl_Dokumen,
            Harga = B.Harga
        FROM (SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
                     Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
                     Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, Tgl_Dokumen
              FROM Ta_KIBCR 
              WHERE Kd_Riwayat = 3 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset1 = @Aset1 AND Kd_Aset2 = @Aset2 AND Kd_Aset3 = @Aset3 AND Kd_Aset4 = @Aset4 AND Kd_Aset5 = @Aset5 AND No_Register = @Reg
              ) A INNER JOIN
		fn_Kartu_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
			AND A.No_Register = B.No_Register
	WHERE Ta_KIB_C.Kd_Prov = @Kd_Prov AND Ta_KIB_C.Kd_Kab_Kota = @Kd_Kab_Kota AND Ta_KIB_C.Kd_Bidang = @Kd_Bidang AND Ta_KIB_C.Kd_Unit = @Kd_Unit AND Ta_KIB_C.Kd_Sub = @Kd_Sub AND Ta_KIB_C.Kd_UPB = @Kd_UPB
	AND Ta_KIB_C.Kd_Aset1 = @Aset1 AND Ta_KIB_C.Kd_Aset2 = @Aset2 AND Ta_KIB_C.Kd_Aset3 = @Aset3 AND Ta_KIB_C.Kd_Aset4 = @Aset4 AND Ta_KIB_C.Kd_Aset5 = @Aset5 AND Ta_KIB_C.No_Register = @Reg
END

IF @KIB = 'D'
BEGIN
	UPDATE Ta_KIB_D
	SET Kd_Prov = A.Kd_Prov1,
            Kd_Kab_Kota = A.Kd_Kab_Kota1,
            Kd_Bidang = A.Kd_Bidang1,
            Kd_Unit = A.Kd_Unit1,
            Kd_Sub = A.Kd_Sub1,
            Kd_UPB = A.Kd_UPB1,
	    No_Register = A.No_Register1,
	    Tgl_Pembukuan = A.Tgl_Dokumen,
            Harga = B.Harga
        FROM (SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
                     Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
                     Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, Tgl_Dokumen
              FROM Ta_KIBDR 
              WHERE Kd_Riwayat = 3 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset1 = @Aset1 AND Kd_Aset2 = @Aset2 AND Kd_Aset3 = @Aset3 AND Kd_Aset4 = @Aset4 AND Kd_Aset5 = @Aset5 AND No_Register = @Reg
              ) A INNER JOIN
		fn_Kartu_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
			AND A.No_Register = B.No_Register
	WHERE Ta_KIB_D.Kd_Prov = @Kd_Prov AND Ta_KIB_D.Kd_Kab_Kota = @Kd_Kab_Kota AND Ta_KIB_D.Kd_Bidang = @Kd_Bidang AND Ta_KIB_D.Kd_Unit = @Kd_Unit AND Ta_KIB_D.Kd_Sub = @Kd_Sub AND Ta_KIB_D.Kd_UPB = @Kd_UPB
	AND Ta_KIB_D.Kd_Aset1 = @Aset1 AND Ta_KIB_D.Kd_Aset2 = @Aset2 AND Ta_KIB_D.Kd_Aset3 = @Aset3 AND Ta_KIB_D.Kd_Aset4 = @Aset4 AND Ta_KIB_D.Kd_Aset5 = @Aset5 AND Ta_KIB_D.No_Register = @Reg
END

IF @KIB = 'E'
BEGIN
	UPDATE Ta_KIB_E
	SET Kd_Prov = A.Kd_Prov1,
            Kd_Kab_Kota = A.Kd_Kab_Kota1,
            Kd_Bidang = A.Kd_Bidang1,
            Kd_Unit = A.Kd_Unit1,
            Kd_Sub = A.Kd_Sub1,
            Kd_UPB = A.Kd_UPB1,
	    No_Register = A.No_Register1,
	    Tgl_Pembukuan = A.Tgl_Dokumen,
            Harga = B.Harga
        FROM (SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
                     Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
                     Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, Tgl_Dokumen
              FROM Ta_KIBER 
              WHERE Kd_Riwayat = 3 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset1 = @Aset1 AND Kd_Aset2 = @Aset2 AND Kd_Aset3 = @Aset3 AND Kd_Aset4 = @Aset4 AND Kd_Aset5 = @Aset5 AND No_Register = @Reg
              ) A INNER JOIN
		fn_Kartu_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
			AND A.No_Register = B.No_Register
	WHERE Ta_KIB_E.Kd_Prov = @Kd_Prov AND Ta_KIB_E.Kd_Kab_Kota = @Kd_Kab_Kota AND Ta_KIB_E.Kd_Bidang = @Kd_Bidang AND Ta_KIB_E.Kd_Unit = @Kd_Unit AND Ta_KIB_E.Kd_Sub = @Kd_Sub AND Ta_KIB_E.Kd_UPB = @Kd_UPB
	AND Ta_KIB_E.Kd_Aset1 = @Aset1 AND Ta_KIB_E.Kd_Aset2 = @Aset2 AND Ta_KIB_E.Kd_Aset3 = @Aset3 AND Ta_KIB_E.Kd_Aset4 = @Aset4 AND Ta_KIB_E.Kd_Aset5 = @Aset5 AND Ta_KIB_E.No_Register = @Reg
END





GO
