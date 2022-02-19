USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** SP_ReklasAset - 11052020 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE dbo.SP_ReklasAset @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4), @D2 Datetime, @KIB varchar(2), @IDUser varchar(20)                           
WITH ENCRYPTION
AS
/*

DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), @jenis varchar(50)
SET @Tahun = '2019'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '8'
SET @Kd_Unit = '1'
SET @Kd_Sub = '46'
SET @Kd_UPB = '1'
SET @jenis = '5'
--*/

	DECLARE @Kd_Aset varchar(3), @Kd_Aset0 varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @Kd_Aset5 varchar(3), @No_Register varchar(4), @JLap Tinyint
	SET @Kd_Aset  = ''
	SET @Kd_Aset0 = ''
	SET @Kd_Aset1 = ''
	SET @Kd_Aset2 = ''
	SET @Kd_Aset3 = ''
	SET @Kd_Aset4 = ''
	SET @Kd_Aset5 = ''
	SET @No_Register = ''
	SET @JLap = 1


IF @KIB = 'B' 
BEGIN
	INSERT INTO Ta_KIB_A (IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
			Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8,
			Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan,  
			Asal_usul, Harga, Keterangan,
			Tahun, No_SP2D, No_ID, Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus)
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
			A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
			A.Kd_Pemilik, A.Tgl_Perolehan, @D2 AS Tgl_Pembukuan,  
			A.Asal_usul, B.Harga, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID, 
			A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, A.Log_User, A.Log_Entry, A.Kd_Hapus	
	FROM Ta_KIB_B A INNER JOIN dbo.fn_Kartu108_BrgB (@D2,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,@Kd_Aset,@Kd_Aset0,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,@No_Register,@JLap) B
		ON A.IDPemda = B.IDPemda AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 = 1 ---AND B.Tahun = @Tahun

		
	INSERT INTO Ta_KIB_C(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB,
			Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8,
			Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan,
			Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID,
			Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus)
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
			A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
			A.Kd_Pemilik, A.Tgl_Perolehan, @D2 AS Tgl_Pembukuan,
			A.Asal_usul, B.Kondisi, B.Harga, 
			CASE
			   WHEN (A.Masa_Manfaat is null OR A.Masa_Manfaat = 0) THEN 0
			  WHEN C.Sisa_Umur > D.Umur THEN D.Umur
			  WHEN C.Sisa_Umur < D.Umur THEN C.Sisa_Umur
			ELSE D.Umur
			END AS Masa_Manfaat,
			A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID,  
			A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, A.Log_User, A.Log_Entry, A.Kd_Hapus	
	FROM Ta_KIB_B A INNER JOIN dbo.fn_Kartu108_BrgB (@D2,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,@Kd_Aset,@Kd_Aset0,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,@No_Register,@JLap) B
		ON A.IDPemda = B.IDPemda AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5 
		LEFT OUTER JOIN (SELECT Tahun, IDPemda, Max(Sisa_Umur) AS Sisa_Umur
				FROM Ta_SusutB 
				GROUP BY Tahun, IDPemda) C ON A.Tahun = C.Tahun AND A.IDPemda = C.IDPemda
		LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, MAX(Umur*12) AS Umur
				FROM Ref_Penyusutan 
				GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D  
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 = 3 --AND B.Tahun = @Tahun


	INSERT INTO Ta_KIB_D(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
			Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8,
			Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan,  
			Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, Kd_Kecamatan,
			Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus)
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
			A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
			A.Kd_Pemilik, A.Tgl_Perolehan, @D2 AS Tgl_Pembukuan,
			A.Asal_usul, B.Kondisi, B.Harga, 
			CASE
			  WHEN (A.Masa_Manfaat is null OR A.Masa_Manfaat = 0) THEN 0
			  WHEN C.Sisa_Umur > D.Umur THEN D.Umur
			  WHEN C.Sisa_Umur < D.Umur THEN C.Sisa_Umur
			ELSE D.Umur
			END AS Masa_Manfaat,
			A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID,  
			A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, A.Log_User, A.Log_Entry, A.Kd_Hapus	
	FROM Ta_KIB_B A INNER JOIN dbo.fn_Kartu108_BrgB (@D2,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,@Kd_Aset,@Kd_Aset0,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,@No_Register,@JLap) B
		ON A.IDPemda = B.IDPemda AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5	
		LEFT OUTER JOIN (SELECT Tahun, IDPemda, Max(Sisa_Umur) AS Sisa_Umur
				FROM Ta_SusutB 
				GROUP BY Tahun, IDPemda) C ON A.Tahun = C.Tahun AND A.IDPemda = C.IDPemda
		LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, MIN(Umur*12) AS Umur
				FROM Ref_Penyusutan 
				GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D  
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 = 4 AND B.Tahun = @Tahun


	INSERT INTO Ta_KIB_E(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
			Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 
			Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8,
			Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan,  
			Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, 
			Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus)
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,

			A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,

			A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, 
