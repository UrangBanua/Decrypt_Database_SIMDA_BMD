USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE RptKontrakRealisasiPer_SKPD @Tahun varchar(4), @D1 datetime, @D2 datetime
WITH ENCRYPTION
AS
/*    
DECLARE @Tahun varchar(4), @D1 datetime, @D2 datetime
SET @Tahun = '2011'
SET @D1 = '20110601'
SET @D2 = '20111231'
*/ 
	SELECT  
		CONVERT(varchar (59), B.Nm_Sub_Unit) AS 'NAMA UNIT ORGANISASI (SKPD)', 
		CONVERT(char (21),(A.Nilai),1)AS 'NILAI KONTRAK',
		---CONVERT(char (20),(A.Nilai_Lalu),1)AS 'REALISASI LALU',
		---CONVERT(char (20),(A.Nilai_Ini),1) AS 'REALISASI INI',
		CONVERT(char (21),(A.Total),1) AS 'REALISASI',
		CONVERT(char (21),(A.Sisa),1)  AS 'SISA',
		CASE WHEN (A.Nilai) =0 THEN 100 ELSE convert (decimal (6,2),(A.Total)/(A.Nilai)*100) END as '(%)'
		
	FROM
		(
		SELECT A.Tahun, A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub,
			A.Nilai, ISNULL(B.Nilai_Lalu, 0) AS Nilai_Lalu, ISNULL(B.Nilai_Ini, 0) AS Nilai_Ini,
			ISNULL(B.Nilai_Lalu, 0) + ISNULL(B.Nilai_Ini, 0) AS Total,
			A.Nilai - (ISNULL(B.Nilai_Lalu, 0) + ISNULL(B.Nilai_Ini, 0)) AS Sisa
		FROM
			(
			SELECT A.Tahun, A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub,
				SUM(CASE
				WHEN B.Tahun IS NULL THEN A.Nilai
				ELSE B.Nilai
				END) AS Nilai
			FROM Ta_Kontrak A LEFT OUTER JOIN
				(
				SELECT A.Tahun, A.No_Kontrak, A.No_Addendum, A.Nilai
				FROM Ta_Kontrak_Addendum A INNER JOIN
					(
					SELECT MAX(CONVERT(varchar, Tgl_Addendum, 112) + No_Addendum) AS Kode
					FROM Ta_Kontrak_Addendum
					WHERE Tgl_Addendum <= @D2
					) B ON (CONVERT(varchar, Tgl_Addendum, 112) + No_Addendum) = Kode
				) B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak
			WHERE A.Tgl_Kontrak <= @D2
			GROUP BY A.Tahun, A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub
			) A LEFT OUTER JOIN
			(
			SELECT A.Tahun, B.Kd_Urusan, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub,
				SUM(CASE
				WHEN A.Tgl_SP2D < @D1 THEN C.Nilai
				ELSE 0
				END) AS Nilai_Lalu,
				SUM(CASE
				WHEN A.Tgl_SP2D < @D1 THEN 0
				ELSE C.Nilai
				END) AS Nilai_Ini
			FROM Ta_SP2D A INNER JOIN
				Ta_SPM B ON A.Tahun = B.Tahun AND A.No_SPM = B.No_SPM INNER JOIN
				Ta_SPM_Rinc C ON B.Tahun = C.Tahun AND B.No_SPM = C.No_SPM INNER JOIN
				Ta_SPP_Kontrak D ON B.Tahun = D.Tahun AND B.no_SPP = D.No_SPP
			WHERE A.Tahun = @Tahun AND A.Tgl_SP2D <= @D2
			GROUP BY A.Tahun, B.Kd_Urusan, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub
			) B ON A.Tahun = B.Tahun AND A.Kd_Urusan = B.Kd_Urusan AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub
		) A INNER JOIN
		Ref_Sub_Unit B ON A.Kd_Urusan = B.Kd_Urusan AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub,
		(
		SELECT Nm_Ka_Keu, Nip_Ka_Keu, Jbt_Ka_Keu
		FROM Ta_Pemda
		WHERE Tahun = @Tahun
		) C
	ORDER BY A.Tahun, A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub


GO
