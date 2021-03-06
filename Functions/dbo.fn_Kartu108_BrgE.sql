USE bmd_hst2020
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_Kartu108_BrgE (@D2 Datetime,@Kd_Prov varchar(3),@Kd_Kab_Kota varchar(3),@Kd_Bidang varchar(3),@Kd_Unit varchar(3), 
                               @Kd_Sub varchar(3),@Kd_UPB varchar(4),@Kd_Aset varchar(3),@Kd_Aset0 varchar(3),@Kd_Aset1 varchar(3),@Kd_Aset2 varchar(3),@Kd_Aset3 varchar(3), 
                               @Kd_Aset4 varchar(3),@Kd_Aset5 varchar(3),@No_Register varchar(5),@JLap Tinyint)

RETURNS @UpdateKIB TABLE(IDPemda Varchar(17),Kd_Prov tinyint,Kd_Kab_Kota tinyint,Kd_Bidang tinyint,Kd_Unit smallint,Kd_Sub smallint,Kd_UPB int, 
			             Kd_Aset tinyint,Kd_Aset0 tinyint,Kd_Aset1 tinyint,Kd_Aset2 tinyint,Kd_Aset3 tinyint,Kd_Aset4 tinyint,Kd_Aset5 int,No_Register int,
			             Kd_Ruang int,Kd_Pemilik tinyint,Tgl_Perolehan Datetime ,Tgl_Pembukuan Datetime,Tgl_Dokumen Datetime,
			             No_Dokumen Varchar(100),Judul Varchar(255),Pencipta Varchar(255),Bahan Varchar(50),Ukuran Varchar(50),
			             Asal_usul Varchar(50),Kondisi Varchar(2),Harga money,Masa_Manfaat smallint,Nilai_Sisa money,Keterangan Varchar(255),Kd_KA tinyint)


