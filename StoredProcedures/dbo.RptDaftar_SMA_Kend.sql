USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** RptDAFTAR_SMA_Kend - 17012017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE RptDaftar_SMA_Kend @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D2 Datetime
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @D2 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3)
SET @Tahun = '2017'
SET @D2 = '20170131'
SET @Kd_Prov = '19'
SET @Kd_Kab_Kota = '0'
SET @Kd_Bidang = '8'
SET @Kd_Unit = '1'
SET @Kd_Sub = '4'
SET @Kd_UPB = '2'
*/

	
	DECLARE @JLap Tinyint SET @JLap = 0

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'


	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang,  C.Nm_Kab_Kota,C.Nm_Bidang, C.Nm_Unit, C.Nm_Sub_Unit,C.Nm_UPB, C.Nm_UPB AS Lokasi,
		A.Kd_Unit, A.Kd_Sub,  A.Kd_UPB,  A.Kd_Aset_Gab, 
		D.Kd_Aset1, D.Nm_Aset1, D.Kd_Aset2, D.Nm_Aset2, D.Kd_Aset3, D.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, D.Kd_Aset5, D.Nm_Aset5, 
		A.No_Register, YEAR (A.Tgl_Perolehan) AS Tahun, 
		ISNULL (A.Merk,'-') AS Merk, ISNULL (A.Type,'-') AS Type, B.Nilai_Sisa, A.Kondisi, 
		ISNULL (A.Nomor_Polisi, '-') AS Nopol, ISNULL (A.Nomor_BPKB, '-') AS BPKB, ISNULL (A.Nomor_Mesin,'-') AS Mesin, ISNULL (A.Nomor_Rangka,'-') As Rangka,
		F.Uraian AS UraianKondisi,
		A.Harga, ISNULL(A.Keterangan, '-') AS Keterangan,   
	   	E.Nm_Pimpinan, E.Nip_Pimpinan, E.Jbt_Pimpinan, E.Nm_Pengurus, E.Nip_Pengurus, E.Jbt_Pengurus,
		G.No_BAST, G.Tanggal, G.Kd_Kab_kota, G.Nm_Kab_kota
	FROM 
		(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.Tgl_Perolehan, A.No_Register, A.Kd_KA, A.Harga,
	       		CONVERT(varchar, A.Kd_Aset1)+'.'+ CONVERT(varchar, A.Kd_Aset2)+'.'+CONVERT(varchar, A.Kd_Aset3)+'.'+CONVERT(varchar, A.Kd_Aset4)+'.'+CONVERT(varchar, A.Kd_Aset5)AS Kd_Aset_Gab
			,A.Merk, A.Type, A.Keterangan, A.Kondisi, A.Nomor_Polisi, A.Nomor_BPKB, A.Nomor_Mesin, A.Nomor_Rangka
		FROM   fn_Kartu_BrgB(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap) A INNER JOIN
			TA_KIB_B B ON A.Kd_Prov = B.KD_PROV AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang 
					AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB AND
					A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_register = B.No_register
		WHERE A.Kd_Bidang = @Kd_Bidang AND A.Kd_Unit = @Kd_Unit AND A.Kd_Sub = @Kd_Sub AND A.Kd_UPB = @Kd_UPB AND A.Tgl_Perolehan <= @D2
		) A LEFT OUTER JOIN
		(
		SELECT B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, CASE A.Nilai_Susut1 WHEN 0 THEN 0 ELSE 1 END AS Jn, 
          		  B.Kd_Aset1, B.Kd_Aset2, B.Kd_Aset3, B.Kd_Aset4, B.Kd_Aset5, 
	 		  CONVERT(varchar, Kd_Aset1)+'.'+ CONVERT(varchar, Kd_Aset2)+'.'+CONVERT(varchar, Kd_Aset3)+'.'+CONVERT(varchar, Kd_Aset4)+'.'+CONVERT(varchar, Kd_Aset5)AS Kd_Aset_Gab, 
        		    B.No_Register, MONTH (B.Tgl_Perolehan) AS Bulan, YEAR (B.Tgl_Perolehan) AS Tahun, 
			    A.Harga, 0 AS Susut1, 0 AS Susut2, (A.Nilai_Susut1+A.Nilai_Susut2) AS Susut, 
        		    A.Akum_Susut, A.Nilai_Sisa
     		FROM Ta_SusutB A INNER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda
    		 WHERE (A.Jndt = 1) AND 
			(B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota) AND (B.Kd_Bidang LIKE @Kd_Bidang) AND (B.Kd_Unit LIKE @Kd_Unit) AND 
        		   (B.Kd_Sub LIKE @Kd_Sub) AND (B.Kd_UPB LIKE @Kd_UPB) AND
        		   (B.Kd_Pemilik = CASE WHEN @Kd_Kab_Kota = 0 THEN 11 ELSE 12 END)
		) B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit 
		AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
		(
		SELECT Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB,
			Nm_Pimpinan, Nip_Pimpinan, Jbt_Pimpinan, Nm_Pengurus, Nip_Pengurus, Jbt_Pengurus
		FROM TA_UPB
		WHERE TAHUN = @TAHUN
		GROUP BY Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Nm_Pimpinan, Nip_Pimpinan, Jbt_Pimpinan, Nm_Pengurus, Nip_Pengurus, Jbt_Pengurus
		) E ON A.Kd_Prov = E.Kd_Prov AND A.Kd_Kab_Kota = E.Kd_Kab_Kota AND A.Kd_Bidang = E.Kd_Bidang AND A.Kd_Unit = E.Kd_Unit 
		AND A.Kd_Sub = E.Kd_Sub AND A.Kd_UPB = E.Kd_UPB INNER JOIN
		(
		SELECT 	A.Kd_Prov, A.Nm_Provinsi, B.Kd_Kab_Kota, B.Nm_Kab_Kota, D.Kd_Bidang, C.Nm_Bidang, D.Kd_Unit, D.Nm_Unit, E.Kd_Sub, E.Nm_Sub_Unit, F.Kd_UPB, F.Nm_UPB
		FROM    Ref_Unit D INNER JOIN
                	Ref_Bidang C ON D.Kd_Bidang = C.Kd_Bidang INNER JOIN
                	Ref_Sub_Unit E ON D.Kd_Prov = E.Kd_Prov AND D.Kd_Kab_Kota = E.Kd_Kab_Kota AND D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
                	Ref_UPB F ON E.Kd_Prov = F.Kd_Prov AND E.Kd_Kab_Kota = F.Kd_Kab_Kota AND E.Kd_Bidang = F.Kd_Bidang AND E.Kd_Unit = F.Kd_Unit AND 
                	E.Kd_Sub = F.Kd_Sub INNER JOIN
                	Ref_Provinsi A INNER JOIN
                	Ref_Kab_Kota B ON A.Kd_Prov = B.Kd_Prov ON D.Kd_Prov = B.Kd_Prov AND D.Kd_Kab_Kota = B.Kd_Kab_Kota 
			
		)C ON   A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND 
                	A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB LEFT OUTER JOIN
		(
		SELECT  A.Kd_Aset1, A.Nm_Aset1, B.Kd_Aset2, B.Nm_Aset2, C.Kd_Aset3, C.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, E.Kd_Aset5, E.Nm_Aset5
		FROM    Ref_Rek_Aset1 A INNER JOIN
                	Ref_Rek_Aset2 B ON A.Kd_Aset1 = B.Kd_Aset1 INNER JOIN
                	Ref_Rek_Aset3 C ON B.Kd_Aset1 = C.Kd_Aset1 AND B.Kd_Aset2 = C.Kd_Aset2 INNER JOIN
                	Ref_Rek_Aset4 D ON C.Kd_Aset1 = D.Kd_Aset1 AND C.Kd_Aset2 = D.Kd_Aset2 AND C.Kd_Aset3 = D.Kd_Aset3 INNER JOIN
                	Ref_Rek_Aset5 E ON D.Kd_Aset1 = E.Kd_Aset1 AND D.Kd_Aset2 = E.Kd_Aset2 AND D.Kd_Aset3 = E.Kd_Aset3 AND D.Kd_Aset4 = E.Kd_Aset4
		) D ON  A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND 
                	A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 INNER JOIN
		(
		SELECT Kd_kondisi, Uraian
		From REF_KONDISI
		) F On A.Kondisi = F.Kd_kondisi,

		(SELECT A.NO_BAST, A.TANGGAL, A.Kd_prov, A.Kd_Kab_kota, SUBSTRING (A.Nm_Kab_kota,12,30) AS Nm_Kab_kota
		 FROM Ta_P3D A INNER JOIN
			TA_P3D_RINC B ON A.NO_BAST = B.NO_BAST AND B.KD_BIDANG = @KD_BIDANG AND B.KD_UNIT = @KD_UNIT AND B.KD_SUB = @KD_SUB AND B.KD_UPB = @KD_UPB
		 ) G

	WHERE 	A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND 
		A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB 
		AND A.KD_ASET1 = 2 AND A.KD_ASET2 = 3

	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang,  C.Nm_Kab_Kota,C.Nm_Bidang, C.Nm_Unit, C.Nm_Sub_Unit,C.Nm_UPB, C.Nm_UPB,
		A.Kd_Unit, A.Kd_Sub,  A.Kd_UPB,  A.Kd_Aset_Gab, 
		D.Kd_Aset1, D.Nm_Aset1, D.Kd_Aset2, D.Nm_Aset2, D.Kd_Aset3, D.Nm_Aset3, D.Kd_Aset4, D.Nm_Aset4, D.Kd_Aset5, D.Nm_Aset5, 
		A.No_Register, A.Tgl_Perolehan, 
		A.Merk, A.Type,
		B.Nilai_Sisa, A.Kondisi, 
		A.Nomor_Polisi, A.Nomor_BPKB, A.Nomor_Mesin,A.Nomor_Rangka,
		F.Uraian,
		A.Harga, A.Keterangan, 
	   	E.Nm_Pimpinan, E.Nip_Pimpinan, E.Jbt_Pimpinan, E.Nm_Pengurus, E.Nip_Pengurus, E.Jbt_Pengurus,
		G.No_BAST, G.Tanggal, G.Kd_Kab_kota, G.Nm_Kab_kota




GO
