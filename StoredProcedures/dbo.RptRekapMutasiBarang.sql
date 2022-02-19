USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** RptRekapMutasiBarang - 05012016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE [dbo].[RptRekapMutasiBarang] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), @D1 Datetime, @D2 Datetime  
WITH ENCRYPTION
AS

/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), @D1 Datetime, @D2 Datetime
SET @Tahun = '2013'
SET @Kd_Prov = '14'
SET @Kd_Kab_Kota = '4'
SET @Kd_Bidang = '5'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @D1 = '20130101'
SET @D2 = '20131231'
*/
	
	IF ISNULL(@Kd_Prov, '') = '' SET @Kd_Prov = '%'
	IF ISNULL(@Kd_Kab_Kota, '') = '' SET @Kd_Kab_Kota = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

	SELECT @Kd_Bidang AS Kd_Bidang,
		@Kd_Bidang + ' . ' + @Kd_Unit AS Kd_Unit,
		@Kd_Bidang + ' . ' + @Kd_Unit + ' . ' + @Kd_Sub AS Kd_Sub,
		@Kd_Bidang + ' . ' + @Kd_Unit + ' . ' + @Kd_Sub + ' . ' + @Kd_UPB AS Kd_UPB,
		D.Nm_Bidang, D.Nm_Unit, D.Nm_Sub_Unit, D.Nm_UPB, A.Kd_Pemilik, UPPER(A.Nm_Pemilik) AS Nm_Pemilik,
		A.Kd_Aset, A.Nm_Aset, 		 
		ISNULL(A.Jml_Awal, 0) AS Jml_Awal, ISNULL(A.Harga_Awal, 0)  AS Hrg_Awal,
		ISNULL(A.Jml_Tambah, 0) AS Jml_Tambah, ISNULL(A.Harga_Tambah, 0) AS Hrg_Tambah,
		ISNULL(A.Jml_Kurang, 0) AS Jml_Kurang, ISNULL(A.Harga_Kurang, 0) AS Hrg_Kurang,
		ISNULL(A.Jml_Awal, 0) + ISNULL(A.Jml_Tambah, 0)- ISNULL(A.Jml_Kurang, 0) AS Jml_Akhir, (ISNULL(A.Harga_Awal, 0) + ISNULL(A.Harga_Tambah, 0)- ISNULL(A.Harga_Kurang, 0))  AS Hrg_Akhir,
		E.Nm_Pemda
		
	FROM
		(
		SELECT B.Kd_Pemilik, C.Nm_Pemilik, 
			RIGHT('00' + CONVERT(varchar, A.Kd_Aset2), 2) AS Kd_Aset, UPPER(A.Nm_Aset2) AS Nm_Aset, 
			SUM(B.Jml_Awal)AS Jml_Awal, SUM(B.Harga_Awal) AS Harga_Awal, SUM(B.Jml_Tambah) AS Jml_Tambah, SUM(B.Harga_Tambah) AS Harga_Tambah, SUM(B.Jml_Kurang) AS Jml_Kurang, SUM(B.Harga_Kurang) AS Harga_Kurang
		FROM			
			Ref_Rek_Aset2 A LEFT OUTER JOIN
			(
			 SELECT B.Kd_Aset1, B.Kd_Aset2, B.Kd_Pemilik, SUM(B.Jumlah) AS Jml_Awal, SUM(B.Harga) AS Harga_Awal, 0 AS Jml_Tambah, 0 AS Harga_Tambah, 0 AS Jml_Kurang, 0 AS Harga_Kurang
			 FROM
				(
				SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik,  
					COUNT(*) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgA_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
			
				UNION ALL
			
				SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik, 
					COUNT(*) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgB_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
			
				UNION ALL
			
				SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik, 
					COUNT(*) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgC_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
			
				UNION ALL

			
				SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik,  
					COUNT(*) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgD_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
			
				UNION ALL
			
				SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik,
					COUNT(*) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgE_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
		
				UNION ALL
			
				SELECT 6 AS Kd_Aset1, 20 AS Kd_Aset2, A.Kd_Pemilik, 
					COUNT(*) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgF_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
				) B
			GROUP BY B.Kd_Aset1, B.Kd_Aset2, B.Kd_Pemilik
			  
			UNION ALL
			
			SELECT C.Kd_Aset1, C.Kd_Aset2, C.Kd_Pemilik, 0 AS Jml_Awal, 0 AS Harga_awal, SUM(C.Jumlah) AS Jml_Tambah, SUM(C.Harga) AS Harga_Tambah, 0 AS Jml_Kurang, 0 AS Harga_Kurang
			FROM
				(
				SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik,  
					SUM(A.Jml_Brg) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgA_Btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Mutasi IN(1,2,4)) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
			
				UNION ALL
			
				SELECT	A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik, 
					SUM(A.Jml_Brg) AS Jumlah, SUM(A.Harga) AS Harga
				FROM	fn_Kartu_BrgB_Btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE	(A.Kd_Mutasi IN(1,2,4)) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
			
				UNION ALL
			
				SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik, 
					SUM(A.Jml_Brg) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgC_Btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Mutasi IN(1,2,4)) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
			
				UNION ALL
			
				SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik,
					SUM(A.Jml_Brg) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgD_Btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Mutasi IN(1,2,4)) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
			
				UNION ALL
			
				SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik,
					SUM(A.Jml_Brg) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgE_Btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Mutasi IN(1,2,4)) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
			
				UNION ALL
			
				SELECT 6 AS Kd_Aset1, 20 AS Kd_Aset2, A.Kd_Pemilik, 
					COUNT(*) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgF_Btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Mutasi IN(1)) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
				) C
			GROUP BY C.Kd_Aset1, C.Kd_Aset2, C.Kd_Pemilik
			 
			UNION ALL
			
			SELECT C.Kd_Aset1, C.Kd_Aset2, C.Kd_Pemilik, 0 AS Jml_Awal, 0 AS Harga_awal, 0 AS Jml_Tambah, 0 AS Harga_Tambah, SUM(C.Jumlah) AS Jml_Kurang, SUM(C.Harga) AS Harga_Kurang
			FROM
				(
				SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik,  
					SUM(A.Jml_Brg) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgA_Btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Mutasi IN(3,5)) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
			
				UNION ALL
			
				SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik, 
					SUM(A.Jml_Brg) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgB_Btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Mutasi IN(3,5)) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
			
				UNION ALL
			
				SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik, 
					SUM(A.Jml_Brg) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgC_Btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Mutasi IN(3,5)) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
			
				UNION ALL
			
				SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik,
					SUM(A.Jml_Brg) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgD_Btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Mutasi IN(3,5)) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
			
				UNION ALL
			
				SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik,
					SUM(A.Jml_Brg) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgE_Btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Mutasi IN(3,5)) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
			
				UNION ALL
			
				SELECT 6 AS Kd_Aset1, 20 AS Kd_Aset2, A.Kd_Pemilik, 
					COUNT(*) AS Jumlah, SUM(A.Harga) AS Harga
				FROM fn_Kartu_BrgF_Btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%')  A
				WHERE (A.Kd_Mutasi IN(3)) AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
				GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Pemilik
				) C
			GROUP BY C.Kd_Aset1, C.Kd_Aset2, C.Kd_Pemilik
			
			) B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 LEFT OUTER JOIN
			Ref_Pemilik C ON B.Kd_Pemilik = C.Kd_Pemilik
		GROUP BY A.Kd_Aset2, A.Nm_Aset2, B.Kd_Pemilik, C.Nm_Pemilik
		
		) A,
		(
		SELECT MAX(F.Nm_Bidang) AS Nm_Bidang, MAX(E.Nm_Unit) AS Nm_Unit, MAX(D.Nm_Sub_Unit) AS Nm_Sub_Unit, MAX(B.Nm_UPB) AS Nm_UPB
		FROM Ta_UPB A INNER JOIN
			Ref_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub and A.Kd_UPB = B.Kd_UPB INNER JOIN
			Ta_Sub_Unit C ON A.Tahun = C.Tahun AND A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub INNER JOIN
			Ref_Sub_Unit D ON C.Kd_Prov = D.Kd_Prov AND C.Kd_Kab_Kota = D.Kd_Kab_Kota AND C.Kd_Bidang = D.Kd_Bidang AND C.Kd_Unit = D.Kd_Unit AND C.Kd_Sub = D.Kd_Sub INNER JOIN
			Ref_Unit E ON D.Kd_Prov = E.Kd_Prov AND D.Kd_Kab_Kota = E.Kd_Kab_Kota AND D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
			Ref_Bidang F ON E.Kd_Bidang = F.Kd_Bidang
		WHERE A.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
		) D,
		(
		SELECT UPPER(B.Nm_Pemda) AS Nm_Pemda, B.Logo
		FROM Ta_Pemda A INNER JOIN
		     Ref_PEMDA B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota
		WHERE A.Tahun = @Tahun AND (A.Kd_Prov LIKE @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota)
		) E
	WHERE A.Kd_Pemilik IS NOT NULL
	ORDER BY  A.Kd_Aset






GO
