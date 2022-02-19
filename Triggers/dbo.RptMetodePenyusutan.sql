USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RptMetodePenyusutan] @Tahun varchar(4)
WITH ENCRYPTION
AS
/*
declare @tahun varchar(4)
set @tahun='2019'
*/
	IF OBJECT_ID('tempdb..#tmpRef_Penyusutan') IS NOT NULL
    DROP TABLE #tmpRef_Penyusutan

	SELECT @tahun AS Tahun, Null as Kd_Aset1, Null as Kd_Aset2, Null as Kd_Aset3, Null as Kd_Aset4, 0 as Metode, Null as Umur, Null as ThnPenyusutan, A.Kd_Aset as Kd_Aset8, A.Kd_Aset0 as Kd_Aset80, A.Kd_Aset1 as Kd_Aset81, A.Kd_Aset2 as Kd_Aset82, A.Kd_Aset3 as Kd_Aset83, A.Kd_Aset4 as Kd_Aset84 -- , D.Nm_Aset4 
	INTO #tmpRef_Penyusutan
	FROM 
		(SELECT A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4
		FROM Ref_Map5_17_108 A group by A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4 ) A
		LEFT OUTER JOIN 
		(SELECT * FROM Ref_Penyusutan WHERE Tahun=@Tahun) B 
		ON A.Kd_Aset = B.Kd_Aset8 AND A.Kd_Aset0 = B.Kd_Aset80 AND A.Kd_Aset1 = B.Kd_Aset81 AND A.Kd_Aset2 = B.Kd_Aset82 AND A.Kd_Aset3 = B.Kd_Aset83 AND A.Kd_Aset4 = B.Kd_Aset84
		INNER JOIN 
		(
		SELECT Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84 FROM Ta_KIB_B 
		GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84
		UNION
		SELECT Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84 FROM Ta_KIB_C 
		GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84
		UNION
		SELECT Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84 FROM Ta_KIB_D 
		GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84
		UNION
		SELECT Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84 FROM Ta_KIB_E 
		GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84
		UNION
		SELECT Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84 FROM Ta_KIB_F 
		GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84
		UNION
		SELECT Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84 FROM Ta_LAINNYA 
		GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84
		) C 
		ON A.Kd_Aset = C.Kd_Aset8 AND A.Kd_Aset0 = C.Kd_Aset80 AND A.Kd_Aset1 = C.Kd_Aset81 AND A.Kd_Aset2 = C.Kd_Aset82 AND A.Kd_Aset3 = C.Kd_Aset83 AND A.Kd_Aset4 = C.Kd_Aset84
		INNER JOIN Ref_Rek4_108 D
		ON A.Kd_Aset = D.Kd_Aset AND A.Kd_Aset0 = D.Kd_Aset0 AND A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4
	WHERE A.Kd_Aset= 1 AND A.Kd_Aset0 IN (3,5) AND NOT
	(A.Kd_Aset= 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 1) AND NOT (A.Kd_Aset= 1 AND A.Kd_Aset0 = 3 AND A.Kd_Aset1 = 5 AND A.Kd_Aset2 <> 7) AND B.Kd_Aset8 IS NULL
	
	SELECT '0' + CONVERT(varchar, A.Kd_Aset) + '.' + '0' + CONVERT(varchar, A.Kd_Aset0) + '.' + '0' + CONVERT(varchar, A.Kd_Aset1) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset2), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset3), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Aset4), 2)AS Kd_Gab,
		A.Nm_Aset4,
		CASE B.Metode
		WHEN 1 THEN 'Garis Lurus'
		WHEN 2 THEN 'Saldo Menurun Ganda' 
		ELSE ''
		END AS Metode, B.Umur,
		C.*
	FROM Ref_Rek4_108 A LEFT OUTER JOIN
		(SELECT Tahun, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Metode, Umur, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84 FROM Ref_Penyusutan 
		 UNION
		 SELECT Tahun, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Metode, Umur, ThnPenyusutan, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84 from #tmpRef_Penyusutan
		)B ON A.Kd_Aset = B.Kd_Aset8 AND A.Kd_Aset0 = B.Kd_Aset80 AND A.Kd_Aset1 = B.Kd_Aset81 AND A.Kd_Aset2 = B.Kd_Aset82 AND A.Kd_Aset3 = B.Kd_Aset83 AND A.Kd_Aset4 = B.Kd_Aset84,
		(
		SELECT Nm_Pemda, NULL AS Logo
		FROM Ref_Pemda
		) C
	WHERE B.Tahun = @Tahun
	ORDER BY CASE ISNULL(B.umur, '') WHEN '' THEN 0 ELSE 1 END, CASE ISNULL(B.Metode, '') WHEN '' THEN 0 ELSE 1 END, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3







GO
