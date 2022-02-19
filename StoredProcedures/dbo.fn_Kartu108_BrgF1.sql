USE bmd_hst2020
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_Kartu108_BrgF1 (@Tahun varchar(4),@D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4),
	@Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(5), @No_Register varchar(5), @JLap Tinyint)

RETURNS @UpdateKIB TABLE(Tahun varchar(4),IDPemda varchar(17), Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int,
 			 Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 int, No_Register int,
			 Kd_Pemilik tinyint, Tgl_Perolehan datetime, Tgl_Pembukuan datetime, Bertingkat_Tidak varchar(20), Beton_Tidak varchar(20), Luas_Lantai float,
			 Lokasi varchar(255), Dokumen_Tanggal datetime, Dokumen_Nomor varchar(50), Status_Tanah varchar(50), Kd_Tanah1 tinyint,
			 Kd_Tanah2 tinyint, Kd_Tanah3 tinyint, Kd_Tanah4 tinyint, Kd_Tanah5 tinyint, Kode_Tanah int, Asal_Usul varchar(50),
			 Kondisi varchar(2), Harga money, Keterangan varchar(255), Kd_KA tinyint)

WITH ENCRYPTION
AS
BEGIN

/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), 
        @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4), @D2 datetime, @JLap Tinyint 

SET @Tahun = '2018'
SET @D2 = '20181231'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = ''
SET @Kd_UPB = ''
SET @Kd_Aset 	= ''
SET @Kd_Aset0	= ''
SET @Kd_Aset1	= ''
SET @Kd_Aset2	= ''
SET @Kd_Aset3	= ''
SET @Kd_Aset4	= ''
SET @Kd_Aset5	= ''
SET @No_Register = ''
SET @JLap = 1
--*/


	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
    	IF ISNULL (@Kd_Aset,'')  = '' SET @Kd_Aset  = '%'
   	IF ISNULL (@Kd_Aset0,'') = '' SET @Kd_Aset0 = '%'
    	IF ISNULL (@Kd_Aset1,'') = '' SET @Kd_Aset1 = '%'
	IF ISNULL (@Kd_Aset2,'') = '' SET @Kd_Aset2 = '%'
	IF ISNULL (@Kd_Aset3,'') = '' SET @Kd_Aset3 = '%'
	IF ISNULL (@Kd_Aset4,'') = '' SET @Kd_Aset4 = '%'
	IF ISNULL (@Kd_Aset5,'') = '' SET @Kd_Aset5 = '%'
	IF ISNULL (@No_Register,'') = '' SET @No_Register = '%'

	
	INSERT INTO @UpdateKIB
	SELECT A.Tahun, A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, 
		6 AS Kd_Aset1, 1 AS Kd_Aset2,  1 AS Kd_Aset3,  1 AS Kd_Aset4, 
		CASE WHEN A.Kd_Aset1 = 1 THEN 1 WHEN A.Kd_Aset1 = 2 THEN 2 WHEN A.Kd_Aset1 = 3 THEN 3 WHEN A.Kd_Aset1 = 4 THEN 4 WHEN A.Kd_Aset1 = 5 THEN 5
		ELSE Kd_Aset5 END AS Kd_Aset5, 
                A.No_Register,
		A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Bertingkat_Tidak, A.Beton_Tidak, A.Luas_Lantai, A.Lokasi, ISNULL(A.Dokumen_Tanggal, 0) AS Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah, 
		A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_Usul, A.Kondisi, A.Harga, '' AS Keterangan, A.Kd_KA
    	FROM Ta_Fn_KIB_F A
	WHERE A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
	      A.Kd_Aset LIKE @Kd_Aset AND A.Kd_Aset0 LIKE @Kd_Aset0 AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register
	      AND A.Tahun = @Tahun
	      

	RETURN END










GO
