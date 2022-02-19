USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/* 07072020*/

CREATE PROCEDURE Rpt108PerbedaanPerolehanSusutNeraca @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D1 datetime, @Kd_KIB varchar(1)
WITH ENCRYPTION
AS
/*

DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D1 datetime, @Kd_KIB varchar(1)
SET @Tahun = '2019'
SET @Kd_Prov = '19'  --19
SET @Kd_Kab_Kota = '13'  --11
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @Kd_UPB = ''
SET @D1 = '20191231' 
SET @Kd_KIB = 'B'
--*/


---------------------------------
	DECLARE	@tmpsusut Table(Tahun smallint, IDPemda varchar (17), Harga money, Nilai_Susut1 money, Nilai_Susut2 money, Akum_Susut money, Nilai_Sisa money, Sisa_Umur smallint, Jndt varchar (1))
	DECLARE	@tmpKIB Table(IDPEMDA varchar (17), Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset smallint, Kd_Aset0 smallint, Kd_Aset1 smallint, Kd_Aset2 smallint, Kd_Aset3 smallint, 
		Kd_Aset4 smallint, Kd_Aset5 smallint, No_Register int)
	DECLARE	@tmpnrc Table(IDPEMDA varchar (17), Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, Kd_UPB smallint, Kd_Aset smallint, Kd_Aset0 smallint, Kd_Aset1 smallint, Kd_Aset2 smallint, Kd_Aset3 smallint, 
		Kd_Aset4 smallint, Kd_Aset5 smallint, No_Register int, Harganrc money, HargaSusut money)
        DECLARE @JLap Tinyint SET @JLap = 1
        
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'



IF @Kd_KIB = 'B' 
BEGIN


	INSERT INTO @tmpsusut
	SELECT	Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt--, Kawal 
	FROM	Ta_SusutB A WHERE Tahun = @Tahun and Jndt = 0

	INSERT INTO @tmpKIB
	SELECT IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8 AS Kd_Aset, Kd_Aset80 AS Kd_Aset0, Kd_Aset81 AS Kd_Aset1, Kd_Aset82 AS Kd_Aset2, Kd_Aset83 AS Kd_Aset3, Kd_Aset84 AS Kd_Aset4, Kd_Aset85 AS Kd_Aset5, No_Reg8 AS No_Register
	FROM TA_KIB_B
