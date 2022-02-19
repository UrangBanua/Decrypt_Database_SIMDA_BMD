USE bmd_hst2020
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO

/*** fn_UPB_L - 26032017 - Modified for Ver 2.0.7 [demi@simda.id] ***/
CREATE FUNCTION dbo.fn_UPB_L (@Tahun varchar(4), @D1 Datetime, @Kd_Prov tinyint, @Kd_Kab_Kota tinyint, @Kd_Bidang varchar(3), @Kd_Unit varchar(3), 
       	                      @Kd_Sub varchar(3), @Kd_UPB varchar(3), @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3))

RETURNS @UPB TABLE(IDPemda varchar(17), Kd_Prov tinyint, Kd_Kab_Kota tinyint, Kd_Bidang tinyint, Kd_Unit smallint, Kd_Sub smallint, Kd_UPB int, 
                   Kd_Aset1 tinyint, Kd_Aset2 tinyint, Kd_Aset3 tinyint, Kd_Aset4 varchar(3), Kd_Aset5 varchar(3), No_Register int, Tgl_Perolehan datetime)

WITH ENCRYPTION
AS
BEGIN

/*
DECLARE @Tahun varchar(4), @D1 Datetime, @Kd_Prov varchar(3), @Kd_Kab_Kota varchar(3), @Kd_Bidang varchar(3), @Kd_Unit varchar(3), @Kd_Sub varchar(3), @Kd_UPB varchar(3),
        @Kd_Aset1 varchar(3), @Kd_Aset2 varchar(3), @Kd_Aset3 varchar(3), @Kd_Aset4 varchar(3)
            
SET @Tahun = '2015'
SET @D1 = '20151231'
SET @Kd_Prov = '55'
SET @Kd_Kab_Kota = '1'
SET @Kd_Bidang = '7'
SET @Kd_Unit = '1'
SET @Kd_Sub = '1'
SET @Kd_UPB = '%'
SET @Kd_Aset1 = '%'
SET @Kd_Aset2 = '%'
SET @Kd_Aset3 = '%'
SET @Kd_Aset4 = '%'
*/

    IF ISNULL(@Kd_Bidang, '') = '' SET @Kd_Bidang = '%'
	IF ISNULL(@Kd_Unit, '')   = '' SET @Kd_Unit   = '%'
	IF ISNULL(@Kd_Sub, '')    = '' SET @Kd_Sub    = '%'
	IF ISNULL(@Kd_UPB, '')    = '' SET @Kd_UPB    = '%'
    IF ISNULL (@Kd_Aset1,'') = '' SET @Kd_Aset1 = '%'
	IF ISNULL (@Kd_Aset2,'') = '' SET @Kd_Aset2 = '%'
	IF ISNULL (@Kd_Aset3,'') = '' SET @Kd_Aset3 = '%'
	IF ISNULL (@Kd_Aset4,'') = '' SET @Kd_Aset4 = '%'


        DECLARE @pindah TABLE(IDPemda varchar(17),Kd_Id Int)
        
        INSERT INTO @pindah
        SELECT A.IDPemda, MIN(A.Kd_Id) AS Kd_ID 
        FROM Ta_KILER A
        WHERE A.Kd_Riwayat = 3 AND A.Tgl_Dokumen > @D1 AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND 
              A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND 
              A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND A.Kd_Aset4 LIKE @Kd_Aset4
        GROUP BY A.IDPemda

	INSERT INTO @UPB
        SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4,
               A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan 
        FROM
	    (
	     SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4,
                    A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan 
             FROM Ta_Lainnya A LEFT OUTER JOIN @pindah B ON A.IDPemda = B.IDPemda
             WHERE B.IDPemda IS NULL AND A.Kd_Prov LIKE @Kd_Prov AND A.Kd_Kab_Kota LIKE @Kd_Kab_Kota AND A.Kd_Bidang LIKE @Kd_Bidang AND A.Kd_Unit LIKE @Kd_Unit AND 
                   A.Kd_Sub LIKE @Kd_Sub AND A.Kd_UPB LIKE @Kd_UPB AND A.Kd_Aset1 LIKE @Kd_Aset1 AND A.Kd_Aset2 LIKE @Kd_Aset2 AND A.Kd_Aset3 LIKE @Kd_Aset3 AND 
                   A.Kd_Aset4 LIKE @Kd_Aset4 AND A.Tgl_Pembukuan <= @D1
             UNION ALL
             SELECT A.IDPemda, A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4,
                    A.Kd_Aset5, A.No_Register, A.Tgl_Perolehan  
             FROM Ta_KILER A INNER JOIN @pindah B ON A.IDPemda = B.IDPemda AND A.Kd_Id = B.Kd_Id 
            ) A

	RETURN
END







GO
