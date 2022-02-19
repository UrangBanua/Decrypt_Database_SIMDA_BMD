USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


/*** PerbedaanDatabase3Register - 28032018 - Modified for Ver 2.0.7 [demi@simda.id] ****/
CREATE PROCEDURE [dbo].[PerbedaanDatabase3Register] @DB1 varchar(100), @DB2 varchar(100)
WITH ENCRYPTION
AS
/*
DECLARE @DB1 varchar(100), @DB2 varchar(100)
SET @DB1 = 'SIMDA_BMD_1'
SET @DB2 = 'SIMDA_BMD_2'
*/

	DECLARE @tmpKIB TABLE(KIB varchar(5), KIB_No varchar(5), Judul varchar(100), IDPemda varchar(17), Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB smallint,
		Nm_UPB varchar(100), Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 tinyint, Kd_Aset5 tinyint, No_Register int, 
		Nm_Aset5 varchar(255), Tgl_Dokumen datetime, Tgl_Perolehan datetime, Tgl_Pembukuan datetime, KondisiR varchar(2), KondisiK varchar(2))

------- KIB B
	INSERT INTO @tmpKIB
	SELECT 'KIB B' AS KIB, 'B.0' AS KIB_No, 'IDPemda ada diriwayat tidak ada di KIB' AS Judul, A.IDPemda, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, C.Nm_UPB, 
		A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan,
		A.Kondisi AS KondisiR, A.Kondisi AS KondisiK
  	FROM Ta_KIBBR A LEFT OUTER JOIN
		TA_KIB_B B ON A.IDPemda = B.IDPemda INNER JOIN
		Ref_UPB C ON A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB INNER JOIN
		Ref_Rek_Aset5 D ON A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 AND 
			A.Kd_Aset5 = D.Kd_Aset5 
 	WHERE B.IDPEMDA IS NULL


	INSERT INTO @tmpKIB
  	SELECT 'KIB B' AS KIB, 'B.1' AS KIB_No, 'TglPerolehan berbeda di KIB dan KIB riwayat' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
         	B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan1, A.Tgl_Perolehan2 AS Tgl_Pembukuan,  A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
 	FROM (
        	SELECT A.IDPemda,SUM(A.Kd_Id) AS Kd_Id, '18000101' AS Tgl_Dokumen, MAX(A.Tgl_Perolehan1) AS Tgl_Perolehan1,MAX(A.Tgl_Perolehan2) AS Tgl_Perolehan2, '0' AS Kondisi
        	FROM (
              		SELECT A.IDPemda,2 AS Kode,MAX(A.Kd_Id) AS Kd_Id,A.Tgl_Dokumen, '18000101' AS Tgl_Perolehan1,A.Tgl_Perolehan AS Tgl_Perolehan2
              		FROM Ta_KIBBR A INNER JOIN
                              (SELECT IDPemda,MIN(Tgl_Perolehan) AS Tgl_Perolehan 
                               FROM Ta_KIBBR WHERE Kd_Riwayat = 3 
                               GROUP BY IDPemda 
                               ) B ON A.IDPemda = B.IDPemda AND A.Tgl_Perolehan = B.Tgl_Perolehan  
              		WHERE A.Kd_Riwayat = 3             
              		GROUP BY A.IDPemda,A.Tgl_Perolehan,A.Tgl_Dokumen                 
              		UNION ALL                
            		SELECT A.IDPemda,1,0,A.Tgl_pembukuan AS Tgl_Dokumen, A.Tgl_Perolehan,'18000101'
              		FROM Ta_KIB_B A INNER JOIN
                             (SELECT IDPemda FROM Ta_KIBBR WHERE Kd_Riwayat = 3 GROUP BY IDPemda 
                             ) B ON A.IDPemda = B.IDPemda
              ) A
        GROUP BY A.IDPemda
        HAVING MAX(A.Tgl_Perolehan1) > MAX(A.Tgl_Perolehan2)   
       	) A INNER JOIN
 	Ta_KIB_B B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


 	INSERT INTO @tmpKIB
  	SELECT 'KIB B' AS KIB, 'B.2' AS KIB_No, 'TglPerolehan di KIB riwayat dibawah 1800' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, 
		B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5,B.No_Register, D.Nm_Aset5, B.Tgl_Pembukuan AS Tgl_Dokumen, A.Tgl_Perolehan1 AS Tgl_Perolehan, A.Tgl_Perolehan2 AS Tgl_Pembukuan,
		B.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
       	SELECT A.IDPemda,SUM(A.Kd_Id) AS Kd_Id,MAX(A.Tgl_Perolehan1) AS Tgl_Perolehan1,MAX(A.Tgl_Perolehan2) AS Tgl_Perolehan2
        FROM (
              SELECT A.IDPemda,2 AS Kode,MAX(A.Kd_Id) AS Kd_Id,'18000101' AS Tgl_Perolehan1,A.Tgl_Perolehan AS Tgl_Perolehan2 
              FROM Ta_KIBBR A INNER JOIN
                              (SELECT IDPemda,MIN(Tgl_Perolehan) AS Tgl_Perolehan 
                               FROM Ta_KIBBR WHERE Kd_Riwayat = 3 
                               GROUP BY IDPemda 
                               ) B ON A.IDPemda = B.IDPemda AND A.Tgl_Perolehan = B.Tgl_Perolehan  
              WHERE A.Kd_Riwayat = 3             
              GROUP BY A.IDPemda,A.Tgl_Perolehan                       
              UNION ALL                
              SELECT A.IDPemda,1,0,A.Tgl_Perolehan,'18000101'
              FROM Ta_KIB_B A INNER JOIN
                             (SELECT IDPemda FROM Ta_KIBBR WHERE Kd_Riwayat = 3 GROUP BY IDPemda 
                             ) B ON A.IDPemda = B.IDPemda
              ) A
        GROUP BY A.IDPemda     
        HAVING MAX(A.Tgl_Perolehan1) < MAX(A.Tgl_Perolehan2)    
       	) A INNER JOIN
 	Ta_KIBBR B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 
     	GROUP BY A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, 
	B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5,B.No_Register, D.Nm_Aset5, B.Tgl_Pembukuan, A.Tgl_Perolehan1, A.Tgl_Perolehan2
	, B.Kondisi, B.Kondisi   


	INSERT INTO @tmpKIB
 	SELECT 'KIB B' AS KIB, 'B.3' AS KIB_No, 'TglPembukuan berbeda dgn TglDokumen pindah' AS Judul, A.IDPemda, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, C.Nm_UPB, 
	A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register, D.Nm_Aset5,
	A.Tgl_Dokumen,  A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, A.Kondisi AS KondisiK
  	FROM(
        SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,
              A.Kd_Aset5,A.No_Register,A.Tgl_Pembukuan, B.Tgl_Dokumen, B.Tgl_Perolehan, A.Kondisi
	FROM Ta_KIB_B A INNER JOIN
		(
		SELECT A.IDPemda,A.Tgl_Dokumen,A.Tgl_Perolehan 
		FROM Ta_KIBBR A INNER JOIN
			(SELECT IDPemda, Max (Kd_Id) AS Kd_Id
			FROM Ta_KIBBR
			WHERE Kd_riwayat = 3
			GROUP BY IDPemda) B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id
		) B ON A.IDPEMDA = B.IDPEMDA
	WHERE A.Tgl_Pembukuan <> B.Tgl_Dokumen 
	) A INNER JOIN
	Ref_UPB C ON A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 AND 
 			   A.Kd_Aset5 = D.Kd_Aset5 
	GROUP BY A.IDPemda, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, C.Nm_UPB, 
	A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register, D.Nm_Aset5,
	A.Tgl_Dokumen,  A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi


	INSERT INTO @tmpKIB
  	SELECT 'KIB B' AS KIB, 'B.4' AS KIB_No, 'TglDokumen pindah lebih besar dari Tglriwayat lain' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, 
		B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
        SELECT A.IDPemda,A.Kd_Id,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,
               A.Kd_Aset4,A.Kd_Aset5,A.No_Register,B.Tgl_Dokumen,B.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi
        FROM Ta_KIBBR A INNER JOIN 
                        (SELECT A.IDPemda,A.Kd_Id,A.Kd_Prov1,A.Kd_Kab_Kota1,A.Kd_Bidang1,A.Kd_Unit1,A.Kd_Sub1,A.Kd_UPB1,
                                A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register1,A.Tgl_Dokumen,A.Tgl_Perolehan
                         FROM Ta_KIBBR A
                         WHERE A.Kd_Riwayat = 3
                         ) B ON A.IDPemda = B.IDPemda AND A.Kd_Prov = B.Kd_Prov1 AND A.Kd_Kab_Kota = B.Kd_Kab_Kota1 AND A.Kd_Bidang = B.Kd_Bidang1 AND A.Kd_Unit = B.Kd_Unit1 AND 
                                A.Kd_Sub = B.Kd_Sub1 AND A.Kd_UPB = B.Kd_UPB1 AND A.Kd_Aset1 LIKE B.Kd_Aset1 AND A.Kd_Aset2 LIKE B.Kd_Aset2 AND 
                                A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register1
        WHERE A.Kd_Riwayat <> 3 AND A.Tgl_Dokumen < B.Tgl_Dokumen                                                  
        ) A INNER JOIN
 	Ta_KIBBR B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB                                                     
  	SELECT 'KIB B' AS KIB, 'B.5' AS KIB_No, 'TglDokumen pindah lebih kecil dari TglPembukuan' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
         	B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
        SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen,B.Tgl_Pembukuan, A.Tgl_Perolehan, A.Kondisi
        FROM Ta_KIBBR A INNER JOIN 
                        (
                         SELECT A.IDPemda,A.Tgl_Pembukuan 
                         FROM Ta_KIB_B A LEFT OUTER JOIN 
                                         (SELECT IDPemda,MAX(Kd_Id) AS Kd_Id FROM Ta_KIBBR
                                          WHERE Kd_Riwayat = 3
                                          GROUP BY IDPemda
                                          ) B ON A.IDPemda = B.IDPemda 
                         WHERE B.IDPemda IS NULL
                         ) B ON A.IDPemda = B.IDPemda
        WHERE A.Kd_Riwayat <> 3 AND A.Tgl_Dokumen < B.Tgl_Pembukuan                                
       	) A INNER JOIN
 	Ta_KIB_B B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB
  	SELECT 'KIB B' AS KIB, 'B.6' AS KIB_No, 'Kondisi Aset di Riwayat berbeda dengan di KIB' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
         	B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM(
	SELECT A.IDPemda,B.Tgl_Dokumen,B.Kondisi, A.Tgl_Perolehan, A.Tgl_Pembukuan
	FROM Ta_KIB_B A INNER JOIN 
                       (SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen,A.Kondisi
                        FROM Ta_KIBBR A INNER JOIN 
                                       (SELECT IDPemda,MAX(Kd_Id) AS KD_Id
                                        FROM Ta_KIBBR
                                        WHERE Kd_Riwayat = 1 AND Kondisi >= 3
                                        GROUP BY IDPemda
                                       ) B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id  
                        ) B ON A.IDPemda = B.IDPemda
	WHERE A.Tgl_Pembukuan >= B.Tgl_Dokumen AND A.Kondisi < 3
	)A INNER JOIN
	Ta_KIB_B B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB      
  	SELECT 'KIB B' AS KIB, 'B.7' AS KIB_No, 'Kondisi Aset berbeda di Riwayat pindah ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
         	B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
        SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, B.Kondisi FROM Ta_KIBBR A INNER JOIN 
                             (SELECT A.IDPemda,A.KD_Id,A.Kondisi,A.Tgl_Dokumen 
                              FROM Ta_KIBBR A INNER JOIN 
                                              (SELECT IDPemda,MIN(Kd_Id) AS KD_Id,MIN(Tgl_Dokumen) AS Tgl_Dokumen FROM Ta_KIBBR
                                               WHERE Kd_Riwayat = 1 AND Kondisi >= 3
                                               GROUP BY IDPemda
                                               ) B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id
                             ) B ON A.IDPemda = B.IDPemda 
         WHERE A.Kd_Riwayat = 3 AND A.Tgl_Dokumen >= B.Tgl_Dokumen AND A.Kondisi < 3
	-- ORDER BY A.IDPemda
        )A INNER JOIN
	Ta_KIBBR B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 
	WHERE B.KD_RIWAYAT = 3
	

	INSERT INTO @tmpKIB
  	SELECT 'KIB B' AS KIB, 'B.8' AS KIB_No, 'TglDokumen lebih kecil dari TglPerolehan ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
         	B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
 	FROM (
       	SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen,A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi
      	FROM Ta_KIBBR A INNER JOIN Ta_KIB_B B ON A.IDPemda = B.IDPemda  
       	WHERE A.Tgl_Dokumen < A.Tgl_Perolehan
       	) A INNER JOIN
	Ta_KIB_B B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB
  	SELECT 'KIB B' AS KIB, 'B.9' AS KIB_No, 'TglPembukuan lebih kecil dari TglPerolehan ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
         	B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Pembukuan AS Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, A.Kondisi AS KondisiK
  	FROM (
        SELECT IDPemda,Tgl_Pembukuan,Tgl_Perolehan, Kondisi
        FROM Ta_KIB_B
        WHERE Tgl_Pembukuan < Tgl_Perolehan
       	) A INNER JOIN
 	Ta_KIB_B B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5
 

	INSERT INTO @tmpKIB
  	SELECT 'KIB B' AS KIB, 'B.10' AS KIB_No, 'KdKA beda KIB dan riwayat ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
         	B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kd_KA AS KondisiR, B.Kd_KA AS KondisiK
  	FROM (
        SELECT A.IDPemda,A.Kd_Id, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.KD_KA
        FROM Ta_KIBBR A INNER JOIN 
                        (SELECT IDPemda FROM Ta_KIB_B WHERE Kd_KA = 0
                        ) B ON A.IDPemda = B.IDPemda
        WHERE A.Kd_KA <> 0                
        ) A INNER JOIN
 	Ta_KIB_B B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 	B.Kd_Aset5 = D.Kd_Aset5



