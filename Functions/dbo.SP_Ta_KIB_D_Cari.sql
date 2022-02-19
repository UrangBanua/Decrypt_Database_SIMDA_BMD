USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_Ta_KIB_D_Cari] @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Nm_Aset_Cari varchar(50)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Nm_Aset_Cari varchar(50)
SET @Tahun     = '2010' 
SET @Kd_Prov = '11'
SET @Kd_Kab_Kota = '28'
SET @Kd_Bidang = '1' 
SET @Kd_Unit   = '1' 
SET @Kd_Sub    = '1'
SET @Kd_UPB	= '1'
SET @Nm_Aset_Cari   = ''
*/
	IF ISNULL(@Nm_Aset_Cari, '') = '' SET @Nm_Aset_Cari = '%'

	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register, A.Kd_Pemilik, A.Tgl_Perolehan,
		A.Tahun, A.Harga, B.Nm_Aset5 AS Nm_Rek_Aset, 
		--REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Barang
		REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85), ' . ', '.') AS Kd_Gab_Barang_108, A.No_Reg8
	FROM Ta_KIB_D A INNER JOIN
		Ref_Rek5_108 B ON A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 
		AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
	WHERE Kd_Prov = @Kd_Prov AND Kd_Kab_Kota = @Kd_Kab_Kota
		AND Kd_Bidang = @Kd_Bidang AND Kd_Unit = @Kd_Unit AND Kd_Sub = @Kd_Sub AND Kd_UPB = @Kd_UPB
		AND B.Nm_Aset5 LIKE '%'+@Nm_Aset_Cari+'%'
		AND A.Kd_Data <> 3
GO
