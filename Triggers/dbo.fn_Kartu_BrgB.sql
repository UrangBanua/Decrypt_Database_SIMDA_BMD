﻿USE bmd_hst2020
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION dbo.fn_Kartu_BrgB (@D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4),
	                           @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(5), @JLap Tinyint)

RETURNS @UpdateKIB TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint,  Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int,  
		                 Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, Kd_Ruang int, Kd_Pemilik tinyint, Harga Money, Masa_Manfaat Smallint,  Nilai_Sisa Money, Tgl_Dokumen Datetime,
			             No_Dokumen Varchar(100), Tgl_Perolehan Datetime, Tgl_Pembukuan Datetime, Merk Varchar(50), Type Varchar(50), CC Varchar(50), Bahan Varchar(50), Nomor_Pabrik Varchar(50), Nomor_Rangka Varchar(50), Nomor_Mesin Varchar(50), Nomor_Polisi Varchar(10),
			             Nomor_BPKB Varchar(50), Asal_usul Varchar(50), Kondisi Varchar(2) , Keterangan Varchar(255), Tahun Varchar(4), Kd_KA tinyint)

WITH ENCRYPTION
AS
BEGIN
/*
DECLARE @Tahun varchar(4), @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	    @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4), @JLap Tinyint

SET @D2 = '20171231'
SET @Kd_Prov = '31'
SET @Kd_Kab_Kota = '2'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset1 = '2'
SET @Kd_Aset2 = '6'
SET @Kd_Aset3 = '2'
SET @Kd_Aset4 = '1'
SET @Kd_Aset5 = '30'
SET @No_Register = '14'
SET @JLap = 1
--*/
    IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	IF ISNULL (@Kd_Aset1,'') = '' SET @Kd_Aset1 = '%'
	IF ISNULL (@Kd_Aset2,'') = '' SET @Kd_Aset2 = '%'
	IF ISNULL (@Kd_Aset3,'') = '' SET @Kd_Aset3 = '%'
	IF ISNULL (@Kd_Aset4,'') = '' SET @Kd_Aset4 = '%'
	IF ISNULL (@Kd_Aset5,'') = '' SET @Kd_Aset5 = '%'
	IF ISNULL (@No_Register,'') = '' SET @No_Register = '%'

    DECLARE @no_urut  TABLE(IDPemda varchar(17),Kd_Id Int)
    DECLARE @tgl_awl  TABLE(IDPemda varchar(17),tgl_awl datetime)
    DECLARE @kondisi  TABLE(IDPemda varchar(17),Kondisi Varchar(2))
    DECLARE @tmpHarga TABLE(IDPemda varchar(17),Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, Harga money, Masa_Manfaat smallint, Nilai_Sisa money, Kd_Data tinyint, Kd_KA tinyint)
    DECLARE @UbahData TABLE(IDPemda varchar(17),Kd_Prov tinyint, Kd_Kab_Kota tinyint,  Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int,  Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, 
				            Kd_Ruang int,Kd_Pemilik tinyint,Merk Varchar(50),Type Varchar(50),CC Varchar(50),Bahan Varchar(50), Tgl_Dokumen Datetime, No_Dokumen Varchar(100),  Tgl_Perolehan Datetime , Tgl_Pembukuan Datetime, Nomor_Pabrik Varchar(50), Nomor_Rangka Varchar(50), Nomor_Mesin Varchar(50), Nomor_Polisi Varchar(10), 
            			    	    Nomor_BPKB Varchar(50),Asal_usul Varchar(50),Kondisi Varchar(2),Keterangan Varchar(255),Tahun Varchar(4))

    INSERT INTO @tgl_awl
    SELECT A.IDPemda,CASE WHEN B.tgl_awl IS NULL THEN A.tgl_awl ELSE B.tgl_awl END AS tgl_awl 
    FROM 
        (SELECT	IDPemda,MIN(Tgl_Perolehan) AS tgl_awl FROM	Ta_KIB_B 
	     WHERE	Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		        Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
		        AND Kd_Data <> 3 AND Kd_Hapus  <> 1
	     GROUP BY IDPemda
	     UNION ALL
	     SELECT	IDPemda,MIN(Tgl_Perolehan) FROM Ta_KIBBHapus 
	     WHERE	Tgl_SK > @D2 AND Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		        Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
	     GROUP BY IDPemda
	     UNION ALL
	     SELECT	IDPemda,MIN(Tgl_Perolehan) FROM	Ta_KIBBR  
	     WHERE	Tgl_Dokumen <= @D2 AND Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		        Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register AND
                	Kd_Riwayat = 3 AND Kd_Data <> 3
	     GROUP BY IDPemda
	    ) A LEFT OUTER JOIN 
	           (SELECT IDPemda,MAX(Tgl_Dokumen) AS tgl_awl FROM Ta_KIBBR 
	            WHERE Tgl_Dokumen <= @D2 AND Kd_Riwayat = 3 AND Kd_Data <> 3 AND Kd_Prov1 = @Kd_Prov AND Kd_Kab_Kota1 = @Kd_Kab_Kota AND Kd_Bidang1 LIKE @Kd_Bidang AND Kd_Unit1 LIKE @Kd_Unit AND Kd_Sub1 LIKE @Kd_Sub AND Kd_UPB1 LIKE @Kd_UPB AND
		              Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
                GROUP BY IDPemda 
	           ) B ON A.IDPemda = B.IDPemda 

  	INSERT INTO @no_urut
  	SELECT A.IDPemda,A.Kd_Id
 	FROM
        (SELECT A.IDPemda, MAX(A.Kd_Id) AS Kd_Id 
         FROM Ta_KIBBR A INNER JOIN @tgl_awl B ON A.IDPemda = B.IDPemda
         WHERE A.Tgl_Dokumen BETWEEN B.tgl_awl AND @D2 AND A.Kd_Riwayat IN(1,18,22) AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		       A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register
         GROUP BY A.IDPemda
		) A 


	INSERT INTO @Kondisi
	SELECT A.IDPemda, MAX (A.Kondisi) AS KONDISI
	FROM
	(
	 SELECT A.IDPemda, A.Tgl_Pembukuan AS Tgl_Dokumen, A.Kondisi
	 FROM TA_KIB_B A
	 UNION ALL
	 SELECT A.IDPemda, A.Tgl_Dokumen, A.Kondisi
	 FROM Ta_KIBBR A INNER JOIN TA_KIB_B B ON A.IDPEMDA = B.IDPEMDA
	 WHERE A.Kd_Riwayat = 1 
	 UNION ALL
	 SELECT A.IDPemda, A.Tgl_Dokumen, A.Kondisi
	 FROM Ta_KIBBR A INNER JOIN TA_KIB_B B ON A.IDPEMDA = B.IDPEMDA
	 WHERE A.Kd_riwayat <> 1 
	 UNION ALL
	 SELECT A.IDPemda, A.Tgl_SK AS Tgl_Dokumen, A.Kondisi
	 FROM Ta_KIBBHapus A INNER JOIN TA_KIB_B B ON A.IDPEMDA = B.IDPEMDA
	) A
	WHERE A.TGL_DOKUMEN <= @D2 
	GROUP BY A.IDPemda

	
	---data yg blm penghapusan
	INSERT INTO @tmpHarga
	SELECT	IDPemda,Kd_Prov,Kd_Kab_Kota,Kd_Bidang,Kd_Unit,Kd_Sub,Kd_UPB,Kd_Aset1,Kd_Aset2,Kd_Aset3,Kd_Aset4,Kd_Aset5,No_Register,  
	        ISNULL(SUM(Harga),0) AS Harga,ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat,ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa,Kd_Data,Kd_KA
	FROM	Ta_KIB_B 
	WHERE	Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		    Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
		    AND Kd_Data <> 3 AND Kd_Hapus  <> 1
	GROUP BY IDPemda,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Data, Kd_KA
	

	INSERT INTO @tmpHarga
	SELECT	IDPemda,Kd_Prov,Kd_Kab_Kota,Kd_Bidang,Kd_Unit,Kd_Sub,Kd_UPB,Kd_Aset1,Kd_Aset2,Kd_Aset3,Kd_Aset4,Kd_Aset5,No_Register,
	        ISNULL(SUM(Harga),0) AS Harga,ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat,ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, 0 AS Kd_Data, Kd_KA
	FROM	Ta_KIBBHapus 
	WHERE	Tgl_SK > @D2 AND Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		    Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
	GROUP BY IDPemda,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_KA

	--data pindah skpd
    	INSERT INTO @tmpHarga
	SELECT	A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,
	        A.Kd_Aset5,A.No_Register,ISNULL(SUM(A.Harga),0) AS Harga,ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat,ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa,
	        A.Kd_Data,A.Kd_KA
	FROM	Ta_KIBBR A INNER JOIN 
                          (SELECT IDPemda, MIN(Kd_Id) AS Kd_Id
                           FROM Ta_KIBBR 
                           WHERE Tgl_Dokumen > @D2 AND Tgl_Pembukuan <= @D2 AND Kd_Riwayat = 3 AND Kd_Data <> 3 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		                         Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
                           GROUP BY IDPemda
                          ) B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id 
	WHERE	A.Tgl_Dokumen > @D2 AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		    A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND
            A.Kd_Riwayat = 3 AND A.Kd_Data <> 3
	GROUP BY A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,
	         A.No_Register,A.Kd_Data,A.Kd_KA

    INSERT INTO @tmpHarga
    SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,
	       A.Kd_Aset5,A.No_Register,
	       CASE WHEN A.Kd_Riwayat = 7 THEN ISNULL(SUM(-A.Harga),0) ELSE ISNULL(SUM(A.Harga),0) END AS Harga,
	       ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat,ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa,A.Kd_Data, 0 AS Kd_KA
	FROM	Ta_KIBBR A --INNER JOIN @tgl_awl B ON A.IDPemda = B.IDPemda
	WHERE A.Tgl_Dokumen <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
	      A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND 
              A.Kd_Riwayat IN (2,7,21) AND A.Kd_Data <> 3
	GROUP BY A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Riwayat,A.Kd_Aset1,A.Kd_Aset2,
	         A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register,A.Kd_Data,A.Kd_KA
    
	INSERT INTO @UbahData
	SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,
	       A.Kd_Aset5,A.No_Register,A.Kd_Ruang,A.Kd_Pemilik,A.Merk,A.Type,A.CC,A.Bahan,A.Tgl_Perolehan AS Tgl_Dokumen,'Data KIB' AS No_Dokumen,
	       A.Tgl_Perolehan,A.Tgl_Pembukuan,A.Nomor_Pabrik,A.Nomor_Rangka,A.Nomor_Mesin,A.Nomor_Polisi,A.Nomor_BPKB,A.Asal_usul,A.Kondisi, 
               CASE WHEN @JLap = 1 THEN '' ELSE A.Keterangan END AS Keterangan, A.Tahun
	FROM Ta_KIB_B A LEFT OUTER JOIN @no_urut B ON A.IDPemda = B.IDPemda 
		--LEFT OUTER JOIN @Kondisi C ON A.IDPemda = C.IDPemda
  	WHERE  B.IDPemda IS NULL AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND 
	       A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND 
	       A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND 
	       A.Kd_Hapus <> 1

	--PERBAIKAN ASET YG DIUBAH KONDISI DAN HAPUS ---> Ambil kondisi awal 
	INSERT INTO @UbahData
	SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4, 
	       A.Kd_Aset5, A.No_Register, A.Kd_Ruang,A.Kd_Pemilik,A.Merk,A.Type,A.CC,A.Bahan,A.Tgl_sk, A.NO_SK AS No_Dokumen,
	       A.Tgl_Perolehan,A.Tgl_Pembukuan,A.Nomor_Pabrik,A.Nomor_Rangka,A.Nomor_Mesin,A.Nomor_Polisi,A.Nomor_BPKB,A.Asal_usul,C.Kondisi, 
           	CASE WHEN @JLap = 1 THEN '' ELSE A.Keterangan END AS Keterangan, A.Tahun
	FROM Ta_KIBBHapus A LEFT OUTER JOIN TA_KIB_B B ON A.IDPemda = B.IDPemda 
		LEFT OUTER JOIN @Kondisi C ON A.IDPemda = C.IDPemda
	WHERE A.Tgl_SK > @D2 AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		  A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register
	

	INSERT INTO @UbahData
	SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,
	       A.Kd_Aset5,A.No_Register,A.Kd_Ruang,A.Kd_Pemilik,A.Merk,A.Type,A.CC,A.Bahan,A.Tgl_Perolehan AS Tgl_Dokumen, 'Data KIB' AS No_Dokumen,
	       A.Tgl_Perolehan,A.Tgl_Pembukuan,A.Nomor_Pabrik,A.Nomor_Rangka,A.Nomor_Mesin,A.Nomor_Polisi,A.Nomor_BPKB,A.Asal_usul,A.Kondisi, 
           	CASE WHEN @JLap = 1 THEN '' ELSE A.Keterangan END AS Keterangan, A.Tahun
	FROM Ta_KIBBR A LEFT OUTER JOIN @no_urut B ON A.IDPemda = B.IDPemda 
		--LEFT OUTER JOIN @Kondisi C ON A.IDPemda = C.IDPemda
	WHERE B.IDPemda IS NULL AND A.Tgl_dokumen > @D2 AND A.Kd_Riwayat = 3 AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		  A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register

	INSERT INTO @UbahData
	SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4, 
	       A.Kd_Aset5,A.No_Register,A.Kd_Ruang,A.Kd_Pemilik,A.Merk,A.Type,A.CC,A.Bahan,A.Tgl_Dokumen,A.No_Dokumen,A.Tgl_Perolehan,
	       A.Tgl_Pembukuan,A.Nomor_Pabrik,A.Nomor_Rangka,A.Nomor_Mesin,A.Nomor_Polisi,A.Nomor_BPKB,A.Asal_usul,A.Kondisi, 
           CASE WHEN @JLap = 1 THEN '' ELSE A.Keterangan END AS Keterangan, 
           A.Tahun
	FROM Ta_KIBBR A INNER JOIN @no_urut B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id
		--LEFT OUTER JOIN @Kondisi C ON A.IDPemda = C.IDPemda
	WHERE A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
	      A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register

    INSERT INTO @UpdateKIB
    SELECT A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5, 
	       A.No_Register,B.Kd_Ruang,B.Kd_Pemilik,A.Harga,A.Masa_Manfaat,A.Nilai_Sisa,B.Tgl_Dokumen,B.No_Dokumen,B.Tgl_Perolehan,
	       B.Tgl_Pembukuan,B.Merk,B.Type,B.CC,B.Bahan,B.Nomor_Pabrik,B.Nomor_Rangka,B.Nomor_Mesin,B.Nomor_Polisi,B.Nomor_BPKB, 
	       B.Asal_usul,B.Kondisi,B.Keterangan,B.Tahun,A.Kd_KA
    FROM (
		  SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4, 
		         A.Kd_Aset5,A.No_Register,ISNULL(SUM(A.Harga),0) AS Harga,ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, 
		         MAX(Kd_KA) AS Kd_KA
	      FROM @tmpHarga A 
	      GROUP BY A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,
	               A.Kd_Aset5,A.No_Register
	     ) A INNER JOIN
	    (
	     SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,
	            A.Kd_Aset5,A.No_Register,A.Kd_Ruang,A.Kd_Pemilik,A.Merk,A.Type,A.CC,A.Bahan,A.Tgl_Dokumen,A.No_Dokumen,A.Tgl_Perolehan,
	            A.Tgl_Pembukuan,A.Nomor_Pabrik,A.Nomor_Rangka,A.Nomor_Mesin,A.Nomor_Polisi,A.Nomor_BPKB,A.Asal_usul,A.Kondisi,A.Keterangan,A.Tahun
	     FROM @UbahData A 
	    )B ON A.IDPemda = B.IDPemda AND A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
	          A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
	          A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register 

	RETURN  END


GO
