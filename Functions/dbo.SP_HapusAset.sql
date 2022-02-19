USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_HapusAset - 11112015 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_HapusAset @No_SK varchar(50), @Tgl_SK datetime, @Alasan varchar(1), @KIB varchar(2), @IDUser varchar(20)
WITH ENCRYPTION
AS

/*
DECLARE @No_SK varchar(50), @Tgl_SK datetime, @Alasan varchar(1), @KIB varchar(1), @IDUser varchar(20)
SET @No_SK = '1'
SET @Tgl_SK = '20150826'
SET @KIB = 'F'
SEt @Alasan = '1'
SET @IDUser = 'admin'
*/

IF @KIB = 'A' 
BEGIN
	INSERT INTO Ta_KIBAHAPUS (IDPemda,No_SK, Tgl_SK, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
		Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Luas_M2, Alamat, Hak_Tanah, Sertifikat_Tanggal, Sertifikat_Nomor, Penggunaan, Asal_usul,
		Harga, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, Kd_Alasan, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_entry)

	SELECT A.IDPemda, @No_SK, @Tgl_SK, 
		A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register,
		A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Luas_M2, A.Alamat, A.Hak_Tanah, A.Sertifikat_Tanggal, A.Sertifikat_Nomor, A.Penggunaan, A.Asal_usul,
		A.Harga, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, A.Invent, @Alasan, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, @IDUser, GetDate()
	FROM Ta_KIB_A A INNER JOIN
		Ta_KIB_Hps B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Hapus = 1 AND B.IDUser = @IDUser

	UPDATE Ta_KIB_A 
	SET Kd_Hapus= 1	
	FROM Ta_KIB_A A INNER JOIN 
		Ta_KIB_Hps B ON A.IDPemda = B.IDPemda 
	WHERE B.Kd_Hapus = 1 AND B.IDUser = @IDUser

	DELETE Ta_KIB_Hps WHERE IDUser = @IDUser
END 	

IF @KIB = 'B' 
BEGIN
	INSERT INTO Ta_KIBBHAPUS (IDPemda, No_SK, Tgl_SK, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
				Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register, 
				Kd_Ruang, Kd_Pemilik, Merk, Type, CC, Bahan, Tgl_Perolehan, Tgl_Pembukuan, Nomor_Pabrik, Nomor_Rangka, Nomor_Mesin, Nomor_Polisi, Nomor_BPKB,
				Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, Kd_Alasan,
				No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_entry)	
	SELECT A.IDPemda, @No_SK, @Tgl_SK, 
		A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register, 
		A.Kd_Ruang, A.Kd_Pemilik, A.Merk, A.Type, A.CC, A.Bahan, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, A.Nomor_BPKB,
		A.Asal_usul, B.Kondisi, 
		A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, A.Invent, @Alasan,
		A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, @IDUser, GetDate()	FROM Ta_KIB_B A INNER JOIN 
		Ta_KIB_Hps B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Hapus = 1 AND B.IDUser = @IDUser

	UPDATE Ta_KIB_B
	SET Kd_Hapus= 1
	FROM Ta_KIB_B A INNER JOIN 
		Ta_KIB_Hps B ON A.IDPemda = B.IDPemda 
	WHERE B.Kd_Hapus = 1 AND B.IDUser = @IDUser
	
	DELETE Ta_KIB_Hps WHERE IDUser = @IDUser
END 	

IF @KIB = 'C' 
BEGIN
	INSERT INTO Ta_KIBCHAPUS (IDPemda, No_SK, Tgl_SK, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
				Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register, 
				Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Bertingkat_Tidak, Beton_tidak, Luas_Lantai, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah,
				Kd_Tanah1, Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan,
				Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, Kd_Alasan, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_entry)
	SELECT A.IDPemda, @No_SK, @Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register, 
		A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Bertingkat_Tidak, A.Beton_tidak, A.Luas_Lantai, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah,
		A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_usul, B.Kondisi, 
		A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan,
		A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, A.Invent, @Alasan, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, @IDUser, GetDate()
	FROM Ta_KIB_C A INNER JOIN 
		Ta_KIB_Hps B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Hapus = 1 AND B.IDUser = @IDUser

	UPDATE Ta_KIB_C
	SET Kd_Hapus= 1
	FROM Ta_KIB_C A INNER JOIN 
		Ta_KIB_Hps B ON A.IDPemda = B.IDPemda 
	WHERE B.Kd_Hapus = 1 AND B.IDUser = @IDUser

	DELETE Ta_KIB_Hps WHERE IDUser = @IDUser
