USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE SP_Proses_Mutasi_Barang @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	     @Aset varchar(2), @Aset0 varchar(2), @Aset1 varchar(2), @Aset2 varchar(3), @Aset3 varchar(3), @Aset4 varchar(3), @Aset5 varchar(3), @Reg varchar(5), @Tgl_Dokumen datetime, @No_Dokumen varchar(100),
		 @Kd_Prov1 varchar(3), @Kd_Kab_Kota1 varchar(3), @Kd_Bidang1 varchar(3), @Kd_Unit1 varchar(3), @Kd_Sub1 varchar(3), @Kd_UPB1 varchar(3), @Reg1 varchar(5), 
		 @Kd_KIB varchar(1), @D2 Datetime
WITH ENCRYPTION
AS

/*
DECLARE @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	     @Aset varchar(2), @Aset0 varchar(2), @Aset1 varchar(2), @Aset2 varchar(3), @Aset3 varchar(3), @Aset4 varchar(3), @Aset5 varchar(3), @Reg varchar(5), @Tgl_Dokumen datetime, @No_Dokumen varchar(100),
		 @Kd_Prov1 varchar(3), @Kd_Kab_Kota1 varchar(3), @Kd_Bidang1 varchar(3), @Kd_Unit1 varchar(3), @Kd_Sub1 varchar(3), @Kd_UPB1 varchar(3), @Reg1 varchar(5), 
		 @Kd_KIB varchar(1), @D2 Datetime

SET @Kd_Prov = '99'
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Aset  = '1'
SET @Aset0 = '3'
SET @Aset1 = '2'
SET @Aset2 = '2'
SET @Aset3 = '3'
SET @Aset4 = '4'
SET @Aset5 = '4'
SET @Reg = '1'
SET @Tgl_Dokumen = '20181231'
SET @No_Dokumen = '675/SIMDA/2018'		 
SET @Kd_Prov1 = '99'
SET @Kd_Kab_Kota1 = '99'
SET @Kd_Bidang1 = '3'
SET @Kd_Unit1 = '1'
SET @Kd_Sub1 = '1'
SET @Kd_UPB1 = '101'
SET @Reg1 = '1'
SET @Kd_KIB = 'B'
SET @D2 = '20181231'
*/
DECLARE @Tahun varchar(4)
SET @Tahun = YEAR(@D2)

DECLARE @JLap tinyint SET @JLap = 1
DECLARE @KdID INT
DECLARE @KdReg INT
DECLARE @KdIDPemda Varchar(17)
DECLARE @KdKondisi Varchar(2)
DECLARE @JmlHarga Money SET @JmlHarga = 0

IF @Kd_KIB = 'A'
BEGIN
	SELECT @KdIDPemda = IDPemda
	FROM Ta_KIB_A
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	SELECT @KdID = ISNULL(MAX(Kd_ID),0)+1 FROM Ta_KIBAR WHERE IDPemda = @KdIDPemda

	SELECT @KdReg = ISNULL(MAX(A.No_Register),0) FROM
	( 
		SELECT ISNULL(MAX(No_Reg8),0)+1 AS No_Register
        	FROM Ta_KIB_A
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
		UNION ALL
		SELECT ISNULL(MAX(No_Register),0)+1 AS No_Register
        	FROM Ta_KIBAR
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
	) A

	SELECT @JmlHarga = Harga FROM dbo.fn_Kartu108_BrgA1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)

	BEGIN TRANSACTION
	INSERT INTO Ta_KIBAR (IDPemda, Kd_Riwayat, Kd_Id, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
			--Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
			Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Luas_M2, Alamat, 

			Hak_Tanah, Sertifikat_Tanggal, Sertifikat_Nomor, Penggunaan,
			Asal_usul, Harga, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, 
			Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, 
			Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_Alasan, Log_User, Log_entry)
	SELECT A.IDPemda, 3 AS Kd_Riwayat, @KdID, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		--A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
		A.Kd_Pemilik, @Tgl_Dokumen, @No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Luas_M2, A.Alamat, 
		A.Hak_Tanah, A.Sertifikat_Tanggal, A.Sertifikat_Nomor, A.Penggunaan,
		A.Asal_usul, B.Harga, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa,
		@Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @KdReg,
		A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, 105, A.Log_User, A.Log_entry
	FROM Ta_KIB_A A INNER JOIN
		(SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, MAX(Harga) AS Harga 
		FROM fn_Kartu108_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)
		GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
			AND A.No_Reg8 = B.No_Register
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
	      AND A.Kd_Aset8 = @Aset AND A.Kd_Aset80 = @Aset0 AND A.Kd_Aset81 = @Aset1 AND A.Kd_Aset82 = @Aset2 AND A.Kd_Aset83 = @Aset3 AND A.Kd_Aset84 = @Aset4 AND A.Kd_Aset85 = @Aset5 AND A.No_Reg8 = @Reg

	UPDATE Ta_KIB_A
	SET Kd_Prov = @Kd_Prov1,
            Kd_Kab_Kota = @Kd_Kab_Kota1,
            Kd_Bidang = @Kd_Bidang1,
            Kd_Unit = @Kd_Unit1,
            Kd_Sub = @Kd_Sub1,
            Kd_UPB = @Kd_UPB1,
			No_Reg8 = @KdReg,
			Tgl_Pembukuan = @Tgl_Dokumen,
            Harga = @JmlHarga,
			Kd_Data = 6
	WHERE IDPemda = @KdIDPemda
	COMMIT
