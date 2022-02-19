USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.Rpt108Mutasi_BrgSKPD @Tahun Varchar(4), @Kd_Prov Varchar(3), @Kd_Kab_Kota Varchar(3), @Kd_Bidang Varchar(3), @Kd_Unit Varchar(3),
		@Kd_Sub Varchar(3), @Kd_UPB Varchar(3), @D1 datetime, @D2 datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun Varchar(4), @Kd_Prov Varchar(3), @Kd_Kab_Kota Varchar(3), @Kd_Bidang Varchar(3), @Kd_Unit Varchar(3),
	@Kd_Sub Varchar(3), @Kd_UPB Varchar(3), @D1 datetime, @D2 datetime

SET @Tahun = '2018'
SET @Kd_Prov = '13'
SET @Kd_Kab_Kota = '33'
SET @Kd_Bidang = '5'
SET @Kd_Unit = '2'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @D1 = '20180101'
SET @D2 = '20181231'
--*/
	
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'	



DECLARE	@Mutasi_SKPD Table(Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB smallint, Kd_Pemilik tinyint, Tgl_Pembukuan datetime,
	Kd_Aset int, Kd_Aset0 int, Kd_Aset1 int, Kd_Aset2 int, Kd_Aset3 int, Kd_Aset4 int, Kd_Aset5 int, No_Register int, Merk varchar(50), Type varchar(50), Dokumen varchar(100), Tgl_Dokumen datetime,
	Bahan varchar(50), Kondisi varchar(4), Harga_Awal money, Pengurangan money, Penambahan money, Kd_Prov1 tinyint, Kd_Kab_Kota1 tinyint, Kd_Bidang1 tinyint, 
	Kd_Unit1 smallint, Kd_Sub1 smallint, Kd_UPB1 smallint, Kd_Prov2 tinyint, Kd_Kab_Kota2 tinyint, Kd_Bidang2 tinyint, Kd_Unit2 smallint, Kd_Sub2 smallint, Kd_UPB2 smallint)
DECLARE @JLap Tinyint SET @JLap = 0


INSERT INTO @Mutasi_SKPD

SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Pemilik, A.Tgl_Pembukuan, 
	A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	A.No_Register, A.Merk, A.Type, A.Dokumen, A.Tgl_DOkumen, A.Bahan, A.Kondisi, A.Harga_Awal, A.Pengurangan, A.Penambahan, A.Kd_Prov1,
	A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1,	
	A.Kd_Prov2, A.Kd_Kab_Kota2, A.Kd_Bidang2, A.Kd_Unit2, A.Kd_Sub2, A.Kd_UPB2
