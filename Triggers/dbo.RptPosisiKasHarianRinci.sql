USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE RptPosisiKasHarianRinci @Tahun varchar(4), @D1 datetime  ---TES MAU SUM tambahan baru harus masuk dalam sml
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @D1 datetime
SET @Tahun = '2008'
SET @D1 = '20080103'
*/
	DECLARE @D2 datetime
	SET @D2 = CONVERT(varchar, YEAR(@D1)) + '0101'
--/*
	SELECT 
	CONVERT(varchar (20),A.No_Bukti) AS 'NOMOR BUKTI TRANSAKSI', --25
	CONVERT(varchar (20),A.Keterangan) AS 'KETERANGAN', ---39
	CONVERT(char (21),SUM(A.Penerimaan),1) AS 'PENERIMAAN',
	CONVERT(char (21),SUM(A.Pengeluaran),1) AS 'PENGELUARAN',
	CONVERT(char (21),SUM(A.AKHIR),1) AS 'SALDO',
	---CONVERT(char (21),SUM(A.Saldo),1) AS 'SALDO',
	CONVERT(char (21),SUM(A.COCOK),1) AS 'RINC. SALDO BANK'

		
	FROM
		(
		SELECT A.No_BKU,
			CASE A.Kd_Source
			WHEN 3 THEN 'SP2D: ' + A.No_Bukti
			WHEN 4 THEN 'SP2D: ' + A.No_Bukti
			WHEN 2 THEN 'STS : ' + A.No_Bukti
			WHEN 14 THEN 'STS : ' + A.No_Bukti
			WHEN 15 THEN 'STS : ' + A.No_Bukti
			ELSE 'LL  : ' + A.No_Bukti
			END AS No_Bukti,
			A.Keterangan, A.Penerimaan, A.Pengeluaran, (B.Saldo), C.AKHIR,0 AS COCOK
		FROM
			(
			SELECT B.Tahun, B.Kd_Source, B.No_Bukti, B.Keterangan, B.No_BKU, SUM(A.Debet) AS Penerimaan, SUM(A.Kredit) AS Pengeluaran
			FROM Ta_JurnalSemua_Rinc A INNER JOIN
				Ta_JurnalSemua B ON A.Tahun = B.Tahun AND A.No_Bukti = B.No_Bukti AND A.Kd_Source = B.Kd_Source
			WHERE A.Tahun = @Tahun AND B.Tgl_Bukti = @D1 AND A.Kd_Rek_1 = 1 AND A.Kd_Rek_2 = 1 AND A.Kd_Rek_3 = 1 AND A.Kd_Rek_4 = 1
			GROUP BY B.Tahun, B.Kd_Source, B.No_Bukti, B.Keterangan, B.No_BKU
			) A,
			(
			SELECT SUM(Saldo) AS Saldo
			FROM
				(
				SELECT 0 AS Saldo
	
				UNION ALL
	
				SELECT Debet - Kredit AS Saldo
				FROM fn_SaldoAwal(4, @D2, '%') A
				WHERE A.Kd_Rek_1 = 1 AND A.Kd_Rek_2 = 1 AND A.Kd_Rek_3 = 1 AND A.Kd_Rek_4 = 1
			
				UNION ALL
			
				SELECT SUM(A.Debet - A.Kredit) AS Saldo
				FROM Ta_JurnalSemua_Rinc A INNER JOIN
					Ta_JurnalSemua B ON A.Tahun = B.Tahun AND A.No_Bukti = B.No_Bukti AND A.Kd_Source = B.Kd_Source
				WHERE A.Tahun = @Tahun AND B.Tgl_Bukti < @D1 AND A.Kd_Rek_1 = 1 AND A.Kd_Rek_2 = 1 AND A.Kd_Rek_3 = 1 AND A.Kd_Rek_4 = 1
				) A
			) B,
                        (
			(
			SELECT A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5, SUM(A.Debet - A.Kredit) AS Akhir
			FROM fn_SaldoAwal(5, @D2, '%') A
			WHERE A.Kd_Rek_1 = 1 AND A.Kd_Rek_2 = 1 AND A.Kd_Rek_3 = 1 AND A.Kd_Rek_4 = 1
			GROUP BY A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5
	
			UNION ALL
	
			SELECT A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5, SUM(A.Debet - A.Kredit) AS Akhir
			FROM Ta_JurnalSemua_Rinc A INNER JOIN
				Ta_JurnalSemua B ON A.Tahun = B.Tahun AND A.No_Bukti = B.No_Bukti AND A.Kd_Source = B.Kd_Source
			WHERE A.Tahun = @Tahun AND B.Tgl_Bukti <= @D1 AND A.Kd_Rek_1 = 1 AND A.Kd_Rek_2 = 1 AND A.Kd_Rek_3 = 1 AND A.Kd_Rek_4 = 1
			GROUP BY A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5
			) ---X INNER JOIN
			--Ref_Bank X ON A.Kd_Rek_1 = X.Kd_Rek_1 AND A.Kd_Rek_2 = X.Kd_Rek_2 AND A.Kd_Rek_3 = X.Kd_Rek_3 AND A.Kd_Rek_4 = X.Kd_Rek_4 AND A.Kd_Rek_5 = X.Kd_Rek_5
		---GROUP BY X.Kd_Bank, X.Nm_Bank, X.No_Rekening)
			)C


	
		UNION ALL


		SELECT  B.Kd_Bank AS No_BKU, '', B.Nm_Bank + ' ' + B.No_Rekening AS Keterangan, 0 AS Penerimaan, 0 AS Pengeluaran, 
		0 AS Saldo, 0 AS AKHIR,SUM(A.Saldo) AS COCOK  -----SALDO BANK
		FROM
			(
			SELECT A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5, SUM(Debet - Kredit) AS Saldo
			FROM fn_SaldoAwal(5, @D2, '%') A
			WHERE A.Kd_Rek_1 = 1 AND A.Kd_Rek_2 = 1 AND A.Kd_Rek_3 = 1 AND A.Kd_Rek_4 = 1
			GROUP BY A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5
	
			UNION ALL
	
			SELECT A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5, SUM(A.Debet - A.Kredit) AS Saldo
			FROM Ta_JurnalSemua_Rinc A INNER JOIN
				Ta_JurnalSemua B ON A.Tahun = B.Tahun AND A.No_Bukti = B.No_Bukti AND A.Kd_Source = B.Kd_Source
			WHERE A.Tahun = @Tahun AND B.Tgl_Bukti <= @D1 AND A.Kd_Rek_1 = 1 AND A.Kd_Rek_2 = 1 AND A.Kd_Rek_3 = 1 AND A.Kd_Rek_4 = 1
			GROUP BY A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5
			) A INNER JOIN
			Ref_Bank B ON A.Kd_Rek_1 = B.Kd_Rek_1 AND A.Kd_Rek_2 = B.Kd_Rek_2 AND A.Kd_Rek_3 = B.Kd_Rek_3 AND A.Kd_Rek_4 = B.Kd_Rek_4 AND A.Kd_Rek_5 = B.Kd_Rek_5
		GROUP BY B.Kd_Bank, B.Nm_Bank, B.No_Rekening

		/*
		UNION ALL

		SELECT '', '', '' , 0 AS Penerimaan, 0 AS Pengeluaran, 0 AS Saldo, SUM (A.Akhir),0 AS COCOK  ----SALDO AKHIR BERDIRI SENDIRI
		FROM
			(
			SELECT A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5, SUM(A.Debet - A.Kredit) AS Akhir
			FROM fn_SaldoAwal(5, @D2, '%') A
			WHERE A.Kd_Rek_1 = 1 AND A.Kd_Rek_2 = 1 AND A.Kd_Rek_3 = 1 AND A.Kd_Rek_4 = 1
			GROUP BY A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5
	
			UNION ALL
	
			SELECT A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5, SUM(A.Debet - A.Kredit) AS Akhir
			FROM Ta_JurnalSemua_Rinc A INNER JOIN
				Ta_JurnalSemua B ON A.Tahun = B.Tahun AND A.No_Bukti = B.No_Bukti AND A.Kd_Source = B.Kd_Source
			WHERE A.Tahun = @Tahun AND B.Tgl_Bukti <= @D1 AND A.Kd_Rek_1 = 1 AND A.Kd_Rek_2 = 1 AND A.Kd_Rek_3 = 1 AND A.Kd_Rek_4 = 1
			GROUP BY A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5
			) A INNER JOIN
			Ref_Bank B ON A.Kd_Rek_1 = B.Kd_Rek_1 AND A.Kd_Rek_2 = B.Kd_Rek_2 AND A.Kd_Rek_3 = B.Kd_Rek_3 AND A.Kd_Rek_4 = B.Kd_Rek_4 AND A.Kd_Rek_5 = B.Kd_Rek_5
		GROUP BY B.Kd_Bank, B.Nm_Bank, B.No_Rekening*/
		
		) A,
		(
		SELECT Nm_Ka_BUD, Nip_Ka_BUD, Jbt_Ka_BUD, Ibukota
		FROM Ta_Pemda
		WHERE Tahun = @Tahun
		) B
	GROUP BY A.No_Bukti,A.Keterangan,A.Saldo,A.Penerimaan,A.Pengeluaran,A.No_BKU
	ORDER BY No_BKU
			

			

GO
