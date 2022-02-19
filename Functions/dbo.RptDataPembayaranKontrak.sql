USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** RptDataPembayaranKontrak - 12122015 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE [dbo].[RptDataPembayaranKontrak] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4), @No_SP2D varchar(50)
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(4), @No_SP2D varchar(50)
SET @Tahun = '2012'
SET @Kd_Prov = '23'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '1'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = ''
SET @No_SP2D = ''
*/

	IF ISNULL(@Kd_Prov, '') = '' SET @Kd_Prov = '%'
	IF ISNULL(@Kd_Kab_Kota, '') = '' SET @Kd_Kab_Kota = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'
	IF ISNULL(@No_SP2D, '') = '' SET @No_SP2D = '%'


	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Nm_Bidang, A.Nm_Unit, A.Nm_Sub_Unit, A.Nm_UPB,
		A.Tahun, A.No_Kontrak, A.Tgl_Kontrak, A.Nilai_Kontrak, A.Keterangan,
		A.No_SP2D, A.Tgl_SP2D, A.Nilai_SP2D, ((Nilai_SP2D) / (Nilai_Kontrak/100)) AS Persen_Termin, A.Keterangan_SP2D AS Keterangan_SP2D, 
		B.Nm_Pimpinan, B.Nip_Pimpinan, B.Jbt_Pimpinan, D.Nm_Pemda,  NULL AS Logo,
		B.Nm_Pengurus, B.Nip_Pengurus, B.Jbt_Pengurus
	FROM
		(SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Nm_Bidang, A.Nm_Unit, A.Nm_Sub_Unit, A.Kd_UPB, A.Nm_UPB,
			A.Tahun, A.No_Kontrak, A.Tgl_Kontrak, A.Nilai AS Nilai_Kontrak, A.Keterangan,
			B.No_SP2D, B.Tgl_SP2D, B.Nilai AS Nilai_SP2D, B.Keterangan AS Keterangan_SP2D
		 FROM
			(SELECT A.Tahun, A.No_Kontrak, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, C.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, C.Nm_UPB,				
				A.Tgl_Kontrak, A.Keterangan, SUM(B.Harga*B.Jumlah) AS Nilai
			 FROM Ta_Pengadaan A INNER JOIN
             		Ta_Pengadaan_Rinc B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak INNER JOIN
				(SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, D.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, A.Nm_Sub_Unit, B.Kd_UPB, B.Nm_UPB
				 FROM Ref_Sub_Unit A INNER JOIN
					Ref_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub INNER JOIN
					Ref_Unit C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit INNER JOIN
					Ref_Bidang D ON C.Kd_Bidang = D.Kd_Bidang
				 GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, D.Nm_Bidang, A.Kd_Unit, C.Nm_Unit, A.Kd_Sub, A.Nm_Sub_Unit, B.Kd_UPB, B.Nm_UPB
				) C ON A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
			GROUP BY A.Tahun, A.No_Kontrak, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, C.Nm_Sub_Unit, A.Kd_UPB, A.Tgl_Kontrak, A.Keterangan, C.Kd_UPB, C.Nm_UPB, C.Nm_Bidang, C.Nm_Unit) A LEFT OUTER JOIN			
			(SELECT A.Tahun, A.No_Kontrak, A.No_SP2D, A.Jn_SP2D, A.Tgl_SP2D, A.Keterangan, SUM(A.Nilai) AS Nilai
			 FROM Ta_Pengadaan_SP2D A
			 WHERE A.Jn_SP2D <> 2	
			 GROUP BY A.Tahun, A.No_Kontrak, A.No_SP2D, A.Jn_SP2D, A.Tgl_SP2D, A.Keterangan ) B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak
		WHERE A.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
		GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Nm_Bidang, A.Nm_Unit, A.Nm_Sub_Unit, A.Kd_UPB, A.Nm_UPB,
			A.Tahun, A.No_Kontrak, A.Tgl_Kontrak, A.Nilai, A.Keterangan, B.Nilai,
			B.No_SP2D, B.Tgl_SP2D, B.Keterangan
    		--ORDER BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub
		) A INNER JOIN

		(
		SELECT A.Tahun, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Nm_Pimpinan, A.Nip_Pimpinan, A.Jbt_Pimpinan, A.Nm_Pengurus, A.Nip_Pengurus, A.Jbt_Pengurus
		FROM Ta_UPB A
		WHERE A.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB
		) B ON B.Tahun = A.Tahun AND B.Kd_Prov = A.Kd_Prov AND B.Kd_Kab_Kota = A.Kd_Kab_Kota AND B.Kd_Bidang = A.Kd_Bidang 
		AND B.Kd_Unit = A.Kd_Unit AND B.Kd_Sub = A.Kd_Sub AND A.Kd_UPB = B.Kd_UPB,

		(
		SELECT UPPER(B.Nm_Pemda) AS Nm_Pemda, B.Logo
		FROM Ta_Pemda A INNER JOIN
	     		Ref_PEMDA B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota
		WHERE A.Tahun = @Tahun AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota
		) D	
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Nm_Sub_Unit,
		A.Tahun, A.No_Kontrak, A.Tgl_Kontrak, A.Nilai_Kontrak, A.Keterangan,
		A.No_SP2D, A.Tgl_SP2D, A.Nilai_SP2D, A.Keterangan_SP2D, 
		B.Nm_Pimpinan, B.Nip_Pimpinan, B.Jbt_Pimpinan, D.Nm_Pemda, 
		B.Nm_Pengurus, B.Nip_Pengurus, B.Jbt_Pengurus, A.Nm_Bidang, A.Nm_unit, A.Nm_UPB		
	ORDER BY A.Tahun, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.No_Kontrak, A.Tgl_Kontrak, A.No_SP2D, A.Tgl_SP2D
	--WHERE A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub

GO
