USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[RptMapRekSetting]
WITH ENCRYPTION
AS
	SELECT 
		CONVERT(varchar, A.Kd_Aset)+ '.' + CONVERT(varchar, A.Kd_Aset0)+ '.' + CONVERT(varchar, A.Kd_Aset1)+ '.' + CONVERT(varchar, A.Kd_Aset2)+ '.' + CONVERT(varchar, A.Kd_Aset3) AS Kd_Gab_1, A.Nm_Aset3,
		CONVERT(varchar, A.Kd_Rek_1)+ '.' + CONVERT(varchar, A.Kd_Rek_2)+ '.' + CONVERT(varchar, A.Kd_Rek_3)+ '.' + CONVERT(varchar, A.Kd_Rek_4) AS Kd_Gab_2, A.Nm_Rek_4,
		C.Nm_Pemda, C.Logo
		FROM (
		SELECT 1 AS KD, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, B.Nm_Aset3, 
		A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, C.Nm_Rek_4
		FROM Ref_Map_Rekening A INNER JOIN
		Ref_Rek3_108 B ON A.Kd_Aset = B.Kd_Aset AND A.Kd_Aset0 = B.Kd_Aset0 AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 
		INNER JOIN
		Ref_Rek_4 C ON A.Kd_Rek_1 = C.Kd_Rek_1 AND A.Kd_Rek_2 = C.Kd_Rek_2 AND A.Kd_Rek_3 = C.Kd_Rek_3 AND A.Kd_Rek_4 = C.Kd_Rek_4 

UNION
		SELECT 0 AS KD, A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Nm_Aset3, 
		A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Nm_Rek_4 FROM
		(
		SELECT A.Kd_Aset, A.Kd_Aset0, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Nm_Aset3, 
		' ' AS Kd_Rek_1, ' ' AS Kd_Rek_2, ' ' AS Kd_Rek_3, '' AS Kd_Rek_4, '' AS Nm_Rek_4
		FROM Ref_Rek3_108 A
		LEFT OUTER JOIN Ref_Map_Rekening B
		ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 
		INNER JOIN 
		(
		SELECT Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM (
		SELECT Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_KIB_B 
		GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83
		UNION
		SELECT Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_KIB_C 
		GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83
		UNION
		SELECT Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_KIB_D 
		GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83
		UNION
		SELECT Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_KIB_E 
		GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83
		UNION
		SELECT Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_KIB_F 
		GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83
		UNION
		SELECT Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83 FROM Ta_LAINNYA 
		GROUP BY Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83
		) A WHERE Kd_Aset8 = 1 AND Kd_Aset80=3
		) C 
		ON A.Kd_Aset1 = C.Kd_Aset81 AND A.Kd_Aset2 = C.Kd_Aset82 AND A.Kd_Aset3 = C.Kd_Aset83 
		WHERE A.KD_ASET=1 AND A.KD_ASET0=3 AND B.Kd_Aset1 IS NULL 
		) A )A ,  
		Ref_Pemda C
		ORDER BY KD
GO
