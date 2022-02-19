USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** SP_Ta_KIB_Batal_Pindah - 22032017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE [dbo].[SP_Ta_KIB_Batal_Pindah] @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_KIB varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_KIB varchar(3)
SET @Kd_Prov	= '20'
SET @Kd_Kab_Kota= '3'
SET @Kd_Bidang	= '4' 
SET @Kd_Unit	= '1' 
SET @Kd_Sub	= '1'
SET @Kd_UPB	= '101'
SET @Kd_KIB	= 'B'
*/

IF @Kd_KIB = 'A'
BEGIN
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, B.Kd_Id, A.Tgl_Perolehan, B.No_Dokumen, B.Tgl_Dokumen,
		REPLACE(dbo.fn_GabUPB(B.Kd_Bidang1, B.Kd_Unit1, B.Kd_Sub1, B.Kd_UPB1), ' . ', '.') AS SKPD_Tujuan, B.No_Register1,
		REPLACE(dbo.fn_GabUPB(B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB), ' . ', '.') AS SKPD_Asal, B.No_Register,
		REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
		dbo.fn108_NmBarang(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85) AS NmBarang,
		A.Harga, A.Keterangan, A.Kd_Hapus,
		B.Kd_Bidang1, B.Kd_Unit1, B.Kd_Sub1, B.Kd_UPB1,
		B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB,
		A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5
	FROM Ta_KIB_A A INNER JOIN Ta_KIBAR B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang = @Kd_Bidang 
		AND B.Kd_Unit = @Kd_Unit AND B.Kd_Sub = @Kd_Sub AND B.Kd_UPB = @Kd_UPB
		AND A.Kd_Hapus = 0 AND B.Kd_Riwayat = 3
    	ORDER BY B.Tgl_Dokumen DESC
END

IF @Kd_KIB = 'B'
BEGIN
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, B.Kd_Id, A.Tgl_Perolehan, B.No_Dokumen, B.Tgl_Dokumen,
		REPLACE(dbo.fn_GabUPB(B.Kd_Bidang1, B.Kd_Unit1, B.Kd_Sub1, B.Kd_UPB1), ' . ', '.') AS SKPD_Tujuan, B.No_Register1,
		REPLACE(dbo.fn_GabUPB(B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB), ' . ', '.') AS SKPD_Asal, B.No_Register,
		REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
		dbo.fn108_NmBarang(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85) AS NmBarang,
		A.Harga, A.Keterangan, A.Kd_Hapus,
		B.Kd_Bidang1, B.Kd_Unit1, B.Kd_Sub1, B.Kd_UPB1,
		B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB,
		A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5
	FROM Ta_KIB_B A INNER JOIN Ta_KIBBR B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang = @Kd_Bidang 
		AND B.Kd_Unit = @Kd_Unit AND B.Kd_Sub = @Kd_Sub AND B.Kd_UPB = @Kd_UPB
		AND A.Kd_Hapus = 0 AND B.Kd_Riwayat = 3
    	ORDER BY B.Tgl_Dokumen DESC
END

IF @Kd_KIB = 'C'
BEGIN
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, B.Kd_Id, A.Tgl_Perolehan, B.No_Dokumen, B.Tgl_Dokumen,
		REPLACE(dbo.fn_GabUPB(B.Kd_Bidang1, B.Kd_Unit1, B.Kd_Sub1, B.Kd_UPB1), ' . ', '.') AS SKPD_Tujuan, B.No_Register1,
		REPLACE(dbo.fn_GabUPB(B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB), ' . ', '.') AS SKPD_Asal, B.No_Register,
		REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
		dbo.fn108_NmBarang(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85) AS NmBarang,
		A.Harga, A.Keterangan, A.Kd_Hapus,
		B.Kd_Bidang1, B.Kd_Unit1, B.Kd_Sub1, B.Kd_UPB1,
		B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB,
		A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5
	FROM Ta_KIB_C A INNER JOIN Ta_KIBCR B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang = @Kd_Bidang 
		AND B.Kd_Unit = @Kd_Unit AND B.Kd_Sub = @Kd_Sub AND B.Kd_UPB = @Kd_UPB
		AND A.Kd_Hapus = 0 AND B.Kd_Riwayat = 3
    	ORDER BY B.Tgl_Dokumen DESC
END

IF @Kd_KIB = 'D'
BEGIN
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, B.Kd_Id, A.Tgl_Perolehan, B.No_Dokumen, B.Tgl_Dokumen,
		REPLACE(dbo.fn_GabUPB(B.Kd_Bidang1, B.Kd_Unit1, B.Kd_Sub1, B.Kd_UPB1), ' . ', '.') AS SKPD_Tujuan, B.No_Register1,
		REPLACE(dbo.fn_GabUPB(B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB), ' . ', '.') AS SKPD_Asal, B.No_Register,
		REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
		dbo.fn108_NmBarang(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85) AS NmBarang,
		A.Harga, A.Keterangan, A.Kd_Hapus,
		B.Kd_Bidang1, B.Kd_Unit1, B.Kd_Sub1, B.Kd_UPB1,
		B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB,
		A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5
	FROM Ta_KIB_D A INNER JOIN Ta_KIBDR B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang = @Kd_Bidang 
		AND B.Kd_Unit = @Kd_Unit AND B.Kd_Sub = @Kd_Sub AND B.Kd_UPB = @Kd_UPB
		AND A.Kd_Hapus = 0 AND B.Kd_Riwayat = 3
    	ORDER BY B.Tgl_Dokumen DESC
END

IF @Kd_KIB = 'E'
BEGIN
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, B.Kd_Id, A.Tgl_Perolehan, B.No_Dokumen, B.Tgl_Dokumen,
		REPLACE(dbo.fn_GabUPB(B.Kd_Bidang1, B.Kd_Unit1, B.Kd_Sub1, B.Kd_UPB1), ' . ', '.') AS SKPD_Tujuan, B.No_Register1,
		REPLACE(dbo.fn_GabUPB(B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB), ' . ', '.') AS SKPD_Asal, B.No_Register,
		REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang,
		dbo.fn108_NmBarang(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85) AS NmBarang,
		A.Harga, A.Keterangan, A.Kd_Hapus,
		B.Kd_Bidang1, B.Kd_Unit1, B.Kd_Sub1, B.Kd_UPB1,
		B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB,
		A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5
	FROM Ta_KIB_E A INNER JOIN Ta_KIBER B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Prov = @Kd_Prov AND B.Kd_Kab_Kota = @Kd_Kab_Kota AND B.Kd_Bidang = @Kd_Bidang 
		AND B.Kd_Unit = @Kd_Unit AND B.Kd_Sub = @Kd_Sub AND B.Kd_UPB = @Kd_UPB
		AND A.Kd_Hapus = 0 AND B.Kd_Riwayat = 3
    	ORDER BY B.Tgl_Dokumen DESC
END




GO
