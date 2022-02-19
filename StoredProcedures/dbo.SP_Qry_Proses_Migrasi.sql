USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/***
Deskripsi Store Procedure :
Nama		: SP_Qry_Proses_Migrasi
Form		: F_Migrasi108
Keterangan	: Di gunakan di Form F_Up_Rekening untuk cari rekening
Dibuat		: 16/01/2019 23:29:00
Oleh		: HRY
***/

CREATE PROCEDURE [dbo].[SP_Qry_Proses_Migrasi] @Kd_KIB varchar(1)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Filter varchar(50), @Kd_KIB varchar(1)
SET @Kd_Aset1 = '4' 
SET @Kd_Aset2 = '4' 
*/

IF @Kd_KIB = 'A'
BEGIN
	UPDATE Ta_KIB_A SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5,
		No_Reg8 = A.No_Register,
		Tg_Update8 = getdate()
	FROM Ta_KIB_A A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
			
	UPDATE Ta_KIBAR SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_KIBAR A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
	
	UPDATE Ta_KIBAHapus SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_KIBAHapus A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
		
	UPDATE Ta_PenA SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_PenA A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
END	

IF @Kd_KIB = 'B'
BEGIN
	UPDATE Ta_KIB_B SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5,
		No_Reg8 = A.No_Register,
		Tg_Update8 = getdate()
	FROM Ta_KIB_B A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
		
	UPDATE Ta_KIBBR SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_KIBBR A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
		
	UPDATE Ta_KIBBHapus SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_KIBBHapus A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
	
	UPDATE Ta_PenB SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_PenB A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
END

IF @Kd_KIB = 'C'
BEGIN
	UPDATE Ta_KIB_C SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5,
		No_Reg8 = A.No_Register,
		Tg_Update8 = getdate()
	FROM Ta_KIB_C A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
		
	UPDATE Ta_KIB_C SET
		Kd_Tanah = B.Kd_Aset,
		Kd_Tanah0 = B.Kd_Aset0,
		Kd_Tanah1 = B.Kd_Aset1,
		Kd_Tanah2 = B.Kd_Aset2,
		Kd_Tanah3 = B.Kd_Aset3,
		Kd_Tanah4 = B.Kd_Aset4,
		Kd_Tanah5 = B.Kd_Aset5,
		Kode_Tanah = A.No_Register
	FROM Ta_KIB_C A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Tanah1 = B.Kd1 AND A.Kd_Tanah2 = B.Kd2 AND A.Kd_Tanah3 = B.Kd3 AND A.Kd_Tanah4 = B.Kd4 AND A.Kd_Tanah5 = B.Kd5
	WHERE (NOT (A.Kd_Tanah1 IS NULL)) AND (A.Kd_Tanah IS NULL)
	
	UPDATE Ta_KIBCR SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_KIBCR A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
	
	UPDATE Ta_KIBCHapus SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_KIBCHapus A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
	
	UPDATE Ta_PenC SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_PenC A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
END

IF @Kd_KIB = 'D'
BEGIN
	UPDATE Ta_KIB_D SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5,
		No_Reg8 = A.No_Register,
		Tg_Update8 = getdate()
	FROM Ta_KIB_D A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
	
	UPDATE Ta_KIB_D SET
		Kd_Tanah = B.Kd_Aset,
		Kd_Tanah0 = B.Kd_Aset0,
		Kd_Tanah1 = B.Kd_Aset1,
		Kd_Tanah2 = B.Kd_Aset2,
		Kd_Tanah3 = B.Kd_Aset3,
		Kd_Tanah4 = B.Kd_Aset4,
		Kd_Tanah5 = B.Kd_Aset5,
		Kode_Tanah = A.No_Register
	FROM Ta_KIB_D A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Tanah1 = B.Kd1 AND A.Kd_Tanah2 = B.Kd2 AND A.Kd_Tanah3 = B.Kd3 AND A.Kd_Tanah4 = B.Kd4 AND A.Kd_Tanah5 = B.Kd5
	WHERE (NOT (A.Kd_Tanah1 IS NULL)) AND (A.Kd_Tanah IS NULL)
		
	UPDATE Ta_KIBDR SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_KIBDR A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
	
	UPDATE Ta_KIBDHapus SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_KIBDHapus A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
	
	UPDATE Ta_PenD SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_PenD A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
END

IF @Kd_KIB = 'E'
BEGIN
	UPDATE Ta_KIB_E SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5,
		No_Reg8 = A.No_Register,
		Tg_Update8 = getdate()
	FROM Ta_KIB_E A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
	
	UPDATE Ta_KIBER SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_KIBER A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
		
	UPDATE Ta_KIBEHapus SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_KIBEHapus A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
	
	UPDATE Ta_PenE SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_PenE A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
END

IF @Kd_KIB = 'L'
BEGIN
	UPDATE Ta_Lainnya SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5,
		No_Reg8 = A.No_Register,
		Tg_Update8 = getdate()
	FROM Ta_Lainnya A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
	
	UPDATE Ta_KILER SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_KILER A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
	
	UPDATE Ta_KILHapus SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3,
		Kd_Aset84 = B.Kd_Aset4,
		Kd_Aset85 = B.Kd_Aset5
	FROM Ta_KILHapus A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3 AND A.Kd_Aset4 = B.Kd4 AND A.Kd_Aset5 = B.Kd5
END

IF EXISTS (SELECT Kd_Aset8 FROM Ref_Kap_Umur WHERE Kd_Aset8 IS NULL)
BEGIN
	UPDATE Ref_Kap_Umur SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3
	FROM Ref_Kap_Umur A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3
	WHERE (A.Kd_Aset8 IS NULL)
END

IF EXISTS (SELECT Tahun FROM Ta_KA WHERE Kd_Aset8 IS NULL AND Tahun = (SELECT DISTINCT TOP 1 Tahun FROM Ta_KA ORDER BY Tahun DESC))
BEGIN
	UPDATE Ta_KA SET
		Kd_Aset8 = B.Kd_Aset,
		Kd_Aset80 = B.Kd_Aset0,
		Kd_Aset81 = B.Kd_Aset1,
		Kd_Aset82 = B.Kd_Aset2,
		Kd_Aset83 = B.Kd_Aset3
	FROM Ta_KA A INNER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1 = B.Kd1 AND A.Kd_Aset2 = B.Kd2 AND A.Kd_Aset3 = B.Kd3
	WHERE (A.Kd_Aset8 IS NULL) AND Tahun = (SELECT DISTINCT TOP 1 Tahun FROM Ta_KA ORDER BY Tahun DESC)
END
	



GO
