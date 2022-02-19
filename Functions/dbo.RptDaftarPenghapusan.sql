USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** RptDaftarPenghapusan - 12122015 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE dbo.RptDaftarPenghapusan @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Hapus varchar(1)
WITH ENCRYPTION
AS

/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Hapus varchar(1)

SET @Tahun = '2017'
SET @Kd_Prov = '31'
SET @Kd_Kab_Kota = '9'
SET @Kd_Bidang = '8'
SET @Kd_Unit = '1'
SET @Kd_Sub = '5'
SET @Kd_UPB = '6'
SET @Kd_Hapus ='2'
*/
	IF ISNULL(@Kd_Prov, '') = '' SET @Kd_Prov = '%'
	IF ISNULL(@Kd_Kab_Kota, '') = '' SET @Kd_Kab_Kota = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

DECLARE @HAPUS TABLE (Tahun Varchar(4), No_SK Varchar(50), Tgl_SK DateTime, Kd_Prov varchar(3), Kd_Kab_Kota varchar(3), Kd_Bidang varchar(3), Kd_Unit varchar(3), Kd_Sub varchar(3), Kd_UPB varchar(3),
 			Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, Kd_Pemilik tinyint, Tgl_Perolehan DateTime, Kondisi Varchar(50), Kd_Alasan tinyint, Harga Money, Keterangan Varchar(255))


INSERT INTO @HAPUS
SELECT A.Tahun, A.No_SK, A.Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, 
		   A.Tgl_Perolehan, A.Kondisi, A.Kd_Alasan, A.Harga, A.Keterangan