A.No_Reg8,
			A.Kd_Pemilik, A.Tgl_Perolehan, A.Tgl_Pembukuan,
			A.Asal_usul, B.Kondisi, B.Harga, 
			CASE
			  WHEN (A.Masa_Manfaat is null OR A.Masa_Manfaat = 0) THEN 0
			  WHEN C.Sisa_Umur > D.Umur THEN D.Umur
			  WHEN C.Sisa_Umur < D.Umur THEN C.Sisa_Umur
			ELSE D.Umur
			END AS Masa_Manfaat,
			A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID,  
			A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, A.Log_User, A.Log_Entry, A.Kd_Hapus	
	FROM Ta_KIB_B A INNER JOIN dbo.fn_Kartu108_BrgB (@D2,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,@Kd_Aset,@Kd_Aset0,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,@No_Register,@JLap) B
		ON A.IDPemda = B.IDPemda AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5	
		LEFT OUTER JOIN (SELECT Tahun, IDPemda, Max(Sisa_Umur) AS Sisa_Umur
				FROM Ta_SusutB 
				GROUP BY Tahun, IDPemda) C ON A.Tahun = C.Tahun AND A.IDPemda = C.IDPemda
		LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Max(Umur*12) AS Umur
				FROM Ref_Penyusutan 
				GROUP BY Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D    
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 = 5 --AND B.Tahun = @Tahun
	

	INSERT INTO Ta_SusutC(Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt, Kawal)
	SELECT B.Tahun, B.IDPemda, B.Harga, B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_Susut, B.Nilai_Sisa, --B.Sisa_Umur, 
		CASE		 
		WHEN B.Sisa_Umur > D.Umur THEN D.Umur
		WHEN B.Sisa_Umur < D.Umur THEN B.Sisa_Umur
		ELSE D.Umur
		END AS Sisa_Umur,
		B.Jndt, B.Kawal
	FROM Ta_KIB_B A INNER JOIN Ta_SusutB B ON A.IDPemda = B.IDPemda 
	LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, MIN(Umur*12) AS Umur
				FROM Ref_Penyusutan 
				GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D  
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 IN (3) AND B.Tahun = @Tahun-1

	INSERT INTO Ta_SusutD(Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt, Kawal)
	SELECT B.Tahun, B.IDPemda, B.Harga, B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_Susut, B.Nilai_Sisa, --B.Sisa_Umur, 
		CASE		 
		WHEN B.Sisa_Umur > D.Umur THEN D.Umur
		WHEN B.Sisa_Umur < D.Umur THEN B.Sisa_Umur
		ELSE D.Umur
		END AS Sisa_Umur,
		B.Jndt, B.Kawal	
	FROM Ta_KIB_B A INNER JOIN Ta_SusutB B ON A.IDPemda = B.IDPemda 
	LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, MIN(Umur*12) AS Umur
				FROM Ref_Penyusutan 
				GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D  
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 IN (4) AND B.Tahun =@Tahun-1

	INSERT INTO Ta_SusutE(Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt, Kawal)
	SELECT B.Tahun, B.IDPemda, B.Harga, B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_Susut, B.Nilai_Sisa, --B.Sisa_Umur, 
		CASE		 
		WHEN B.Sisa_Umur > D.Umur THEN D.Umur
		WHEN B.Sisa_Umur < D.Umur THEN B.Sisa_Umur
		ELSE D.Umur
		END AS Sisa_Umur,
		B.Jndt, B.Kawal	
	FROM Ta_KIB_B A INNER JOIN Ta_SusutB B ON A.IDPemda = B.IDPemda 
	LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, MIN(Umur*12) AS Umur
				FROM Ref_Penyusutan 
				GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D  
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 IN (5) AND B.Tahun = @Tahun-1
	
	
	BEGIN TRANSACTION
	DELETE Ta_SusutB
	FROM Ta_SusutB A INNER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Aset8 = 1 AND B.Kd_Aset80 = 3 AND B.Kd_Aset81 IN (1,3,4,5)

	DELETE Ta_KIBBR 
	FROM Ta_KIBBR A INNER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Hapus = 0 AND B.Kd_Aset8 = 1 AND B.Kd_Aset80 = 3 AND B.Kd_Aset81 IN (1,3,4,5)

	DELETE Ta_KIB_B 
	FROM Ta_KIB_B A
	WHERE Kd_Hapus = 0 AND Kd_Aset8 = 1 AND Kd_Aset80 = 3 AND Kd_Aset81 IN (1,3,4,5)
	COMMIT TRANSACTION
