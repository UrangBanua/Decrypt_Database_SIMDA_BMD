USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE dbo.SP_Mutasi_Barang @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @KdCari varchar(25), @Kd_KIB varchar(1), @pagenum INT, @perpage INT
WITH ENCRYPTION
AS

/*
DECLARE @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_KIB varchar(1), @KdCari varchar(25), @pagenum INT, @perpage INT
SET @Kd_Prov	= '30'
SET @Kd_Kab_Kota= '5'
SET @Kd_Bidang	= '6'
SET @Kd_Unit	= '1'
SET @Kd_Sub		= '1'
SET @Kd_UPB		= '1'
SET @Kd_KIB		= 'B'
SET @pagenum	= 1
SET @perpage	= 5000
SET @KdCari = 'pick'
--*/
	DECLARE
	@ubound INT,
	@lbound INT,
	@pages INT,
	@rows INT
	DECLARE @IDPemda varchar(17)
	DECLARE @D2 Datetime SET @D2 = getdate()
	DECLARE @Tahun varchar(4)
	SET @Tahun = YEAR(@D2)


IF @Kd_KIB = 'A'
BEGIN
	SET NOCOUNT ON

	SELECT @rows = COUNT(*), @pages = COUNT(*) / @perpage
	FROM Ta_KIB_A A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'

	IF @rows % @perpage != 0 SET @pages = @pages + 1
	IF @pagenum < 1 SET @pagenum = 1
	IF @pagenum > @pages SET @pagenum = @pages

	SET @ubound = @perpage * @pagenum
	SET @lbound = @ubound - (@perpage - 1)

	IF @lbound < 0 SET @lbound = 0
	SET ROWCOUNT @lbound

	SELECT @IDPemda = A.IDPemda
	FROM Ta_KIB_A A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'
	ORDER BY IDPemda

	SET ROWCOUNT @perPage

	SELECT A.IDPemda, 
 	REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang, Convert(Varchar,A.No_Reg8) AS No_Reg, B.Nm_Aset5, CONVERT(Varchar(20), A.Tgl_Perolehan,105) AS Tgl_Perolehan, CONVERT(varchar, C.Harga, 1) AS Harga, IsNull(A.Keterangan,'') AS Keterangan
 	FROM Ta_KIB_A A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
 	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5 INNER JOIN
	fn_Kartu108_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%', '%', '%', '%', '%', '%', 1) C ON
				A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
				AND A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
				AND A.No_Register = C.No_Register
	WHERE A.IDPemda >= @IDPemda AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'
 	ORDER BY A.IDPemda

	SET ROWCOUNT 0
END

IF @Kd_KIB = 'B'
BEGIN
	SET NOCOUNT ON

	SELECT @rows = COUNT(*), @pages = COUNT(*) / @perpage
	FROM Ta_KIB_B A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      AND A.Kondisi <= 3 AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'

	IF @rows % @perpage != 0 SET @pages = @pages + 1
	IF @pagenum < 1 SET @pagenum = 1
	IF @pagenum > @pages SET @pagenum = @pages

	SET @ubound = @perpage * @pagenum
	SET @lbound = @ubound - (@perpage - 1)

	IF @lbound < 0 SET @lbound = 0

	SET ROWCOUNT @lbound

	SELECT @IDPemda = A.IDPemda
	FROM Ta_KIB_B A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5 
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 
	      AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'
	ORDER BY IDPemda
	
	SET ROWCOUNT @perPage

	SELECT A.IDPemda, 
 	REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang, Convert(Varchar,A.No_Reg8) AS No_Reg, B.Nm_Aset5, CONVERT(Varchar(20), A.Tgl_Perolehan,105) AS Tgl_Perolehan, CONVERT(varchar, C.Harga, 1) AS Harga, IsNull(A.Keterangan,'') AS Keterangan
 	FROM Ta_KIB_B A WITH (NOLOCK) INNER JOIN 
		Ref_Rek5_108 B ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5 INNER JOIN
		fn_Kartu108_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%', '%', '%', '%', '%', '%', 1) C ON
				A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
				AND A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
				AND A.No_Register = C.No_Register
	WHERE A.IDPemda >= @IDPemda AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 
	      AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'
 	ORDER BY A.IDPemda

	SET ROWCOUNT 0
END

