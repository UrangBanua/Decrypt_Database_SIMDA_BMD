USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



/*** Rpt_NilaiAset - 16102015 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE PROCEDURE [dbo].[Rpt_NilaiAset] @Tahun varchar(4)
WITH ENCRYPTION
AS

/*
DECLARE @Tahun VARCHAR(4)
SET @Tahun = 2014
*/
SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, 
		A.Kd_Prov AS Kd_ProvGab, A.Kd_Kab_Kota AS Kd_KabKotaGab,
		CONVERT(VARCHAR, A.Kd_Prov) + '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Kab_Kota),2) AS Kd_UnitGab1,
		CONVERT(VARCHAR, A.Kd_Prov) + '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Kab_Kota),2) + '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Bidang),2) AS Kd_UnitGab2,
		CONVERT(VARCHAR, A.Kd_Prov) + '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Kab_Kota),2) + '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Bidang),2)
		+ '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Unit),2) AS Kd_UnitGab3,
		CONVERT(VARCHAR, A.Kd_Prov) + '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Kab_Kota),2) + '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Bidang),2)
		+ '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Unit),2) + '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Sub),2) AS Kd_UnitGab4,
		CONVERT(VARCHAR, A.Kd_Prov) + '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Kab_Kota),2) + '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Bidang),2)
		+ '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Unit),2) + '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Sub),2) + '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_UPB),2) AS Kd_UnitGab5,
		C.Nm_Provinsi, B.Nm_Kab_Kota, G.Nm_Bidang, F.Nm_Unit, E.Nm_Sub_Unit, D.Nm_UPB,
		A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, 
		A.Kd_Aset1 AS Kd_Aset1Gab, CONVERT(VARCHAR, A.Kd_Aset1) + '.' + CONVERT(VARCHAR, A.Kd_Aset2) AS Kd_Aset2Gab,
		CONVERT(VARCHAR, A.Kd_Aset1) + '.' + CONVERT(VARCHAR, A.Kd_Aset2) + '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Aset3), 2) AS Kd_Aset3Gab,
		CONVERT(VARCHAR, A.Kd_Aset1) + '.' + CONVERT(VARCHAR, A.Kd_Aset2) + '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Aset3), 2)
		+ '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Aset4), 2) AS Kd_Aset4Gab,
		CONVERT(VARCHAR, A.Kd_Aset1) + '.' + CONVERT(VARCHAR, A.Kd_Aset2) + '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Aset3), 2)
		+ '.' + RIGHT('0' + CONVERT(VARCHAR, A.Kd_Aset4), 2)+ '.' + RIGHT('00' + CONVERT(VARCHAR, A.Kd_Aset5), 3) AS Kd_Aset5Gab,
		J.Nm_Aset1, K.Nm_Aset2, L.Nm_Aset3, M.Nm_Aset4, N.Nm_Aset5,
		A.Id_Kab_Kota, A.Id_UPB, A.No_Register, A.Harga
