USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[fn_Penghapusan](@Tahun Varchar(4), @Jn Varchar(1))
RETURNS TABLE
WITH ENCRYPTION
AS
RETURN (
 /*
DECLARE @Tahun Varchar(4), @Jn Varchar(1)
SET @Tahun = '2007'
SET @Jn = '1'
*/
	SELECT A.Kd_Prov, A.Kd_Kab_Kota, A.Kd_Bidang, A.Kd_Unit, A.Kd_Sub, A.Kd_UPB, A.Kd_Aset1, A.Kd_Aset2, A.Kd_Aset3, A.Kd_Aset4, A.Kd_Aset5, A.No_Register
	FROM Ta_Penghapusan_Rinc A INNER JOIN
	     Ta_Penghapusan B ON A.Tahun = B.Tahun AND A.No_SK = B.No_SK
	     WHERE (B.Tgl_SK <= (@Tahun + '1231')) AND (A.Kd_Aset1 = @Jn)
)







GO