END

IF @Kd_KIB = 'B'
BEGIN
	SELECT @KdIDPemda = IDPemda
	FROM Ta_KIB_B
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	SELECT @KdID = ISNULL(MAX(Kd_ID),0)+1 FROM Ta_KIBBR WHERE IDPemda = @KdIDPemda

	SELECT @KdReg = ISNULL(MAX(A.No_Register),0) FROM
	( 
		SELECT ISNULL(MAX(No_Reg8),0)+1 AS No_Register
        	FROM Ta_KIB_B
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
		UNION ALL
		SELECT ISNULL(MAX(No_Register),0)+1 AS No_Register
        	FROM Ta_KIBBR
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
	) A

	SELECT @JmlHarga = Harga, @KdKondisi = Kondisi FROM fn_Kartu108_BrgB1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)

	BEGIN TRANSACTION
	INSERT INTO Ta_KIBBR (IDPemda, Kd_Id, Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		--Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
		Kd_Ruang, Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, 
		Merk, Type, CC, Bahan, Nomor_Pabrik, Nomor_Rangka, Nomor_Mesin, Nomor_Polisi, Nomor_BPKB,
		Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa,
		Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, 
		Kd_Penyusutan, Kd_Data, Invent, No_SKGuna, Kd_KA, Kd_Alasan, Log_User, Log_entry)
	SELECT A.IDPemda, @KdID, 3 AS Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		--A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
		A.Kd_Ruang, A.Kd_Pemilik, @Tgl_Dokumen, @No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, 
		A.Merk, A.Type, A.CC, A.Bahan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, A.Nomor_BPKB, 
		A.Asal_usul, B.Kondisi, B.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_Id, A.Kd_Kecamatan, A.Kd_Desa, 
		@Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @KdReg,
		A.Kd_Penyusutan, A.Kd_Data, A.Invent, A.No_SKGuna, A.Kd_KA, 105, A.Log_User, A.Log_entry
	FROM Ta_KIB_B A INNER JOIN
		(SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, MAX(Kondisi) AS Kondisi, MAX(Harga) AS Harga
		FROM fn_Kartu108_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)
		GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
			AND A.No_Reg8 = B.No_Register
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	UPDATE Ta_KIB_B
	SET Kd_Prov = @Kd_Prov1,
            Kd_Kab_Kota = @Kd_Kab_Kota1,
            Kd_Bidang = @Kd_Bidang1,
            Kd_Unit = @Kd_Unit1,
            Kd_Sub = @Kd_Sub1,
            Kd_UPB = @Kd_UPB1,
			No_Reg8 = @KdReg,
			Tgl_Pembukuan = @Tgl_Dokumen,
            Harga = @JmlHarga,
			Kondisi = @KdKondisi,
			Kd_Data = 6
	WHERE IDPemda = @KdIDPemda
	COMMIT
END

