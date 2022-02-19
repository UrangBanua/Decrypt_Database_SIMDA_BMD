USE bmd_hst2020
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_Kartu108_BrgA (@D2 Datetime,@Kd_Prov varchar(3),@Kd_Kab_Kota varchar(3),@Kd_Bidang varchar(3),@Kd_Unit varchar(3), 
                               @Kd_Sub varchar(3),@Kd_UPB varchar(4),@Kd_Aset varchar(3),@Kd_Aset0 varchar(3),@Kd_Aset1 varchar(3),@Kd_Aset2 varchar(3),@Kd_Aset3 varchar(3), 
                               @Kd_Aset4 varchar(3),@Kd_Aset5 varchar(3),@No_Register varchar(5),@JLap Tinyint)

RETURNS @UpdateKIB TABLE(IDPemda varchar(17),Kd_Prov tinyint,Kd_Kab_Kota tinyint,Kd_Bidang tinyint,Kd_Unit smallint,Kd_Sub smallint,Kd_UPB int,
		                 Kd_Aset tinyint,Kd_Aset0 tinyint,Kd_Aset1 tinyint,Kd_Aset2 tinyint,Kd_Aset3 tinyint,Kd_Aset4 tinyint,Kd_Aset5 int,No_Register int,
		                 Harga Money,Luas_M2 Float(8),Tgl_Dok DateTime,No_Dok Varchar(100),Kd_Pemilik tinyint,Tgl_Perolehan datetime, 
		                 Tgl_Pembukuan datetime,Alamat Varchar(255),Hak_Tanah Varchar(25),Sertifikat_Tanggal DateTime,Sertifikat_Nomor Varchar(50),
		                 Penggunaan Varchar(50),Asal_usul Varchar(50),Keterangan Varchar(255),Kd_KA Tinyint)


