USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Ta_Pengadaan_Rinc] @Tahun varchar(4), @No_Kontrak varchar(50)
WITH ENCRYPTION
AS
	SELECT A.Tahun, A.No_Kontrak, A.No_ID, 
		A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5,
		A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85,
		A.Merk, A.Type, A.Ukuran, A.Panjang, A.Lebar, A.Luas,
		A.Jumlah, A.Harga, A.Jumlah * A.Harga AS Total, A.Keterangan,
		dbo.fn_GabBarang(A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5) AS Rek_GabAset,
		dbo.fn_GabBarang_108(A.Kd_Aset8, A.Kd_Aset80, A.Kd_Aset81, A.Kd_Aset82, A.Kd_Aset83, A.Kd_Aset84, A.Kd_Aset85) AS Rek_GabAset108
	FROM Ta_Pengadaan_Rinc A
	WHERE (A.Tahun = @Tahun) AND (A.No_Kontrak = @No_Kontrak)





GO
