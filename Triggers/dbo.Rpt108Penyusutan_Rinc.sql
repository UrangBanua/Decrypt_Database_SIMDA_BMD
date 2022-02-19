USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[Rpt108Penyusutan_Rinc] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), 
	@Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset varchar(2), @Kd_Aset0 varchar(2), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3),	@D1 datetime, @Kd_KIB varchar(1)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
		@Kd_Aset varchar(2), @Kd_Aset0 varchar(2), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @D1 datetime, @Kd_KIB varchar(1)
		
SET @Tahun = '2019'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Kd_Aset = '1'
SET @Kd_Aset0 = '3'
SET @Kd_Aset1 = '3'
SET @Kd_Aset2 = ''
SET @Kd_Aset3 = ''
SET @Kd_Aset4 = ''
SET @D1 = '20191231'
SET @Kd_KIB = 'C'
--*/

IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
IF ISNULL(@Kd_Aset, '') = '' SET @Kd_Aset = '%'
IF ISNULL(@Kd_Aset0, '') = '' SET @Kd_Aset0 = '%'
IF ISNULL(@Kd_Aset1, '') = '' SET @Kd_Aset1 = '%'
IF ISNULL(@Kd_Aset2, '') = '' SET @Kd_Aset2 = '%'
IF ISNULL(@Kd_Aset3, '') = '' SET @Kd_Aset3 = '%'
IF ISNULL(@Kd_Aset4, '') = '' SET @Kd_Aset4 = '%'

