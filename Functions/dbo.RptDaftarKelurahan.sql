USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** RptDaftarKelurahan - 12122015 - Modified for Ver 2.0.7 [demi@simda.id] ***/
 CREATE PROCEDURE [dbo].[RptDaftarKelurahan] @Tahun varchar(4)
 WITH ENCRYPTION
 AS

/*
DECLARE @Tahun varchar(4)
SET @Tahun = '2009'
 */

SELECT A.Kd_Rek_Gab_17, A.Nm_Aset5_17, A.Kd_Rek_Gab_108, A.Nm_Aset5_108, D.Nm_Pemda FROM
(
SELECT CONVERT(varchar, A.Kd1) + '.' + CONVERT(varchar, A.Kd2) + '.' + CONVERT(varchar, A.Kd3) + '.' + CONVERT(varchar, A.Kd4) + '.' + CONVERT(varchar, A.Kd5) AS Kd_Rek_Gab_17, Nm_Aset5_17, 
CONVERT(varchar, A.Kd_Aset) + '.' + CONVERT(varchar, A.Kd_Aset0) + '.' + CONVERT(varchar, A.Kd_Aset1) + '.' + CONVERT(varchar, A.Kd_Aset2) + '.' + CONVERT(varchar, A.Kd_Aset3) + '.' + CONVERT(varchar, A.Kd_Aset4) + '.' + CONVERT(varchar, A.Kd_Aset5) 
AS Kd_Rek_Gab_108, Nm_Aset5 AS Nm_Aset5_108 FROM [Ref_Map5_17_108] A
UNION
SELECT CONVERT(varchar, A.Kd_Aset1) + '.' + CONVERT(varchar, A.Kd_Aset2) + '.' + CONVERT(varchar, A.Kd_Aset3) + '.' + CONVERT(varchar, A.Kd_Aset4) + '.' + CONVERT(varchar, A.Kd_Aset5) AS Kd_Rek_Gab_17, A.Nm_Aset5 AS Nm_Aset5_17, NULL AS Kd_Rek_Gab_108, NULL AS Nm_Aset5_108
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

) A, Ref_Pemda D
ORDER BY A.Kd_Rek_Gab_108, A.Kd_Rek_Gab_17



	




GO
