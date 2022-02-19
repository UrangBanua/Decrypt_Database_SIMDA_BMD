USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE dbo.RptSaldo_Mutasi @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), 
	@Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3),	@D1 datetime, @KM varchar(1)

WITH ENCRYPTION
AS

/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @D1 datetime, @KM varchar(1)

	
SET @Tahun = '2018'
SET @Kd_Prov = '13'
SET @Kd_Kab_Kota = '22'
SET @Kd_Bidang = '4'
SET @Kd_Unit = '3'
SET @Kd_Sub = '3'
SET @Kd_UPB = '3'
SET @Kd_Aset1 = ''
SET @Kd_Aset2 = ''
SET @Kd_Aset3 = ''
SET @Kd_Aset4 = ''
SET @D1= '20181231'
SET @KM = '1' 
--1 = keluar
--2 = masuk
--*/
DECLARE @JLap Tinyint SET @JLap = 1

IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
IF ISNULL(@Kd_Aset1, '') = '' SET @Kd_Aset1 = '%'
IF ISNULL(@Kd_Aset2, '') = '' SET @Kd_Aset2 = '%'
IF ISNULL(@Kd_Aset3, '') = '' SET @Kd_Aset3 = '%'
IF ISNULL(@Kd_Aset4, '') = '' SET @Kd_Aset4 = '%'
	

IF @KM = '1' 
BEGIN
SELECT  A.Jndt, A.Kd_Prov, C.Nm_Provinsi, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB,
	A.Kd_Aset1, B.Nm_Aset1, A.Kd_Aset2, B.Nm_Aset2, A.Kd_Aset3, B.Nm_Aset3, A.Kd_Aset4, B.Nm_Aset4, A.Kd_Aset5, B.Nm_Aset5, 
	CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)AS Kd_Aset_Gab2,    
	CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)AS Kd_Aset_Gab3,     
	CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4)AS Kd_Aset_Gab4,     
	CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4)+'.'+CONVERT(varchar, A.Kd_Aset5)AS Kd_Aset_Gab5,     
	YEAR (@D1) AS THN_SBLM, A.No_Register, A.Tgl_Perolehan, MONTH (A.Tgl_Perolehan) AS Bulan1, YEAR (A.Tgl_Perolehan) AS Tahun, CONVERT(varchar, A.Sisa_Umur / 12) AS Thn, A.Sisa_Umur % 12 AS Bln,
	A.Nilai_Susut1, A.Nilai_Susut2, SUM (A.Nilai_Susut1 + A.Nilai_Susut2) AS Nilai_susut,
	A.Akum_susut, A.Nilai_Sisa,
       A.Harga AS Nilai_Perolehan, 
       (ISNULL(A.Akum_Susut,0)) - (ISNULL(A.Nilai_Susut1,0)) - (ISNULL(A.Nilai_Susut2,0)) AS AKP_Awal, 
       (ISNULL(A.Nilai_Susut1,0)) + (ISNULL(A.Nilai_Susut2,0))AS Penyusutan, ISNULL(A.Akum_Susut,0) AS AKP_Akhir,
	A.Harga - ISNULL(A.Akum_Susut,0) AS Nilai_Buku, 
	A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, dbo.fn_GabUPB (A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1) AS Kd_UPB_Tujuan, D.Nm_UPB AS Nm_UPB_Tujuan

