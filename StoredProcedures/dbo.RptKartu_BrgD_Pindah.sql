USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[RptKartu_BrgD_Pindah] @Tahun varchar(4), @Kd_Pemilik Varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
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
SET @Kd_Bidang = '5'
SET @Kd_Unit = '5'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset1	= '4'
SET @Kd_Aset2	= '13'
SET @Kd_Aset3	= '1'
SET @Kd_Aset4	= '1'
SET @Kd_Aset5	= '1'
SET @No_Register = '1'
*/
	
	SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen, A.No_Dokumen, 
		A.Keterangan AS Keterangan, A.Kd_Riwayat AS Kode, B.Nm_Riwayat AS Uraian,
		A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Harga AS Nilai, 
		C.Kd_Gab_Bidang + '.' + C.Kd_Gab_Unit + '.' +  C.Kd_Gab_Sub +'.' + C.Kd_Gab_UPB AS Kd_Gab_UPB, D.Nm_UPB
	FROM	Ta_KIBDR A INNER JOIN
		Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat INNER JOIN
		(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3,
			A.Kd_Aset4, A.Kd_Aset5, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1,
			RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) AS Kd_Gab_Bidang,
			CASE LEN(CONVERT(Varchar, A.Kd_Unit)) WHEN 1 THEN
			'00'+ CONVERT(Varchar, A.Kd_Unit) ELSE
			RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 3) END AS Kd_Gab_Unit,
			CASE LEN(CONVERT(varchar, A.Kd_Sub)) WHEN 3 THEN 
			CONVERT(varchar, A.Kd_Sub) ELSE RIGHT('0' + CONVERT(varchar, A.Kd_Sub1), 2) END AS Kd_Gab_Sub,
			CASE LEN(CONVERT(varchar, A.Kd_UPB1)) WHEN 3 THEN 
			CONVERT(varchar, A.Kd_UPB) ELSE RIGHT('0' + CONVERT(varchar, A.Kd_UPB1), 2) END AS Kd_Gab_UPB
		FROM	Ta_KIBDR A
		WHERE	(A.Kd_Prov = @Kd_Prov OR A.Kd_Prov1 = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota OR A.Kd_Kab_Kota1 = @Kd_Kab_Kota)
			AND (A.Kd_Bidang = @Kd_Bidang OR A.Kd_Bidang1 = @Kd_Bidang) AND (A.Kd_Unit = @Kd_Unit OR A.Kd_Unit1 = @Kd_Unit)
			AND (A.Kd_Sub = @Kd_Sub OR A.Kd_Sub1 = @Kd_Sub) AND (A.Kd_UPB = @Kd_UPB OR A.Kd_UPB1 = @Kd_UPB) 
			AND A.Kd_Aset1 = @Kd_Aset1 AND A.Kd_Aset2 = @Kd_Aset2 AND A.Kd_Aset3 = @Kd_Aset3 AND A.Kd_Aset4 = @Kd_Aset4 
			AND A.Kd_Aset5 = @Kd_Aset5 AND (A.No_Register = @No_Register OR A.No_Register1 = @No_Register) AND A.Kd_Riwayat IN(3,4)
		) C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND
				A.Kd_UPB = C.Kd_UPB AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3
				AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5 INNER JOIN
		Ref_UPB D ON C.Kd_Prov = D.Kd_Prov AND C.Kd_Kab_Kota = D.Kd_Kab_Kota AND C.Kd_Bidang = D.Kd_Bidang AND C.Kd_Unit = D.Kd_Unit AND C.Kd_Sub = D.Kd_Sub AND
				C.Kd_UPB = D.Kd_UPB
	WHERE	(A.Kd_Prov = @Kd_Prov OR A.Kd_Prov1 = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota OR A.Kd_Kab_Kota1 = @Kd_Kab_Kota)
		AND (A.Kd_Bidang = @Kd_Bidang OR A.Kd_Bidang1 = @Kd_Bidang) AND (A.Kd_Unit = @Kd_Unit OR A.Kd_Unit1 = @Kd_Unit)
		AND (A.Kd_Sub = @Kd_Sub OR A.Kd_Sub1 = @Kd_Sub) AND (A.Kd_UPB = @Kd_UPB OR A.Kd_UPB1 = @Kd_UPB) 
		AND A.Kd_Aset1 = @Kd_Aset1 AND A.Kd_Aset2 = @Kd_Aset2 AND A.Kd_Aset3 = @Kd_Aset3 AND A.Kd_Aset4 = @Kd_Aset4 
		AND A.Kd_Aset5 = @Kd_Aset5 AND (A.No_Register = @No_Register OR A.No_Register1 = @No_Register) AND A.Kd_Riwayat IN(3,4)





GO