--
	INSERT INTO @tmpnrc
	SELECT A.IDPEMDA, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Harga AS Harganrc, 0 as HargaSusut FROM 
			(
			SELECT A.IDPEMDA,A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
				A.Harga , A.Masa_Manfaat AS Masa_ManfaatA, '' AS Tgl_DokumenA, A.Tgl_Perolehan AS Tgl_PerolehanA, A.Tgl_Pembukuan AS Tgl_PembukuanA, A.Kondisi AS KondisiA
				FROM fn_Kartu108_BrgB1(@Tahun, @D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A --LEFT OUTER JOIN
				WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              			A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 
	      			AND (A.Tahun = @Tahun)
					) A 

	INSERT INTO @tmpnrc
	SELECT A.IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 0 AS Harganrc, A.Harga as HargaSusut FROM 
			@tmpsusut A INNER JOIN @tmpKIB B ON A.IDPEMDA = B.IDPEMDA 
			WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)	


	SELECT B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, 
	RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_UPB), 2) AS KD_UPB_GAB, 
	CONVERT(varchar, A.Kd_ASET) + '.' + CONVERT(varchar, A.Kd_ASET0) + '.' + CONVERT(varchar, A.Kd_ASET1) + '.' + CONVERT(varchar, A.Kd_ASET2) + '.' +  RIGHT('0' + CONVERT(varchar, A.Kd_ASET3), 2)  + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_ASET4), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_ASET5), 2) AS Kd_Gab_5,
	C.Nm_Kab_Kota, B.Nm_Bidang, B.Nm_Unit, B.Nm_Sub_Unit, B.Nm_UPB, A.IDPEMDA, A.No_register, A.Nm_Aset5, A.TanpaKIBHapus, A.Bedakondisi, A.BedaHargadgnRwyt, A.TglBukuTglSKHapus, A.RBJadiB, A.HargaNrc as PerolehanNeraca, A.HargaSusut as PerolehanSusut 

	FROM 
	(	
	SELECT A.IDPEMDA, B.IDPEMDA AS 'TanpaKIBHapus', C.IDPEMDA AS 'Bedakondisi', D.IDPEMDA AS 'BedaHargadgnRwyt', E.IDPEMDA AS 'TglBukuTglSKHapus', F.IDPEMDA AS 'RBJadiB', Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, X.Nm_Aset5, No_Register, Harganrc, HargaSusut 
	FROM (
	SELECT Max(IDPEMDA)AS IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, SUM(Harganrc) AS Harganrc, SUM(HargaSusut) AS HargaSusut 
	FROM @tmpnrc 
	WHERE KD_ASET = 1 AND KD_ASET0 =3
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
	having (SUM(Harganrc) - SUM(HargaSusut)) <> 0 
		) A 
	INNER JOIN REF_REK5_108 X ON A.Kd_Aset = X.Kd_Aset AND A.Kd_Aset0 = X.Kd_Aset0 AND A.Kd_Aset1 = X.Kd_Aset1 AND A.Kd_Aset2 = X.Kd_Aset2 AND A.Kd_Aset3 = X.Kd_Aset3 AND A.Kd_Aset4 = X.Kd_Aset4 AND A.Kd_Aset5 = X.Kd_Aset5 

	left outer join -- KD_HAPUS=1 TAPI TIDAK ADA DI TA_KIBXHAPUS
	(
	select A.IDPEMDA from Ta_KIB_B A left outer join Ta_KIBBhapus B on A.IDPEMDA = B.IDPEMDA where A.kd_hapus=1 and A.Kd_KA=1 
	and B.IDPEMDA is null 
	) B ON A.IDPEMDA = B.IDPEMDA

	left outer join -- BUKAN RIWAYAT UBAH KONDISI TAPI KONDISI DI RIWAYATNYA <> INDUK
	(
	select A.IDPEMDA from Ta_KIBBR A inner join Ta_KIB_B B on A.IDPEMDA = B.IDPEMDA
	where A.kondisi <> B.kondisi and A.Kd_Riwayat <> 1 AND (A.kondisi = 3 OR B.kondisi = 3)
	) C ON A.IDPEMDA = C.IDPEMDA

	left outer join -- harga kib<>riwayat pada kode selain kapitalisasi, penghapusan sebagian, dan koreksi nilai (2,7,21)
	(
	select A.IDPEMDA from Ta_KIBBR A inner join Ta_KIB_B B on A.IDPEMDA = B.IDPEMDA
	where A.HARGA <> B.HARGA AND (NOT A.kd_riwayat IN (2,7,21)) 
	AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) 
	AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	) D ON A.IDPEMDA = D.IDPEMDA

	left outer join -- Tgl_Pembukuan>Tgl_SKHapus
	(
	select A.IDPEMDA FROM Ta_KIB_B A left outer join Ta_KIBBhapus B on A.IDPEMDA = B.IDPEMDA where a.kd_hapus=1 and a.kd_ka=1 and a.kondisi<3
	and A.Tgl_Pembukuan > B.Tgl_SK
	AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	) E ON A.IDPEMDA = E.IDPEMDA

	left outer join -- UBAH KONDISI BEBERAPA KALI
	(
	select IDPEMDA FROM Ta_KIBBR  where Kd_Riwayat in(1,2) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
	group by IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB having count(Kd_Riwayat) > 1 and sum(Kd_Riwayat) > count(Kd_Riwayat)
	) F ON A.IDPEMDA = F.IDPEMDA
	) A , 
        (		
         SELECT @Kd_Prov AS Kd_Prov, @Kd_Kab_Kota AS Kd_Kab_Kota, @Kd_Bidang AS Kd_Bidang, @Kd_Unit AS Kd_Unit, @Kd_Sub AS Kd_Sub, 
                @Kd_UPB AS Kd_UPB, E.Nm_Bidang, D.Nm_Unit, C.Nm_sub_Unit, B.Nm_UPB			
	 FROM Ta_UPB A INNER JOIN
              Ref_UPB B ON A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
	      Ref_Sub_Unit C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub INNER JOIN
	      Ref_Unit D ON C.Kd_Bidang = D.Kd_Bidang AND C.Kd_Unit = D.Kd_Unit INNER JOIN
	      Ref_Bidang E ON D.Kd_Bidang = E.Kd_Bidang INNER JOIN
	      (
	       SELECT TOP 1 Tahun, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
	       FROM Ta_UPB A
	       WHERE (A.Tahun = @Tahun) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	       ORDER BY Tahun, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
	       ) F ON A.Tahun = F.Tahun AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB
	 ) B,
         (
	  SELECT A.Nm_Kab_Kota
	  FROM Ref_Kab_Kota A
	  WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
	 ) C

