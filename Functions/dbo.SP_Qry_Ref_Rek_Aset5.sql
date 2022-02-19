USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/****** Encrypted object is not transferable, and script can not be generated. ******/

/***
Deskripsi Store Procedure :
Nama		: SP_Qry_Ref_Rek_Aset5
Form		: F_Up_Rekening
Keterangan	: Di gunakan di Form F_Up_Rekening untuk cari rekening
Dibuat		: 22/11/2006 23:29:00
Oleh		: Iman
***/

CREATE PROCEDURE [dbo].[SP_Qry_Ref_Rek_Aset5] @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Filter varchar(50)
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Filter varchar(50)
SET @Kd_Aset1 = '4' 
SET @Kd_Aset2 = '4' 
SET @Filter = ''
*/
IF @Kd_Aset1 = '10' --mapping 108--
BEGIN

	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A LEFT OUTER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1=B.Kd1 AND A.Kd_Aset2=B.Kd2 AND A.Kd_Aset3=B.Kd3 AND A.Kd_Aset4=B.Kd4 AND A.Kd_Aset5=B.Kd5
		WHERE A.Kd_Aset1 = 1 AND B.Kd1 IS NULL AND (A.Nm_Aset5 LIKE '%' + @Filter + '%')
		) A INNER JOIN Ta_KIB_A B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A LEFT OUTER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1=B.Kd1 AND A.Kd_Aset2=B.Kd2 AND A.Kd_Aset3=B.Kd3 AND A.Kd_Aset4=B.Kd4 AND A.Kd_Aset5=B.Kd5
		WHERE A.Kd_Aset1 = 2 AND B.Kd1 IS NULL AND (A.Nm_Aset5 LIKE '%' + @Filter + '%')
		) A INNER JOIN Ta_KIB_B B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A LEFT OUTER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1=B.Kd1 AND A.Kd_Aset2=B.Kd2 AND A.Kd_Aset3=B.Kd3 AND A.Kd_Aset4=B.Kd4 AND A.Kd_Aset5=B.Kd5
		WHERE A.Kd_Aset1 = 3 AND B.Kd1 IS NULL AND (A.Nm_Aset5 LIKE '%' + @Filter + '%')
		) A INNER JOIN Ta_KIB_C B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A LEFT OUTER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1=B.Kd1 AND A.Kd_Aset2=B.Kd2 AND A.Kd_Aset3=B.Kd3 AND A.Kd_Aset4=B.Kd4 AND A.Kd_Aset5=B.Kd5
		WHERE A.Kd_Aset1 = 4 AND B.Kd1 IS NULL AND (A.Nm_Aset5 LIKE '%' + @Filter + '%')
		) A INNER JOIN Ta_KIB_D B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A LEFT OUTER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1=B.Kd1 AND A.Kd_Aset2=B.Kd2 AND A.Kd_Aset3=B.Kd3 AND A.Kd_Aset4=B.Kd4 AND A.Kd_Aset5=B.Kd5
		WHERE A.Kd_Aset1 = 5 AND B.Kd1 IS NULL AND (A.Nm_Aset5 LIKE '%' + @Filter + '%')
		) A INNER JOIN Ta_KIB_E B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A LEFT OUTER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1=B.Kd1 AND A.Kd_Aset2=B.Kd2 AND A.Kd_Aset3=B.Kd3 AND A.Kd_Aset4=B.Kd4 AND A.Kd_Aset5=B.Kd5
		WHERE B.Kd1 IS NULL AND (A.Nm_Aset5 LIKE '%' + @Filter + '%')
		) A INNER JOIN Ta_KIB_F B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5
	UNION ALL
	SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, MAX(A.Nm_Aset5) AS Nm_Aset5
	FROM (
		SELECT A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Nm_Aset5
		FROM Ref_Rek_Aset5 A LEFT OUTER JOIN Ref_Map5_17_108 B 
		ON A.Kd_Aset1=B.Kd1 AND A.Kd_Aset2=B.Kd2 AND A.Kd_Aset3=B.Kd3 AND A.Kd_Aset4=B.Kd4 AND A.Kd_Aset5=B.Kd5
		WHERE B.Kd1 IS NULL AND (A.Nm_Aset5 LIKE '%' + @Filter + '%')
		) A INNER JOIN Ta_Lainnya B 
			ON A.Kd_Aset1=B.Kd_Aset1 AND A.Kd_Aset2=B.Kd_Aset2 AND A.Kd_Aset3=B.Kd_Aset3 AND A.Kd_Aset4=B.Kd_Aset4 AND A.Kd_Aset5=B.Kd_Aset5
	GROUP BY A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5

END
ELSE 
IF @Kd_Aset1 = '11' --mapping 108--
BEGIN
	SELECT Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Nm_Aset5
	FROM Ref_Rek5_108
	WHERE (Nm_Aset5 LIKE '%' + @Filter + '%')
	AND IDData = dbo.fn_KdLokasi5(Kd_Aset, Kd_Aset0, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5)
END
ELSE 
BEGIN
	SELECT Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Nm_Aset5
	FROM Ref_Rek_Aset5
	WHERE (Kd_Aset1 = @Kd_Aset1) AND (Kd_Aset2 LIKE @Kd_Aset2) AND (Nm_Aset5 LIKE '%' + @Filter + '%')
END



GO
