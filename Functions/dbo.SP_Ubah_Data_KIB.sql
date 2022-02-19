USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Ubah_Data_KIB - 12122017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Ubah_Data_KIB @IDPemda varchar(17), @Log_User varchar(20), @Kd_KIB varchar(1)
WITH ENCRYPTION
AS
/*
DECLARE @IDPemda varchar(17), @Log_User varchar(20)
SET @IDPemda  = '04010011011000001'
SET @Log_User = 'simda'
*/

DECLARE @JLap tinyint SET @JLap = 1
DECLARE @KdID INT
DECLARE @KdReg INT
DECLARE @KdIDPemda Varchar(17)

IF @Kd_KIB = 'A'
BEGIN
    BEGIN TRANSACTION
	UPDATE Ta_KIB_A
	SET Luas_M2 = A.Luas_M2,
            Alamat = A.Alamat,
            Sertifikat_Tanggal = A.Sertifikat_Tanggal,
            Sertifikat_Nomor = A.Sertifikat_Nomor,
            Penggunaan = A.Penggunaan,
            Keterangan = A.Keterangan
        FROM (SELECT IDPemda, Luas_M2, Alamat, Sertifikat_Tanggal, Sertifikat_Nomor, Penggunaan, Keterangan
              FROM Ta_KIBAR 
              WHERE Kd_Riwayat = 18 AND IDPemda = @IDPemda 
	      AND No_Urut = (SELECT MAX(No_Urut) AS No_Urut FROM Ta_KIBAR WHERE Kd_Riwayat = 18 AND IDPemda = @IDPemda)
              ) A 
	WHERE Ta_KIB_A.IDPemda = @IDPemda 
    COMMIT
END

IF @Kd_KIB = 'B'
BEGIN
    BEGIN TRANSACTION
	UPDATE Ta_KIB_B
	SET Merk=A.Merk, 
	    Type=A.Type, 
	    CC=A.CC, 
  	    Bahan=A.Bahan, 
	    Nomor_Pabrik=A.Nomor_Pabrik, 
	    Nomor_Rangka=A.Nomor_Rangka, 
	    Nomor_Mesin=A.Nomor_Mesin, 
	    Nomor_Polisi=A.Nomor_Polisi, 
	    Nomor_BPKB=A.Nomor_BPKB, 
	    Keterangan=A.Keterangan
        FROM (SELECT IDPemda, Merk, Type, CC, Bahan=Bahan, Nomor_Pabrik, Nomor_Rangka, Nomor_Mesin, Nomor_Polisi, Nomor_BPKB, Keterangan
              FROM Ta_KIBBR 
              WHERE Kd_Riwayat = 18 AND IDPemda = @IDPemda
	      AND No_Urut = (SELECT MAX(No_Urut) AS No_Urut FROM Ta_KIBBR WHERE Kd_Riwayat = 18 AND IDPemda = @IDPemda)	  
              ) A 
	WHERE Ta_KIB_B.IDPemda = @IDPemda
    COMMIT
END

IF @Kd_KIB = 'C'
BEGIN
    BEGIN TRANSACTION
	UPDATE Ta_KIB_C
	SET Luas_Lantai = A.Luas_Lantai,
            Lokasi = A.Lokasi,
            Dokumen_Tanggal = A.Dokumen_Tanggal,
            Dokumen_Nomor = A.Dokumen_Nomor,
            Keterangan = A.Keterangan
        FROM (SELECT IDPemda, Luas_Lantai, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Keterangan
              FROM Ta_KIBCR 
              WHERE Kd_Riwayat = 18 AND IDPemda = @IDPemda
	      AND No_Urut = (SELECT MAX(No_Urut) AS No_Urut FROM Ta_KIBCR WHERE Kd_Riwayat = 18 AND IDPemda = @IDPemda)
              ) A 
	WHERE Ta_KIB_C.IDPemda = @IDPemda
    COMMIT
END

IF @Kd_KIB = 'D'
BEGIN
    BEGIN TRANSACTION
	UPDATE Ta_KIB_D
	SET Konstruksi = A.Konstruksi,
	    Panjang = A.Panjang, 
 	    Lebar = A.Lebar, 
	    Luas = A.Luas, 
	    Lokasi = A.Lokasi, 
	    Dokumen_Tanggal = A.Dokumen_Tanggal,
	    Dokumen_Nomor = A.Dokumen_Nomor,
	    Keterangan = A.Keterangan
        FROM (SELECT IDPemda, Konstruksi, Panjang, Lebar, Luas, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Keterangan
              FROM Ta_KIBDR 
              WHERE Kd_Riwayat = 18 AND IDPemda = @IDPemda
	      AND No_Urut = (SELECT MAX(No_Urut) AS No_Urut FROM Ta_KIBDR WHERE Kd_Riwayat = 18 AND IDPemda = @IDPemda)
              ) A 
	WHERE Ta_KIB_D.IDPemda = @IDPemda
    COMMIT
END

IF @Kd_KIB = 'E'
BEGIN
	BEGIN TRANSACTION
	UPDATE Ta_KIB_E
	SET Judul = A.Judul, 
	    Pencipta = A.Pencipta, 
	    Bahan = A.Bahan, 
   	    Keterangan = A.Keterangan
        FROM (SELECT IDPemda, Judul, Pencipta, Bahan, Keterangan
              FROM Ta_KIBER 
              WHERE Kd_Riwayat = 18 AND IDPemda = @IDPemda
	      AND No_Urut = (SELECT MAX(No_Urut) AS No_Urut FROM Ta_KIBER WHERE Kd_Riwayat = 18 AND IDPemda = @IDPemda)
              ) A 
	WHERE Ta_KIB_E.IDPemda = @IDPemda
	COMMIT
END




GO