IF @Kd_KIB = 'C'
BEGIN
   	SELECT @KdIDPemda = IDPemda
	FROM Ta_KIB_C
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	SELECT @KdID = ISNULL(MAX(Kd_ID),0)+1 FROM Ta_KIBCR WHERE IDPemda = @KdIDPemda

	SELECT @KdReg = ISNULL(MAX(A.No_Register),0) FROM
	( 
		SELECT ISNULL(MAX(No_Reg8),0)+1 AS No_Register
        	FROM Ta_KIB_C
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
		UNION ALL
		SELECT ISNULL(MAX(No_Register),0)+1 AS No_Register
        	FROM Ta_KIBCR
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
	) A

	SELECT @JmlHarga = Harga, @KdKondisi = Kondisi FROM fn_Kartu108_BrgC1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)

	BEGIN TRANSACTION
	INSERT INTO Ta_KIBCR (IDPemda, Kd_Id, Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		--Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
		Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Bertingkat_Tidak, Beton_tidak, 
		Luas_Lantai, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, Kd_Tanah1,
		Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, 
		Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa,
		Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, 
		Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Kd_Alasan, Log_User, Log_entry)
	SELECT A.IDPemda, @KdID, 3 AS Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		--A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
		A.Kd_Pemilik, @Tgl_Dokumen, @No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Bertingkat_Tidak, A.Beton_tidak, 
		A.Luas_Lantai, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah, A.Kd_Tanah1,
		A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_usul, B.Kondisi, B.Harga, 
		A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, 
		@Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @KdReg,
		A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, 105, A.Log_User, A.Log_entry
	FROM Ta_KIB_C A INNER JOIN
		(SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, MAX(Kondisi) AS Kondisi, MAX(Harga) AS Harga
		FROM fn_Kartu108_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)
		GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
			AND A.No_Reg8 = B.No_Register
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	UPDATE Ta_KIB_C
	SET Kd_Prov = @Kd_Prov1,
            Kd_Kab_Kota = @Kd_Kab_Kota1,
            Kd_Bidang = @Kd_Bidang1,
            Kd_Unit = @Kd_Unit1,
            Kd_Sub = @Kd_Sub1,
            Kd_UPB = @Kd_UPB1,
			No_Reg8 = @KdReg,
			Tgl_Pembukuan = @Tgl_Dokumen,
            Harga = @JmlHarga,
			Kondisi = @KdKondisi,
			Kd_Data = 6
	WHERE IDPemda = @KdIDPemda
	COMMIT
END

IF @Kd_KIB = 'D'
BEGIN
	SELECT @KdIDPemda = IDPemda
	FROM Ta_KIB_D
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	SELECT @KdID = ISNULL(MAX(Kd_ID),0)+1 FROM Ta_KIBDR WHERE IDPemda = @KdIDPemda

	SELECT @KdReg = ISNULL(MAX(A.No_Register),0) FROM
	( 
		SELECT ISNULL(MAX(No_Reg8),0)+1 AS No_Register
        	FROM Ta_KIB_D
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
		UNION ALL
		SELECT ISNULL(MAX(No_Register),0)+1 AS No_Register
        	FROM Ta_KIBDR
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
	) A

	SELECT @JmlHarga = Harga, @KdKondisi = Kondisi FROM fn_Kartu108_BrgD1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)

	BEGIN TRANSACTION
	INSERT INTO Ta_KIBDR (IDPemda, Kd_Id, Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		--Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
		Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Konstruksi, Panjang, Lebar, Luas, Lokasi, 
		Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, 
		Kd_Tanah1, Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, 
		Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa,
		Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, 
		Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Kd_Alasan, Log_User, Log_entry)
	SELECT A.IDPemda, @KdID, 3 AS Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		--A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
		A.Kd_Pemilik, @Tgl_Dokumen, @No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Konstruksi, A.Panjang, A.Lebar, A.Luas, A.Lokasi, 
		A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah, 
		A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_usul, 
		B.Kondisi, B.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, 
		@Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @KdReg,
		A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, 105, A.Log_User, A.Log_entry
	FROM Ta_KIB_D A INNER JOIN
		(SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Max(Kondisi) AS Kondisi, MAX(Harga) AS Harga 
		FROM fn_Kartu108_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)
		GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
			AND A.No_Reg8 = B.No_Register
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	UPDATE Ta_KIB_D
	SET Kd_Prov = @Kd_Prov1,
            Kd_Kab_Kota = @Kd_Kab_Kota1,
            Kd_Bidang = @Kd_Bidang1,
            Kd_Unit = @Kd_Unit1,
            Kd_Sub = @Kd_Sub1,
            Kd_UPB = @Kd_UPB1,
			No_Reg8 = @KdReg,
			Tgl_Pembukuan = @Tgl_Dokumen,
            Harga = @JmlHarga,
			Kondisi = @KdKondisi,
			Kd_Data = 6
        WHERE IDPemda = @KdIDPemda
	COMMIT