FROM (
	
	SELECT 0 AS Jndt, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
	        A.Harga,0 AS Nilai_Susut1, 0 AS Nilai_Susut2, --0 AS Nilai_susut,
		0 AS Akum_Susut, 0 AS Nilai_Sisa, 0 AS Sisa_Umur, 
		A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
	FROM Ta_KIBAR A LEFT OUTER JOIN
		fn_Kartu_BrgA(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap ) B 
			ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota= B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.KD_UPB = B.KD_UPB 
	WHERE YEAR (A.TGL_Dokumen) = @TAHUN
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
	           A.Harga, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1

	UNION ALL
	
	SELECT C.Jndt, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
	         	C.Harga AS Harga,
			C.Nilai_Susut1 AS Nilai_Susut1, C.Nilai_Susut2 AS Nilai_Susut2, --SUM (C.Nilai_susut1 + C.Nilai_susut2) AS Nilai_susut,
			C.Akum_Susut AS Akum_Susut, C.Nilai_Sisa AS Nilai_Sisa, C.Sisa_Umur AS Sisa_Umur,
			A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
	FROM Ta_KIBBR A INNER JOIN
		fn_UPB_B(@Tahun,@D1,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4) B 
			ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota= B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.KD_UPB = B.KD_UPB 
			INNER JOIN
		(SELECT Tahun, IDPemda, Jndt, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur FROM Ta_SusutB) C ON A.IDPemda = C.IDPemda
      		   WHERE Kd_Alasan = 105 AND Kd_Riwayat = 3 AND YEAR(Tgl_Dokumen) = @Tahun
			AND C.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
	      		A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB /*AND A.Tgl_Pembukuan <= @D1*/ AND NOT (C.Jndt = 1 AND Nilai_Susut1 = 0 AND C.IDPemda IS NULL)
			AND YEAR (A.TGL_Dokumen) = @TAHUN
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
	           C.Harga, C.Nilai_Susut1, C.Nilai_Susut2, C.Akum_Susut, C.Nilai_Sisa, C.Sisa_Umur, C.Jndt,
	           A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1


	UNION ALL

	SELECT C.Jndt, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
	         	C.Harga AS Harga,
			C.Nilai_Susut1 AS Nilai_Susut1, C.Nilai_Susut2 AS Nilai_Susut2, --SUM (C.Nilai_susut1 + C.Nilai_susut2) AS Nilai_susut,
			C.Akum_Susut AS Akum_Susut, C.Nilai_Sisa AS Nilai_Sisa, C.Sisa_Umur AS Sisa_Umur,
			A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
	FROM Ta_KIBCR A INNER JOIN
		fn_UPB_C(@Tahun,@D1,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4) B 
			ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota= B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.KD_UPB = B.KD_UPB 
			INNER JOIN
		(SELECT Tahun, IDPemda, Jndt, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur FROM Ta_SusutC) C ON A.IDPemda = C.IDPemda
      		   WHERE Kd_Alasan = 105 AND Kd_Riwayat = 3 AND YEAR(Tgl_Dokumen) = @Tahun
			AND C.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
	      		A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND NOT (C.Jndt = 1 AND Nilai_Susut1 = 0 AND C.IDPemda IS NULL)
			AND  YEAR (A.TGL_Dokumen) = @TAHUN
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
	           C.Harga, C.Nilai_Susut1, C.Nilai_Susut2, C.Akum_Susut, C.Nilai_Sisa, C.Sisa_Umur, C.Jndt,
	           A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1


	UNION ALL

	SELECT C.Jndt, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
	         	C.Harga AS Harga,
			C.Nilai_Susut1 AS Nilai_Susut1, C.Nilai_Susut2 AS Nilai_Susut2,-- SUM (C.Nilai_susut1 + C.Nilai_susut2) AS Nilai_susut,
			C.Akum_Susut AS Akum_Susut, C.Nilai_Sisa AS Nilai_Sisa, C.Sisa_Umur AS Sisa_Umur,
			A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
	FROM Ta_KIBDR A INNER JOIN
		fn_UPB_D(@Tahun,@D1,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4) B 
			ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota= B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.KD_UPB = B.KD_UPB 
			INNER JOIN
		(SELECT Tahun, IDPemda, Jndt, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur FROM Ta_SusutD) C ON A.IDPemda = C.IDPemda
      		   WHERE Kd_Alasan = 105 AND Kd_Riwayat = 3 AND YEAR(Tgl_Dokumen) = @Tahun
			AND C.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
	      		A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND NOT (C.Jndt = 1 AND Nilai_Susut1 = 0 AND C.IDPemda IS NULL)
			AND  YEAR (A.TGL_Dokumen) = @TAHUN
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
	           C.Harga, C.Nilai_Susut1, C.Nilai_Susut2, C.Akum_Susut, C.Nilai_Sisa, C.Sisa_Umur, C.Jndt,
	           A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1

	UNION ALL

	SELECT 0 AS Jndt, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan 
	        ,B.Harga, 0 AS Nilai_Susut1, 0 AS Nilai_Susut2, --0 AS Nilai_susut,
		0 AS Akum_Susut, 0 AS Nilai_Sisa, 0 AS Sisa_Umur,
		A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
	FROM   Ta_KIBER A INNER JOIN
		fn_Kartu_BrgE(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap ) B 
			ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota= B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.KD_UPB = B.KD_UPB 
			 AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 
	WHERE A.Kd_Alasan = 105 AND A.Kd_Riwayat = 3 AND YEAR(A.Tgl_Dokumen) = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
	      A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND A.Tgl_Perolehan <= @D1 AND  YEAR (A.TGL_Dokumen) = @TAHUN
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan 
	          ,B.Harga,
	          A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1

	UNION ALL

	SELECT B.Jndt, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan 
	        ,B.Harga, B.Nilai_Susut1 AS Nilai_Susut1, B.Nilai_Susut2 AS Nilai_Susut2, --SUM (B.Nilai_susut1 + B.Nilai_susut2) AS Nilai_susut,
		B.Akum_Susut AS Akum_Susut, B.Nilai_Sisa AS Nilai_Sisa, B.Sisa_Umur AS Sisa_Umur,
		A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
	FROM   Ta_SusutE B LEFT OUTER JOIN
			Ta_KIBER A ON A.IDPemda = B.IDPemda
	WHERE A.Kd_Alasan = 105 AND A.Kd_Riwayat = 3 AND YEAR(A.Tgl_Dokumen) = @Tahun AND B.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
	      A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND A.Tgl_Perolehan <= @D1 --AND NOT (B.Jndt = 1 AND Nilai_Susut1 = 0 AND B.IDPemda IS NULL)

	UNION ALL

	SELECT C.Jndt, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
	         	B.Harga AS Harga,
			C.Nilai_Susut1 AS Nilai_Susut1, C.Nilai_Susut2 AS Nilai_Susut2, --SUM (C.Nilai_susut1 + C.Nilai_susut2) AS Nilai_susut,
			C.Akum_Susut AS Akum_Susut, C.Nilai_Sisa AS Nilai_Sisa, C.Sisa_Umur AS Sisa_Umur,
			A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
	FROM Ta_KILER A INNER JOIN
		fn_Kartu_BrgL(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap ) B 
			ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota= B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.KD_UPB = B.KD_UPB 
			INNER JOIN
			(SELECT Tahun, IDPemda, Jndt, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur FROM Ta_SusutL) C ON A.IDPemda = C.IDPemda
      		  	 WHERE A.Kd_Alasan = 105 AND A.Kd_Riwayat = 3 AND YEAR(A.Tgl_Dokumen) = @Tahun
			AND C.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
	      		A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND NOT (C.Jndt = 1 AND Nilai_Susut1 = 0 AND C.IDPemda IS NULL) AND  YEAR (A.TGL_Dokumen) = @TAHUN
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
	           B.Harga, C.Nilai_Susut1, C.Nilai_Susut2, C.Akum_Susut, C.Nilai_Sisa, C.Sisa_Umur, C.Jndt,
	           A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1

) A INNER JOIN
	(
	SELECT  A.Kd_Aset1, A.Nm_Aset1, B.Kd_Aset2, B.Nm_Aset2, C.Kd_Aset3, C.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, E.Kd_Aset5, E.Nm_Aset5
	FROM    Ref_Rek_Aset1 A INNER JOIN
                Ref_Rek_Aset2 B ON A.Kd_Aset1 = B.Kd_Aset1 INNER JOIN
                Ref_Rek_Aset3 C ON B.Kd_Aset1 = C.Kd_Aset1 AND B.Kd_Aset2 = C.Kd_Aset2 INNER JOIN
                Ref_Rek_Aset4 D ON C.Kd_Aset1 = D.Kd_Aset1 AND C.Kd_Aset2 = D.Kd_Aset2 AND C.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
                Ref_Rek_Aset5 E ON D.Kd_Aset1 = E.Kd_Aset1 AND D.Kd_Aset2 = E.Kd_Aset2 AND D.Kd_Aset3 = E.Kd_Aset3 AND D.Kd_Aset4 = E.Kd_Aset4
	) B ON  A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND 
                A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
	(
	SELECT  A.Kd_Prov, A.Nm_Provinsi, B.Kd_Kab_Kota, B.Nm_Kab_Kota, D.Kd_Bidang, C.Nm_Bidang, D.Kd_Unit, D.Nm_Unit, E.Kd_Sub, E.Nm_Sub_Unit, F.Kd_UPB, F.Nm_UPB
	FROM    Ref_Unit D INNER JOIN
                Ref_Bidang C ON D.Kd_Bidang = C.Kd_Bidang INNER JOIN
                Ref_Sub_Unit E ON D.Kd_Prov = E.Kd_Prov AND D.Kd_Kab_Kota = E.Kd_Kab_Kota AND D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
                Ref_UPB F ON E.Kd_Prov = F.Kd_Prov AND E.Kd_Kab_Kota = F.Kd_Kab_Kota AND E.Kd_Bidang = F.Kd_Bidang AND E.Kd_Unit = F.Kd_Unit AND 
                E.Kd_Sub = F.Kd_Sub INNER JOIN
                Ref_Provinsi A INNER JOIN
                Ref_Kab_Kota B ON A.Kd_Prov = B.Kd_Prov ON D.Kd_Prov = B.Kd_Prov AND D.Kd_Kab_Kota = B.Kd_Kab_Kota
	)C ON   A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND 
                A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB INNER JOIN
    Ref_UPB D ON C.Kd_Prov = D.Kd_Prov AND C.Kd_Kab_Kota = D.Kd_Kab_Kota AND D.Kd_Bidang = A.Kd_Bidang1 AND D.Kd_Unit = A.Kd_Unit1 AND D.Kd_Sub = A.Kd_Sub1 AND D.Kd_UPB = A.Kd_UPB1                  
	WHERE A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
      		A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND 
      		A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Tgl_Perolehan <= @D1

