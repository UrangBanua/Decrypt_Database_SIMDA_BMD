USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** RptLampiranPenyusutanAsetLain - 21012016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE dbo.RptLampiranPenyusutanAsetLain @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3), @D2 datetime 
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3), @D2 datetime
SET @Tahun = '2015'
SET @Kd_Prov = '5'
SET @Kd_Kab_Kota = '1'
SET @Kd_Bidang = '6'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = ''
SET @Kd_Aset1 = '5'
SET @D2 = '20151231' 
*/
        IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

     

SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset_Gab,D.Nm_Aset, E.Nm_Kab_Kota, E.Nm_Bidang, E.Nm_Unit, E.Nm_Sub_Unit, E.Nm_UPB,
       A.Jn, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register, A.BULAN, A.TAHUN, IsNull(A.Harga,0) AS Nilai_Perolehan, 
      (ISNULL(A.Akum_Susut,0)) - (ISNULL(A.Susut1,0)) - (ISNULL(A.Susut2,0)) AS AKP_Awal, 
	 IsNull (A.Susut1,0) AS Susut1, IsNull (A.Susut2,0) AS Susut2, IsNull (A.Susut,0) AS Susut, IsNull(A.Akum_Susut,0) AS Akum_Susut, IsNull (A.Nilai_Sisa,0) AS Nilai_Sisa
