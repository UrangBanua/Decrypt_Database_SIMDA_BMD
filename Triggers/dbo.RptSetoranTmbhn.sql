USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE RptSetoranTmbhn @Tahun varchar(4), 
@D1 datetime, @D2 datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Urusan varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @D1 datetime, @D2 datetime
SET @Tahun = '2008'
SET @Kd_Urusan = ''
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @D1 = '20080101'
SET @D2 = '20081231'
*/
	

	SELECT A.Tgl_Bukti AS 'TANGGAL',CONVERT(varchar (27), A.NM_SUB_UNIT) AS 'NAMA SKPD',
		---substring(CONVERT(varchar, A.Tgl_Bukti, 13),1,2)+''-''+ substring(CONVERT(varchar, A.Tgl_Bukti, 13),4,3)+''-''+substring(CONVERT(varchar, A.Tgl_Bukti, 13),8,4)AS 'A.Tgl_Bukti',
		CONVERT(varchar (20),A.No_Bukti) AS 'NOMOR BUKTI', 
		CONVERT(varchar (23),A.No_SPM) AS 'NOMOR SPM TU',
		CONVERT(varchar (25),A.Uraian) AS 'URAIAN TRANSAKSI',
		---CONVERT(char (21),(A.Nilai),1)AS 'NILAI KONTRAK',
                CONVERT(char (20), (A.Nilai),1) AS 'SALDO UP'
	FROM
		(
		SELECT A.Tahun, A.No_Bukti, A.Tgl_Bukti, B.No_SPM, A.Keterangan AS Uraian, A.Nilai, C.NM_SUB_UNIT
		FROM Ta_SPJ_Sisa A INNER JOIN
			Ta_SPJ B ON A.Tahun = B.Tahun AND A.No_SPJ = B.No_SPJ
	                INNER JOIN Ref_Sub_Unit C ON B.Kd_Urusan = C.Kd_Urusan AND B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_SUB = C.Kd_SUB
 			INNER JOIN Ref_Unit D ON B.Kd_Urusan = D.Kd_Urusan AND B.Kd_Bidang = D.Kd_Bidang AND B.Kd_Unit = D.Kd_Unit
		WHERE (B.Tahun = @Tahun) 
			AND (A.Tgl_Bukti BETWEEN @D1 AND @D2)
		) A
	ORDER BY A.Tgl_Bukti, A.No_Bukti




GO
