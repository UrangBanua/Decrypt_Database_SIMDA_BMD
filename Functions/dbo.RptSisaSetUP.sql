USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE RptSisaSetUP @Tahun varchar(4), @D2 datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Urusan varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @D1 datetime, @D2 datetime
SET @Tahun = '2008'
SET @Kd_Urusan = ''
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @D2 = '20081231'
*/
	
	SELECT 
		A.Tgl_Bukti AS 'TANGGAL',
                CONVERT(varchar (40), A.NM_SUB_UNIT) AS 'NAMA SKPD' ,
		CONVERT(varchar (25),A.No_Bukti) AS 'NOMOR BUKTI', 
		CONVERT(varchar (30),A.Uraian) AS 'URAIAN TRANSAKSI',
                CONVERT(char (20), (A.Nilai),1) AS 'SALDO UP'
		
		
	FROM
		(
		SELECT A.Tahun, A.No_Bukti, A.Tgl_Bukti, A.Keterangan AS Uraian, A.Nilai, D.NM_UNIT, C.NM_SUB_UNIT
		FROM Ta_S3UP A
		INNER JOIN Ref_Sub_Unit C ON A.Kd_Urusan = C.Kd_Urusan AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_SUB = C.Kd_SUB
 		INNER JOIN Ref_Unit D ON A.Kd_Urusan = D.Kd_Urusan AND A.Kd_Bidang = D.Kd_Bidang AND A.Kd_Unit = D.Kd_Unit
		WHERE (A.Tahun = @Tahun) 
		) A 
		
	ORDER BY A.Tgl_Bukti, A.No_Bukti


GO