END 	

IF @KIB = 'C' 
BEGIN
	INSERT INTO Ta_KIB_B(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
			Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8,
			Kd_Ruang, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Merk, [Type], CC, Bahan, 
			Nomor_Pabrik, Nomor_Rangka, Nomor_Mesin, Nomor_Polisi, Nomor_BPKB, 
			Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, 
			Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan,
			Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus)
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
			'' AS Kd_Ruang, A.Kd_Pemilik, A.Tgl_Perolehan, @D2 AS Tgl_Pembukuan, '' AS Merk, '' AS [Type], '' AS CC, '' AS Bahan,
			'' AS  Nomor_Pabrik, '' AS  Nomor_Rangka, '' AS  Nomor_Mesin, '' AS  Nomor_Polisi, '' AS  Nomor_BPKB, 
			A.Asal_usul, B.Kondisi, B.Harga, 
			CASE
			  WHEN (A.Masa_Manfaat is null OR A.Masa_Manfaat = 0) THEN 0
			  WHEN C.Sisa_Umur > D.Umur THEN D.Umur
			  WHEN C.Sisa_Umur < D.Umur THEN C.Sisa_Umur
			ELSE D.Umur
			END AS Masa_Manfaat,
			A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID,
			A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, A.Log_User, A.Log_Entry, A.Kd_Hapus						
	FROM Ta_KIB_C A INNER JOIN dbo.fn_Kartu108_BrgC (@D2,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,@Kd_Aset,@Kd_Aset0,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,@No_Register,@JLap) B
		ON A.IDPemda = B.IDPemda AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5	
		LEFT OUTER JOIN (SELECT Tahun, IDPemda, Max(Sisa_Umur) AS Sisa_Umur
				FROM Ta_SusutC 
				GROUP BY Tahun, IDPemda) C ON A.Tahun = C.Tahun AND A.IDPemda = C.IDPemda
		LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, MIN(Umur*12) AS Umur
				FROM Ref_Penyusutan 
				GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D  
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 = 2 --AND B.Tahun = @Tahun
	
	INSERT INTO Ta_KIB_D(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
			Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,

			Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8,
			Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Konstruksi, Panjang, Lebar, Luas, Lokasi, Dokumen_Tanggal, Dokumen_Nomor, 
			Status_Tanah, Kd_Tanah1, Kd_Tanah2, Kd_Tanah3, Kd_Tanah4, Kd_Tanah5, Kode_Tanah, 
			Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, 
			Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus)
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
			A.Kd_Pemilik, A.Tgl_Perolehan, @D2 AS Tgl_Pembukuan, '' AS Konstruksi, '' AS Panjang, '' AS Lebar, '' AS Luas, '' AS Lokasi, '' AS Dokumen_Tanggal, '' AS Dokumen_Nomor, 
			'' AS Status_Tanah, '' AS Kd_Tanah1, '' AS Kd_Tanah2, '' AS Kd_Tanah3, '' AS Kd_Tanah4, '' AS Kd_Tanah5, '' AS Kode_Tanah,
			A.Asal_usul, B.Kondisi, B.Harga, 
			CASE
			  WHEN (A.Masa_Manfaat is null OR A.Masa_Manfaat = 0) THEN 0
			  WHEN C.Sisa_Umur > D.Umur THEN D.Umur
			  WHEN C.Sisa_Umur < D.Umur THEN C.Sisa_Umur
			ELSE D.Umur
			END AS Masa_Manfaat,
			A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID,
			A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, A.Log_User, A.Log_Entry, A.Kd_Hapus						
	FROM Ta_KIB_C A INNER JOIN dbo.fn_Kartu108_BrgC (@D2,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,@Kd_Aset,@Kd_Aset0,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,@No_Register,@JLap) B
		ON A.IDPemda = B.IDPemda AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5	
		LEFT OUTER JOIN (SELECT Tahun, IDPemda, Max(Sisa_Umur) AS Sisa_Umur
				FROM Ta_SusutC 
				GROUP BY Tahun, IDPemda) C ON A.Tahun = C.Tahun AND A.IDPemda = C.IDPemda
		LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Max(Umur*12) AS Umur
				FROM Ref_Penyusutan 
				GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D    
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 = 4 --AND B.Tahun = @Tahun

	INSERT INTO Ta_SusutB(Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt, Kawal)
	SELECT B.Tahun, B.IDPemda, B.Harga, B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_Susut, B.Nilai_Sisa, --B.Sisa_Umur, 
		CASE		 
		WHEN B.Sisa_Umur > D.Umur THEN D.Umur
		WHEN B.Sisa_Umur < D.Umur THEN B.Sisa_Umur
		ELSE D.Umur
		END AS Sisa_Umur,
		B.Jndt, B.Kawal	
	FROM Ta_KIB_C A INNER JOIN Ta_SusutC B ON A.IDPemda = B.IDPemda 
	LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, MIN(Umur*12) AS Umur
				FROM Ref_Penyusutan 
				GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D  
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 IN (2) AND B.Tahun = @Tahun-1

	INSERT INTO Ta_SusutD(Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt, Kawal)
	SELECT B.Tahun, B.IDPemda, B.Harga, B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_Susut, B.Nilai_Sisa, --B.Sisa_Umur, 
		CASE		 
		WHEN B.Sisa_Umur > D.Umur THEN D.Umur
		WHEN B.Sisa_Umur < D.Umur THEN B.Sisa_Umur
		ELSE D.Umur
		END AS Sisa_Umur,
		B.Jndt, B.Kawal	
	FROM Ta_KIB_C A INNER JOIN Ta_SusutC B ON A.IDPemda = B.IDPemda 
	LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, MIN(Umur*12) AS Umur
				FROM Ref_Penyusutan 
				GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D  
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 IN (4) AND B.Tahun = @Tahun-1
	

	BEGIN TRANSACTION
	DELETE Ta_SusutC
	FROM Ta_SusutC A INNER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Aset8 = 1 AND B.Kd_Aset80 = 3 AND B.Kd_Aset81 IN (2,4)

	DELETE Ta_KIBCR 
	FROM Ta_KIBCR A INNER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Hapus = 0 AND A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 IN (2,4)

	DELETE Ta_KIB_C WHERE Kd_Hapus = 0 AND  Kd_Aset81 IN (2,4)
	COMMIT TRANSACTION