END

IF @KIB = 'D' 
BEGIN
	INSERT INTO Ta_KIBDHAPUS (IDPemda, No_SK, Tgl_SK, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
				Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
				Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Konstruksi, Panjang, Lebar, Luas, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah,
				Kd_Tanah1, Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan,
				Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, Kd_Alasan, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_entry)
	SELECT A.IDPemda, @No_SK, @Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register,
		A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Konstruksi, A.Panjang, A.Lebar, A.Luas, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah,
		A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_usul, B.Kondisi, 
		A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan,
		A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, A.Invent, @Alasan, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, @IDUser, GetDate()
	FROM Ta_KIB_D A INNER JOIN 
		Ta_KIB_Hps B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Hapus = 1 AND B.IDUser = @IDUser

	UPDATE Ta_KIB_D
	SET Kd_Hapus= 1
	FROM Ta_KIB_D A INNER JOIN 
		Ta_KIB_Hps B ON A.IDPemda = B.IDPemda 
	WHERE B.Kd_Hapus = 1 AND B.IDUser = @IDUser

	DELETE Ta_KIB_Hps WHERE IDUser = @IDUser
END

IF @KIB = 'E' 
BEGIN
	INSERT INTO Ta_KIBEHAPUS (IDPemda, No_SK, Tgl_SK, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
				Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
				Kd_Ruang, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Judul, Pencipta, Bahan, Ukuran, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa,
				Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, Kd_Alasan, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_entry)
	SELECT A.IDPemda, @No_SK, @Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register,
		A.Kd_Ruang, A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, B.Kondisi, 
		A.Harga, A.Masa_Manfaat, A.Nilai_Sisa,
		A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, A.Invent, @Alasan, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, @IDUser, GetDate()
	FROM Ta_KIB_E A INNER JOIN 
		Ta_KIB_Hps B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Hapus = 1 AND B.IDUser = @IDUser

	UPDATE Ta_KIB_E
	SET Kd_Hapus= 1
	FROM Ta_KIB_E A INNER JOIN 
		Ta_KIB_Hps B ON A.IDPemda = B.IDPemda 
	WHERE B.Kd_Hapus = 1 AND B.IDUser = @IDUser

	DELETE Ta_KIB_Hps WHERE IDUser = @IDUser
END

IF @KIB = 'L' 
BEGIN
	INSERT INTO Ta_LainnyaHapus (IDPemda, No_SK, Tgl_SK, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register, 
		Kd_Ruang, Kd_Pemilik, Tgl_Perolehan, Judul, Pencipta, Bahan, Ukuran, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, 
		No_ID, Tgl_Pembukuan, Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Umur, Dev_Id, Log_User, Log_entry)
	SELECT A.IDPemda, @No_SK, @Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register, 
		A.Kd_Ruang, A.Kd_Pemilik, A.Tgl_Perolehan, A.Judul, A.Pencipta, A.Bahan, A.Ukuran, A.Asal_usul, B.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, 
		A.No_ID, A.Tgl_Pembukuan, A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, A.Umur, A.Dev_Id, @IDUser, GetDate()
	FROM Ta_Lainnya A INNER JOIN 
		Ta_KIB_Hps B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Hapus = 1 AND B.IDUser = @IDUser

	UPDATE Ta_Lainnya
	SET Kd_Hapus= 1
	FROM Ta_Lainnya A INNER JOIN 
		Ta_KIB_Hps B ON A.IDPemda = B.IDPemda 
	WHERE B.Kd_Hapus = 1 AND B.IDUser = @IDUser

	DELETE Ta_KIB_Hps WHERE IDUser = @IDUser
END


