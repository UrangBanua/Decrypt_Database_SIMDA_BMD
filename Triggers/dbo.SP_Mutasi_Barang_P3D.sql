USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Mutasi_Barang_P3D - 22032017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Mutasi_Barang_P3D @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_KIB varchar(1), @pagenum INT, @perpage INT
WITH ENCRYPTION
AS

/*
DECLARE @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_KIB varchar(1), @pagenum INT, @perpage INT
SET @Kd_Prov	= '99'
SET @Kd_Kab_Kota= '99'
SET @Kd_Bidang	= '5'
SET @Kd_Unit	= '1'
SET @Kd_Sub	= '1'
SET @Kd_UPB	= '101'
SET @Kd_KIB	= 'B'
SET @pagenum	= 6
SET @perpage	= 10
*/

DECLARE	@ubound INT, @lbound INT, @pages INT, @rows INT
DECLARE @IDPemda varchar(17)

IF @Kd_KIB = 'A'
BEGIN
	SET NOCOUNT ON

	SELECT @rows = COUNT(*), @pages = COUNT(*) / @perpage
	FROM BMD_KAB.dbo.Ta_KIB_A A WITH (NOLOCK)
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB

	IF @rows % @perpage != 0 SET @pages = @pages + 1
	IF @pagenum < 1 SET @pagenum = 1
	IF @pagenum > @pages SET @pagenum = @pages

	SET @ubound = @perpage * @pagenum
	SET @lbound = @ubound - (@perpage - 1)

	IF @lbound < 0 SET @lbound = 0

	--SELECT CurrentPage = @pagenum, TotalPages = @pages, TotalRows = @rows

	SET ROWCOUNT @lbound

	SELECT @IDPemda = A.IDPemda
	FROM BMD_KAB.dbo.Ta_KIB_A A WITH (NOLOCK)
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	ORDER BY IDPemda

	SET ROWCOUNT @perPage

	SELECT A.IDPemda, 
 	REPLACE(BMD_KAB.dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang, Convert(Varchar,A.No_Register) AS No_Reg, B.Nm_Aset5, IsNull(A.Keterangan,'') AS Keterangan
 	FROM BMD_KAB.dbo.Ta_KIB_A A WITH (NOLOCK) INNER JOIN BMD_KAB.dbo.Ref_Rek_Aset5 B 
 	ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5 
	WHERE IDPemda >= @IDPemda AND A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
 	ORDER BY A.IDPemda

	SET ROWCOUNT 0
END

IF @Kd_KIB = 'B'
BEGIN
	SET NOCOUNT ON

	SELECT @rows = COUNT(*), @pages = COUNT(*) / @perpage
	FROM BMD_KAB.dbo.Ta_KIB_B A WITH (NOLOCK)
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB

	IF @rows % @perpage != 0 SET @pages = @pages + 1
	IF @pagenum < 1 SET @pagenum = 1
	IF @pagenum > @pages SET @pagenum = @pages

	SET @ubound = @perpage * @pagenum
	SET @lbound = @ubound - (@perpage - 1)

	IF @lbound < 0 SET @lbound = 0

	SET ROWCOUNT @lbound

	SELECT @IDPemda = A.IDPemda
	FROM BMD_KAB.dbo.Ta_KIB_B A WITH (NOLOCK)
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	ORDER BY IDPemda

	SET ROWCOUNT @perPage

	SELECT A.IDPemda, 
 	REPLACE(BMD_KAB.dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang, Convert(Varchar,A.No_Register) AS No_Reg, B.Nm_Aset5, IsNull(A.Keterangan,'') AS Keterangan
 	FROM BMD_KAB.dbo.Ta_KIB_B A WITH (NOLOCK) INNER JOIN BMD_KAB.dbo.Ref_Rek_Aset5 B 
 	ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5 
	WHERE IDPemda >= @IDPemda AND A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
 	ORDER BY A.IDPemda

	SET ROWCOUNT 0
END

IF @Kd_KIB = 'C'
BEGIN
	SET NOCOUNT ON

	SELECT @rows = COUNT(*), @pages = COUNT(*) / @perpage
	FROM BMD_KAB.dbo.Ta_KIB_C A WITH (NOLOCK)
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB

	IF @rows % @perpage != 0 SET @pages = @pages + 1
	IF @pagenum < 1 SET @pagenum = 1
	IF @pagenum > @pages SET @pagenum = @pages

	SET @ubound = @perpage * @pagenum
	SET @lbound = @ubound - (@perpage - 1)

	IF @lbound < 0 SET @lbound = 0

	SET ROWCOUNT @lbound

	SELECT @IDPemda = A.IDPemda
	FROM BMD_KAB.dbo.Ta_KIB_C A WITH (NOLOCK)
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	ORDER BY IDPemda

	SET ROWCOUNT @perPage

	SELECT A.IDPemda, 
 	REPLACE(BMD_KAB.dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang, Convert(Varchar,A.No_Register) AS No_Reg, B.Nm_Aset5, IsNull(A.Keterangan,'') AS Keterangan
 	FROM BMD_KAB.dbo.Ta_KIB_C A WITH (NOLOCK) INNER JOIN BMD_KAB.dbo.Ref_Rek_Aset5 B 
 	ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5 
	WHERE IDPemda >= @IDPemda AND A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
 	ORDER BY A.IDPemda

	SET ROWCOUNT 0
END

IF @Kd_KIB = 'D'
BEGIN
	SET NOCOUNT ON

	SELECT @rows = COUNT(*), @pages = COUNT(*) / @perpage
	FROM BMD_KAB.dbo.Ta_KIB_D A WITH (NOLOCK)
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB

	IF @rows % @perpage != 0 SET @pages = @pages + 1
	IF @pagenum < 1 SET @pagenum = 1
	IF @pagenum > @pages SET @pagenum = @pages

	SET @ubound = @perpage * @pagenum
	SET @lbound = @ubound - (@perpage - 1)

	IF @lbound < 0 SET @lbound = 0

	SET ROWCOUNT @lbound

	SELECT @IDPemda = A.IDPemda
	FROM BMD_KAB.dbo.Ta_KIB_D A WITH (NOLOCK)
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	ORDER BY IDPemda

	SET ROWCOUNT @perPage

	SELECT A.IDPemda, 
 	REPLACE(BMD_KAB.dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang, Convert(Varchar,A.No_Register) AS No_Reg, B.Nm_Aset5, IsNull(A.Keterangan,'') AS Keterangan
 	FROM BMD_KAB.dbo.Ta_KIB_D A WITH (NOLOCK) INNER JOIN BMD_KAB.dbo.Ref_Rek_Aset5 B 
 	ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5 
	WHERE IDPemda >= @IDPemda AND A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
 	ORDER BY A.IDPemda

	SET ROWCOUNT 0
END

IF @Kd_KIB = 'E'
BEGIN
	SET NOCOUNT ON

	SELECT @rows = COUNT(*), @pages = COUNT(*) / @perpage
	FROM BMD_KAB.dbo.Ta_KIB_E A WITH (NOLOCK)
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB

	IF @rows % @perpage != 0 SET @pages = @pages + 1
	IF @pagenum < 1 SET @pagenum = 1
	IF @pagenum > @pages SET @pagenum = @pages

	SET @ubound = @perpage * @pagenum
	SET @lbound = @ubound - (@perpage - 1)

	IF @lbound < 0 SET @lbound = 0

	SET ROWCOUNT @lbound

	SELECT @IDPemda = A.IDPemda
	FROM BMD_KAB.dbo.Ta_KIB_E A WITH (NOLOCK)
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	ORDER BY IDPemda

	SET ROWCOUNT @perPage

	SELECT A.IDPemda, 
 	REPLACE(BMD_KAB.dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang, Convert(Varchar,A.No_Register) AS No_Reg, B.Nm_Aset5, IsNull(A.Keterangan,'') AS Keterangan
 	FROM BMD_KAB.dbo.Ta_KIB_E A WITH (NOLOCK) INNER JOIN BMD_KAB.dbo.Ref_Rek_Aset5 B 
 	ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5 
	WHERE IDPemda >= @IDPemda AND A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
 	ORDER BY A.IDPemda

	SET ROWCOUNT 0
END

IF @Kd_KIB = 'F'
BEGIN
	SET NOCOUNT ON

	SELECT @rows = COUNT(*), @pages = COUNT(*) / @perpage
	FROM BMD_KAB.dbo.Ta_Lainnya A WITH (NOLOCK)
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB

	IF @rows % @perpage != 0 SET @pages = @pages + 1
	IF @pagenum < 1 SET @pagenum = 1
	IF @pagenum > @pages SET @pagenum = @pages

	SET @ubound = @perpage * @pagenum
	SET @lbound = @ubound - (@perpage - 1)

	IF @lbound < 0 SET @lbound = 0

	SET ROWCOUNT @lbound

	SELECT @IDPemda = A.IDPemda
	FROM BMD_KAB.dbo.Ta_Lainnya A WITH (NOLOCK)
	WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
	ORDER BY IDPemda

	SET ROWCOUNT @perPage

	SELECT A.IDPemda, 
 	REPLACE(BMD_KAB.dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang, Convert(Varchar,A.No_Register) AS No_Reg, B.Nm_Aset5, IsNull(A.Keterangan,'') AS Keterangan
 	FROM BMD_KAB.dbo.Ta_Lainnya A WITH (NOLOCK) INNER JOIN BMD_KAB.dbo.Ref_Rek_Aset5 B 
 	ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5 
	WHERE IDPemda >= @IDPemda AND A.Kd_Prov = @Kd_Prov AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
              A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
 	ORDER BY A.IDPemda

	SET ROWCOUNT 0
END



GO