WITH ENCRYPTION
AS
BEGIN
/*
DECLARE @Tahun varchar(4), @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	    @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4), @JLap Tinyint

SET @D2 = '20181231'
SET @Kd_Prov = '14'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '7'
SET @Kd_Unit = '1'
SET @Kd_Sub = ''
SET @Kd_UPB = ''
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

    DECLARE @no_urut  TABLE(IDPemda varchar(17),Kd_Id Int)
    DECLARE @tgl_awl  TABLE(IDPemda varchar(17),tgl_awl datetime)
    DECLARE @kondisi  TABLE(IDPemda varchar(17),Kondisi Varchar(2))
    DECLARE @tmpHarga TABLE(IDPemda varchar(17),Kd_Prov tinyint,Kd_Kab_Kota tinyint,Kd_Bidang tinyint,Kd_Unit smallint,Kd_Sub smallint,
                            Kd_UPB int,Kd_Aset tinyint,Kd_Aset0 tinyint,Kd_Aset1 tinyint,Kd_Aset2 tinyint,Kd_Aset3 tinyint,Kd_Aset4 tinyint,Kd_Aset5 int,
                            No_Register int,Harga money,Tgl_Dokumen Datetime, No_Dokumen Varchar(100),
			    Masa_Manfaat smallint,Nilai_Sisa money,Kd_Data tinyint,Kd_KA tinyint)
    DECLARE @UbahData TABLE(IDPemda varchar(17),Kd_Prov tinyint,Kd_Kab_Kota tinyint,Kd_Bidang tinyint,Kd_Unit smallint,Kd_Sub smallint,
                            Kd_UPB int,Kd_Aset tinyint,Kd_Aset0 tinyint,Kd_Aset1 tinyint,Kd_Aset2 tinyint,Kd_Aset3 tinyint,Kd_Aset4 tinyint,Kd_Aset5 int,
                            No_Register int,Kd_Ruang int,Kd_Pemilik tinyint,Tgl_Perolehan Datetime,Tgl_Pembukuan Datetime,Tgl_Dokumen Datetime,
                            No_Dokumen Varchar(100),Judul Varchar (255),Pencipta Varchar (255),Bahan Varchar (50),Ukuran Varchar (50),
                            Asal_usul Varchar(50),Kondisi Varchar(2),Keterangan Varchar(255))


    INSERT INTO @tgl_awl
    SELECT A.IDPemda,CASE WHEN B.tgl_awl IS NULL THEN A.tgl_awl ELSE B.tgl_awl END AS tgl_awl 
    FROM 
        (SELECT	IDPemda,MIN(Tgl_Perolehan) AS tgl_awl FROM	Ta_KIB_E 
	     WHERE	Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		        Kd_Aset8 LIKE @Kd_Aset AND Kd_Aset80 LIKE @Kd_Aset0 AND Kd_Aset81 LIKE @Kd_Aset1 AND Kd_Aset82 LIKE @Kd_Aset2 AND Kd_Aset83 LIKE @Kd_Aset3 AND Kd_Aset84 LIKE @Kd_Aset4 AND Kd_Aset85 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
		        AND Kd_Data <> 3 AND Kd_Hapus  <> 1
	     GROUP BY IDPemda
	     UNION ALL
	     SELECT	IDPemda,MIN(Tgl_Perolehan) FROM Ta_KIBEHapus 
	     WHERE	Tgl_SK > @D2 AND Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		        Kd_Aset8 LIKE @Kd_Aset AND Kd_Aset80 LIKE @Kd_Aset0 AND Kd_Aset81 LIKE @Kd_Aset1 AND Kd_Aset82 LIKE @Kd_Aset2 AND Kd_Aset83 LIKE @Kd_Aset3 AND Kd_Aset84 LIKE @Kd_Aset4 AND Kd_Aset85 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
	     GROUP BY IDPemda
	     UNION ALL
	     SELECT	IDPemda,MIN(Tgl_Perolehan) FROM	Ta_KIBER  
	     WHERE	Tgl_Dokumen > @D2 AND Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		        Kd_Aset8 LIKE @Kd_Aset AND Kd_Aset80 LIKE @Kd_Aset0 AND Kd_Aset81 LIKE @Kd_Aset1 AND Kd_Aset82 LIKE @Kd_Aset2 AND Kd_Aset83 LIKE @Kd_Aset3 AND Kd_Aset84 LIKE @Kd_Aset4 AND Kd_Aset85 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register AND
                Kd_Riwayat = 3 AND Kd_Data <> 3
	     GROUP BY IDPemda
	    ) A LEFT OUTER JOIN 
	           (SELECT IDPemda,MAX(Tgl_Dokumen) AS tgl_awl FROM Ta_KIBER 
	            WHERE Tgl_Dokumen <= @D2 AND Kd_Riwayat = 3 AND Kd_Data <> 3 AND Kd_Prov1 = @Kd_Prov AND Kd_Kab_Kota1 = @Kd_Kab_Kota AND Kd_Bidang1 LIKE @Kd_Bidang AND Kd_Unit1 LIKE @Kd_Unit AND Kd_Sub1 LIKE @Kd_Sub AND Kd_UPB1 LIKE @Kd_UPB AND
		          Kd_Aset8 LIKE @Kd_Aset AND Kd_Aset80 LIKE @Kd_Aset0 AND Kd_Aset81 LIKE @Kd_Aset1 AND Kd_Aset82 LIKE @Kd_Aset2 AND Kd_Aset83 LIKE @Kd_Aset3 AND Kd_Aset84 LIKE @Kd_Aset4 AND Kd_Aset85 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
                GROUP BY IDPemda 
	           ) B ON A.IDPemda = B.IDPemda 

    INSERT INTO @no_urut
    SELECT A.IDPemda,A.Kd_Id
    FROM
        (SELECT A.IDPemda, MAX(A.Kd_Id) AS Kd_Id 
         FROM Ta_KIBER A INNER JOIN @tgl_awl B ON A.IDPemda = B.IDPemda
         WHERE A.Tgl_Dokumen BETWEEN B.tgl_awl AND @D2 AND A.Kd_Riwayat IN(1,18,22) AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		       A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register
         GROUP BY A.IDPemda
		) A 

	

	INSERT INTO @Kondisi
	SELECT A.IDPemda, MAX (A.Kondisi) AS KONDISI
	FROM
	(
	 SELECT A.IDPemda, A.Tgl_Pembukuan AS Tgl_Dokumen, A.Kondisi
	 FROM TA_KIB_E A
	 UNION ALL
	 SELECT A.IDPemda, A.Tgl_Dokumen, A.Kondisi
	 FROM Ta_KIBER A INNER JOIN TA_KIB_E B ON A.IDPEMDA = B.IDPEMDA
	 WHERE A.Kd_Riwayat = 1 
	 UNION ALL
	 SELECT A.IDPemda, A.Tgl_Dokumen, B.Kondisi
	 FROM Ta_KIBER A INNER JOIN TA_KIB_E B ON A.IDPEMDA = B.IDPEMDA
	 WHERE A.Kd_riwayat <> 1 
	 UNION ALL
	 SELECT A.IDPemda, A.Tgl_SK AS Tgl_Dokumen, A.Kondisi
	 FROM Ta_KIBEHapus A INNER JOIN TA_KIB_E B ON A.IDPEMDA = B.IDPEMDA
	) A
	WHERE A.TGL_DOKUMEN <= @D2 
	GROUP BY A.IDPemda

	--tambahan data riwayat 33 (reklass)
	 INSERT INTO @Kondisi
	 SELECT A.IDPemda,B.Kondisi
	 FROM Ta_KIBER A INNER JOIN TA_KIB_E B ON A.IDPEMDA = B.IDPEMDA
	 WHERE A.Kd_Riwayat = 33 AND A.TGL_DOKUMEN >@D2


	INSERT INTO @tmpHarga
	SELECT	IDPemda,Kd_Prov,Kd_Kab_Kota,Kd_Bidang,Kd_Unit,Kd_Sub,Kd_UPB,Kd_Aset8,Kd_Aset80,Kd_Aset81,Kd_Aset82,Kd_Aset83,Kd_Aset84,Kd_Aset85,No_Reg8 AS No_Register,  
	        ISNULL(SUM(Harga),0) AS Harga,Tgl_Perolehan AS Tgl_Dokumen, 'DATA KIB' AS No_Dokumen,
		ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat,ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa,Kd_Data,Kd_KA
	FROM	Ta_KIB_E 
	WHERE	Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		    Kd_Aset8 LIKE @Kd_Aset AND Kd_Aset80 LIKE @Kd_Aset0 AND Kd_Aset81 LIKE @Kd_Aset1 AND Kd_Aset82 LIKE @Kd_Aset2 AND Kd_Aset83 LIKE @Kd_Aset3 AND Kd_Aset84 LIKE @Kd_Aset4 AND Kd_Aset85 LIKE @Kd_Aset5 AND No_Reg8 LIKE @No_Register
		    AND Kd_Data <> 3 AND Kd_Hapus  <> 1
		 --AND (KD_ASET1 = 5 OR KD_ASET1 IS NULL)
	GROUP BY IDPemda,Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet8, Kd_ASet80, Kd_ASet81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8, Kd_Data, Kd_KA
		, Tgl_Perolehan	

	INSERT INTO @tmpHarga
	SELECT	IDPemda,Kd_Prov,Kd_Kab_Kota,Kd_Bidang,Kd_Unit,Kd_Sub,Kd_UPB,Kd_Aset8,Kd_Aset80,Kd_Aset81,Kd_Aset82,Kd_Aset83,Kd_Aset84,Kd_Aset85,No_Register,
	        ISNULL(SUM(Harga),0) AS Harga,Tgl_SK AS Tgl_Dokumen, No_SK AS No_DOkumen,
		ISNULL(SUM(Masa_Manfaat),0) AS Masa_Manfaat,ISNULL(SUM(Nilai_Sisa),0) AS Nilai_Sisa, 0 AS Kd_Data, Kd_KA
	FROM	Ta_KIBEHapus 
	WHERE	Tgl_SK > @D2 AND Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		    Kd_Aset8 LIKE @Kd_Aset AND Kd_Aset80 LIKE @Kd_Aset0 AND Kd_Aset81 LIKE @Kd_Aset1 AND Kd_Aset82 LIKE @Kd_Aset2 AND Kd_Aset83 LIKE @Kd_Aset3 AND Kd_Aset84 LIKE @Kd_Aset4 AND Kd_Aset85 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
	GROUP BY IDPemda,Kd_Prov,Kd_Kab_Kota,Kd_Bidang,Kd_Unit,Kd_Sub,Kd_UPB,Kd_Aset8,Kd_Aset80,Kd_Aset81,Kd_Aset82,Kd_Aset83,Kd_Aset84,Kd_Aset85,No_Register,Kd_KA
		 , Tgl_SK, No_SK

    INSERT INTO @tmpHarga
	SELECT	A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,
	        A.Kd_Aset85,A.No_Register,ISNULL(SUM(A.Harga),0) AS Harga,A.Tgl_DOkumen, A.No_Dokumen,
		ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat,ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa,
	        A.Kd_Data,A.Kd_KA
	FROM	Ta_KIBER A INNER JOIN 
                          (SELECT IDPemda, MIN(Kd_Id) AS Kd_Id
                           FROM Ta_KIBER 
                           WHERE Tgl_Dokumen > @D2 AND Tgl_Pembukuan <= @D2 AND Kd_Riwayat = 3 AND Kd_Data <> 3 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
					 Kd_Aset8 LIKE @Kd_Aset AND Kd_Aset80 LIKE @Kd_Aset0 AND Kd_Aset81 LIKE @Kd_Aset1 AND Kd_Aset82 LIKE @Kd_Aset2 AND Kd_Aset83 LIKE @Kd_Aset3 AND Kd_Aset84 LIKE @Kd_Aset4 AND Kd_Aset85 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
                           GROUP BY IDPemda
                          ) B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id 
	WHERE	A.Tgl_Dokumen > @D2 AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		    A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND
            A.Kd_Riwayat = 3 AND A.Kd_Data <> 3
	GROUP BY A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85,
	         A.No_Register,A.Kd_Data,A.Kd_KA,A.Tgl_DOkumen, A.No_Dokumen

    INSERT INTO @tmpHarga
    SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,
	       A.Kd_Aset85,A.No_Register,
	       CASE WHEN A.Kd_Riwayat = 7 THEN ISNULL(SUM(-A.Harga),0) ELSE ISNULL(SUM(A.Harga),0) END AS Harga,A.Tgl_DOkumen, A.No_Dokumen,
	       ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat,ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa,A.Kd_Data, 0 AS Kd_KA
	FROM	Ta_KIBER A INNER JOIN @tgl_awl B ON A.IDPemda = B.IDPemda
	WHERE A.Tgl_Dokumen BETWEEN B.tgl_awl AND @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
	      A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register AND 
          A.Kd_Riwayat IN (2,7,21) AND A.Kd_Data <> 3
	GROUP BY A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Riwayat,A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,
	         A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85,A.No_Register,A.Kd_Data,A.Kd_KA,A.Tgl_DOkumen, A.No_Dokumen
    

    --saldo awal reklass
	INSERT INTO @tmpHarga
    	SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,
	   	A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85,B.No_Reg8,
	      	SUM (A.Harga) AS Harga,A.Tgl_Dokumen, A.No_Dokumen,
	       	ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat,ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa,A.Kd_Data, A.Kd_KA
	FROM Ta_KIBER A INNER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
	
	WHERE A.Tgl_Dokumen > @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
	      A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND B.No_Reg8 LIKE @No_Register AND 
              A.Kd_Riwayat IN (33) AND B.KD_HAPUS = 0 AND B.KD_KA = 1
	GROUP BY A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Riwayat,A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,
	         A.Tgl_Dokumen, A.No_Dokumen,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85,B.No_Reg8,A.Kd_Data,A.Kd_KA


----------
	INSERT INTO @UbahData
	SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,
	       A.Kd_Aset85,A.No_Reg8 AS No_Register,A.Kd_Ruang,A.Kd_Pemilik,A.Tgl_Perolehan,A.Tgl_Pembukuan, A.Tgl_Pembukuan AS Tgl_Dokumen,'' AS No_Dokumen, 
           CASE WHEN @JLap = 1 THEN '' ELSE A.Judul END AS Judul, 
           CASE WHEN @JLap = 1 THEN '' ELSE A.Pencipta END AS Pencipta, 
           A.Bahan, A.Ukuran, A.Asal_Usul, A.Kondisi, 
           CASE WHEN @JLap = 1 THEN '' ELSE A.Keterangan END AS Keterangan
	FROM Ta_KIB_E A LEFT OUTER JOIN @no_urut B ON A.IDPemda = B.IDPemda 
    WHERE  B.IDPemda IS NULL AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND 
	       A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND 
	       A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Reg8 LIKE @No_Register AND 
	       A.Kd_Hapus <> 1

	INSERT INTO @UbahData
	SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,
	       A.Kd_Aset85,A.No_Register,A.Kd_Ruang,A.Kd_Pemilik,A.Tgl_Perolehan,A.Tgl_Pembukuan,A.Tgl_SK AS Tgl_Dokumen,A.NO_SK AS No_Dokumen, 
	       CASE WHEN @JLap = 1 THEN '' ELSE A.Judul END AS Judul, 
           CASE WHEN @JLap = 1 THEN '' ELSE A.Pencipta END AS Pencipta, 
	       A.Bahan,A.Ukuran,A.Asal_usul,C.Kondisi, 
           CASE WHEN @JLap = 1 THEN '' ELSE A.Keterangan END AS Keterangan
	FROM Ta_KIBEHapus A LEFT OUTER JOIN @no_urut B ON A.IDPemda = B.IDPemda 
		LEFT OUTER JOIN @Kondisi C ON A.IDPemda = C.IDPemda
	WHERE B.IDPemda IS NULL AND A.Tgl_SK > @D2 AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		  A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register

	INSERT INTO @UbahData
	SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,
	       A.Kd_Aset85,A.No_Register,A.Kd_Ruang,A.Kd_Pemilik,A.Tgl_Perolehan,A.Tgl_Pembukuan,A.Tgl_Dokumen, A.No_Dokumen,
	       CASE WHEN @JLap = 1 THEN '' ELSE A.Judul END AS Judul, 
           CASE WHEN @JLap = 1 THEN '' ELSE A.Pencipta END AS Pencipta, 
	       A.Bahan,A.Ukuran,A.Asal_usul,A.Kondisi, 
           CASE WHEN @JLap = 1 THEN '' ELSE A.Keterangan END AS Keterangan
	FROM Ta_KIBER A LEFT OUTER JOIN @no_urut B ON A.IDPemda = B.IDPemda 
	WHERE B.IDPemda IS NULL AND A.Tgl_dokumen > @D2 AND A.Kd_Riwayat = 3 AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit 
LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		  A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register

	INSERT INTO @UbahData
	SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,
	       A.Kd_Aset85,A.No_Register,A.Kd_Ruang,A.Kd_Pemilik,A.Tgl_Perolehan,A.Tgl_Pembukuan,A.Tgl_Dokumen,A.No_Dokumen,
	       CASE WHEN @JLap = 1 THEN '' ELSE A.Judul END AS Judul, 
           CASE WHEN @JLap = 1 THEN '' ELSE A.Pencipta END AS Pencipta, 
	       A.Bahan,A.Ukuran,A.Asal_usul,A.Kondisi, 
           CASE WHEN @JLap = 1 THEN '' ELSE A.Keterangan END AS Keterangan
	FROM Ta_KIBER A INNER JOIN @no_urut B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id
	WHERE A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
	      A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register


    INSERT INTO @UpdateKIB
    SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5, 
	       A.No_Register,B.Kd_Ruang,B.Kd_Pemilik,B.Tgl_Perolehan,B.Tgl_Pembukuan,B.Tgl_Dokumen,B.No_Dokumen,B.Judul,B.Pencipta,
	       B.Bahan,B.Ukuran,B.Asal_usul,B.Kondisi,A.Harga,A.Masa_Manfaat,A.Nilai_Sisa,B.Keterangan,A.Kd_KA
    FROM (
		  SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4, 
		         A.Kd_Aset5,A.No_Register,ISNULL(SUM(A.Harga),0) AS Harga,ISNULL(SUM(A.Masa_Manfaat),0) AS Masa_Manfaat, ISNULL(SUM(A.Nilai_Sisa),0) AS Nilai_Sisa, 
		         MAX(Kd_KA) AS Kd_KA
	      FROM @tmpHarga A 
	      GROUP BY A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,
	               A.Kd_Aset5,A.No_Register
	     ) A INNER JOIN
	    (
	     SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,
	            A.Kd_Aset4,A.Kd_Aset5,A.No_Register,A.Kd_Ruang,A.Kd_Pemilik,A.Tgl_Perolehan,A.Tgl_Pembukuan,A.Tgl_Dokumen, 
	            A.No_Dokumen,A.Judul,A.Pencipta,A.Bahan,A.Ukuran,A.Asal_usul,A.Kondisi,A.Keterangan
	     FROM @UbahData A 
	    )B ON A.IDPemda = B.IDPemda AND A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
	          A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND 
	          A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register 

	RETURN   END












GO
