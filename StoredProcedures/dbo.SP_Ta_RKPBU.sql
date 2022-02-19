USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Ta_RKPBU] @Tahun varchar(4), @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3)
WITH ENCRYPTION
AS
	SELECT A.Tahun, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.No_ID,
		A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Uraian, A.Lokasi, A.Jumlah, A.Harga, A.Jumlah * A.Harga AS Total,
		A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5,
		A.Keterangan, dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5) AS Rek_GabAset,
		dbo.fn_GabRekening(A.Kd_Rek_1, A.Kd_Rek_2, A.Kd_Rek_3, A.Kd_Rek_4, A.Kd_Rek_5) AS Rek_Gabungan
	FROM Ta_RKPBU A
	WHERE (A.Tahun = @Tahun) AND (A.Kd_Prov = @Kd_Prov) AND (A.Kd_Kab_Kota = @Kd_Kab_Kota) AND (A.Kd_Bidang = @Kd_Bidang) AND (A.Kd_Unit = @Kd_Unit) AND (A.Kd_Sub = @Kd_Sub) AND (A.Kd_UPB = @Kd_UPB)





GO