GROUP BY  A.Jndt, A.Kd_Prov, C.Nm_Provinsi, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB,
	A.Kd_Aset1, B.Nm_Aset1, A.Kd_Aset2, B.Nm_Aset2, A.Kd_Aset3, B.Nm_Aset3, A.Kd_Aset4, B.Nm_Aset4, A.Kd_Aset5, B.Nm_Aset5, A.No_Register, A.Tgl_Perolehan,
	A.Sisa_Umur,A.Nilai_Susut1, A.Nilai_Susut2, A.Akum_susut,A.Nilai_Sisa, A.Harga,A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, D.Nm_UPB
ORDER BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register


END



IF @KM = '2' 
BEGIN
SELECT  A.Jndt, A.Kd_Prov1 AS Kd_Prov, C.Nm_Provinsi, A.Kd_Kab_Kota1 AS Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang1 AS Kd_Bidang, C.Nm_Bidang, A.Kd_Unit1 AS Kd_Unit, C.Nm_Unit, A.Kd_Sub1 AS Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB1 AS Kd_UPB, C.Nm_UPB,
	A.Kd_Aset1, B.Nm_Aset1, A.Kd_Aset2, B.Nm_Aset2, A.Kd_Aset3, B.Nm_Aset3, A.Kd_Aset4, B.Nm_Aset4, A.Kd_Aset5, B.Nm_Aset5, 
	CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)AS Kd_Aset_Gab2,    
	CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)AS Kd_Aset_Gab3,     
	CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4)AS Kd_Aset_Gab4,     
	CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4)+'.'+CONVERT(varchar, A.Kd_Aset5)AS Kd_Aset_Gab5,     
	YEAR (@D1) AS Thn_Sblm, A.No_Register1 AS No_Register, A.Tgl_Perolehan, MONTH (A.Tgl_Perolehan) AS Bulan1, YEAR (A.Tgl_Perolehan) AS Tahun, CONVERT(varchar, A.Sisa_Umur / 12) AS Thn, A.Sisa_Umur % 12 AS Bln,
	A.Nilai_Susut1, A.Nilai_Susut2, SUM (A.Nilai_susut1 + A.Nilai_susut2) AS Nilai_susut,
	A.Akum_susut, A.Nilai_Sisa,
         A.Harga AS Nilai_Perolehan, 
       (ISNULL(A.Akum_Susut,0)) - (ISNULL(A.Nilai_Susut1,0)) - (ISNULL(A.Nilai_Susut2,0)) AS AKP_Awal, 
       (ISNULL(A.Nilai_Susut1,0)) + (ISNULL(A.Nilai_Susut2,0))AS Penyusutan, ISNULL(A.Akum_Susut,0) AS AKP_Akhir,
	A.Harga - ISNULL(A.Akum_Susut,0) AS Nilai_Buku,
	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, dbo.fn_GabUPB (A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1) AS Kd_UPB_Tujuan, D.Nm_UPB AS Nm_UPB_Tujuan

