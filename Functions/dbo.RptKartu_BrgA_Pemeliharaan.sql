USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** RptKartu_BrgA_Pemeliharaan - 12122015 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE [dbo].[RptKartu_BrgA_Pemeliharaan] @Tahun varchar(4), @Kd_Pemilik Varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Pemilik Varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4)
SET @Tahun = '2008'
SET @Kd_Pemilik	= '12'
SET @Kd_Prov = '13'
SET @Kd_Kab_Kota = '4'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset1	= '1'
SET @Kd_Aset2	= '1'
SET @Kd_Aset3	= '11'
SET @Kd_Aset4	= '4'
SET @Kd_Aset5	= '1'
SET @No_Register = '1'
*/
	
	
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen, A.No_Dokumen, 
			A.Keterangan AS Keterangan, A.Kd_Riwayat AS Kode, B.Nm_Riwayat AS Uraian, A.No_Register, 
			A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, '' AS Masalah, '' Lain2
		FROM	Ta_KIBAR A INNER JOIN
			Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
			A.Kd_Aset1 = @Kd_Aset1 AND A.Kd_Aset2 = @Kd_Aset2 AND A.Kd_Aset3 = @Kd_Aset3 AND A.Kd_Aset4 = @Kd_Aset4 
			AND A.Kd_Aset5 = @Kd_Aset5 AND A.No_Register = @No_Register AND A.Kd_Riwayat BETWEEN 5 AND 6

GO
