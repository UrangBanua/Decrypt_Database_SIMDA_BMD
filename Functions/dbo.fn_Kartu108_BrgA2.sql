USE bmd_hst2020
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_Kartu108_BrgA2 (@D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4),
	                           @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(5), @JLap Tinyint)

RETURNS @UpdateKIB TABLE(IDPemda varchar(17),Kd_Prov tinyint,Kd_Kab_Kota tinyint,Kd_Bidang tinyint,Kd_Unit smallint,Kd_Sub smallint,Kd_UPB int,
		                 Kd_Aset tinyint,Kd_Aset0 tinyint,Kd_Aset1 tinyint,Kd_Aset2 tinyint,Kd_Aset3 tinyint,Kd_Aset4 tinyint,Kd_Aset5 int,No_Register int,
		                 Harga Money,Luas_M2 Float(8),Tgl_Dok DateTime,No_Dok Varchar(50),Kd_Pemilik tinyint,Tgl_Perolehan datetime, 
		                 Tgl_Pembukuan datetime,Alamat Varchar(255),Hak_Tanah Varchar(25),Sertifikat_Tanggal DateTime,Sertifikat_Nomor Varchar(50),
		                 Penggunaan Varchar(50),Asal_usul Varchar(50),Keterangan Varchar(255),Kd_KA Tinyint)

WITH ENCRYPTION
AS
BEGIN  
/*

DECLARE @Tahun varchar(4), @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	    @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4), @JLap Tinyint

SET @D2 = '20191231'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @Kd_UPB = ''
SET @Kd_Aset  = '%'
SET @Kd_Aset0 = '%'
SET @Kd_Aset1 = '%'
SET @Kd_Aset2 = '%'
SET @Kd_Aset3 = '%'
SET @Kd_Aset4 = '%'
SET @Kd_Aset5 = '%'
SET @No_Register = '%'
SET @JLap = 1

-- */
    	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	IF ISNULL (@Kd_Aset,'') = '' SET @Kd_Aset = '%'
	IF ISNULL (@Kd_Aset0,'') = '' SET @Kd_Aset0 = '%'
	IF ISNULL (@Kd_Aset1,'') = '' SET @Kd_Aset1 = '%'
	IF ISNULL (@Kd_Aset2,'') = '' SET @Kd_Aset2 = '%'
	IF ISNULL (@Kd_Aset3,'') = '' SET @Kd_Aset3 = '%'
	IF ISNULL (@Kd_Aset4,'') = '' SET @Kd_Aset4 = '%'
	IF ISNULL (@Kd_Aset5,'') = '' SET @Kd_Aset5 = '%'
	IF ISNULL (@No_Register,'') = '' SET @No_Register = '%'


   	INSERT INTO @UpdateKIB
    	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
		A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		A.Harga, A.Luas_M2, A.Tgl_Dok, A.No_Dok, A.Kd_Pemilik, A.Tgl_Perolehan,
		A.Tgl_Pembukuan, A.Alamat, A.Hak_Tanah, A.Sertifikat_Tanggal, A.Sertifikat_Nomor,
		A.Penggunaan, A.Asal_usul, A.Keterangan, A.Kd_KA
    		FROM fn_Kartu108_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'1','3','1','%','%','%','%','%',@JLap)  A
		-- WHERE (A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 1) 

   	INSERT INTO @UpdateKIB
    	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	       	A.No_Register, A.Harga, NULL AS Luas_M2, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen AS No_Dok, A.Kd_Pemilik, A.Tgl_Perolehan,
		A.Tgl_Pembukuan, NULL AS Alamat, NULL AS Hak_Tanah, NULL AS Sertifikat_Tanggal, NULL AS Sertifikat_Nomor,				
		NULL AS Penggunaan, A.Asal_usul, A.Keterangan, A.Kd_KA
    		FROM fn_Kartu108_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'1','3','1','%','%','%','%','%',@JLap)  A
		-- WHERE (A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 1) 

   	INSERT INTO @UpdateKIB
    	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	       	A.No_Register, A.Harga, NULL AS Luas_M2, A.Dokumen_Tanggal AS Tgl_Dok, A.Dokumen_Nomor AS No_Dok, A.Kd_Pemilik, A.Tgl_Perolehan,
		A.Tgl_Pembukuan, NULL AS Alamat, NULL AS Hak_Tanah, NULL AS Sertifikat_Tanggal, NULL AS Sertifikat_Nomor,
		NULL AS Penggunaan, A.Asal_usul, A.Keterangan, A.Kd_KA
    		FROM fn_Kartu108_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'1','3','1','%','%','%','%','%',@JLap)  A
		-- WHERE (A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 1) 

   	INSERT INTO @UpdateKIB
    	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
		A.No_Register, A.Harga, NULL AS Luas_M2, A.Dokumen_Tanggal AS Tgl_Dok, A.Dokumen_Nomor AS No_Dok, A.Kd_Pemilik, A.Tgl_Perolehan,
		A.Tgl_Pembukuan, NULL AS Alamat, NULL AS Hak_Tanah, NULL AS Sertifikat_Tanggal, NULL AS Sertifikat_Nomor,
		NULL AS Penggunaan, A.Asal_usul, A.Keterangan, A.Kd_KA
    		FROM fn_Kartu108_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'1','3','1','%','%','%','%','%',@JLap)  A
		-- WHERE (A.Kd_Aset = 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 1) 


	RETURN  END









GO
