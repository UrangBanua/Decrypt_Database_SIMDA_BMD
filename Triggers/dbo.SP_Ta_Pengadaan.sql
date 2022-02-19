USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_Pengadaan] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(10)
WITH ENCRYPTION
AS
	SELECT TOP 100 PERCENT A.Tahun, A.No_Kontrak, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB,
		A.Tgl_Kontrak, A.Keterangan, Waktu, Nilai, Nm_Perusahaan, Bentuk, Alamat, Nm_Pemilik, NPWP, Nm_Bank, Nm_Rekening, No_Rekening, 
		Kd_Urusan, Kd_Bidang1, Kd_Unit1, Kd_Sub1, Kd_Prog, Id_Prog, Kd_Keg, Kd_Posting
	FROM Ta_Pengadaan A
	WHERE (A.Tahun = @Tahun) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota)
		AND (A.Kd_Bidang = @Kd_Bidang) AND (A.Kd_Unit = @Kd_Unit) AND (A.Kd_Sub = @Kd_Sub) AND (A.Kd_UPB = @Kd_UPB)
	ORDER BY A.Tgl_Kontrak DESC, A.No_Kontrak





GO
