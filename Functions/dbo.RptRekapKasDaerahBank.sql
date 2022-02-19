USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE RptRekapKasDaerahBank @D1 datetime
WITH ENCRYPTION
AS
/*
DECLARE @D1 datetime
SET @D1 = '20071231'
*/
	DECLARE @Jurnal TABLE(Kd_Bank tinyint, Debet money, Kredit money)

	INSERT INTO @Jurnal
	SELECT B.Kd_Bank, 0, SUM(C.Nilai)
	FROM Ta_Cheque A INNER JOIN
		Ta_SP2D B ON A.Tahun = B.Tahun AND A.No_SP2D = B.No_SP2D INNER JOIN
		(
		SELECT Tahun, No_SPM, SUM(Nilai) AS Nilai
		FROM
			(
			SELECT Tahun, No_SPM, SUM(Nilai) AS Nilai
			FROM Ta_SPM_Rinc
			GROUP BY Tahun, No_SPM
	
			UNION ALL
	
			SELECT A.Tahun, A.No_SPM, -SUM(Nilai) AS Nilai
			FROM Ta_SPM_Pot A INNER JOIN
				(
				SELECT Tahun, No_SPM, MAX(CASE WHEN Kd_Rek_1 = 5 AND Kd_Rek_2 = 1 AND Kd_Rek_3 = 1 AND Kd_Rek_4 = 1 THEN 1 ELSE 0 END) AS Gaji
				FROM Ta_SPM_Rinc
				GROUP BY Tahun, No_SPM
				) B ON A.Tahun = B.Tahun AND A.No_SPM = B.No_SPM LEFT OUTER JOIN
				Ref_Setting C ON B.Tahun = C.Tahun
			WHERE ((ISNULL(C.PFK, 0) = 0) OR ((ISNULL(C.PFK, 0) = 1) AND B.Gaji = 1))
			GROUP BY A.Tahun, A.No_SPM
			) A
		GROUP BY Tahun, No_SPM
		) C ON B.Tahun = C.Tahun AND B.No_SPM = C.No_SPM
	WHERE A.Tgl_Cair <= @D1
	GROUP BY B.Kd_Bank

	INSERT INTO @Jurnal
	SELECT B.Kd_Bank, 0, SUM(A.Nilai)
	FROM Ta_Cheque_Non A INNER JOIN
		Ta_SP2D_Non B ON A.Tahun = B.Tahun AND A.No_SP2D = B.No_SP2D
	WHERE A.Tgl_Cair <= @D1
	GROUP BY B.Kd_Bank

	INSERT INTO @Jurnal
	SELECT B.Kd_Bank, SUM(A.Nilai), 0
	FROM Ta_STS_Rinc A INNER JOIN
		Ta_STS B ON A.Tahun = B.Tahun AND A.No_STS = B.No_STS
	WHERE B.Tgl_STS <= @D1
	GROUP BY B.Kd_Bank

	INSERT INTO @Jurnal
	SELECT A.Kd_Bank, SUM(A.Nilai), 0
	FROM Ta_Realisasi_Pembiayaan A
	WHERE A.Tgl_Bukti <= @D1
	GROUP BY A.Kd_Bank

	INSERT INTO @Jurnal
	SELECT A.Kd_Bank, SUM(A.Nilai), 0
	FROM Ta_SPJ_Sisa A
	WHERE A.Tgl_Bukti <= @D1
	GROUP BY A.Kd_Bank

	INSERT INTO @Jurnal
	SELECT A.Kd_Bank, SUM(A.Debet), SUM(A.Kredit)
	FROM
		(
		SELECT C.Kd_Bank,
			CASE A.D_K
			WHEN 'D' THEN A.Nilai
			ELSE 0
			END AS Debet,
			CASE A.D_K
			WHEN 'K' THEN A.Nilai
			ELSE 0
			END AS Kredit
		FROM Ta_Jurnal_Rinc A INNER JOIN
			Ta_Jurnal B ON A.Tahun = B.Tahun AND A.No_Bukti = B.No_Bukti INNER JOIN
			Ref_Bank C ON A.Kd_Rek_1 = C.Kd_Rek_1 AND A.Kd_Rek_2 = C.Kd_Rek_2 AND A.Kd_Rek_3 = C.Kd_Rek_3 AND A.Kd_Rek_4 = C.Kd_Rek_4 AND A.Kd_Rek_5 = C.Kd_Rek_5
		WHERE B.Tgl_Bukti <= @D1
		) A
	GROUP BY A.Kd_Bank

	INSERT INTO @Jurnal
	SELECT B.Kd_Bank, 
		SUM(CASE
		WHEN B.Jns_P1 = 1 AND B.Jns_P2 = 3 THEN A.Nilai
		WHEN B.Jns_P1 = 2 AND B.Jns_P2 = 2 THEN A.Nilai
		ELSE 0
		END),
		SUM(CASE
		WHEN B.Jns_P1 = 1 AND B.Jns_P2 = 2 THEN A.Nilai
		WHEN B.Jns_P1 = 2 AND B.Jns_P2 = 3 THEN A.Nilai
		ELSE 0
		END)
	FROM Ta_Penyesuaian_Rinc A INNER JOIN
		Ta_Penyesuaian B ON A.Tahun = B.Tahun AND A.No_Bukti = B.No_Bukti
	WHERE (B.Tgl_Bukti <= @D1) AND (B.Jns_P2 IN (2, 3))
	GROUP BY B.Kd_Bank

	INSERT INTO @Jurnal
	SELECT A.Kd_Bank, 
		SUM(CASE A.D_K
		WHEN 'D' THEN A.Nilai
		ELSE 0
		END), 
		SUM(CASE A.D_K
		WHEN 'D' THEN 0
		ELSE A.Nilai
		END)
	FROM Ta_S3UP A
	WHERE A.Tgl_Bukti <= @D1
	GROUP BY A.Kd_Bank

	SELECT 
	CONVERT(varchar (50),A.Nm_Bank) AS 'NAMA BANK PENYIMPAN KAS DAERAH/NOMOR REKENING',
	CONVERT(varchar (25),A.No_Rekening) AS 'NOMOR REKENING',
	CONVERT(CHAR (21),SUM(A.Saldo),1) AS 'SALDO BANK'

	FROM
		(
		SELECT B.Kd_Bank, B.Nm_Bank, B.No_Rekening,
			CASE D_K
			WHEN 'D' THEN Saldo
			ELSE -Saldo
			END AS Saldo
		FROM Ta_Saldo_Awal A INNER JOIN
			Ref_Bank B ON A.Kd_Rek_1 = B.Kd_Rek_1 AND A.Kd_Rek_2 = B.Kd_Rek_2 AND A.Kd_Rek_3 = B.Kd_Rek_3 AND A.Kd_Rek_4 = B.Kd_Rek_4 AND A.Kd_Rek_5 = B.Kd_Rek_5
		WHERE A.Tahun = YEAR(@D1) - 1

		UNION ALL

		SELECT B.Kd_Bank, B.Nm_Bank, B.No_Rekening,
			A.Debet - A.Kredit AS Saldo
		FROM @Jurnal A INNER JOIN
			Ref_Bank B ON A.Kd_Bank = B.Kd_Bank
		) A
	GROUP BY A.Kd_Bank, A.Nm_Bank, A.No_Rekening
	ORDER BY A.Kd_Bank


GO
