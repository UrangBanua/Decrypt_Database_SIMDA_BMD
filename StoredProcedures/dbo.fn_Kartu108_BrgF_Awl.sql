USE bmd_hst2020
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION dbo.fn_Kartu108_BrgF_Awl (@D1 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4),
				@Kd_Aset varchar(3), @Kd_Aset0 varchar(3),@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(5))

RETURNS @UpdateKIB TABLE(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int,
 			 Kd_ASet tinyint,Kd_ASet0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 smallint, Kd_Aset5 smallint, No_Register int,
			 Kd_Pemilik tinyint, Tgl_Perolehan datetime, Tgl_Pembukuan datetime, Bertingkat_Tidak varchar(20), Beton_Tidak varchar(20), Luas_Lantai float,
			 Lokasi varchar(255), Dokumen_Tanggal datetime, Dokumen_Nomor varchar(50), Status_Tanah varchar(50), Kd_Tanah1 tinyint,
			 Kd_Tanah2 tinyint, Kd_Tanah3 tinyint, Kd_Tanah4 tinyint, Kd_Tanah5 tinyint, Kode_Tanah int, Asal_Usul varchar(50),
			 Kondisi varchar(2), Harga money, Keterangan varchar(255), Kd_KA tinyint)

WITH ENCRYPTION
AS
BEGIN
/*

DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), 
		@Kd_Aset varchar(3), @Kd_Aset0 varchar(3),@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4), @D1 datetime 
SET @Tahun = '2011'
SET @D1 = '20111231'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '1'
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @Kd_UPB = ''
SET @Kd_Aset  = ''
SET @Kd_Aset0 = ''
SET @Kd_Aset1	= ''
SET @Kd_Aset2	= ''
SET @Kd_Aset3	= ''
SET @Kd_Aset4	= ''
SET @Kd_Aset5	= ''
SET @No_Register = ''
*/

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	IF ISNULL (@Kd_Aset,'') = '' SET @Kd_Aset = '%'
	IF ISNULL (@Kd_Aset0,'') = '' SET @Kd_Aset0 = '%'
    IF ISNULL (@Kd_Aset1,'') = '' SET @Kd_Aset1 = '%'
	IF ISNULL (@Kd_Aset2,'') = '' SET @Kd_Aset2 = '%'
	IF ISNULL (@Kd_Aset3,'') = '' SET @Kd_Aset3 = '%'
	IF ISNULL (@Kd_Aset4,'') = '' SET @Kd_Aset4 = '%'
	IF ISNULL (@Kd_Aset5,'') = '' SET @Kd_Aset5 = '%'
	IF ISNULL (@No_Register,'') = '' SET @No_Register = '%'



	INSERT INTO @UpdateKIB
	SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
			A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Bertingkat_Tidak, A.Beton_Tidak, A.Luas_Lantai, A.Lokasi, ISNULL(A.Dokumen_Tanggal, 0) AS Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah, 
			A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kd_Tanah, A.Asal_Usul, A.Kondisi, A.Harga, A.Keterangan, A.Kd_KA
	FROM
            	(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
				A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, '' AS Bertingkat_Tidak, '' Beton_Tidak, A.Luas_M2 AS Luas_Lantai, A.Alamat AS Lokasi, A.Tgl_Perolehan AS Dokumen_Tanggal, A.Sertifikat_Nomor AS Dokumen_Nomor, 
				'' AS Status_Tanah, '' AS Kd_Tanah1, '' AS Kd_Tanah2, '' AS Kd_Tanah3, '' AS Kd_Tanah4, '' AS Kd_Tanah5, '' AS Kd_Tanah, 
				A.Asal_Usul, 1 AS Kondisi, A.Harga, A.Keterangan, A.Kd_Data, A.Kd_KA
		FROM	Ta_KIB_A A
		WHERE	(Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) 
			AND (A.Kd_Data = 3) AND (A.Tgl_Pembukuan <= @D1)
	 
		UNION ALL

		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
				A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, '' AS Bertingkat_Tidak, '' Beton_Tidak, '' AS Luas_Lantai, '' AS Lokasi, A.Tgl_Perolehan AS Dokumen_Tanggal, A.Nomor_BPKB AS Dokumen_Nomor, 
				'' AS Status_Tanah, '' AS Kd_Tanah1, '' AS Kd_Tanah2, '' AS Kd_Tanah3, '' AS Kd_Tanah4, '' AS Kd_Tanah5, '' AS Kd_Tanah, 
				A.Asal_Usul, A.Kondisi, A.Harga, A.Keterangan, A.Kd_Data, A.Kd_KA
		FROM	Ta_KIB_B A
		WHERE	(Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) 
			 AND (A.Kd_Data = 3) AND (A.Tgl_Pembukuan <= @D1)
	
		UNION ALL
	
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
				A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Bertingkat_Tidak, A.Beton_Tidak, A.Luas_Lantai, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah,
				A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_Usul, A.Kondisi, A.Harga, A.Keterangan, A.Kd_Data, A.Kd_KA
		FROM	Ta_KIB_C A
		WHERE	(Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) 
                        AND (A.Kd_Data = 3) AND (A.Tgl_Pembukuan <= @D1)
	
		UNION ALL
	
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
				A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, '' AS Bertingkat_Tidak, '' Beton_Tidak, A.Luas, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah,
				A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_Usul, A.Kondisi, A.Harga, A.Keterangan, A.Kd_Data, A.Kd_KA
		FROM	Ta_KIB_D A
		WHERE	(Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) 
                        AND (A.Kd_Data = 3) AND (A.Tgl_Pembukuan <= @D1)
		
		UNION ALL

		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
				A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, '' AS Bertingkat_Tidak, '' Beton_Tidak, 0 AS Luas_Lantai, '' AS Lokasi, A.Tgl_Perolehan AS Dokumen_Tanggal, '' AS Dokumen_Nomor, 
				'' AS Status_Tanah, '' AS Kd_Tanah1, '' AS Kd_Tanah2, '' AS Kd_Tanah3, '' AS Kd_Tanah4, '' AS Kd_Tanah5, '' AS Kd_Tanah, 
				A.Asal_Usul, A.Kondisi AS Kondisi, A.Harga, A.Keterangan, A.Kd_Data, A.Kd_KA
		FROM	Ta_KIB_E A
		WHERE	(Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) 
			AND (A.Kd_Data = 3) AND (A.Tgl_Pembukuan <= @D1)
                
                UNION ALL

        SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
				A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, '' AS Bertingkat_Tidak, '' Beton_Tidak, A.Luas_M2 AS Luas_Lantai, A.Alamat AS Lokasi, A.Tgl_Perolehan AS Dokumen_Tanggal, A.Sertifikat_Nomor AS Dokumen_Nomor, 
				'' AS Status_Tanah, '' AS Kd_Tanah1, '' AS Kd_Tanah2, '' AS Kd_Tanah3, '' AS Kd_Tanah4, '' AS Kd_Tanah5, '' AS Kd_Tanah, 
				A.Asal_Usul, 1 AS Kondisi, A.Harga, A.Keterangan, A.Kd_Data, A.Kd_KA
		FROM	Ta_KIBAR A
		WHERE	(Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) 
			AND (A.Kd_Data = 3) AND (A.Tgl_Pembukuan <= @D1) AND (A.Tgl_Dokumen > @D1)
	 
		UNION ALL

		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
				A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, '' AS Bertingkat_Tidak, '' Beton_Tidak, '' AS Luas_Lantai, '' AS Lokasi, A.Tgl_Perolehan AS Dokumen_Tanggal, A.Nomor_BPKB AS Dokumen_Nomor, 
				'' AS Status_Tanah, '' AS Kd_Tanah1, '' AS Kd_Tanah2, '' AS Kd_Tanah3, '' AS Kd_Tanah4, '' AS Kd_Tanah5, '' AS Kd_Tanah, 
				A.Asal_Usul, A.Kondisi, A.Harga, A.Keterangan, A.Kd_Data, A.Kd_KA
		FROM	Ta_KIBBR A
		WHERE	(Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) 
				AND (A.Kd_Data = 3) AND (A.Tgl_Pembukuan <= @D1) AND (A.Tgl_Dokumen > @D1)
	
		UNION ALL
	
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
				A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Bertingkat_Tidak, A.Beton_Tidak, A.Luas_Lantai, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah,
				A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_Usul, A.Kondisi, A.Harga, A.Keterangan, A.Kd_Data, A.Kd_KA
		FROM	Ta_KIBCR A
		WHERE	(Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) 
                 AND (A.Kd_Data = 3) AND (A.Tgl_Pembukuan <= @D1) AND (A.Tgl_Dokumen > @D1)
	
		UNION ALL
	
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
				A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, '' AS Bertingkat_Tidak, '' Beton_Tidak, A.Luas, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah,
				A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5, A.Kode_Tanah, A.Asal_Usul, A.Kondisi, A.Harga, A.Keterangan, A.Kd_Data, A.Kd_KA
		FROM	Ta_KIBDR A
		WHERE	(Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) 
                AND (A.Kd_Data = 3) AND (A.Tgl_Pembukuan <= @D1) AND (A.Tgl_Dokumen > @D1)
		
		UNION ALL

		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81,A.Kd_Aset82,A.Kd_Aset83,A.Kd_Aset84,A.Kd_Aset85, A.No_Register, 
				A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan, '' AS Bertingkat_Tidak, '' Beton_Tidak, 0 AS Luas_Lantai, '' AS Lokasi, A.Tgl_Perolehan AS Dokumen_Tanggal, '' AS Dokumen_Nomor, 
				'' AS Status_Tanah, '' AS Kd_Tanah1, '' AS Kd_Tanah2, '' AS Kd_Tanah3, '' AS Kd_Tanah4, '' AS Kd_Tanah5, '' AS Kd_Tanah, 
				A.Asal_Usul, A.Kondisi AS Kondisi, A.Harga, A.Keterangan, A.Kd_Data, A.Kd_KA
		FROM	Ta_KIBER A
		WHERE	(Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB) 
			AND (A.Kd_Data = 3) AND (A.Tgl_Pembukuan <= @D1) AND (A.Tgl_Dokumen > @D1)
		) A

	
	
	RETURN END











GO
