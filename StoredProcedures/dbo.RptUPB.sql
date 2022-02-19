USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[RptUPB] @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Level tinyint
WITH ENCRYPTION
AS
/*
DECLARE @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3)
SET @Kd_Prov = '30'
SET @Kd_Kab_Kota = '1'
*/
	SELECT A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
		RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) AS Kd_Gab_Bidang,
		RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + ' . ' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) AS Kd_Gab_Unit,
		RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + ' . ' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + ' . ' + CASE LEN(CONVERT(varchar, A.Kd_Sub)) WHEN 3 THEN CONVERT(varchar, A.Kd_Sub) ELSE RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) END AS Kd_Gab_Sub,
		RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + ' . ' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + ' . ' + CASE LEN(CONVERT(varchar, A.Kd_Sub)) WHEN 3 THEN CONVERT(varchar, A.Kd_Sub) ELSE RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2) END + ' . ' + CASE LEN(CONVERT(varchar, A.Kd_UPB)) WHEN 3 THEN CONVERT(varchar, A.Kd_UPB) ELSE RIGHT('0' + CONVERT(varchar, A.Kd_UPB), 2) END AS Kd_Gab_UPB,
		D.Nm_Bidang, C.Nm_Unit, B.Nm_Sub_Unit, A.Nm_UPB, E.Nm_Pemda, E.Logo
	FROM Ref_UPB A INNER JOIN
		Ref_Sub_Unit B ON A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub INNER JOIN
		Ref_Unit C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit INNER JOIN
		Ref_Bidang D ON C.Kd_Bidang = D.Kd_Bidang,
		(
		SELECT Nm_Pemda, Logo
		FROM Ref_Pemda
		WHERE (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota)
		) E
	ORDER BY A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB





GO
