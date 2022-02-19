USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO

create PROCEDURE RptSP2DTUBELMSPJ_REKAP @Tahun varchar(4), @Kd_Urusan varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @D1 datetime
WITH ENCRYPTION  ----OK
AS
/*
DECLARE @Tahun varchar(4), @Kd_Urusan varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @D1 datetime
SET @Tahun = '2007'
SET @Kd_Urusan = ''
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @D1 = '20071231'
*/
	IF ISNULL(@Kd_Urusan, '') = '' SET @Kd_Urusan = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'

	SELECT  
		CONVERT(varchar (40),C.NM_SUB_UNIT) AS 'NAMA UNIT ORGANISASI/SKPD',
		CONVERT(varchar (15), A.No_SP2D) AS 'NOMOR SP2D TU',
                substring(CONVERT(varchar, A.Tgl_SP2D, 13),1,2)+'-'+ substring(CONVERT(varchar, A.Tgl_SP2D, 13),4,3)+'-'+substring(CONVERT(varchar, A.Tgl_SP2D, 13),8,4) AS 'TGL SP2D',
		CONVERT(varchar (40), B.Ket_Kegiatan) AS 'NAMA KEGIATAN', 
		CONVERT (VARCHAR (5), DATEDIFF(day, A.Tgl_SP2D, @D1)) AS 'LAMA',
		CONVERT(char (19),(A.Nilai_spm),1)AS 'JUMLAH'
	FROM
		(
		SELECT A.Tahun, A.No_SP2D, A.Tgl_SP2D, A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_Prog, A.ID_Prog, A.Kd_Keg, A.Nilai_SPM
		FROM
			(
			SELECT A.Tahun, A.No_SPM, C.No_SP2D, C.Tgl_SP2D, A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_Prog, A.ID_Prog, A.Kd_Keg, SUM(A.Nilai) AS Nilai_SPM
			FROM Ta_SPM_Rinc A INNER JOIN
				Ta_SPM B ON A.Tahun = B.Tahun AND A.No_SPM = B.No_SPM INNER JOIN
				Ta_SP2D C ON B.Tahun = C.Tahun AND B.No_SPM = C.No_SPM
			WHERE (A.Tahun = @Tahun) AND (A.Kd_Urusan LIKE @Kd_Urusan) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub)
				 AND (B.Jn_SPM = 4) AND (C.Tgl_SP2D <= @D1)
			GROUP BY A.Tahun, A.No_SPM, C.No_SP2D, C.Tgl_SP2D, A.Kd_Urusan, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_Prog, A.ID_Prog, A.Kd_Keg
			) A LEFT OUTER JOIN
			(
			SELECT A.Tahun, A.No_SPM
			FROM Ta_SPJ A INNER JOIN
				Ta_Pengesahan_SPJ B ON A.Tahun = B.Tahun AND A.No_SPJ = B.No_SPJ
			WHERE (A.Jn_SPJ = 4) AND (A.Tahun = @Tahun) AND (A.Kd_Urusan LIKE @Kd_Urusan) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub)
			GROUP BY A.Tahun, A.No_SPM
			) B ON A.Tahun = B.Tahun AND A.No_SPM = B.No_SPM
		WHERE B.Tahun IS NULL
		) A INNER JOIN
		Ta_Kegiatan B ON A.Tahun = B.Tahun AND A.Kd_Urusan = B.Kd_Urusan AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_Prog = B.Kd_Prog AND A.ID_Prog = B.ID_Prog AND A.Kd_Keg = B.Kd_Keg INNER JOIN
		Ta_Program F ON B.Tahun = F.Tahun AND B.Kd_Urusan = F.Kd_Urusan AND B.Kd_Bidang = F.Kd_Bidang AND B.Kd_Unit = F.Kd_Unit AND B.Kd_Sub = F.Kd_Sub AND B.Kd_Prog = F.Kd_Prog AND B.ID_Prog = F.ID_Prog INNER JOIN
		Ref_Sub_Unit C ON B.Kd_Urusan = C.Kd_Urusan AND B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub INNER JOIN
		Ta_Pemda D ON A.Tahun = D.Tahun,
		(
		SELECT @Kd_Urusan AS Kd_UrusanA, @Kd_Bidang AS Kd_BidangA, @Kd_Unit AS Kd_UnitA, @Kd_Sub AS Kd_SubA,
			@Kd_Urusan AS Kd_Urusan_Gab,
			@Kd_Urusan + ' . ' + RIGHT('0' + @Kd_Bidang, 2) AS Kd_Bidang_Gab,
			@Kd_Urusan + ' . ' + RIGHT('0' + @Kd_Bidang, 2) + ' . ' + RIGHT('0' +  @Kd_Unit, 2) AS Kd_Unit_Gab,
			@Kd_Urusan + ' . ' + RIGHT('0' + @Kd_Bidang, 2) + ' . ' + RIGHT('0' +  @Kd_Unit, 2) + ' . ' + RIGHT('0' +  @Kd_Sub, 2) AS Kd_Sub_Gab,
			E.Nm_Urusan AS Nm_Urusan_Gab, D.Nm_Bidang AS Nm_Bidang_Gab, C.Nm_Unit AS Nm_Unit_Gab, B.Nm_Sub_Unit AS Nm_Sub_Unit_Gab
		FROM Ta_Sub_Unit A INNER JOIN
			Ref_Sub_Unit B ON A.Kd_Urusan = B.Kd_Urusan AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub INNER JOIN
			Ref_Unit C ON B.Kd_Urusan = C.Kd_Urusan AND B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit INNER JOIN
			Ref_Bidang D ON C.Kd_Urusan = D.Kd_Urusan AND C.Kd_Bidang = D.Kd_Bidang INNER JOIN
			Ref_Urusan E ON D.Kd_Urusan = E.Kd_Urusan INNER JOIN
			(
			SELECT TOP 1 Tahun, Kd_Urusan, Kd_Bidang, Kd_Unit, Kd_Sub
			FROM Ta_Sub_Unit A
			WHERE (A.Tahun = @Tahun) AND (A.Kd_Urusan LIKE @Kd_Urusan) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub)
			ORDER BY Tahun, Kd_Urusan, Kd_Bidang, Kd_Unit, Kd_Sub
			) F ON A.Tahun = F.Tahun AND A.Kd_Urusan = F.Kd_Urusan AND A.Kd_Bidang = F.Kd_Bidang AND A.Kd_Unit = F.Kd_Unit AND A.Kd_Sub = F.Kd_Sub
		) E
	ORDER BY A.Tgl_SP2D, A.No_SP2D



GO