------- KIB C
	INSERT INTO @tmpKIB
 	SELECT 'KIB C' AS KIB, 'C.0' AS KIB_No, 'IDPemda ada diriwayat tidak ada di KIB' AS Judul, A.IDPemda, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, C.Nm_UPB, 
	A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan,
	A.Kondisi AS KondisiR, A.Kondisi AS KondisiK
  	FROM Ta_KIBCR A LEFT OUTER JOIN
	TA_KIB_C B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 AND 
 			   A.Kd_Aset5 = D.Kd_Aset5 
	WHERE B.IDPEMDA IS NULL
 

	INSERT INTO @tmpKIB
  	SELECT 'KIB C' AS KIB, 'C.1' AS KIB_No, 'TglPerolehan berbeda di KIB dan KIB riwayat' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
		B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan1, A.Tgl_Perolehan2 AS Tgl_Pembukuan,  A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
        SELECT A.IDPemda,SUM(A.Kd_Id) AS Kd_Id, '18000101' AS Tgl_Dokumen, MAX(A.Tgl_Perolehan1) AS Tgl_Perolehan1,MAX(A.Tgl_Perolehan2) AS Tgl_Perolehan2, '0' AS Kondisi
        FROM (
              SELECT A.IDPemda,2 AS Kode,MAX(A.Kd_Id) AS Kd_Id,A.Tgl_Dokumen, '18000101' AS Tgl_Perolehan1,A.Tgl_Perolehan AS Tgl_Perolehan2
              FROM Ta_KIBCR A INNER JOIN
                              (SELECT IDPemda,MIN(Tgl_Perolehan) AS Tgl_Perolehan 
                               FROM Ta_KIBCR WHERE Kd_Riwayat = 3 
                               GROUP BY IDPemda 
                               ) B ON A.IDPemda = B.IDPemda AND A.Tgl_Perolehan = B.Tgl_Perolehan  
              WHERE A.Kd_Riwayat = 3             
              GROUP BY A.IDPemda,A.Tgl_Perolehan,A.Tgl_Dokumen                 
              UNION ALL                
            SELECT A.IDPemda,1,0,A.Tgl_pembukuan AS Tgl_Dokumen, A.Tgl_Perolehan,'18000101'
              FROM Ta_KIB_C A INNER JOIN
                             (SELECT IDPemda FROM Ta_KIBCR WHERE Kd_Riwayat = 3 GROUP BY IDPemda 
                             ) B ON A.IDPemda = B.IDPemda
              ) A
        GROUP BY A.IDPemda
        HAVING MAX(A.Tgl_Perolehan1) > MAX(A.Tgl_Perolehan2)   
       	) A INNER JOIN
 	Ta_KIB_C B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB
  	SELECT 'KIB C' AS KIB, 'C.2' AS KIB_No, 'TglPerolehan di KIB riwayat dibawah 1800' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, 
	B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5,B.No_Register, D.Nm_Aset5, B.Tgl_Pembukuan AS Tgl_Dokumen, A.Tgl_Perolehan1 AS Tgl_Perolehan, A.Tgl_Perolehan2 AS Tgl_Pembukuan,
	B.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
       	SELECT A.IDPemda,SUM(A.Kd_Id) AS Kd_Id,MAX(A.Tgl_Perolehan1) AS Tgl_Perolehan1,MAX(A.Tgl_Perolehan2) AS Tgl_Perolehan2
        FROM (
              SELECT A.IDPemda,2 AS Kode,MAX(A.Kd_Id) AS Kd_Id,'18000101' AS Tgl_Perolehan1,A.Tgl_Perolehan AS Tgl_Perolehan2 
              FROM Ta_KIBCR A INNER JOIN
                              (SELECT IDPemda,MIN(Tgl_Perolehan) AS Tgl_Perolehan 
                               FROM Ta_KIBCR WHERE Kd_Riwayat = 3 
                               GROUP BY IDPemda 
                               ) B ON A.IDPemda = B.IDPemda AND A.Tgl_Perolehan = B.Tgl_Perolehan  
              WHERE A.Kd_Riwayat = 3             
              GROUP BY A.IDPemda,A.Tgl_Perolehan                       
              UNION ALL                
              SELECT A.IDPemda,1,0,A.Tgl_Perolehan,'18000101'
              FROM Ta_KIB_C A INNER JOIN
                             (SELECT IDPemda FROM Ta_KIBCR WHERE Kd_Riwayat = 3 GROUP BY IDPemda 
                             ) B ON A.IDPemda = B.IDPemda
              ) A
        GROUP BY A.IDPemda     
        HAVING MAX(A.Tgl_Perolehan1) < MAX(A.Tgl_Perolehan2)    
       	) A INNER JOIN
	Ta_KIBCR B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 
    	GROUP BY A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, 
		B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5,B.No_Register, D.Nm_Aset5, B.Tgl_Pembukuan, A.Tgl_Perolehan1, A.Tgl_Perolehan2, B.Kondisi, B.Kondisi 


	INSERT INTO @tmpKIB
	SELECT 'KIB C' AS KIB, 'B.3' AS KIB_No, 'TglPembukuan berbeda dgn TglDokumen pindah' AS Judul, A.IDPemda, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, C.Nm_UPB, 
	A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register, D.Nm_Aset5,
	A.Tgl_Dokumen,  A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, A.Kondisi AS KondisiK
  	FROM(
        SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,
              A.Kd_Aset5,A.No_Register,A.Tgl_Pembukuan, B.Tgl_Dokumen, B.Tgl_Perolehan, A.Kondisi
	FROM Ta_KIB_C A INNER JOIN
		(
		SELECT A.IDPemda,A.Tgl_Dokumen,A.Tgl_Perolehan 
		FROM Ta_KIBCR A INNER JOIN
			(SELECT IDPemda, Max (Kd_Id) AS Kd_Id
			FROM Ta_KIBCR
			WHERE Kd_riwayat = 3
			GROUP BY IDPemda) B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id
		) B ON A.IDPEMDA = B.IDPEMDA
	WHERE A.Tgl_Pembukuan <> B.Tgl_Dokumen 
	) A INNER JOIN
	Ref_UPB C ON A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 AND 
 			   A.Kd_Aset5 = D.Kd_Aset5 
	GROUP BY A.IDPemda, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, C.Nm_UPB, 
		A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register, D.Nm_Aset5,
		A.Tgl_Dokumen,  A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi


	INSERT INTO @tmpKIB
	SELECT 'KIB C' AS KIB, 'C.4' AS KIB_No, 'TglDokumen pindah lebih besar dari Tglriwayat lain' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, 
	B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
        SELECT A.IDPemda,A.Kd_Id,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,
               A.Kd_Aset4,A.Kd_Aset5,A.No_Register,B.Tgl_Dokumen,B.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi
        FROM Ta_KIBCR A INNER JOIN 
                        (SELECT A.IDPemda,A.Kd_Id,A.Kd_Prov1,A.Kd_Kab_Kota1,A.Kd_Bidang1,A.Kd_Unit1,A.Kd_Sub1,A.Kd_UPB1,
                                A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register1,A.Tgl_Dokumen,A.Tgl_Perolehan
                         FROM Ta_KIBCR A
                         WHERE A.Kd_Riwayat = 3
                         ) B ON A.IDPemda = B.IDPemda AND A.Kd_Prov = B.Kd_Prov1 AND A.Kd_Kab_Kota = B.Kd_Kab_Kota1 AND A.Kd_Bidang = B.Kd_Bidang1 AND A.Kd_Unit = B.Kd_Unit1 AND 
                                A.Kd_Sub = B.Kd_Sub1 AND A.Kd_UPB = B.Kd_UPB1 AND A.Kd_Aset1 LIKE B.Kd_Aset1 AND A.Kd_Aset2 LIKE B.Kd_Aset2 AND 
                                A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register1
        WHERE A.Kd_Riwayat <> 3 AND A.Tgl_Dokumen < B.Tgl_Dokumen                                                  
        ) A INNER JOIN
 	Ta_KIBCR B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB                                                       
  	SELECT 'KIB C' AS KIB, 'C.5' AS KIB_No, 'TglDokumen pindah lebih kecil dari TglPembukuan' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
         B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
        SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen,B.Tgl_Pembukuan, A.Tgl_Perolehan, A.Kondisi
        FROM Ta_KIBCR A INNER JOIN 
                        (
                         SELECT A.IDPemda,A.Tgl_Pembukuan 
                         FROM Ta_KIB_C A LEFT OUTER JOIN 
                                         (SELECT IDPemda,MAX(Kd_Id) AS Kd_Id FROM Ta_KIBCR
                                          WHERE Kd_Riwayat = 3
                                          GROUP BY IDPemda
                                          ) B ON A.IDPemda = B.IDPemda 
                         WHERE B.IDPemda IS NULL
                         ) B ON A.IDPemda = B.IDPemda
        WHERE A.Kd_Riwayat <> 3 AND A.Tgl_Dokumen < B.Tgl_Pembukuan                                
       	) A INNER JOIN
	Ta_KIB_C B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB
  	SELECT 'KIB C' AS KIB, 'C.6' AS KIB_No, 'Kondisi Aset di Riwayat berbeda dengan di KIB' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
		B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM(
       	SELECT A.IDPemda,B.Tgl_Dokumen,B.Kondisi, A.Tgl_Perolehan, A.Tgl_Pembukuan
       	FROM Ta_KIB_C A INNER JOIN 
                       (SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen,A.Kondisi
                        FROM Ta_KIBCR A INNER JOIN 
                                       (SELECT IDPemda,MAX(Kd_Id) AS KD_Id
                                        FROM Ta_KIBCR
                                        WHERE Kd_Riwayat = 1 AND Kondisi >= 3
                                        GROUP BY IDPemda
                                       ) B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id  
                        ) B ON A.IDPemda = B.IDPemda
       	WHERE A.Tgl_Pembukuan >= B.Tgl_Dokumen AND A.Kondisi < 3
      	)A INNER JOIN
	Ta_KIB_C B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB  
	SELECT 'KIB C' AS KIB, 'C.7' AS KIB_No, 'Kondisi Aset berbeda di Riwayat pindah ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
		B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
	FROM (
        SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, B.Kondisi FROM Ta_KIBBR A INNER JOIN 
                             (SELECT A.IDPemda,A.KD_Id,A.Kondisi,A.Tgl_Dokumen 
                              FROM Ta_KIBCR A INNER JOIN 
                                              (SELECT IDPemda,MIN(Kd_Id) AS KD_Id,MIN(Tgl_Dokumen) AS Tgl_Dokumen FROM Ta_KIBCR
                                               WHERE Kd_Riwayat = 1 AND Kondisi >= 3
                                               GROUP BY IDPemda
                                               ) B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id
                             ) B ON A.IDPemda = B.IDPemda 
         WHERE A.Kd_Riwayat = 3 AND A.Tgl_Dokumen >= B.Tgl_Dokumen AND A.Kondisi < 3
	-- ORDER BY A.IDPemda
        )A INNER JOIN
	Ta_KIBCR B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 
	WHERE B.KD_RIWAYAT = 3
	

	INSERT INTO @tmpKIB
	SELECT 'KIB C' AS KIB, 'C.8' AS KIB_No, 'TglDokumen lebih kecil dari TglPerolehan ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
         	B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
 	FROM (
       	SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen,A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi
       	FROM Ta_KIBCR A INNER JOIN Ta_KIB_C B ON A.IDPemda = B.IDPemda  
       	WHERE A.Tgl_Dokumen < A.Tgl_Perolehan
       	) A INNER JOIN
	Ta_KIB_C B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB
  	SELECT 'KIB C' AS KIB, 'C.9' AS KIB_No, 'TglPembukuan lebih kecil dari TglPerolehan ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
		B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Pembukuan AS Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, A.Kondisi AS KondisiK
 	FROM (
        SELECT IDPemda,Tgl_Pembukuan,Tgl_Perolehan, Kondisi
        FROM Ta_KIB_C
        WHERE Tgl_Pembukuan < Tgl_Perolehan
       	) A INNER JOIN
 	Ta_KIB_C B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5
 

	INSERT INTO @tmpKIB
  	SELECT 'KIB C' AS KIB, 'C.10' AS KIB_No, 'KdKA beda KIB dan riwayat ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
	B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kd_KA AS KondisiR, B.Kd_KA AS KondisiK
  	FROM (
        SELECT A.IDPemda,A.Kd_Id, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.KD_KA
        FROM Ta_KIBCR A INNER JOIN 
                        (SELECT IDPemda FROM Ta_KIB_C WHERE Kd_KA = 0
                        ) B ON A.IDPemda = B.IDPemda
        WHERE A.Kd_KA <> 0                
        ) A INNER JOIN
 	Ta_KIB_C B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5


