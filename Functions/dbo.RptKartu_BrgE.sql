USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[RptKartu_BrgE] @Tahun varchar(4), @Kd_Pemilik Varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
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
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset1	= '5'
SET @Kd_Aset2	= '17'
SET @Kd_Aset3	= '1'
SET @Kd_Aset4	= '1'
SET @Kd_Aset5	= '1'
SET @No_Register = '6'
*/

	SELECT	A.Kd_Gab_Bidang + '.' + A.Kd_Gab_Unit + '.' +  A.Kd_Gab_Sub +'.' + A.Kd_Gab_UPB AS Kd_Gab_UPB, A.Nm_UPB,
		CONVERT(varchar, B.Kd_Aset1) + '.' + CONVERT(varchar, B.Kd_Aset2) + '.' + CONVERT(varchar, B.Kd_Aset3) + 
		'.' + RIGHT('0' + CONVERT(varchar, B.Kd_Aset4), 2) + '.' + RIGHT('0' + CONVERT(varchar, B.Kd_Aset5), 2) AS Kd_AsetGab,
		D.Nm_Aset5, B.No_Register, F.Alamat/*,
		CASE WHEN E.Kd_Riwayat = NULL THEN '-'ELSE
		E.Status_Manfaat END AS Status_Manfaat, G.Umur, G.Nama_Metode, G.Nm_Ruang*/
	FROM	
		(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Nm_UPB,
			RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) AS Kd_Gab_Bidang,
			CASE LEN(CONVERT(Varchar, A.Kd_Unit)) WHEN 1 THEN
			'00'+ CONVERT(Varchar, A.Kd_Unit) ELSE
			RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 3) END AS Kd_Gab_Unit,
			CASE LEN(CONVERT(varchar, A.Kd_Sub)) WHEN 3 THEN 
			CONVERT(varchar, A.Kd_Sub) ELSE RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) END AS Kd_Gab_Sub,
			CASE LEN(CONVERT(varchar, A.Kd_UPB)) WHEN 3 THEN 
			CONVERT(varchar, A.Kd_UPB) ELSE RIGHT('0' + CONVERT(varchar, A.Kd_UPB), 2) END AS Kd_Gab_UPB
		FROM	Ref_UPB A
		) A INNER JOIN
		Ta_KIB_E B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB LEFT OUTER JOIN
		--Ref_Riwayat C ON B.Kd_Riwayat = C.Kd_Riwayat INNER JOIN
		Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 LEFT OUTER JOIN
		/*(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.No_Register, A.Kd_Aset1, A.Kd_Aset2,
			A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Kd_Riwayat, A.Kd_Id, B.Nm_Riwayat AS Status_Manfaat
		FROM	Ta_KIBER A INNER JOIN
			Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
		WHERE	(A.Kd_Riwayat BETWEEN 8 AND 13) AND (Kd_Id = (SELECT MAX(Kd_Id) FROM Ta_KIBER WHERE Kd_Riwayat BETWEEN 8 AND 13))
		) E ON B.Kd_Prov = E.Kd_Prov AND B.Kd_Kab_Kota = E.Kd_Kab_Kota AND B.Kd_Bidang = E.Kd_Bidang AND B.Kd_Unit = E.Kd_Unit AND
		B.Kd_Sub = E.Kd_Sub AND B.Kd_UPB = E.Kd_UPB AND B.Kd_Aset1 = E.Kd_Aset1 AND B.Kd_Aset2 = E.Kd_Aset2 AND B.Kd_Aset3 = E.Kd_Aset3
		AND B.Kd_Aset4 = E.Kd_Aset4 AND B.Kd_Aset5 = E.Kd_Aset5 AND B.No_Register = E.No_Register INNER JOIN*/
		(
		SELECT 	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Alamat
		FROM	Ta_UPB A
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND
			A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND A.Tahun = @Tahun
		) F ON B.Kd_Prov = F.Kd_Prov AND B.Kd_Kab_Kota = F.Kd_Kab_Kota AND B.Kd_Bidang = F.Kd_Bidang AND
				B.Kd_Unit = F.Kd_Unit AND B.Kd_Sub = F.Kd_Sub AND B.Kd_UPB = F.Kd_UPB/*,
		(SELECT	A.Tahun, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Metode, A.Nama_Metode, D.Masa_Manfaat AS Umur, B.Kd_Ruang, C.Nm_Ruang
		FROM
			(SELECT	A.Tahun, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Metode, A.Umur, A.ThnPenyusutan, B.Ur_Metode AS Nama_Metode
			FROM	Ref_Penyusutan A INNER JOIN
				Ref_Metode B ON A.Metode = B.Kd_Metode
			WHERE	A.Tahun = @Tahun) A RIGHT OUTER JOIN
			Ta_KIB_E B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 LEFT OUTER JOIN
			Ta_Ruang C ON B.Kd_Prov = C.Kd_Prov AND B.Kd_Kab_Kota = C.Kd_Kab_Kota AND B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND 
				      B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB AND B.Kd_Ruang = C.Kd_Ruang INNER JOIN
			Ta_KIBER D ON B.Kd_Prov = D.Kd_Prov AND B.Kd_Kab_Kota = D.Kd_Kab_Kota AND B.Kd_Bidang = D.Kd_Bidang AND B.Kd_Unit = D.Kd_Unit AND 
				      B.Kd_Sub = D.Kd_Sub AND B.Kd_UPB = D.Kd_UPB AND B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4
				      AND B.Kd_Aset5 = D.Kd_Aset5 AND B.No_Register = D.No_Register
		WHERE	B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang = @Kd_Bidang AND B.Kd_Unit = @Kd_Unit AND B.Kd_Sub = @Kd_Sub AND B.Kd_UPB = @Kd_UPB AND
			B.Kd_Aset1 = @Kd_Aset1 AND B.Kd_Aset2 = @Kd_Aset2 AND B.Kd_Aset3 = @Kd_Aset3 AND B.Kd_Aset4 = @Kd_Aset4 AND B.Kd_Aset5 = @Kd_Aset5 AND B.No_Register = @No_Register
			
		) G*/
	WHERE	B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang = @Kd_Bidang AND B.Kd_Unit = @Kd_Unit AND
		B.Kd_Sub = @Kd_Sub AND B.Kd_UPB = @Kd_UPB AND B.Kd_Aset1 = @Kd_Aset1 AND B.Kd_Aset2 = @Kd_Aset2 AND B.Kd_Aset3 = @Kd_Aset3 AND
		B.Kd_Aset4 = @Kd_Aset4 AND B.Kd_Aset5 = @Kd_Aset5 AND B.No_Register = @No_Register





GO
