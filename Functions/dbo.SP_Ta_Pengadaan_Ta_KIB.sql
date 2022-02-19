USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*** SP_Ta_Pengadaan_Ta_KIB - 24032016 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE [dbo].[SP_Ta_Pengadaan_Ta_KIB] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Pil tinyint
WITH ENCRYPTION
AS
/*
DECLARE @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Pil tinyint
SET @Tahun = '2010'
SET @Kd_Prov = '99'
SET @Kd_Kab_Kota = '99'
SET @Kd_Bidang = '4'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '1'
SET @Pil = 2
*/
	SELECT A.Tahun, A.No_Kontrak, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
			A.Tgl_Kontrak, B.Tgl_SP2D, A.Keterangan, A.Kd_Posting, A.Total, B.Termin, B.Penunjang, A.No_Bast, A.Tgl_BAST
	FROM
		(
		SELECT B.Tahun, B.No_Kontrak, B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Tgl_Kontrak, B.Keterangan, B.Kd_Posting,
			SUM(A.Jumlah * A.Harga) AS Total, C.No_Bast, C.Tgl_BAST
		FROM Ta_Pengadaan_Rinc A INNER JOIN
			Ta_Pengadaan B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak INNER JOIN
				Ta_Pengadaan_Bast C ON B.Tahun = C.Tahun AND B.No_Kontrak = C.No_Kontrak
		WHERE (B.Tahun = @Tahun) AND (B.Kd_Prov = @Kd_Prov) AND (B.Kd_Kab_Kota = @Kd_Kab_Kota)
			AND (B.Kd_Bidang = @Kd_Bidang) AND (B.Kd_Unit = @Kd_Unit) AND (B.Kd_Sub = @Kd_Sub) AND (B.Kd_UPB = @Kd_UPB) AND (B.Kd_Posting = 1)
		GROUP BY B.Tahun, B.No_Kontrak, C.No_Bast, C.Tgl_BAST, B.Kd_Prov, B.Kd_Kab_Kota, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, B.Tgl_Kontrak, B.Keterangan, B.Kd_Posting
		) A INNER JOIN
		(
		SELECT B.Tahun, B.No_Kontrak, MAX(B.Tgl_SP2D) AS Tgl_SP2D,
			SUM(CASE B.Jn_SP2D
			WHEN 1 THEN B.Nilai
			ELSE 0
			END) AS Termin,
			SUM(CASE B.Jn_SP2D
			WHEN 2 THEN A.Nilai
			ELSE 0
			END) AS Penunjang
		FROM Ta_Pengadaan_SP2D B LEFT OUTER JOIN
			Ta_Pengadaan_SP2D_Rinc A ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak AND A.No_SP2D = B.No_SP2D AND A.Jn_SP2D = B.Jn_SP2D
		GROUP BY B.Tahun, B.No_Kontrak
		) B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak LEFT OUTER JOIN
		(
		SELECT Tahun, No_SP2D
		FROM
			(
			SELECT Tahun, No_SP2D
			FROM Ta_KIB_A
			WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota)
				AND (Kd_Bidang = @Kd_Bidang) AND (Kd_Unit = @Kd_Unit) AND (Kd_Sub = @Kd_Sub) AND (Kd_UPB = @Kd_UPB)
			UNION ALL
			SELECT Tahun, No_SP2D
			FROM Ta_KIB_B
			WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota)
				AND (Kd_Bidang = @Kd_Bidang) AND (Kd_Unit = @Kd_Unit) AND (Kd_Sub = @Kd_Sub) AND (Kd_UPB = @Kd_UPB)
			UNION ALL
			SELECT Tahun, No_SP2D
			FROM Ta_KIB_C
			WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota)
				AND (Kd_Bidang = @Kd_Bidang) AND (Kd_Unit = @Kd_Unit) AND (Kd_Sub = @Kd_Sub) AND (Kd_UPB = @Kd_UPB)
			UNION ALL
			SELECT Tahun, No_SP2D
			FROM Ta_KIB_D
			WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota)
				AND (Kd_Bidang = @Kd_Bidang) AND (Kd_Unit = @Kd_Unit) AND (Kd_Sub = @Kd_Sub) AND (Kd_UPB = @Kd_UPB)
			UNION ALL
			SELECT Tahun, No_SP2D
			FROM Ta_KIB_E
			WHERE (Tahun = @Tahun) AND (Kd_Prov = @Kd_Prov) AND (Kd_Kab_Kota = @Kd_Kab_Kota)
				AND (Kd_Bidang = @Kd_Bidang) AND (Kd_Unit = @Kd_Unit) AND (Kd_Sub = @Kd_Sub) AND (Kd_UPB = @Kd_UPB)
			) A
		GROUP BY Tahun, No_SP2D
		) C ON A.Tahun = C.Tahun AND A.No_Kontrak = C.No_SP2D
	--WHERE (A.Total = B.Termin) AND ((C.Tahun IS NULL AND @Pil = 1) OR (C.Tahun IS NOT NULL AND @Pil = 2))
	WHERE ((C.Tahun IS NULL AND @Pil = 1) OR (C.Tahun IS NOT NULL AND @Pil = 2))
	ORDER BY A.Tahun, A.Tgl_Kontrak, A.No_Kontrak


GO
