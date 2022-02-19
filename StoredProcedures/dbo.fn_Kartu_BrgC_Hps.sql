USE bmd_hst2020
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO


/*** fn_Kartu_BrgC_Hps - 09012017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE FUNCTION fn_Kartu_BrgC_Hps (@D2 Datetime,  @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4),
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(5), @JLap Tinyint, @Kondisi Varchar(2))

RETURNS @UpdateKIB TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint,  Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int,  
			 Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, 
			 No_Register int, Harga money, Kondisi Varchar(2))

WITH ENCRYPTION
AS
BEGIN

/*
DECLARE @Tahun varchar(4), @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4), @JLap Tinyint
SET @Tahun = '2015'
SET @D2 = '20151231'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '11'
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @Kd_UPB = ''
SET @Kd_Aset1	= ''
SET @Kd_Aset2	= ''
SET @Kd_Aset3	= ''
SET @Kd_Aset4	= ''
SET @Kd_Aset5	= ''
SET @No_Register = ''
SET @JLap = 1
*/
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
        IF ISNULL (@JLap,'') = '' SET @JLap = 0

	DECLARE @no_urut  TABLE(IDPemda varchar(17), Kd_Id Int) 
	DECLARE @tmpHarga TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int, Kd_ASet1 int, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, Harga money)
	DECLARE @UbahData TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint,  Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int,  Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, Kondisi Varchar(2))

	INSERT INTO @no_urut
	SELECT IDPemda, MAX(Kd_Id) AS Kd_Id FROM Ta_KIBCR WHERE Tgl_Dokumen <= @D2 AND Kd_Riwayat IN(1,18,22) GROUP BY IDPemda

	INSERT INTO @tmpHarga
	SELECT	Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,  ISNULL(SUM(Harga),0) AS Harga
	FROM	Ta_KIB_C 
	WHERE	Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
		AND Kd_Data <> 3 AND Kd_Hapus  <> 1
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Data, Kd_KA

        INSERT INTO @tmpHarga
	SELECT	Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,  ISNULL(SUM(Harga),0) AS Harga
	FROM	Ta_KIBCHapus 
	WHERE	Tgl_SK > @D2 AND Tgl_Pembukuan <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Data, Kd_KA

        INSERT INTO @tmpHarga
	SELECT	B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Kd_ASet1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, 
		B.No_Register, ISNULL(SUM(B.Harga),0) AS Harga
	FROM	Ta_KIBCR B 
	WHERE	B.Tgl_dokumen > @D2 AND B.Tgl_Pembukuan <= @D2 AND B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang LIKE @Kd_Bidang AND B.Kd_Unit LIKE @Kd_Unit AND B.Kd_Sub LIKE @Kd_Sub AND B.Kd_UPB LIKE @Kd_UPB AND
		B.Kd_Aset1 LIKE @Kd_Aset1 AND B.Kd_Aset2 LIKE @Kd_Aset2 AND B.Kd_Aset3 LIKE @Kd_Aset3 AND B.Kd_Aset4 LIKE @Kd_Aset4 AND B.Kd_Aset5 LIKE @Kd_Aset5 AND B.No_Register LIKE @No_Register AND
                B.Kd_Riwayat = 3 AND B.Kd_Data <> 3 
	GROUP BY B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Kd_ASet1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.No_Register, B.Kd_Data, B.Kd_KA

	INSERT INTO @tmpHarga
	SELECT	B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, 
                B.No_Register, ISNULL(SUM(B.Harga),0) AS Harga
	FROM	Ta_KIBCR B 
	WHERE	B.Tgl_dokumen <= @D2 AND B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang LIKE @Kd_Bidang AND B.Kd_Unit LIKE @Kd_Unit AND B.Kd_Sub LIKE @Kd_Sub AND B.Kd_UPB LIKE @Kd_UPB AND
		B.Kd_Aset1 LIKE @Kd_Aset1 AND B.Kd_Aset2 LIKE @Kd_Aset2 AND B.Kd_Aset3 LIKE @Kd_Aset3 AND B.Kd_Aset4 LIKE @Kd_Aset4 AND B.Kd_Aset5 LIKE @Kd_Aset5 AND B.No_Register LIKE @No_Register AND 
                B.Kd_Riwayat = 2 AND B.Kd_Data <> 3 
	GROUP BY B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Kd_ASet1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.No_Register, B.Kd_Data

	INSERT INTO @tmpHarga
	SELECT	Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_ASet1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, 
                No_Register, ISNULL(SUM(-Harga),0) AS Harga
	FROM	Ta_KIBCR 
	WHERE	Tgl_dokumen <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register AND 
                Kd_Riwayat = 7 AND Kd_Data <> 3
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Data

	INSERT INTO @tmpHarga
	SELECT	Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, 
                No_Register, ISNULL(SUM(Harga),0) AS Harga
	FROM	Ta_KIBCR
	WHERE	Tgl_dokumen <= @D2 AND Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota AND Kd_Bidang LIKE @Kd_Bidang AND Kd_Unit LIKE @Kd_Unit AND Kd_Sub LIKE @Kd_Sub AND Kd_UPB LIKE @Kd_UPB AND
		Kd_Aset1 LIKE @Kd_Aset1 AND Kd_Aset2 LIKE @Kd_Aset2 AND Kd_Aset3 LIKE @Kd_Aset3 AND Kd_Aset4 LIKE @Kd_Aset4 AND Kd_Aset5 LIKE @Kd_Aset5 AND No_Register LIKE @No_Register AND 
                Kd_Riwayat = 21	AND Kd_Data <> 3
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Data


	INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kondisi
	FROM Ta_KIB_C A LEFT OUTER JOIN
		(
		SELECT A.IDPemda, A.Kd_Id AS Kd_Id 
		FROM Ta_KIBCR A INNER JOIN
		     @no_urut B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id
		) B ON  A.IDPemda = B.IDPemda
	WHERE (B.IDPemda IS NULL) AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
	       A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register
               AND A.Kd_Hapus <> 1

        INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kondisi
	FROM Ta_KIBCHapus A LEFT OUTER JOIN
		(
		SELECT A.IDPemda, A.Kd_Id AS Kd_Id 
		FROM Ta_KIBCR A INNER JOIN
		     @no_urut B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id
		) B ON A.IDPemda = B.IDPemda
	WHERE (B.IDPemda IS NULL) AND A.Tgl_SK > @D2 AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register

        INSERT INTO @UbahData
        SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kondisi
	FROM Ta_KIBCR A LEFT OUTER JOIN
		(
		  SELECT A.IDPemda, A.Kd_Id AS Kd_Id 
		  FROM Ta_KIBCR A INNER JOIN
		       @no_urut B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id 
		) B ON A.IDPemda = B.IDPemda
	WHERE (B.IDPemda IS NULL) AND A.Tgl_dokumen > @D2 AND A.Kd_Riwayat = 3 AND A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register

	INSERT INTO @UbahData
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kondisi
	FROM Ta_KIBCR A INNER JOIN
		(
		SELECT A.Kd_Riwayat, A.IDPemda, MAX(A.Kd_Id) AS Kd_Id 
		FROM Ta_KIBCR A INNER JOIN
		     @no_urut B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id 
		GROUP BY A.IDPemda, A.Kd_Riwayat
		) B ON A.Kd_Riwayat = B.Kd_Riwayat AND A.Kd_Id = B.Kd_Id AND A.IDPemda = B.IDPemda
	WHERE	A.Tgl_Dokumen <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
		A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register


   INSERT INTO @UpdateKIB
   SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	  A.No_Register, A.Harga, B.Kondisi
	FROM(
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,  ISNULL(SUM(A.Harga),0) AS Harga
	FROM @tmpharga A 
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
	) A INNER JOIN
	(
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kondisi
	FROM @ubahdata A WHERE A.Kondisi LIKE @Kondisi
	)B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_ASet1 = B.Kd_ASet1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 
           AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register 

	RETURN
   END









GO
