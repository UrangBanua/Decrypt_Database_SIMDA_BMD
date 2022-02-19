USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** RptMappingKodeBarang - 30082019 - Modified for Ver 2.0.7 [demi@simda.id] ***/
 CREATE PROCEDURE RptMappingKodeBarang @Tahun varchar(4)
 WITH ENCRYPTION
 AS

/*
DECLARE @Tahun varchar(4)
SET @Tahun = '2019'
--*/ 



DECLARE @map17 TABLE(Kd_Rek_Gab_17 varchar (20),  Nm_Aset5_17 varchar (255), Nm_Aset5_17s varchar (255), Kd_Rek_Gab_108 varchar (20), Nm_Aset5_108 varchar (255), KODE tinyint)

insert into @map17

SELECT A.Kd_Rek_Gab_17, A.Nm_Aset5_17, A.Nm_Aset5_17s, A.Kd_Rek_Gab_108, A.Nm_Aset5_108, A.KODE FROM
(
SELECT CONVERT(varchar, A.Kd1) + '.' + CONVERT(varchar, A.Kd2) + '.' + CONVERT(varchar, A.Kd3) + '.' + CONVERT(varchar, A.Kd4) + '.' + CONVERT(varchar, A.Kd5) AS Kd_Rek_Gab_17, Nm_Aset5_17, Nm_Aset5_17s,
CONVERT(varchar, A.Kd_Aset) + '.' + CONVERT(varchar, A.Kd_Aset0) + '.' + CONVERT(varchar, A.Kd_Aset1) + '.' + CONVERT(varchar, A.Kd_Aset2) + '.' + CONVERT(varchar, A.Kd_Aset3) + '.' + CONVERT(varchar, A.Kd_Aset4) + '.' + CONVERT(varchar, A.Kd_Aset5) 
AS Kd_Rek_Gab_108, Nm_Aset5 AS Nm_Aset5_108, 0 AS KODE FROM [Ref_Map5_17_108] A
) A

insert into @map17
SELECT A.Kd_Rek_Gab_17, A.Nm_Aset5_17, A.Nm_Aset5_17s, A.Kd_Rek_Gab_108, A.Nm_Aset5_108, A.KODE FROM
(
SELECT CONVERT(varchar, A.Kd_Aset1) + '.' + CONVERT(varchar, A.Kd_Aset2) + '.' + CONVERT(varchar, A.Kd_Aset3) + '.' + CONVERT(varchar, A.Kd_Aset4) + '.' + CONVERT(varchar, A.Kd_Aset5) AS Kd_Rek_Gab_17, A.Nm_Aset5 AS Nm_Aset5_17, '-' AS Nm_Aset5_17s, '-' AS Kd_Rek_Gab_108, '-' AS Nm_Aset5_108, 1 AS KODE 

FROM
	(
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A LEFT OUTER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1=B.Kd1 AND A.Kd_Aset2=B.Kd2 AND A.Kd_Aset3=B.Kd3 AND A.Kd_Aset4=B.Kd4 AND A.Kd_Aset5=B.Kd5
		WHERE A.Kd_Aset1 = 1 AND B.Kd1 IS NULL AND (A.Nm_Aset5 LIKE '%' + '' + '%')
		) A INNER JOIN Ta_KIB_A B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A LEFT OUTER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1=B.Kd1 AND A.Kd_Aset2=B.Kd2 AND A.Kd_Aset3=B.Kd3 AND A.Kd_Aset4=B.Kd4 AND A.Kd_Aset5=B.Kd5
		WHERE A.Kd_Aset1 = 2 AND B.Kd1 IS NULL AND (A.Nm_Aset5 LIKE '%' + '' + '%')
		) A INNER JOIN Ta_KIB_B B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A LEFT OUTER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1=B.Kd1 AND A.Kd_Aset2=B.Kd2 AND A.Kd_Aset3=B.Kd3 AND A.Kd_Aset4=B.Kd4 AND A.Kd_Aset5=B.Kd5
		WHERE A.Kd_Aset1 = 3 AND B.Kd1 IS NULL AND (A.Nm_Aset5 LIKE '%' + '' + '%')
		) A INNER JOIN Ta_KIB_C B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A LEFT OUTER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1=B.Kd1 AND A.Kd_Aset2=B.Kd2 AND A.Kd_Aset3=B.Kd3 AND A.Kd_Aset4=B.Kd4 AND A.Kd_Aset5=B.Kd5
		WHERE A.Kd_Aset1 = 4 AND B.Kd1 IS NULL AND (A.Nm_Aset5 LIKE '%' + '' + '%')
		) A INNER JOIN Ta_KIB_D B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A LEFT OUTER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1=B.Kd1 AND A.Kd_Aset2=B.Kd2 AND A.Kd_Aset3=B.Kd3 AND A.Kd_Aset4=B.Kd4 AND A.Kd_Aset5=B.Kd5
		WHERE A.Kd_Aset1 = 5 AND B.Kd1 IS NULL AND (A.Nm_Aset5 LIKE '%' + '' + '%')
		) A INNER JOIN Ta_KIB_E B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5

	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A LEFT OUTER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1=B.Kd1 AND A.Kd_Aset2=B.Kd2 AND A.Kd_Aset3=B.Kd3 AND A.Kd_Aset4=B.Kd4 AND A.Kd_Aset5=B.Kd5
		WHERE B.Kd1 IS NULL AND (A.Nm_Aset5 LIKE '%' + '' + '%')
		) A INNER JOIN Ta_KIB_F B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A LEFT OUTER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1=B.Kd1 AND A.Kd_Aset2=B.Kd2 AND A.Kd_Aset3=B.Kd3 AND A.Kd_Aset4=B.Kd4 AND A.Kd_Aset5=B.Kd5
		WHERE B.Kd1 IS NULL AND (A.Nm_Aset5 LIKE '%' + '' + '%')
		) A INNER JOIN Ta_Lainnya B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5 ) A

) A
----ORDER BY A.Kd_Rek_Gab_108, A.Kd_Rek_Gab_17