END

IF @Kd_KIB = 'E'
BEGIN
	SELECT @KdIDPemda = IDPemda
	FROM Ta_KIB_E
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	SELECT @KdID = ISNULL(MAX(Kd_ID),0)+1 FROM Ta_KIBER WHERE IDPemda = @KdIDPemda

	SELECT @KdReg = ISNULL(MAX(A.No_Register),0) FROM
	( 
		SELECT ISNULL(MAX(No_Reg8),0)+1 AS No_Register
        	FROM Ta_KIB_E
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
		UNION ALL
		SELECT ISNULL(MAX(No_Register),0)+1 AS No_Register
        	FROM Ta_KIBER
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
	) A

	SELECT @JmlHarga = Harga, @KdKondisi = Kondisi FROM fn_Kartu108_BrgE1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)

	BEGIN TRANSACTION
	INSERT INTO Ta_KIBER (IDPemda, Kd_Id, Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		--Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
		Kd_Ruang, Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Judul, Pencipta, 
		Bahan, Ukuran, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan,
		Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, 
		Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, 
		Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Kd_Alasan, Log_User, Log_entry)
	SELECT A.IDPemda, @KdID, 3 AS Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		--A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
		A.Kd_Ruang, A.Kd_Pemilik, @Tgl_Dokumen, @No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Judul, A.Pencipta, 
		A.Bahan, A.Ukuran, A.Asal_usul, B.Kondisi, B.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan,
		A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, 
		@Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @KdReg,
		A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, 105, A.Log_User, A.Log_entry
	FROM Ta_KIB_E A INNER JOIN
		(SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Max(Kondisi) AS Kondisi, MAX(Harga) AS Harga
		FROM fn_Kartu108_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)
		GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
			AND A.No_Reg8 = B.No_Register
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg
	COMMIT

	BEGIN TRANSACTION
	UPDATE Ta_KIB_E
	SET Kd_Prov = @Kd_Prov1,
            Kd_Kab_Kota = @Kd_Kab_Kota1,
            Kd_Bidang = @Kd_Bidang1,
            Kd_Unit = @Kd_Unit1,
            Kd_Sub = @Kd_Sub1,
            Kd_UPB = @Kd_UPB1,
			No_Reg8 = @KdReg,
			Tgl_Pembukuan = @Tgl_Dokumen,
            Harga = @JmlHarga,
			Kondisi = @KdKondisi,
			Kd_Data = 6
        WHERE IDPemda = @KdIDPemda
	COMMIT
END