------- KIB D
	INSERT INTO @tmpKIB
 	SELECT 'KIB D' AS KIB, 'D.0' AS KIB_No, 'IDPemda ada diriwayat tidak ada di KIB' AS Judul, A.IDPemda, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, C.Nm_UPB, 
	A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, A.Kondisi AS KondisiK
  	FROM Ta_KIBDR A LEFT OUTER JOIN
	TA_KIB_D B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 AND 
 			   A.Kd_Aset5 = D.Kd_Aset5 
	WHERE B.IDPEMDA IS NULL
 

	INSERT INTO @tmpKIB
  	SELECT 'KIB D' AS KIB, 'D.1' AS KIB_No, 'TglPerolehan berbeda di KIB dan KIB riwayat' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
		B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan1, A.Tgl_Perolehan2 AS Tgl_Pembukuan,  A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
        SELECT A.IDPemda,SUM(A.Kd_Id) AS Kd_Id, '18000101' AS Tgl_Dokumen, MAX(A.Tgl_Perolehan1) AS Tgl_Perolehan1,MAX(A.Tgl_Perolehan2) AS Tgl_Perolehan2, '0' AS Kondisi
        FROM (
              SELECT A.IDPemda,2 AS Kode,MAX(A.Kd_Id) AS Kd_Id,A.Tgl_Dokumen, '18000101' AS Tgl_Perolehan1,A.Tgl_Perolehan AS Tgl_Perolehan2
              FROM Ta_KIBDR A INNER JOIN
                              (SELECT IDPemda,MIN(Tgl_Perolehan) AS Tgl_Perolehan 
                               FROM Ta_KIBDR WHERE Kd_Riwayat = 3 
                               GROUP BY IDPemda 
                               ) B ON A.IDPemda = B.IDPemda AND A.Tgl_Perolehan = B.Tgl_Perolehan  
              WHERE A.Kd_Riwayat = 3             
              GROUP BY A.IDPemda,A.Tgl_Perolehan,A.Tgl_Dokumen                 
              UNION ALL                
            SELECT A.IDPemda,1,0,A.Tgl_pembukuan AS Tgl_Dokumen, A.Tgl_Perolehan,'18000101'
              FROM Ta_KIB_D A INNER JOIN
                             (SELECT IDPemda FROM Ta_KIBDR WHERE Kd_Riwayat = 3 GROUP BY IDPemda 
                             ) B ON A.IDPemda = B.IDPemda
              ) A
        GROUP BY A.IDPemda
        HAVING MAX(A.Tgl_Perolehan1) > MAX(A.Tgl_Perolehan2)   
	) A INNER JOIN
 	Ta_KIB_D B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB
  	SELECT 'KIB D' AS KIB, 'D.2' AS KIB_No, 'TglPerolehan di KIB riwayat dibawah 1800' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, 
		B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5,B.No_Register, D.Nm_Aset5, B.Tgl_Pembukuan AS Tgl_Dokumen, A.Tgl_Perolehan1 AS Tgl_Perolehan, A.Tgl_Perolehan2 AS Tgl_Pembukuan, 
		B.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
       	SELECT A.IDPemda,SUM(A.Kd_Id) AS Kd_Id,MAX(A.Tgl_Perolehan1) AS Tgl_Perolehan1,MAX(A.Tgl_Perolehan2) AS Tgl_Perolehan2
        FROM (
              SELECT A.IDPemda,2 AS Kode,MAX(A.Kd_Id) AS Kd_Id,'18000101' AS Tgl_Perolehan1,A.Tgl_Perolehan AS Tgl_Perolehan2 
              FROM Ta_KIBDR A INNER JOIN
                              (SELECT IDPemda,MIN(Tgl_Perolehan) AS Tgl_Perolehan 
                               FROM Ta_KIBDR WHERE Kd_Riwayat = 3 
                               GROUP BY IDPemda 
                               ) B ON A.IDPemda = B.IDPemda AND A.Tgl_Perolehan = B.Tgl_Perolehan  
              WHERE A.Kd_Riwayat = 3             
              GROUP BY A.IDPemda,A.Tgl_Perolehan                       
              UNION ALL                
              SELECT A.IDPemda,1,0,A.Tgl_Perolehan,'18000101'
              FROM Ta_KIB_D A INNER JOIN
                             (SELECT IDPemda FROM Ta_KIBDR WHERE Kd_Riwayat = 3 GROUP BY IDPemda 
                             ) B ON A.IDPemda = B.IDPemda
              ) A
        GROUP BY A.IDPemda     
        HAVING MAX(A.Tgl_Perolehan1) < MAX(A.Tgl_Perolehan2)    
       	) A LEFT JOIN
	Ta_KIBDR B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 
  	GROUP BY A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, 
		B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5,B.No_Register, D.Nm_Aset5, B.Tgl_Pembukuan, A.Tgl_Perolehan1, A.Tgl_Perolehan2, B.Kondisi, B.Kondisi 


	INSERT INTO @tmpKIB
	SELECT 'KIB D' AS KIB, 'D.3' AS KIB_No, 'TglPembukuan berbeda dgn TglDokumen pindah' AS Judul, A.IDPemda, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, C.Nm_UPB, 
		A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register, D.Nm_Aset5,
		A.Tgl_Dokumen,  A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, A.Kondisi AS KondisiK
  	FROM(
        SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,
              A.Kd_Aset5,A.No_Register,A.Tgl_Pembukuan, B.Tgl_Dokumen, B.Tgl_Perolehan, A.Kondisi
	FROM Ta_KIB_D A INNER JOIN
		(
		SELECT A.IDPemda,A.Tgl_Dokumen,A.Tgl_Perolehan 
		FROM Ta_KIBDR A INNER JOIN
			(SELECT IDPemda, Max (Kd_Id) AS Kd_Id
			FROM Ta_KIBDR
			WHERE Kd_riwayat = 3
			GROUP BY IDPemda) B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id
		) B ON A.IDPEMDA = B.IDPEMDA
	WHERE A.Tgl_Pembukuan <> B.Tgl_Dokumen 
	) A INNER JOIN
	Ref_UPB C ON A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 AND 
 			   A.Kd_Aset5 = D.Kd_Aset5 
	GROUP BY A.IDPemda, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, C.Nm_UPB, 
		A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register, D.Nm_Aset5,
		A.Tgl_Dokumen,  A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi


	INSERT INTO @tmpKIB
  	SELECT 'KIB D' AS KIB, 'D.4' AS KIB_No, 'TglDokumen pindah lebih besar dari Tglriwayat lain' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, 
		B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
        SELECT A.IDPemda,A.Kd_Id,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,
               A.Kd_Aset4,A.Kd_Aset5,A.No_Register,B.Tgl_Dokumen,B.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi
        FROM Ta_KIBDR A INNER JOIN 
                        (SELECT A.IDPemda,A.Kd_Id,A.Kd_Prov1,A.Kd_Kab_Kota1,A.Kd_Bidang1,A.Kd_Unit1,A.Kd_Sub1,A.Kd_UPB1,
                                A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register1,A.Tgl_Dokumen,A.Tgl_Perolehan
                         FROM Ta_KIBDR A
                         WHERE A.Kd_Riwayat = 3
                         ) B ON A.IDPemda = B.IDPemda AND A.Kd_Prov = B.Kd_Prov1 AND A.Kd_Kab_Kota = B.Kd_Kab_Kota1 AND A.Kd_Bidang = B.Kd_Bidang1 AND A.Kd_Unit = B.Kd_Unit1 AND 
                                A.Kd_Sub = B.Kd_Sub1 AND A.Kd_UPB = B.Kd_UPB1 AND A.Kd_Aset1 LIKE B.Kd_Aset1 AND A.Kd_Aset2 LIKE B.Kd_Aset2 AND 
                                A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register1
        WHERE A.Kd_Riwayat <> 3 AND A.Tgl_Dokumen < B.Tgl_Dokumen                                                  
        ) A INNER JOIN
 	Ta_KIBDR B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB                                                       
  	SELECT 'KIB D' AS KIB, 'D.5' AS KIB_No, 'TglDokumen pindah lebih kecil dari TglPembukuan' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
		B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
        SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen,B.Tgl_Pembukuan, A.Tgl_Perolehan, A.Kondisi
        FROM Ta_KIBDR A INNER JOIN 
                        (
                         SELECT A.IDPemda,A.Tgl_Pembukuan 
                         FROM Ta_KIB_D A LEFT OUTER JOIN 
                                         (SELECT IDPemda,MAX(Kd_Id) AS Kd_Id FROM Ta_KIBDR
                                          WHERE Kd_Riwayat = 3
                                          GROUP BY IDPemda
                                          ) B ON A.IDPemda = B.IDPemda 
                         WHERE B.IDPemda IS NULL
                         ) B ON A.IDPemda = B.IDPemda
        WHERE A.Kd_Riwayat <> 3 AND A.Tgl_Dokumen < B.Tgl_Pembukuan                                
       	) A INNER JOIN
	Ta_KIB_D B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 
		GROUP BY A.IDPEMDA, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, 
		B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5,B.No_Register, D.Nm_Aset5, 
		A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi , B.Kondisi 


	INSERT INTO @tmpKIB
  	SELECT 'KIB D' AS KIB, 'D.6' AS KIB_No, 'Kondisi Aset di Riwayat berbeda dengan di KIB' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
	         B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM(
       	SELECT A.IDPemda,B.Tgl_Dokumen,B.Kondisi, A.Tgl_Perolehan, A.Tgl_Pembukuan
       	FROM Ta_KIB_D A INNER JOIN 
                       (SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen,A.Kondisi
                        FROM Ta_KIBDR A INNER JOIN 
                                       (SELECT IDPemda,MAX(Kd_Id) AS KD_Id
                                        FROM Ta_KIBDR
                                        WHERE Kd_Riwayat = 1 AND Kondisi >= 3
                                        GROUP BY IDPemda
                                       ) B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id  
                        ) B ON A.IDPemda = B.IDPemda
       	WHERE A.Tgl_Pembukuan >= B.Tgl_Dokumen AND A.Kondisi < 3
      	)A INNER JOIN
	Ta_KIB_D B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB   
	SELECT 'KIB D' AS KIB, 'D.7' AS KIB_No, 'Kondisi Aset berbeda di Riwayat pindah ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
		B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
        SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, B.Kondisi FROM Ta_KIBBR A INNER JOIN 
                             (SELECT A.IDPemda,A.KD_Id,A.Kondisi,A.Tgl_Dokumen 
                              FROM Ta_KIBDR A INNER JOIN 
                                              (SELECT IDPemda,MIN(Kd_Id) AS KD_Id,MIN(Tgl_Dokumen) AS Tgl_Dokumen FROM Ta_KIBDR
                                               WHERE Kd_Riwayat = 1 AND Kondisi >= 3
                                               GROUP BY IDPemda
                                               ) B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id
                             ) B ON A.IDPemda = B.IDPemda 
         WHERE A.Kd_Riwayat = 3 AND A.Tgl_Dokumen >= B.Tgl_Dokumen AND A.Kondisi < 3
	)A INNER JOIN
	Ta_KIBDR B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 
	WHERE B.KD_RIWAYAT = 3
	

	INSERT INTO @tmpKIB
  	SELECT 'KIB D' AS KIB, 'D.8' AS KIB_No, 'TglDokumen lebih kecil dari TglPerolehan ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
		B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
 	FROM (
       	SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen,A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi
       	FROM Ta_KIBDR A INNER JOIN Ta_KIB_D B ON A.IDPemda = B.IDPemda  
       	WHERE A.Tgl_Dokumen < A.Tgl_Perolehan
       	) A INNER JOIN
	Ta_KIB_D B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB
  	SELECT 'KIB D' AS KIB, 'D.9' AS KIB_No, 'TglPembukuan lebih kecil dari TglPerolehan ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
		B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Pembukuan AS Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, A.Kondisi AS KondisiK
  	FROM (
        SELECT IDPemda,Tgl_Pembukuan,Tgl_Perolehan, Kondisi
        FROM Ta_KIB_D
        WHERE Tgl_Pembukuan < Tgl_Perolehan
       	) A INNER JOIN
 	Ta_KIB_D B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5
 

	INSERT INTO @tmpKIB
  	SELECT 'KIB D' AS KIB, 'D.10' AS KIB_No, 'KdKA beda KIB dan riwayat ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
		B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kd_KA AS KondisiR, B.Kd_KA AS KondisiK
  	FROM (
        SELECT A.IDPemda,A.Kd_Id, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.KD_KA
        FROM Ta_KIBDR A INNER JOIN 
                        (SELECT IDPemda FROM Ta_KIB_D WHERE Kd_KA = 0
                        ) B ON A.IDPemda = B.IDPemda
        WHERE A.Kd_KA <> 0                
        ) A INNER JOIN
 	Ta_KIB_D B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5


