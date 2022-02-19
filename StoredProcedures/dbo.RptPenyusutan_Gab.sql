USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.RptPenyusutan_Gab @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), 
	@Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3),	@D1 datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
	@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @D1 datetime
	
SET @Tahun = '2019'
SET @Kd_Prov = '5'
SET @Kd_Kab_Kota = '1'
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @Kd_UPB = ''
SET @Kd_Aset1 = ''
SET @Kd_Aset2 = ''
SET @Kd_Aset3 = ''
SET @Kd_Aset4 = ''
SET @D1= '20191231'
--*/


DECLARE @JLap Tinyint SET @JLap = 1

IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
IF ISNULL(@Kd_Aset1, '') = '' SET @Kd_Aset1 = '%'
IF ISNULL(@Kd_Aset2, '') = '' SET @Kd_Aset2 = '%'
IF ISNULL(@Kd_Aset3, '') = '' SET @Kd_Aset3 = '%'
IF ISNULL(@Kd_Aset4, '') = '' SET @Kd_Aset4 = '%'



SELECT  A.Jndt, A.Kd_Prov, C.Nm_Provinsi, A.Kd_Kab_Kota, C.Nm_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB,
	A.Kd_Aset1, B.Nm_Aset1, A.Kd_Aset2, B.Nm_Aset2, A.Kd_Aset3, B.Nm_Aset3, A.Kd_Aset4, B.Nm_Aset4, A.Kd_Aset5, B.Nm_Aset5, 
	CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)AS Kd_Aset_Gab2,    
	CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)AS Kd_Aset_Gab3,     
	CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4)AS Kd_Aset_Gab4,     
	CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4)+'.'+CONVERT(varchar, A.Kd_Aset5)AS Kd_Aset_Gab5,     
	YEAR (@D1) AS THN_SBLM, A.No_Register, A.Tgl_Perolehan, MONTH (A.Tgl_Perolehan) AS Bulan1, YEAR (A.Tgl_Perolehan) AS Tahun, CONVERT(varchar, A.Sisa_Umur / 12) AS Thn, A.Sisa_Umur % 12 AS Bln,
	A.Nilai_Susut1, A.Nilai_Susut2, A.Akum_susut, A.Nilai_Sisa,
       --(ISNULL(A.Nilai_Sisa,0)) + (ISNULL(A.Akum_susut,0)) AS Nilai_Perolehan, 
	ISNULL(A.Harga,0) AS Nilai_Perolehan,
       (ISNULL(A.Akum_Susut,0)) - (ISNULL(A.Nilai_Susut1,0)) - (ISNULL(A.Nilai_Susut2,0)) AS AKP_Awal, 
       (ISNULL(A.Nilai_Susut1,0)) + (ISNULL(A.Nilai_Susut2,0))AS Penyusutan, ISNULL(A.Akum_Susut,0) AS AKP_Akhir, ISNULL(A.Nilai_Sisa,0) AS Nilai_Buku

