USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_Proses_KA] @Tahun varchar(4)
WITH ENCRYPTION
AS
	/*
	DECLARE @Tahun varchar(4)
	SET @Tahun = '2011'
	*/
	ALTER TABLE Ta_KIB_A DISABLE TRIGGER ALL
	ALTER TABLE Ta_KIB_B DISABLE TRIGGER ALL
	ALTER TABLE Ta_KIB_C DISABLE TRIGGER ALL
	ALTER TABLE Ta_KIB_D DISABLE TRIGGER ALL
	ALTER TABLE Ta_KIB_E DISABLE TRIGGER ALL

	UPDATE Ta_KIB_A 
	SET Kd_KA = 1
	WHERE YEAR(Tgl_Pembukuan) = @Tahun
	
	UPDATE Ta_KIB_B 
	SET Kd_KA = 1
	WHERE YEAR(Tgl_Pembukuan) = @Tahun
	
	UPDATE Ta_KIB_C 
	SET Kd_KA = 1
	WHERE YEAR(Tgl_Pembukuan) = @Tahun
	
	UPDATE Ta_KIB_D 
	SET Kd_KA = 1
	WHERE YEAR(Tgl_Pembukuan) = @Tahun
	
	UPDATE Ta_KIB_E 
	SET Kd_KA = 1
	WHERE YEAR(Tgl_Pembukuan) = @Tahun
	
	
	UPDATE Ta_KIB_A 
	SET Kd_KA = 0
	FROM(
	     SELECT 	A.Tgl_Pembukuan, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Harga
	     FROM 	Ta_KIB_A A INNER JOIN 
			Ta_KA B ON YEAR(A.Tgl_Pembukuan) = B.Tahun AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3
	     WHERE 	B.Tahun = @Tahun AND YEAR(A.Tgl_Pembukuan) = @Tahun AND A.Harga < B.MinSatuan
	    )sKA 
	WHERE Ta_KIB_A.Kd_Prov = sKA.Kd_Prov AND Ta_KIB_A.Kd_Kab_Kota = sKA.Kd_Kab_Kota AND Ta_KIB_A.Kd_Aset1 = sKA.Kd_Aset1 AND Ta_KIB_A.Kd_Aset2 = sKA.Kd_Aset2
	      AND Ta_KIB_A.Kd_Aset3 = sKA.Kd_Aset3 AND Ta_KIB_A.Tgl_Pembukuan = sKA.Tgl_Pembukuan AND Ta_KIB_A.Harga = sKA.Harga
	
	UPDATE Ta_KIB_B 
	SET Kd_KA = 0
	FROM(
	     SELECT 	A.Tgl_Pembukuan, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Harga
	     FROM 	Ta_KIB_B A INNER JOIN 
			Ta_KA B ON YEAR(A.Tgl_Pembukuan) = B.Tahun AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3
	     WHERE 	B.Tahun = @Tahun AND YEAR(A.Tgl_Pembukuan) = @Tahun AND A.Harga < B.MinSatuan
	    )sKA 
	WHERE Ta_KIB_B.Kd_Prov = sKA.Kd_Prov AND Ta_KIB_B.Kd_Kab_Kota = sKA.Kd_Kab_Kota AND Ta_KIB_B.Kd_Aset1 = sKA.Kd_Aset1 AND Ta_KIB_B.Kd_Aset2 = sKA.Kd_Aset2
	      AND Ta_KIB_B.Kd_Aset3 = sKA.Kd_Aset3 AND Ta_KIB_B.Tgl_Pembukuan = sKA.Tgl_Pembukuan AND Ta_KIB_B.Harga = sKA.Harga
	
	UPDATE Ta_KIB_C 
	SET Kd_KA = 0
	FROM(
	     SELECT A.Tgl_Pembukuan, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Harga
	     FROM Ta_KIB_C A INNER JOIN Ta_KA B ON YEAR(A.Tgl_Pembukuan) = B.Tahun AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3
	     WHERE B.Tahun = @Tahun AND YEAR(A.Tgl_Pembukuan) = @Tahun AND A.Harga < B.MinSatuan
	    )sKA 
	WHERE Ta_KIB_C.Kd_Prov = sKA.Kd_Prov AND Ta_KIB_C.Kd_Kab_Kota = sKA.Kd_Kab_Kota AND Ta_KIB_C.Kd_Aset1 = sKA.Kd_Aset1 AND Ta_KIB_C.Kd_Aset2 = sKA.Kd_Aset2
	      AND Ta_KIB_C.Kd_Aset3 = sKA.Kd_Aset3 AND Ta_KIB_C.Tgl_Pembukuan = sKA.Tgl_Pembukuan AND Ta_KIB_C.Harga = sKA.Harga   
	
	UPDATE Ta_KIB_D 
	SET Kd_KA = 0
	FROM(
	     SELECT A.Tgl_Pembukuan, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Harga
	     FROM Ta_KIB_D A INNER JOIN Ta_KA B ON YEAR(A.Tgl_Pembukuan) = B.Tahun AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3
	     WHERE B.Tahun = @Tahun AND YEAR(A.Tgl_Pembukuan) = @Tahun AND A.Harga < B.MinSatuan
	    )sKA 
	WHERE Ta_KIB_D.Kd_Prov = sKA.Kd_Prov AND Ta_KIB_D.Kd_Kab_Kota = sKA.Kd_Kab_Kota AND Ta_KIB_D.Kd_Aset1 = sKA.Kd_Aset1 AND Ta_KIB_D.Kd_Aset2 = sKA.Kd_Aset2
	      AND Ta_KIB_D.Kd_Aset3 = sKA.Kd_Aset3 AND Ta_KIB_D.Tgl_Pembukuan = sKA.Tgl_Pembukuan AND Ta_KIB_D.Harga = sKA.Harga 
	
	UPDATE Ta_KIB_E 
	SET Kd_KA = 0
	FROM(
	     SELECT A.Tgl_Pembukuan, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Harga
	     FROM Ta_KIB_E A INNER JOIN Ta_KA B ON YEAR(A.Tgl_Pembukuan) = B.Tahun AND A.Kd_Aset1 = B.Kd_Aset1 AND A.Kd_Aset2 = B.Kd_Aset2 AND A.Kd_Aset3 = B.Kd_Aset3
	     WHERE B.Tahun = @Tahun AND YEAR(A.Tgl_Pembukuan) = @Tahun AND A.Harga < B.MinSatuan
	    )sKA 
	WHERE Ta_KIB_E.Kd_Prov = sKA.Kd_Prov AND Ta_KIB_E.Kd_Kab_Kota = sKA.Kd_Kab_Kota AND Ta_KIB_E.Kd_Aset1 = sKA.Kd_Aset1 AND Ta_KIB_E.Kd_Aset2 = sKA.Kd_Aset2
	      AND Ta_KIB_E.Kd_Aset3 = sKA.Kd_Aset3 AND Ta_KIB_E.Tgl_Pembukuan = sKA.Tgl_Pembukuan AND Ta_KIB_E.Harga = sKA.Harga
	
	ALTER TABLE Ta_KIB_A ENABLE TRIGGER ALL
	ALTER TABLE Ta_KIB_B ENABLE TRIGGER ALL
	ALTER TABLE Ta_KIB_C ENABLE TRIGGER ALL
	ALTER TABLE Ta_KIB_D ENABLE TRIGGER ALL
	ALTER TABLE Ta_KIB_E ENABLE TRIGGER ALL
	
	SELECT 'PROSES KEBIJAKAN TELAH SELESAI'	



GO
