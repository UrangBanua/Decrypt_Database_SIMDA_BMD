USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** SP_Ta_Pengadaan_RefPosting_Kap - 21022018 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Ta_Pengadaan_RefPosting_Kap @Tahun varchar(4),  @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3)
WITH ENCRYPTION 
AS

/*
DECLARE @Tahun varchar(4),  @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3)
SET @Tahun = '2017'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '7'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset1 = '3'
SET @Kd_Aset2 = '11'
SET @Kd_Aset3 = '1'
SET @Kd_Aset4 = '1'
SET @Kd_Aset5 = '1'
*/

SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Harga,
	A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kd_data, REPLACE(dbo.fn_GabBarang_108(A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab
FROM 
	(SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Reg8 AS No_Register, A.Harga,
		--A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Harga,
		A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kd_data
	 FROM Ta_KIB_A A
 	 WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5
		AND A.Kd_Data <> 3 AND A.Kd_Hapus = 0
	
	 UNION ALL

	 SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Reg8 AS No_Register, A.Harga,
		--A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Harga,
		A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kd_data
	 FROM Ta_KIB_B A
 	 WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5
		AND A.Kd_Data <> 3 AND A.Kd_Hapus = 0

	 UNION ALL

	 SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Reg8 AS No_Register, A.Harga,
		--A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Harga,
		A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kd_data
	 FROM Ta_KIB_C A
 	 WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5
		AND A.Kd_Data <> 3 AND A.Kd_Hapus = 0

	 UNION ALL

	 SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Reg8 AS No_Register, A.Harga,
		--A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Harga,
		A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kd_data
	 FROM Ta_KIB_D A
 	 WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5
		AND A.Kd_Data <> 3 AND A.Kd_Hapus = 0

	 UNION ALL

	 SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Reg8 AS No_Register, A.Harga,
		--A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Harga,
		A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kd_data
	 FROM Ta_KIB_E A
 	 WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
		AND A.Kd_Aset8 LIKE @Kd_Aset AND A.Kd_Aset80 LIKE @Kd_Aset0 AND A.Kd_Aset81 LIKE @Kd_Aset1 AND A.Kd_Aset82 LIKE @Kd_Aset2 AND A.Kd_Aset83 LIKE @Kd_Aset3 AND A.Kd_Aset84 LIKE @Kd_Aset4 AND A.Kd_Aset85 LIKE @Kd_Aset5
		AND A.Kd_Data <> 3 AND A.Kd_Hapus = 0
	) A
ORDER BY A.No_Register







GO