FROM	(
		SELECT	A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4,
				A.Kd_Aset5, A.Id_Kab_Kota, A.Id_UPB, A.No_Register, A.Harga
		FROM
				(SELECT	Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4,
						A.Kd_Aset5, A.Id_Kab_Kota, A.Id_UPB, A.No_Register, A.Harga
				FROM	Ta_SaldoKIB_A A
				WHERE	Harga <= 100
				
				UNION ALL
				
				SELECT	Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4,
						A.Kd_Aset5, A.Id_Kab_Kota, A.Id_UPB, A.No_Register, A.Harga
				FROM	Ta_SaldoKIB_B A
				WHERE	Harga <= 100
				
				UNION ALL
				
				SELECT	Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4,
						A.Kd_Aset5, A.Id_Kab_Kota, A.Id_UPB, A.No_Register, A.Harga
				FROM	Ta_SaldoKIB_C A
				WHERE	Harga <= 100
				
				UNION ALL
				
				SELECT	Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4,
						A.Kd_Aset5, A.Id_Kab_Kota, A.Id_UPB, A.No_Register, A.Harga
				FROM	Ta_SaldoKIB_D A
				WHERE	Harga <= 100
				
				UNION ALL
				
				SELECT	Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4,
						A.Kd_Aset5, A.Id_Kab_Kota, A.Id_UPB, A.No_Register, A.Harga
				FROM	Ta_SaldoKIB_E A
				WHERE	Harga <= 100
				
				UNION ALL
				
				SELECT	Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4,
						A.Kd_Aset5, A.Id_Kab_Kota, A.Id_UPB, A.No_Register, A.Harga
				FROM	Ta_Saldo_Lainnya A
				WHERE	Harga <= 100
				) A
		) A INNER JOIN
		(
		SELECT A.Tahun, A.Id_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Id_Bidang, A.Id_Unit, A.Id_Sub, A.Alamat
		FROM	Ta_Saldo_Sub_Unit A
		WHERE	A.Tahun = @Tahun
		) H ON A.Id_Kab_Kota = H.Id_Kab_Kota AND A.Kd_Bidang = H.Kd_Bidang AND A.Kd_Unit = H.Kd_Unit AND A.Kd_Sub = H.Kd_Sub INNER JOIN
		(
		SELECT	A.Tahun, A.Id_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Id_Bidang, A.Id_Unit, A.Id_Sub, 
				A.Id_UPB, A.Nm_Pimpinan, A.Nip_Pimpinan, A.Jbt_Pimpinan, A.Nm_Pengurus, A.Nip_Pengurus, A.Jbt_Pengurus, 
				A.Nm_Penyimpan, A.Nip_Penyimpan, A.Jbt_Penyimpan, A.Alamat
		FROM	Ta_Saldo_UPB A
		WHERE	A.Tahun = @Tahun
		) I ON H.Tahun = I.Tahun AND A.Id_Kab_Kota = I.Id_Kab_Kota AND A.Kd_Bidang = I.Kd_Bidang AND A.Kd_Unit = I.Kd_Unit
		AND A.Kd_Sub = I.Kd_Sub AND A.Kd_UPB = I.Kd_UPB INNER JOIN
		(
		SELECT TOP 1 A.Kd_Prov, A.Kd_Kab_Kota, A.ID_Prov, A.Id_Kab_Kota, A.Nm_Kab_Kota
		FROM	Ref_Saldo_Kab_Kota A
		) B ON H.Id_Kab_Kota = B.Id_Kab_Kota INNER JOIN
		(
		SELECT TOP 1 Kd_Prov, Id_Prov, Nm_Provinsi
		FROM	Ref_Saldo_Provinsi 
		) C ON B.Id_Prov = C.Id_Prov INNER JOIN
		(
		SELECT Tahun, Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB, Id_Kab_Kota, Id_Bidang, Id_Unit, Id_Sub, Id_UPB, Lat, Long, Nm_UPB
		FROM	Ref_Saldo_UPB
		WHERE	Tahun = @Tahun
		) D ON H.Tahun = D.Tahun AND H.Id_Kab_Kota = D.Id_Kab_Kota AND I.Id_UPB = D.Id_UPB INNER JOIN 
		(
		SELECT Tahun, Kd_Bidang, Kd_Unit, Kd_Sub, Id_Kab_Kota, Id_Bidang, Id_Unit, Id_Sub, Nm_Sub_Unit
		FROM	Ref_Saldo_Sub_Unit
		WHERE	Tahun = @Tahun
		) E ON D.Id_Sub = E.Id_Sub AND I.Tahun = E.Tahun INNER JOIN
		(
		SELECT Tahun, Kd_Bidang, Kd_Unit, Id_Kab_Kota, Id_Bidang, Id_Unit, Nm_Unit
		FROM	Ref_Saldo_Unit 
		WHERE	Tahun = @Tahun
		) F ON E.Id_Unit = F.Id_Unit AND I.Tahun = F.Tahun INNER JOIN
		(
		SELECT Tahun, Kd_Bidang, Id_Kab_Kota, Id_Bidang, Nm_Bidang
		FROM	Ref_Saldo_Bidang 
		WHERE	Tahun = @Tahun
		) G ON I.Tahun = G.Tahun AND I.Id_Kab_Kota = G.Id_Kab_Kota AND I.Id_Bidang = G.Id_Bidang INNER JOIN
		(
		SELECT	Kd_Aset1, Id_Kab_Kota, Nm_Aset1
		FROM	Ref_Saldo_Aset1
		) J ON A.Id_Kab_Kota = J.Id_Kab_Kota AND A.Kd_Aset1 = J.Kd_Aset1 INNER JOIN
		(
		SELECT	Kd_Aset1, Kd_Aset2, Id_Kab_Kota, Nm_Aset2
		FROM	Ref_Saldo_Aset2
		) K ON A.Id_Kab_Kota = K.Id_Kab_Kota AND A.Kd_Aset1 = K.Kd_Aset1 AND A.Kd_Aset2 = K.Kd_Aset2 INNER JOIN
		(
		SELECT	Kd_Aset1, Kd_Aset2, Kd_Aset3, Id_Kab_Kota, Nm_Aset3
		FROM	Ref_Saldo_Aset3
		) L ON A.Id_Kab_Kota = L.Id_Kab_Kota AND A.Kd_Aset1 = L.Kd_Aset1 AND A.Kd_Aset2 = L.Kd_Aset2 AND A.Kd_Aset3 = L.Kd_Aset3 INNER JOIN
		(
		SELECT	Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Id_Kab_Kota, Nm_Aset4
		FROM	Ref_Saldo_Aset4
		) M ON A.Id_Kab_Kota = M.Id_Kab_Kota AND A.Kd_Aset1 = M.Kd_Aset1 AND A.Kd_Aset2 = M.Kd_Aset2 AND A.Kd_Aset3 = M.Kd_Aset3 AND A.Kd_Aset4 = M.Kd_Aset4 INNER JOIN
		(
		SELECT	Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Id_Kab_Kota, Nm_Aset5
		FROM	Ref_Saldo_Aset5
		) N ON A.Id_Kab_Kota = N.Id_Kab_Kota AND A.Kd_Aset1 = N.Kd_Aset1 AND A.Kd_Aset2 = N.Kd_Aset2 AND A.Kd_Aset3 = N.Kd_Aset3 AND A.Kd_Aset4 = N.Kd_Aset4 AND A.Kd_Aset5 = N.Kd_Aset5
ORDER BY A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register

GO
