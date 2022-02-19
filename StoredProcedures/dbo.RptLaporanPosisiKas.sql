USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE RptLaporanPosisiKas @Tahun varchar(4), @D1 datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @D1 datetime
SET @Tahun = '2008'
SET @D1 = '20080103'
*/
	DECLARE @D2 datetime
	SET @D2 = CONVERT(varchar, YEAR(@D1)) + '0101'

				
		SELECT 	b.kd_bank as 'NOMOR',
		b.nm_bank as 'NAMA BANK PENYIMPAN KAS DAERAH/NOMOR REKENING', 
		sum (Saldo) as 'SALDO BANK'
		
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

GO
