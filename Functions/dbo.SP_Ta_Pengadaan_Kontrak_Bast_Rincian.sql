USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE SP_Ta_Pengadaan_Kontrak_Bast_Rincian @Tahun varchar(4), @No_Kontrak varchar(50), @No_SP2D varchar(50), @No_Bast varchar(50), @Log_User varchar(25)
WITH ENCRYPTION    
AS

/*
	DECLARE @Tahun varchar(4), @No_Kontrak varchar(50), @No_SP2D varchar(50), @No_Bast varchar(50), @Log_User varchar(25)
	SET @Tahun = '2020'
	SET @No_Kontrak = '777'
	SET @No_SP2D = '777BSP2D' --9228/KBUD-LS/DISKES/DAK/XII/2016
	SET @No_Bast = '777BAST'
	SET @Log_User = 'dwi'
--*/

	DECLARE @TglPerolehan DateTime, @TglPembukuan DateTime, @sKdPemilik Varchar(2)
	SELECT TOP 1 @TglPerolehan = Tgl_BAST, @TglPembukuan = Tgl_BAST, @sKdPemilik = CASE WHEN Kd_Kab_Kota = 0 THEN '11' ELSE '12' END FROM Ta_Pengadaan_Bast
	WHERE Tahun = @Tahun AND No_Kontrak = @No_Kontrak AND No_Bast = @No_BAST



	if @No_Kontrak <> ''
	BEGIN
		DELETE FROM Ta_Pengadaan_Bast_Rinc WHERE Tahun = @Tahun AND No_BAST = @No_Bast

		DECLARE tnames_cursor CURSOR
		FOR
			SELECT RIGHT('00' + CONVERT(varchar, No_ID), 3) +
			RIGHT('0' + CONVERT(varchar, Kd_Aset8), 2) + RIGHT('0' + CONVERT(varchar, Kd_Aset80), 2) + RIGHT('0' + CONVERT(varchar, Kd_Aset81), 2) + 
			RIGHT('0' + CONVERT(varchar, Kd_Aset82), 2) + RIGHT('0' + CONVERT(varchar, Kd_Aset83), 2) + RIGHT('0' + CONVERT(varchar, Kd_Aset84), 2) + RIGHT('00' + CONVERT(varchar, Kd_Aset85), 3) +
			+ LEFT(RIGHT('000' + CONVERT(varchar, Jumlah), 7),4) AS Kd_AsetGab
			FROM Ta_Pengadaan_Rinc 
			WHERE Tahun = @Tahun AND No_Kontrak = @No_Kontrak
			ORDER BY Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5
		OPEN tnames_cursor

		--00102080113062001
		--001051701010011199
		--0010103030101010010001

		DECLARE @tablename Varchar(22), @tablename1 Varchar(22)
		DECLARE @intFlag Int, @intJml Int, @intReg Int, @intRegT Int
		SET @intReg  = 0
		SET @intRegT = 0

		FETCH NEXT FROM tnames_cursor INTO @tablename
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
   			IF (@@FETCH_STATUS <> -2)
   			BEGIN   
				SET @intJml = 0
				SET @intJml = SubString(@tablename,19,4)
				SET @intFlag = 1
				IF (SubString(@tablename,4,15) <> SubString(@tablename1,4,15)) SET @intRegT = 0
				IF (SubString(@tablename,4,15) = SubString(@tablename1,4,15)) SET @intRegT = @intRegT

				WHILE (@intFlag <= @intJml)
				BEGIN    	
					SET @intReg = @intRegT + @intFlag
					
      					INSERT INTO Ta_Pengadaan_Bast_Rinc (Tahun, No_BAST, 
						Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, 
						Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85,
						No_Register, Kd_Pemilik, Tgl_Perolehan, Tgl_Pembukuan, Judul, Type, CC, Bahan, Nomor_Pabrik, Nomor_Rangka, 
						Nomor_Mesin, Nomor_Polisi, Nomor_BPKB, Luas_Lantai, Panjang, Lebar, Lokasi, 
						Asal_Usul, Kondisi, Harga, Masa_Manfaat,
						Keterangan, No_SP2D, 
						No_ID, Kd_Penyusutan, Kd_Data, 
						Log_User, Log_entry, Kd_KA, Kd_Hapus)
					SELECT C.Tahun, @No_Bast, 
						--C.Kd_Aset1, C.Kd_Aset2, C.Kd_Aset3, C.Kd_Aset4, C.Kd_Aset5,
						C.Kd_Aset81, C.Kd_Aset82, C.Kd_Aset83, C.Kd_Aset84, C.Kd_Aset85,
						C.Kd_Aset8, C.Kd_Aset80, C.Kd_Aset81, C.Kd_Aset82, C.Kd_Aset83, C.Kd_Aset84, C.Kd_Aset85,
						@intReg AS No_Register, @sKdPemilik, @TglPerolehan, @TglPembukuan, C.Merk, C.Type, C.Ukuran, '-' AS Bahan, '-' AS Nomor_Pabrik,  '-' AS Nomor_Rangka,
						'-' AS Nomor_Mesin, '-' AS Nomor_Polisi, '-' AS Nomor_BPKB, C.Luas, C.Panjang, C.Lebar, '-' AS Lokasi, 
						'Pembelian' AS Asal_Usul, 1 AS Kondisi, 
						CASE 
							WHEN A.Nilai = B.Nilai THEN C.Harga
							WHEN (A.Nilai < B.Nilai) AND (C.KD_ASET80 =3 AND C.KD_ASET81 IN(3,4)) THEN A.Nilai 
							END AS Harga,
						0 AS Masa_Manfaat,
						C.Keterangan, A.No_Kontrak AS No_SP2D, 
						1. AS No_ID, 1 AS Kd_Penyusutan, 5 AS Kd_Data, 
						@Log_User, GetDate(), 1 AS Kd_KA, 1 AS Kd_Hapus
					FROM (SELECT A.Tahun, A.No_Kontrak, --Max(A.No_SP2D) AS No_SP2D, Max(A.Jn_SP2D) AS Jn_SP2D, 
							SUM(A.Nilai) AS Nilai
						FROM Ta_Pengadaan_SP2D A 
						WHERE A.Jn_SP2D = 1
						GROUP BY A.Tahun, A.No_Kontrak
						) A INNER JOIN 
						Ta_Pengadaan B ON A.Tahun = B.Tahun AND A.No_Kontrak = B.No_Kontrak INNER JOIN
						(SELECT Tahun, No_Kontrak, Kd_Aset1, Kd_Aset2, Kd_Aset3, Kd_Aset4, Kd_Aset5, Kd_Aset8, Kd_Aset80, Kd_Aset81, Kd_Aset82, Kd_Aset83, Kd_Aset84, Kd_Aset85,
							Merk, Ukuran, Luas, Type, CC, Bahan, Nomor_Pabrik, Nomor_Rangka, Nomor_Mesin, Nomor_Polisi, Nomor_BPKB, Panjang, Lebar,
							Harga,Keterangan,No_ID
						FROM Ta_Pengadaan_Rinc) C ON B.Tahun = C.Tahun AND B.No_Kontrak = C.No_Kontrak
					WHERE (B.Tahun = @Tahun) --AND A.Jn_SP2D = 1 
						AND (B.No_Kontrak = @No_Kontrak) AND C.No_ID = SubString(@tablename,1,3)
						AND C.Kd_Aset8 = SubString(@tablename,4,2) AND C.Kd_Aset80 = SubString(@tablename,6,2) 
						AND C.Kd_Aset81 = SubString(@tablename,8,2) AND C.Kd_Aset82 = SubString(@tablename,10,2) 
						AND C.Kd_Aset83 = SubString(@tablename,12,2) AND C.Kd_Aset84 = SubString(@tablename,14,2) 
						AND C.Kd_Aset85 = SubString(@tablename,16,3)
						--AND A.No_SP2D = @No_SP2D

					--PRINT CONVERT(Varchar,@tablename) + ' ' + CONVERT(Varchar,@intJml) + ' ' + CONVERT(Varchar,@intReg)
				
					SET @intFlag = @intFlag + 1
				END
				SET @intRegT = @intReg
   			END
			SET @tablename1 = @tablename
   			FETCH NEXT FROM tnames_cursor INTO @tablename
		END
		CLOSE tnames_cursor
		DEALLOCATE tnames_cursor

	END









GO
