USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.Rpt108Kartu_Brg @Tahun varchar(4), @Kd_Pemilik Varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
		@Kd_Aset varchar(3), @Kd_Aset0 varchar(3),@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4)
WITH ENCRYPTION
AS

/*
DECLARE @Tahun varchar(4), @Kd_Pemilik Varchar(3), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset varchar(3), @Kd_Aset0 varchar(3),@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4)
SET @Tahun = '2019'
SET @Kd_Pemilik	= '12'
SET @Kd_Prov = '30'
SET @Kd_Kab_Kota = '2'
SET @Kd_Bidang = '6'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset	= '1'
SET @Kd_Aset0	= '3'
SET @Kd_Aset1	= '3'
SET @Kd_Aset2	= '1'
SET @Kd_Aset3	= '1'
SET @Kd_Aset4	= '18'
SET @Kd_Aset5	= '1'
SET @No_Register = '1'
--*/

----------------------------------------------------------------------

IF @Kd_Aset = '1' AND @Kd_Aset0 = '3' AND @Kd_Aset1 = '1' 
BEGIN
	SELECT A.Kd_Gab_UPB, A.Nm_UPB, Max(A.Nm_Sub_Unit) AS Nm_Sub_Unit,
		A.Kd_AsetGab,A.Nm_Aset5, A.No_Register, A.Alamat, 
		B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Tgl_Dok, ISNULL (B.No_Dokumen, '-') AS No_Dokumen, B.Kd_Riwayat, B.Uraian, 
		B.No_Register AS No_RegisterB, B.Kd_ASet,B.Kd_ASet0,B.Kd_ASet1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, 
		B.Nilai, B.Luas, B.Masa, B.Nilai_Sisa, B.Keterangan

	FROM
		(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, F.Nm_Sub_Unit,
			A.Kd_Gab_Bidang + '.' + A.Kd_Gab_Unit + '.' +  A.Kd_Gab_Sub +'.' + A.Kd_Gab_UPB AS Kd_Gab_UPB, A.Nm_UPB,
			CONVERT(varchar, B.Kd_Aset) + '.' + CONVERT(varchar, B.Kd_Aset0) + '.' + CONVERT(varchar, B.Kd_Aset1) + '.' + CONVERT(varchar, B.Kd_Aset2) + '.' + CONVERT(varchar, B.Kd_Aset3) + 
			'.' + RIGHT('0' + CONVERT(varchar, B.Kd_Aset4), 2) + '.' + RIGHT('0' + CONVERT(varchar, B.Kd_Aset5), 2) AS Kd_AsetGab,
			E.Nm_Aset5, B.No_Register, F.Alamat
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
			(SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
					A.Kd_Aset8 AS Kd_ASet,A.Kd_Aset80 AS Kd_ASet0,A.Kd_Aset81 AS Kd_ASet1, A.Kd_Aset82 AS Kd_Aset2, 
					A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Reg8 AS No_Register
			FROM Ta_KIB_A A) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB LEFT OUTER JOIN
			Ref_Rek5_108 E ON B.Kd_Aset = E.Kd_Aset AND B.Kd_Aset0 = E.Kd_Aset0 AND B.Kd_Aset1 = E.Kd_Aset1 AND B.Kd_Aset2 = E.Kd_Aset2 AND B.Kd_Aset3 = E.Kd_Aset3 AND B.Kd_Aset4 = E.Kd_Aset4 AND B.Kd_Aset5 = E.Kd_Aset5 LEFT OUTER JOIN
			(
				SELECT 	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, Max(C.Nm_Sub_Unit) AS Nm_Sub_Unit, B.Alamat
				FROM	Ta_UPB A INNER JOIN
					Ta_Sub_Unit B ON A.Tahun = B.Tahun AND A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND
						A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub INNER JOIN
					Ref_Sub_Unit C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND
						A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub
				WHERE	B.Tahun = @Tahun AND
				A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND
				A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB 
				Group by A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, B.Alamat, B.Tahun
			) F ON B.Kd_Prov = F.Kd_Prov AND B.Kd_Kab_Kota = F.Kd_Kab_Kota AND B.Kd_Bidang = F.Kd_Bidang AND
			B.Kd_Unit = F.Kd_Unit AND B.Kd_Sub = F.Kd_Sub AND B.Kd_UPB = F.Kd_UPB
		WHERE	B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang = @Kd_Bidang AND B.Kd_Unit = @Kd_Unit AND
		B.Kd_Sub = @Kd_Sub AND B.Kd_UPB = @Kd_UPB AND 
		B.Kd_Aset = @Kd_Aset AND B.Kd_Aset0 = @Kd_Aset0 AND  B.Kd_Aset1 = @Kd_Aset1 AND B.Kd_Aset2 = @Kd_Aset2 AND B.Kd_Aset3 = @Kd_Aset3 AND
		B.Kd_Aset4 = @Kd_Aset4 AND B.Kd_Aset5 = @Kd_Aset5 AND B.No_Register = @No_Register
		) A
		INNER JOIN
(SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, A.Uraian, 
		A.No_Register, A.Kd_ASet, A.Kd_ASet0, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
		A.Nilai, A.Luas, '' AS Masa, A.Nilai_Sisa, A.Keterangan
  FROM
		(
			SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Pembukuan AS Tgl_Dok, A.Sertifikat_Nomor AS No_Dokumen, '' AS Kd_Riwayat, 'Harga Perolehan' AS Uraian, 
				A.No_Reg8 AS No_Register, A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, 
				A.Harga AS Nilai, A.Luas_M2 AS Luas, '' AS Masa, '' AS Nilai_Sisa, A.Keterangan
			FROM	Ta_KIB_A A
			WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Reg8 = @No_Register
		
			UNION ALL
	
			SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, B.Nm_Riwayat AS Uraian, 
				A.No_Register, A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
				A.Harga AS Nilai, A.Luas_M2 AS Luas, '' AS Masa, '' AS Nilai_Sisa, A.Keterangan
			FROM	Ta_KIBAR A INNER JOIN
				Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
			WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register
				AND A.Kd_Riwayat = 2
		
			UNION ALL

			SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, B.Nm_Riwayat AS Uraian, 
				A.No_Register, A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
				A.Harga AS Nilai, A.Luas_M2 AS Luas, '' AS Masa, '' AS Nilai_Sisa, A.Keterangan
			FROM	Ta_KIBAR A INNER JOIN
				Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
			WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register
				AND A.Kd_Riwayat = 7
			
			UNION ALL

			SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, B.Nm_Riwayat AS Uraian, 
				A.No_Register, A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
				A.Harga AS Nilai, A.Luas_M2 AS Luas, '' AS Masa, '' AS Nilai_Sisa, A.Keterangan
			FROM	Ta_KIBAR A INNER JOIN
					Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
			WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register
				AND A.Kd_Riwayat = 21
		)A
	) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit
			AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
	GROUP BY A.Kd_Gab_UPB, A.Nm_UPB,
		A.Kd_AsetGab,
		A.Nm_Aset5, A.No_Register, A.Alamat, 
		B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Tgl_Dok, B.No_Dokumen, B.Kd_Riwayat, B.Uraian, 
		B.No_Register, B.Kd_ASet, B.Kd_ASet0, B.Kd_ASet1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.Nilai, B.Luas, B.Masa, B.Nilai_Sisa, B.Keterangan
END