END

IF @KIB = 'D' 
BEGIN
	INSERT INTO Ta_KIB_B(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
			Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8,
			Kd_Ruang, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Merk, [Type], CC, Bahan, 
			Nomor_Pabrik, Nomor_Rangka, Nomor_Mesin, Nomor_Polisi, Nomor_BPKB, 
			Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, 
			Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan,
			Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus)
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
			'' AS Kd_Ruang, A.Kd_Pemilik, A.Tgl_Perolehan, @D2 AS Tgl_Pembukuan, '' AS Merk, '' AS [Type], '' AS CC, '' AS Bahan,
			'' AS  Nomor_Pabrik, '' AS  Nomor_Rangka, '' AS  Nomor_Mesin, '' AS  Nomor_Polisi, '' AS  Nomor_BPKB, 
			A.Asal_usul, B.Kondisi, B.Harga, 
			CASE
			   WHEN (A.Masa_Manfaat is null OR A.Masa_Manfaat = 0) THEN 0
			  WHEN C.Sisa_Umur > D.Umur THEN D.Umur
			  WHEN C.Sisa_Umur < D.Umur THEN C.Sisa_Umur
			ELSE D.Umur
			END AS Masa_Manfaat,
			A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID,
			A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, A.Log_User, A.Log_Entry, A.Kd_Hapus						
	FROM Ta_KIB_D A INNER JOIN dbo.fn_Kartu108_BrgD (@D2,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,@Kd_Aset,@Kd_Aset0,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,@No_Register,@JLap) B
		ON A.IDPemda = B.IDPemda AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5	
		LEFT OUTER JOIN (SELECT Tahun, IDPemda, Max(Sisa_Umur) AS Sisa_Umur
				FROM Ta_SusutD 
				GROUP BY Tahun, IDPemda) C ON A.Tahun = C.Tahun AND A.IDPemda = C.IDPemda
		LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, MIN(Umur*12) AS Umur
				FROM Ref_Penyusutan 
				GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D    
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 = 2 --AND B.Tahun = @Tahun

	INSERT INTO Ta_KIB_C(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB,
			Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8,
			Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan,
			Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID,
			Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan, Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus)
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
			A.Kd_Pemilik, A.Tgl_Perolehan, @D2 AS Tgl_Pembukuan, A.Asal_usul, B.Kondisi, B.Harga, 
			CASE
			   WHEN (A.Masa_Manfaat is null OR A.Masa_Manfaat = 0) THEN 0
			  WHEN C.Sisa_Umur > D.Umur THEN D.Umur
			  WHEN C.Sisa_Umur < D.Umur THEN C.Sisa_Umur
			ELSE D.Umur
			END AS Masa_Manfaat,
			A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID,
			A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, A.Log_User, A.Log_Entry, A.Kd_Hapus						
	FROM Ta_KIB_D A INNER JOIN dbo.fn_Kartu108_BrgD (@D2,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,@Kd_Aset,@Kd_Aset0,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,@No_Register,@JLap) B
		ON A.IDPemda = B.IDPemda AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5	
		LEFT OUTER JOIN (SELECT Tahun, IDPemda, Max(Sisa_Umur) AS Sisa_Umur
				FROM Ta_SusutD 
				GROUP BY Tahun, IDPemda) C ON A.Tahun = C.Tahun AND A.IDPemda = C.IDPemda
		LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, MAX(Umur*12) AS Umur
				FROM Ref_Penyusutan 
				GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D    
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 = 3 --AND B.Tahun = @Tahun

	INSERT INTO Ta_SusutB(Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt, Kawal)
	SELECT B.Tahun, B.IDPemda, B.Harga, B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_Susut, B.Nilai_Sisa, --B.Sisa_Umur, 
		CASE		 
		WHEN B.Sisa_Umur > D.Umur THEN D.Umur
		WHEN B.Sisa_Umur < D.Umur THEN B.Sisa_Umur
		ELSE D.Umur
		END AS Sisa_Umur,
		B.Jndt, B.Kawal	
	FROM Ta_KIB_D A INNER JOIN Ta_SusutC B ON A.IDPemda = B.IDPemda 
	LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, MIN(Umur*12) AS Umur
				FROM Ref_Penyusutan 
				GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D  
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 IN (2) AND B.Tahun = @Tahun-1

	INSERT INTO Ta_SusutC(Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt, Kawal)
	SELECT B.Tahun, B.IDPemda, B.Harga, B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_Susut, B.Nilai_Sisa, --B.Sisa_Umur, 
		CASE		 
		WHEN B.Sisa_Umur > D.Umur THEN D.Umur
		WHEN B.Sisa_Umur < D.Umur THEN B.Sisa_Umur
		ELSE D.Umur
		END AS Sisa_Umur,
		B.Jndt, B.Kawal	
	FROM Ta_KIB_D A INNER JOIN Ta_SusutC B ON A.IDPemda = B.IDPemda 
	LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, MIN(Umur*12) AS Umur
				FROM Ref_Penyusutan 
				GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D  
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 IN (3) AND B.Tahun = @Tahun-1
	

	BEGIN TRANSACTION
	DELETE Ta_SusutD
	FROM Ta_SusutD A INNER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Aset8 = 1 AND B.Kd_Aset80 = 3 AND B.Kd_Aset81 IN (2,3)

	DELETE Ta_KIBDR 
	FROM Ta_KIBDR A INNER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Hapus = 0 AND B.Kd_Aset8 = 1 AND B.Kd_Aset80 = 3 AND B.Kd_Aset81 IN (2,3)

	DELETE Ta_KIB_D 
	FROM Ta_KIB_D A --INNER JOIN Ta_SusutD B ON A.IDPemda = B.IDPemda
	WHERE Kd_Hapus = 0 AND A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 IN (2,3)

	COMMIT TRANSACTION
