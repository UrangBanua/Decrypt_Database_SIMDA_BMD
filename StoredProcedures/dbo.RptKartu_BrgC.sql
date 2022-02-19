USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[RptKartu_BrgC] @Tahun varchar(4), @Kd_Pemilik Varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
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
SET @Kd_Aset1	= '3'
SET @Kd_Aset2	= '11'
SET @Kd_Aset3	= '1'
SET @Kd_Aset4	= '1'
SET @Kd_Aset5	= '1'
SET @No_Register = '3'
*/

	SELECT	A.Kd_Gab_Bidang + '.' + A.Kd_Gab_Unit + '.' +  A.Kd_Gab_Sub +'.' + A.Kd_Gab_UPB AS Kd_Gab_UPB, A.Nm_UPB,
		CONVERT(varchar, B.Kd_Aset1) + '.' + CONVERT(varchar, B.Kd_Aset2) + '.' + CONVERT(varchar, B.Kd_Aset3) + 
		'.' + RIGHT('0' + CONVERT(varchar, B.Kd_Aset4), 2) + '.' + RIGHT('0' + CONVERT(varchar, B.Kd_Aset5), 2) AS Kd_AsetGab,
		E.Nm_Aset5, B.No_Register, F.Alamat/*,
		CASE WHEN E.Kd_Riwayat = NULL THEN '-'ELSE
		E.Status_Manfaat END AS Status_Manfaat, G.Umur, G.Nama_Metode*/
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
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit
			AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		) A INNER JOIN
		Ta_KIB_C B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB LEFT OUTER JOIN
		Ref_Rek_Aset5 E ON B.Kd_Aset1 = E.Kd_Aset1 AND B.Kd_Aset2 = E.Kd_Aset2 AND B.Kd_Aset3 = E.Kd_Aset3 AND B.Kd_Aset4 = E.Kd_Aset4 AND B.Kd_Aset5 = E.Kd_Aset5 LEFT OUTER JOIN
		(
		SELECT 	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Alamat
		FROM	Ta_UPB A
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND
			A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND A.Tahun = @Tahun
		) F ON B.Kd_Prov = F.Kd_Prov AND B.Kd_Kab_Kota = F.Kd_Kab_Kota AND B.Kd_Bidang = F.Kd_Bidang AND
			B.Kd_Unit = F.Kd_Unit AND B.Kd_Sub = F.Kd_Sub AND B.Kd_UPB = F.Kd_UPB
	WHERE	B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang = @Kd_Bidang AND B.Kd_Unit = @Kd_Unit AND
		B.Kd_Sub = @Kd_Sub AND B.Kd_UPB = @Kd_UPB AND B.Kd_Aset1 = @Kd_Aset1 AND B.Kd_Aset2 = @Kd_Aset2 AND B.Kd_Aset3 = @Kd_Aset3 AND
		B.Kd_Aset4 = @Kd_Aset4 AND B.Kd_Aset5 = @Kd_Aset5 AND B.No_Register = @No_Register

GO