IF @Kd_Aset = '1' AND @Kd_Aset0 = '3' AND @Kd_Aset1 = '2' 
BEGIN
	SELECT A.Kd_Gab_UPB, A.Nm_UPB, Max(A.Nm_Sub_Unit) AS Nm_Sub_Unit,
		A.Kd_AsetGab,A.Nm_Aset5, A.No_Register, A.Alamat, 
		B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Tgl_Dok, ISNULL (B.No_Dokumen, '-') AS No_Dokumen, B.Kd_Riwayat, B.Uraian, 
		B.No_Register AS No_RegisterB, B.Kd_ASet,B.Kd_ASet0,B.Kd_ASet1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, 
		B.Nilai, B.Luas, B.Masa, B.Nilai_Sisa, B.Keterangan

	FROM
		(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, F.Nm_Sub_Unit,
			A.Kd_Gab_Bidang + '.' + A.Kd_Gab_Unit + '.' +  A.Kd_Gab_Sub +'.' + A.Kd_Gab_UPB AS Kd_Gab_UPB, A.Nm_UPB,
			CONVERT(varchar, B.Kd_Aset) + '.' + CONVERT(varchar, B.Kd_Aset0) + '.' + CONVERT(varchar, B.Kd_Aset1) + '.' + CONVERT(varchar, B.Kd_Aset2) + '.' + CONVERT(varchar, B.Kd_Aset3) + 
			'.' + RIGHT('0' + CONVERT(varchar, B.Kd_Aset4), 2) + '.' + RIGHT('0' + CONVERT(varchar, B.Kd_Aset5), 2) AS Kd_AsetGab,
			E.Nm_Aset5, B.No_Register, F.Alamat
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
			(SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
					A.Kd_Aset8 AS Kd_ASet,A.Kd_Aset80 AS Kd_ASet0,A.Kd_Aset81 AS Kd_ASet1, A.Kd_Aset82 AS Kd_Aset2, 
					A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Reg8 AS No_Register
			FROM Ta_KIB_B A) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB LEFT OUTER JOIN
			Ref_Rek5_108 E ON B.Kd_Aset = E.Kd_Aset AND B.Kd_Aset0 = E.Kd_Aset0 AND B.Kd_Aset1 = E.Kd_Aset1 AND B.Kd_Aset2 = E.Kd_Aset2 AND B.Kd_Aset3 = E.Kd_Aset3 AND B.Kd_Aset4 = E.Kd_Aset4 AND B.Kd_Aset5 = E.Kd_Aset5 LEFT OUTER JOIN
			(
				SELECT 	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, Max(C.Nm_Sub_Unit) AS Nm_Sub_Unit, B.Alamat
				FROM	Ta_UPB A INNER JOIN
					Ta_Sub_Unit B ON A.Tahun = B.Tahun AND A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND
						A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub INNER JOIN
					Ref_Sub_Unit C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND
						A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub
				WHERE	B.Tahun = @Tahun AND
				A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND
				A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB 
				Group by A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, B.Alamat, B.Tahun
			) F ON B.Kd_Prov = F.Kd_Prov AND B.Kd_Kab_Kota = F.Kd_Kab_Kota AND B.Kd_Bidang = F.Kd_Bidang AND
			B.Kd_Unit = F.Kd_Unit AND B.Kd_Sub = F.Kd_Sub AND B.Kd_UPB = F.Kd_UPB
		WHERE	B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang = @Kd_Bidang AND B.Kd_Unit = @Kd_Unit AND
		B.Kd_Sub = @Kd_Sub AND B.Kd_UPB = @Kd_UPB AND 
		B.Kd_Aset = @Kd_Aset AND B.Kd_Aset0 = @Kd_Aset0 AND  B.Kd_Aset1 = @Kd_Aset1 AND B.Kd_Aset2 = @Kd_Aset2 AND B.Kd_Aset3 = @Kd_Aset3 AND
		B.Kd_Aset4 = @Kd_Aset4 AND B.Kd_Aset5 = @Kd_Aset5 AND B.No_Register = @No_Register
		) A
		INNER JOIN
	(SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, A.Uraian, 
			A.No_Register, A.Kd_ASet, A.Kd_ASet0, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
			A.Nilai, A.Luas, A.Masa, A.Nilai_Sisa, A.Keterangan
	 FROM
		(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Pembukuan AS Tgl_Dok, A.Nomor_Polisi AS No_Dokumen, '' AS Kd_Riwayat, 'Harga Perolehan' AS Uraian, 
			A.No_Reg8 AS No_Register, A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Merk AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIB_B A
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Reg8 = @No_Register
		
		UNION ALL
	
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, B.Nm_Riwayat AS Uraian, 
			A.No_Register, A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Merk AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIBBR A INNER JOIN
			Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register
				AND A.Kd_Riwayat = 2
		
		UNION ALL

		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, B.Nm_Riwayat AS Uraian, 
			A.No_Register, A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Merk AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIBBR A INNER JOIN
			Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register
			AND A.Kd_Riwayat = 7
		
		UNION ALL

		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, B.Nm_Riwayat AS Uraian, 
			A.No_Register, A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Merk AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIBBR A INNER JOIN
			Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register
			AND A.Kd_Riwayat = 21
		)A
	) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit
			AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
	GROUP BY A.Kd_Gab_UPB, A.Nm_UPB,
		A.Kd_AsetGab,
		A.Nm_Aset5, A.No_Register, A.Alamat, 
		B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Tgl_Dok, B.No_Dokumen, B.Kd_Riwayat, B.Uraian, 
		B.No_Register, B.Kd_ASet, B.Kd_ASet0, B.Kd_ASet1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.Nilai, B.Luas, B.Masa, B.Nilai_Sisa, B.Keterangan
