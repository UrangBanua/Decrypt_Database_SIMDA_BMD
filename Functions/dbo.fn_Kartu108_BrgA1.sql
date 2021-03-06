USE bmd_hst2020
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO

/*** fn_Kartu108_BrgA1 - 11052020 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE FUNCTION dbo.fn_Kartu108_BrgA1 (@Tahun varchar(4),@D2 Datetime,@Kd_Prov varchar(3),@Kd_Kab_Kota varchar(3),@Kd_Bidang varchar(3),@Kd_Unit varchar(3), 
                               @Kd_Sub varchar(3),@Kd_UPB varchar(4),@Kd_Aset varchar(3),@Kd_Aset0 varchar(3),@Kd_Aset1 varchar(3),@Kd_Aset2 varchar(3),@Kd_Aset3 varchar(3), 
                               @Kd_Aset4 varchar(3),@Kd_Aset5 varchar(3),@No_Register varchar(5),@JLap Tinyint)

RETURNS @UpdateKIB TABLE(Tahun varchar(4),IDPemda varchar(17),Kd_Prov tinyint,Kd_Kab_Kota tinyint,Kd_Bidang tinyint,Kd_Unit smallint,Kd_Sub smallint,Kd_UPB int,
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

SET @Tahun = '2018'
SET @D2 = '20181231'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '4'
SET @Kd_Unit = '6'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset  = ''
SET @Kd_Aset0 = ''
SET @Kd_Aset1 = ''
SET @Kd_Aset2 = ''
SET @Kd_Aset3 = ''
SET @Kd_Aset4 = ''
SET @Kd_Aset5 = ''
SET @No_Register = ''
SET @JLap = 1
--*/

    	IF ISNULL (@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL (@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL (@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL (@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	IF ISNULL (@Kd_Aset,'') = '' SET @Kd_Aset = '%'
	IF ISNULL (@Kd_Aset0,'') = '' SET @Kd_Aset0 = '%'
	IF ISNULL (@Kd_Aset1,'') = '' SET @Kd_Aset1 = '%'
	IF ISNULL (@Kd_Aset2,'') = '' SET @Kd_Aset2 = '%'
	IF ISNULL (@Kd_Aset3,'') = '' SET @Kd_Aset3 = '%'
	IF ISNULL (@Kd_Aset4,'') = '' SET @Kd_Aset4 = '%'
	IF ISNULL (@Kd_Aset5,'') = '' SET @Kd_Aset5 = '%'
	IF ISNULL (@No_Register,'') = '' SET @No_Register = '%'



    INSERT INTO @UpdateKIB
    SELECT A.Tahun, A.IDPemda, A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,
		--   A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,
	       CASE WHEN B.KD_RIWAYAT IN (9,10,11,12,13) THEN 1 ELSE A.Kd_Aset END AS Kd_Aset, 
               CASE WHEN B.KD_RIWAYAT IN (9,10,11,12,13) THEN 5 ELSE A.Kd_Aset0 END AS Kd_Aset0, 
               CASE WHEN B.KD_RIWAYAT IN (10,11,12,13) THEN 2 ELSE A.Kd_Aset1 END AS Kd_Aset1, 
               CASE WHEN B.KD_RIWAYAT IN (9,10,11,12,13) THEN 1 ELSE A.Kd_Aset2 END AS Kd_Aset2, 
               CASE WHEN B.KD_RIWAYAT IN (9,10,11,12,13) THEN 1 ELSE A.Kd_Aset3 END AS Kd_Aset3,
               CASE WHEN B.KD_RIWAYAT = 10 THEN 1 WHEN B.KD_RIWAYAT IN (9) THEN 5 WHEN B.KD_RIWAYAT IN (11) THEN 2 
		    WHEN B.KD_RIWAYAT IN (12,13) THEN 3 ELSE A.Kd_Aset4 END AS Kd_Aset4,
               CASE WHEN B.KD_RIWAYAT IN (9,10,11,12,13) THEN 1 ELSE A.Kd_Aset5 END AS Kd_Aset5,
		   A.No_Register, 
		   A.Harga,A.Luas_M2,A.Tgl_Dok,A.No_Dok,A.Kd_Pemilik,A.Tgl_Perolehan,
		   A.Tgl_Pembukuan,A.Alamat,A.Hak_Tanah,A.Sertifikat_Tanggal,A.Sertifikat_Nomor,
		   A.Penggunaan,A.Asal_usul, '' AS Keterangan,A.Kd_KA
    FROM Ta_Fn_KIB_A A LEFT OUTER JOIN
	       (SELECT IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register, Kd_Riwayat
                FROM Ta_KIBAR 
                WHERE Kd_Riwayat IN(9,10,11,12,13) AND Tgl_Dokumen <= @D2
                GROUP BY IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Register, Kd_Riwayat
               ) B ON A.IDPemda = B.IDPemda AND 
		      A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
                      A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset = B.Kd_Aset8 AND A.Kd_Aset0 = B.Kd_Aset80 AND A.Kd_Aset1 = B.Kd_Aset81 AND 
                      A.Kd_Aset2 = B.Kd_Aset82 AND A.Kd_Aset3 = B.Kd_Aset83 AND A.Kd_Aset4 = B.Kd_Aset84 AND A.Kd_Aset5 = B.Kd_Aset85 AND 
                      A.No_Register = B.No_Register
	WHERE A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
	      A.Kd_Aset LIKE @Kd_Aset AND A.Kd_Aset0 LIKE @Kd_Aset0 AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register
	     

  RETURN END





GO