FROM(
		
	SELECT A.Tahun, A.No_SK, A.Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, 
		   A.Tgl_Perolehan, A.Kondisi, A.Kd_Alasan, A.Harga, A.Keterangan
	FROM(
			SELECT @Tahun AS Tahun, No_SK, Tgl_SK, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik, 
		            Tgl_Perolehan, 1 AS Kondisi, Kd_Alasan, Harga, Keterangan
			FROM  Ta_KIBAHapus
			WHERE (YEAR(Tgl_Pembukuan) <= @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			
			UNION ALL

			SELECT @Tahun AS Tahun, B.No_SK, B.Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, 
		            A.Tgl_Perolehan, 1 AS Kondisi, A.Kd_Alasan, A.Harga, A.Keterangan
			FROM	Ta_KIBAR A INNER JOIN
				Ta_KIBAHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
			WHERE (YEAR(B.Tgl_SK) <= @Tahun) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
				AND A.Kd_Riwayat IN (2,21)
			
			UNION ALL

			SELECT @Tahun AS Tahun, No_SK, Tgl_SK, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik, 
		            Tgl_Perolehan, Kondisi, Kd_Alasan, Harga, Keterangan
			FROM  Ta_KIBBHapus
			WHERE (YEAR(Tgl_Pembukuan) <= @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			
			UNION ALL

			SELECT @Tahun AS Tahun, B.No_SK, B.Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, 
		            A.Tgl_Perolehan, A.Kondisi, A.Kd_Alasan, A.Harga, A.Keterangan
			FROM	Ta_KIBBR A INNER JOIN
				Ta_KIBBHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
			WHERE (YEAR(B.Tgl_SK) <= @Tahun) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
				AND A.Kd_Riwayat IN (2,21)
			
			UNION ALL
			
			SELECT  @Tahun AS Tahun, No_SK, Tgl_SK, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik, 
		            Tgl_Perolehan, Kondisi, Kd_Alasan, Harga, Keterangan
			FROM  Ta_KIBCHapus
			WHERE (YEAR(Tgl_Pembukuan) <= @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
		
			UNION ALL

			SELECT @Tahun AS Tahun, B.No_SK, B.Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, 
		            A.Tgl_Perolehan, A.Kondisi, A.Kd_Alasan, A.Harga, A.Keterangan
			FROM	Ta_KIBCR A INNER JOIN
				Ta_KIBCHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
			WHERE (YEAR(B.Tgl_SK) <= @Tahun) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
				AND A.Kd_Riwayat IN (2,21)
			
			UNION ALL
			
			SELECT  @Tahun AS Tahun, No_SK, Tgl_SK, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik, 
		            Tgl_Perolehan, Kondisi, Kd_Alasan, Harga, Keterangan
			FROM  Ta_KIBDHapus
			WHERE (YEAR(Tgl_Pembukuan) <= @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
		
			UNION ALL

			SELECT @Tahun AS Tahun, B.No_SK, B.Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, 
		            A.Tgl_Perolehan, A.Kondisi, A.Kd_Alasan, A.Harga, A.Keterangan
			FROM	Ta_KIBDR A INNER JOIN
				Ta_KIBDHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
			WHERE (YEAR(B.Tgl_SK) <= @Tahun) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
				AND A.Kd_Riwayat IN (2,21)
			
			UNION ALL
			
			SELECT  @Tahun AS Tahun, No_SK, Tgl_SK, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik, 
		            Tgl_Perolehan, Kondisi, Kd_Alasan, Harga, Keterangan
			FROM  Ta_KIBEHapus
			WHERE (YEAR(Tgl_Pembukuan) <= @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			
			UNION ALL

			SELECT @Tahun AS Tahun, B.No_SK, B.Tgl_SK, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, 
		            A.Tgl_Perolehan, A.Kondisi, A.Kd_Alasan, A.Harga, A.Keterangan
			FROM	Ta_KIBER A INNER JOIN
				Ta_KIBEHapus B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
				AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register
			WHERE (YEAR(B.Tgl_SK) <= @Tahun) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
				AND A.Kd_Riwayat IN (2,21)			
			
		)A 

	UNION ALL
	

	SELECT B.Tahun, B.No_Dokumen, B.Tgl_Dokumen, B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.No_Register, B.Kd_Pemilik, 
		   B.Tgl_Perolehan, B.Kondisi, B.Kd_Alasan, B.Harga, B.Keterangan
	FROM(
			
			SELECT @Tahun AS Tahun, No_Dokumen, Tgl_Dokumen, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik, 
		            Tgl_Perolehan, '' AS Kondisi, Kd_Alasan, Harga, Keterangan
			FROM  Ta_KIBAR
			WHERE (YEAR(Tgl_Pembukuan) <= @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) AND (Kd_Riwayat = 7)
			
			UNION ALL

			SELECT @Tahun AS Tahun, No_Dokumen, Tgl_Dokumen, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik, 
		            Tgl_Perolehan, Kondisi, Kd_Alasan, Harga, Keterangan
			FROM  Ta_KIBBR
			WHERE (YEAR(Tgl_Pembukuan) <= @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) AND (Kd_Riwayat = 7)
			
			UNION ALL
			
			SELECT  @Tahun AS Tahun, No_Dokumen, Tgl_Dokumen, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik, 
		            Tgl_Perolehan, Kondisi, Kd_Alasan, Harga, Keterangan
			FROM  Ta_KIBCR
			WHERE (YEAR(Tgl_Pembukuan) <= @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)AND (Kd_Riwayat = 7)
		
			UNION ALL
		
			SELECT  @Tahun AS Tahun, No_Dokumen, Tgl_Dokumen, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik, 
		            Tgl_Perolehan, Kondisi, Kd_Alasan, Harga, Keterangan
			FROM  Ta_KIBDR
			WHERE (YEAR(Tgl_Pembukuan) <= @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)AND (Kd_Riwayat = 7)
		
			UNION ALL
		
			SELECT  @Tahun AS Tahun, No_Dokumen, Tgl_Dokumen, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, Kd_Pemilik, 
		            Tgl_Perolehan, Kondisi, Kd_Alasan, Harga, Keterangan
			FROM  Ta_KIBER
			WHERE (YEAR(Tgl_Pembukuan) <= @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)AND (Kd_Riwayat = 7)
		)B
		
)A


	SELECT N.Kd_Prov, N.Nm_Provinsi, M.Kd_Kab_Kota, M.Nm_Kab_Kota, K.Kd_Bidang, K.Nm_Bidang, L.Nm_UPB,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) As Kd_Prov_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) As Kd_Kab_Kota_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) AS Kd_Bidang_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) AS Kd_Unit_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) AS Kd_Sub_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_UPB), 2) AS Kd_UPB_Gab,

		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) AS Kd_Aset_Gab1,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) AS Kd_Aset_Gab2,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) AS Kd_Aset_Gab3,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 4) AS Kd_Aset_Gab4,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 4) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset5), 5) AS Kd_Aset_Gab5,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_UPB), 2) + '.' +
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 4) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset5), 5) AS Kd_Aset_UPB,
		A.No_Register, J.Nm_Aset1, I.Nm_Aset2, H.Nm_Aset3, G.Nm_Aset4, C.Nm_Aset5, 
		B.No_SK, B.Tgl_SK,  YEAR(A.Tgl_Perolehan) AS Tahun, MAX(A.Keterangan) AS Keterangan, SUM(A.Harga) AS Harga, MAX(A.Kd_Alasan) AS Kd_Alasan, MAX(O.Ur_Alasan) AS Ur_Alasan, 
		dbo.fn_KdLokasi(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, '%', YEAR(A.Tgl_Perolehan)) AS Kd_Lokasi,
		REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') + '.' + RIGHT('0000' + CONVERT(varchar, A.No_Register), 4) AS Kd_Gab_Brg,
		CASE
		WHEN D.Nm_Sub_Unit = E.Nm_Unit THEN D.Nm_Sub_Unit
		ELSE D.Nm_Sub_Unit + ' ' + E.Nm_Unit
		END AS Nm_Unit,
		P.Uraian AS Kondisi, F.Jbt_Pimpinan, F.Nm_Pimpinan, F.Nip_Pimpinan, F.Jbt_Pengurus, F.Nm_Pengurus, F.Nip_Pengurus
	FROM 	@HAPUS A INNER JOIN
		Ta_Penghapusan B ON A.No_SK = B.No_SK INNER JOIN --A.Tahun = B.Tahun AND
		Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5 INNER JOIN
		Ref_Rek_Aset4 G ON C.Kd_Aset1 = G.Kd_Aset1 AND C.Kd_Aset2 = G.Kd_Aset2 AND C.Kd_Aset3 = G.Kd_Aset3 AND C.Kd_Aset4 = G.Kd_Aset4 INNER JOIN
		Ref_Rek_Aset3 H ON G.Kd_Aset1 = H.Kd_Aset1 AND G.Kd_Aset2 = H.Kd_Aset2 AND G.Kd_Aset3 = H.Kd_Aset3 INNER JOIN
		Ref_Rek_Aset2 I ON H.Kd_Aset1 = I.Kd_Aset1 AND H.Kd_Aset2 = I.Kd_Aset2 INNER JOIN
		Ref_Rek_Aset1 J ON I.Kd_Aset1 = J.Kd_Aset1 INNER JOIN
		Ref_UPB L ON A.Kd_prov = L.Kd_Prov AND A.Kd_Kab_Kota = L.Kd_Kab_Kota AND A.Kd_Bidang = L.Kd_Bidang AND A.Kd_Unit = L.Kd_Unit AND A.Kd_Sub = L.Kd_Sub AND A.Kd_UPB = L.Kd_UPB INNER JOIN
		Ref_Sub_Unit D ON A.Kd_Bidang = D.Kd_Bidang AND A.Kd_Unit = D.Kd_Unit AND A.Kd_Sub = D.Kd_Sub INNER JOIN
		Ref_Unit E ON D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
		Ref_Bidang K ON E.Kd_Bidang = K.Kd_Bidang INNER JOIN
		Ta_UPB F ON A.Tahun = F.Tahun AND A.Kd_Prov = F.Kd_Prov AND A.Kd_Kab_Kota = F.Kd_Kab_Kota AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB INNER JOIN
		Ref_Kab_Kota M ON A.Kd_Prov = M.Kd_Prov AND A.Kd_Kab_Kota = M.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi N ON M.Kd_Prov = N.Kd_Prov LEFT OUTER JOIN
		Ref_Alasan O ON A.Kd_Alasan = O.Kd_Alasan INNER JOIN
		Ref_kondisi P ON A.Kondisi = P.Kd_Kondisi
	WHERE   (B.Tahun = @Tahun) AND 
		(M.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (K.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND (B.Kd_Hapus = @Kd_Hapus)
	GROUP BY N.Kd_Prov, N.Nm_Provinsi, M.Kd_Kab_Kota, M.Nm_Kab_Kota, K.Kd_Bidang, K.Nm_Bidang, L.Nm_UPB,
		A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		J.Nm_Aset1, I.Nm_Aset2, H.Nm_Aset3, G.Nm_Aset4, C.Nm_Aset5, B.No_SK, B.Tgl_SK, A.Tgl_Perolehan, A.Kd_Pemilik,
		D.Nm_Sub_Unit, E.Nm_Unit,  
		P.Uraian, F.Jbt_Pimpinan, F.Nm_Pimpinan, F.Nip_Pimpinan, F.Jbt_Pengurus, F.Nm_Pengurus, F.Nip_Pengurus
	ORDER BY B.No_SK, B.Tgl_SK



GO