end




-------------------------------------------


IF @Kd_KIB = 'C' 
BEGIN



	INSERT INTO @tmpsusut
	SELECT	Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt--, Kawal 
	FROM	Ta_SusutC A WHERE Tahun = @Tahun and Jndt = 0

	INSERT INTO @tmpKIB
	SELECT IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8 AS Kd_Aset, Kd_Aset80 AS Kd_Aset0, Kd_Aset81 AS Kd_Aset1, Kd_Aset82 AS Kd_Aset2, Kd_Aset83 AS Kd_Aset3, Kd_Aset84 AS Kd_Aset4, Kd_Aset85 AS Kd_Aset5, No_Reg8 AS No_Register
	FROM TA_KIB_C
--
	INSERT INTO @tmpnrc
	SELECT A.IDPEMDA, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Harga AS Harganrc, 0 as HargaSusut FROM 
			(
			SELECT A.IDPEMDA,A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
				A.Harga , A.Masa_Manfaat AS Masa_ManfaatA, '' AS Tgl_DokumenA, A.Tgl_Perolehan AS Tgl_PerolehanA, A.Tgl_Pembukuan AS Tgl_PembukuanA, A.Kondisi AS KondisiA
				FROM fn_Kartu108_BrgC1(@Tahun, @D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A --LEFT OUTER JOIN
				WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              			A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 
	      			AND (A.Tahun = @Tahun)
					) A 

	INSERT INTO @tmpnrc
	SELECT A.IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 0 AS Harganrc, A.Harga as HargaSusut FROM 
			@tmpsusut A INNER JOIN @tmpKIB B ON A.IDPEMDA = B.IDPEMDA 
			WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)	



	SELECT B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, 
	RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_UPB), 2) AS KD_UPB_GAB, 
	CONVERT(varchar, A.Kd_ASET) + '.' + CONVERT(varchar, A.Kd_ASET0) + '.' + CONVERT(varchar, A.Kd_ASET1) + '.' + CONVERT(varchar, A.Kd_ASET2) + '.' +  RIGHT('0' + CONVERT(varchar, A.Kd_ASET3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_ASET4), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_ASET5), 2) AS Kd_Gab_5,
	C.Nm_Kab_Kota, B.Nm_Bidang, B.Nm_Unit, B.Nm_Sub_Unit, B.Nm_UPB, A.IDPEMDA, A.No_register, A.Nm_Aset5, A.TanpaKIBHapus, A.Bedakondisi, A.BedaHargadgnRwyt, A.TglBukuTglSKHapus, A.RBJadiB, A.HargaNrc as PerolehanNeraca, A.HargaSusut as PerolehanSusut 

	FROM 
	(	
	SELECT A.IDPEMDA, B.IDPEMDA AS 'TanpaKIBHapus', C.IDPEMDA AS 'Bedakondisi', D.IDPEMDA AS 'BedaHargadgnRwyt', E.IDPEMDA AS 'TglBukuTglSKHapus', F.IDPEMDA AS 'RBJadiB', Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, X.Nm_Aset5, No_Register, Harganrc, HargaSusut 
	FROM (
	SELECT Max(IDPEMDA)AS IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, SUM(Harganrc) AS Harganrc, SUM(HargaSusut) AS HargaSusut 
	FROM @tmpnrc 
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
	having (SUM(Harganrc) - SUM(HargaSusut)) <> 0 
		) A 
	INNER JOIN REF_REK5_108 X ON A.Kd_Aset = X.Kd_Aset AND A.Kd_Aset0 = X.Kd_Aset0 AND A.Kd_Aset1 = X.Kd_Aset1 AND A.Kd_Aset2 = X.Kd_Aset2 AND A.Kd_Aset3 = X.Kd_Aset3 AND A.Kd_Aset4 = X.Kd_Aset4 AND A.Kd_Aset5 = X.Kd_Aset5 

	left outer join -- KD_HAPUS=1 TAPI TIDAK ADA DI TA_KIBXHAPUS
	(
	select A.IDPEMDA from ta_kib_c A left outer join ta_kibchapus B on A.IDPEMDA = B.IDPEMDA where A.kd_hapus=1 and A.Kd_KA=1 
	and b.IDPEMDA is null 
	) B ON A.IDPEMDA = B.IDPEMDA

	left outer join -- BUKAN RIWAYAT UBAH KONDISI TAPI KONDISI DI RIWAYATNYA <> INDUK
	(
	select A.IDPEMDA from ta_kibcr A inner join ta_kib_c B on A.IDPEMDA = B.IDPEMDA
	where A.kondisi <> B.kondisi and A.Kd_Riwayat <> 1 AND (A.kondisi = 3 OR B.kondisi = 3)
	) C ON A.IDPEMDA = C.IDPEMDA

	left outer join -- harga kib<>riwayat pada kode selain kapitalisasi, penghapusan sebagian, dan koreksi nilai (2,7,21)
	(
	select A.IDPEMDA from ta_kibcr A inner join Ta_Kib_C B on A.IDPEMDA = B.IDPEMDA
	where A.HARGA <> B.HARGA AND (NOT A.kd_riwayat IN (2,7,21)) 
	AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	) D ON A.IDPEMDA = D.IDPEMDA

	left outer join -- Tgl_Pembukuan>Tgl_SKHapus
	(
	select A.IDPEMDA FROM ta_kib_C A left outer join ta_kibchapus B on A.IDPEMDA = B.IDPEMDA where a.kd_hapus=1 and a.kd_ka=1 and a.kondisi<3
	and A.Tgl_Pembukuan > B.Tgl_SK
	AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	) E ON A.IDPEMDA = E.IDPEMDA

	left outer join -- UBAH KONDISI BEBERAPA KALI
	(
	select IDPEMDA FROM Ta_KIBCR  where Kd_Riwayat in(1,2) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
	group by IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB having count(Kd_Riwayat) > 1 and sum(Kd_Riwayat) > count(Kd_Riwayat)
	) F ON A.IDPEMDA = F.IDPEMDA
	) A , 
        (		
         SELECT @Kd_Prov AS Kd_Prov, @Kd_Kab_Kota AS Kd_Kab_Kota, @Kd_Bidang AS Kd_Bidang, @Kd_Unit AS Kd_Unit, @Kd_Sub AS Kd_Sub, 
                @Kd_UPB AS Kd_UPB, E.Nm_Bidang, D.Nm_Unit, C.Nm_sub_Unit, B.Nm_UPB			
	 FROM Ta_UPB A INNER JOIN
              Ref_UPB B ON A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
	      Ref_Sub_Unit C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub INNER JOIN
	      Ref_Unit D ON C.Kd_Bidang = D.Kd_Bidang AND C.Kd_Unit = D.Kd_Unit INNER JOIN
	      Ref_Bidang E ON D.Kd_Bidang = E.Kd_Bidang INNER JOIN
	      (
	       SELECT TOP 1 Tahun, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
	       FROM Ta_UPB A
	       WHERE (A.Tahun = @Tahun) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	       ORDER BY Tahun, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
	       ) F ON A.Tahun = F.Tahun AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB
	 ) B,
         (
	  SELECT A.Nm_Kab_Kota
	  FROM Ref_Kab_Kota A
	  WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
	 ) C

