USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** SP_Ta_Pengadaan_Bast - 28022017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE SP_Ta_Pengadaan_Bast_Sp2d @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10), @No_Kontrak varchar(50)
WITH ENCRYPTION
AS

	IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '') = '' SET @Kd_Unit = '%'
	IF ISNULL(@Kd_Sub, '') = '' SET @Kd_Sub = '%'
	IF ISNULL(@Kd_UPB, '') = '' SET @Kd_UPB = '%'

	if @No_Kontrak = ''
	BEGIN
		SELECT A.Tahun, A.No_Kontrak, B.Tgl_Kontrak, B.Keterangan
		FROM Ta_Pengadaan_SP2D A INNER JOIN 
			Ta_Pengadaan B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak LEFT OUTER JOIN
			Ta_Pengadaan_Bast C ON A.Tahun = C.Tahun AND A.No_Kontrak = C.No_Kontrak
		WHERE (A.Tahun = @Tahun) AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota)
			AND (B.Kd_Bidang = @Kd_Bidang) AND (B.Kd_Unit = @Kd_Unit) AND (B.Kd_Sub = @Kd_Sub) AND (B.Kd_UPB = @Kd_UPB)
			AND (C.Tahun IS NULL)
		GROUP BY A.Tahun, A.No_Kontrak, B.Tgl_Kontrak, B.Keterangan
		ORDER BY A.Tahun, A.No_Kontrak, B.Tgl_Kontrak
	END

	if @No_Kontrak <> ''
	BEGIN
		SELECT A.Tahun, A.No_Kontrak, B.Tgl_Kontrak, B.Keterangan
		FROM Ta_Pengadaan_SP2D A INNER JOIN 
			Ta_Pengadaan B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak INNER JOIN
			Ta_Pengadaan_Bast C ON A.Tahun = C.Tahun AND A.No_Kontrak = C.No_Kontrak
		WHERE (A.Tahun = @Tahun) AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota)
			AND (B.Kd_Bidang = @Kd_Bidang) AND (B.Kd_Unit = @Kd_Unit) AND (B.Kd_Sub = @Kd_Sub) AND (B.Kd_UPB = @Kd_UPB)
		GROUP BY A.Tahun, A.No_Kontrak, B.Tgl_Kontrak, B.Keterangan
		ORDER BY A.Tahun, A.No_Kontrak, B.Tgl_Kontrak
	END



GO