IF @Kd_KIB = 'F'
BEGIN
    IF @Aset1 = '1'
    BEGIN
	SELECT @KdIDPemda = IDPemda
	FROM Ta_KIB_A
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	SELECT @KdID = ISNULL(MAX(Kd_ID),0)+1 FROM Ta_KIBAR WHERE IDPemda = @KdIDPemda

	SELECT @KdReg = ISNULL(MAX(A.No_Register),0) FROM
	( 
		SELECT ISNULL(MAX(No_Reg8),0)+1 AS No_Register
        	FROM Ta_KIB_A
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
		UNION ALL
		SELECT ISNULL(MAX(No_Register),0)+1 AS No_Register
        	FROM Ta_KIBAR
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
	) A

	SELECT @JmlHarga = Harga FROM fn_Kartu108_BrgA1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)

	BEGIN TRANSACTION
	INSERT INTO Ta_KIBAR (IDPemda, Kd_Riwayat, Kd_Id, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
			--Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
			Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Luas_M2, Alamat, 
			Hak_Tanah, Sertifikat_Tanggal, Sertifikat_Nomor, Penggunaan,
			Asal_usul, Harga, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, 
			Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, 
			Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_Alasan, Log_User, Log_entry)
	SELECT IDPemda, 3 AS Kd_Riwayat, @KdID, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		--Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8,
		Kd_Pemilik, @Tgl_Dokumen, @No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Luas_M2, Alamat, 
		Hak_Tanah, Sertifikat_Tanggal, Sertifikat_Nomor, Penggunaan,
		Asal_usul, Harga, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa,
		@Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @KdReg,
		Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, 105, Log_User, Log_entry
	FROM Ta_KIB_A
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	UPDATE Ta_KIB_A
	SET Kd_Prov = @Kd_Prov1,
            Kd_Kab_Kota = @Kd_Kab_Kota1,
            Kd_Bidang = @Kd_Bidang1,
            Kd_Unit = @Kd_Unit1,
            Kd_Sub = @Kd_Sub1,
            Kd_UPB = @Kd_UPB1,
			No_Reg8 = @KdReg,
			Tgl_Pembukuan = @Tgl_Dokumen,
			Harga = @JmlHarga,
			Kd_Data = 6
        WHERE IDPemda = @KdIDPemda
	COMMIT
    END

    IF @Aset1 = '2'
    BEGIN
	SELECT @KdIDPemda = IDPemda
	FROM Ta_KIB_B
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	SELECT @KdID = ISNULL(MAX(Kd_ID),0)+1 FROM Ta_KIBBR WHERE IDPemda = @KdIDPemda

	SELECT @KdReg = ISNULL(MAX(A.No_Register),0) FROM
	( 
		SELECT ISNULL(MAX(No_Reg8),0)+1 AS No_Register
        	FROM Ta_KIB_B
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
		UNION ALL
		SELECT ISNULL(MAX(No_Register),0)+1 AS No_Register
        	FROM Ta_KIBBR
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
	) A

	SELECT @JmlHarga = Harga, @KdKondisi = Kondisi FROM fn_Kartu108_BrgB1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)

	BEGIN TRANSACTION
	INSERT INTO Ta_KIBBR (IDPemda, Kd_Id, Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
		Kd_Ruang, Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, 
		Merk, Type, CC, Bahan, Nomor_Pabrik, Nomor_Rangka, Nomor_Mesin, Nomor_Polisi, Nomor_BPKB,
		Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa,
		Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, 
		Kd_Penyusutan, Kd_Data, Invent, No_SKGuna, Kd_KA, Kd_Alasan, Log_User, Log_entry)
	SELECT IDPemda, @KdID, 3 AS Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8, 
		Kd_Ruang, Kd_Pemilik, @Tgl_Dokumen, @No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, 
		Merk, Type, CC, Bahan, Nomor_Pabrik, Nomor_Rangka, Nomor_Mesin, Nomor_Polisi, Nomor_BPKB, 
		Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_Id, Kd_Kecamatan, Kd_Desa, 
		@Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @KdReg,
		Kd_Penyusutan, Kd_Data, Invent, No_SKGuna, Kd_KA, 105, Log_User, Log_entry
	FROM Ta_KIB_B
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	UPDATE Ta_KIB_B
	SET Kd_Prov = @Kd_Prov1,
            Kd_Kab_Kota = @Kd_Kab_Kota1,
            Kd_Bidang = @Kd_Bidang1,
            Kd_Unit = @Kd_Unit1,
            Kd_Sub = @Kd_Sub1,
            Kd_UPB = @Kd_UPB1,
			No_Reg8 = @KdReg,
			Tgl_Pembukuan = @Tgl_Dokumen,
			Harga = @JmlHarga,
			Kondisi = @KdKondisi,
			Kd_Data = 6
	WHERE IDPemda = @KdIDPemda
	COMMIT
    END

    IF @Aset1 = '3'
    BEGIN
	SELECT @KdIDPemda = IDPemda
	FROM Ta_KIB_C
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	     AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	SELECT @KdID = ISNULL(MAX(Kd_ID),0)+1 FROM Ta_KIBCR WHERE IDPemda = @KdIDPemda

	SELECT @KdReg = ISNULL(MAX(A.No_Register),0) FROM
	( 
		SELECT ISNULL(MAX(No_Register),0)+1 AS No_Register
        	FROM Ta_KIB_C
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
		UNION ALL
		SELECT ISNULL(MAX(No_Register),0)+1 AS No_Register
        	FROM Ta_KIBCR
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
	) A

	SELECT @JmlHarga = Harga, @KdKondisi = Kondisi FROM fn_Kartu108_BrgC1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)

	BEGIN TRANSACTION
	INSERT INTO Ta_KIBCR (IDPemda, Kd_Id, Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
		Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Bertingkat_Tidak, Beton_tidak, 
		Luas_Lantai, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, Kd_Tanah1,
		Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, 
		Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa,
		Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, 
		Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Kd_Alasan, Log_User, Log_entry)
	SELECT IDPemda, @KdID, 3 AS Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8, 
		Kd_Pemilik, @Tgl_Dokumen, @No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Bertingkat_Tidak, Beton_tidak, 
		Luas_Lantai, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, Kd_Tanah1,
		Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, 
		Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, 
		@Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @KdReg,
		Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, 105, Log_User, Log_entry
	FROM Ta_KIB_C
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	UPDATE Ta_KIB_C
	SET Kd_Prov = @Kd_Prov1,
            Kd_Kab_Kota = @Kd_Kab_Kota1,
            Kd_Bidang = @Kd_Bidang1,
            Kd_Unit = @Kd_Unit1,
            Kd_Sub = @Kd_Sub1,
            Kd_UPB = @Kd_UPB1,
			No_Reg8 = @KdReg,
			Tgl_Pembukuan = @Tgl_Dokumen,
			Harga = @JmlHarga,
			Kondisi = @KdKondisi,
			Kd_Data = 6
        WHERE IDPemda = @KdIDPemda
	COMMIT
    END

    IF @Aset1 = '4'
    BEGIN
	SELECT @KdIDPemda = IDPemda
	FROM Ta_KIB_D
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	SELECT @KdID = ISNULL(MAX(Kd_ID),0)+1 FROM Ta_KIBDR WHERE IDPemda = @KdIDPemda

	SELECT @KdReg = ISNULL(MAX(A.No_Register),0) FROM
	( 
		SELECT ISNULL(MAX(No_Reg8),0)+1 AS No_Register
        	FROM Ta_KIB_D
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
		UNION ALL
		SELECT ISNULL(MAX(No_Register),0)+1 AS No_Register
        	FROM Ta_KIBDR
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
	) A

	SELECT @JmlHarga = Harga, @KdKondisi = Kondisi FROM fn_Kartu108_BrgD1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)

	BEGIN TRANSACTION
	INSERT INTO Ta_KIBDR (IDPemda, Kd_Id, Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
		Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Konstruksi, Panjang, Lebar, Luas, Lokasi, 
		Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, 
		Kd_Tanah1, Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, 
		Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa,
		Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, 
		Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Kd_Alasan, Log_User, Log_entry)
	SELECT IDPemda, @KdID, 3 AS Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8,
		Kd_Pemilik, @Tgl_Dokumen, @No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Konstruksi, Panjang, Lebar, Luas, Lokasi, 
		Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, 
		Kd_Tanah1, Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, 
		Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, 
		@Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @KdReg,
		Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, 105, Log_User, Log_entry
	FROM Ta_KIB_D
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	UPDATE Ta_KIB_D
	SET Kd_Prov = @Kd_Prov1,
            Kd_Kab_Kota = @Kd_Kab_Kota1,
            Kd_Bidang = @Kd_Bidang1,
            Kd_Unit = @Kd_Unit1,
            Kd_Sub = @Kd_Sub1,
            Kd_UPB = @Kd_UPB1,
			No_Reg8 = @KdReg,
			Tgl_Pembukuan = @Tgl_Dokumen,
			Harga = @JmlHarga,
			Kondisi = @KdKondisi,
			Kd_Data = 6
        WHERE IDPemda = @KdIDPemda
	COMMIT
    END

    IF @Aset1 = '5'
    BEGIN
	SELECT @KdIDPemda = IDPemda
	FROM Ta_KIB_E
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	SELECT @KdID = ISNULL(MAX(Kd_ID),0)+1 FROM Ta_KIBER WHERE IDPemda = @KdIDPemda

	SELECT @KdReg = ISNULL(MAX(A.No_Register),0) FROM
	( 
		SELECT ISNULL(MAX(No_Register),0)+1 AS No_Register
        	FROM Ta_KIB_E
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
		UNION ALL
		SELECT ISNULL(MAX(No_Register),0)+1 AS No_Register
        	FROM Ta_KIBER
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
	) A

	SELECT @JmlHarga = Harga, @KdKondisi = Kondisi FROM fn_Kartu108_BrgE1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)

	BEGIN TRANSACTION
	INSERT INTO Ta_KIBER (IDPemda, Kd_Id, Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
		Kd_Ruang, Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Judul, Pencipta, 
		Bahan, Ukuran, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan,
		Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, 
		Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, 
		Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Kd_Alasan, Log_User, Log_entry)
	SELECT IDPemda, @KdID, 3 AS Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8,
		Kd_Ruang, Kd_Pemilik, @Tgl_Dokumen, @No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Judul, Pencipta, 
		Bahan, Ukuran, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan,
		Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, 
		@Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @KdReg,
		Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, 105, Log_User, Log_entry
	FROM Ta_KIB_E
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	UPDATE Ta_KIB_E
	SET Kd_Prov = @Kd_Prov1,
            Kd_Kab_Kota = @Kd_Kab_Kota1,
            Kd_Bidang = @Kd_Bidang1,
            Kd_Unit = @Kd_Unit1,
            Kd_Sub = @Kd_Sub1,
            Kd_UPB = @Kd_UPB1,
	    No_Register = @KdReg,
	    Tgl_Pembukuan = @Tgl_Dokumen,
	    Harga = @JmlHarga,
	    Kondisi = @KdKondisi,
	    Kd_Data = 6
        WHERE IDPemda = @KdIDPemda
	COMMIT
    END