end

---------------------------------------------

IF @Kd_KIB = 'D' 
BEGIN


	INSERT INTO @tmpsusut
	SELECT	Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt--, Kawal 
	FROM	Ta_SusutD A WHERE Tahun = @Tahun and Jndt = 0

	INSERT INTO @tmpKIB
	SELECT IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8 AS Kd_Aset, Kd_Aset80 AS Kd_Aset0, Kd_Aset81 AS Kd_Aset1, Kd_Aset82 AS Kd_Aset2, Kd_Aset83 AS Kd_Aset3, Kd_Aset84 AS Kd_Aset4, Kd_Aset85 AS Kd_Aset5, No_Reg8 AS No_Register
	FROM TA_KIB_D
--
	INSERT INTO @tmpnrc
	SELECT A.IDPEMDA, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Harga AS Harganrc, 0 as HargaSusut FROM 
			(
			SELECT A.IDPEMDA,A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
				A.Harga , A.Masa_Manfaat AS Masa_ManfaatA, '' AS Tgl_DokumenA, A.Tgl_Perolehan AS Tgl_PerolehanA, A.Tgl_Pembukuan AS Tgl_PembukuanA, A.Kondisi AS KondisiA
				FROM fn_Kartu108_BrgD1(@Tahun, @D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A --LEFT OUTER JOIN
				WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              			A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 
	      			AND (A.Tahun = @Tahun)
					) A 

	INSERT INTO @tmpnrc
	SELECT A.IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 0 AS Harganrc, A.Harga as HargaSusut FROM 
			@tmpsusut A INNER JOIN @tmpKIB B ON A.IDPEMDA = B.IDPEMDA 
			WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)	





	SELECT B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, 
	RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_UPB), 2) AS KD_UPB_GAB, 
	CONVERT(varchar, A.Kd_ASET) + '.' + CONVERT(varchar, A.Kd_ASET0) + '.' + CONVERT(varchar, A.Kd_ASET1) + '.' + CONVERT(varchar, A.Kd_ASET2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_ASET3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_ASET4), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_ASET5), 2) AS Kd_Gab_5,
	C.Nm_Kab_Kota, B.Nm_Bidang, B.Nm_Unit, B.Nm_Sub_Unit, B.Nm_UPB, A.IDPEMDA, A.No_register, A.Nm_Aset5, A.TanpaKIBHapus, A.Bedakondisi, A.BedaHargadgnRwyt, A.TglBukuTglSKHapus, A.RBJadiB, A.HargaNrc as PerolehanNeraca, A.HargaSusut as PerolehanSusut 

	FROM 
	(	
	SELECT A.IDPEMDA, B.IDPEMDA AS 'TanpaKIBHapus', C.IDPEMDA AS 'Bedakondisi', D.IDPEMDA AS 'BedaHargadgnRwyt', E.IDPEMDA AS 'TglBukuTglSKHapus', F.IDPEMDA AS 'RBJadiB', Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, X.Nm_Aset5, No_Register, Harganrc, HargaSusut 
	FROM (
	SELECT Max(IDPEMDA) AS IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, SUM(Harganrc) AS Harganrc, SUM(HargaSusut) AS HargaSusut 
	FROM @tmpnrc 
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
	having (SUM(Harganrc) - SUM(HargaSusut)) <> 0 
		) A 
	INNER JOIN REF_REK5_108 X ON A.Kd_Aset = X.Kd_Aset AND A.Kd_Aset0 = X.Kd_Aset0 AND A.Kd_Aset1 = X.Kd_Aset1 AND A.Kd_Aset2 = X.Kd_Aset2 AND A.Kd_Aset3 = X.Kd_Aset3 AND A.Kd_Aset4 = X.Kd_Aset4 AND A.Kd_Aset5 = X.Kd_Aset5 

	left outer join -- KD_HAPUS=1 TAPI TIDAK ADA DI TA_KIBXHAPUS
	(
	select A.IDPEMDA from Ta_KIB_D A left outer join Ta_KIBDhapus B on A.IDPEMDA = B.IDPEMDA where A.kd_hapus=1 and A.Kd_KA=1 
	and b.IDPEMDA is null 
	) B ON A.IDPEMDA = B.IDPEMDA

	left outer join -- BUKAN RIWAYAT UBAH KONDISI TAPI KONDISI DI RIWAYATNYA <> INDUK
	(
	select A.IDPEMDA from Ta_KIBDR A inner join Ta_KIB_D B on A.IDPEMDA = B.IDPEMDA
	where A.kondisi <> B.kondisi and A.Kd_Riwayat <> 1 AND (A.kondisi = 3 OR B.kondisi = 3)
	) C ON A.IDPEMDA = C.IDPEMDA

	left outer join -- harga kib<>riwayat pada kode selain kapitalisasi, penghapusan sebagian, dan koreksi nilai (2,7,21)
	(
	select A.IDPEMDA from Ta_KIBDR A inner join Ta_KIB_D B on A.IDPEMDA = B.IDPEMDA
	where A.HARGA <> B.HARGA AND (NOT A.kd_riwayat IN (2,7,21)) 
	AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	) D ON A.IDPEMDA = D.IDPEMDA

	left outer join -- Tgl_Pembukuan>Tgl_SKHapus
	(
	select A.IDPEMDA FROM Ta_KIB_D A left outer join Ta_KIBDhapus B on A.IDPEMDA = B.IDPEMDA where a.kd_hapus=1 and a.kd_ka=1 and a.kondisi<3
	and A.Tgl_Pembukuan > B.Tgl_SK
	AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	) E ON A.IDPEMDA = E.IDPEMDA

	left outer join -- UBAH KONDISI BEBERAPA KALI
	(
	select IDPEMDA FROM Ta_KIBDR  where Kd_Riwayat in(1,2) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
	group by IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB having count(Kd_Riwayat) > 1 and sum(Kd_Riwayat) > count(Kd_Riwayat)
	) F ON A.IDPEMDA = F.IDPEMDA
	) A , 
        (		
         SELECT @Kd_Prov AS Kd_Prov, @Kd_Kab_Kota AS Kd_Kab_Kota, @Kd_Bidang AS Kd_Bidang, @Kd_Unit AS Kd_Unit, @Kd_Sub AS Kd_Sub, 
                @Kd_UPB AS Kd_UPB, E.Nm_Bidang, D.Nm_Unit, C.Nm_sub_Unit, B.Nm_UPB			
	 FROM Ta_UPB A INNER JOIN
              Ref_UPB B ON A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
	      Ref_Sub_Unit C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub INNER JOIN
	      Ref_Unit D ON C.Kd_Bidang = D.Kd_Bidang AND C.Kd_Unit = D.Kd_Unit INNER JOIN
	      Ref_Bidang E ON D.Kd_Bidang = E.Kd_Bidang INNER JOIN
	      (
	       SELECT TOP 1 Tahun, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
	       FROM Ta_UPB A
	       WHERE (A.Tahun = @Tahun) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	       ORDER BY Tahun, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
	       ) F ON A.Tahun = F.Tahun AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB
	 ) B,
         (
	  SELECT A.Nm_Kab_Kota
	  FROM Ref_Kab_Kota A
	  WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
	 ) C