DECLARE @JLap Tinyint SET @JLap = 1


			
IF @Kd_KIB = 'B' 
BEGIN
	SELECT  B.Jndt, A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB, A.Kd_Aset_Gab, 
		D.Kd_Aset0, D.Nm_Aset0, D.Kd_Aset1, D.Nm_Aset1, D.Kd_Aset2, D.Nm_Aset2, D.Kd_Aset3, D.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, D.Kd_Aset5, D.Nm_Aset5, A.No_Register, MONTH (A.Tgl_Perolehan) AS Bulan1, 
		YEAR (A.Tgl_Perolehan) AS Tahun, 
       		YEAR(@D1) AS Tahun_Sblm, 
		B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_susut, B.Nilai_Sisa, B.Sisa_Umur,
       		CONVERT(int, B.Sisa_Umur / 12) AS Thn, B.Sisa_Umur % 12 AS Bln,
       		B.Harga AS Nilai_Perolehan, 
                (ISNULL(B.Akum_Susut,0)) - (ISNULL(B.Nilai_Susut1,0)) - (ISNULL(B.Nilai_Susut2,0)) AS AKP_Awal, 
       		(ISNULL(B.Nilai_Susut1,0)) + (ISNULL(B.Nilai_Susut2,0))AS Penyusutan, ISNULL(B.Akum_Susut,0) AS AKP_Akhir, ISNULL(B.Nilai_Sisa,0) AS Nilai_Buku
	FROM (
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	       		CONVERT(varchar, A.Kd_Aset)+'.'+CONVERT(varchar, A.Kd_Aset0)+'.'+CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4)+'.'+CONVERT(varchar, A.Kd_Aset5)AS Kd_Aset_Gab,     
			A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Kondisi, A.Kd_KA
		FROM (
			SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, 
				A.Kd_Aset83 AS KD_ASET3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, 	       		
				A.No_Reg8 AS No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Kondisi, A.Kd_KA
			FROM   Ta_KIB_B A LEFT OUTER JOIN Ta_KIBBR B ON A.IDPemda = B.IDPemda
			WHERE (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND A.Tgl_Perolehan <= @D1 AND IsNull(B.Kd_Riwayat,0) <> 3
			UNION ALL
			SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, 
				A.Kd_Aset83 AS KD_ASET3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, 		       		
				A.No_Reg8 AS No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan,A.Harga, A.Kondisi, A.Kd_KA
			FROM Ta_KIB_B A LEFT OUTER JOIN Ta_KIBBR B ON A.IDPemda = B.IDPemda
			WHERE (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND B.Tgl_Dokumen <= @D1 AND IsNull(B.Kd_Riwayat,0) = 3
			UNION ALL
        		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, 
				A.Kd_Aset83 AS KD_ASET3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, 	     		
				B.No_Reg8 AS No_Register,  
				A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Kondisi, A.Kd_KA
        		FROM Ta_KIBBR A INNER JOIN TA_KIB_B B ON A.IDPEMDA = B.IDPEMDA
        		WHERE A.Kd_Riwayat = 3 AND A.Tgl_dokumen > @D1 AND A.Tgl_Pembukuan <= @D1) A		
		) A LEFT OUTER JOIN
		(
		SELECT A.Tahun, A.IDPemda, A.Harga, ISNULL(A.Nilai_Susut1,0)AS Nilai_Susut1, ISNULL(A.Nilai_Susut2,0)AS Nilai_Susut2, A.Akum_Susut, A.Nilai_Sisa, A.Sisa_Umur, A.Jndt
		FROM Ta_SusutB A LEFT OUTER JOIN 
                            (SELECT IDPemda FROM Ta_KIBBR
                             WHERE Kd_Riwayat = 1 AND YEAR(Tgl_Dokumen) = @Tahun
                            ) B ON A.IDPemda = B.IDPemda      
		WHERE NOT(A.Jndt = 1 AND A.Nilai_Susut1 = 0 AND B.IDPemda IS NULL)
		) B  ON A.IDPemda = B.IDPemda LEFT OUTER JOIN
		(
		SELECT  A.Kd_Prov, A.Nm_Provinsi, B.Kd_Kab_Kota, B.Nm_Kab_Kota, D.Kd_Bidang, C.Nm_Bidang, D.Kd_Unit, D.Nm_Unit, E.Kd_Sub, E.Nm_Sub_Unit, F.Kd_UPB, F.Nm_UPB
		FROM    Ref_Unit D INNER JOIN
                	Ref_Bidang C ON D.Kd_Bidang = C.Kd_Bidang INNER JOIN
                	Ref_Sub_Unit E ON D.Kd_Prov = E.Kd_Prov AND D.Kd_Kab_Kota = E.Kd_Kab_Kota AND D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
                	Ref_UPB F ON E.Kd_Prov = F.Kd_Prov AND E.Kd_Kab_Kota = F.Kd_Kab_Kota AND E.Kd_Bidang = F.Kd_Bidang AND E.Kd_Unit = F.Kd_Unit AND 
                	E.Kd_Sub = F.Kd_Sub INNER JOIN
                	Ref_Provinsi A INNER JOIN
                	Ref_Kab_Kota B ON A.Kd_Prov = B.Kd_Prov ON D.Kd_Prov = B.Kd_Prov AND D.Kd_Kab_Kota = B.Kd_Kab_Kota
		)C ON   A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND 
                	A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB LEFT OUTER JOIN
		(
		SELECT  G.Kd_Aset, G.Kd_Aset0, G.Nm_Aset0,A.Kd_Aset1, A.Nm_Aset1, B.Kd_Aset2, B.Nm_Aset2, C.Kd_Aset3, C.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, E.Kd_Aset5, E.Nm_Aset5
		FROM    Ref_Rek0_108 G INNER JOIN
			Ref_Rek1_108 A ON A.Kd_Aset = G.Kd_Aset AND A.Kd_Aset0 = G.Kd_Aset0 INNER JOIN
                	Ref_Rek2_108 B ON A.Kd_Aset = B.Kd_Aset AND A.Kd_Aset0 = B.Kd_Aset0 AND A.Kd_Aset1 = B.Kd_Aset1 INNER JOIN
                	Ref_Rek3_108 C ON B.Kd_Aset = C.Kd_Aset AND B.Kd_Aset0 = C.Kd_Aset0 AND B.Kd_Aset1 = C.Kd_Aset1 AND B.Kd_Aset2 = C.Kd_Aset2 INNER JOIN
                	Ref_Rek4_108 D ON D.Kd_Aset = C.Kd_Aset AND D.Kd_Aset0 = C.Kd_Aset0 AND C.Kd_Aset1 = D.Kd_Aset1 AND C.Kd_Aset2 = D.Kd_Aset2 AND C.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
                	Ref_Rek5_108 E ON D.Kd_Aset = E.Kd_Aset AND D.Kd_Aset0 = E.Kd_Aset0 AND D.Kd_Aset1 = E.Kd_Aset1 AND D.Kd_Aset2 = E.Kd_Aset2 AND D.Kd_Aset3 = E.Kd_Aset3 AND D.Kd_Aset4 = E.Kd_Aset4
		) D ON  A.Kd_Aset = D.Kd_Aset AND A.Kd_Aset0 = D.Kd_Aset0 AND A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND 
                	A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 
	WHERE B.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
      	A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND 
	A.Kd_Aset LIKE @Kd_Aset AND A.Kd_Aset0 LIKE @Kd_Aset0 AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND 
      	A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Tgl_Pembukuan <=@D1 AND A.KD_KA <> 0
   GROUP BY  B.Jndt, A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB, A.Kd_Aset_Gab, 
		D.Kd_Aset0, D.Nm_Aset0, D.Kd_Aset1, D.Nm_Aset1, D.Kd_Aset2, D.Nm_Aset2, D.Kd_Aset3, D.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, D.Kd_Aset5, D.Nm_Aset5, A.No_Register, B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_susut, 
		A.Tgl_Perolehan, B.Nilai_Sisa, B.Sisa_Umur,B.Harga
	ORDER BY B.Jndt, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		D.Kd_Aset0, D.Kd_Aset1, D.Kd_Aset2, D.Kd_Aset3, D.Kd_Aset4, D.Kd_Aset5, A.No_Register

END

IF @Kd_KIB = 'C' 
BEGIN
	SELECT  B.Jndt, A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB, A.Kd_Aset_Gab, 
		D.Kd_Aset0, D.Nm_Aset0, D.Kd_Aset1, D.Nm_Aset1, D.Kd_Aset2, D.Nm_Aset2, D.Kd_Aset3, D.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, D.Kd_Aset5, D.Nm_Aset5, A.No_Register, MONTH (A.Tgl_Perolehan) AS Bulan1, 
		YEAR (A.Tgl_Perolehan) AS Tahun, 
       		YEAR(@D1) AS Tahun_Sblm, 
		B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_susut, B.Nilai_Sisa, B.Sisa_Umur,
       		CONVERT(int, B.Sisa_Umur / 12) AS Thn, B.Sisa_Umur % 12 AS Bln,
       		B.Harga AS Nilai_Perolehan, 
                (ISNULL(B.Akum_Susut,0)) - (ISNULL(B.Nilai_Susut1,0)) - (ISNULL(B.Nilai_Susut2,0)) AS AKP_Awal, 
       		(ISNULL(B.Nilai_Susut1,0)) + (ISNULL(B.Nilai_Susut2,0))AS Penyusutan, ISNULL(B.Akum_Susut,0) AS AKP_Akhir, ISNULL(B.Nilai_Sisa,0) AS Nilai_Buku
	FROM (
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	       		CONVERT(varchar, A.Kd_Aset)+'.'+CONVERT(varchar, A.Kd_Aset0)+'.'+CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4)+'.'+CONVERT(varchar, A.Kd_Aset5)AS Kd_Aset_Gab,     
			A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Kondisi, A.Kd_KA
		FROM (
			SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, 
				A.Kd_Aset83 AS KD_ASET3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, 	       		
				A.No_Reg8 AS No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Kondisi, A.Kd_KA
			FROM   Ta_KIB_C A LEFT OUTER JOIN Ta_KIBCR B ON A.IDPemda = B.IDPemda
			WHERE (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND A.Tgl_Perolehan <= @D1 AND IsNull(B.Kd_Riwayat,0) <> 3
			UNION ALL
			SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, 
				A.Kd_Aset83 AS KD_ASET3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, 		       		
				A.No_Reg8 AS No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan,A.Harga, A.Kondisi, A.Kd_KA
			FROM Ta_KIB_C A LEFT OUTER JOIN Ta_KIBCR B ON A.IDPemda = B.IDPemda
			WHERE (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND B.Tgl_Dokumen <= @D1 AND IsNull(B.Kd_Riwayat,0) = 3
			UNION ALL
        		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, 
				A.Kd_Aset83 AS KD_ASET3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, 	     		
				B.No_Reg8 AS No_Register,  
				A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Kondisi, A.Kd_KA
        		FROM Ta_KIBCR A INNER JOIN TA_KIB_C B ON A.IDPEMDA = B.IDPEMDA
        		WHERE A.Kd_Riwayat = 3 AND A.Tgl_dokumen > @D1 AND A.Tgl_Pembukuan <= @D1) A	
		) A INNER JOIN
		(
		SELECT A.Tahun, A.IDPemda, A.Harga, ISNULL(A.Nilai_Susut1,0)AS Nilai_Susut1, ISNULL(A.Nilai_Susut2,0)AS Nilai_Susut2, A.Akum_Susut, A.Nilai_Sisa, A.Sisa_Umur, A.Jndt
		FROM Ta_SusutC A LEFT OUTER JOIN 
                            (SELECT IDPemda FROM Ta_KIBCR
                             WHERE Kd_Riwayat = 1 AND YEAR(Tgl_Dokumen) = @Tahun
                            ) B ON A.IDPemda = B.IDPemda      
		WHERE NOT(A.Jndt = 1 AND A.Nilai_Susut1 = 0 AND B.IDPemda IS NULL)
		) B ON A.IDPemda = B.IDPemda LEFT OUTER JOIN
		(
		SELECT  A.Kd_Prov, A.Nm_Provinsi, B.Kd_Kab_Kota, B.Nm_Kab_Kota, D.Kd_Bidang, C.Nm_Bidang, D.Kd_Unit, D.Nm_Unit, E.Kd_Sub, E.Nm_Sub_Unit, F.Kd_UPB, F.Nm_UPB
		FROM    Ref_Unit D INNER JOIN
                	Ref_Bidang C ON D.Kd_Bidang = C.Kd_Bidang INNER JOIN
                	Ref_Sub_Unit E ON D.Kd_Prov = E.Kd_Prov AND D.Kd_Kab_Kota = E.Kd_Kab_Kota AND D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
                	Ref_UPB F ON E.Kd_Prov = F.Kd_Prov AND E.Kd_Kab_Kota = F.Kd_Kab_Kota AND E.Kd_Bidang = F.Kd_Bidang AND E.Kd_Unit = F.Kd_Unit AND 
                	E.Kd_Sub = F.Kd_Sub INNER JOIN
                	Ref_Provinsi A INNER JOIN
                	Ref_Kab_Kota B ON A.Kd_Prov = B.Kd_Prov ON D.Kd_Prov = B.Kd_Prov AND D.Kd_Kab_Kota = B.Kd_Kab_Kota
		)C ON   A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND 
                	A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB LEFT OUTER JOIN
		(
		SELECT  G.Kd_Aset, G.Kd_Aset0, G.Nm_Aset0,A.Kd_Aset1, A.Nm_Aset1, B.Kd_Aset2, B.Nm_Aset2, C.Kd_Aset3, C.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, E.Kd_Aset5, E.Nm_Aset5
		FROM    Ref_Rek0_108 G INNER JOIN
			Ref_Rek1_108 A ON A.Kd_Aset = G.Kd_Aset AND A.Kd_Aset0 = G.Kd_Aset0 INNER JOIN
                	Ref_Rek2_108 B ON A.Kd_Aset = B.Kd_Aset AND A.Kd_Aset0 = B.Kd_Aset0 AND A.Kd_Aset1 = B.Kd_Aset1 INNER JOIN
                	Ref_Rek3_108 C ON B.Kd_Aset = C.Kd_Aset AND B.Kd_Aset0 = C.Kd_Aset0 AND B.Kd_Aset1 = C.Kd_Aset1 AND B.Kd_Aset2 = C.Kd_Aset2 INNER JOIN
                	Ref_Rek4_108 D ON D.Kd_Aset = C.Kd_Aset AND D.Kd_Aset0 = C.Kd_Aset0 AND C.Kd_Aset1 = D.Kd_Aset1 AND C.Kd_Aset2 = D.Kd_Aset2 AND C.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
                	Ref_Rek5_108 E ON D.Kd_Aset = E.Kd_Aset AND D.Kd_Aset0 = E.Kd_Aset0 AND D.Kd_Aset1 = E.Kd_Aset1 AND D.Kd_Aset2 = E.Kd_Aset2 AND D.Kd_Aset3 = E.Kd_Aset3 AND D.Kd_Aset4 = E.Kd_Aset4
		) D ON  A.Kd_Aset = D.Kd_Aset AND A.Kd_Aset0 = D.Kd_Aset0 AND A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND 
                	A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 
	WHERE B.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
      	A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND 
	A.Kd_Aset LIKE @Kd_Aset AND A.Kd_Aset0 LIKE @Kd_Aset0 AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND 
      	A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Tgl_Pembukuan <=@D1 AND A.KD_KA <> 0
   GROUP BY  B.Jndt, A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB, A.Kd_Aset_Gab, 
		D.Kd_Aset0, D.Nm_Aset0, D.Kd_Aset1, D.Nm_Aset1, D.Kd_Aset2, D.Nm_Aset2, D.Kd_Aset3, D.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, D.Kd_Aset5, D.Nm_Aset5, A.No_Register, B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_susut, 
		A.Tgl_Perolehan, B.Nilai_Sisa, B.Sisa_Umur,B.Harga
	ORDER BY B.Jndt, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		D.Kd_Aset0, D.Kd_Aset1, D.Kd_Aset2, D.Kd_Aset3, D.Kd_Aset4, D.Kd_Aset5, A.No_Register

END

IF @Kd_KIB = 'D' 
BEGIN
	SELECT  B.Jndt, A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB, A.Kd_Aset_Gab, 
		D.Kd_Aset0, D.Nm_Aset0, D.Kd_Aset1, D.Nm_Aset1, D.Kd_Aset2, D.Nm_Aset2, D.Kd_Aset3, D.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, D.Kd_Aset5, D.Nm_Aset5, A.No_Register, MONTH (A.Tgl_Perolehan) AS Bulan1, 
		YEAR (A.Tgl_Perolehan) AS Tahun, 
       		YEAR(@D1) AS Tahun_Sblm, 
		B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_susut, B.Nilai_Sisa, B.Sisa_Umur,
       		CONVERT(int, B.Sisa_Umur / 12) AS Thn, B.Sisa_Umur % 12 AS Bln,
       		B.Harga AS Nilai_Perolehan, 
                (ISNULL(B.Akum_Susut,0)) - (ISNULL(B.Nilai_Susut1,0)) - (ISNULL(B.Nilai_Susut2,0)) AS AKP_Awal, 
       		(ISNULL(B.Nilai_Susut1,0)) + (ISNULL(B.Nilai_Susut2,0))AS Penyusutan, ISNULL(B.Akum_Susut,0) AS AKP_Akhir, ISNULL(B.Nilai_Sisa,0) AS Nilai_Buku
	FROM (
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	       		CONVERT(varchar, A.Kd_Aset)+'.'+CONVERT(varchar, A.Kd_Aset0)+'.'+CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4)+'.'+CONVERT(varchar, A.Kd_Aset5)AS Kd_Aset_Gab,     
			A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Kondisi, A.Kd_KA
		FROM (
			SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, 
				A.Kd_Aset83 AS KD_ASET3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, 	       		
				A.No_Reg8 AS No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Kondisi, A.Kd_KA
			FROM   Ta_KIB_D A LEFT OUTER JOIN Ta_KIBDR B ON A.IDPemda = B.IDPemda
			WHERE (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND A.Tgl_Perolehan <= @D1 AND IsNull(B.Kd_Riwayat,0) <> 3
			UNION ALL
			SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, 
				A.Kd_Aset83 AS KD_ASET3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, 		       		
				A.No_Reg8 AS No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan,A.Harga, A.Kondisi, A.Kd_KA
			FROM Ta_KIB_D A LEFT OUTER JOIN Ta_KIBDR B ON A.IDPemda = B.IDPemda
			WHERE (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND B.Tgl_Dokumen <= @D1 AND IsNull(B.Kd_Riwayat,0) = 3
			UNION ALL
        		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, 
				A.Kd_Aset83 AS KD_ASET3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, 	 		
				B.No_Reg8 AS No_Register,  
				A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Kondisi, A.Kd_KA
        		FROM Ta_KIBDR A INNER JOIN TA_KIB_D B ON A.IDPEMDA = B.IDPEMDA
        		WHERE A.Kd_Riwayat = 3 AND A.Tgl_dokumen > @D1 AND A.Tgl_Pembukuan <= @D1) A	
		) A INNER JOIN
		(
		SELECT A.Tahun, A.IDPemda, A.Harga, ISNULL(A.Nilai_Susut1,0)AS Nilai_Susut1, ISNULL(A.Nilai_Susut2,0)AS Nilai_Susut2, A.Akum_Susut, A.Nilai_Sisa, A.Sisa_Umur, A.Jndt
		FROM Ta_SusutD A LEFT OUTER JOIN 
                            (SELECT IDPemda FROM Ta_KIBDR
                             WHERE Kd_Riwayat = 1 AND YEAR(Tgl_Dokumen) = @Tahun
                            ) B ON A.IDPemda = B.IDPemda      
		WHERE NOT(A.Jndt = 1 AND A.Nilai_Susut1 = 0 AND B.IDPemda IS NULL)
		) B ON A.IDPemda = B.IDPemda LEFT OUTER JOIN
		(
		SELECT  A.Kd_Prov, A.Nm_Provinsi, B.Kd_Kab_Kota, B.Nm_Kab_Kota, D.Kd_Bidang, C.Nm_Bidang, D.Kd_Unit, D.Nm_Unit, E.Kd_Sub, E.Nm_Sub_Unit, F.Kd_UPB, F.Nm_UPB
		FROM    Ref_Unit D INNER JOIN
                	Ref_Bidang C ON D.Kd_Bidang = C.Kd_Bidang INNER JOIN
                	Ref_Sub_Unit E ON D.Kd_Prov = E.Kd_Prov AND D.Kd_Kab_Kota = E.Kd_Kab_Kota AND D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
                	Ref_UPB F ON E.Kd_Prov = F.Kd_Prov AND E.Kd_Kab_Kota = F.Kd_Kab_Kota AND E.Kd_Bidang = F.Kd_Bidang AND E.Kd_Unit = F.Kd_Unit AND 
                	E.Kd_Sub = F.Kd_Sub INNER JOIN
                	Ref_Provinsi A INNER JOIN
                	Ref_Kab_Kota B ON A.Kd_Prov = B.Kd_Prov ON D.Kd_Prov = B.Kd_Prov AND D.Kd_Kab_Kota = B.Kd_Kab_Kota
		)C ON   A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND 
                	A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB LEFT OUTER JOIN
		(
		SELECT  G.Kd_Aset, G.Kd_Aset0, G.Nm_Aset0,A.Kd_Aset1, A.Nm_Aset1, B.Kd_Aset2, B.Nm_Aset2, C.Kd_Aset3, C.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, E.Kd_Aset5, E.Nm_Aset5
		FROM    Ref_Rek0_108 G INNER JOIN
			Ref_Rek1_108 A ON A.Kd_Aset = G.Kd_Aset AND A.Kd_Aset0 = G.Kd_Aset0 INNER JOIN
                	Ref_Rek2_108 B ON A.Kd_Aset = B.Kd_Aset AND A.Kd_Aset0 = B.Kd_Aset0 AND A.Kd_Aset1 = B.Kd_Aset1 INNER JOIN
                	Ref_Rek3_108 C ON B.Kd_Aset = C.Kd_Aset AND B.Kd_Aset0 = C.Kd_Aset0 AND B.Kd_Aset1 = C.Kd_Aset1 AND B.Kd_Aset2 = C.Kd_Aset2 INNER JOIN
                	Ref_Rek4_108 D ON D.Kd_Aset = C.Kd_Aset AND D.Kd_Aset0 = C.Kd_Aset0 AND C.Kd_Aset1 = D.Kd_Aset1 AND C.Kd_Aset2 = D.Kd_Aset2 AND C.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
                	Ref_Rek5_108 E ON D.Kd_Aset = E.Kd_Aset AND D.Kd_Aset0 = E.Kd_Aset0 AND D.Kd_Aset1 = E.Kd_Aset1 AND D.Kd_Aset2 = E.Kd_Aset2 AND D.Kd_Aset3 = E.Kd_Aset3 AND D.Kd_Aset4 = E.Kd_Aset4
		) D ON  A.Kd_Aset = D.Kd_Aset AND A.Kd_Aset0 = D.Kd_Aset0 AND A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND 
                	A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 
	WHERE B.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
      	A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND 
	A.Kd_Aset LIKE @Kd_Aset AND A.Kd_Aset0 LIKE @Kd_Aset0 AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND 
      	A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Tgl_Pembukuan <=@D1 AND A.KD_KA <> 0
   GROUP BY  B.Jndt, A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB, A.Kd_Aset_Gab, 
		D.Kd_Aset0, D.Nm_Aset0, D.Kd_Aset1, D.Nm_Aset1, D.Kd_Aset2, D.Nm_Aset2, D.Kd_Aset3, D.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, D.Kd_Aset5, D.Nm_Aset5, A.No_Register, B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_susut, 
		A.Tgl_Perolehan, B.Nilai_Sisa, B.Sisa_Umur,B.Harga
	ORDER BY B.Jndt, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		D.Kd_Aset0, D.Kd_Aset1, D.Kd_Aset2, D.Kd_Aset3, D.Kd_Aset4, D.Kd_Aset5, A.No_Register

END

IF @Kd_KIB = 'E' 
BEGIN
	SELECT  B.Jndt, A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB, A.Kd_Aset_Gab, 
		D.Kd_Aset0, D.Nm_Aset0, D.Kd_Aset1, D.Nm_Aset1, D.Kd_Aset2, D.Nm_Aset2, D.Kd_Aset3, D.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, D.Kd_Aset5, D.Nm_Aset5, A.No_Register, MONTH (A.Tgl_Perolehan) AS Bulan1, 
		YEAR (A.Tgl_Perolehan) AS Tahun, 
       		YEAR(@D1) AS Tahun_Sblm, 
		B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_susut, B.Nilai_Sisa, B.Sisa_Umur,
       		CONVERT(int, B.Sisa_Umur / 12) AS Thn, B.Sisa_Umur % 12 AS Bln,
       		B.Harga AS Nilai_Perolehan, 
                (ISNULL(B.Akum_Susut,0)) - (ISNULL(B.Nilai_Susut1,0)) - (ISNULL(B.Nilai_Susut2,0)) AS AKP_Awal, 
       		(ISNULL(B.Nilai_Susut1,0)) + (ISNULL(B.Nilai_Susut2,0))AS Penyusutan, ISNULL(B.Akum_Susut,0) AS AKP_Akhir, ISNULL(B.Nilai_Sisa,0) AS Nilai_Buku
	FROM (
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	       		CONVERT(varchar, A.Kd_Aset)+'.'+CONVERT(varchar, A.Kd_Aset0)+'.'+CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4)+'.'+CONVERT(varchar, A.Kd_Aset5)AS Kd_Aset_Gab,     
			A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Kondisi, A.Kd_KA
		FROM (
			SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, 
				A.Kd_Aset83 AS KD_ASET3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, 	       		
				A.No_Reg8 AS No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Kondisi, A.Kd_KA
			FROM   Ta_KIB_E A LEFT OUTER JOIN Ta_KIBER B ON A.IDPemda = B.IDPemda
			WHERE (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND A.Tgl_Perolehan <= @D1 AND IsNull(B.Kd_Riwayat,0) <> 3
			UNION ALL
			SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, 
				A.Kd_Aset83 AS KD_ASET3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, 		       		
				A.No_Reg8 AS No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan,A.Harga, A.Kondisi, A.Kd_KA
			FROM Ta_KIB_E A LEFT OUTER JOIN Ta_KIBER B ON A.IDPemda = B.IDPemda
			WHERE (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND B.Tgl_Dokumen <= @D1 AND IsNull(B.Kd_Riwayat,0) = 3
			UNION ALL
        		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
				A.Kd_Aset8 AS Kd_Aset, A.Kd_Aset80 AS Kd_Aset0, A.Kd_Aset81 AS Kd_Aset1, A.Kd_Aset82 AS Kd_Aset2, 
				A.Kd_Aset83 AS KD_ASET3, A.Kd_Aset84 AS Kd_Aset4, A.Kd_Aset85 AS Kd_Aset5, 	     		
				B.No_Reg8 AS No_Register,  
				A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Kondisi, A.Kd_KA
        		FROM Ta_KIBER A INNER JOIN TA_KIB_E B ON A.IDPEMDA = B.IDPEMDA
        		WHERE A.Kd_Riwayat = 3 AND A.Tgl_dokumen > @D1 AND A.Tgl_Pembukuan <= @D1) A	
		) A INNER JOIN
		(
		SELECT A.Tahun, A.IDPemda, A.Harga, ISNULL(A.Nilai_Susut1,0)AS Nilai_Susut1, ISNULL(A.Nilai_Susut2,0)AS Nilai_Susut2, A.Akum_Susut, A.Nilai_Sisa, A.Sisa_Umur, A.Jndt
		FROM Ta_SusutE A LEFT OUTER JOIN 
                            (SELECT IDPemda FROM Ta_KIBER
                             WHERE Kd_Riwayat = 1 AND YEAR(Tgl_Dokumen) = @Tahun
                            ) B ON A.IDPemda = B.IDPemda      
		WHERE NOT(A.Jndt = 1 AND A.Nilai_Susut1 = 0 AND B.IDPemda IS NULL)
		) B ON A.IDPemda = B.IDPemda LEFT OUTER JOIN
		(
		SELECT  A.Kd_Prov, A.Nm_Provinsi, B.Kd_Kab_Kota, B.Nm_Kab_Kota, D.Kd_Bidang, C.Nm_Bidang, D.Kd_Unit, D.Nm_Unit, E.Kd_Sub, E.Nm_Sub_Unit, F.Kd_UPB, F.Nm_UPB
		FROM    Ref_Unit D INNER JOIN
                	Ref_Bidang C ON D.Kd_Bidang = C.Kd_Bidang INNER JOIN
                	Ref_Sub_Unit E ON D.Kd_Prov = E.Kd_Prov AND D.Kd_Kab_Kota = E.Kd_Kab_Kota AND D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
                	Ref_UPB F ON E.Kd_Prov = F.Kd_Prov AND E.Kd_Kab_Kota = F.Kd_Kab_Kota AND E.Kd_Bidang = F.Kd_Bidang AND E.Kd_Unit = F.Kd_Unit AND 
                	E.Kd_Sub = F.Kd_Sub INNER JOIN
                	Ref_Provinsi A INNER JOIN
                	Ref_Kab_Kota B ON A.Kd_Prov = B.Kd_Prov ON D.Kd_Prov = B.Kd_Prov AND D.Kd_Kab_Kota = B.Kd_Kab_Kota
		)C ON   A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND 
                	A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB LEFT OUTER JOIN
		(
		SELECT  G.Kd_Aset, G.Kd_Aset0, G.Nm_Aset0,A.Kd_Aset1, A.Nm_Aset1, B.Kd_Aset2, B.Nm_Aset2, C.Kd_Aset3, C.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, E.Kd_Aset5, E.Nm_Aset5
		FROM    Ref_Rek0_108 G INNER JOIN
			Ref_Rek1_108 A ON A.Kd_Aset = G.Kd_Aset AND A.Kd_Aset0 = G.Kd_Aset0 INNER JOIN
                	Ref_Rek2_108 B ON A.Kd_Aset = B.Kd_Aset AND A.Kd_Aset0 = B.Kd_Aset0 AND A.Kd_Aset1 = B.Kd_Aset1 INNER JOIN
                	Ref_Rek3_108 C ON B.Kd_Aset = C.Kd_Aset AND B.Kd_Aset0 = C.Kd_Aset0 AND B.Kd_Aset1 = C.Kd_Aset1 AND B.Kd_Aset2 = C.Kd_Aset2 INNER JOIN
                	Ref_Rek4_108 D ON D.Kd_Aset = C.Kd_Aset AND D.Kd_Aset0 = C.Kd_Aset0 AND C.Kd_Aset1 = D.Kd_Aset1 AND C.Kd_Aset2 = D.Kd_Aset2 AND C.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
                	Ref_Rek5_108 E ON D.Kd_Aset = E.Kd_Aset AND D.Kd_Aset0 = E.Kd_Aset0 AND D.Kd_Aset1 = E.Kd_Aset1 AND D.Kd_Aset2 = E.Kd_Aset2 AND D.Kd_Aset3 = E.Kd_Aset3 AND D.Kd_Aset4 = E.Kd_Aset4
		) D ON  A.Kd_Aset = D.Kd_Aset AND A.Kd_Aset0 = D.Kd_Aset0 AND A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND 
                	A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 
	WHERE B.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
      	A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND 
	A.Kd_Aset LIKE @Kd_Aset AND A.Kd_Aset0 LIKE @Kd_Aset0 AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND 
      	A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Tgl_Pembukuan <=@D1 AND A.KD_KA <> 0
   GROUP BY  B.Jndt, A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB, A.Kd_Aset_Gab, 
		D.Kd_Aset0, D.Nm_Aset0, D.Kd_Aset1, D.Nm_Aset1, D.Kd_Aset2, D.Nm_Aset2, D.Kd_Aset3, D.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, D.Kd_Aset5, D.Nm_Aset5, A.No_Register, B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_susut, 
		A.Tgl_Perolehan, B.Nilai_Sisa, B.Sisa_Umur,B.Harga
	ORDER BY B.Jndt, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		D.Kd_Aset0, D.Kd_Aset1, D.Kd_Aset2, D.Kd_Aset3, D.Kd_Aset4, D.Kd_Aset5, A.No_Register
END

IF @Kd_KIB = 'L' 
BEGIN
	SELECT  B.Jndt, A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB, A.Kd_Aset_Gab, 
		D.Kd_Aset0, D.Nm_Aset0, D.Kd_Aset1, D.Nm_Aset1, D.Kd_Aset2, D.Nm_Aset2, D.Kd_Aset3, D.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, D.Kd_Aset5, D.Nm_Aset5, A.No_Register, MONTH (A.Tgl_Perolehan) AS Bulan1, 
		YEAR (A.Tgl_Perolehan) AS Tahun, 
       		YEAR(@D1) AS Tahun_Sblm, 
		B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_susut, B.Nilai_Sisa, B.Sisa_Umur,
       		CONVERT(int, B.Sisa_Umur / 12) AS Thn, B.Sisa_Umur % 12 AS Bln,
       		B.Harga AS Nilai_Perolehan, 
                (ISNULL(B.Akum_Susut,0)) - (ISNULL(B.Nilai_Susut1,0)) - (ISNULL(B.Nilai_Susut2,0)) AS AKP_Awal, 
       		(ISNULL(B.Nilai_Susut1,0)) + (ISNULL(B.Nilai_Susut2,0))AS Penyusutan, ISNULL(B.Akum_Susut,0) AS AKP_Akhir, ISNULL(B.Nilai_Sisa,0) AS Nilai_Buku
	FROM (
		SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
	       		CONVERT(varchar, A.Kd_Aset)+'.'+CONVERT(varchar, A.Kd_Aset0)+'.'+CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4)+'.'+CONVERT(varchar, A.Kd_Aset5)AS Kd_Aset_Gab,     
			A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Kondisi, A.Kd_KA
		FROM (
			SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 	       		
				A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Harga, A.Kondisi, A.Kd_KA
			FROM fn_Kartu108_BrgL1(@Tahun, @D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
				LEFT OUTER JOIN Ta_KILER B ON A.IDPemda = B.IDPemda
			WHERE (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND A.Tgl_Perolehan <= @D1 AND IsNull(B.Kd_Riwayat,0) <> 3 AND (A.TAHUN = @Tahun)
			UNION ALL
			SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 	       		
	       			A.No_Register, A.Tgl_Perolehan, A.Tgl_Pembukuan,A.Harga, A.Kondisi, A.Kd_KA
			FROM fn_Kartu108_BrgL1(@Tahun, @D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%','%','%',@JLap)  A 
				LEFT OUTER JOIN Ta_KILER B ON A.IDPemda = B.IDPemda
			WHERE (A.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END) AND B.Tgl_Dokumen <= @D1 AND IsNull(B.Kd_Riwayat,0) = 3 AND (A.TAHUN = @Tahun))A
		) A INNER JOIN
		(
		SELECT A.Tahun, A.IDPemda, A.Harga, ISNULL(A.Nilai_Susut1,0)AS Nilai_Susut1, ISNULL(A.Nilai_Susut2,0)AS Nilai_Susut2, A.Akum_Susut, A.Nilai_Sisa, A.Sisa_Umur, A.Jndt
		FROM Ta_SusutL A LEFT OUTER JOIN 
                            (SELECT IDPemda FROM Ta_KILER
                             WHERE Kd_Riwayat = 1 AND YEAR(Tgl_Dokumen) = @Tahun
                            ) B ON A.IDPemda = B.IDPemda      
		WHERE NOT(A.Jndt = 1 AND A.Nilai_Susut1 = 0 AND B.IDPemda IS NULL)
		) B ON A.IDPemda = B.IDPemda LEFT OUTER JOIN
		(
		SELECT  A.Kd_Prov, A.Nm_Provinsi, B.Kd_Kab_Kota, B.Nm_Kab_Kota, D.Kd_Bidang, C.Nm_Bidang, D.Kd_Unit, D.Nm_Unit, E.Kd_Sub, E.Nm_Sub_Unit, F.Kd_UPB, F.Nm_UPB
		FROM    Ref_Unit D INNER JOIN
                	Ref_Bidang C ON D.Kd_Bidang = C.Kd_Bidang INNER JOIN
                	Ref_Sub_Unit E ON D.Kd_Prov = E.Kd_Prov AND D.Kd_Kab_Kota = E.Kd_Kab_Kota AND D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
                	Ref_UPB F ON E.Kd_Prov = F.Kd_Prov AND E.Kd_Kab_Kota = F.Kd_Kab_Kota AND E.Kd_Bidang = F.Kd_Bidang AND E.Kd_Unit = F.Kd_Unit AND 
                	E.Kd_Sub = F.Kd_Sub INNER JOIN
                	Ref_Provinsi A INNER JOIN
                	Ref_Kab_Kota B ON A.Kd_Prov = B.Kd_Prov ON D.Kd_Prov = B.Kd_Prov AND D.Kd_Kab_Kota = B.Kd_Kab_Kota
		)C ON   A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND 
                	A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB LEFT OUTER JOIN
		(
		SELECT  G.Kd_Aset, G.Kd_Aset0, G.Nm_Aset0,A.Kd_Aset1, A.Nm_Aset1, B.Kd_Aset2, B.Nm_Aset2, C.Kd_Aset3, C.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, E.Kd_Aset5, E.Nm_Aset5
		FROM    Ref_Rek0_108 G INNER JOIN
			Ref_Rek1_108 A ON A.Kd_Aset = G.Kd_Aset AND A.Kd_Aset0 = G.Kd_Aset0 INNER JOIN
                	Ref_Rek2_108 B ON A.Kd_Aset = B.Kd_Aset AND A.Kd_Aset0 = B.Kd_Aset0 AND A.Kd_Aset1 = B.Kd_Aset1 INNER JOIN
                	Ref_Rek3_108 C ON B.Kd_Aset = C.Kd_Aset AND B.Kd_Aset0 = C.Kd_Aset0 AND B.Kd_Aset1 = C.Kd_Aset1 AND B.Kd_Aset2 = C.Kd_Aset2 INNER JOIN
                	Ref_Rek4_108 D ON D.Kd_Aset = C.Kd_Aset AND D.Kd_Aset0 = C.Kd_Aset0 AND C.Kd_Aset1 = D.Kd_Aset1 AND C.Kd_Aset2 = D.Kd_Aset2 AND C.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
                	Ref_Rek5_108 E ON D.Kd_Aset = E.Kd_Aset AND D.Kd_Aset0 = E.Kd_Aset0 AND D.Kd_Aset1 = E.Kd_Aset1 AND D.Kd_Aset2 = E.Kd_Aset2 AND D.Kd_Aset3 = E.Kd_Aset3 AND D.Kd_Aset4 = E.Kd_Aset4
		) D ON  A.Kd_Aset = D.Kd_Aset AND A.Kd_Aset0 = D.Kd_Aset0 AND A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND 
                	A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 
	WHERE B.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
      	A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND 
	A.Kd_Aset LIKE @Kd_Aset AND A.Kd_Aset0 LIKE @Kd_Aset0 AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND 
      	A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Tgl_Pembukuan <=@D1 AND A.KD_KA <> 0
   GROUP BY  B.Jndt, A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB, A.Kd_Aset_Gab, 
		D.Kd_Aset0, D.Nm_Aset0, D.Kd_Aset1, D.Nm_Aset1, D.Kd_Aset2, D.Nm_Aset2, D.Kd_Aset3, D.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, D.Kd_Aset5, D.Nm_Aset5, A.No_Register, B.Nilai_Susut1, B.Nilai_Susut2, B.Akum_susut, 
		A.Tgl_Perolehan, B.Nilai_Sisa, B.Sisa_Umur,B.Harga
	ORDER BY B.Jndt, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		D.Kd_Aset0, D.Kd_Aset1, D.Kd_Aset2, D.Kd_Aset3, D.Kd_Aset4, D.Kd_Aset5, A.No_Register

END








GO