END

IF @KIB = 'E' 
BEGIN
	INSERT INTO Ta_KIB_B(IDPemda, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
			Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register,
			Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85, No_Reg8,
			Kd_Ruang, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Merk, [Type], CC, Bahan, 
			Nomor_Pabrik, Nomor_Rangka, Nomor_Mesin, Nomor_Polisi, Nomor_BPKB, 
			Asal_usul, Kondisi, Harga, Masa_Manfaat, Nilai_Sisa, Keterangan, Tahun, No_SP2D, No_ID, 
			Kd_Kecamatan, Kd_Desa, Invent, No_SKGuna, Kd_Penyusutan,
			Kd_Data, Kd_KA, Log_User, Log_Entry, Kd_Hapus)
	SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
			A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
			A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85, A.No_Reg8,
			'' AS Kd_Ruang, A.Kd_Pemilik, A.Tgl_Perolehan, @D2 AS Tgl_Pembukuan, '' AS Merk, '' AS [Type], '' AS CC, '' AS Bahan,
			'' AS  Nomor_Pabrik, '' AS  Nomor_Rangka, '' AS  Nomor_Mesin, '' AS  Nomor_Polisi, '' AS  Nomor_BPKB, 
			A.Asal_usul, B.Kondisi, B.Harga, 
			CASE
			  WHEN (A.Masa_Manfaat is null OR A.Masa_Manfaat = 0) THEN 0
			  WHEN C.Sisa_Umur > D.Umur THEN D.Umur
			  WHEN C.Sisa_Umur < D.Umur THEN C.Sisa_Umur
			ELSE D.Umur
			END AS Masa_Manfaat,
			--IsNull(A.Masa_Manfaat,0), 
			A.Nilai_Sisa, A.Keterangan, A.Tahun, A.No_SP2D, A.No_ID,
			A.Kd_Kecamatan, A.Kd_Desa, A.Invent, A.No_SKGuna, A.Kd_Penyusutan, A.Kd_Data, A.Kd_KA, A.Log_User, A.Log_Entry, A.Kd_Hapus						
	FROM Ta_KIB_E A INNER JOIN dbo.fn_Kartu108_BrgE (@D2,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,@Kd_Aset,@Kd_Aset0,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4,@Kd_Aset5,@No_Register,@JLap) B
		ON A.IDPemda = B.IDPemda AND A.Kd_Aset8 = B.Kd_Aset AND A.Kd_Aset80 = B.Kd_Aset0 AND A.Kd_Aset81 = B.Kd_Aset1 AND A.Kd_Aset82 = B.Kd_Aset2 AND A.Kd_Aset83 = B.Kd_Aset3 AND A.Kd_Aset84 = B.Kd_Aset4 AND A.Kd_Aset85 = B.Kd_Aset5	
		LEFT OUTER JOIN (SELECT Tahun, IDPemda, Max(Sisa_Umur) AS Sisa_Umur
				FROM Ta_SusutE 
				GROUP BY Tahun, IDPemda) C ON A.Tahun = C.Tahun AND A.IDPemda = C.IDPemda
		LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Max(Umur*12) AS Umur
				FROM Ref_Penyusutan
				WHERE Kd_Aset8 = 1 AND Kd_Aset80 = 3 AND Kd_Aset81 = 2 --AND KD_ASET82 =19
				GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D    
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84

	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 = 2 --AND B.Tahun = @Tahun

	INSERT INTO Ta_SusutB(Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt, Kawal)
	SELECT B.Tahun, B.IDPemda, B.Harga, B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_Susut, B.Nilai_Sisa, --B.Sisa_Umur, 
		CASE		 
		WHEN B.Sisa_Umur > D.Umur THEN D.Umur
		WHEN B.Sisa_Umur < D.Umur THEN B.Sisa_Umur
		ELSE D.Umur
		END AS Sisa_Umur,
		B.Jndt, B.Kawal	
	FROM Ta_KIB_E A INNER JOIN Ta_SusutE B ON A.IDPemda = B.IDPemda 
	LEFT OUTER JOIN (SELECT MAX (Tahun) AS Tahun, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, MIN(Umur*12) AS Umur
				FROM Ref_Penyusutan 
				GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84) D  
			ON A.Kd_Aset8 = D.Kd_Aset8 AND A.Kd_Aset80 = D.Kd_Aset80 AND A.Kd_Aset81 = D.Kd_Aset81 AND A.Kd_Aset82 = D.Kd_Aset82 AND A.Kd_Aset83 = D.Kd_Aset83 AND A.Kd_Aset84 = D.Kd_Aset84
	WHERE A.Kd_Aset8 = 1 AND A.Kd_Aset80 = 3 AND A.Kd_Aset81 = 2 AND B.Tahun = @Tahun-1
	

	BEGIN TRANSACTION
	DELETE Ta_SusutE
	FROM Ta_SusutE A INNER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Aset8 = 1 AND B.Kd_Aset80 = 3 AND B.Kd_Aset81 IN (2)
	
	DELETE Ta_KIBER 
	FROM Ta_KIBER A INNER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
	WHERE B.Kd_Hapus = 0 AND B.Kd_Aset8 = 1 AND B.Kd_Aset80 = 3 AND B.Kd_Aset81 IN (2)

	DELETE Ta_KIB_E WHERE Kd_Hapus = 0 AND Kd_Aset8 = 1 AND Kd_Aset80 = 3 AND  Kd_Aset81 IN (2)
	COMMIT TRANSACTION
END







GO
