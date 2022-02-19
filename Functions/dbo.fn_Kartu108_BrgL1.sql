USE bmd_hst2020
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_Kartu108_BrgL1 (@Tahun varchar(4),@D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4),
	@Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(5), @JLap Tinyint)

RETURNS @UpdateKIB TABLE(Tahun varchar(4),IDPemda Varchar(17), Kd_Prov tinyint, Kd_Kab_Kota tinyint,  Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub tinyint, Kd_UPB int, Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, 
                         Kd_Aset4 tinyint, Kd_Aset5 int, No_Register int, Kd_Ruang int, Kd_Pemilik tinyint, Tgl_Perolehan Datetime , Tgl_Pembukuan Datetime, Tgl_Dokumen Datetime, 
                         No_Dokumen Varchar(100),  Judul Varchar(255), Pencipta Varchar(255), Bahan Varchar(50), Ukuran Float(8), Asal_usul Varchar(50), Kondisi Varchar(2), Harga money, 
                         Masa_Manfaat smallint, Nilai_Sisa money, Keterangan Varchar (255), Kd_KA tinyint)

WITH ENCRYPTION
AS
BEGIN

/*
DECLARE @Tahun varchar(4), @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4)
SET @Tahun = '2017'
SET @D2 = '20171231'
SET @Kd_Prov = '30'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
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
*/
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
	SELECT A.Tahun, A.IDpemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	  A.No_Register, A.Kd_Ruang, A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Tgl_Dokumen, '' AS No_Dokumen, '' AS Judul, '' AS Pencipta, A.Bahan, A.Ukuran,
	  A.Asal_usul, A.Kondisi, A.Harga, A.Masa_Manfaat, A.Nilai_Sisa, '' AS Keterangan, A.Kd_KA
	FROM Ta_Fn_KIB_L A
	WHERE A.Tgl_Pembukuan <= @D2 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND
	      A.Kd_Aset LIKE @Kd_Aset AND A.Kd_Aset0 LIKE @Kd_Aset0 AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Kd_Aset5 LIKE @Kd_Aset5 AND A.No_Register LIKE @No_Register
	      AND A.Tahun = @Tahun	

	
	RETURN
END










GO
