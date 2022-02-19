USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Ta_KIB_Hps_Isi - 20022020 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Ta_KIB_Hps_Isi @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@D2 Datetime, @KdKIB varchar(2), @IDUser varchar(20), @Kd_Kondisi varchar(2), @Tahun varchar(4), @KdTgl varchar(2)
WITH ENCRYPTION
AS
	
/*
DECLARE @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D2 Datetime, @KdKIB varchar(1), @IDUser varchar(20), @Kd_Kondisi varchar(2), @Tahun varchar(4), @KdTgl varchar(2)
SET @D2 = '20191231'
SET @Kd_Prov   = '30'
SET @Kd_Kab_Kota = '5'
SET @Kd_Bidang = '5' 
SET @Kd_Unit   = '1' 
SET @Kd_Sub    = '1'
SET @Kd_UPB    = '1'
SET @KdKIB     = 'D'
SET @IDUser    = 'admin'
SET @Kd_Kondisi = '1' 
SET @Tahun      = '2004'
SET @KdTgl      = '1'
*/

	DECLARE @JLap tinyint SET @JLap = 1
	DECLARE @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @Reg varchar(4)
	SET @Kd_Aset 	= '%'
	SET @Kd_Aset0	= '%'
	SET @Kd_Aset1	= '%'
	SET @Kd_Aset2	= '%'
	SET @Kd_Aset3	= '%'
	SET @Kd_Aset4	= '%'
	SET @Kd_Aset5	= '%'
	SET @Reg        = '%' 
	
	DECLARE @TahunBerjalan Varchar(4)
	SELECT DISTINCT @TahunBerjalan=MAX(Tahun) FROM Ta_Fn_KIB_B
		
	IF ISNULL(@Kd_Prov, '') = '' SET @Kd_Prov = '%'
	IF ISNULL(@Kd_Kab_Kota, '') = '' SET @Kd_Kab_Kota = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	IF ISNULL(@Tahun, '') = '' SET @Tahun = '%'	
			
   IF ((@KdKIB = 'A') AND (@KdTgl = '1'))
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	    
	    SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, 0 AS Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(A.Harga, A.Harga) AS Harga, 1 AS Kondisi
		FROM Ta_Fn_KIB_A A INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Perolehan) = @Tahun AND A.Tahun = @TahunBerjalan
		ORDER BY A.IDPemda, Kd_Gab_Barang
		
		/*SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(B.Harga, A.Harga) AS Harga, 1 AS Kondisi
		FROM Ta_KIB_A A INNER JOIN 
			fn_Kartu108_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset, @Kd_Aset0, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @Reg, @JLap) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
			AND A.No_Reg8 = B.No_Register INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Perolehan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang*/
   END

   IF ((@KdKIB = 'A') AND (@KdTgl = '2'))
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	    
	    SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, 0 AS Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(A.Harga, A.Harga) AS Harga, 1 AS Kondisi
		FROM Ta_Fn_KIB_A A INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Pembukuan) = @Tahun AND A.Tahun = @TahunBerjalan
		ORDER BY A.IDPemda, Kd_Gab_Barang
		
		/*SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(B.Harga, A.Harga) AS Harga, 1 AS Kondisi
		FROM Ta_KIB_A A INNER JOIN 
			fn_Kartu108_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset, @Kd_Aset0, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @Reg, @JLap) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
			AND A.No_Reg8 = B.No_Register INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Pembukuan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang*/
   END

   IF ((@KdKIB = 'B') AND (@KdTgl = '1'))
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
			
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, 0 AS Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(A.Harga, A.Harga) AS Harga, A.Kondisi
		FROM Ta_Fn_KIB_B A INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Perolehan) = @Tahun AND A.Kondisi LIKE @Kd_Kondisi AND A.Tahun = @TahunBerjalan
		ORDER BY A.IDPemda, Kd_Gab_Barang
   END

   IF ((@KdKIB = 'B') AND (@KdTgl = '2'))
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
		
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, 0 AS Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(A.Harga, A.Harga) AS Harga, A.Kondisi
		FROM Ta_Fn_KIB_B A INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Pembukuan) = @Tahun AND A.Kondisi LIKE @Kd_Kondisi AND A.Tahun = @TahunBerjalan
		ORDER BY A.IDPemda, Kd_Gab_Barang
   END

   IF ((@KdKIB = 'C') AND (@KdTgl = '1'))
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	    
	    SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, 0 AS Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(A.Harga, A.Harga) AS Harga, A.Kondisi
		FROM Ta_Fn_KIB_C A INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Perolehan) = @Tahun AND A.Kondisi LIKE @Kd_Kondisi AND A.Tahun = @TahunBerjalan
		ORDER BY A.IDPemda, Kd_Gab_Barang
		
		/*SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(B.Harga, A.Harga) AS Harga, B.Kondisi
		FROM Ta_KIB_C A INNER JOIN 
			fn_Kartu108_BrgC_Hps(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset, @Kd_Aset0, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @Reg, @JLap, @Kd_Kondisi) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
			AND A.No_Reg8 = B.No_Register INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Perolehan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang*/
   END

   IF ((@KdKIB = 'C') AND (@KdTgl = '2'))
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, 0 AS Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(A.Harga, A.Harga) AS Harga, A.Kondisi
		FROM Ta_Fn_KIB_C A INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Pembukuan) = @Tahun AND A.Kondisi LIKE @Kd_Kondisi AND A.Tahun = @TahunBerjalan
		ORDER BY A.IDPemda, Kd_Gab_Barang
		
		/*SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(B.Harga, A.Harga) AS Harga, B.Kondisi
		FROM Ta_KIB_C A INNER JOIN 
			fn_Kartu108_BrgC_Hps(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset, @Kd_Aset0, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @Reg, @JLap, @Kd_Kondisi) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
			AND A.No_Reg8 = B.No_Register INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Pembukuan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang*/
   END

   IF ((@KdKIB = 'D') AND (@KdTgl = '1'))
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, 0 AS Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(A.Harga, A.Harga) AS Harga, A.Kondisi
		FROM Ta_Fn_KIB_D A INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
		AND Year(A.Tgl_Perolehan) LIKE @Tahun AND A.Kondisi LIKE @Kd_Kondisi AND A.Tahun = @TahunBerjalan
		ORDER BY A.IDPemda, Kd_Gab_Barang

		/*SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(B.Harga, A.Harga) AS Harga, B.Kondisi
		FROM Ta_KIB_D A INNER JOIN 
			fn_Kartu108_BrgD_Hps(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset, @Kd_Aset0, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @Reg, @JLap, @Kd_Kondisi) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
			AND A.No_Reg8 = B.No_Register INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND B.Kondisi = @Kd_Kondisi
		AND Year(A.Tgl_Perolehan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang*/
   END

   IF ((@KdKIB = 'D') AND (@KdTgl = '2'))
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, 0 AS Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(A.Harga, A.Harga) AS Harga, A.Kondisi
		FROM Ta_Fn_KIB_D A INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Pembukuan) LIKE @Tahun AND A.Kondisi LIKE @Kd_Kondisi AND A.Tahun = @TahunBerjalan
		ORDER BY A.IDPemda, Kd_Gab_Barang
		
		/*SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(B.Harga, A.Harga) AS Harga, B.Kondisi
		FROM Ta_KIB_D A INNER JOIN 
			fn_Kartu108_BrgD_Hps(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset, @Kd_Aset0, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @Reg, @JLap, @Kd_Kondisi) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
			AND A.No_Reg8 = B.No_Register INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND B.Kondisi = @Kd_Kondisi
		AND Year(A.Tgl_Pembukuan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang*/
   END

   IF ((@KdKIB = 'E') AND (@KdTgl = '1'))
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, 0 AS Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(A.Harga, A.Harga) AS Harga, A.Kondisi
		FROM Ta_Fn_KIB_E A INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Perolehan) = @Tahun AND A.Kondisi LIKE @Kd_Kondisi AND A.Tahun = @TahunBerjalan
		ORDER BY A.IDPemda, Kd_Gab_Barang
		
		/*SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(B.Harga, A.Harga) AS Harga, B.Kondisi
		FROM Ta_KIB_E A INNER JOIN 
			fn_Kartu108_BrgE_Hps(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset, @Kd_Aset0, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @Reg, @JLap, @Kd_Kondisi) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
			AND A.No_Reg8 = B.No_Register INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND B.Kondisi = @Kd_Kondisi
		AND Year(A.Tgl_Perolehan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang*/
   END

   IF ((@KdKIB = 'E') AND (@KdTgl = '2'))
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
	    SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, 0 AS Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(A.Harga, A.Harga) AS Harga, A.Kondisi
		FROM Ta_Fn_KIB_E A INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Pembukuan) = @Tahun AND A.Kondisi LIKE @Kd_Kondisi AND A.Tahun = @TahunBerjalan
		ORDER BY A.IDPemda, Kd_Gab_Barang
		
		/*SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(B.Harga, A.Harga) AS Harga, B.Kondisi
		FROM Ta_KIB_E A INNER JOIN 
			fn_Kartu108_BrgE_Hps(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset, @Kd_Aset0, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @Reg, @JLap, @Kd_Kondisi) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
			AND A.No_Reg8 = B.No_Register INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND B.Kondisi = @Kd_Kondisi
		AND Year(A.Tgl_Pembukuan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang*/
   END

   IF ((@KdKIB = 'L') AND (@KdTgl = '1'))
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
	    SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, 0 AS Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(A.Harga, A.Harga) AS Harga, A.Kondisi
		FROM Ta_Fn_KIB_L A INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Perolehan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang
		
		/*SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(B.Harga, A.Harga) AS Harga, B.Kondisi
		FROM Ta_Lainnya A INNER JOIN 
			fn_Kartu108_BrgL_Hps(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset, @Kd_Aset0, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @Reg, @JLap, @Kd_Kondisi) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
			AND A.No_Reg8 = B.No_Register INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND B.Kondisi = @Kd_Kondisi
		AND Year(A.Tgl_Perolehan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang*/
   END

   IF ((@KdKIB = 'L') AND (@KdTgl = '2'))
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	    
	    SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, 0 AS Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(A.Harga, A.Harga) AS Harga, A.Kondisi
		FROM Ta_Fn_KIB_L A INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset = C.Kd_Aset AND A.Kd_Aset0 = C.Kd_Aset0 AND A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Pembukuan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang
		
		/*SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, ISNULL(B.Harga, A.Harga) AS Harga, B.Kondisi
		FROM Ta_Lainnya A INNER JOIN 
			fn_Kartu108_BrgL_Hps(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, @Kd_Aset, @Kd_Aset0, @Kd_Aset1, @Kd_Aset2, @Kd_Aset3, @Kd_Aset4, @Kd_Aset5, @Reg, @JLap, @Kd_Kondisi) B ON
			A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
			AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
			AND A.No_Reg8 = B.No_Register INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND B.Kondisi = @Kd_Kondisi
		AND Year(A.Tgl_Pembukuan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang*/
   END

   IF ((@KdKIB = 'F') AND (@KdTgl = '1')) /*Sebagian A*/
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, A.Harga, 1 AS Kondisi
		FROM Ta_KIB_A A INNER JOIN
		Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Perolehan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang
   END

   IF ((@KdKIB = 'F') AND (@KdTgl = '2')) /*Sebagian A*/
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, A.Harga, 1 AS Kondisi
		FROM Ta_KIB_A A INNER JOIN
			Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND Year(A.Tgl_Pembukuan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang
   END

   IF ((@KdKIB = 'G') AND (@KdTgl = '1')) /*Sebagian B*/
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, A.Harga, A.Kondisi
		FROM Ta_KIB_B A INNER JOIN
			Ref_Rek5_108 C ON A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
			--Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kondisi = @Kd_Kondisi
		AND Year(A.Tgl_Perolehan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang
   END

   IF ((@KdKIB = 'G') AND (@KdTgl = '2')) /*Sebagian B*/
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, A.Harga, A.Kondisi
		FROM Ta_KIB_B A INNER JOIN
			Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kondisi = @Kd_Kondisi
		AND Year(A.Tgl_Pembukuan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang
   END

   IF ((@KdKIB = 'H') AND (@KdTgl = '1')) /*Sebagian C*/
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, A.Harga, A.Kondisi
		FROM Ta_KIB_C A INNER JOIN
			Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kondisi = @Kd_Kondisi
		AND Year(A.Tgl_Perolehan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang
   END

   IF ((@KdKIB = 'H') AND (@KdTgl = '2')) /*Sebagian C*/
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, A.Harga, A.Kondisi
		FROM Ta_KIB_C A INNER JOIN
			Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kondisi = @Kd_Kondisi
		AND Year(A.Tgl_Pembukuan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang
   END

   IF ((@KdKIB = 'I') AND (@KdTgl = '1')) /*Sebagian D*/
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, A.Harga, A.Kondisi
		FROM Ta_KIB_D A INNER JOIN
			Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kondisi = @Kd_Kondisi
		AND Year(A.Tgl_Perolehan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang
   END

   IF ((@KdKIB = 'I') AND (@KdTgl = '2')) /*Sebagian D*/
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, A.Harga, A.Kondisi
		FROM Ta_KIB_D A INNER JOIN
			Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
			AND A.Kondisi = @Kd_Kondisi
		AND Year(A.Tgl_Pembukuan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang
   END

   IF ((@KdKIB = 'J') AND (@KdTgl = '1')) /*Sebagian E*/
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, A.Harga, A.Kondisi
		FROM Ta_KIB_E A INNER JOIN
			Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kondisi = @Kd_Kondisi
		AND Year(A.Tgl_Perolehan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang
   END

   IF ((@KdKIB = 'J') AND (@KdTgl = '2')) /*Sebagian E*/
   BEGIN
        DELETE Ta_KIB_Hps WHERE IDUser = @IDUser

        INSERT INTO Ta_KIB_Hps(IDPemda, IDUser, IDUrut, Kd_Hapus, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Barang, No_Register, Nm_Aset, Harga, Kondisi)
	
		SELECT DISTINCT A.IDPemda, @IDUser AS IDUser, 0 AS IDUrut, A.Kd_Hapus, 
				A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
 				--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
 				REPLACE(dbo.fn_GabBarang_108(Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang,
				A.No_Register, C.Nm_Aset5, A.Harga, A.Kondisi
		FROM Ta_KIB_E A INNER JOIN
			Ref_Rek_Aset5 C ON A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5
		WHERE A.Kd_Hapus = 0 AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		AND A.Kondisi = @Kd_Kondisi
		AND Year(A.Tgl_Perolehan) = @Tahun
		ORDER BY A.IDPemda, Kd_Gab_Barang
   END






GO