FROM
    (

	SELECT B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB,
            CASE A.Nilai_Susut1 WHEN 0 THEN 0 ELSE 1 END AS Jn, 
            B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, 
	   CONVERT(varchar, Kd_Aset1)+'.'+ CONVERT(varchar, Kd_Aset2)+'.'+CONVERT(varchar, Kd_Aset3)+'.'+CONVERT(varchar, Kd_Aset4)+'.'+CONVERT(varchar, Kd_Aset5)AS Kd_Aset_Gab, 
            B.No_Register, MONTH (B.Tgl_Perolehan) AS Bulan, YEAR (B.Tgl_Perolehan) AS Tahun, 
	    A.Harga, 0 AS Susut1, 0 AS Susut2, (A.Nilai_Susut1+A.Nilai_Susut2) AS Susut, 
            A.Akum_Susut, A.Nilai_Sisa
     FROM Ta_SusutB A INNER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
     WHERE (A.Tahun = @Tahun) AND (A.Jndt = 1) AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND 
           (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB) AND
           (B.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
				WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
				WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
				ELSE 12 END)


     UNION ALL

     SELECT B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB,
            CASE A.Nilai_Susut1 WHEN 0 THEN 0 ELSE 1 END AS Jn, 
            B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, 
	  CONVERT(varchar, Kd_Aset1)+'.'+ CONVERT(varchar, Kd_Aset2)+'.'+CONVERT(varchar, Kd_Aset3)+'.'+CONVERT(varchar, Kd_Aset4)+'.'+CONVERT(varchar, Kd_Aset5)AS Kd_Aset_Gab,
	    B.No_Register, MONTH (B.Tgl_Perolehan) AS Bulan, YEAR (B.Tgl_Perolehan) AS Tahun, A.HARGA, 0 AS Susut1, 0 AS Susut2, (A.Nilai_Susut1+A.Nilai_Susut2) AS Susut, 
            A.Akum_Susut, A.Nilai_Sisa
     FROM Ta_SusutC A INNER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda
     WHERE (A.Tahun = @Tahun) AND (A.Jndt = 1) AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND 
           (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB) AND
           (B.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
				WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
				WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
				ELSE 12 END)
     
     UNION ALL

     SELECT B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB,
            	CASE A.Nilai_Susut1 WHEN 0 THEN 0 ELSE 1 END AS Jn, 
            	B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, 
		CONVERT(varchar, B.Kd_Aset1)+'.'+ CONVERT(varchar, Kd_Aset2)+'.'+CONVERT(varchar, Kd_Aset3)+'.'+CONVERT(varchar, Kd_Aset4)+'.'+CONVERT(varchar, Kd_Aset5)AS Kd_Aset_Gab,
		B.No_Register, MONTH (B.Tgl_Perolehan) AS Bulan, YEAR (B.Tgl_Perolehan) AS Tahun, A.Harga, 0 AS Susut1, 0 AS Susut2, (A.Nilai_Susut1+A.Nilai_Susut2) AS Susut, 
            	A.Akum_Susut, A.Nilai_Sisa
     FROM Ta_SusutD A INNER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda
     WHERE (A.Tahun = @Tahun) AND (A.Jndt = 1) AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND 
           (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB) AND
           (B.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
				WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
				WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
				ELSE 12 END)

     UNION ALL

     SELECT B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB,
            	CASE A.Nilai_Susut1 WHEN 0 THEN 0 ELSE 1 END AS Jn, 
            	B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, 
		CONVERT(varchar, Kd_Aset1)+'.'+ CONVERT(varchar, Kd_Aset2)+'.'+CONVERT(varchar, Kd_Aset3)+'.'+CONVERT(varchar, Kd_Aset4)+'.'+CONVERT(varchar, Kd_Aset5)AS Kd_Aset_Gab,
		B.No_Register,MONTH (B.Tgl_Perolehan) AS Bulan, YEAR (B.Tgl_Perolehan) AS Tahun, A.Harga, 0 AS Susut1, 0 AS Susut2, (A.Nilai_Susut1+A.Nilai_Susut2) AS Susut, 
            	A.Akum_Susut, A.Nilai_Sisa
     FROM Ta_SusutE A INNER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda
     WHERE (A.Tahun = @Tahun) AND (A.Jndt = 1) AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND 
           (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB) AND
           (B.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
				WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
				WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
				ELSE 12 END)


     UNION ALL
     
     SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 0 AS Jn, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, 
            	A.Kd_Aset5,  '', A.No_Register, MONTH (A.Tgl_Perolehan) AS Bulan, YEAR (A.Tgl_Perolehan) AS Tahun,
		A.Harga, 0 AS Susut1, 0 AS Susut2, 0 AS Susut, 0 AS Akum_Susut, A.Harga AS Nilai_Sisa
     FROM fn_Kartu_BrgE(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, '%','%','%','%','%','%',1)  A           
	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND 
           (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB) AND
           (A.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
				WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
				WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
				ELSE 12 END) AND 
           (A.Kd_KA = 1) AND (A.KD_BIDANG <> 22) AND (A.Kondisi = 3) AND A.Kd_Aset2 IN(17,18,19)

     UNION ALL
     
     SELECT B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB,
            0 AS Jn, B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, 
	    CONVERT(varchar, B.Kd_Aset1)+'.'+ CONVERT(varchar, B.Kd_Aset2)+'.'+CONVERT(varchar, B.Kd_Aset3)+'.'+CONVERT(varchar, B.Kd_Aset4)+'.'+CONVERT(varchar, B.Kd_Aset5)AS Kd_Aset_Gab,
            B.No_Register, MONTH (B.Tgl_Perolehan) AS Bulan, YEAR (B.Tgl_Perolehan) AS Tahun, A.Harga, A.Nilai_Susut1, A.Nilai_Susut2, 0 AS Susut, 
            A.Akum_Susut, A.Nilai_Sisa
     FROM Ta_SusutL A INNER JOIN Ta_Lainnya B ON A.IDPemda = B.IDPemda
     WHERE (A.Tahun = @Tahun) AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND 
           (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB) AND
           (B.Kd_Pemilik = CASE WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota = 0 THEN 11
				WHEN @Kd_Prov = 9 AND @Kd_Kab_Kota <> 0 THEN 11
				WHEN @Kd_Prov <> 9 AND @Kd_Kab_Kota = 0 THEN 11
				ELSE 12 END)
    ) A INNER JOIN 
     (
	SELECT  A.Kd_Aset1, A.Nm_Aset1, B.Kd_Aset2, B.Nm_Aset2, C.Kd_Aset3, C.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, E.Kd_Aset5, E.Nm_Aset5 AS NM_ASET
	FROM    Ref_Rek_Aset1 A INNER JOIN
                Ref_Rek_Aset2 B ON A.Kd_Aset1 = B.Kd_Aset1 INNER JOIN
                Ref_Rek_Aset3 C ON B.Kd_Aset1 = C.Kd_Aset1 AND B.Kd_Aset2 = C.Kd_Aset2 INNER JOIN
                Ref_Rek_Aset4 D ON C.Kd_Aset1 = D.Kd_Aset1 AND C.Kd_Aset2 = D.Kd_Aset2 AND C.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
                Ref_Rek_Aset5 E ON D.Kd_Aset1 = E.Kd_Aset1 AND D.Kd_Aset2 = E.Kd_Aset2 AND D.Kd_Aset3 = E.Kd_Aset3 AND D.Kd_Aset4 = E.Kd_Aset4
	) D ON  A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND 
                A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 
		INNER JOIN
	(       	
         SELECT @Kd_Prov AS Kd_Prov, @Kd_Kab_Kota AS Kd_Kab_Kota, @Kd_Bidang AS Kd_Bidang, @Kd_Unit AS Kd_Unit, @Kd_Sub AS Kd_Sub, 
                @Kd_UPB AS Kd_UPB, E.Nm_Bidang, D.Nm_Unit, C.Nm_sub_Unit, B.Nm_UPB, G.Nm_Kab_Kota		
	 FROM Ta_UPB A INNER JOIN
              Ref_UPB B ON A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
	      Ref_Sub_Unit C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub INNER JOIN
	      Ref_Unit D ON C.Kd_Bidang = D.Kd_Bidang AND C.Kd_Unit = D.Kd_Unit INNER JOIN
	      Ref_Bidang E ON D.Kd_Bidang = E.Kd_Bidang INNER JOIN
	      REF_KAB_KOTA G ON A.KD_KAB_KOTA = G. KD_KAB_KOTA AND A.KD_PROV = G.KD_PROV INNER JOIN
	      (
	       SELECT TOP 1 Tahun, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
	       FROM Ta_UPB A
	       WHERE (A.Tahun = @Tahun) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	       ORDER BY Tahun, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
	       ) F ON A.Tahun = F.Tahun AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub AND A.Kd_UPB = F.Kd_UPB

	) E ON A.Kd_Prov = E.KD_PROV AND A.KD_KAB_KOTA = E.KD_KAB_KOTA





GO