FROM (
	SELECT     A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, B.Jndt, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
	           B.Harga AS Harga, B.Nilai_Susut1 AS Nilai_Susut1, B.Nilai_Susut2 AS Nilai_Susut2, B.Akum_Susut AS Akum_Susut, B.Nilai_Sisa AS Nilai_Sisa, B.Sisa_Umur AS Sisa_Umur
	FROM       fn_UPB_B(@Tahun,@D1,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4) A INNER JOIN
	           Ta_SusutB B ON A.IDPemda = B.IDPemda LEFT OUTER JOIN 
                   (SELECT IDPemda FROM Ta_KIBBR
                    WHERE Kd_Riwayat = 1 AND YEAR(Tgl_Dokumen) = @Tahun) C ON B.IDPemda = C.IDPemda                                
	WHERE B.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
	      A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB /*AND A.Tgl_Pembukuan <= @D1*/ AND NOT (B.Jndt = 1 AND Nilai_Susut1 = 0 AND C.IDPemda IS NULL)
		
	UNION ALL 
	
	SELECT     A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, B.Jndt, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
	           B.Harga AS Harga, B.Nilai_Susut1 AS Nilai_Susut1, B.Nilai_Susut2 AS Nilai_Susut2, B.Akum_Susut AS Akum_Susut, B.Nilai_Sisa AS Nilai_Sisa, B.Sisa_Umur AS Sisa_Umur
	FROM       fn_UPB_C(@Tahun,@D1,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4) A INNER JOIN
	           Ta_SusutC B ON A.IDPemda = B.IDPemda LEFT OUTER JOIN 
                   (SELECT IDPemda FROM Ta_KIBCR
                    WHERE Kd_Riwayat = 1 AND YEAR(Tgl_Dokumen) = @Tahun) C ON B.IDPemda = C.IDPemda  		   
	WHERE B.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
	      A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB /*AND A.Tgl_Perolehan <= @D1*/ AND NOT (B.Jndt = 1 AND Nilai_Susut1 = 0 AND C.IDPemda IS NULL)
	
	UNION ALL 
	
	SELECT     A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, B.Jndt, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,  A.No_Register, A.Tgl_Perolehan, 
	           B.Harga AS Harga, B.Nilai_Susut1 AS Nilai_Susut1, B.Nilai_Susut2 AS Nilai_Susut2, B.Akum_Susut AS Akum_Susut, B.Nilai_Sisa AS Nilai_Sisa, B.Sisa_Umur AS Sisa_Umur
	FROM       fn_UPB_D(@Tahun,@D1,@Kd_Prov,@Kd_Kab_Kota,@Kd_Bidang,@Kd_Unit,@Kd_Sub,@Kd_UPB,@Kd_Aset1,@Kd_Aset2,@Kd_Aset3,@Kd_Aset4) A INNER JOIN
	           Ta_SusutD B ON A.IDPemda = B.IDPemda LEFT OUTER JOIN 
                   (SELECT IDPemda FROM Ta_KIBDR
                    WHERE Kd_Riwayat = 1 AND YEAR(Tgl_Dokumen) = @Tahun) C ON B.IDPemda = C.IDPemda
	WHERE B.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
	      A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND /*A.Tgl_Perolehan <= @D1 AND*/ NOT (B.Jndt = 1 AND Nilai_Susut1 = 0 AND C.IDPemda IS NULL)
	
	UNION ALL 
	
	SELECT     A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, B.Jndt, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan, 
	           D.Harga AS Harga, B.Nilai_Susut1 AS Nilai_Susut1, B.Nilai_Susut2 AS Nilai_Susut2, B.Akum_Susut AS Akum_Susut, B.Nilai_Sisa AS Nilai_Sisa, B.Sisa_Umur AS Sisa_Umur
	FROM       fn_Kartu_BrgE(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@Jlap)  D INNER JOIN
		    Ta_KIB_E A ON A.Kd_Prov = D.Kd_Prov AND A.Kd_Kab_Kota = D.Kd_Kab_Kota AND A.Kd_Bidang = D.Kd_Bidang AND 
                      A.Kd_Unit = D.Kd_Unit AND A.Kd_Sub = D.Kd_Sub AND A.Kd_UPB = D.Kd_UPB AND A.Kd_Aset1 = D.Kd_Aset1 AND 
                      A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 AND 
                      A.No_Register = D.No_Register  INNER JOIN
	           Ta_SusutE B ON A.IDPemda = B.IDPemda LEFT OUTER JOIN 
                   (SELECT IDPemda FROM Ta_KIBER
                    WHERE Kd_Riwayat = 1 AND YEAR(Tgl_Dokumen) = @Tahun) C ON B.IDPemda = C.IDPemda
	WHERE B.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
	      A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND A.Tgl_Perolehan <= @D1 AND NOT (B.Jndt = 1 AND Nilai_Susut1 = 0 AND C.IDPemda IS NULL)

	) A INNER JOIN
	(
	SELECT  A.Kd_Aset1, A.Nm_Aset1, B.Kd_Aset2, B.Nm_Aset2, C.Kd_Aset3, C.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, E.Kd_Aset5, E.Nm_Aset5
	FROM    Ref_Rek_Aset1 A INNER JOIN
                Ref_Rek_Aset2 B ON A.Kd_Aset1 = B.Kd_Aset1 INNER JOIN
                Ref_Rek_Aset3 C ON B.Kd_Aset1 = C.Kd_Aset1 AND B.Kd_Aset2 = C.Kd_Aset2 INNER JOIN
                Ref_Rek_Aset4 D ON C.Kd_Aset1 = D.Kd_Aset1 AND C.Kd_Aset2 = D.Kd_Aset2 AND C.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
                Ref_Rek_Aset5 E ON D.Kd_Aset1 = E.Kd_Aset1 AND D.Kd_Aset2 = E.Kd_Aset2 AND D.Kd_Aset3 = E.Kd_Aset3 AND D.Kd_Aset4 = E.Kd_Aset4
	) B ON  A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND 
                A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
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
                A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB 
WHERE A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
      A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND 
      A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Tgl_Perolehan <= @D1

ORDER BY A.Jndt, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register













GO