END


IF @Kd_Aset = '1' AND @Kd_Aset0 = '3' AND @Kd_Aset1 = '3' 
BEGIN
	SELECT A.Kd_Gab_UPB, A.Nm_UPB, Max(A.Nm_Sub_Unit) AS Nm_Sub_Unit,
		A.Kd_AsetGab,A.Nm_Aset5, A.No_Register, A.Alamat, 
		B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Tgl_Dok, ISNULL (B.No_Dokumen, '-') AS No_Dokumen, B.Kd_Riwayat, B.Uraian, 
		B.No_Register AS No_RegisterB, B.Kd_ASet,B.Kd_ASet0,B.Kd_ASet1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, 
		B.Nilai, B.Luas, B.Masa, B.Nilai_Sisa, B.Keterangan

	FROM
		(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, F.Nm_Sub_Unit,
			A.Kd_Gab_Bidang + '.' + A.Kd_Gab_Unit + '.' +  A.Kd_Gab_Sub +'.' + A.Kd_Gab_UPB AS Kd_Gab_UPB, A.Nm_UPB,
			CONVERT(varchar, B.Kd_Aset) + '.' + CONVERT(varchar, B.Kd_Aset0) + '.' + CONVERT(varchar, B.Kd_Aset1) + '.' + CONVERT(varchar, B.Kd_Aset2) + '.' + CONVERT(varchar, B.Kd_Aset3) + 
			'.' + RIGHT('0' + CONVERT(varchar, B.Kd_Aset4), 2) + '.' + RIGHT('0' + CONVERT(varchar, B.Kd_Aset5), 2) AS Kd_AsetGab,
			E.Nm_Aset5, B.No_Register, F.Alamat
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
			(SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
					A.Kd_Aset8 AS Kd_ASet,A.Kd_Aset80 AS Kd_ASet0,A.Kd_Aset81 AS Kd_ASet1, A.Kd_Aset82 AS Kd_Aset2, 
					A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Reg8 AS No_Register
			FROM Ta_KIB_C A) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB LEFT OUTER JOIN
			Ref_Rek5_108 E ON B.Kd_Aset = E.Kd_Aset AND B.Kd_Aset0 = E.Kd_Aset0 AND B.Kd_Aset1 = E.Kd_Aset1 AND B.Kd_Aset2 = E.Kd_Aset2 AND B.Kd_Aset3 = E.Kd_Aset3 AND B.Kd_Aset4 = E.Kd_Aset4 AND B.Kd_Aset5 = E.Kd_Aset5 LEFT OUTER JOIN
			(
				SELECT 	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, Max(C.Nm_Sub_Unit) AS Nm_Sub_Unit, B.Alamat
				FROM	Ta_UPB A INNER JOIN
					Ta_Sub_Unit B ON A.Tahun = B.Tahun AND A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND
						A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub INNER JOIN
					Ref_Sub_Unit C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND
						A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub
				WHERE	B.Tahun = @Tahun AND
				A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND
				A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB 
				Group by A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, B.Alamat, B.Tahun
			) F ON B.Kd_Prov = F.Kd_Prov AND B.Kd_Kab_Kota = F.Kd_Kab_Kota AND B.Kd_Bidang = F.Kd_Bidang AND
			B.Kd_Unit = F.Kd_Unit AND B.Kd_Sub = F.Kd_Sub AND B.Kd_UPB = F.Kd_UPB
		WHERE	B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang = @Kd_Bidang AND B.Kd_Unit = @Kd_Unit AND
		B.Kd_Sub = @Kd_Sub AND B.Kd_UPB = @Kd_UPB AND 
		B.Kd_Aset = @Kd_Aset AND B.Kd_Aset0 = @Kd_Aset0 AND  B.Kd_Aset1 = @Kd_Aset1 AND B.Kd_Aset2 = @Kd_Aset2 AND B.Kd_Aset3 = @Kd_Aset3 AND
		B.Kd_Aset4 = @Kd_Aset4 AND B.Kd_Aset5 = @Kd_Aset5 AND B.No_Register = @No_Register
		) A
		INNER JOIN
	(SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, A.Uraian, 
			A.No_Register, A.Kd_ASet, A.Kd_ASet0, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
			A.Nilai, A.Luas, A.Masa, A.Nilai_Sisa, A.Keterangan
	 FROM
		(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Tgl_Pembukuan AS Tgl_Dok, '' AS No_Dokumen, '' AS Kd_Riwayat, 'Harga Perolehan' AS Uraian, 
			A.No_Reg8 AS No_Register, 
			A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Luas_Lantai AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIB_C A
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
			A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Reg8 = @No_Register
		
		UNION ALL
	
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, B.Nm_Riwayat AS Uraian, 
			A.No_Register, A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Luas_Lantai AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIBCR A INNER JOIN
			Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register			
				AND A.Kd_Riwayat = 2
		
		UNION ALL

		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, B.Nm_Riwayat AS Uraian, 
			A.No_Register, A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Luas_Lantai AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIBCR A INNER JOIN
			Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register			
				AND A.Kd_Riwayat = 7
				
		UNION ALL

		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, B.Nm_Riwayat AS Uraian, 
			A.No_Register, A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Luas_Lantai AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIBCR A INNER JOIN
			Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register			
				AND A.Kd_Riwayat = 21
		)A
	) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit
			AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
	GROUP BY A.Kd_Gab_UPB, A.Nm_UPB,
		A.Kd_AsetGab,
		A.Nm_Aset5, A.No_Register, A.Alamat, 
		B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Tgl_Dok, B.No_Dokumen, B.Kd_Riwayat, B.Uraian, 
		B.No_Register, B.Kd_ASet, B.Kd_ASet0, B.Kd_ASet1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.Nilai, B.Luas, B.Masa, B.Nilai_Sisa, B.Keterangan
