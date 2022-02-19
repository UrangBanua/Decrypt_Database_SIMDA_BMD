USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO


create PROCEDURE RptBendPengeluaran @Tahun varchar(4), @Kd_Urusan varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @D1 datetime, @Level tinyint, @Kd_Rek_1 varchar(1), @Kd_Rek_2 varchar(3), @Kd_Rek_3 varchar(3), @Kd_Rek_4 varchar(3), @Kd_Rek_5 varchar(3)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Urusan varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @D1 datetime, @Level tinyint, @Kd_Rek_1 varchar(1), @Kd_Rek_2 varchar(3), @Kd_Rek_3 varchar(3), @Kd_Rek_4 varchar(3), @Kd_Rek_5 varchar(3)
SET @Tahun = '2007'
SET @Kd_Urusan = ''
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @D1 = '20071231'
SET @Level = 5
SET @Kd_Rek_1 = '5'
SET @Kd_Rek_2 = '5'
SET @Kd_Rek_3 = '5'
SET @Kd_Rek_4 = '5'
SET @Kd_Rek_5 = '5'
*/
	IF ISNULL(@Kd_Urusan, '') = '' SET @Kd_Urusan = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_Rek_1, '') = '' SET @Kd_Rek_1 = '%'
	IF ISNULL(@Kd_Rek_2, '') = '' SET @Kd_Rek_2 = '%'
	IF ISNULL(@Kd_Rek_3, '') = '' SET @Kd_Rek_3 = '%'
	IF ISNULL(@Kd_Rek_4, '') = '' SET @Kd_Rek_4 = '%'
	IF ISNULL(@Kd_Rek_5, '') = '' SET @Kd_Rek_5 = '%'

	SELECT CONVERT(varchar (70),b.NM_SUB_UNIT)as 'Nama Satuan Kerja Perangkat Daerah (SKPD)',
		CONVERT(varchar (30),F.NAMA) AS 'Nama Bendaharawan', 
		CONVERT(char (18),(a.debet),1) AS 'Saldo Kas di Bendaharawan'
		
	FROM 
		(
		SELECT A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_Rek_Gab, A.Nm_Rek_Gab,
			SUM(CASE A.SaldoNorm
			WHEN 'D' THEN A.Debet - A.Kredit
			ELSE 0
			END) AS Debet,
			SUM(CASE A.SaldoNorm
			WHEN 'K' THEN A.Kredit - A.Debet
			ELSE 0
			END) AS Kredit
		FROM fn_SaldoAkhir(@Level, @D1, '%') A
		WHERE (A.Kd_Urusan LIKE @Kd_Urusan) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub)
			AND (A.Kd_Rek_1 LIKE @Kd_Rek_1) AND (A.Kd_Rek_2 LIKE @Kd_Rek_2) AND (A.Kd_Rek_3 LIKE @Kd_Rek_3) AND (A.Kd_Rek_4 LIKE @Kd_Rek_4) AND (A.Kd_Rek_5 LIKE @Kd_Rek_5)
			
		GROUP BY A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_Rek_Gab, A.Nm_Rek_Gab
		) A INNER JOIN
		Ref_Sub_Unit B ON A.Kd_Urusan = B.Kd_Urusan AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub INNER JOIN
		Ref_Unit C ON B.Kd_Urusan = C.Kd_Urusan AND B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit INNER JOIN
		Ref_Bidang D ON C.Kd_Urusan = D.Kd_Urusan AND C.Kd_Bidang = D.Kd_Bidang INNER JOIN
		Ref_Urusan E ON D.Kd_Urusan = E.Kd_Urusan INNER JOIN Ta_Sub_Unit_Jab F ON A.Kd_Urusan = F.Kd_Urusan AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit
	where (F.KD_JAB=4)AND F.TAHUN=@Tahun
	ORDER BY A.Kd_Rek_Gab, A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub


GO
