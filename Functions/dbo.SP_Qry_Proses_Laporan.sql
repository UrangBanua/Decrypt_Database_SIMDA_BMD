USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/***
Deskripsi Store Procedure :
Nama		: SP_Qry_Proses_Laporan
Form		: F_LaporanAkhir
Keterangan	: Di gunakan di Form F_Up_Rekening untuk cari rekening
Dibuat		: 29/04/2019 23:29:00
Oleh		: HRY
***/

CREATE PROCEDURE [dbo].[SP_Qry_Proses_Laporan] @Kd_KIB varchar(1), @KdTahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), @D2 Datetime
WITH ENCRYPTION
AS
/*
DECLARE @Kd_KIB varchar(1), @KdTahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), @D2 Datetime
SET @Kd_KIB      = 'A' 
SET @KdTahun     = '2018'
SET @Kd_Prov     = '99' 
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang   = '1'
SET @Kd_Unit     = '1'
SET @Kd_Sub      = '1'
SET @Kd_UPB      = '1'
SET @D2          = GetDate()
*/

	DECLARE @JLap Tinyint SET @JLap = 0

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

IF @Kd_KIB = 'A'
BEGIN
	EXEC [dbo].[SP_Qry_Proses_Laporan_Del] @Kd_KIB, @KdTahun, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB
	
	WAITFOR DELAY '00:00:5'
	
	BEGIN TRANSACTION
	DELETE Ta_Fn_KIB_A WHERE Tahun = @KdTahun
	AND Kd_Prov LIKE @Kd_Prov AND Kd_Kab_Kota LIKE @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit 
	AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB
	COMMIT
	
	WAITFOR DELAY '00:00:5'
	
	BEGIN TRANSACTION
	INSERT INTO Ta_Fn_KIB_A (Tahun, IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
	Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Harga, 
	Luas_M2, Tgl_Dok, No_Dok, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Alamat,
	Hak_Tanah, Sertifikat_Tanggal, Sertifikat_Nomor, Penggunaan, Asal_usul, Kd_KA, 
	Tgl_D2, Tgl_Proses)
	SELECT @KdTahun, A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
	A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Harga, 
	A.Luas_M2, A.Tgl_Dok, SubString(A.No_Dok,1,50) AS No_Dok, A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Alamat,  
	A.Hak_Tanah, A.Sertifikat_Tanggal, A.Sertifikat_Nomor, A.Penggunaan, A.Asal_usul, A.Kd_KA,
	@D2, GetDate()
	FROM fn_Kartu108_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap) A
	COMMIT
END	

IF @Kd_KIB = 'B'
BEGIN
	EXEC [dbo].[SP_Qry_Proses_Laporan_Del] @Kd_KIB, @KdTahun, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB
	
	WAITFOR DELAY '00:00:5'
	
	BEGIN TRANSACTION
	DELETE Ta_Fn_KIB_B WHERE Tahun = @KdTahun
	AND Kd_Prov LIKE @Kd_Prov AND Kd_Kab_Kota LIKE @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit 
	AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB
	COMMIT
	
	WAITFOR DELAY '00:00:5'
	
	BEGIN TRANSACTION
	INSERT INTO Ta_Fn_KIB_B (Tahun, IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
	Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Ruang, Kd_Pemilik, Harga, 
	Masa_Manfaat, Nilai_Sisa, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Merk, [Type], CC, Bahan, 
	Nomor_Pabrik, Nomor_Rangka, Nomor_Mesin, Nomor_Polisi, Nomor_BPKB, Asal_usul, Kondisi,  
	Tahun1, Kd_KA, Tgl_D2, Tgl_Proses)
	SELECT @KdTahun, A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota,  A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  
	A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, A.Kd_Pemilik, A.Harga, 
	A.Masa_Manfaat,  A.Nilai_Sisa, A.Tgl_Dokumen, SubString(A.No_Dokumen,1,50) AS No_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Merk, A.[Type], A.CC, A.Bahan, 
	A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, A.Nomor_BPKB, A.Asal_usul, A.Kondisi,  
	A.Tahun, A.Kd_KA, @D2, GetDate()
	FROM fn_Kartu108_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap) A
	COMMIT
END

IF @Kd_KIB = 'C'
BEGIN
	EXEC [dbo].[SP_Qry_Proses_Laporan_Del] @Kd_KIB, @KdTahun, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB
	
	WAITFOR DELAY '00:00:5'
	
	BEGIN TRANSACTION
	DELETE Ta_Fn_KIB_C WHERE Tahun = @KdTahun
	AND Kd_Prov LIKE @Kd_Prov AND Kd_Kab_Kota LIKE @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit 
	AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB
	COMMIT 
	
	WAITFOR DELAY '00:00:5'
	
	BEGIN TRANSACTION
	INSERT INTO Ta_Fn_KIB_C(Tahun, IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
	Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik, 
	Tgl_Perolehan, Tgl_Pembukuan, Bertingkat_Tidak, Beton_tidak, Luas_Lantai, Dokumen_Tanggal, Dokumen_Nomor, 
	Status_Tanah, Kd_Tanah1, Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Lokasi,
	Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Kd_KA, Tgl_D2, Tgl_Proses)	
	SELECT @KdTahun, A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  
	A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, 
	A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Bertingkat_Tidak, A.Beton_tidak, A.Luas_Lantai, A.Dokumen_Tanggal, SubString(A.Dokumen_Nomor,1,50) AS Dokumen_Nomor, 
	A.Status_Tanah, A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Lokasi,
	A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Kd_KA, @D2, GetDate()
	FROM fn_Kartu108_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap) A	
	COMMIT	 