IF @Kd_KIB = 'C'
BEGIN
	SET NOCOUNT ON

	SELECT @rows = COUNT(*), @pages = COUNT(*) / @perpage
	FROM Ta_KIB_C A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5 
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 
	      AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'

	IF @rows % @perpage != 0 SET @pages = @pages + 1
	IF @pagenum < 1 SET @pagenum = 1
	IF @pagenum > @pages SET @pagenum = @pages

	SET @ubound = @perpage * @pagenum
	SET @lbound = @ubound - (@perpage - 1)

	IF @lbound < 0 SET @lbound = 0

	SET ROWCOUNT @lbound

	SELECT @IDPemda = A.IDPemda
	FROM Ta_KIB_C A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5  
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 
	      AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'
	ORDER BY IDPemda

	SET ROWCOUNT @perPage

	SELECT A.IDPemda, 
 	REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang, Convert(Varchar,A.No_Reg8) AS No_Reg, B.Nm_Aset5, CONVERT(Varchar(20), C.Tgl_Perolehan,105) AS Tgl_Perolehan, CONVERT(varchar, C.Harga, 1) AS Harga, IsNull(A.Keterangan,'') AS Keterangan
 	FROM Ta_KIB_C A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
 	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5 INNER JOIN
 	fn_Kartu108_BrgC(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%', '%', '%', '%', '%', '%', 1) C ON
				A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
				AND A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
				AND A.No_Register = C.No_Register
	WHERE A.IDPemda >= @IDPemda AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 
	      AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'
 	ORDER BY A.IDPemda

	SET ROWCOUNT 0
END

IF @Kd_KIB = 'D'
BEGIN
	SET NOCOUNT ON

	SELECT @rows = COUNT(*), @pages = COUNT(*) / @perpage
	FROM Ta_KIB_D A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 
	      AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'

	IF @rows % @perpage != 0 SET @pages = @pages + 1
	IF @pagenum < 1 SET @pagenum = 1
	IF @pagenum > @pages SET @pagenum = @pages

	SET @ubound = @perpage * @pagenum
	SET @lbound = @ubound - (@perpage - 1)

	IF @lbound < 0 SET @lbound = 0

	SET ROWCOUNT @lbound

	SELECT @IDPemda = A.IDPemda
	FROM Ta_KIB_D A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5 
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 
	      AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'
	ORDER BY IDPemda

	SET ROWCOUNT @perPage

	SELECT A.IDPemda, 
 	REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang, Convert(Varchar,A.No_Reg8) AS No_Reg, B.Nm_Aset5, CONVERT(Varchar(20), C.Tgl_Perolehan,105) AS Tgl_Perolehan, CONVERT(varchar, C.Harga, 1) AS Harga, IsNull(A.Keterangan,'') AS Keterangan
 	FROM Ta_KIB_D A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
 	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5 INNER JOIN
 	fn_Kartu108_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%', '%', '%', '%', '%', '%', 1) C ON
				A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
				AND A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
				AND A.No_Register = C.No_Register
	WHERE A.IDPemda >= @IDPemda AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 
	      AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'
 	ORDER BY A.IDPemda

	SET ROWCOUNT 0
END

IF @Kd_KIB = 'E'
BEGIN
	SET NOCOUNT ON

	SELECT @rows = COUNT(*), @pages = COUNT(*) / @perpage
	FROM Ta_KIB_E A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 
	      AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'

	IF @rows % @perpage != 0 SET @pages = @pages + 1
	IF @pagenum < 1 SET @pagenum = 1
	IF @pagenum > @pages SET @pagenum = @pages

	SET @ubound = @perpage * @pagenum
	SET @lbound = @ubound - (@perpage - 1)

	IF @lbound < 0 SET @lbound = 0

	SET ROWCOUNT @lbound

	SELECT @IDPemda = A.IDPemda
	FROM Ta_KIB_E A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5 
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 
	      AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'
	ORDER BY IDPemda

	SET ROWCOUNT @perPage

	SELECT A.IDPemda, 
 	REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang, Convert(Varchar,A.No_Reg8) AS No_Reg, B.Nm_Aset5, CONVERT(Varchar(20), C.Tgl_Perolehan,105) AS Tgl_Perolehan, CONVERT(varchar, C.Harga, 1) AS Harga, IsNull(A.Keterangan,'') AS Keterangan
 	FROM Ta_KIB_E A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
 	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5 INNER JOIN
 	fn_Kartu108_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%', '%', '%', '%', '%', '%', '%', '%', 1) C ON
				A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
				AND A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_Aset0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
				AND A.No_Register = C.No_Register
	WHERE A.IDPemda >= @IDPemda AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 
	      AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'
 	ORDER BY A.IDPemda

	SET ROWCOUNT 0
END

IF @Kd_KIB = 'F'
BEGIN
	SET NOCOUNT ON

	DECLARE @DataKIB TABLE(IDPemda Varchar(17), Kd_Aset tinyint, Kd_Aset0 tinyint, Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, Harga Money, Tgl_Perolehan Datetime, Keterangan Varchar(255), Nm_Aset5 Varchar(255))

	INSERT INTO @DataKIB
	SELECT A.IDPemda, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8, A.Harga, A.Tgl_Perolehan, A.Keterangan, B.Nm_Aset5
	FROM Ta_KIB_A A INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit  
              AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB 
	      AND A.Kd_Hapus = 0 AND A.Kd_Data = 3
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'

	INSERT INTO @DataKIB
    SELECT A.IDPemda, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8, A.Harga, A.Tgl_Perolehan, A.Keterangan, B.Nm_Aset5
	FROM Ta_KIB_B A INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      AND A.Kondisi <= 3 AND A.Kd_Hapus = 0 AND A.Kd_Data = 3
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'

	INSERT INTO @DataKIB
    SELECT A.IDPemda, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8, A.Harga, A.Tgl_Perolehan, A.Keterangan, B.Nm_Aset5
	FROM Ta_KIB_C A INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 
	      AND A.Kd_Hapus = 0 AND A.Kd_Data = 3
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'

	INSERT INTO @DataKIB
    SELECT A.IDPemda, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8, A.Harga, A.Tgl_Perolehan, A.Keterangan, B.Nm_Aset5
	FROM Ta_KIB_D A INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 
	      AND A.Kd_Hapus = 0 AND A.Kd_Data = 3
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'

	INSERT INTO @DataKIB
        SELECT A.IDPemda, A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8, A.Harga, A.Tgl_Perolehan, A.Keterangan, B.Nm_Aset5
	FROM Ta_KIB_E A INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 
	      AND A.Kd_Hapus = 0 AND A.Kd_Data = 3
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'


	SELECT @rows = COUNT(*), @pages = COUNT(*) / @perpage
	FROM @DataKIB

	IF @rows % @perpage != 0 SET @pages = @pages + 1
	IF @pagenum < 1 SET @pagenum = 1
	IF @pagenum > @pages SET @pagenum = @pages

	SET @ubound = @perpage * @pagenum
	SET @lbound = @ubound - (@perpage - 1)

	IF @lbound < 0 SET @lbound = 0

	SET ROWCOUNT @lbound

	SELECT @IDPemda = A.IDPemda
	FROM @DataKIB A
	ORDER BY A.IDPemda

	SET ROWCOUNT @perPage

	SELECT A.IDPemda, 
 	REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang, Convert(Varchar,A.No_Register) AS No_Reg, A.Nm_Aset5, CONVERT(Varchar(20), Tgl_Perolehan,105) AS Tgl_Perolehan, CONVERT(varchar, A.Harga, 1) AS Harga, IsNull(A.Keterangan,'') AS Keterangan
 	FROM @DataKIB A 
 	ORDER BY A.IDPemda

	SET ROWCOUNT 0
END

IF @Kd_KIB = 'L'
BEGIN
	SET NOCOUNT ON

	SELECT @rows = COUNT(*), @pages = COUNT(*) / @perpage
	FROM Ta_Lainnya A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5 
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 --AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'

	IF @rows % @perpage != 0 SET @pages = @pages + 1
	IF @pagenum < 1 SET @pagenum = 1
	IF @pagenum > @pages SET @pagenum = @pages

	SET @ubound = @perpage * @pagenum
	SET @lbound = @ubound - (@perpage - 1)

	IF @lbound < 0 SET @lbound = 0

	SET ROWCOUNT @lbound

	SELECT @IDPemda = A.IDPemda
	FROM Ta_Lainnya A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5  
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 --AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'
	ORDER BY IDPemda

	SET ROWCOUNT @perPage

	SELECT A.IDPemda, 
 	REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang, Convert(Varchar,A.No_Reg8) AS No_Reg, B.Nm_Aset5, CONVERT(Varchar(20), Tgl_Perolehan,105) AS Tgl_Perolehan, CONVERT(varchar, Harga, 1) AS Harga, IsNull(A.Keterangan,'') AS Keterangan
 	FROM Ta_Lainnya A WITH (NOLOCK) INNER JOIN Ref_Rek5_108 B 
 	ON A.Kd_Aset8=B.Kd_Aset AND A.Kd_Aset80=B.Kd_Aset0 AND A.Kd_Aset81=B.Kd_Aset1 AND A.Kd_Aset82=B.Kd_Aset2 AND A.Kd_Aset83=B.Kd_Aset3 AND A.Kd_Aset84=B.Kd_Aset4 AND A.Kd_Aset85=B.Kd_Aset5  
	WHERE IDPemda >= @IDPemda AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	      --AND A.Kondisi <= 3 --AND A.Kd_Hapus = 0
	      AND B.Nm_Aset5 LIKE '%'+@KdCari+'%'
 	ORDER BY A.IDPemda

	SET ROWCOUNT 0
END








GO