FROM	
	(

--Pengurangan
	SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, '' AS Kd_Pemilik, A.Tgl_Pembukuan, 
		A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi,  
		0 AS Harga_Awal, SUM(A.Pengurangan) AS Pengurangan, 0 AS Penambahan, 
		A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1,
		'-' AS Kd_Prov2, '-' AS Kd_Kab_Kota2, '-' AS Kd_Bidang2, '-' AS Kd_Unit2, '-' AS Kd_Sub2, '-' AS Kd_UPB2
	FROM
		(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, '' AS Kd_Pemilik, A.Tgl_Pembukuan, 
			A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
			A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
			0 AS Harga_Awal, SUM(A.Pengurangan) AS Pengurangan, 0 AS Penambahan, 
			A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1,
			'-' AS Kd_Prov2, '-' AS Kd_Kab_Kota2, '-' AS Kd_Bidang2, '-' AS Kd_Unit2, '-' AS Kd_Sub2, '-' AS Kd_UPB2
		FROM	
			(
			SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
				A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
				A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
				0 AS Harga_Awal, A.Pengurangan, 0 AS Penambahan, A.Kd_Prov1,
				A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
			FROM
				(SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
					A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
					A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi,
					A.Pengurangan, A.Kd_Prov1,
					A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
				FROM
					
					(
					SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Pembukuan, 
							A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Register, 
						'-' AS Merk, '-' AS Type, A.No_Dokumen AS Dokumen, A. Tgl_Dokumen, '-' AS Bahan, 1 AS Kondisi, 
						ISNULL(SUM(C.Harga),0) AS Pengurangan, A.Kd_Prov1,
						A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
					FROM	Ta_KIBAR A LEFT OUTER JOIN
						fn_Kartu108_BrgA_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%','%','%') B ON
							A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
							AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_ASet0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
							AND A.No_Register = B.No_Register LEFT OUTER JOIN 
						 fn_Kartu108_BrgA_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%') C ON
										A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
										AND A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_ASet0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
										AND A.No_Register = C.No_Register
					WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND A.Kd_Riwayat = 3
							AND B.Tgl_Dok BETWEEN @D1 AND @D2
					GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
						A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register, 
						A.Kd_Prov1,	A.No_Dokumen, A. Tgl_Dokumen, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1

					) A
				) A
			
			
			UNION ALL
		
			SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
				A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
				A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
				0 AS Harga_Awal, A.Pengurangan, 0 AS Penambahan, A.Kd_Prov1,
				A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
			FROM
				(SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
					A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
					A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
					A.Pengurangan, A.Kd_Prov1,
					A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
				FROM
					
					(
					SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
							A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Register, 
							A.Merk, A.Type, A.No_Dokumen AS Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
							ISNULL(SUM(B.Harga),0) AS Pengurangan, A.Kd_Prov1,
							A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
					FROM	Ta_KIBBR A LEFT OUTER JOIN
						fn_Kartu108_BrgB_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%','%','%') B ON
							A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
							AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_ASet0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
							AND A.No_Register = B.No_Register LEFT OUTER JOIN 
						 fn_Kartu108_BrgB_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%') C ON
										A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
										AND A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_ASet0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
										AND A.No_Register = C.No_Register
					WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND A.Kd_Riwayat = 3
							AND B.Tgl_Dokumen BETWEEN @D1 AND @D2
					GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
						A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register, 
						A.Kd_Prov1,
						A.Merk, A.Type, A.No_Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi,
						A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
					) A
				) A
		
		
			UNION ALL
		
			SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
				A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
				A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi,
				0 AS Harga_Awal, A.Pengurangan, 0 AS Penambahan, A.Kd_Prov1,
				A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
			FROM
				(SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
					A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
					A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi,
					A.Pengurangan, A.Kd_Prov1,
					A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
				FROM
					
					(
					SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
							A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Register, 
						'-' AS Merk, '-' AS Type, A.No_Dokumen AS DOkumen, A. Tgl_Dokumen, '-' AS Bahan, A.Kondisi, 
						ISNULL(SUM(C.Harga),0) AS Pengurangan,
						A.Kd_Prov1,
						A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
					FROM	Ta_KIBCR A LEFT OUTER JOIN
						fn_Kartu108_BrgC_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%', '%','%','%','%','%','%') B ON
										A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
										AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_ASet0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
							AND A.No_Register = B.No_Register LEFT OUTER JOIN 
						 fn_Kartu108_BrgC_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%') C ON
										A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
										AND A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_ASet0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
										AND A.No_Register = C.No_Register
							
					WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND A.Kd_Riwayat = 3
							AND A.Tgl_Dokumen BETWEEN @D1 AND @D2
					GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
						A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register, 
						A.Kd_Prov1,	A.No_Dokumen, A. Tgl_Dokumen,A.Kondisi, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, C.Harga
					) A
				) A
		
		
			UNION ALL
		
			SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
				A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
				A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi,
				0 AS Harga_Awal, A.Pengurangan, 0 AS Penambahan, A.Kd_Prov1,
				A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
			FROM
				(SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
					A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
					A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi,
					A.Pengurangan, A.Kd_Prov1,
					A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
				FROM
					
					(
					SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
							A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Register, 
						'-' AS Merk, '-' AS Type, A.No_Dokumen AS Dokumen, A. Tgl_Dokumen, '-' AS Bahan, A.Kondisi,
						ISNULL(SUM(C.Harga),0) AS Pengurangan, A.Kd_Prov1,
						A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
					FROM	Ta_KIBDR A LEFT OUTER JOIN
						fn_Kartu108_BrgD_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%', '%','%','%','%','%','%') B ON
							A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
							AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_ASet0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
							AND A.No_Register = B.No_Register LEFT OUTER JOIN 
						 fn_Kartu108_BrgD_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%') C ON
										A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
										AND A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_ASet0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
										AND A.No_Register = C.No_Register
					WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND A.Kd_Riwayat = 3
							AND A.Tgl_Dokumen BETWEEN @D1 AND @D2
					GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
						A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register, 
						A.Kd_Prov1,
						A.No_Dokumen, A. Tgl_Dokumen, A.Kondisi, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
					) A
				) A
		
			UNION ALL
		
			SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
				A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
				A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi,
				0 AS Harga_Awal, A.Pengurangan, 0 AS Penambahan, A.Kd_Prov1,
				A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
			FROM
				(SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
					A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
					A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi,
					A.Pengurangan, A.Kd_Prov1,
					A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
				FROM
					
					(
					SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
							A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Register, 
						'-' AS Merk, '-' AS Type, A.No_Dokumen AS Dokumen, A. Tgl_Dokumen, '-' AS Bahan, A.Kondisi,
						ISNULL(SUM(C.Harga),0) AS Pengurangan, A.Kd_Prov1,
						A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
					FROM	Ta_KIBER A LEFT OUTER JOIN
						fn_Kartu108_BrgE_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%','%','%') B ON
							A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB
							AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_ASet0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
							AND A.No_Register = B.No_Register LEFT OUTER JOIN 
						 fn_Kartu108_BrgE_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%') C ON
										A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
										AND A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_ASet0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
										AND A.No_Register = C.No_Register
					WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND A.Kd_Riwayat = 3
							AND A.Tgl_Dokumen BETWEEN @D1 AND @D2
					GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
						A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register, 
						A.Kd_Prov1,
						A.No_Dokumen, A. Tgl_Dokumen, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1, A.KONDISI
					) A
				) A
		
			) A
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
			A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
			 A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi,A.Pengurangan, A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
		) A
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Pembukuan, 
		A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		 A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi,A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
 
--Penambahan
	UNION ALL
	
	SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, '' Kd_Pemilik, A.Tgl_Pembukuan, 
		A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
		A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi,  0 AS Harga_Awal, 0 AS Pengurangan, SUM(A.Penambahan) AS Penambahan, 
		'-' AS Kd_Prov1, '-' AS Kd_Kab_Kota1, '-' AS Kd_Bidang1, '-' AS Kd_Unit1, '-' AS Kd_Sub1, '-' AS Kd_UPB1,
		A.Kd_Prov2, A.Kd_Kab_Kota2, A.Kd_Bidang2, A.Kd_Unit2, A.Kd_Sub2, A.Kd_UPB2
	FROM
		(
		SELECT	A.Kd_Prov_B AS Kd_Prov, A.Kd_Kab_Kota_B AS Kd_Kab_Kota, A.Kd_Bidang_B AS Kd_Bidang, A.Kd_Unit_B AS Kd_Unit, A.Kd_Sub_B AS Kd_Sub, A.Kd_UPB_B AS Kd_UPB, '' Kd_Pemilik, A.Tgl_Pembukuan, 
			A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1 AS No_Register, 
			A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi,  0 AS Harga_Awal, 0 AS Pengurangan, SUM(A.Penambahan) AS Penambahan, 
			'-' AS Kd_Prov1, '-' AS Kd_Kab_Kota1, '-' AS Kd_Bidang1, '-' AS Kd_Unit1, '-' AS Kd_Sub1, '-' AS Kd_UPB1,
			A.Kd_Prov_A AS Kd_Prov2, A.Kd_Kab_Kota_A AS Kd_Kab_Kota2, A.Kd_Bidang_A AS Kd_Bidang2, A.Kd_Unit_A AS Kd_Unit2, A.Kd_Sub_A AS Kd_Sub2, A.Kd_UPB_A AS Kd_UPB2
		FROM
			(SELECT	A.Kd_Prov_B, A.Kd_Kab_Kota_B, A.Kd_Bidang_B, A.Kd_Unit_B, A.Kd_Sub_B, A.Kd_UPB_B,  A.Tgl_Pembukuan, 
				A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, 0 AS Harga_Awal, 0 AS Pengurangan, A.Penambahan, A.Kd_Prov_A,
				A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
				A.Kd_Kab_Kota_A, A.Kd_Bidang_A, A.Kd_Unit_A, A.Kd_Sub_A, A.Kd_UPB_A
			FROM
				(SELECT	A.Kd_Prov_B, A.Kd_Kab_Kota_B, A.Kd_Bidang_B, A.Kd_Unit_B, A.Kd_Sub_B, A.Kd_UPB_B,  A.Tgl_Pembukuan, 
					A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Penambahan, A.Kd_Prov_A,
					A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
					A.Kd_Kab_Kota_A, A.Kd_Bidang_A, A.Kd_Unit_A, A.Kd_Sub_A, A.Kd_UPB_A
				FROM
					(
					SELECT	A.Kd_Prov AS Kd_Prov_A, A.Kd_Kab_Kota AS Kd_Kab_Kota_A, A.Kd_Bidang AS Kd_Bidang_A, A.Kd_Unit AS Kd_Unit_A, A.Kd_Sub AS Kd_Sub_A, A.Kd_UPB AS Kd_UPB_A,  A.Tgl_Pembukuan, 
							A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Register1, 
						'-' AS Merk, '-' AS Type, A.No_Dokumen AS Dokumen, A. Tgl_Dokumen, '-' AS Bahan, '-' AS Kondisi, 
						 ISNULL(SUM(B.Harga),0) AS Penambahan, A.Kd_Prov1 AS Kd_Prov_B, A.Kd_Kab_Kota1 AS Kd_Kab_Kota_B, 
						A.Kd_Bidang1 AS Kd_Bidang_B, A.Kd_Unit1 AS Kd_Unit_B, A.Kd_Sub1 AS Kd_Sub_B, A.Kd_UPB1 AS Kd_UPB_B
					FROM	Ta_KIBAR A LEFT OUTER JOIN
						fn_Kartu108_BrgA_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%','%','%') B ON
							A.Kd_Prov1 = B.Kd_Prov AND A.Kd_Kab_Kota1 = B.Kd_Kab_Kota AND A.Kd_Bidang1 = B.Kd_Bidang AND A.Kd_Unit1 = B.Kd_Unit AND A.Kd_Sub1 = B.Kd_Sub AND A.Kd_UPB1 = B.Kd_UPB
							AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_ASet0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
							AND A.No_Register = B.No_Register LEFT OUTER JOIN 
						 fn_Kartu108_BrgA_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%') C ON
										A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
										AND A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_ASet0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
										AND A.No_Register = C.No_Register
					WHERE	A.Kd_Prov1 = @Kd_Prov AND A.Kd_Kab_Kota1 = @Kd_Kab_Kota AND A.Kd_Bidang1 = @Kd_Bidang AND A.Kd_Unit1 = @Kd_Unit AND A.Kd_Sub1 = @Kd_Sub AND A.Kd_UPB1 = @Kd_UPB AND A.Kd_Riwayat = 3
							AND A.Tgl_Dokumen BETWEEN @D1 AND @D2
					GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
						A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register1, 
						A.Kd_Prov1,	A.No_Dokumen, A. Tgl_Dokumen,A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
					) A
				) A
		
			UNION ALL
		
		SELECT	A.Kd_Prov_B, A.Kd_Kab_Kota_B, A.Kd_Bidang_B, A.Kd_Unit_B, A.Kd_Sub_B, A.Kd_UPB_B,  A.Tgl_Pembukuan, 
			A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, 0 AS Harga_Awal, 0 AS Pengurangan, A.Penambahan, A.Kd_Prov_A,
			A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
			A.Kd_Kab_Kota_A, A.Kd_Bidang_A, A.Kd_Unit_A, A.Kd_Sub_A, A.Kd_UPB_A
		FROM
			(SELECT	A.Kd_Prov_B, A.Kd_Kab_Kota_B, A.Kd_Bidang_B, A.Kd_Unit_B, A.Kd_Sub_B, A.Kd_UPB_B,  A.Tgl_Pembukuan, 
				A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Penambahan, A.Kd_Prov_A,
				A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
				A.Kd_Kab_Kota_A, A.Kd_Bidang_A, A.Kd_Unit_A, A.Kd_Sub_A, A.Kd_UPB_A
			FROM
				(
				SELECT	A.Kd_Prov AS Kd_Prov_A, A.Kd_Kab_Kota AS Kd_Kab_Kota_A, A.Kd_Bidang AS Kd_Bidang_A, A.Kd_Unit AS Kd_Unit_A, A.Kd_Sub AS Kd_Sub_A, A.Kd_UPB AS Kd_UPB_A,  A.Tgl_Pembukuan, 
					A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Register1, 
					A.Merk, A.Type, A.No_Dokumen AS Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
					ISNULL(SUM(B.Harga),0) AS Penambahan, A.Kd_Prov1 AS Kd_Prov_B, A.Kd_Kab_Kota1 AS Kd_Kab_Kota_B, 
					A.Kd_Bidang1 AS Kd_Bidang_B, A.Kd_Unit1 AS Kd_Unit_B, A.Kd_Sub1 AS Kd_Sub_B, A.Kd_UPB1 AS Kd_UPB_B
				FROM	Ta_KIBBR A LEFT OUTER JOIN
					fn_Kartu108_BrgB_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%', '%','%','%','%','%','%') B ON
						A.Kd_Prov1 = B.Kd_Prov AND A.Kd_Kab_Kota1 = B.Kd_Kab_Kota AND A.Kd_Bidang1 = B.Kd_Bidang AND A.Kd_Unit1 = B.Kd_Unit AND A.Kd_Sub1 = B.Kd_Sub AND A.Kd_UPB1 = B.Kd_UPB
						AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_ASet0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
							AND A.No_Register = B.No_Register LEFT OUTER JOIN 
					fn_Kartu108_BrgB_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%') C ON
										A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
										AND A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_ASet0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
										AND A.No_Register = C.No_Register
				WHERE	A.Kd_Prov1 = @Kd_Prov AND A.Kd_Kab_Kota1 = @Kd_Kab_Kota AND A.Kd_Bidang1 = @Kd_Bidang AND A.Kd_Unit1 = @Kd_Unit AND A.Kd_Sub1 = @Kd_Sub AND A.Kd_UPB1 = @Kd_UPB AND A.Kd_Riwayat = 3
						AND A.Tgl_Dokumen BETWEEN @D1 AND @D2
				GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
					A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register1, A.Kd_Prov1,
					A.Merk, A.Type, A.No_Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
				) A
			) A
		
			UNION ALL
		
			SELECT	A.Kd_Prov_B, A.Kd_Kab_Kota_B, A.Kd_Bidang_B, A.Kd_Unit_B, A.Kd_Sub_B, A.Kd_UPB_B,  A.Tgl_Pembukuan, 
				A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, 0 AS Harga_Awal, 0 AS Pengurangan,A.Penambahan, A.Kd_Prov_A,
				A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
				A.Kd_Kab_Kota_A, A.Kd_Bidang_A, A.Kd_Unit_A, A.Kd_Sub_A, A.Kd_UPB_A
			FROM
				(SELECT	A.Kd_Prov_B, A.Kd_Kab_Kota_B, A.Kd_Bidang_B, A.Kd_Unit_B, A.Kd_Sub_B, A.Kd_UPB_B,  A.Tgl_Pembukuan, 
					A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Penambahan, A.Kd_Prov_A,
					A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
					A.Kd_Kab_Kota_A, A.Kd_Bidang_A, A.Kd_Unit_A, A.Kd_Sub_A, A.Kd_UPB_A
				FROM
					(
					SELECT	A.Kd_Prov AS Kd_Prov_A, A.Kd_Kab_Kota AS Kd_Kab_Kota_A, A.Kd_Bidang AS Kd_Bidang_A, A.Kd_Unit AS Kd_Unit_A, A.Kd_Sub AS Kd_Sub_A, A.Kd_UPB AS Kd_UPB_A,  A.Tgl_Pembukuan, 
						A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Register1, 
						ISNULL(SUM(B.Harga),0) AS Penambahan, A.Kd_Prov1 AS Kd_Prov_B, A.Kd_Kab_Kota1 AS Kd_Kab_Kota_B, 
						'-' AS Merk, '-' AS Type, A.No_Dokumen AS Dokumen, A. Tgl_Dokumen, '-' AS Bahan, A.Kondisi, 
						A.Kd_Bidang1 AS Kd_Bidang_B, A.Kd_Unit1 AS Kd_Unit_B, A.Kd_Sub1 AS Kd_Sub_B, A.Kd_UPB1 AS Kd_UPB_B
					FROM	Ta_KIBCR A LEFT OUTER JOIN
						fn_Kartu108_BrgC_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%','%','%') B ON
							A.Kd_Prov1 = B.Kd_Prov AND A.Kd_Kab_Kota1 = B.Kd_Kab_Kota AND A.Kd_Bidang1 = B.Kd_Bidang AND A.Kd_Unit1 = B.Kd_Unit AND A.Kd_Sub1 = B.Kd_Sub AND A.Kd_UPB1 = B.Kd_UPB
							AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_ASet0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
							AND A.No_Register = B.No_Register LEFT OUTER JOIN 
						 fn_Kartu108_BrgC_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%') C ON
										A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
										AND A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_ASet0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
										AND A.No_Register = C.No_Register
					WHERE	A.Kd_Prov1 = @Kd_Prov AND A.Kd_Kab_Kota1 = @Kd_Kab_Kota AND A.Kd_Bidang1 = @Kd_Bidang AND A.Kd_Unit1 = @Kd_Unit AND A.Kd_Sub1 = @Kd_Sub AND A.Kd_UPB1 = @Kd_UPB AND A.Kd_Riwayat = 3
							AND A.Tgl_Dokumen BETWEEN @D1 AND @D2
					GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
						A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register1, A.Kd_Prov1,
						A.No_Dokumen, A. Tgl_Dokumen, A.Kondisi, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
					) A
				) A
		
			UNION ALL
		
			SELECT	A.Kd_Prov_B, A.Kd_Kab_Kota_B, A.Kd_Bidang_B, A.Kd_Unit_B, A.Kd_Sub_B, A.Kd_UPB_B,  A.Tgl_Pembukuan, 
				A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, 0 AS Harga_Awal, 0 AS Pengurangan, A.Penambahan, A.Kd_Prov_A,
				A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
				A.Kd_Kab_Kota_A, A.Kd_Bidang_A, A.Kd_Unit_A, A.Kd_Sub_A, A.Kd_UPB_A
			FROM
				(SELECT	A.Kd_Prov_B, A.Kd_Kab_Kota_B, A.Kd_Bidang_B, A.Kd_Unit_B, A.Kd_Sub_B, A.Kd_UPB_B,  A.Tgl_Pembukuan, 
					A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Penambahan, A.Kd_Prov_A,
					A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
					A.Kd_Kab_Kota_A, A.Kd_Bidang_A, A.Kd_Unit_A, A.Kd_Sub_A, A.Kd_UPB_A
				FROM
					(
					SELECT	A.Kd_Prov AS Kd_Prov_A, A.Kd_Kab_Kota AS Kd_Kab_Kota_A, A.Kd_Bidang AS Kd_Bidang_A, A.Kd_Unit AS Kd_Unit_A, A.Kd_Sub AS Kd_Sub_A, A.Kd_UPB AS Kd_UPB_A,  A.Tgl_Pembukuan, 
						A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Register1, 
						ISNULL(SUM(B.Harga),0) AS Penambahan, A.Kd_Prov1 AS Kd_Prov_B, A.Kd_Kab_Kota1 AS Kd_Kab_Kota_B, 
						'-' AS Merk, '-' AS Type, A.No_Dokumen AS Dokumen, A. Tgl_Dokumen, '-' AS Bahan, A.Kondisi, 
						A.Kd_Bidang1 AS Kd_Bidang_B, A.Kd_Unit1 AS Kd_Unit_B, A.Kd_Sub1 AS Kd_Sub_B, A.Kd_UPB1 AS Kd_UPB_B
					FROM	Ta_KIBDR A LEFT OUTER JOIN
						fn_Kartu108_BrgD_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%','%','%') B ON
							A.Kd_Prov1 = B.Kd_Prov AND A.Kd_Kab_Kota1 = B.Kd_Kab_Kota AND A.Kd_Bidang1 = B.Kd_Bidang AND A.Kd_Unit1 = B.Kd_Unit AND A.Kd_Sub1 = B.Kd_Sub AND A.Kd_UPB1 = B.Kd_UPB
							AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_ASet0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
							AND A.No_Register = B.No_Register LEFT OUTER JOIN 
						 fn_Kartu108_BrgD_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%') C ON
										A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
										AND A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_ASet0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
										AND A.No_Register = C.No_Register
					WHERE	A.Kd_Prov1 = @Kd_Prov AND A.Kd_Kab_Kota1 = @Kd_Kab_Kota AND A.Kd_Bidang1 = @Kd_Bidang AND A.Kd_Unit1 = @Kd_Unit AND A.Kd_Sub1 = @Kd_Sub AND A.Kd_UPB1 = @Kd_UPB AND A.Kd_Riwayat = 3
							AND A.Tgl_Dokumen BETWEEN @D1 AND @D2
					GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
						A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register1, A.Kd_Prov1,
						A.No_Dokumen, A. Tgl_Dokumen,A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kondisi, A.Kd_UPB1
					) A
				) A
		
			UNION ALL
		
			SELECT	A.Kd_Prov_B, A.Kd_Kab_Kota_B, A.Kd_Bidang_B, A.Kd_Unit_B, A.Kd_Sub_B, A.Kd_UPB_B,  A.Tgl_Pembukuan, 
				A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, 0 AS Harga_Awal, 0 AS Pengurangan, A.Penambahan, A.Kd_Prov_A,
				A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
				A.Kd_Kab_Kota_A, A.Kd_Bidang_A, A.Kd_Unit_A, A.Kd_Sub_A, A.Kd_UPB_A
			FROM
				(SELECT	A.Kd_Prov_B, A.Kd_Kab_Kota_B, A.Kd_Bidang_B, A.Kd_Unit_B, A.Kd_Sub_B, A.Kd_UPB_B,  A.Tgl_Pembukuan, 
					A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, A.Penambahan, A.Kd_Prov_A,
					A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, 
					A.Kd_Kab_Kota_A, A.Kd_Bidang_A, A.Kd_Unit_A, A.Kd_Sub_A, A.Kd_UPB_A
				FROM
					(
					SELECT	A.Kd_Prov AS Kd_Prov_A, A.Kd_Kab_Kota AS Kd_Kab_Kota_A, A.Kd_Bidang AS Kd_Bidang_A, A.Kd_Unit AS Kd_Unit_A, A.Kd_Sub AS Kd_Sub_A, A.Kd_UPB AS Kd_UPB_A,  A.Tgl_Pembukuan, 
							A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, A.Kd_Aset83 AS Kd_Aset3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, A.No_Register1, 
						 ISNULL(SUM(B.Harga),0) AS Penambahan, A.Kd_Prov1 AS Kd_Prov_B, A.Kd_Kab_Kota1 AS Kd_Kab_Kota_B, 
						A.Judul AS Merk, A.Pencipta AS Type, A.No_Dokumen AS Dokumen, A. Tgl_Dokumen, '-' AS Bahan, A.Kondisi, 
						A.Kd_Bidang1 AS Kd_Bidang_B, A.Kd_Unit1 AS Kd_Unit_B, A.Kd_Sub1 AS Kd_Sub_B, A.Kd_UPB1 AS Kd_UPB_B
					FROM	Ta_KIBER A LEFT OUTER JOIN
						fn_Kartu108_BrgE_btw(@D1, @D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%','%','%') B ON
							A.Kd_Prov1 = B.Kd_Prov AND A.Kd_Kab_Kota1 = B.Kd_Kab_Kota AND A.Kd_Bidang1 = B.Kd_Bidang AND A.Kd_Unit1 = B.Kd_Unit AND A.Kd_Sub1 = B.Kd_Sub AND A.Kd_UPB1 = B.Kd_UPB
							AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_ASet0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
							AND A.No_Register = B.No_Register LEFT OUTER JOIN 
						 fn_Kartu108_BrgE_Awl(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%') C ON
										A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
										AND A.Kd_Aset8 = C.Kd_Aset AND A.Kd_Aset80 = C.Kd_ASet0 AND A.Kd_Aset81 = C.Kd_Aset1 AND A.Kd_Aset82 = C.Kd_Aset2 AND A.Kd_Aset83 = C.Kd_Aset3 AND A.Kd_Aset84 = C.Kd_Aset4 AND A.Kd_Aset85 = C.Kd_Aset5
										AND A.No_Register = C.No_Register
					WHERE	A.Kd_Prov1 = @Kd_Prov AND A.Kd_Kab_Kota1 = @Kd_Kab_Kota AND A.Kd_Bidang1 = @Kd_Bidang AND A.Kd_Unit1 = @Kd_Unit AND A.Kd_Sub1 = @Kd_Sub AND A.Kd_UPB1 = @Kd_UPB AND A.Kd_Riwayat = 3
							AND A.Tgl_Dokumen BETWEEN @D1 AND @D2
					GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,  A.Tgl_Pembukuan, 
						A.Kd_Aset8,A.Kd_Aset80,A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Register1, A.Kd_Prov1,
						A.Judul, A.Pencipta, A.No_Dokumen, A.Kondisi, A.Tgl_Dokumen, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1
					) A
				) A
			) A
		GROUP BY A.Kd_Prov_B, A.Kd_Kab_Kota_B, A.Kd_Bidang_B, A.Kd_Unit_B, A.Kd_Sub_B, A.Kd_UPB_B, A.Tgl_Pembukuan, 
			A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register1, 
			A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, A.Penambahan, A.Kd_Prov_A, A.Kd_Kab_Kota_A, A.Kd_Bidang_A, A.Kd_Unit_A, A.Kd_Sub_A, A.Kd_UPB_A
		) A

	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Tgl_Pembukuan, 
		A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		 A.Merk, A.Type, A.Dokumen, A. Tgl_Dokumen, A.Bahan, A.Kondisi, A.Kd_Prov2, A.Kd_Kab_Kota2, A.Kd_Bidang2, A.Kd_Unit2, A.Kd_Sub2, A.Kd_UPB2
 	) A
GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Pemilik, A.Tgl_Pembukuan, 
	A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	 A.No_Register, A.Merk, A.Type, A.Dokumen, A.Tgl_DOkumen, A.Bahan, A.Kondisi, A.Harga_Awal, A.Pengurangan, A.Penambahan, A.Kd_Prov1,
	A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1,	
	A.Kd_Prov2, A.Kd_Kab_Kota2, A.Kd_Bidang2, A.Kd_Unit2, A.Kd_Sub2, A.Kd_UPB2

--Data Umum
SELECT	A.Tahun, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, B.Nm_Provinsi, C.Nm_Kab_Kota, D.Nm_Bidang,
	E.Nm_Unit, F.Nm_Sub_Unit, G.Nm_UPB, A.Jbt_Pimpinan, A.Nm_Pimpinan, A.NIP_Pimpinan, A.Jbt_Pengurus, A.Nm_Pengurus, A.NIP_Pengurus,
	dbo.fn_KdLokasi(H.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, YEAR(H.Tgl_Pembukuan)) AS Kd_Lokasi,
	dbo.fn_KdLokasi3(H.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, YEAR(H.Tgl_Pembukuan)) AS Kd_Lokasi_Grp,
	H.Nama_Barang, H.Kd_Aset_Gab5, H.No_Register, H.Merk, H.Type, H.Dokumen, H.Tgl_DOkumen, H.Bahan, H.Kondisi, H.Harga_Awal, H.Pengurangan, H.Penambahan,
	H.Kd_UPB_Gab, H.Nama_UPB_Tujuan, H.Kd_UPB_Gab_A, H.Nama_UPB_Asal
FROM	Ta_UPB A LEFT OUTER JOIN
	Ref_Provinsi B ON A.Kd_Prov = B.Kd_Prov LEFT OUTER JOIN
	Ref_Kab_Kota C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota LEFT OUTER JOIN
	Ref_Bidang D ON A.Kd_Bidang = D.Kd_Bidang LEFT OUTER JOIN
	Ref_Unit E ON A.Kd_Bidang = E.Kd_Bidang AND A.Kd_Unit = E.Kd_Unit LEFT OUTER JOIN
	Ref_Sub_Unit F ON A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub LEFT OUTER JOIN
	Ref_UPB G ON A.Kd_Bidang = G.Kd_Bidang AND A.Kd_Unit = G.Kd_Unit AND A.Kd_Sub = G.Kd_Sub AND A.Kd_UPB = G.Kd_UPB LEFT OUTER JOIN
	(
	SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Pemilik, A.Tgl_Pembukuan, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset), 2) AS Kd_Aset_Gab,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset0), 2) AS Kd_Aset_Gab0,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset0), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) AS Kd_Aset_Gab1,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset0), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) AS Kd_Aset_Gab2,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset0), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) AS Kd_Aset_Gab3,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset0), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 4) AS Kd_Aset_Gab4,
		RIGHT('0' + CONVERT(varchar, A.Kd_Aset), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset0), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset1), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 4) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset5), 5) AS Kd_Aset_Gab5,
		B.Nm_Aset5 AS Nama_Barang, A.Merk, A.Type, A.Dokumen, A.Tgl_DOkumen, A.Bahan, E.Uraian AS Kondisi,
		ISNULL(A.Harga_Awal,0)AS Harga_Awal, ISNULL(A.Pengurangan,0) AS Pengurangan, ISNULL(A.Penambahan, 0) AS Penambahan, 
		A.Kd_Prov1, A.Kd_Kab_Kota1, A.Kd_Bidang1, A.Kd_Unit1, A.Kd_Sub1, A.Kd_UPB1,
		RIGHT('0' + A.Kd_Bidang1, 2) AS Kd_Bidang_Gab_1,
		RIGHT('0' + A.Kd_Bidang1, 2) + '.' + RIGHT('0' + A.Kd_Unit1, 2) AS Kd_Unit_Gab_1,
		RIGHT('0' + A.Kd_Bidang1, 2) + '.' + RIGHT('0' + A.Kd_Unit1, 2) + '.' + RIGHT('0' + A.Kd_Sub1, 2) AS Kd_Sub_Gab_1,
		CASE WHEN A.Pengurangan <> 0
		THEN
		RIGHT('0' + A.Kd_Bidang1, 2) + '.' + RIGHT('0' + A.Kd_Unit1, 2) + '.' + RIGHT('0' + A.Kd_Sub1, 2) + '.' + RIGHT('0' + A.Kd_UPB1, 2) 
		ELSE '' END AS Kd_UPB_Gab, 
		CASE WHEN A.Pengurangan <> 0
		THEN C.Nm_UPB 
		ELSE '' END AS Nama_UPB_Tujuan,
		A.Kd_Prov2, A.Kd_Kab_Kota2, A.Kd_Bidang2, A.Kd_Unit2, A.Kd_Sub2, A.Kd_UPB2,
		RIGHT('0' + A.Kd_Bidang2, 2) AS Kd_Bidang_Gab_A,
		RIGHT('0' + A.Kd_Bidang2, 2) + '.' + RIGHT('0' + A.Kd_Unit2, 2) AS Kd_Unit_Gab_A,
		RIGHT('0' + A.Kd_Bidang2, 2) + '.' + RIGHT('0' + A.Kd_Unit2, 2) + '.' + RIGHT('0' + A.Kd_Sub2, 2) AS Kd_Sub_Gab_A,
		CASE WHEN A.Penambahan <> 0 
		THEN
		RIGHT('0' + A.Kd_Bidang2, 2) + '.' + RIGHT('0' + A.Kd_Unit2, 2) + '.' + RIGHT('0' + A.Kd_Sub2, 2) + '.' + RIGHT('0' + A.Kd_UPB2, 2) 
		ELSE '' END AS Kd_UPB_Gab_A, 
		CASE WHEN A.Penambahan <> 0 
		THEN 
		D.Nama_UPB 
		ELSE '' END AS Nama_UPB_Asal
	FROM	@Mutasi_SKPD A LEFT OUTER JOIN
		REF_KONDISI E ON A.KONDISI = E.KD_KONDISI LEFT OUTER JOIN
		Ref_Rek5_108 B ON A.Kd_Aset = B.Kd_Aset AND A.Kd_Aset0 = B.Kd_Aset0 AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 LEFT OUTER JOIN
		Ref_UPB C ON A.Kd_Prov1 = C.Kd_Prov AND A.Kd_Kab_Kota1 = C.Kd_Kab_Kota AND A.Kd_Bidang1 = C.Kd_Bidang AND A.Kd_Unit1 = C.Kd_Unit AND A.Kd_Sub1 = C.Kd_Sub AND A.Kd_UPB1 = C.Kd_UPB LEFT OUTER JOIN
		(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
			A.Kd_Prov2, A.Kd_Kab_Kota2, A.Kd_Bidang2, A.Kd_Unit2, A.Kd_Sub2, A.Kd_UPB2, B.Nm_UPB AS Nama_UPB,
			A.Kd_Aset,A.Kd_Aset0,A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
		FROM	@Mutasi_SKPD A LEFT OUTER JOIN
			Ref_UPB B ON A.Kd_Prov2 = B.Kd_Prov AND A.Kd_Kab_Kota2 = B.Kd_Kab_Kota AND A.Kd_Bidang2 = B.Kd_Bidang AND A.Kd_Unit2 = B.Kd_Unit AND
				     A.Kd_Sub2 = B.Kd_Sub AND A.Kd_UPB2 = B.Kd_UPB
		WHERE	A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND
			A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
		) D ON A.Kd_Prov = D.Kd_Prov AND A.Kd_Kab_Kota = D.Kd_Kab_Kota AND A.Kd_Bidang = D.Kd_Bidang AND A.Kd_Unit = D.Kd_Unit AND A.Kd_Sub = D.Kd_Sub AND A.Kd_UPB = D.Kd_UPB AND 
			A.Kd_Aset = D.Kd_Aset AND A.Kd_Aset0 = D.Kd_Aset0 AND A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND 
			A.Kd_Aset5 = D.Kd_Aset5 AND A.No_Register = D.No_Register
	WHERE	(A.Pengurangan <> 0 OR A.Penambahan <> 0) --AND (A.Tgl_Pembukuan >= @D1 AND A.Tgl_Pembukuan <= @D2)
	--AND A.Kd_Aset1=2 AND A.Kd_Aset2=3 AND A.Kd_Aset3=1 AND A.Kd_Aset4=1 AND A.Kd_Aset5=3
	) H ON A.Kd_Prov = H.Kd_Prov AND A.Kd_Kab_Kota = H.Kd_Kab_Kota AND A.Kd_Bidang = H.Kd_Bidang AND A.Kd_Unit = H.Kd_Unit AND 
	       A.Kd_Sub = H.Kd_Sub AND A.Kd_UPB = H.Kd_UPB 
WHERE	A.Tahun = @Tahun AND A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota AND A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND
	A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB
GROUP BY A.Tahun, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, B.Nm_Provinsi, C.Nm_Kab_Kota, D.Nm_Bidang,
	E.Nm_Unit, F.Nm_Sub_Unit, G.Nm_UPB, A.Jbt_Pimpinan, A.Nm_Pimpinan, A.NIP_Pimpinan, A.Jbt_Pengurus, A.Nm_Pengurus, A.NIP_Pengurus,
	H.Kd_Pemilik, H.Tgl_Pembukuan, H.Nama_Barang, H.Kd_Aset_Gab5, H.No_Register, H.Merk, H.Type, H.Dokumen, H.Tgl_DOkumen, H.Bahan, H.Kondisi,
	H.Harga_Awal, H.Pengurangan, H.Penambahan, H.Kd_UPB_Gab, H.Nama_UPB_Tujuan, H.Kd_UPB_Gab_A, H.Nama_UPB_Asal
ORDER BY H.Kd_Aset_Gab5



GO
