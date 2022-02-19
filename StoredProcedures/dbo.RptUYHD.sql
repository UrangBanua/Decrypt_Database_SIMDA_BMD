USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE RptUYHD @Tahun varchar(4) -----OK
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4)
SET @Tahun = '2011'
*/
	DECLARE @tmpUP TABLE(Kd_Urusan tinyint, Kd_Bidang tinyint, Kd_Unit tinyint, Kd_Sub smallint, UP money, NIHIL money, Saldo money, Setor money)
	DECLARE @D1 datetime

	SET @D1 = @Tahun + '0101'

	INSERT INTO @tmpUP
	SELECT A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, SUM(A.Nilai) AS UP, 0, 0, 0
	FROM Ta_SPM_Rinc A INNER JOIN
		Ta_SPM B ON A.Tahun = B.Tahun AND A.No_SPM = B.No_SPM INNER JOIN
		Ta_SP2D C ON B.Tahun = C.Tahun AND B.No_SPM = C.No_SPM
	WHERE (B.Tahun = @Tahun) AND (B.Jn_SPM = 1)
	GROUP BY A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub

	INSERT INTO @tmpUP
	SELECT A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 0, SUM(A.Nilai) AS NIHIL, 0, 0
	FROM Ta_SPM_Rinc A INNER JOIN
		Ta_SPM B ON A.Tahun = B.Tahun AND A.No_SPM = B.No_SPM INNER JOIN
		Ta_SPP C ON B.Tahun = C.Tahun AND B.No_SPP = C.No_SPP INNER JOIN
		Ta_Pengesahan_SPJ D ON C.Tahun = D.Tahun AND C.No_SPJ = D.No_Pengesahan INNER JOIN
		Ta_SPJ E ON D.Tahun = E.Tahun AND D.No_SPJ = E.No_SPJ INNER JOIN
		Ta_SP2D F ON B.Tahun = F.Tahun AND B.No_SPM = F.No_SPM
	WHERE (A.Tahun = @Tahun) AND (E.Jn_SPJ = 2) AND (B.Jn_SPM = 5)
	GROUP BY A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub

	INSERT INTO @tmpUP
	SELECT A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 0, 0, SUM(A.Debet - A.Kredit), 0
	FROM fn_SaldoAwal(4, @D1, '%') A
	WHERE (A.Kd_Rek_1 = 1 AND A.Kd_Rek_2 = 1 AND A.Kd_Rek_3 = 1 AND A.Kd_Rek_4 = 3)
	GROUP BY A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub

	INSERT INTO @tmpUP
	SELECT A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 0, 0, SUM(A.Debet - A.Kredit), 0
	FROM fn_SaldoAwal(4, @D1, '%') A LEFT OUTER JOIN 
		Ref_Setting B ON. A.Tahun = B.Tahun AND A.Kd_Urusan = B.Kd_Urusan AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub
	WHERE (B.Tahun IS NULL) AND ((A.Kd_Rek_1 = 2 AND A.Kd_Rek_2 = 1 AND A.Kd_Rek_3 = 1)
		OR (A.Kd_Rek_1 = 1 AND A.Kd_Rek_2 = 1 AND A.Kd_Rek_3 = 1 AND A.Kd_Rek_4 = 2)
		OR (A.Kd_Rek_1 = 3 AND A.Kd_Rek_2 = 1 AND A.Kd_Rek_3 = 5))
	GROUP BY A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub

	INSERT INTO @tmpUP
	SELECT A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 0, 0, SUM(A.Debet - A.Kredit), 0
	FROM fn_SaldoAwal(4, @D1, '%') A INNER JOIN 
		Ref_Setting B ON. A.Tahun = B.Tahun AND A.Kd_Urusan = B.Kd_Urusan AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub
	WHERE ((A.Kd_Rek_1 = 1 AND A.Kd_Rek_2 = 1 AND A.Kd_Rek_3 = 1 AND A.Kd_Rek_4 = 2)
		OR (A.Kd_Rek_1 = 3 AND A.Kd_Rek_2 = 1 AND A.Kd_Rek_3 = 5))
	GROUP BY A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub

	INSERT INTO @tmpUP
	SELECT A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, 0, 0, 0, SUM(A.Nilai) AS Setor
	FROM Ta_S3UP A
	WHERE (A.Tahun = @Tahun) AND (YEAR(A.Tgl_Bukti) = @Tahun)
	GROUP BY A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub

	SELECT 
           	---CONVERT (VARCHAR (4),(CONVERT(varchar, A.Kd_Urusan) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Bidang), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Unit), 2) + '.' + RIGHT('0' + CONVERT(varchar, A.Kd_Sub), 2))) AS 'KODE',
		CONVERT(varchar (15),B.Nm_Sub_Unit) as 'NAMA SKPD',
		CONVERT(char (20), A.UP,1) AS 'BESAR SP2D UP',
		CONVERT(char (20), A.NIHIL,1) AS 'SPJ NIHIL',
		CONVERT(char (20), A.UP - A.NIHIL,1) AS 'SALDO THN INI',
		CONVERT(char (20), A.Saldo,1) AS 'UP THN LALU',
		CONVERT(char (20), A.Setor,1) AS 'SETORAN UP',
		CONVERT(char (20), (A.UP - A.NIHIL + A.Saldo - A.Setor),1) AS 'SALDO UP'
  		 
	FROM
		(
		SELECT A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, SUM(A.UP) AS UP, SUM(A.NIHIL) AS NIHIL, SUM(A.Saldo) AS Saldo, SUM(A.Setor) AS Setor
		FROM @tmpUP A LEFT OUTER JOIN 
			Ref_BLU C ON A.Kd_Urusan = C.Kd_Urusan AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub
		WHERE (C.Kd_Urusan IS NULL)
		GROUP BY A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub
		) A INNER JOIN
		Ref_Sub_Unit B ON A.Kd_Urusan = B.Kd_Urusan AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub



GO