END




IF @Kd_Aset = '1' AND @Kd_Aset0 = '3' AND @Kd_Aset1 = '4' 
BEGIN
	SELECT A.Kd_Gab_UPB, A.Nm_UPB, Max(A.Nm_Sub_Unit) AS Nm_Sub_Unit,
		A.Kd_AsetGab,A.Nm_Aset5, A.No_Register, A.Alamat, 
		B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Tgl_Dok, ISNULL (B.No_Dokumen, '-') AS No_Dokumen, B.Kd_Riwayat, B.Uraian, 
		B.No_Register AS No_RegisterB, B.Kd_ASet,B.Kd_ASet0,B.Kd_ASet1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, 
		B.Nilai, B.Luas, B.Masa, B.Nilai_Sisa, B.Keterangan

	FROM
		(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, F.Nm_Sub_Unit,
			A.Kd_Gab_Bidang + '.' + A.Kd_Gab_Unit + '.' +  A.Kd_Gab_Sub +'.' + A.Kd_Gab_UPB AS Kd_Gab_UPB, A.Nm_UPB,
			CONVERT(varchar, B.Kd_Aset) + '.' + CONVERT(varchar, B.Kd_Aset0) + '.' + CONVERT(varchar, B.Kd_Aset1) + '.' + CONVERT(varchar, B.Kd_Aset2) + '.' + CONVERT(varchar, B.Kd_Aset3) + 
			'.' + RIGHT('0' + CONVERT(varchar, B.Kd_Aset4), 2) + '.' + RIGHT('0' + CONVERT(varchar, B.Kd_Aset5), 2) AS Kd_AsetGab,
			E.Nm_Aset5, B.No_Register, F.Alamat
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
			(SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
					A.Kd_Aset8 AS Kd_ASet,A.Kd_Aset80 AS Kd_ASet0,A.Kd_Aset81 AS Kd_ASet1, A.Kd_Aset82 AS Kd_Aset2, 
					A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Reg8 AS No_Register
			FROM Ta_KIB_D A) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB LEFT OUTER JOIN
			Ref_Rek5_108 E ON B.Kd_Aset = E.Kd_Aset AND B.Kd_Aset0 = E.Kd_Aset0 AND B.Kd_Aset1 = E.Kd_Aset1 AND B.Kd_Aset2 = E.Kd_Aset2 AND B.Kd_Aset3 = E.Kd_Aset3 AND B.Kd_Aset4 = E.Kd_Aset4 AND B.Kd_Aset5 = E.Kd_Aset5 LEFT OUTER JOIN
			(
				SELECT 	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, Max(C.Nm_Sub_Unit) AS Nm_Sub_Unit, B.Alamat
				FROM	Ta_UPB A INNER JOIN
					Ta_Sub_Unit B ON A.Tahun = B.Tahun AND A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND
						A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub INNER JOIN
					Ref_Sub_Unit C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND
						A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub
				WHERE	B.Tahun = @Tahun AND
				A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND
				A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB 
				Group by A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, B.Alamat, B.Tahun
			) F ON B.Kd_Prov = F.Kd_Prov AND B.Kd_Kab_Kota = F.Kd_Kab_Kota AND B.Kd_Bidang = F.Kd_Bidang AND
			B.Kd_Unit = F.Kd_Unit AND B.Kd_Sub = F.Kd_Sub AND B.Kd_UPB = F.Kd_UPB
		WHERE	B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang = @Kd_Bidang AND B.Kd_Unit = @Kd_Unit AND
		B.Kd_Sub = @Kd_Sub AND B.Kd_UPB = @Kd_UPB AND 
		B.Kd_Aset = @Kd_Aset AND B.Kd_Aset0 = @Kd_Aset0 AND  B.Kd_Aset1 = @Kd_Aset1 AND B.Kd_Aset2 = @Kd_Aset2 AND B.Kd_Aset3 = @Kd_Aset3 AND
		B.Kd_Aset4 = @Kd_Aset4 AND B.Kd_Aset5 = @Kd_Aset5 AND B.No_Register = @No_Register
		) A
		INNER JOIN
	(SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, A.Uraian, 
			A.No_Register, A.Kd_ASet, A.Kd_ASet0, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
			A.Nilai, A.Luas, A.Masa, A.Nilai_Sisa, A.Keterangan
	 FROM
		(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Tgl_Pembukuan AS Tgl_Dok, A.Dokumen_Nomor AS No_Dokumen, '' AS Kd_Riwayat, 'Harga Perolehan' AS Uraian, 
			A.No_Reg8 AS No_Register, 
			A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Panjang AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIB_D A
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Reg8 = @No_Register			
		
		UNION ALL
	
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, B.Nm_Riwayat AS Uraian, 
			A.No_Register,A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Panjang AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIBDR A INNER JOIN
			Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register			
				AND A.Kd_Riwayat = 2
		
		UNION ALL

		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, B.Nm_Riwayat AS Uraian, 
			A.No_Register, A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Panjang AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIBDR A INNER JOIN
			Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register			
				AND A.Kd_Riwayat = 7
		
		UNION ALL

		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, B.Nm_Riwayat AS Uraian, 
			A.No_Register, A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Panjang AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIBDR A INNER JOIN
			Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register			
			AND A.Kd_Riwayat = 21
		)A
	) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit
			AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
	GROUP BY A.Kd_Gab_UPB, A.Nm_UPB,
		A.Kd_AsetGab,
		A.Nm_Aset5, A.No_Register, A.Alamat, 
		B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Tgl_Dok, B.No_Dokumen, B.Kd_Riwayat, B.Uraian, 
		B.No_Register, B.Kd_ASet, B.Kd_ASet0, B.Kd_ASet1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.Nilai, B.Luas, B.Masa, B.Nilai_Sisa, B.Keterangan