WITH ENCRYPTION
AS
BEGIN
/*
DECLARE @Tahun varchar(4), @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	    @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4), @JLap Tinyint

SET @D2 = '20191231'
SET @Kd_Prov = '3'
SET @Kd_Kab_Kota = '19'
SET @Kd_Bidang = '5'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset  = '1'
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

    DECLARE @no_urut  TABLE(IDPemda varchar(17),Kd_Id Int, Tgl_Dokumen Datetime, No_Dokumen Varchar(100))
    DECLARE @tgl_awl  TABLE(IDPemda varchar(17),tgl_awl datetime)
    DECLARE @tmpHarga TABLE(IDPemda varchar(17),Kd_Prov tinyint,Kd_Kab_Kota tinyint,Kd_Bidang tinyint,Kd_Unit smallint,Kd_Sub smallint,
                            Kd_UPB int, Tgl_Dok datetime,No_Dok Varchar(100),Kd_Aset tinyint,Kd_Aset0 tinyint,Kd_Aset1 tinyint,Kd_Aset2 tinyint,Kd_Aset3 tinyint,Kd_Aset4 tinyint,Kd_Aset5 int,
                            No_Register int,Harga money,Luas_M2 Float(8),Kd_Data tinyint,Kd_KA Tinyint)
    DECLARE @UbahData TABLE(IDPemda varchar(17),Kd_Prov tinyint,Kd_Kab_Kota tinyint,Kd_Bidang tinyint,Kd_Unit smallint,Kd_Sub smallint,
                            Kd_UPB int,Tgl_Dok datetime,No_Dok Varchar(100),Kd_Aset tinyint,Kd_Aset0 tinyint,Kd_Aset1 tinyint,Kd_Aset2 tinyint,Kd_Aset3 tinyint,
                            Kd_Aset4 tinyint,Kd_Aset5 int,No_Register int,Kd_Pemilik tinyint,Tgl_Perolehan datetime, 
                            Tgl_Pembukuan datetime,Alamat Varchar(255),Hak_Tanah Varchar(25),Sertifikat_Tanggal DateTime, 
                            Sertifikat_Nomor Varchar(50),Penggunaan Varchar(50),Asal_usul Varchar(50),Keterangan Varchar(255))



    INSERT INTO @tgl_awl
    SELECT A.IDPemda, CASE WHEN B.tgl_awl IS NULL THEN A.tgl_awl ELSE B.tgl_awl END AS tgl_awl 
    FROM 
        (SELECT	IDPemda,MIN(Tgl_Perolehan) AS tgl_awl FROM Ta_KIB_A 
	     WHERE	Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE 
@Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		        Kd_Aset8 LIKE @Kd_Aset AND Kd_Aset80 LIKE @Kd_Aset0 AND Kd_Aset81 LIKE @Kd_Aset1 AND Kd_Aset82 LIKE @Kd_Aset2 AND Kd_Aset83 LIKE @Kd_Aset3 AND Kd_Aset84 LIKE @Kd_Aset4 AND Kd_Aset85 LIKE @Kd_Aset5 AND No_Reg8 LIKE @No_Register
		        AND Kd_Data <> 3 AND Kd_Hapus  <> 1
	     GROUP BY IDPemda
	     UNION ALL
	     SELECT	IDPemda,MIN(Tgl_Perolehan) FROM Ta_KIBAHapus 
	     WHERE	Tgl_SK > @D2 AND Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		        Kd_Aset8 LIKE @Kd_Aset AND Kd_Aset80 LIKE @Kd_Aset0 AND Kd_Aset81 LIKE @Kd_Aset1 AND Kd_Aset82 LIKE @Kd_Aset2 AND Kd_Aset83 LIKE @Kd_Aset3 AND Kd_Aset84 LIKE @Kd_Aset4 AND Kd_Aset85 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
	     GROUP BY IDPemda
	     UNION ALL
	     SELECT	IDPemda,MIN(Tgl_Perolehan) FROM	Ta_KIBAR  
	     WHERE	Tgl_Dokumen > @D2 AND Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		        Kd_Aset8 LIKE @Kd_Aset AND Kd_Aset80 LIKE @Kd_Aset0 AND Kd_Aset81 LIKE @Kd_Aset1 AND Kd_Aset82 LIKE @Kd_Aset2 AND Kd_Aset83 LIKE @Kd_Aset3 AND Kd_Aset84 LIKE @Kd_Aset4 AND Kd_Aset85 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register AND
                	Kd_Riwayat = 3 AND Kd_Data <> 3
	     GROUP BY IDPemda
	    ) A LEFT OUTER JOIN 
	           (SELECT IDPemda,MAX(Tgl_Dokumen) AS tgl_awl FROM Ta_KIBAR 
	            WHERE Tgl_Dokumen <= @D2 AND Kd_Riwayat = 3 AND Kd_Data <> 3 AND Kd_Prov1 = @Kd_Prov AND Kd_Kab_Kota1 = @Kd_Kab_Kota AND Kd_Bidang1 LIKE @Kd_Bidang AND Kd_Unit1 LIKE @Kd_Unit AND Kd_Sub1 LIKE @Kd_Sub AND Kd_UPB1 LIKE @Kd_UPB AND
		    Kd_Aset8 LIKE @Kd_Aset AND Kd_Aset80 LIKE @Kd_Aset0 AND Kd_Aset81 LIKE @Kd_Aset1 AND Kd_Aset82 LIKE @Kd_Aset2 AND Kd_Aset83 LIKE @Kd_Aset3 AND Kd_Aset84 LIKE @Kd_Aset4 AND Kd_Aset85 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
                GROUP BY IDPemda 
	           ) B ON A.IDPemda = B.IDPemda 

	INSERT INTO @no_urut
  	SELECT A.IDPemda,A.Kd_Id, A.TGL_DOKUMEN, A.NO_DOKUMEN
 	FROM
        (SELECT A.IDPemda, MAX(A.Kd_Id) AS Kd_Id, Max(A.TGL_DOKUMEN) AS TGL_DOKUMEN, Max(A.NO_DOKUMEN) AS NO_DOKUMEN
         FROM Ta_KIBBR A INNER JOIN @tgl_awl B ON A.IDPemda = B.IDPemda
         WHERE A.Tgl_Dokumen BETWEEN B.tgl_awl AND @D2 AND A.Kd_Riwayat IN(1,18,22) AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		       A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register
         GROUP BY A.IDPemda--, A.TGL_DOKUMEN, A.NO_DOKUMEN
		) A 

	INSERT INTO @tmpHarga
	SELECT IDPemda,Kd_Prov,Kd_Kab_Kota,Kd_Bidang,Kd_Unit,Kd_Sub,Kd_UPB,Tgl_perolehan AS Tgl_Dok, 'Data KIB' AS No_Dok, 
		Kd_Aset8,Kd_Aset80,Kd_Aset81,Kd_Aset82,Kd_Aset83,Kd_Aset84,Kd_Aset85,No_Reg8 AS No_Register,  
		   ISNULL(SUM(Harga),0) AS Harga,ISNULL(SUM(Luas_M2),0) AS Luas_M2,Kd_Data,Kd_KA
	FROM	Ta_KIB_A 
	WHERE	Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		    Kd_Aset8 LIKE @Kd_Aset AND Kd_Aset80 LIKE @Kd_Aset0 AND Kd_Aset81 LIKE @Kd_Aset1 AND Kd_Aset82 LIKE @Kd_Aset2 AND Kd_Aset83 LIKE @Kd_Aset3 AND Kd_Aset84 LIKE @Kd_Aset4 AND Kd_Aset85 LIKE @Kd_Aset5 AND No_Reg8 LIKE @No_Register
		    AND Kd_Data <> 3 AND Kd_Hapus  <> 1
	GROUP BY IDPemda,Kd_Prov,Kd_Kab_Kota,Kd_Bidang,Kd_Unit,Kd_Sub,Kd_UPB,Tgl_perolehan, 
		 Kd_Aset8, Kd_Aset80,Kd_Aset81,Kd_Aset82,Kd_Aset83,Kd_Aset84,Kd_Aset85,No_Reg8,Kd_Data,Kd_KA

	INSERT INTO @tmpHarga
	SELECT	IDPemda,Kd_Prov,Kd_Kab_Kota,Kd_Bidang,Kd_Unit,Kd_Sub,Kd_UPB,Tgl_SK AS Tgl_Dok, No_SK AS No_Dokumen,
		Kd_Aset8,Kd_Aset80,Kd_Aset81,Kd_Aset82,Kd_Aset83,Kd_Aset84,Kd_Aset85,No_Register,  
		    ISNULL(SUM(Harga),0) AS Harga,ISNULL(SUM(Luas_M2),0) AS Luas_M2,0 AS Kd_Data,Kd_KA
	FROM	Ta_KIBAHapus 
	WHERE	Tgl_SK > @D2 AND Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		    Kd_Aset8 LIKE @Kd_Aset AND Kd_Aset80 LIKE @Kd_Aset0 AND Kd_Aset81 LIKE @Kd_Aset1 AND Kd_Aset82 LIKE @Kd_Aset2 AND Kd_Aset83 LIKE @Kd_Aset3 AND Kd_Aset84 LIKE @Kd_Aset4 AND Kd_Aset85 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
	GROUP BY IDPemda,Kd_Prov,Kd_Kab_Kota,Kd_Bidang,Kd_Unit,Kd_Sub,Kd_UPB,Tgl_SK, No_SK, 
		 Kd_Aset8,Kd_Aset80,Kd_Aset81,Kd_Aset82,Kd_Aset83,Kd_Aset84,Kd_Aset85,No_Register, Kd_KA

    INSERT INTO @tmpHarga
	SELECT	A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Tgl_Dokumen As Tgl_Dok, A.No_Dokumen As No_Dok,
		A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,
	        A.Kd_Aset85,A.No_Register,ISNULL(SUM(A.Harga),0) AS Harga,ISNULL(SUM(A.Luas_M2),0) AS Luas_M2,A.Kd_Data,A.Kd_KA
	FROM	Ta_KIBAR A INNER JOIN 
                          (SELECT IDPemda, MIN(Kd_Id) AS Kd_Id
                           FROM Ta_KIBAR 
                           WHERE Tgl_Dokumen > @D2 AND Tgl_Pembukuan <= @D2 AND Kd_Riwayat = 3 AND Kd_Data <> 3 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
				Kd_Aset8 LIKE @Kd_Aset AND Kd_Aset80 LIKE @Kd_Aset0 AND Kd_Aset81 LIKE @Kd_Aset1 AND Kd_Aset82 LIKE @Kd_Aset2 AND Kd_Aset83 LIKE @Kd_Aset3 AND Kd_Aset84 LIKE @Kd_Aset4 AND Kd_Aset85 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
                           GROUP BY IDPemda
                          ) B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id 
	WHERE	A.Tgl_Dokumen > @D2 AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		    A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND
            A.Kd_Riwayat = 3 AND A.Kd_Data <> 3
	GROUP BY A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Tgl_Dokumen, A.No_Dokumen,
		 A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85,
	         A.No_Register,A.Kd_Data,A.Kd_KA

    INSERT INTO @tmpHarga
    SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Tgl_Dokumen As Tgl_Dok, A.No_Dokumen As No_Dok,
           A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,
	       A.Kd_Aset85,A.No_Register,
	       CASE WHEN A.Kd_Riwayat = 7 THEN ISNULL(SUM(-A.Harga),0) ELSE ISNULL(SUM(A.Harga),0) END AS Harga,
	       ISNULL(SUM(A.Luas_M2),0) AS Luas_M2,A.Kd_Data,A.Kd_KA
	FROM	Ta_KIBAR A INNER JOIN @tgl_awl B ON A.IDPemda = B.IDPemda
	WHERE A.Tgl_Dokumen BETWEEN B.tgl_awl AND @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
	      A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND 
          A.Kd_Riwayat IN (2,7,21) AND A.Kd_Data <> 3
	GROUP BY A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Tgl_Dokumen, A.No_Dokumen,
		 A.Kd_Riwayat,A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,
	         A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85,A.No_Register,A.Kd_Data,A.Kd_KA
    
	INSERT INTO @UbahData
	SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,B.Tgl_Dokumen AS Tgl_Dok, B.No_Dokumen AS No_Dok, 
		--A.Tgl_Perolehan AS Tgl_Dok,'Data Awal' AS No_Dok, 
	       A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85,A.No_Reg8 AS No_Register,A.Kd_Pemilik,A.Tgl_Perolehan,A.Tgl_Pembukuan,  
           CASE WHEN @JLap = 1 THEN '' ELSE A.Alamat END AS Alamat, 
           A.Hak_Tanah,A.Sertifikat_Tanggal,A.Sertifikat_Nomor,A.Penggunaan,A.Asal_usul, 
           CASE WHEN @JLap = 1 THEN '' ELSE A.Keterangan END AS Keterangan
	FROM Ta_KIB_A A LEFT OUTER JOIN @no_urut B ON A.IDPemda = B.IDPemda 
    	WHERE  B.IDPemda IS NULL AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND 
	       A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND  
	       A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Reg8 LIKE @No_Register AND 
	       A.Kd_Hapus <> 1

	INSERT INTO @UbahData
	SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,B.Tgl_Dokumen AS Tgl_Dok, B.No_Dokumen AS No_Dok, 
		--A.Tgl_Perolehan AS Tgl_Dok,'Data Awal' AS No_Dok, 
	       A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85,A.No_Register,A.Kd_Pemilik,A.Tgl_Perolehan,A.Tgl_Pembukuan,  
           CASE WHEN @JLap = 1 THEN '' ELSE A.Alamat END AS Alamat,
           A.Hak_Tanah, A.Sertifikat_Tanggal, A.Sertifikat_Nomor, A.Penggunaan, A.Asal_usul, 
           CASE WHEN @JLap = 1 THEN '' ELSE A.Keterangan END AS Keterangan
	FROM Ta_KIBAHapus A LEFT OUTER JOIN @no_urut B ON A.IDPemda = B.IDPemda 
	WHERE B.IDPemda IS NULL AND A.Tgl_SK > @D2 AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		  A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register

	INSERT INTO @UbahData
	SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,B.Tgl_Dokumen AS Tgl_Dok, B.No_Dokumen AS No_Dok, 
		--A.Tgl_Perolehan AS Tgl_Dok,'Data Awal' AS No_Dok, 
	       A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85,A.No_Register,A.Kd_Pemilik,A.Tgl_Perolehan,A.Tgl_Pembukuan,  
           CASE WHEN @JLap = 1 THEN '' ELSE A.Alamat END AS Alamat,
           A.Hak_Tanah, A.Sertifikat_Tanggal, A.Sertifikat_Nomor, A.Penggunaan, A.Asal_usul, 
           CASE WHEN @JLap = 1 THEN '' ELSE A.Keterangan END AS Keterangan
	FROM Ta_KIBAR A LEFT OUTER JOIN @no_urut B ON A.IDPemda = B.IDPemda 
	WHERE B.IDPemda IS NULL AND A.Tgl_dokumen > @D2 AND A.Kd_Riwayat = 3 AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		  A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register

	INSERT INTO @UbahData
	SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,
		B.Tgl_Dokumen AS Tgl_Dok,B.No_Dokumen AS No_Dok,
	        A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85,A.No_Register,A.Kd_Pemilik,A.Tgl_Perolehan,A.Tgl_Pembukuan,  
           CASE WHEN @JLap = 1 THEN '' ELSE A.Alamat END AS Alamat,
           A.Hak_Tanah,A.Sertifikat_Tanggal,A.Sertifikat_Nomor,A.Penggunaan,A.Asal_usul, 
           CASE WHEN @JLap = 1 THEN '' ELSE A.Keterangan END AS Keterangan
	FROM Ta_KIBAR A INNER JOIN @no_urut B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id
	WHERE A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
	      A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register


	
   INSERT INTO @UpdateKIB
    SELECT A.IDPemda, A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,
		   A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register, 
		  A.Harga, A.Luas_M2, 

		   Case WHEN B.Tgl_Dok > A.Tgl_Dok THEN B.Tgl_Dok ELSE A.Tgl_Dok END AS Tgl_Dok,
		   Case WHEN B.Tgl_Dok > A.Tgl_Dok THEN B.No_Dok ELSE A.No_Dok END AS No_Dok,
		   B.Kd_Pemilik,B.Tgl_Perolehan,
		   B.Tgl_Pembukuan,B.Alamat,B.Hak_Tanah,B.Sertifikat_Tanggal,B.Sertifikat_Nomor,
		   B.Penggunaan,B.Asal_usul,B.Keterangan,A.Kd_KA 
    FROM (
	      SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB, MAX(A.Tgl_Dok) AS TGL_DOK, MAX(A.No_Dok) AS NO_DOK,
		     A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,
		         A.Kd_Aset4,A.Kd_Aset5,A.No_Register,SUM(A.Harga)AS Harga,SUM(A.Luas_M2) AS Luas_M2,MAX(A.Kd_KA) AS Kd_KA
	      FROM @tmpHarga A 
	      GROUP BY A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,--A.Tgl_Dok, A.No_Dok,
		       A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,
	               A.Kd_Aset5,A.No_Register
	     ) A INNER JOIN
	    (
	     SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,
	            A.Kd_Aset4,A.Kd_Aset5,A.No_Register,MAX(A.Tgl_Dok) AS TGL_DOK, MAX(A.No_Dok) AS NO_DOK,A.Kd_Pemilik,A.Tgl_Perolehan,A.Tgl_Pembukuan,A.Alamat,
	            A.Hak_Tanah,A.Sertifikat_Tanggal,A.Sertifikat_Nomor,A.Penggunaan,A.Asal_usul,A.Keterangan
	     FROM @UbahData A 
	      GROUP BY A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,--A.Tgl_Dok, A.No_Dok,
		       A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,
	               A.Kd_Aset5,A.No_Register,A.Kd_Pemilik,A.Tgl_Perolehan,A.Tgl_Pembukuan,A.Alamat,
	            A.Hak_Tanah,A.Sertifikat_Tanggal,A.Sertifikat_Nomor,A.Penggunaan,A.Asal_usul,A.Keterangan

	    )B ON A.IDPemda = B.IDPemda AND A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
	          A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset = B.Kd_Aset AND A.Kd_Aset0 = B.Kd_Aset0 AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
	          A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register 
	
	RETURN END












GO