------- KIB E
	INSERT INTO @tmpKIB
	SELECT 'KIB E' AS KIB, 'E.0' AS KIB_No, 'IDPemda ada diriwayat tidak ada di KIB' AS Judul, A.IDPemda, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, C.Nm_UPB, 
	A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan,
	A.Kondisi AS KondisiR, A.Kondisi AS KondisiK
  	FROM Ta_KIBER A LEFT OUTER JOIN
	TA_KIB_E B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 AND 
 			   A.Kd_Aset5 = D.Kd_Aset5 
	WHERE B.IDPEMDA IS NULL
 

	INSERT INTO @tmpKIB
  	SELECT 'KIB E' AS KIB, 'E.1' AS KIB_No, 'TglPerolehan berbeda di KIB dan KIB riwayat' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
		B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan1, A.Tgl_Perolehan2 AS Tgl_Pembukuan,  A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
        SELECT A.IDPemda,SUM(A.Kd_Id) AS Kd_Id, '18000101' AS Tgl_Dokumen, MAX(A.Tgl_Perolehan1) AS Tgl_Perolehan1,MAX(A.Tgl_Perolehan2) AS Tgl_Perolehan2, '0' AS Kondisi
        FROM (
              SELECT A.IDPemda,2 AS Kode,MAX(A.Kd_Id) AS Kd_Id,A.Tgl_Dokumen, '18000101' AS Tgl_Perolehan1,A.Tgl_Perolehan AS Tgl_Perolehan2
              FROM Ta_KIBER A INNER JOIN
                              (SELECT IDPemda,MIN(Tgl_Perolehan) AS Tgl_Perolehan 
                               FROM Ta_KIBER WHERE Kd_Riwayat = 3 
                               GROUP BY IDPemda 
                               ) B ON A.IDPemda = B.IDPemda AND A.Tgl_Perolehan = B.Tgl_Perolehan  
              WHERE A.Kd_Riwayat = 3             
              GROUP BY A.IDPemda,A.Tgl_Perolehan,A.Tgl_Dokumen                 
              UNION ALL                
            SELECT A.IDPemda,1,0,A.Tgl_pembukuan AS Tgl_Dokumen, A.Tgl_Perolehan,'18000101'
              FROM Ta_KIB_E A INNER JOIN
                             (SELECT IDPemda FROM Ta_KIBDR WHERE Kd_Riwayat = 3 GROUP BY IDPemda 
                             ) B ON A.IDPemda = B.IDPemda
              ) A
        GROUP BY A.IDPemda
        HAVING MAX(A.Tgl_Perolehan1) > MAX(A.Tgl_Perolehan2)   
	) A INNER JOIN
 	Ta_KIB_E B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB
  	SELECT 'KIB E' AS KIB, 'E.2' AS KIB_No, 'TglPerolehan di KIB riwayat dibawah 1800' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, 
		B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5,B.No_Register, D.Nm_Aset5, B.Tgl_Pembukuan AS Tgl_Dokumen, A.Tgl_Perolehan1 AS Tgl_Perolehan, A.Tgl_Perolehan2 AS Tgl_Pembukuan,
		B.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
       SELECT A.IDPemda,SUM(A.Kd_Id) AS Kd_Id,MAX(A.Tgl_Perolehan1) AS Tgl_Perolehan1,MAX(A.Tgl_Perolehan2) AS Tgl_Perolehan2
        FROM (
              SELECT A.IDPemda,2 AS Kode,MAX(A.Kd_Id) AS Kd_Id,'18000101' AS Tgl_Perolehan1,A.Tgl_Perolehan AS Tgl_Perolehan2 
              FROM Ta_KIBER A INNER JOIN
                              (SELECT IDPemda,MIN(Tgl_Perolehan) AS Tgl_Perolehan 
                               FROM Ta_KIBER WHERE Kd_Riwayat = 3 
                               GROUP BY IDPemda 
                               ) B ON A.IDPemda = B.IDPemda AND A.Tgl_Perolehan = B.Tgl_Perolehan  
              WHERE A.Kd_Riwayat = 3             
              GROUP BY A.IDPemda,A.Tgl_Perolehan                       
              UNION ALL                
              SELECT A.IDPemda,1,0,A.Tgl_Perolehan,'18000101'
              FROM Ta_KIB_E A INNER JOIN
                             (SELECT IDPemda FROM Ta_KIBDR WHERE Kd_Riwayat = 3 GROUP BY IDPemda 
                             ) B ON A.IDPemda = B.IDPemda
              ) A
        GROUP BY A.IDPemda     
        HAVING MAX(A.Tgl_Perolehan1) < MAX(A.Tgl_Perolehan2)    
       ) A LEFT JOIN
	Ta_KIBER B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 
  	GROUP BY A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, 
	B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5,B.No_Register, D.Nm_Aset5, B.Tgl_Pembukuan, A.Tgl_Perolehan1, A.Tgl_Perolehan2, B.Kondisi, B.Kondisi  


	INSERT INTO @tmpKIB
	SELECT 'KIB E' AS KIB, 'E.3' AS KIB_No, 'TglPembukuan berbeda dgn TglDokumen pindah' AS Judul, A.IDPemda, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, C.Nm_UPB, 
		A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register, D.Nm_Aset5,
		A.Tgl_Dokumen,  A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, A.Kondisi AS KondisiK
  	FROM(
        SELECT A.IDPemda,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,
              A.Kd_Aset5,A.No_Register,A.Tgl_Pembukuan, B.Tgl_Dokumen, B.Tgl_Perolehan, A.Kondisi
	FROM Ta_KIB_E A INNER JOIN
		(
		SELECT A.IDPemda,A.Tgl_Dokumen,A.Tgl_Perolehan 
		FROM Ta_KIBER A INNER JOIN
			(SELECT IDPemda, Max (Kd_Id) AS Kd_Id
			FROM Ta_KIBER
			WHERE Kd_riwayat = 3
			GROUP BY IDPemda) B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id
		) B ON A.IDPEMDA = B.IDPEMDA
	WHERE A.Tgl_Pembukuan <> B.Tgl_Dokumen 
	) A INNER JOIN
	Ref_UPB C ON A.Kd_Bidang = C.Kd_Bidang AND A.Kd_Unit = C.Kd_Unit AND A.Kd_Sub = C.Kd_Sub AND A.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON A.Kd_Aset1 = D.Kd_Aset1 AND A.Kd_Aset2 = D.Kd_Aset2 AND A.Kd_Aset3 = D.Kd_Aset3 AND A.Kd_Aset4 = D.Kd_Aset4 AND A.Kd_Aset5 = D.Kd_Aset5 AND 
 			   A.Kd_Aset5 = D.Kd_Aset5 
	GROUP BY A.IDPemda, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, C.Nm_UPB, 
		A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register, D.Nm_Aset5,
		A.Tgl_Dokumen,  A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi


	INSERT INTO @tmpKIB
  	SELECT 'KIB E' AS KIB, 'E.4' AS KIB_No, 'TglDokumen pindah lebih besar dari Tglriwayat lain' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, 
		B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
        SELECT A.IDPemda,A.Kd_Id,A.Kd_Prov,A.Kd_Kab_Kota,A.Kd_Bidang,A.Kd_Unit,A.Kd_Sub,A.Kd_UPB,A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,
               A.Kd_Aset4,A.Kd_Aset5,A.No_Register,B.Tgl_Dokumen,B.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi
        FROM Ta_KIBER A INNER JOIN 
                        (SELECT A.IDPemda,A.Kd_Id,A.Kd_Prov1,A.Kd_Kab_Kota1,A.Kd_Bidang1,A.Kd_Unit1,A.Kd_Sub1,A.Kd_UPB1,
                                A.Kd_Aset1,A.Kd_Aset2,A.Kd_Aset3,A.Kd_Aset4,A.Kd_Aset5,A.No_Register1,A.Tgl_Dokumen,A.Tgl_Perolehan
                         FROM Ta_KIBER A
                         WHERE A.Kd_Riwayat = 3
                         ) B ON A.IDPemda = B.IDPemda AND A.Kd_Prov = B.Kd_Prov1 AND A.Kd_Kab_Kota = B.Kd_Kab_Kota1 AND A.Kd_Bidang = B.Kd_Bidang1 AND A.Kd_Unit = B.Kd_Unit1 AND 
                                A.Kd_Sub = B.Kd_Sub1 AND A.Kd_UPB = B.Kd_UPB1 AND A.Kd_Aset1 LIKE B.Kd_Aset1 AND A.Kd_Aset2 LIKE B.Kd_Aset2 AND 
                                A.Kd_Aset3 = B.Kd_Aset3 AND A.Kd_Aset4 = B.Kd_Aset4 AND A.Kd_Aset5 = B.Kd_Aset5 AND A.No_Register = B.No_Register1
        WHERE A.Kd_Riwayat <> 3 AND A.Tgl_Dokumen < B.Tgl_Dokumen                                                  
        ) A INNER JOIN
 	Ta_KIBER B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB                                                       
  	SELECT 'KIB E' AS KIB, 'E.5' AS KIB_No, 'TglDokumen pindah lebih kecil dari TglPembukuan' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
	         B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
        SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen,B.Tgl_Pembukuan, A.Tgl_Perolehan, A.Kondisi
        FROM Ta_KIBER A INNER JOIN 
                        (
                         SELECT A.IDPemda,A.Tgl_Pembukuan 
                         FROM Ta_KIB_E A LEFT OUTER JOIN 
                                         (SELECT IDPemda,MAX(Kd_Id) AS Kd_Id FROM Ta_KIBER
                                          WHERE Kd_Riwayat = 3
                                          GROUP BY IDPemda
                                          ) B ON A.IDPemda = B.IDPemda 
                         WHERE B.IDPemda IS NULL
                         ) B ON A.IDPemda = B.IDPemda
        WHERE A.Kd_Riwayat <> 3 AND A.Tgl_Dokumen < B.Tgl_Pembukuan                                
       ) A INNER JOIN
	Ta_KIB_E B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 
		GROUP BY A.IDPEMDA, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, 
		B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,B.Kd_Aset5,B.No_Register, D.Nm_Aset5, 
		A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi , B.Kondisi 


	INSERT INTO @tmpKIB
  	SELECT 'KIB E' AS KIB, 'E.6' AS KIB_No, 'Kondisi Aset di Riwayat berbeda dengan di KIB' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
		B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM(
       	SELECT A.IDPemda,B.Tgl_Dokumen,B.Kondisi, A.Tgl_Perolehan, A.Tgl_Pembukuan
       	FROM Ta_KIB_E A INNER JOIN 
                       (SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen,A.Kondisi
                        FROM Ta_KIBER A INNER JOIN 
                                       (SELECT IDPemda,MAX(Kd_Id) AS KD_Id
                                        FROM Ta_KIBER
                                        WHERE Kd_Riwayat = 1 AND Kondisi >= 3
                                        GROUP BY IDPemda
                                       ) B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id  
                        ) B ON A.IDPemda = B.IDPemda
       	WHERE A.Tgl_Pembukuan >= B.Tgl_Dokumen AND A.Kondisi < 3
      	)A INNER JOIN
	Ta_KIB_E B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB    
  	SELECT 'KIB E' AS KIB, 'E.7' AS KIB_No, 'Kondisi Aset berbeda di Riwayat pindah ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
		B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
  	FROM (
        SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, B.Kondisi FROM Ta_KIBBR A INNER JOIN 
                             (SELECT A.IDPemda,A.KD_Id,A.Kondisi,A.Tgl_Dokumen 
                              FROM Ta_KIBER A INNER JOIN 
                                              (SELECT IDPemda,MIN(Kd_Id) AS KD_Id,MIN(Tgl_Dokumen) AS Tgl_Dokumen FROM Ta_KIBER
                                               WHERE Kd_Riwayat = 1 AND Kondisi >= 3
                                               GROUP BY IDPemda
                                               ) B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id
                             ) B ON A.IDPemda = B.IDPemda 
	WHERE A.Kd_Riwayat = 3 AND A.Tgl_Dokumen >= B.Tgl_Dokumen AND A.Kondisi < 3
	)A INNER JOIN
	Ta_KIBER B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 
	WHERE B.KD_RIWAYAT = 3
	

	INSERT INTO @tmpKIB
  	SELECT 'KIB E' AS KIB, 'E.8' AS KIB_No, 'TglDokumen lebih kecil dari TglPerolehan ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
		B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, B.Kondisi AS KondisiK
	 FROM (
       	SELECT A.IDPemda,A.Kd_Id,A.Tgl_Dokumen,A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi
       	FROM Ta_KIBER A INNER JOIN Ta_KIB_E B ON A.IDPemda = B.IDPemda  
       	WHERE A.Tgl_Dokumen < A.Tgl_Perolehan
       	) A INNER JOIN
	Ta_KIB_E B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5 


	INSERT INTO @tmpKIB
  	SELECT 'KIB E' AS KIB, 'E.9' AS KIB_No, 'TglPembukuan lebih kecil dari TglPerolehan ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
	B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Pembukuan AS Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kondisi AS KondisiR, A.Kondisi AS KondisiK
  	FROM (
        SELECT IDPemda,Tgl_Pembukuan,Tgl_Perolehan, Kondisi
        FROM Ta_KIB_E
        WHERE Tgl_Pembukuan < Tgl_Perolehan
       	) A INNER JOIN
 	Ta_KIB_E B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5
 

	INSERT INTO @tmpKIB
  	SELECT 'KIB E' AS KIB, 'E.10' AS KIB_No, 'KdKA beda KIB dan riwayat ' AS Judul, A.IDPemda, B.Kd_Bidang, B.Kd_Unit, B.Kd_Sub, B.Kd_UPB, C.Nm_UPB, B.Kd_Aset1,B.Kd_Aset2,B.Kd_Aset3,B.Kd_Aset4,
		B.Kd_Aset5,B.No_Register, D.Nm_Aset5, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.Kd_KA AS KondisiR, B.Kd_KA AS KondisiK
	FROM (
        SELECT A.IDPemda,A.Kd_Id, A.Tgl_Dokumen, A.Tgl_Perolehan, A.Tgl_Pembukuan, A.KD_KA
        FROM Ta_KIBER A INNER JOIN 
                        (SELECT IDPemda FROM Ta_KIB_E WHERE Kd_KA = 0
                        ) B ON A.IDPemda = B.IDPemda
        WHERE A.Kd_KA <> 0                
        ) A INNER JOIN
 	Ta_KIB_E B ON A.IDPemda = B.IDPemda INNER JOIN
	Ref_UPB C ON B.Kd_Bidang = C.Kd_Bidang AND B.Kd_Unit = C.Kd_Unit AND B.Kd_Sub = C.Kd_Sub AND B.Kd_UPB = C.Kd_UPB INNER JOIN
	Ref_Rek_Aset5 D ON B.Kd_Aset1 = D.Kd_Aset1 AND B.Kd_Aset2 = D.Kd_Aset2 AND B.Kd_Aset3 = D.Kd_Aset3 AND B.Kd_Aset4 = D.Kd_Aset4 AND B.Kd_Aset5 = D.Kd_Aset5 AND 
 			   B.Kd_Aset5 = D.Kd_Aset5


	SELECT KIB, KIB_No, Judul, IDPemda, [dbo].[fn_GabUPB] (Kd_Bidang, Kd_Unit, Kd_Sub, Kd_UPB) AS Gab_UPB, 
		Nm_UPB, [dbo].[fn_GabRekening] (Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5) AS Gab_Rekening, No_Register, 
		Nm_Aset5, Tgl_Dokumen, Tgl_Perolehan, Tgl_Pembukuan, KondisiR, KondisiK
	FROM @tmpKIB

GO
