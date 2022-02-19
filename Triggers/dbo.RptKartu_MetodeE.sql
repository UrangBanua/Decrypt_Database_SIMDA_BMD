USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[RptKartu_MetodeE] @Tahun varchar(4), @Kd_Pemilik Varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
		@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4)
WITH ENCRYPTION
AS
/*

DECLARE @Tahun varchar(4), @Kd_Pemilik Varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4)
SET @Tahun = '2009'
SET @Kd_Pemilik	= '12'
SET @Kd_Prov = '13'
SET @Kd_Kab_Kota = '4'
SET @Kd_Bidang = '4'
SET @Kd_Unit = '50'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset1	= '2'
SET @Kd_Aset2	= '3'
SET @Kd_Aset3	= '1'
SET @Kd_Aset4	= '5'
SET @Kd_Aset5	= '1'
SET @No_Register = '1'
*/
	
DECLARE @Metode Table(Tahun varchar(4), Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Status_Manfaat Varchar(100), Metode tinyint, Nama_Metode varchar(50), Umur tinyint, Kd_Ruang int, Nm_Ruang varchar(100))

INSERT INTO @Metode
SELECT	@Tahun AS Tahun, B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, A.Status_Manfaat, B.Metode, B.Nama_Metode, B.Umur, B.Kd_Ruang, B.Nm_Ruang
FROM
	(
	SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.No_Register, A.Kd_Aset1, A.Kd_Aset2,
		A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Riwayat, A.Kd_Id, B.Nm_Riwayat AS Status_Manfaat
	FROM	Ta_KIBER A INNER JOIN
		Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
	WHERE	(A.Kd_Riwayat BETWEEN 8 AND 13) AND (Kd_Id = (SELECT MAX(Kd_Id) FROM Ta_KIBER WHERE Kd_Riwayat BETWEEN 8 AND 13))
	) A RIGHT OUTER JOIN
	(
	SELECT	A.Tahun, D.Kd_Prov, D.Kd_Kab_Kota, D.Kd_Bidang, D.Kd_Unit, D.Kd_Sub, D.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Metode, A.Nama_Metode, B.Kd_Ruang, C.Nm_Ruang,
		CASE
		WHEN D.Kd_Riwayat <> 2 THEN ISNULL(B.Masa_Manfaat,0) ELSE ISNULL(D.Masa_Manfaat,0) END AS Umur --D.Masa_Manfaat AS Umur
	FROM
		(SELECT	A.Tahun, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Metode, A.Umur, A.ThnPenyusutan, B.Ur_Metode AS Nama_Metode
		FROM	Ref_Penyusutan A LEFT OUTER JOIN
			Ref_Metode B ON A.Metode = B.Kd_Metode
		WHERE	A.Tahun = @Tahun) A LEFT OUTER JOIN
		Ta_KIB_E B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 LEFT OUTER JOIN
		Ta_Ruang C ON B.Kd_Prov = C.Kd_Prov AND B.Kd_Kab_Kota = C.Kd_Kab_Kota AND B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND 
			      B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB AND B.Kd_Ruang = C.Kd_Ruang LEFT OUTER JOIN
		Ta_KIBER D ON B.Kd_Prov = D.Kd_Prov AND B.Kd_Kab_Kota = D.Kd_Kab_Kota AND B.Kd_Bidang = D.Kd_Bidang AND B.Kd_Unit = D.Kd_Unit AND 
			      B.Kd_Sub = D.Kd_Sub AND B.Kd_UPB = D.Kd_UPB AND B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4
			      AND B.Kd_Aset5 = D.Kd_Aset5 AND B.No_Register = D.No_Register
	WHERE	B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang = @Kd_Bidang AND B.Kd_Unit = @Kd_Unit AND B.Kd_Sub = @Kd_Sub AND B.Kd_UPB = @Kd_UPB AND
		B.Kd_Aset1 = @Kd_Aset1 AND B.Kd_Aset2 = @Kd_Aset2 AND B.Kd_Aset3 = @Kd_Aset3 AND B.Kd_Aset4 = @Kd_Aset4 AND B.Kd_Aset5 = @Kd_Aset5 AND B.No_Register = @No_Register
		AND D.Kd_Riwayat = 2
	) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND 
	A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4

SELECT	A.Metode, A.Status_Manfaat, A.Nama_Metode, A.Umur, A.Kd_Ruang, A.Nm_Ruang
FROM	@Metode A





GO