END

IF @Kd_KIB = 'L'
BEGIN
	SELECT @KdIDPemda = IDPemda
	FROM Ta_Lainnya
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg

	SELECT @KdID = ISNULL(MAX(Kd_ID),0)+1 FROM Ta_KILER WHERE IDPemda = @KdIDPemda
	
	SELECT @KdReg = ISNULL(MAX(A.No_Register),0) FROM
	( 
		SELECT ISNULL(MAX(No_Register),0)+1 AS No_Register
        	FROM Ta_Lainnya
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
		UNION ALL
		SELECT ISNULL(MAX(No_Register),0)+1 AS No_Register
        	FROM Ta_KILER
        	WHERE Kd_Prov = @Kd_Prov1 AND Kd_Kab_Kota = @Kd_Kab_Kota1 AND Kd_Bidang = @Kd_Bidang1
        	AND Kd_Unit = @Kd_Unit1 AND Kd_Sub = @Kd_Sub1 AND Kd_UPB = @Kd_UPB1
        	AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5
	) A

	SELECT @JmlHarga = Harga, @KdKondisi = Kondisi FROM fn_Kartu108_BrgL1(@Tahun, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset, @Aset0, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)

	BEGIN TRANSACTION
	INSERT INTO Ta_KILER (IDPemda, Kd_Id, Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
		Kd_Ruang, Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Judul, Pencipta, 
		Bahan, Ukuran, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan,
		Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, 
		Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, 
		Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Kd_Alasan, Log_User, Log_entry)
	SELECT A.IDPemda, @KdID, 3 AS Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8,
		A.Kd_Ruang, A.Kd_Pemilik, @Tgl_Dokumen, @No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Judul, A.Pencipta, 
		A.Bahan, A.Ukuran, A.Asal_usul, B.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan,
		A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, 
		@Kd_Prov1, @Kd_Kab_Kota1, @Kd_Bidang1, @Kd_Unit1, @Kd_Sub1, @Kd_UPB1, @KdReg,
		A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, 105, A.Log_User, A.Log_entry
	FROM Ta_Lainnya A INNER JOIN
		(SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Max(Kondisi) AS Kondisi 
		FROM fn_Kartu_BrgL(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Aset1, @Aset2, @Aset3, @Aset4, @Aset5, @Reg, @JLap)
		GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5
			AND A.No_Register = B.No_Register
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
	      AND Kd_Aset8 = @Aset AND Kd_Aset80 = @Aset0 AND Kd_Aset81 = @Aset1 AND Kd_Aset82 = @Aset2 AND Kd_Aset83 = @Aset3 AND Kd_Aset84 = @Aset4 AND Kd_Aset85 = @Aset5 AND No_Reg8 = @Reg
	COMMIT

	BEGIN TRANSACTION
	UPDATE Ta_Lainnya
	SET Kd_Prov = @Kd_Prov1,
            Kd_Kab_Kota = @Kd_Kab_Kota1,
            Kd_Bidang = @Kd_Bidang1,
            Kd_Unit = @Kd_Unit1,
            Kd_Sub = @Kd_Sub1,
            Kd_UPB = @Kd_UPB1,
			No_Reg8 = @KdReg,
			Tgl_Pembukuan = @Tgl_Dokumen,
            Harga = @JmlHarga,
			Kondisi = @KdKondisi,
			Kd_Data = 6
        WHERE IDPemda = @KdIDPemda
	COMMIT
END





GO
