USE bmd_hst2020
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO



CREATE   PROCEDURE [dbo].[PerbedaanDatabase2] @DB1 varchar(100), @DB2 varchar(100)
WITH ENCRYPTION
AS
/*
DECLARE @DB1 varchar(100), @DB2 varchar(100)
SET @DB1 = 'SIMDA_V2_BONBOL'
SET @DB2 = 'BONBOL_LAMA'
*/
	declare @exec_stmt varchar(8000)

	select @exec_stmt =
	'DECLARE @tmp1 TABLE(R_Table sysname, F_Table sysname, R_Field sysname, F_Field sysname, NoId int, OnUpdate tinyint, OnDelete tinyint) ' +
	'DECLARE @tmp2 TABLE(R_Table sysname, F_Table sysname, R_Field sysname, F_Field sysname, NoId int, OnUpdate tinyint, OnDelete tinyint) ' +

	'USE ' + @DB1 + ' ' +
	'INSERT INTO @tmp1 ' +
	'select C.name AS R_Table, D.name AS F_Table, E.name AS R_Field, F.name AS F_Field, A.keyno AS NoId,' +
		' ObjectProperty(constid, ''CnstIsUpdateCascade'') AS OnUpdate, ObjectProperty(constid, ''CnstIsDeleteCascade'') AS OnDelete' +
	' from sysforeignkeys A INNER JOIN ' +
		'sysobjects B ON A.constid = B.id INNER JOIN ' +
		'sysobjects C ON A.rkeyid = C.id INNER JOIN ' +
		'sysobjects D ON A.fkeyid = D.id INNER JOIN ' +
		'syscolumns E on A.rkey = E.colid and A.rkeyid = E.id INNER JOIN ' +
		'syscolumns F on A.fkey = F.colid and A.fkeyid = F.id ' +

	'USE ' + @DB2 + ' ' +
	'INSERT INTO @tmp2 ' +
	'select C.name AS R_Table, D.name AS F_Table, E.name AS R_Field, F.name AS F_Field, A.keyno AS NoId,' +
		' ObjectProperty(constid, ''CnstIsUpdateCascade'') AS OnUpdate, ObjectProperty(constid, ''CnstIsDeleteCascade'') AS OnDelete' +
	' from sysforeignkeys A INNER JOIN ' +
		'sysobjects B ON A.constid = B.id INNER JOIN ' +
		'sysobjects C ON A.rkeyid = C.id INNER JOIN ' +
		'sysobjects D ON A.fkeyid = D.id INNER JOIN ' +
		'syscolumns E on A.rkey = E.colid and A.rkeyid = E.id INNER JOIN ' +
		'syscolumns F on A.fkey = F.colid and A.fkeyid = F.id ' +
	
	'select CASE WHEN A.R_Table IS NULL THEN B.R_Table ELSE A.R_Table END AS R_Table, ' +
	'CASE WHEN A.F_Table IS NULL THEN B.F_Table ELSE A.F_Table END AS F_Table, ' +
	'ISNULL(A.R_Field, '''') AS R_Field1, ISNULL(A.F_Field, '''') AS F_Field1, ' +
	'A.NoId AS NoId1, A.OnUpdate AS OnUpdate1, A.OnDelete AS OnDelete1, ' +
 
	'ISNULL(B.R_Field, '''') AS R_Field2, ISNULL(B.F_Field, '''') AS F_Field2, ' +
	'B.NoId AS NoId2, B.OnUpdate AS OnUpdate2, B.OnDelete AS OnDelete2 ' +

	'from ' +
	'@tmp1 A FULL OUTER JOIN ' +
	'@tmp2 B ON A.R_Table = B.R_Table AND A.F_Table = B.F_Table ' +
	'AND A.R_Field = B.R_Field AND A.F_Field = B.F_Field ' +
	'WHERE (ISNULL(A.R_Table, '''') <> ISNULL(B.R_Table, '''')) OR (ISNULL(A.F_Table, '''') <> ISNULL(B.F_Table, '''')) ' +
	' OR (ISNULL(A.R_Field, '''') <> ISNULL(B.R_Field, '''')) OR (ISNULL(A.F_Field, '''') <> ISNULL(B.F_Field, '''')) OR (ISNULL(A.NoId, 0) <> ISNULL(B.NoId, 0)) ' +
	' OR (ISNULL(A.OnUpdate, 0) <> ISNULL(B.OnUpdate, 0)) OR (ISNULL(A.OnDelete, 0) <> ISNULL(B.OnDelete, 0)) ' +
	'ORDER BY ISNULL(A.R_Table, ''z''), ISNULL(A.F_Table, ''z''), ISNULL(A.NoId, 9999), ISNULL(B.R_Table, ''z''), ISNULL(B.F_Table, ''z''), ISNULL(B.NoId, 9999)'

	execute (@exec_stmt)






GO