END



IF @Kd_Aset = '1' AND @Kd_Aset0 = '3' AND @Kd_Aset1 = '5' 
BEGIN
	SELECT A.Kd_Gab_UPB, A.Nm_UPB, Max(A.Nm_Sub_Unit) AS Nm_Sub_Unit,
		A.Kd_AsetGab,A.Nm_Aset5, A.No_Register, A.Alamat, 
		B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Tgl_Dok, ISNULL (B.No_Dokumen, '-') AS No_Dokumen, B.Kd_Riwayat, B.Uraian, 
		B.No_Register AS No_RegisterB, B.Kd_ASet,B.Kd_ASet0,B.Kd_ASet1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, 
		B.Nilai, B.Luas, B.Masa, B.Nilai_Sisa, B.Keterangan

	FROM
		(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, F.Nm_Sub_Unit,
			A.Kd_Gab_Bidang + '.' + A.Kd_Gab_Unit + '.' +  A.Kd_Gab_Sub +'.' + A.Kd_Gab_UPB AS Kd_Gab_UPB, A.Nm_UPB,
			CONVERT(varchar, B.Kd_Aset) + '.' + CONVERT(varchar, B.Kd_Aset0) + '.' + CONVERT(varchar, B.Kd_Aset1) + '.' + CONVERT(varchar, B.Kd_Aset2) + '.' + CONVERT(varchar, B.Kd_Aset3) + 
			'.' + RIGHT('0' + CONVERT(varchar, B.Kd_Aset4), 2) + '.' + RIGHT('0' + CONVERT(varchar, B.Kd_Aset5), 2) AS Kd_AsetGab,
			E.Nm_Aset5, B.No_Register, F.Alamat
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
			(SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
					A.Kd_Aset8 AS Kd_ASet,A.Kd_Aset80 AS Kd_ASet0,A.Kd_Aset81 AS Kd_ASet1, A.Kd_Aset82 AS Kd_Aset2, 
					A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Reg8 AS No_Register
			FROM Ta_KIB_E A) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND
				A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB LEFT OUTER JOIN
			Ref_Rek5_108 E ON B.Kd_Aset = E.Kd_Aset AND B.Kd_Aset0 = E.Kd_Aset0 AND B.Kd_Aset1 = E.Kd_Aset1 AND B.Kd_Aset2 = E.Kd_Aset2 AND B.Kd_Aset3 = E.Kd_Aset3 AND B.Kd_Aset4 = E.Kd_Aset4 AND B.Kd_Aset5 = E.Kd_Aset5 LEFT OUTER JOIN
			(
				SELECT 	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, Max(C.Nm_Sub_Unit) AS Nm_Sub_Unit, B.Alamat
				FROM	Ta_UPB A INNER JOIN
					Ta_Sub_Unit B ON A.Tahun = B.Tahun AND A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND
						A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub INNER JOIN
					Ref_Sub_Unit C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND
						A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub
				WHERE	B.Tahun = @Tahun AND
				A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND
				A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB 
				Group by A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, B.Alamat, B.Tahun
			) F ON B.Kd_Prov = F.Kd_Prov AND B.Kd_Kab_Kota = F.Kd_Kab_Kota AND B.Kd_Bidang = F.Kd_Bidang AND
			B.Kd_Unit = F.Kd_Unit AND B.Kd_Sub = F.Kd_Sub AND B.Kd_UPB = F.Kd_UPB
		WHERE	B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang = @Kd_Bidang AND B.Kd_Unit = @Kd_Unit AND
		B.Kd_Sub = @Kd_Sub AND B.Kd_UPB = @Kd_UPB AND 
		B.Kd_Aset = @Kd_Aset AND B.Kd_Aset0 = @Kd_Aset0 AND  B.Kd_Aset1 = @Kd_Aset1 AND B.Kd_Aset2 = @Kd_Aset2 AND B.Kd_Aset3 = @Kd_Aset3 AND
		B.Kd_Aset4 = @Kd_Aset4 AND B.Kd_Aset5 = @Kd_Aset5 AND B.No_Register = @No_Register
		) A
		INNER JOIN
	(SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, A.Uraian, 
			A.No_Register, A.Kd_ASet, A.Kd_ASet0, A.Kd_ASet1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
			A.Nilai, A.Luas, A.Masa, A.Nilai_Sisa, A.Keterangan
	 FROM
		(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Tgl_Pembukuan AS Tgl_Dok, A.Judul AS No_Dokumen, '' AS Kd_Riwayat, 'Harga Perolehan' AS Uraian, 
			A.No_Reg8 AS No_Register, 
			A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Judul AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIB_E A
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register			
			AND A.No_Reg8 = @No_Register
		
		UNION ALL
	
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, B.Nm_Riwayat AS Uraian, 
			A.No_Register, 
			A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Judul AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIBER A INNER JOIN
			Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register			
				AND A.Kd_Riwayat = 2
		
		UNION ALL

		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, B.Nm_Riwayat AS Uraian, 
			A.No_Register, 
			A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Judul AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIBER A INNER JOIN
			Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register			
				AND A.Kd_Riwayat = 7
		
		UNION ALL

		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Dokumen AS Tgl_Dok, A.No_Dokumen, A.Kd_Riwayat, B.Nm_Riwayat AS Uraian, 
			A.No_Register, 
			A.Kd_ASet8 AS Kd_Aset,A.Kd_ASet80 AS Kd_Aset0,A.Kd_ASet81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5,
			A.Harga AS Nilai, A.Judul AS Luas, A.Masa_Manfaat AS Masa, A.Nilai_Sisa, A.Keterangan
		FROM	Ta_KIBER A INNER JOIN
			Ref_Riwayat B ON A.Kd_Riwayat = B.Kd_Riwayat
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND
				A.Kd_Aset8 = @Kd_Aset AND A.Kd_Aset80 = @Kd_Aset0 AND A.Kd_Aset81 = @Kd_Aset1 AND A.Kd_Aset82 = @Kd_Aset2 AND A.Kd_Aset83 = @Kd_Aset3 
				AND A.Kd_Aset84 = @Kd_Aset4 AND A.Kd_Aset85 = @Kd_Aset5 AND A.No_Register = @No_Register			
			AND A.Kd_Riwayat = 21
		)A
	) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit
			AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
	GROUP BY A.Kd_Gab_UPB, A.Nm_UPB,
		A.Kd_AsetGab,
		A.Nm_Aset5, A.No_Register, A.Alamat, 
		B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Tgl_Dok, B.No_Dokumen, B.Kd_Riwayat, B.Uraian, 
		B.No_Register, B.Kd_ASet, B.Kd_ASet0, B.Kd_ASet1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, B.Nilai, B.Luas, B.Masa, B.Nilai_Sisa, B.Keterangan
END




GO
