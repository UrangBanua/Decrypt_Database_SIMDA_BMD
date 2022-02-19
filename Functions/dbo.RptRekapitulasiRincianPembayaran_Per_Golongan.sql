USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/***
Deskripsi Store Procedure :
Nama		: RptRekapitulasiRincianPembayaran
Report		: RptRekapitulasiRincianPembayaran.rpt
Keterangan	: Di gunakan untuk Report RptRekapitulasiRincianPembayaran.rpt
Dibuat		: 18/02/2008 10:17:15
Oleh		: Herry S [0852 1821 9951, 021 98 000 182]
***/

CREATE PROCEDURE RptRekapitulasiRincianPembayaran_Per_Golongan @BlnThn Varchar(8), @C_URUSAN Varchar(3),@C_Bid Varchar(3), @C_Unt Varchar(3), @C_Sub Varchar(3), @Kd_Jenis Varchar(1), @Kd_Gol Varchar(10)
WITH ENCRYPTION
AS

/*
DECLARE @BlnThn Varchar(8), @C_URUSAN Varchar(3),@C_Bid Varchar(3), @C_Unt Varchar(3), @C_Sub Varchar(3), @Kd_Gol1 Varchar(10), @Kd_Gol2 Varchar(10), @Kd_Gol3 Varchar(10), @Kd_Gol4 Varchar(10), @Kd_Jenis Varchar(1), @Kd_Gol Varchar(10)
SET @BlnThn = '04/2009'
SET @C_URUSAN = ''
SET @C_Bid = ''
SET @C_Unt = ''
SET @C_Sub = ''
SET @Kd_Jenis = '1'
SET @Kd_Gol = 'II'
*/

	DECLARE @D1 datetime
	SET @D1 = GetDate()

	DECLARE @B1 varchar(7), @B2 varchar(7), @B3 varchar(7), @B4 varchar(7), @B5 varchar(7), @B6 varchar(7)
	SET @B1 = '01' + RIGHT(@BlnThn, 5)
	SET @B2 = '02' + RIGHT(@BlnThn, 5)
	SET @B3 = '03' + RIGHT(@BlnThn, 5)
	SET @B4 = '04' + RIGHT(@BlnThn, 5)
	SET @B5 = '05' + RIGHT(@BlnThn, 5)
	SET @B6 = '06' + RIGHT(@BlnThn, 5)

	DECLARE @B7 varchar(7), @B8 varchar(7), @B9 varchar(7), @B10 varchar(7), @B11 varchar(7), @B12 varchar(7)
	SET @B7 = '07' + RIGHT(@BlnThn, 5)
	SET @B8 = '08' + RIGHT(@BlnThn, 5)
	SET @B9 = '09' + RIGHT(@BlnThn, 5)
	SET @B10 = '10' + RIGHT(@BlnThn, 5)
	SET @B11 = '11' + RIGHT(@BlnThn, 5)
	SET @B12 = '12' + RIGHT(@BlnThn, 5)

	IF ISNULL(@C_URUSAN, '') = '' SET @C_URUSAN = '%'
	IF ISNULL(@C_Bid, '') = '' SET @C_Bid = '%'
	IF ISNULL(@C_Unt, '') = '' SET @C_Unt = '%'
	IF ISNULL(@C_Sub, '') = '' SET @C_Sub = '%'

	IF @Kd_Jenis = '1' /*Semester 1*/
	BEGIN

	SELECT A.Bulan, A.Tahun AS Tahun, 
		A.Jumlah_Pegawai, A.Gaji_Pokok, A.Tunj_Keluarga, 
  		A.Tunj_Struktural, A.Tunj_Fungsional, A.Tunj_Umum, 
		A.Tunj_Pajak, A.Tunj_Beras, A.LainLain, A.Pembulatan, Upper(B.V_NAMA_PEMDA) AS Nama_Pemda, 
		B.V_JUDUL_KEP_DAERAH, B.V_NM_KEP_KEUANGAN, B.V_NIP_KEP_KEUANGAN, B.V_JAB_FUNGSI_KEP_KEUANGAN, B.V_JUDUL_KEP_KEUANGAN, B.Logo
	FROM
		(SELECT UPPER(A.BULAN) AS Bulan, A.Tahun AS Tahun, 
		SUM(A.Jumlah_Pegawai) AS Jumlah_Pegawai, SUM(A.Gaji_Pokok) AS Gaji_Pokok, SUM(A.Tunj_Istri+A.Tunj_Anak) AS Tunj_Keluarga, 
  		SUM(A.Tunj_Struktur) AS Tunj_Struktural, SUM(A.Tunj_Fungsi) AS Tunj_Fungsional, SUM(A.Tunj_Umum) As Tunj_Umum, 
		SUM(A.Pajak) AS Tunj_Pajak, SUM(A.Tunj_Beras) AS Tunj_Beras, SUM(A.N_Tunj_Kerja+A.TPP+A.Tunj_Peralihan+A.Iuran_Pemda+A.Tunj_Khusus_1+A.Tunj_Khusus_2+A.Add_Pembulatan) AS LainLain,
		SUM(ISNULL(Add_Pembulatan, 0)) AS Pembulatan
 		FROM fn_PerhitunganGaji(@B1, @D1) A
		WHERE (A.C_URUSAN LIKE @C_URUSAN AND A.C_BIDANG LIKE @C_Bid AND A.C_UNIT LIKE @C_Unt AND A.C_SUB LIKE @C_Sub) 
		AND (A.Golongan in (@Kd_Gol))
		GROUP BY A.BULAN, A.Tahun

		UNION ALL

		SELECT 	UPPER(A.BULAN) AS Bulan, A.Tahun AS Tahun, 
		SUM(A.Jumlah_Pegawai) AS Jumlah_Pegawai, SUM(A.Gaji_Pokok) AS Gaji_Pokok, SUM(A.Tunj_Istri+A.Tunj_Anak) AS Tunj_Keluarga, 
  		SUM(A.Tunj_Struktur) AS Tunj_Struktural, SUM(A.Tunj_Fungsi) AS Tunj_Fungsional, SUM(A.Tunj_Umum) As Tunj_Umum, 
		SUM(A.Pajak) AS Tunj_Pajak, SUM(A.Tunj_Beras) AS Tunj_Beras, SUM(A.N_Tunj_Kerja+A.TPP+A.Tunj_Peralihan+A.Iuran_Pemda+A.Tunj_Khusus_1+A.Tunj_Khusus_2+A.Add_Pembulatan) AS LainLain,
		SUM(ISNULL(Add_Pembulatan, 0)) AS Pembulatan
 		FROM fn_PerhitunganGaji(@B2, @D1) A
		WHERE (A.C_URUSAN LIKE @C_URUSAN AND A.C_BIDANG LIKE @C_Bid AND A.C_UNIT LIKE @C_Unt AND A.C_SUB LIKE @C_Sub) 
		AND (A.Golongan in (@Kd_Gol))
		GROUP BY A.BULAN, A.Tahun

		UNION ALL

		SELECT 	UPPER(A.BULAN) AS Bulan, A.Tahun AS Tahun, 
		SUM(A.Jumlah_Pegawai) AS Jumlah_Pegawai, SUM(A.Gaji_Pokok) AS Gaji_Pokok, SUM(A.Tunj_Istri+A.Tunj_Anak) AS Tunj_Keluarga, 
  		SUM(A.Tunj_Struktur) AS Tunj_Struktural, SUM(A.Tunj_Fungsi) AS Tunj_Fungsional, SUM(A.Tunj_Umum) As Tunj_Umum, 
		SUM(A.Pajak) AS Tunj_Pajak, SUM(A.Tunj_Beras) AS Tunj_Beras, SUM(A.N_Tunj_Kerja+A.TPP+A.Tunj_Peralihan+A.Iuran_Pemda+A.Tunj_Khusus_1+A.Tunj_Khusus_2+A.Add_Pembulatan) AS LainLain,
		SUM(ISNULL(Add_Pembulatan, 0)) AS Pembulatan
 		FROM fn_PerhitunganGaji(@B3, @D1) A
		WHERE (A.C_URUSAN LIKE @C_URUSAN AND A.C_BIDANG LIKE @C_Bid AND A.C_UNIT LIKE @C_Unt AND A.C_SUB LIKE @C_Sub) 
		AND (A.Golongan in (@Kd_Gol))
		GROUP BY A.BULAN, A.Tahun

		UNION ALL

		SELECT 	UPPER(A.BULAN) AS Bulan, A.Tahun AS Tahun, 
		SUM(A.Jumlah_Pegawai) AS Jumlah_Pegawai, SUM(A.Gaji_Pokok) AS Gaji_Pokok, SUM(A.Tunj_Istri+A.Tunj_Anak) AS Tunj_Keluarga, 
  		SUM(A.Tunj_Struktur) AS Tunj_Struktural, SUM(A.Tunj_Fungsi) AS Tunj_Fungsional, SUM(A.Tunj_Umum) As Tunj_Umum, 
		SUM(A.Pajak) AS Tunj_Pajak, SUM(A.Tunj_Beras) AS Tunj_Beras, SUM(A.N_Tunj_Kerja+A.TPP+A.Tunj_Peralihan+A.Iuran_Pemda+A.Tunj_Khusus_1+A.Tunj_Khusus_2+A.Add_Pembulatan) AS LainLain,
		SUM(ISNULL(Add_Pembulatan, 0)) AS Pembulatan
 		FROM fn_PerhitunganGaji(@B4, @D1) A
		WHERE (A.C_URUSAN LIKE @C_URUSAN AND A.C_BIDANG LIKE @C_Bid AND A.C_UNIT LIKE @C_Unt AND A.C_SUB LIKE @C_Sub) 
		AND (A.Golongan in (@Kd_Gol))
		GROUP BY A.BULAN, A.Tahun

		UNION ALL

		SELECT 	UPPER(A.BULAN) AS Bulan, A.Tahun AS Tahun, 
		SUM(A.Jumlah_Pegawai) AS Jumlah_Pegawai, SUM(A.Gaji_Pokok) AS Gaji_Pokok, SUM(A.Tunj_Istri+A.Tunj_Anak) AS Tunj_Keluarga, 
  		SUM(A.Tunj_Struktur) AS Tunj_Struktural, SUM(A.Tunj_Fungsi) AS Tunj_Fungsional, SUM(A.Tunj_Umum) As Tunj_Umum, 
		SUM(A.Pajak) AS Tunj_Pajak, SUM(A.Tunj_Beras) AS Tunj_Beras, SUM(A.N_Tunj_Kerja+A.TPP+A.Tunj_Peralihan+A.Iuran_Pemda+A.Tunj_Khusus_1+A.Tunj_Khusus_2+A.Add_Pembulatan) AS LainLain,
		SUM(ISNULL(Add_Pembulatan, 0)) AS Pembulatan
 		FROM fn_PerhitunganGaji(@B5, @D1) A
		WHERE (A.C_URUSAN LIKE @C_URUSAN AND A.C_BIDANG LIKE @C_Bid AND A.C_UNIT LIKE @C_Unt AND A.C_SUB LIKE @C_Sub) 
		AND (A.Golongan in (@Kd_Gol))
		GROUP BY A.BULAN, A.Tahun

		UNION ALL

		SELECT 	UPPER(A.BULAN) AS Bulan, A.Tahun AS Tahun, 
		SUM(A.Jumlah_Pegawai) AS Jumlah_Pegawai, SUM(A.Gaji_Pokok) AS Gaji_Pokok, SUM(A.Tunj_Istri+A.Tunj_Anak) AS Tunj_Keluarga, 
  		SUM(A.Tunj_Struktur) AS Tunj_Struktural, SUM(A.Tunj_Fungsi) AS Tunj_Fungsional, SUM(A.Tunj_Umum) As Tunj_Umum, 
		SUM(A.Pajak) AS Tunj_Pajak, SUM(A.Tunj_Beras) AS Tunj_Beras, SUM(A.N_Tunj_Kerja+A.TPP+A.Tunj_Peralihan+A.Iuran_Pemda+A.Tunj_Khusus_1+A.Tunj_Khusus_2+A.Add_Pembulatan) AS LainLain,
		SUM(ISNULL(Add_Pembulatan, 0)) AS Pembulatan
 		FROM fn_PerhitunganGaji(@B6, @D1) A
		WHERE (A.C_URUSAN LIKE @C_URUSAN AND A.C_BIDANG LIKE @C_Bid AND A.C_UNIT LIKE @C_Unt AND A.C_SUB LIKE @C_Sub) 
		AND (A.Golongan in (@Kd_Gol))
		GROUP BY A.BULAN, A.Tahun) A,

		(SELECT V_BULAN_TH, V_NAMA_PEMDA, V_JUDUL_KEP_DAERAH, V_NM_KEP_KEUANGAN, V_NIP_KEP_KEUANGAN, V_JAB_FUNGSI_KEP_KEUANGAN, V_JUDUL_KEP_KEUANGAN, LOGO From T_PAR_PEMDA WHERE V_BULAN_TH=@BlnThn) B
	END


	IF @Kd_Jenis = '2' /*Semester 2*/
	BEGIN
	SELECT A.Bulan, A.Tahun AS Tahun,
		A.Jumlah_Pegawai, A.Gaji_Pokok, A.Tunj_Keluarga, 
  		A.Tunj_Struktural, A.Tunj_Fungsional, A.Tunj_Umum, 
		A.Tunj_Pajak, A.Tunj_Beras, A.LainLain, A.Pembulatan, Upper(B.V_NAMA_PEMDA) AS Nama_Pemda,
		B.V_JUDUL_KEP_DAERAH, B.V_NM_KEP_KEUANGAN, B.V_NIP_KEP_KEUANGAN, B.V_JAB_FUNGSI_KEP_KEUANGAN, B.V_JUDUL_KEP_KEUANGAN, B.Logo
	FROM
		(SELECT UPPER(A.BULAN) AS Bulan, A.Tahun AS Tahun, 
		SUM(A.Jumlah_Pegawai) AS Jumlah_Pegawai, SUM(A.Gaji_Pokok) AS Gaji_Pokok, SUM(A.Tunj_Istri+A.Tunj_Anak) AS Tunj_Keluarga, 
  		SUM(A.Tunj_Struktur) AS Tunj_Struktural, SUM(A.Tunj_Fungsi) AS Tunj_Fungsional, SUM(A.Tunj_Umum) As Tunj_Umum, 
		SUM(A.Pajak) AS Tunj_Pajak, SUM(A.Tunj_Beras) AS Tunj_Beras, SUM(A.N_Tunj_Kerja+A.TPP+A.Tunj_Peralihan+A.Iuran_Pemda+A.Tunj_Khusus_1+A.Tunj_Khusus_2+A.Add_Pembulatan) AS LainLain,
		SUM(ISNULL(Add_Pembulatan, 0)) AS Pembulatan
 		FROM fn_PerhitunganGaji(@B7, @D1) A
		WHERE (A.C_URUSAN LIKE @C_URUSAN AND A.C_BIDANG LIKE @C_Bid AND A.C_UNIT LIKE @C_Unt AND A.C_SUB LIKE @C_Sub) 
		AND (A.Golongan in (@Kd_Gol))
		GROUP BY A.BULAN, A.Tahun

		UNION ALL

		SELECT 	UPPER(A.BULAN) AS Bulan, A.Tahun AS Tahun, 
		SUM(A.Jumlah_Pegawai) AS Jumlah_Pegawai, SUM(A.Gaji_Pokok) AS Gaji_Pokok, SUM(A.Tunj_Istri+A.Tunj_Anak) AS Tunj_Keluarga, 
  		SUM(A.Tunj_Struktur) AS Tunj_Struktural, SUM(A.Tunj_Fungsi) AS Tunj_Fungsional, SUM(A.Tunj_Umum) As Tunj_Umum, 
		SUM(A.Pajak) AS Tunj_Pajak, SUM(A.Tunj_Beras) AS Tunj_Beras, SUM(A.N_Tunj_Kerja+A.TPP+A.Tunj_Peralihan+A.Iuran_Pemda+A.Tunj_Khusus_1+A.Tunj_Khusus_2+A.Add_Pembulatan) AS LainLain,
		SUM(ISNULL(Add_Pembulatan, 0)) AS Pembulatan
 		FROM fn_PerhitunganGaji(@B8, @D1) A
		WHERE (A.C_URUSAN LIKE @C_URUSAN AND A.C_BIDANG LIKE @C_Bid AND A.C_UNIT LIKE @C_Unt AND A.C_SUB LIKE @C_Sub) 
		AND (A.Golongan in (@Kd_Gol))
		GROUP BY A.BULAN, A.Tahun

		UNION ALL

		SELECT 	UPPER(A.BULAN) AS Bulan, A.Tahun AS Tahun, 
		SUM(A.Jumlah_Pegawai) AS Jumlah_Pegawai, SUM(A.Gaji_Pokok) AS Gaji_Pokok, SUM(A.Tunj_Istri+A.Tunj_Anak) AS Tunj_Keluarga, 
  		SUM(A.Tunj_Struktur) AS Tunj_Struktural, SUM(A.Tunj_Fungsi) AS Tunj_Fungsional, SUM(A.Tunj_Umum) As Tunj_Umum, 
		SUM(A.Pajak) AS Tunj_Pajak, SUM(A.Tunj_Beras) AS Tunj_Beras, SUM(A.N_Tunj_Kerja+A.TPP+A.Tunj_Peralihan+A.Iuran_Pemda+A.Tunj_Khusus_1+A.Tunj_Khusus_2+A.Add_Pembulatan) AS LainLain,
		SUM(ISNULL(Add_Pembulatan, 0)) AS Pembulatan
 		FROM fn_PerhitunganGaji(@B9, @D1) A
		WHERE (A.C_URUSAN LIKE @C_URUSAN AND A.C_BIDANG LIKE @C_Bid AND A.C_UNIT LIKE @C_Unt AND A.C_SUB LIKE @C_Sub) 
		AND (A.Golongan in (@Kd_Gol))
		GROUP BY A.BULAN, A.Tahun

		UNION ALL

		SELECT 	UPPER(A.BULAN) AS Bulan, A.Tahun AS Tahun, 
		SUM(A.Jumlah_Pegawai) AS Jumlah_Pegawai, SUM(A.Gaji_Pokok) AS Gaji_Pokok, SUM(A.Tunj_Istri+A.Tunj_Anak) AS Tunj_Keluarga, 
  		SUM(A.Tunj_Struktur) AS Tunj_Struktural, SUM(A.Tunj_Fungsi) AS Tunj_Fungsional, SUM(A.Tunj_Umum) As Tunj_Umum, 
		SUM(A.Pajak) AS Tunj_Pajak, SUM(A.Tunj_Beras) AS Tunj_Beras, SUM(A.N_Tunj_Kerja+A.TPP+A.Tunj_Peralihan+A.Iuran_Pemda+A.Tunj_Khusus_1+A.Tunj_Khusus_2+A.Add_Pembulatan) AS LainLain,
		SUM(ISNULL(Add_Pembulatan, 0)) AS Pembulatan
 		FROM fn_PerhitunganGaji(@B10, @D1) A
		WHERE (A.C_URUSAN LIKE @C_URUSAN AND A.C_BIDANG LIKE @C_Bid AND A.C_UNIT LIKE @C_Unt AND A.C_SUB LIKE @C_Sub) 
		AND (A.Golongan in (@Kd_Gol))
		GROUP BY A.BULAN, A.Tahun

		UNION ALL

		SELECT 	UPPER(A.BULAN) AS Bulan, A.Tahun AS Tahun, 
		SUM(A.Jumlah_Pegawai) AS Jumlah_Pegawai, SUM(A.Gaji_Pokok) AS Gaji_Pokok, SUM(A.Tunj_Istri+A.Tunj_Anak) AS Tunj_Keluarga, 
  		SUM(A.Tunj_Struktur) AS Tunj_Struktural, SUM(A.Tunj_Fungsi) AS Tunj_Fungsional, SUM(A.Tunj_Umum) As Tunj_Umum, 
		SUM(A.Pajak) AS Tunj_Pajak, SUM(A.Tunj_Beras) AS Tunj_Beras, SUM(A.N_Tunj_Kerja+A.TPP+A.Tunj_Peralihan+A.Iuran_Pemda+A.Tunj_Khusus_1+A.Tunj_Khusus_2+A.Add_Pembulatan) AS LainLain,
		SUM(ISNULL(Add_Pembulatan, 0)) AS Pembulatan
 		FROM fn_PerhitunganGaji(@B11, @D1) A
		WHERE (A.C_URUSAN LIKE @C_URUSAN AND A.C_BIDANG LIKE @C_Bid AND A.C_UNIT LIKE @C_Unt AND A.C_SUB LIKE @C_Sub) 
		AND (A.Golongan in (@Kd_Gol))
		GROUP BY A.BULAN, A.Tahun

		UNION ALL

		SELECT 	UPPER(A.BULAN) AS Bulan, A.Tahun AS Tahun, 
		SUM(A.Jumlah_Pegawai) AS Jumlah_Pegawai, SUM(A.Gaji_Pokok) AS Gaji_Pokok, SUM(A.Tunj_Istri+A.Tunj_Anak) AS Tunj_Keluarga, 
  		SUM(A.Tunj_Struktur) AS Tunj_Struktural, SUM(A.Tunj_Fungsi) AS Tunj_Fungsional, SUM(A.Tunj_Umum) As Tunj_Umum, 
		SUM(A.Pajak) AS Tunj_Pajak, SUM(A.Tunj_Beras) AS Tunj_Beras, SUM(A.N_Tunj_Kerja+A.TPP+A.Tunj_Peralihan+A.Iuran_Pemda+A.Tunj_Khusus_1+A.Tunj_Khusus_2+A.Add_Pembulatan) AS LainLain,
		SUM(ISNULL(Add_Pembulatan, 0)) AS Pembulatan
 		FROM fn_PerhitunganGaji(@B12, @D1) A
		WHERE (A.C_URUSAN LIKE @C_URUSAN AND A.C_BIDANG LIKE @C_Bid AND A.C_UNIT LIKE @C_Unt AND A.C_SUB LIKE @C_Sub) 
		AND (A.Golongan in (@Kd_Gol))
		GROUP BY A.BULAN, A.Tahun) A,

		(SELECT V_BULAN_TH, V_NAMA_PEMDA, V_JUDUL_KEP_DAERAH, V_NM_KEP_KEUANGAN, V_NIP_KEP_KEUANGAN, V_JAB_FUNGSI_KEP_KEUANGAN, V_JUDUL_KEP_KEUANGAN, LOGO From T_PAR_PEMDA WHERE V_BULAN_TH=@BlnThn) B

	END



GO