IF @KIB = 'F' /*Sebagian A*/
BEGIN
	INSERT INTO Ta_KIBAR (IDPemda, Kd_ID, Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
        	Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
			Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Luas_M2, Alamat, 
        	Hak_Tanah, Sertifikat_Tanggal, Sertifikat_Nomor, Penggunaan,
			Asal_usul, Harga, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, 
        	Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1,
			No_Register1, Kd_Penyusutan, Invent, No_SKGuna, Kd_Alasan, Kd_KA, Log_User, Log_entry)
	SELECT A.IDPemda, IsNull(B.Kd_ID,1) AS Kd_ID, 7 AS Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register, 
		A.Kd_Pemilik, @Tgl_SK, @No_SK, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Luas_M2, A.Alamat, 
		A.Hak_Tanah, A.Sertifikat_Tanggal, A.Sertifikat_Nomor, A.Penggunaan, 
		A.Asal_usul, A.Harga, A.Keterangan, A.Tahun, A.No_SP2D, A.No_Id, A.Kd_Kecamatan, A.Kd_Desa, 
		A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
		A.No_Register, A.Kd_Penyusutan, A.Invent, A.No_SKGuna, @Alasan, A.Kd_KA, @IDUser, GetDate()
	FROM Ta_KIB_A A LEFT OUTER JOIN 
		(SELECT IDPemda, ISNULL(MAX(Kd_Id),0)+1 AS Kd_ID FROM Ta_KIBAR GROUP BY IDPemda) B ON A.IDPemda = B.IDPemda INNER JOIN
		Ta_KIB_Hps C ON A.IDPemda = C.IDPemda
	WHERE C.Kd_Hapus = 1 AND C.IDUser = @IDUser

	DELETE Ta_KIB_Hps WHERE IDUser = @IDUser
END 	

IF @KIB = 'G' /*Sebagian B*/
BEGIN
	INSERT INTO Ta_KIBBR (IDPemda, Kd_ID, Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
		Kd_Ruang, Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Merk, Type, 
		CC, Bahan, Nomor_Pabrik, Nomor_Rangka, Nomor_Mesin, Nomor_Polisi, Nomor_BPKB,
		Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, A.Kd_Desa,
		Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, 
		Kd_Penyusutan, Kd_Data, Invent, No_SKGuna, Kd_Alasan, Kd_KA, Log_User, Log_entry)
	SELECT A.IDPemda, IsNull(B.Kd_ID,1) AS Kd_ID, 7 AS Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register, 
		A.Kd_Ruang, A.Kd_Pemilik, @Tgl_SK, @No_SK, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Merk, A.Type, 
		A.CC, A.Bahan, A.Nomor_Pabrik, A.Nomor_Rangka, A.Nomor_Mesin, A.Nomor_Polisi, A.Nomor_BPKB, 
		A.Asal_usul, C.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa, 
		A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.No_Register,
		A.Kd_Penyusutan, A.Kd_Data, A.Invent, A.No_SKGuna, @Alasan, A.Kd_KA , @IDUser, GetDate()
	FROM Ta_KIB_B A LEFT OUTER JOIN 
		(SELECT IDPemda, ISNULL(MAX(Kd_Id),0)+1 AS Kd_ID FROM Ta_KIBBR GROUP BY IDPemda) B ON A.IDPemda = B.IDPemda INNER JOIN
		Ta_KIB_Hps C ON A.IDPemda = C.IDPemda
	WHERE C.Kd_Hapus = 1 AND C.IDUser = @IDUser

	DELETE Ta_KIB_Hps WHERE IDUser = @IDUser
END 	

IF @KIB = 'H' /*Sebagian C*/
BEGIN
	INSERT INTO Ta_KIBCR (IDPemda, Kd_ID, Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
		Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Bertingkat_Tidak, Beton_tidak, 
		Luas_Lantai, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah,
		Kd_Tanah1, Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, 
		Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, 
		Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, 
		Kd_Penyusutan, Kd_Data, Invent, No_SKGuna, Kd_Alasan, Kd_KA, Log_User, Log_entry)
	SELECT A.IDPemda, IsNull(B.Kd_ID,1) AS Kd_ID, 7 AS Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register,		 
		A.Kd_Pemilik, @Tgl_SK, @No_SK, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Bertingkat_Tidak, A.Beton_tidak, 
		A.Luas_Lantai, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah, 
		A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_usul, C.Kondisi, A.Harga, 
		A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa,
		A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.No_Register, 
		A.Kd_Penyusutan, A.Kd_Data, A.Invent, A.No_SKGuna, @Alasan, A.Kd_KA, @IDUser, GetDate()
	FROM Ta_KIB_C A LEFT OUTER JOIN 
		(SELECT IDPemda, ISNULL(MAX(Kd_Id),0)+1 AS Kd_ID FROM Ta_KIBCR GROUP BY IDPemda) B ON A.IDPemda = B.IDPemda INNER JOIN
		Ta_KIB_Hps C ON A.IDPemda = C.IDPemda
	WHERE C.Kd_Hapus = 1 AND C.IDUser = @IDUser

	DELETE Ta_KIB_Hps WHERE IDUser = @IDUser
