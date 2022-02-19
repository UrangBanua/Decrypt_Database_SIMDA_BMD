USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** RptAsetTidakDisusutkan - 13012016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE RptAsetTidakDisusutkan @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @D1 datetime
WITH ENCRYPTION
AS
/*

DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
		@Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3), @D1 datetime
		
SET @Tahun = '2015'
SET @Kd_Prov = '99'
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = ''
SET @Kd_Aset1 = ''
SET @Kd_Aset2 = ''
SET @Kd_Aset3 = ''
SET @Kd_Aset4 = ''
SET @D1= '20151231'
*/

DECLARE @JLap Tinyint

IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
IF ISNULL(@Kd_Aset1, '') = '' SET @Kd_Aset1 = '%'
IF ISNULL(@Kd_Aset2, '') = '' SET @Kd_Aset2 = '%'
IF ISNULL(@Kd_Aset3, '') = '' SET @Kd_Aset3 = '%'
IF ISNULL(@Kd_Aset4, '') = '' SET @Kd_Aset4 = '%'

	

SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang,  A.Kd_Unit,  A.Kd_Sub,  A.Kd_UPB, 
       B.Nm_Kab_Kota, B.Nm_Bidang, B.Nm_Unit, B.Nm_Sub_Unit, B.Nm_UPB, 
       A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,  C.Kd_Aset_Gab, C.Kd_Aset_Gab2,C.Kd_Aset_Gab3,
       C.Nm_Aset1, C.Nm_Aset2, C.Nm_Aset3, C.Nm_Aset4, C.Nm_Aset5,
       A.No_Register, A.Tgl_Perolehan, A.Harga
 
FROM (
	SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Tgl_Perolehan, No_Register, '-' AS Kondisi, Harga
	FROM   fn_Kartu_BrgA(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, 1, '%','%','%','%','%',@JLap) A
	WHERE (Kd_Aset1 = 1)
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Tgl_Perolehan, No_Register, Harga

/*
	UNION ALL

	SELECT Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Tgl_Perolehan, No_Register, Kondisi, Harga       
	FROM fn_Kartu_BrgB(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, 2, '%','%','%','%','%',@JLap)A
	WHERE (Kondisi = 3)
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Tgl_Perolehan, No_Register, Kondisi, Harga


	UNION ALL

	SELECT  Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Tgl_Perolehan, No_Register, Kondisi, Harga
	FROM   fn_Kartu_BrgC(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, 3, '%','%','%','%','%',@JLap)A
	WHERE (Kondisi = 3)
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Tgl_Perolehan, No_Register, Kondisi, Harga


	UNION ALL

	SELECT  Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Tgl_Perolehan, No_Register, Kondisi, Harga
	FROM   fn_Kartu_BrgD(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, 4, '%','%','%','%','%',@JLap)A
	WHERE (Kondisi = 3)
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Tgl_Perolehan, No_Register, Kondisi, Harga

*/
	UNION ALL

	SELECT  Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Tgl_Perolehan, No_Register, Kondisi, Harga
	FROM   fn_Kartu_BrgE(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, 5, '%','%','%','%','%',@JLap)A
	WHERE (Kd_Aset1 = 5) AND (Kd_Aset2 BETWEEN 17 AND 19)
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Tgl_Perolehan, No_Register, Kondisi, Harga


	UNION ALL

	SELECT  Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, 6 AS Kd_Aset1, 20 AS Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Tgl_Perolehan, No_Register, Kondisi, Harga
	FROM   fn_Kartu_BrgF(@D1, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB, 6, '%','%','%','%','%',@JLap)A
	GROUP BY Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Tgl_Perolehan, No_Register, Kondisi, Harga

	) A LEFT OUTER JOIN
	(
	SELECT  A.Kd_Prov, A.Nm_Provinsi, B.Kd_Kab_Kota, B.Nm_Kab_Kota, D.Kd_Bidang, C.Nm_Bidang, D.Kd_Unit, D.Nm_Unit, E.Kd_Sub, E.Nm_Sub_Unit, F.Kd_UPB, F.Nm_UPB
	FROM    Ref_Unit D INNER JOIN
                Ref_Bidang C ON D.Kd_Bidang = C.Kd_Bidang INNER JOIN
                Ref_Sub_Unit E ON D.Kd_Prov = E.Kd_Prov AND D.Kd_Kab_Kota = E.Kd_Kab_Kota AND D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
                Ref_UPB F ON E.Kd_Prov = F.Kd_Prov AND E.Kd_Kab_Kota = F.Kd_Kab_Kota AND E.Kd_Bidang = F.Kd_Bidang AND E.Kd_Unit = F.Kd_Unit AND 
                E.Kd_Sub = F.Kd_Sub INNER JOIN
                Ref_Provinsi A INNER JOIN
                Ref_Kab_Kota B ON A.Kd_Prov = B.Kd_Prov ON D.Kd_Prov = B.Kd_Prov AND D.Kd_Kab_Kota = B.Kd_Kab_Kota
	)B ON   A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND 
                A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB LEFT OUTER JOIN
	(
	SELECT  A.Kd_Aset1, A.Nm_Aset1, B.Kd_Aset2, B.Nm_Aset2, C.Kd_Aset3, C.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, E.Kd_Aset5, E.Nm_Aset5,
		CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, B.Kd_Aset2) AS Kd_Aset_Gab2,
		CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, B.Kd_Aset2)+'.'+CONVERT(varchar, C.Kd_Aset3) AS Kd_Aset_Gab3,
	        CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, B.Kd_Aset2)+'.'+CONVERT(varchar, C.Kd_Aset3)+'.'+CONVERT(varchar, D.Kd_Aset4)+'.'+CONVERT(varchar, E.Kd_Aset5)AS Kd_Aset_Gab     
	FROM    Ref_Rek_Aset1 A INNER JOIN
                Ref_Rek_Aset2 B ON A.Kd_Aset1 = B.Kd_Aset1 INNER JOIN
                Ref_Rek_Aset3 C ON B.Kd_Aset1 = C.Kd_Aset1 AND B.Kd_Aset2 = C.Kd_Aset2 INNER JOIN
                Ref_Rek_Aset4 D ON C.Kd_Aset1 = D.Kd_Aset1 AND C.Kd_Aset2 = D.Kd_Aset2 AND C.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
                Ref_Rek_Aset5 E ON D.Kd_Aset1 = E.Kd_Aset1 AND D.Kd_Aset2 = E.Kd_Aset2 AND D.Kd_Aset3 = E.Kd_Aset3 AND D.Kd_Aset4 = E.Kd_Aset4
	) C ON  A.Kd_Aset1 = C.Kd_Aset1 AND A.Kd_Aset2 = C.Kd_Aset2 AND 
                A.Kd_Aset3 = C.Kd_Aset3 AND A.Kd_Aset4 = C.Kd_Aset4 AND A.Kd_Aset5 = C.Kd_Aset5 

WHERE A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
      A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND 
      A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Tgl_Perolehan <= @D1

ORDER BY  A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register

GO