------------------------------------------------------------------------------------------------------

insert into @map17
SELECT A.Kd_Rek_Gab_17, A.Nm_Aset5_17, A.Nm_Aset5_17s, A.Kd_Rek_Gab_108, A.Nm_Aset5_108, A.KODE FROM
(
SELECT CONVERT(varchar, A.Kd_Aset1) + '.' + CONVERT(varchar, A.Kd_Aset2) + '.' + CONVERT(varchar, A.Kd_Aset3) + '.' + CONVERT(varchar, A.Kd_Aset4) + '.' + CONVERT(varchar, A.Kd_Aset5) AS Kd_Rek_Gab_17, A.Nm_Aset5 AS Nm_Aset5_17, '-' AS Nm_Aset5_17s, '-' AS Kd_Rek_Gab_108, '-' AS Nm_Aset5_108, 1 AS KODE 

FROM
	(
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A 
		) A INNER JOIN Ta_KIB_A B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A 
		) A INNER JOIN Ta_KIB_B B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A 
		) A INNER JOIN Ta_KIB_C B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A 
		) A INNER JOIN Ta_KIB_D B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A 
		) A INNER JOIN Ta_KIB_E B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5

	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A 
		) A INNER JOIN Ta_KIB_F B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A 
		) A INNER JOIN Ta_Lainnya B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5 ) A

) A
--ORDER BY A.Kd_Rek_Gab_108, A.Kd_Rek_Gab_17

SELECT A.Kd_Rek_Gab_17, A.Nm_Aset5_17, A.Nm_Aset5_17s, A.Kd_Rek_Gab_108, A.Nm_Aset5_108, A.KODE, D.Nm_Pemda  FROM
(
SELECT max(A.Kd_Rek_Gab_17) as Kd_Rek_Gab_17, max(A.Nm_Aset5_17) as Nm_Aset5_17, max(A.Nm_Aset5_17s) as Nm_Aset5_17s, max(A.Kd_Rek_Gab_108) as Kd_Rek_Gab_108, max(A.Nm_Aset5_108) as Nm_Aset5_108, sum(A.KODE) as KODE
from @map17 A
GROUP BY  A.Kd_Rek_Gab_17
) A, Ref_Pemda D
ORDER BY KODE DESC, Kd_Rek_Gab_17 ASC, A.Kd_Rek_Gab_108 ASC


	








GO