END

IF @KIB = 'I' /*Sebagian D*/
BEGIN
	INSERT INTO Ta_KIBDR (IDPemda, Kd_ID, Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
		Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Konstruksi, Panjang, Lebar, 
		Luas, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, Status_Tanah, 
		Kd_Tanah1, Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, Asal_usul, Kondisi, Harga, 
		Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, 
		Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, 
		Kd_Penyusutan, Kd_Data, Invent, No_SKGuna, Kd_Alasan, Kd_KA, Log_User, Log_entry)
	SELECT A.IDPemda, IsNull(B.Kd_ID,1) AS Kd_ID, 7 AS Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register,		
		A.Kd_Pemilik, @Tgl_SK, @No_SK, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Konstruksi, A.Panjang, A.Lebar, 
		A.Luas, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah, 
		A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_usul, C.Kondisi, A.Harga, 
		A.Masa_Manfaat, A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa,
		A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.No_Register,
		A.Kd_Penyusutan, A.Kd_Data, A.Invent, A.No_SKGuna, @Alasan, A.Kd_KA, @IDUser, GetDate()
	FROM Ta_KIB_D A LEFT OUTER JOIN 
		(SELECT IDPemda, ISNULL(MAX(Kd_Id),0)+1 AS Kd_ID FROM Ta_KIBDR GROUP BY IDPemda) B ON A.IDPemda = B.IDPemda INNER JOIN
		Ta_KIB_Hps C ON A.IDPemda = C.IDPemda
	WHERE C.Kd_Hapus = 1 AND C.IDUser = @IDUser

	DELETE Ta_KIB_Hps WHERE IDUser = @IDUser
END

IF @KIB = 'J' /*Sebagian E*/
BEGIN
	INSERT INTO Ta_KIBER (IDPemda, Kd_ID, Kd_Riwayat, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register,
		Kd_Ruang, Kd_Pemilik, Tgl_Dokumen, No_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, Judul, Pencipta, 
		Bahan, Ukuran, Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa,
		Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, 
		Kd_Prov1, Kd_Kab_Kota1, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_UPB1, No_Register1, 
		Kd_Penyusutan, Kd_Data, Invent, No_SKGuna, Kd_Alasan, Kd_KA, Log_User, Log_entry)
	SELECT	A.IDPemda, IsNull(B.Kd_ID,1) AS Kd_ID, 7 AS Kd_Riwayat, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register, 
		A.Kd_Ruang, A.Kd_Pemilik, @Tgl_SK, @No_SK, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Judul, A.Pencipta, 
		A.Bahan, A.Ukuran, A.Asal_usul, C.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, 
		A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, A.Kd_Kecamatan, A.Kd_Desa,
		A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.No_Register,
		A.Kd_Penyusutan, A.Kd_Data, A.Invent, A.No_SKGuna, @Alasan, A.Kd_KA, @IDUser, GetDate()
	FROM Ta_KIB_E A LEFT OUTER JOIN 
		(SELECT IDPemda, ISNULL(MAX(Kd_Id),0)+1 AS Kd_ID FROM Ta_KIBER GROUP BY IDPemda) B ON A.IDPemda = B.IDPemda INNER JOIN
		Ta_KIB_Hps C ON A.IDPemda = C.IDPemda
	WHERE C.Kd_Hapus = 1 AND C.IDUser = @IDUser

	DELETE Ta_KIB_Hps WHERE IDUser = @IDUser
END







GO