end


-------------------------------------

IF @Kd_KIB = 'E' 
BEGIN


	INSERT INTO @tmpsusut
	SELECT	Tahun, IDPemda, Harga, Nilai_Susut1, Nilai_Susut2, Akum_Susut, Nilai_Sisa, Sisa_Umur, Jndt--, Kawal 
	FROM	Ta_SusutE A WHERE Tahun = @Tahun and Jndt = 0

	INSERT INTO @tmpKIB
	SELECT IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 
		Kd_Aset8 AS Kd_Aset, Kd_Aset80 AS Kd_Aset0, Kd_Aset81 AS Kd_Aset1, Kd_Aset82 AS Kd_Aset2, Kd_Aset83 AS Kd_Aset3, Kd_Aset84 AS Kd_Aset4, Kd_Aset85 AS Kd_Aset5, No_Reg8 AS No_Register
	FROM TA_KIB_E
--
	INSERT INTO @tmpnrc
	SELECT A.IDPEMDA, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Harga AS Harganrc, 0 as HargaSusut FROM 
			(
			SELECT A.IDPEMDA,A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, 
				A.Harga , A.Masa_Manfaat AS Masa_ManfaatA, '' AS Tgl_DokumenA, A.Tgl_Perolehan AS Tgl_PerolehanA, A.Tgl_Pembukuan AS Tgl_PembukuanA, A.Kondisi AS KondisiA
				FROM fn_Kartu108_BrgE1(@Tahun, @D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A --LEFT OUTER JOIN
				WHERE A.Kd_Prov = @Kd_Prov AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND 
              			A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Bidang <> 22 AND A.Kd_KA = 1 AND (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) 
	      			AND (A.Tahun = @Tahun)
					) A 

	INSERT INTO @tmpnrc
	SELECT A.IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, 0 AS Harganrc, A.Harga as HargaSusut FROM 
			@tmpsusut A INNER JOIN @tmpKIB B ON A.IDPEMDA = B.IDPEMDA 
			WHERE (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB)	



	SELECT B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, 
	RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_UPB), 2) AS KD_UPB_GAB, 
	CONVERT(varchar, A.Kd_ASET) + '.' + CONVERT(varchar, A.Kd_ASET0) + '.' + CONVERT(varchar, A.Kd_ASET1) + '.' + CONVERT(varchar, A.Kd_ASET2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_ASET3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_ASET4), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_ASET5), 2) AS Kd_Gab_5,
	C.Nm_Kab_Kota, B.Nm_Bidang, B.Nm_Unit, B.Nm_Sub_Unit, B.Nm_UPB, A.IDPEMDA, A.No_register, A.Nm_Aset5, A.TanpaKIBHapus, A.Bedakondisi, A.BedaHargadgnRwyt, A.TglBukuTglSKHapus, A.RBJadiB, A.HargaNrc as PerolehanNeraca, A.HargaSusut as PerolehanSusut 

	FROM 
	(	
	SELECT A.IDPEMDA, B.IDPEMDA AS 'TanpaKIBHapus', C.IDPEMDA AS 'Bedakondisi', D.IDPEMDA AS 'BedaHargadgnRwyt', E.IDPEMDA AS 'TglBukuTglSKHapus', F.IDPEMDA AS 'RBJadiB', Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, X.Nm_Aset5, No_Register, Harganrc, HargaSusut 
	FROM (
	SELECT Max(IDPEMDA)AS IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register, SUM(Harganrc) AS Harganrc, SUM(HargaSusut) AS HargaSusut 
	FROM @tmpnrc 
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, No_Register
	having (SUM(Harganrc) - SUM(HargaSusut)) <> 0 
		) A 
	INNER JOIN REF_REK5_108 X ON A.Kd_Aset = X.Kd_Aset AND A.Kd_Aset0 = X.Kd_Aset0 AND A.Kd_Aset1 = X.Kd_Aset1 AND A.Kd_Aset2 = X.Kd_Aset2 AND A.Kd_Aset3 = X.Kd_Aset3 AND A.Kd_Aset4 = X.Kd_Aset4 AND A.Kd_Aset5 = X.Kd_Aset5 

	left outer join -- KD_HAPUS=1 TAPI TIDAK ADA DI TA_KIBXHAPUS
	(
	select A.IDPEMDA from Ta_KIB_E A left outer join Ta_KIBEhapus B on A.IDPEMDA = B.IDPEMDA where A.kd_hapus=1 and A.Kd_KA=1 
	and b.IDPEMDA is null 
	) B ON A.IDPEMDA = B.IDPEMDA

	left outer join -- BUKAN RIWAYAT UBAH KONDISI TAPI KONDISI DI RIWAYATNYA <> INDUK
	(
	select A.IDPEMDA from Ta_KIBER A inner join Ta_KIB_E B on A.IDPEMDA = B.IDPEMDA
	where A.kondisi <> B.kondisi and A.Kd_Riwayat <> 1 AND (A.kondisi = 3 OR B.kondisi = 3)
	) C ON A.IDPEMDA = C.IDPEMDA

	left outer join -- harga kib<>riwayat pada kode selain kapitalisasi, penghapusan sebagian, dan koreksi nilai (2,7,21)
	(
	select A.IDPEMDA from Ta_KIBER A inner join Ta_KIB_E B on A.IDPEMDA = B.IDPEMDA
	where A.HARGA <> B.HARGA AND (NOT A.kd_riwayat IN (2,7,21)) 
	AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	) D ON A.IDPEMDA = D.IDPEMDA

	left outer join -- Tgl_Pembukuan>Tgl_SKHapus
	(
	select A.IDPEMDA FROM Ta_KIB_E A left outer join Ta_KIBEhapus B on A.IDPEMDA = B.IDPEMDA where a.kd_hapus=1 and a.kd_ka=1 and a.kondisi<3
	and A.Tgl_Pembukuan > B.Tgl_SK
	AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	) E ON A.IDPEMDA = E.IDPEMDA

	left outer join -- UBAH KONDISI BEBERAPA KALI
	(
	select IDPEMDA FROM Ta_KIBER  where Kd_Riwayat in(1,2) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
	group by IDPEMDA, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB having count(Kd_Riwayat) > 1 and sum(Kd_Riwayat) > count(Kd_Riwayat)
	) F ON A.IDPEMDA = F.IDPEMDA
	) A , 
        (		
         SELECT @Kd_Prov AS Kd_Prov, @Kd_Kab_Kota AS Kd_Kab_Kota, @Kd_Bidang AS Kd_Bidang, @Kd_Unit AS Kd_Unit, @Kd_Sub AS Kd_Sub, 
                @Kd_UPB AS Kd_UPB, E.Nm_Bidang, D.Nm_Unit, C.Nm_sub_Unit, B.Nm_UPB			
	 FROM Ta_UPB A INNER JOIN
              Ref_UPB B ON A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
	      Ref_Sub_Unit C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub INNER JOIN
	      Ref_Unit D ON C.Kd_Bidang = D.Kd_Bidang AND C.Kd_Unit = D.Kd_Unit INNER JOIN
	      Ref_Bidang E ON D.Kd_Bidang = E.Kd_Bidang INNER JOIN
	      (
	       SELECT TOP 1 Tahun, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
	       FROM Ta_UPB A
	       WHERE (A.Tahun = @Tahun) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	       ORDER BY Tahun, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
	       ) F ON A.Tahun = F.Tahun AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB
	 ) B,
         (
	  SELECT A.Nm_Kab_Kota
	  FROM Ref_Kab_Kota A
	  WHERE A.Kd_Prov = @Kd_Prov AND A.Kd_Kab_Kota = @Kd_Kab_Kota
	 ) C

end







GO