FROM (

	SELECT 0 AS Jndt, A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Tgl_Perolehan, 
	         	A.Harga AS Harga,0 AS Nilai_Susut1, 0 AS Nilai_Susut2, 0 AS Akum_Susut, 0 AS Nilai_Sisa, 0 AS Sisa_Umur,
	         	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
	FROM Ta_KIBAR A LEFT OUTER JOIN
		fn_Kartu_BrgA(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap ) B 
			ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota= B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.KD_UPB = B.KD_UPB 
	WHERE YEAR (A.TGL_Dokumen) = @TAHUN
	GROUP BY A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Tgl_Perolehan, 
	           A.Harga, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB

	UNION ALL
	
	SELECT C.Jndt, A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Tgl_Perolehan, 
	         	C.Harga AS Harga, C.Nilai_Susut1 AS Nilai_Susut1, C.Nilai_Susut2 AS Nilai_Susut2, C.Akum_Susut AS Akum_Susut, C.Nilai_Sisa AS Nilai_Sisa, C.Sisa_Umur AS Sisa_Umur,
	         	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
	FROM Ta_KIBBR A INNER JOIN
		(SELECT Tahun, IDPemda, Jndt, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur 
		 FROM Ta_SusutB) C ON A.IDPemda = C.IDPemda
        	 WHERE Kd_Alasan = 105 AND YEAR(Tgl_Dokumen) = @Tahun
			AND C.Tahun = @Tahun AND A.Kd_Prov1 LIKE @Kd_Prov AND A.Kd_Kab_Kota1 LIKE @Kd_Kab_Kota AND A.Kd_Bidang1 LIKE @Kd_Bidang AND A.Kd_Unit1 LIKE @Kd_Unit AND 
	      		A.Kd_Sub1 LIKE @Kd_Sub AND A.Kd_UPB1 LIKE @Kd_UPB AND NOT (C.Jndt = 1 AND Nilai_Susut1 = 0 AND C.IDPemda IS NULL) AND  YEAR (A.TGL_Dokumen) = @TAHUN
	GROUP BY A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Tgl_Perolehan, 
	           C.Harga, C.Nilai_Susut1, C.Nilai_Susut2, C.Akum_Susut, C.Nilai_Sisa, C.Sisa_Umur, C.JNDT,
	           A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB

	UNION ALL

	SELECT C.Jndt, A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Tgl_Perolehan, 
	         	C.Harga AS Harga, C.Nilai_Susut1 AS Nilai_Susut1, C.Nilai_Susut2 AS Nilai_Susut2, C.Akum_Susut AS Akum_Susut, C.Nilai_Sisa AS Nilai_Sisa, C.Sisa_Umur AS Sisa_Umur,
	         	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
	FROM Ta_KIBCR A INNER JOIN
			(SELECT Tahun, IDPemda, Jndt, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur 
			FROM Ta_SusutC) C ON A.IDPemda = C.IDPemda
        		WHERE Kd_Alasan = 105 AND YEAR(Tgl_Dokumen) = @Tahun
				AND C.Tahun = @Tahun AND A.Kd_Prov1 LIKE @Kd_Prov AND A.Kd_Kab_Kota1 LIKE @Kd_Kab_Kota AND A.Kd_Bidang1 LIKE @Kd_Bidang AND A.Kd_Unit1 LIKE @Kd_Unit AND 
	      			A.Kd_Sub1 LIKE @Kd_Sub AND A.Kd_UPB1 LIKE @Kd_UPB AND NOT (C.Jndt = 1 AND Nilai_Susut1 = 0 AND C.IDPemda IS NULL)
	GROUP BY A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Tgl_Perolehan, 
	           C.Harga, C.Nilai_Susut1, C.Nilai_Susut2, C.Akum_Susut, C.Nilai_Sisa, C.Sisa_Umur, C.Jndt,
	           A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB

	UNION ALL

	SELECT C.Jndt, A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Tgl_Perolehan, 
	         	C.Harga AS Harga, C.Nilai_Susut1 AS Nilai_Susut1, C.Nilai_Susut2 AS Nilai_Susut2, C.Akum_Susut AS Akum_Susut, C.Nilai_Sisa AS Nilai_Sisa, C.Sisa_Umur AS Sisa_Umur,
	         	A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
	FROM Ta_KIBDR A INNER JOIN
			(SELECT Tahun, IDPemda, Jndt, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur 
			FROM Ta_SusutD) C ON A.IDPemda = C.IDPemda
        		WHERE Kd_Alasan = 105 AND YEAR(Tgl_Dokumen) = @Tahun
				AND C.Tahun = @Tahun AND A.Kd_Prov1 LIKE @Kd_Prov AND A.Kd_Kab_Kota1 LIKE @Kd_Kab_Kota AND A.Kd_Bidang1 LIKE @Kd_Bidang AND A.Kd_Unit1 LIKE @Kd_Unit AND 
	      			A.Kd_Sub1 LIKE @Kd_Sub AND A.Kd_UPB1 LIKE @Kd_UPB AND NOT (C.Jndt = 1 AND Nilai_Susut1 = 0 AND C.IDPemda IS NULL) AND  YEAR (A.TGL_Dokumen) = @TAHUN
	GROUP BY A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Tgl_Perolehan, 
	           C.Harga, C.Nilai_Susut1, C.Nilai_Susut2, C.Akum_Susut, C.Nilai_Sisa, C.Sisa_Umur, C.Jndt,
	           A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB

	UNION ALL

	SELECT 0 AS Jndt, A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1,  A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Tgl_Perolehan 
			,A.Harga, 0 AS Nilai_Susut1, 0 AS Nilai_Susut2, 0 AS Akum_Susut, 0 AS Nilai_Sisa, 0 AS Sisa_Umur,
			A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
	FROM   Ta_KIBER A LEFT OUTER JOIN
		fn_Kartu_BrgE(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap ) B 
			ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota= B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.KD_UPB = B.KD_UPB 
			 AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 
	WHERE A.Kd_Alasan = 105 AND A.Kd_Riwayat = 3 AND YEAR(A.Tgl_Dokumen) = @Tahun AND A.Kd_Prov1 LIKE @Kd_Prov AND A.Kd_Kab_Kota1 LIKE @Kd_Kab_Kota AND A.Kd_Bidang1 LIKE @Kd_Bidang AND A.Kd_Unit1 LIKE @Kd_Unit AND 
	      A.Kd_Sub1 LIKE @Kd_Sub AND A.Kd_UPB1 LIKE @Kd_UPB AND A.Tgl_Perolehan <= @D1 
	GROUP BY A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1,  A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Tgl_Perolehan, A.Harga, 
			A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB

	UNION ALL

	SELECT 0 AS Jndt, A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1,  A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Tgl_Perolehan 
	          ,B.Harga, B.Nilai_Susut1 AS Nilai_Susut1, B.Nilai_Susut2 AS Nilai_Susut2, B.Akum_Susut AS Akum_Susut, B.Nilai_Sisa AS Nilai_Sisa, B.Sisa_Umur AS Sisa_Umur,
	          A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
	FROM   Ta_SusutE B LEFT OUTER JOIN
			Ta_KIBER A ON A.IDPemda = B.IDPemda
	WHERE A.Kd_Alasan = 105 AND A.Kd_Riwayat = 3 AND YEAR(A.Tgl_Dokumen) = @Tahun AND A.Kd_Prov1 LIKE @Kd_Prov AND A.Kd_Kab_Kota1 LIKE @Kd_Kab_Kota AND A.Kd_Bidang1 LIKE @Kd_Bidang AND A.Kd_Unit1 LIKE @Kd_Unit AND 
	      A.Kd_Sub1 LIKE @Kd_Sub AND A.Kd_UPB1 LIKE @Kd_UPB AND A.Tgl_Perolehan <= @D1 
	GROUP BY A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1,  A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Tgl_Perolehan,
	          B.Harga, B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_Susut, B.Nilai_Sisa, B.Sisa_Umur, B.Jndt,
	          A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB

	UNION ALL

	SELECT 0 AS Jndt, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
	         	B.Harga AS Harga,
			C.Nilai_Susut1 AS Nilai_Susut1, C.Nilai_Susut2 AS Nilai_Susut2, C.Akum_Susut AS Akum_Susut, C.Nilai_Sisa AS Nilai_Sisa, C.Sisa_Umur AS Sisa_Umur,
			A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB
	FROM Ta_KILER A INNER JOIN
		fn_Kartu_BrgL(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap ) B 
			ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota= B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.KD_UPB = B.KD_UPB 
			INNER JOIN
			(SELECT Tahun, IDPemda, Jndt, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur FROM Ta_SusutL) C ON A.IDPemda = C.IDPemda
      		  	 WHERE A.Kd_Alasan = 105 AND A.Kd_Riwayat = 3 AND YEAR(A.Tgl_Dokumen) = @Tahun
			AND C.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
	      		A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND NOT (C.Jndt = 1 AND Nilai_Susut1 = 0 AND C.IDPemda IS NULL) AND  YEAR (A.TGL_Dokumen) = @TAHUN
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
	           B.Harga, C.Nilai_Susut1, C.Nilai_Susut2, C.Akum_Susut, C.Nilai_Sisa, C.Sisa_Umur, C.Jndt,
	           A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB

) A INNER JOIN
	(
	SELECT  A.Kd_Aset1, A.Nm_Aset1, B.Kd_Aset2, B.Nm_Aset2, C.Kd_Aset3, C.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, E.Kd_Aset5, E.Nm_Aset5
	FROM    Ref_Rek_Aset1 A INNER JOIN
                Ref_Rek_Aset2 B ON A.Kd_Aset1 = B.Kd_Aset1 INNER JOIN
                Ref_Rek_Aset3 C ON B.Kd_Aset1 = C.Kd_Aset1 AND B.Kd_Aset2 = C.Kd_Aset2 INNER JOIN
                Ref_Rek_Aset4 D ON C.Kd_Aset1 = D.Kd_Aset1 AND C.Kd_Aset2 = D.Kd_Aset2 AND C.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
                Ref_Rek_Aset5 E ON D.Kd_Aset1 = E.Kd_Aset1 AND D.Kd_Aset2 = E.Kd_Aset2 AND D.Kd_Aset3 = E.Kd_Aset3 AND D.Kd_Aset4 = E.Kd_Aset4
	) B ON  A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND 
                A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
	(
	SELECT  A.Kd_Prov, A.Nm_Provinsi, B.Kd_Kab_Kota, B.Nm_Kab_Kota, D.Kd_Bidang, C.Nm_Bidang, D.Kd_Unit, D.Nm_Unit, E.Kd_Sub, E.Nm_Sub_Unit, F.Kd_UPB, F.Nm_UPB
	FROM    Ref_Unit D INNER JOIN
                Ref_Bidang C ON D.Kd_Bidang = C.Kd_Bidang INNER JOIN
                Ref_Sub_Unit E ON D.Kd_Prov = E.Kd_Prov AND D.Kd_Kab_Kota = E.Kd_Kab_Kota AND D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
                Ref_UPB F ON E.Kd_Prov = F.Kd_Prov AND E.Kd_Kab_Kota = F.Kd_Kab_Kota AND E.Kd_Bidang = F.Kd_Bidang AND E.Kd_Unit = F.Kd_Unit AND 
                E.Kd_Sub = F.Kd_Sub INNER JOIN
                Ref_Provinsi A INNER JOIN
                Ref_Kab_Kota B ON A.Kd_Prov = B.Kd_Prov ON D.Kd_Prov = B.Kd_Prov AND D.Kd_Kab_Kota = B.Kd_Kab_Kota
	)C ON   A.Kd_Prov1 = C.Kd_Prov AND A.Kd_Kab_Kota1 = C.Kd_Kab_Kota AND A.Kd_Bidang1 = C.Kd_Bidang AND 
                A.Kd_Unit1 = C.Kd_Unit AND A.Kd_Sub1 = C.Kd_Sub AND A.Kd_UPB1 = C.Kd_UPB INNER JOIN
    Ref_UPB D ON C.Kd_Prov = D.Kd_Prov AND C.Kd_Kab_Kota = D.Kd_Kab_Kota AND D.Kd_Bidang = A.Kd_Bidang AND D.Kd_Unit = A.Kd_Unit AND D.Kd_Sub = A.Kd_Sub AND D.Kd_UPB = A.Kd_UPB                  
	WHERE A.Kd_Prov1 LIKE @Kd_Prov AND A.Kd_Kab_Kota1 LIKE @Kd_Kab_Kota AND A.Kd_Bidang1 LIKE @Kd_Bidang AND A.Kd_Unit1 LIKE @Kd_Unit AND 
  		    A.Kd_Sub1 LIKE @Kd_Sub AND A.Kd_UPB1 LIKE @Kd_UPB AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND 
  		    A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Tgl_Perolehan <= @D1

GROUP BY  A.Jndt, A.Kd_Prov1, C.Nm_Provinsi, A.Kd_Kab_Kota1, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB,
	A.Kd_Aset1, B.Nm_Aset1, A.Kd_Aset2, B.Nm_Aset2, A.Kd_Aset3, B.Nm_Aset3, A.Kd_Aset4, B.Nm_Aset4, A.Kd_Aset5, B.Nm_Aset5, A.No_Register1, A.Tgl_Perolehan,
	A.Sisa_Umur,A.Nilai_Susut1, A.Nilai_Susut2, A.Akum_susut,A.Nilai_Sisa, A.Harga,A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, D.Nm_UPB
	
ORDER BY A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1

END



GO
