USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.Rpt108JumlahBarang @Tahun varchar(4), @D2 datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), 
		---@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @D2 Datetime
			@Nm_Aset5 varchar (255)
WITH ENCRYPTION
AS
/*
				
DECLARE @Tahun varchar(4), @D2 datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), 
		---@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3)
		@Nm_Aset5 varchar (255)
SET @Tahun = 2018
SET @D2 = '20181231'
SET @Kd_Prov = '13'
SET @Kd_Kab_Kota = '33'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = ''
SET @Nm_Aset5 = '%sepeda%'
--*/

		DECLARE @tmpBI TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, 
			Kd_Aset tinyint,Kd_Aset0 tinyint,Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 int, Kd_Aset5 int, No_Register int, 
			Tahun money, Jumlah money, Asal_Usul varchar(20), Harga money, Kondisi varchar (50), Keterangan varchar (255), 
			Nm_aset5 varchar (255), Dokumen1 varchar (255),Dokumen2 varchar (255),Dokumen3 varchar (255))
	
	DECLARE @JLap Tinyint SET @JLap = 0

	IF ISNULL(@Kd_Kab_Kota, '') = '' SET @Kd_Kab_Kota = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	IF ISNULL(@Nm_Aset5, '') = '' SET @Nm_Aset5 = '%'
	
			
	INSERT INTO @tmpBI 
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
			YEAR(A.Tgl_Perolehan) AS Tahun, 1 AS Jumlah, A.Asal_Usul, A.Harga, 
			'Baik' AS Kondisi, ISNULL(A.Keterangan, '-') AS Keterangan,D.NM_ASET5, 
			ISNULL (A.Luas_M2,'') AS Dokumen1, ISNULL(A.Sertifikat_Nomor,'') AS Dokumen2, ISNULL(A.Alamat,'-') AS Dokumen3
		FROM fn_Kartu108_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%', '%','%','%','%',@JLap)  A 
				LEFT OUTER JOIN
			Ref_Rek5_108 D ON A.Kd_Aset = D.Kd_Aset AND A.Kd_Aset0 = D.Kd_Aset0 AND A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5

		WHERE (A.Kd_Pemilik IN(0, 11, 12)) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	            AND (A.Kd_Aset LIKE D.Kd_Aset) AND (A.Kd_Aset0 LIKE D.Kd_Aset0) AND (A.Kd_Aset1 LIKE D.Kd_Aset1) AND (A.Kd_Aset2 LIKE D.Kd_Aset2) AND (A.Kd_Aset3 LIKE D.Kd_Aset3) AND (A.Kd_Aset4 LIKE D.Kd_Aset4) AND (A.Kd_Aset5 LIKE D.Kd_Aset5)
				AND (D.Nm_Aset5 LIKE @Nm_Aset5)
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan), A.Luas_M2, A.Asal_Usul, A.Harga, A.Keterangan
				,D.NM_ASET5, A.Luas_M2, A.Sertifikat_Nomor, A.Alamat
				
		
		INSERT INTO @tmpBI 
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
			YEAR(A.Tgl_Perolehan) AS Tahun,	COUNT(*) AS Jumlah, A.Asal_Usul, SUM(A.Harga) AS Harga, 
			C.Uraian AS Kondisi,ISNULL(A.Keterangan, '-') AS Keterangan,D.NM_ASET5,
			ISNULL(A.Merk,'-') AS Dokumen1, ISNULL(A.Nomor_Polisi,'') AS Dokumen2,ISNULL(A.Nomor_BPKB, '-') AS Dokumen3
		FROM fn_Kartu108_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%', '%','%','%','%','%','%','%',@JLap) A LEFT OUTER JOIN
			Ref_Kondisi C On A.Kondisi = C.Kd_Kondisi LEFT OUTER JOIN
			Ref_Rek5_108 D ON A.Kd_Aset = D.Kd_Aset AND A.Kd_Aset0 = D.Kd_Aset0 AND A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5
		WHERE (A.Kd_Pemilik IN(0, 11, 12)) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	            AND (A.Kd_Aset LIKE D.Kd_Aset) AND (A.Kd_Aset0 LIKE D.Kd_Aset0) AND (A.Kd_Aset1 LIKE D.Kd_Aset1) AND (A.Kd_Aset2 LIKE D.Kd_Aset2) AND (A.Kd_Aset3 LIKE D.Kd_Aset3) AND (A.Kd_Aset4 LIKE D.Kd_Aset4) AND (A.Kd_Aset5 LIKE D.Kd_Aset5)
				AND (D.Nm_Aset5 LIKE @Nm_Aset5)
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, YEAR(A.Tgl_Perolehan), A.Asal_Usul, A.Kondisi, ISNULL(A.Keterangan, ''), C.Uraian
				,D.NM_ASET5, A.Merk,A.Nomor_Polisi, A.Nomor_BPKB,A.Keterangan
				
		INSERT INTO @tmpBI 
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, 
			1 AS Jumlah, A.Asal_Usul, A.Harga, 
			C.Uraian AS Kondisi, ISNULL(A.Keterangan, '-') AS Keterangan,D.NM_ASET5, 
			ISNULL (A.Luas_Lantai,'-') AS Dokumen1, ISNULL (A.Dokumen_Nomor, '-') AS Dokumen2, A.Lokasi AS Dokumen3
		FROM fn_Kartu108_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%', '%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
			Ref_Kondisi C On A.Kondisi = C.Kd_Kondisi LEFT OUTER JOIN
			Ref_Rek5_108 D ON A.Kd_Aset = D.Kd_Aset AND A.Kd_Aset0 = D.Kd_Aset0 AND A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5

		WHERE (A.Kd_Pemilik IN(0, 11, 12))AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	            AND (A.Kd_Aset LIKE D.Kd_Aset) AND (A.Kd_Aset0 LIKE D.Kd_Aset0) AND (A.Kd_Aset1 LIKE D.Kd_Aset1) AND (A.Kd_Aset2 LIKE D.Kd_Aset2) AND (A.Kd_Aset3 LIKE D.Kd_Aset3) AND (A.Kd_Aset4 LIKE D.Kd_Aset4) AND (A.Kd_Aset5 LIKE D.Kd_Aset5)
				AND (D.Nm_Aset5 LIKE @Nm_Aset5)
		
		INSERT INTO @tmpBI 
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, YEAR(A.Tgl_Perolehan) AS Tahun, 
			1 AS Jumlah, A.Asal_Usul, A.Harga, C.Uraian AS Kondisi, ISNULL(A.Keterangan, '-') AS Keterangan,D.NM_ASET5, 
			ISNULL (A.Luas,'') AS Dokumen1, ISNULL(A.Dokumen_Nomor,'') AS Dokumen2, A.Lokasi AS Dokumen3
		FROM fn_Kartu108_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%', '%','%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
			Ref_Kondisi C On A.Kondisi = C.Kd_Kondisi LEFT OUTER JOIN
			Ref_Rek5_108 D ON A.Kd_Aset = D.Kd_Aset AND A.Kd_Aset0 = D.Kd_Aset0 AND A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5

		WHERE (A.Kd_Pemilik IN(0, 11, 12)) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	            AND (A.Kd_Aset LIKE D.Kd_Aset) AND (A.Kd_Aset0 LIKE D.Kd_Aset0) AND (A.Kd_Aset1 LIKE D.Kd_Aset1) AND (A.Kd_Aset2 LIKE D.Kd_Aset2) AND (A.Kd_Aset3 LIKE D.Kd_Aset3) AND (A.Kd_Aset4 LIKE D.Kd_Aset4) AND (A.Kd_Aset5 LIKE D.Kd_Aset5)
				AND (D.Nm_Aset5 LIKE @Nm_Aset5)
	
		INSERT INTO @tmpBI 
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
			YEAR(A.Tgl_Perolehan) AS Tahun, COUNT(*) AS Jumlah, A.Asal_Usul, SUM(Harga) AS Harga, 
			C.Uraian AS Kondisi, ISNULL(A.Keterangan, '-') AS Keterangan,D.NM_ASET5, 
			ISNULL(A.Judul,'-') AS Dokumen1, ISNULL(A.Pencipta,'-') AS Dokumen2, A.Bahan AS Dokumen3
		FROM fn_Kartu108_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
			Ref_Kondisi C On A.Kondisi = C.Kd_Kondisi LEFT OUTER JOIN
			Ref_Rek5_108 D ON A.Kd_Aset = D.Kd_Aset AND A.Kd_Aset0 = D.Kd_Aset0 AND A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5

		WHERE (A.Kd_Pemilik IN(0, 11, 12)) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	            AND (A.Kd_Aset LIKE D.Kd_Aset) AND (A.Kd_Aset0 LIKE D.Kd_Aset0) AND (A.Kd_Aset1 LIKE D.Kd_Aset1) AND (A.Kd_Aset2 LIKE D.Kd_Aset2) AND (A.Kd_Aset3 LIKE D.Kd_Aset3) AND (A.Kd_Aset4 LIKE D.Kd_Aset4) AND (A.Kd_Aset5 LIKE D.Kd_Aset5)
				AND (D.Nm_Aset5 LIKE @Nm_Aset5)
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,  A.Kd_Pemilik, YEAR(A.Tgl_Perolehan), A.Asal_Usul, A.Kondisi, ISNULL(A.Keterangan, ''), C.Uraian
			   ,A.Keterangan,D.NM_ASET5, A.Judul, A.Pencipta, A.Bahan
		
		INSERT INTO @tmpBI 
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
			YEAR(A.Tgl_Perolehan) AS Tahun, COUNT(*) AS Jumlah, A.Asal_Usul, SUM(A.Harga) AS Harga, 
			C.Uraian AS Kondisi, ISNULL(A.Keterangan, '-') AS Keterangan
			,D.NM_ASET5, ISNULL (A.Luas_Lantai,'') AS Dokumen1, ISNULL(A.Dokumen_Nomor,'') AS Dokumen2, ISNULL(A.Lokasi,'-') AS Dokumen3
		FROM fn_Kartu108_BrgF(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%', '%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
			Ref_Kondisi C On A.Kondisi = C.Kd_Kondisi LEFT OUTER JOIN
			Ref_Rek5_108 D ON A.Kd_Aset = D.Kd_Aset AND A.Kd_Aset0 = D.Kd_Aset0 AND A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5

		WHERE (A.Kd_Pemilik IN(0, 11, 12)) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	            AND (A.Kd_Aset LIKE D.Kd_Aset) AND (A.Kd_Aset0 LIKE D.Kd_Aset0) AND (A.Kd_Aset1 LIKE D.Kd_Aset1) AND (A.Kd_Aset2 LIKE D.Kd_Aset2) AND (A.Kd_Aset3 LIKE D.Kd_Aset3) AND (A.Kd_Aset4 LIKE D.Kd_Aset4) AND (A.Kd_Aset5 LIKE D.Kd_Aset5)
				AND (D.Nm_Aset5 LIKE @Nm_Aset5)
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, YEAR(A.Tgl_Perolehan), A.Asal_Usul, A.Kondisi, ISNULL(A.Keterangan, ''), C.Uraian
				,A.Keterangan,D.NM_ASET5, A.Luas_Lantai, A.Dokumen_Nomor, A.Lokasi
				
		INSERT INTO @tmpBI 
		SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
			YEAR(A.Tgl_Perolehan) AS Tahun, COUNT(*) AS Jumlah, A.Asal_Usul, SUM(A.Harga) AS Harga, 
			C.Uraian AS Kondisi, ISNULL(A.Keterangan, '-') AS Keterangan,D.NM_ASET5, 
			ISNULL(A.Judul,'-') AS Dokumen1, ISNULL(A.Pencipta,'-') AS Dokumen2, ISNULL (A.Bahan,'-') AS Dokumen3
		FROM fn_Kartu108_BrgL(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%', '%','%','%','%','%',@JLap)  A LEFT OUTER JOIN
			Ref_Kondisi C On A.Kondisi = C.Kd_Kondisi LEFT OUTER JOIN
			Ref_Rek5_108 D ON A.Kd_Aset = D.Kd_Aset AND A.Kd_Aset0 = D.Kd_Aset0 AND A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5

		WHERE (A.Kd_Pemilik IN(0, 11, 12)) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	            AND (A.Kd_Aset LIKE D.Kd_Aset) AND (A.Kd_Aset0 LIKE D.Kd_Aset0) AND (A.Kd_Aset1 LIKE D.Kd_Aset1) AND (A.Kd_Aset2 LIKE D.Kd_Aset2) AND (A.Kd_Aset3 LIKE D.Kd_Aset3) AND (A.Kd_Aset4 LIKE D.Kd_Aset4) AND (A.Kd_Aset5 LIKE D.Kd_Aset5)
				AND (D.Nm_Aset5 LIKE @Nm_Aset5)
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Kd_Pemilik, YEAR(A.Tgl_Perolehan), A.Asal_Usul, A.Kondisi, ISNULL(A.Keterangan, ''), C.Uraian
			,A.Keterangan,D.NM_ASET5, A.Judul, A.Pencipta, A.Bahan
			
	
	
	SELECT 
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) As Kd_Kab_Kota_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) AS Kd_Bidang_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) AS Kd_Unit_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) AS Kd_Sub_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset), 2) + '.' +RIGHT('0' + CONVERT(varchar, A.Kd_Aset0), 2) + '.' +RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 4) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset5), 5) AS Kd_Aset_Gab5,
		RIGHT('0' + CONVERT(varchar, A.Kd_Prov), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Kab_Kota), 2) + '.'+ RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_UPB), 2) AS Kd_UPB_Gab,
		E.NM_PEMDA,
		B.Nm_Unit, C.Nm_Sub_Unit,D.Nm_UPB,A.Nm_Aset5, 
		A.Dokumen1, A.Dokumen2, A.Dokumen3,A.Tahun, 
		A.Jumlah, A.Asal_Usul, A.Harga, A.Kondisi, A.Keterangan
		,F.Nm_Pimpinan, F.Nip_Pimpinan, F.Jbt_Pimpinan, F.Nm_Pengurus, F.Nip_Pengurus, F.Jbt_Pengurus --G.Logo 

	FROM @tmpBI A INNER JOIN
		Ref_Unit B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit INNER JOIN
		Ref_Sub_Unit C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub INNER JOIN
		Ref_UPB D ON A.Kd_Prov = D.Kd_Prov AND A.Kd_Kab_Kota = D.Kd_Kab_Kota AND A.Kd_Bidang = D.Kd_Bidang AND A.Kd_Unit = D.Kd_Unit AND A.Kd_Sub = D.Kd_Sub INNER JOIN
		Ref_Pemda E ON A.Kd_Prov = E.Kd_Prov AND A.Kd_Kab_Kota = E.Kd_Kab_Kota INNER JOIN
		Ta_UPB F ON A.Kd_prov = F.Kd_Prov AND A.Kd_Kab_Kota = F.Kd_Kab_Kota AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB 

		
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND (A.Nm_Aset5 LIKE @Nm_Aset5)
		AND (F.Tahun =@Tahun)
		
		
		

GO
