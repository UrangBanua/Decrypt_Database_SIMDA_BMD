USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** RptRekapKIB_D_Gabungan - 05012016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE dbo.RptRekapKIB_D_Gabungan @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @D2 datetime
WITH ENCRYPTION
AS
  
/*
DECLARE @Tahun varchar(4), @D2 datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3)
SET @Tahun = '2011'
SET @D2 = '20111231'
SET @Kd_Prov = '22'
SET @Kd_Kab_Kota = '16'
SET @Kd_Bidang = ''
SET @Kd_Unit = ''
SET @Kd_Sub = ''
SET @Kd_UPB = ''
*/
	DECLARE @JLap Tinyint SET @JLap = 1

	IF ISNULL(@Kd_Kab_Kota, '') = '' SET @Kd_Kab_Kota = '%'
	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

	SELECT 	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_UPB, I.Nm_Provinsi, 
		H.Nm_Kab_Kota, F.Nm_Bidang, E.Nm_Unit, D.Nm_Sub_Unit, M.Nm_UPB,
		dbo.fn_KdLokasi2(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, @Kd_UPB) AS Kd_Lokasi,
		dbo.fn_KdLokasi2(A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, @Kd_UPB) AS Kd_Lokasi_Grp,
		B.Nm_Aset5, REPLACE(dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5), ' . ', '.') AS Kd_Gab_Brg,
		RIGHT('0000' + CONVERT(varchar, A.No_Register), 4) AS No_Register,
		A.Konstruksi, A.Panjang, A.Lebar, A.Luas, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah, 
		REPLACE(dbo.fn_GabBarang(A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5), ' . ', '.') + '.' + CHAR(13) + RIGHT('0000' + CONVERT(varchar, A.Kode_Tanah), 4) AS Kode_Tanah,
		A.Asal_usul, A.Harga / 1000 AS Harga, 
		CASE A.Kondisi
		WHEN 1 THEN 'Baik'
		WHEN 2 THEN 'Kurang Baik'
		WHEN 3 THEN 'Rusak Berat'
		END AS Kondisi,
		A.Keterangan,
		L.Nm_Pimpinan, L.Nip_Pimpinan, L.Jbt_Pimpinan, L.Nm_Pengurus, L.Nip_Pengurus, L.Jbt_Pengurus
	FROM fn_Kartu_BrgD(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap)  A INNER JOIN
		Ref_Rek_Aset5 B ON A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 INNER JOIN
		Ref_Sub_Unit D ON A.Kd_Prov = D.Kd_Prov AND A.Kd_Kab_Kota = D.Kd_Kab_Kota AND A.Kd_Bidang = D.Kd_Bidang AND A.Kd_Unit = D.Kd_Unit AND A.Kd_Sub = D.Kd_Sub INNER JOIN
		Ref_Unit E ON D.Kd_Prov = E.Kd_Prov AND D.Kd_Kab_Kota = E.Kd_Kab_Kota AND D.Kd_Bidang = E.Kd_Bidang AND D.Kd_Unit = E.Kd_Unit INNER JOIN
		Ref_Bidang F ON E.Kd_Bidang = F.Kd_Bidang INNER JOIN
		Ref_Pemda G ON A.Kd_Prov = G.Kd_Prov AND A.Kd_Kab_Kota = G.Kd_Kab_Kota INNER JOIN
		Ref_Kab_Kota H ON G.Kd_Prov = H.Kd_Prov AND G.Kd_Kab_Kota = H.Kd_Kab_Kota INNER JOIN
		Ref_Provinsi I ON H.Kd_Prov = I.Kd_Prov LEFT OUTER JOIN
		fn_Kartu_BrgA(@D2, @Kd_Prov, @Kd_Kab_Kota, @Kd_Bidang, @Kd_Unit, @Kd_Sub, @Kd_UPB,'%','%','%','%','%','%',@JLap) K ON A.Kd_Prov = K.Kd_Prov AND A.Kd_Kab_Kota = K.Kd_Kab_Kota AND A.Kd_Bidang = K.Kd_Bidang 
                      AND A.Kd_Unit = K.Kd_Unit AND A.Kd_Sub = K.Kd_Sub AND A.Kd_UPB = K.Kd_UPB AND A.Kd_Tanah1 = K.Kd_Aset1 AND A.Kd_Tanah2 = K.Kd_Aset2 AND A.Kd_Tanah3 = K.Kd_Aset3 AND A.Kd_Tanah4 = K.Kd_Aset4 
                      AND A.Kd_Tanah5 = K.Kd_Aset5 AND A.Kode_Tanah = K.No_Register LEFT OUTER JOIN
		Ta_UPB J ON A.Kd_Prov = J.Kd_Prov AND A.Kd_Kab_Kota = J.Kd_Kab_Kota AND A.Kd_Bidang = J.Kd_Bidang AND A.Kd_Unit = J.Kd_Unit AND A.Kd_Sub = J.Kd_Sub AND A.Kd_UPB = J.Kd_UPB INNER JOIN
		Ref_UPB M ON A.Kd_Prov = M.Kd_Prov AND A.Kd_Kab_Kota = M.Kd_Kab_Kota AND A.Kd_Bidang = M.Kd_Bidang AND A.Kd_Unit = M.Kd_Unit AND A.Kd_Sub = M.Kd_Sub AND A.Kd_UPB = M.Kd_UPB,
		(
		SELECT @Kd_UPB AS Kd_UPBA, 
			RIGHT('0' + @Kd_Bidang, 2) + '.' + RIGHT('0' + @Kd_Unit, 2) + '.' + RIGHT('0' + @Kd_Sub, 2) + '.' + RIGHT('0' + @Kd_UPB, 2) AS Kd_UPB_Gab,
			B.Nm_UPB AS Nm_UPB_Gab, A.Nm_Pimpinan, A.Nip_Pimpinan, A.Jbt_Pimpinan,
			A.Nm_Pengurus, A.Nip_Pengurus, A.Jbt_Pengurus
		FROM Ta_UPB A INNER JOIN
			Ref_UPB B ON A.Kd_Prov = B.Kd_Prov AND A.Kd_Kab_Kota = B.Kd_Kab_Kota AND A.Kd_Bidang = B.Kd_Bidang AND A.Kd_Unit = B.Kd_Unit AND A.Kd_Sub = B.Kd_Sub AND A.Kd_UPB = B.Kd_UPB INNER JOIN
			(
			SELECT TOP 1 Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			FROM Ta_UPB
			WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota) AND (Kd_Bidang LIKE @Kd_Bidang) AND (Kd_Unit LIKE @Kd_Unit) AND (Kd_Sub LIKE @Kd_Sub) AND (Kd_UPB LIKE @Kd_UPB)
			ORDER BY Tahun, Kd_Prov, Kd_Kab_Kota, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB
			) C ON A.Tahun = C.Tahun AND A.Kd_Prov = C.Kd_Prov AND A.Kd_Kab_Kota = C.Kd_Kab_Kota AND A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB
		) L

	WHERE (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota LIKE @Kd_Kab_Kota) AND (A.Kd_Bidang LIKE @Kd_Bidang) AND (A.Kd_Unit LIKE @Kd_Unit) AND (A.Kd_Sub LIKE @Kd_Sub) AND (A.Kd_UPB LIKE @Kd_UPB)
	GROUP BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_UPB, I.Nm_Provinsi, H.Nm_Kab_Kota, F.Nm_Bidang, E.Nm_Unit, D.Nm_Sub_Unit, M.Nm_UPB,
		A.Kd_Pemilik, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register,
		A.Konstruksi, A.Panjang, A.Lebar, A.Luas, A.Lokasi, A.Dokumen_Tanggal, A.Dokumen_Nomor, A.Status_Tanah, A.Kd_Tanah1, A.Kd_Tanah2, A.Kd_Tanah3, A.Kd_Tanah4, A.Kd_Tanah5,
		A.Asal_usul, A.Harga, A.Kondisi, A.Keterangan, B.Nm_Aset5, A.Kode_Tanah,
		L.Nm_Pimpinan, L.Nip_Pimpinan, L.Jbt_Pimpinan, L.Nm_Pengurus, L.Nip_Pengurus, L.Jbt_Pengurus
	ORDER BY A.Kd_Kab_Kota, Kd_Gab_Brg, A.No_Register




GO