END

IF @Kd_KIB = 'D'
BEGIN
	EXEC [dbo].[SP_Qry_Proses_Laporan_Del] @Kd_KIB, @KdTahun, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB
	
	WAITFOR DELAY '00:00:5'
	
	BEGIN TRANSACTION
	DELETE Ta_Fn_KIB_D WHERE Tahun = @KdTahun
	AND Kd_Prov LIKE @Kd_Prov AND Kd_Kab_Kota LIKE @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit 
	AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB
	COMMIT
		
	WAITFOR DELAY '00:00:5'
	
	BEGIN TRANSACTION
	INSERT INTO Ta_Fn_KIB_D(Tahun, IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
	Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, 
	Konstruksi, Panjang, Lebar, Luas, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, Lokasi,
	Kd_Tanah1, Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, Masa_Manfaat, 
	Nilai_Sisa, Kd_KA, Tgl_D2, Tgl_Proses)
	SELECT @KdTahun, A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
	A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
	A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Konstruksi, A.Panjang,
	A.Lebar, A.Luas, A.Dokumen_Tanggal, SubString(A.Dokumen_Nomor,1,50) AS Dokumen_Nomor, A.Status_Tanah, A.Lokasi,
	A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_usul,
	A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Kd_KA, @D2, GetDate()	
	FROM fn_Kartu108_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap) A
	COMMIT
END

IF @Kd_KIB = 'E'
BEGIN
	EXEC [dbo].[SP_Qry_Proses_Laporan_Del] @Kd_KIB, @KdTahun, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB
	
	WAITFOR DELAY '00:00:5'
	
	BEGIN TRANSACTION
	DELETE Ta_Fn_KIB_E WHERE Tahun = @KdTahun
	AND Kd_Prov LIKE @Kd_Prov AND Kd_Kab_Kota LIKE @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit 
	AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB
	COMMIT
	
	WAITFOR DELAY '00:00:5'
	
	BEGIN TRANSACTION
	INSERT INTO Ta_Fn_KIB_E (Tahun, IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
	Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Ruang, Kd_Pemilik, 
	Tgl_Perolehan, Tgl_Pembukuan, Tgl_Dokumen, Bahan, Ukuran, Asal_usul, Kondisi, Harga, 
	Masa_Manfaat, Nilai_Sisa, Kd_KA, Tgl_D2, Tgl_Proses)
	SELECT @KdTahun, IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
	A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
	A.Kd_Ruang, A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Tgl_Dokumen,
	A.Bahan, A.Ukuran,
	Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Kd_KA, @D2, GetDate()
	FROM fn_Kartu108_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap) A
	COMMIT
END

IF @Kd_KIB = 'F'
BEGIN
	EXEC [dbo].[SP_Qry_Proses_Laporan_Del] @Kd_KIB, @KdTahun, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB
	
	WAITFOR DELAY '00:00:5'
	
	BEGIN TRANSACTION
	DELETE Ta_Fn_KIB_F WHERE Tahun = @KdTahun
	AND Kd_Prov LIKE @Kd_Prov AND Kd_Kab_Kota LIKE @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit 
	AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB
	COMMIT
	
	WAITFOR DELAY '00:00:5'
	
	BEGIN TRANSACTION
	INSERT INTO Ta_Fn_KIB_F(Tahun, IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
	Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, 
	Bertingkat_Tidak, Beton_Tidak, Luas_Lantai, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, 
	Kd_Tanah1, Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_Usul, Kondisi, Harga, 
	Kd_KA, Tgl_D2, Tgl_Proses)
	SELECT @KdTahun, IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
 	A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, 
 	A.Bertingkat_Tidak, A.Beton_Tidak, A.Luas_Lantai, A.Lokasi, A.Dokumen_Tanggal, SubString(A.Dokumen_Nomor,1,50) AS Dokumen_Nomor, A.Status_Tanah, 
 	A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_Usul, A.Kondisi, A.Harga, 
 	A.Kd_KA, @D2, GetDate()
	FROM fn_Kartu108_BrgF(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap) A
	COMMIT
END

IF @Kd_KIB = 'L'
BEGIN
	EXEC [dbo].[SP_Qry_Proses_Laporan_Del] @Kd_KIB, @KdTahun, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB
	
	WAITFOR DELAY '00:00:5'
	
	BEGIN TRANSACTION
	DELETE Ta_Fn_KIB_L WHERE Tahun = @KdTahun	
	AND Kd_Prov LIKE @Kd_Prov AND Kd_Kab_Kota LIKE @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit 
	AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB
	COMMIT
	
	WAITFOR DELAY '00:00:5'
	
	BEGIN TRANSACTION
	INSERT INTO Ta_Fn_KIB_L(Tahun, IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
	Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Ruang, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, 
	Tgl_Dokumen, Bahan, Ukuran, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, 
	Kd_KA, Tgl_D2, Tgl_Proses)
	SELECT @KdTahun, IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
	Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Ruang, A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, 
	A.Tgl_Dokumen, A.Bahan, A.Ukuran, A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, 
	A.Kd_KA, @D2, GetDate()
	FROM fn_Kartu108_BrgL(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap) A
	COMMIT
END
GO
