USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** SP_BatalPindahSKPD - 23032017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_BatalPindahSKPD @IDPemda varchar(17), @Kd_ID varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), 
		@Aset varchar(2), @Aset0 varchar(3), @Aset1 varchar(2), @Aset2 varchar(3), @Aset3 varchar(3), @Aset4 varchar(3), @Aset5 varchar(3), @Reg varchar(4), @KIB varchar(1)
WITH ENCRYPTION
AS

/*
DECLARE @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), 
	@Aset1 varchar(2), @Aset2 varchar(3), @Aset3 varchar(3), @Aset4 varchar(3), @Aset5 varchar(3), @Reg varchar(3), @KIB varchar(1)

SET @D2 = '20181231'
SET @Kd_Prov = '99'
SET @Kd_Kab_Kota = '99'
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

IF @KIB = 'A'
BEGIN
	UPDATE Ta_KIB_A
	SET Kd_Prov = A.Kd_Prov,
            Kd_Kab_Kota = A.Kd_Kab_Kota,
            Kd_Bidang = A.Kd_Bidang,
            Kd_Unit = A.Kd_Unit,
            Kd_Sub = A.Kd_Sub,
            Kd_UPB = A.Kd_UPB,
	    No_Register = A.No_Register,
	    Tgl_Pembukuan = A.Tgl_Pembukuan,
            Harga = A.Harga
        FROM (SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
                     Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
                     Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, Tgl_Dokumen, Tgl_Pembukuan, Harga
              FROM Ta_KIBAR 
              WHERE IDPemda = @IDPemda AND Kd_Riwayat = 3 AND Kd_ID = @Kd_ID AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Register = @Reg
              ) A 
	WHERE Ta_KIB_A.IDPemda = @IDPemda 

	DELETE Ta_KIBAR
	WHERE IDPemda = @IDPemda AND Kd_Riwayat = 3 AND Kd_ID = @Kd_ID AND Kd_Prov1 = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Register = @Reg
END

IF @KIB = 'B'
BEGIN
	UPDATE Ta_KIB_B
	SET Kd_Prov = A.Kd_Prov,
            Kd_Kab_Kota = A.Kd_Kab_Kota,
            Kd_Bidang = A.Kd_Bidang,
            Kd_Unit = A.Kd_Unit,
            Kd_Sub = A.Kd_Sub,
            Kd_UPB = A.Kd_UPB,
	    No_Register = A.No_Register,
	    Tgl_Pembukuan = A.Tgl_Pembukuan,
            Harga = A.Harga
        FROM (SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
                     Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
                     Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, Tgl_Dokumen, Tgl_Pembukuan, Harga
              FROM Ta_KIBBR 
              WHERE IDPemda = @IDPemda AND Kd_Riwayat = 3 AND Kd_ID = @Kd_ID AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Register = @Reg
              ) A 
	WHERE Ta_KIB_B.IDPemda = @IDPemda 

	DELETE Ta_KIBBR
	WHERE IDPemda = @IDPemda AND Kd_Riwayat = 3 AND Kd_ID = @Kd_ID AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Register = @Reg
END

IF @KIB = 'C'
BEGIN
	UPDATE Ta_KIB_C
	SET Kd_Prov = A.Kd_Prov,
            Kd_Kab_Kota = A.Kd_Kab_Kota,
            Kd_Bidang = A.Kd_Bidang,
            Kd_Unit = A.Kd_Unit,
            Kd_Sub = A.Kd_Sub,
            Kd_UPB = A.Kd_UPB,
	    No_Register = A.No_Register,
	    Tgl_Pembukuan = A.Tgl_Pembukuan,
            Harga = A.Harga
        FROM (SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
                     Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
                     Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, Tgl_Dokumen, Tgl_Pembukuan, Harga
              FROM Ta_KIBCR 
              WHERE IDPemda = @IDPemda AND Kd_Riwayat = 3 AND Kd_ID = @Kd_ID AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Register = @Reg
              ) A 
	WHERE Ta_KIB_C.IDPemda = @IDPemda 

	DELETE Ta_KIBCR
	WHERE IDPemda = @IDPemda AND Kd_Riwayat = 3 AND Kd_ID = @Kd_ID AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Register = @Reg
END

IF @KIB = 'D'
BEGIN
	UPDATE Ta_KIB_D
	SET Kd_Prov = A.Kd_Prov,
            Kd_Kab_Kota = A.Kd_Kab_Kota,
            Kd_Bidang = A.Kd_Bidang,
            Kd_Unit = A.Kd_Unit,
            Kd_Sub = A.Kd_Sub,
            Kd_UPB = A.Kd_UPB,
	    No_Register = A.No_Register,
	    Tgl_Pembukuan = A.Tgl_Pembukuan,
            Harga = A.Harga
        FROM (SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
                     Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
                     Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, Tgl_Dokumen, Tgl_Pembukuan, Harga
              FROM Ta_KIBDR 
              WHERE IDPemda = @IDPemda AND Kd_Riwayat = 3 AND Kd_ID = @Kd_ID AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Register = @Reg
              ) A 
	WHERE Ta_KIB_D.IDPemda = @IDPemda 

	DELETE Ta_KIBDR
	WHERE IDPemda = @IDPemda AND Kd_Riwayat = 3 AND Kd_ID = @Kd_ID AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Register = @Reg
END

IF @KIB = 'E'
BEGIN
	UPDATE Ta_KIB_E
	SET Kd_Prov = A.Kd_Prov,
            Kd_Kab_Kota = A.Kd_Kab_Kota,
            Kd_Bidang = A.Kd_Bidang,
            Kd_Unit = A.Kd_Unit,
            Kd_Sub = A.Kd_Sub,
            Kd_UPB = A.Kd_UPB,
	    No_Register = A.No_Register,
	    Tgl_Pembukuan = A.Tgl_Pembukuan,
            Harga = A.Harga
        FROM (SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
                     Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
                     Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, Tgl_Dokumen, Tgl_Pembukuan, Harga
              FROM Ta_KIBER 
              WHERE IDPemda = @IDPemda AND Kd_Riwayat = 3 AND Kd_ID = @Kd_ID AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Register = @Reg
              ) A 
	WHERE Ta_KIB_E.IDPemda = @IDPemda 

	DELETE Ta_KIBER
	WHERE IDPemda = @IDPemda AND Kd_Riwayat = 3 AND Kd_ID = @Kd_ID AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Register = @Reg
END



GO
