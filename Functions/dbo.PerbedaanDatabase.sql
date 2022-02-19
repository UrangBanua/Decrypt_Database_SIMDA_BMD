USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PerbedaanDatabase] @DB1 varchar(100), @DB2 varchar(100)
WITH ENCRYPTION
AS
/*
DECLARE @DB1 varchar(100), @DB2 varchar(100)
SET @DB1 = 'SIMDA_V3'
SET @DB2 = 'SIMDA_CILEGON'
*/
declare @exec_stmt varchar(8000), @exec_stmt2 varchar(8000), @exec_stmt3 varchar(8000)

	select @exec_stmt = 
	'DECLARE @T1 TABLE(TabName sysname, ColID smallint, ColName sysname, ColType varchar(50), Nullable varchar(3), PK varchar(5))' +
	' DECLARE @T2 TABLE(TabName sysname, ColID smallint, ColName sysname, ColType varchar(50), Nullable varchar(3), PK varchar(5))' +
	' declare @numtypes nvarchar(80), @lentypes nvarchar(80)' +
	' select @numtypes = N''decimal,numeric''' +
	' select @lentypes = N''binary,char,nchar,nvarchar,varbinary,varchar''' +
	' INSERT INTO @T1' +
	' SELECT B.name AS TabName, A.colid, A.name AS ColName, ' +
	' type_name(A.xtype) + ' +
	' case ' +
	' when charindex(type_name(A.xtype), @lentypes) > 0 then ''('' + convert(varchar(5), A.length) + '')''' +
	' else ''''' +
	' end +' +
	' case ' +
	' when charindex(type_name(A.xtype), @numtypes) > 0 then ''('' + convert(varchar(5), A.xprec) + '', '' + convert(varchar(5), A.xscale) + '')''' +
	' else ''''' +
	' end AS ColType,' +
	' case' +
	' when isnullable = 0 then ''no''' +
	' else ''yes''' +
	' end AS Nullable,' +
	' '''' AS PK' +
	' FROM ' + quotename(@DB1) + '..syscolumns A INNER JOIN ' +
	quotename(@DB1) + '..sysobjects B ON A.id = B.id' +
	' WHERE (B.xtype = N''U'' OR B.xtype = N''V'') AND B.name <> ''dtproperties''' +

	' INSERT INTO @T1' +
	' SELECT B.name + '' '' + D.name AS TabName, A.colid, A.name AS ColName, ' +
	' type_name(A.xtype)  +  ' +
	' case ' +
	' when charindex(type_name(A.xtype), @lentypes) > 0 then ''('' + convert(varchar(5), A.length) + '')''' +
	' else ''''' +
	' end +' +
	' case ' +
	' when charindex(type_name(A.xtype), @numtypes) > 0 then ''('' + convert(varchar(5), A.xprec) + '', '' + convert(varchar(5), A.xscale) + '')''' +
	' else ''''' +
	' end AS ColType,' +
	' case' +
	' when isnullable = 0 then ''no''' +
	' else ''yes''' +
	' end AS Nullable,' +
	' CONVERT(varchar(5), D.keyno) AS PK' +
	' FROM ' + quotename(@DB1) + '..syscolumns A INNER JOIN ' +
	quotename(@DB1) + '..sysobjects B ON A.id = B.id INNER JOIN' +
	' (' +
	' SELECT A.id, A.name, B.colid, B.keyno + CASE LEFT(A.name, 2) WHEN ''PK'' THEN 0 ELSE 100 END AS keyno' +
	' FROM ' + quotename(@DB1) + '..sysindexes A INNER JOIN ' +
	quotename(@DB1) + '..sysindexkeys B ON A.id = B.id AND A.indid = B.indid' +
	' WHERE A.indid > 0 and A.indid < 255 and (A.status & 64) = 0' +
	' ) D ON B.id = D.id AND A.colid = D.colid' +	
	' WHERE (B.xtype = N''U'' OR B.xtype = N''V'') AND B.name <> ''dtproperties'''

	select @exec_stmt2 =
	' INSERT INTO @T2' +
	' SELECT B.name AS TabName, A.colid, A.name AS ColName, ' +
	' type_name(A.xtype) + ' +
	' case ' +
	' when charindex(type_name(A.xtype), @lentypes) > 0 then ''('' + convert(varchar(5), A.length) + '')''' +
	' else ''''' +
	' end +' +
	' case ' +
	' when charindex(type_name(A.xtype), @numtypes) > 0 then ''('' + convert(varchar(5), A.xprec) + '', '' + convert(varchar(5), A.xscale) + '')''' +
	' else ''''' +
	' end AS ColType,' +
	' case' +
	' when isnullable = 0 then ''no''' +
	' else ''yes''' +
	' end AS Nullable,' +
	' '''' AS PK' +
	' FROM ' + quotename(@DB2) + '..syscolumns A INNER JOIN ' +
	quotename(@DB2) + '..sysobjects B ON A.id = B.id' +
	' WHERE (B.xtype = N''U'' OR B.xtype = N''V'') AND B.name <> ''dtproperties''' +

	' INSERT INTO @T2' +
	' SELECT B.name + '' '' + D.name AS TabName, A.colid, A.name AS ColName, ' +
	' type_name(A.xtype)  +  ' +
	' case ' +
	' when charindex(type_name(A.xtype), @lentypes) > 0 then ''('' + convert(varchar(5), A.length) + '')''' +
	' else ''''' +
	' end +' +
	' case ' +
	' when charindex(type_name(A.xtype), @numtypes) > 0 then ''('' + convert(varchar(5), A.xprec) + '', '' + convert(varchar(5), A.xscale) + '')''' +
	' else ''''' +
	' end AS ColType,' +
	' case' +
	' when isnullable = 0 then ''no''' +
	' else ''yes''' +
	' end AS Nullable,' +
	' CONVERT(varchar(5), D.keyno) AS PK' +
	' FROM ' + quotename(@DB2) + '..syscolumns A INNER JOIN ' +
	quotename(@DB2) + '..sysobjects B ON A.id = B.id INNER JOIN' +
	' (' +
	' SELECT A.id, A.name, B.colid, B.keyno + CASE LEFT(A.name, 2) WHEN ''PK'' THEN 0 ELSE 100 END AS keyno' +
	' FROM ' + quotename(@DB2) + '..sysindexes A INNER JOIN ' +
	quotename(@DB2) + '..sysindexkeys B ON A.id = B.id AND A.indid = B.indid' +
	' WHERE A.indid > 0 and A.indid < 255 and (A.status & 64) = 0' +
	' ) D ON B.id = D.id AND A.colid = D.colid' +	
	' WHERE (B.xtype = N''U'' OR B.xtype = N''V'') AND B.name <> ''dtproperties'''

	select @exec_stmt3 =
	' SELECT' +
	' CASE' +
	' WHEN (CONVERT(int, ISNULL(A.PK, '''')) <> 0) OR (CONVERT(int, ISNULL(B.PK, '''')) <> 0) THEN' +
	' CASE' +
	' WHEN (CONVERT(int, ISNULL(A.PK, '''')) > 100) OR (CONVERT(int, ISNULL(B.PK, '''')) > 100) THEN 6' +
	' ELSE 5' +
	' END' +
	' ELSE' +
	' CASE' +
	' WHEN ISNULL(A.ColType, '''') = '''' THEN 1' +
	' WHEN ISNULL(B.ColType, '''') = '''' THEN 2' +
	' WHEN ISNULL(A.ColType, '''') <> ISNULL(B.ColType, '''') THEN 3' +
	' WHEN ISNULL(A.Nullable, '''') <> ISNULL(B.Nullable, '''') THEN 4' +
	' WHEN ISNULL(A.PK, '''') <> ISNULL(B.PK, '''') THEN 5' +
	' END' + 
	' END AS Kd_Perbedaan, ' +
	' CASE' +
	' WHEN (CONVERT(int, ISNULL(A.PK, '''')) <> 0) OR (CONVERT(int, ISNULL(B.PK, '''')) <> 0) THEN' +
	' CASE' +
	' WHEN (CONVERT(int, ISNULL(A.PK, '''')) > 100) OR (CONVERT(int, ISNULL(B.PK, '''')) > 100) THEN ''INDEX TIDAK SAMA''' +
	' ELSE ''PRIMARY KEY TIDAK SAMA''' +
	' END' +
	' ELSE' +
	' CASE' +
	' WHEN ISNULL(A.ColType, '''') = '''' THEN ''FIELD / TABEL / VIEW DI ' + @DB1 + ' TIDAK ADA''' +
	' WHEN ISNULL(B.ColType, '''') = '''' THEN ''FIELD / TABEL / VIEW DI ' + @DB2 + ' TIDAK ADA''' +
	' WHEN ISNULL(A.ColType, '''') <> ISNULL(B.ColType, '''') THEN ''TIPE DATA TIDAK SAMA''' +
	' WHEN ISNULL(A.Nullable, '''') <> ISNULL(B.Nullable, '''') THEN ''NULLABLE TIDAK SAMA''' +
	' WHEN ISNULL(A.PK, '''') <> ISNULL(B.PK, '''') THEN ''PRIMARY KEY TIDAK SAMA''' +
	' END' + 
	' END AS Perbedaan, ' +
	' CASE' +
	' WHEN ISNULL(A.TabName, '''') = '''' THEN B.TabName' +
	' ELSE A.TabName' +
	' END AS TabName,' +
	' ISNULL(A.ColName, '''') AS DB1_ColName,' +
	' ISNULL(A.ColType, '''') AS DB1_ColType,' +
	' ISNULL(A.Nullable, '''') AS DB1_Nullable,' +
	' CASE WHEN CONVERT(int, ISNULL(A.PK, '''')) > 100 THEN CONVERT(varchar, A.PK - 100)' +
	' ELSE ISNULL(A.PK, '''') END AS DB1_PK,' +
	' ISNULL(B.ColName, '''') AS DB2_ColName,' +
	' ISNULL(B.ColType, '''') AS DB2_ColType,' +
	' ISNULL(B.Nullable, '''') AS DB2_Nullable,' +
	' CASE WHEN CONVERT(int, ISNULL(B.PK, '''')) > 100 THEN CONVERT(varchar, B.PK - 100)' +
	' ELSE ISNULL(B.PK, '''') END AS DB2_PK,' +
	' CASE WHEN ISNULL(A.ColID, 0) = 0 THEN B.ColID ELSE A.ColID END AS ColumnID' +
	' FROM @T1 A FULL OUTER JOIN' +
	' @T2 B ON A.TabName = B.TabName AND A.ColName = B.ColName' +
	' WHERE ISNULL(A.ColType, '''') <> ISNULL(B.ColType, '''')' +
	' OR ISNULL(A.Nullable, '''') <> ISNULL(B.Nullable, '''')' +
	' OR ISNULL(A.PK, '''') <> ISNULL(B.PK, '''')' +

	' UNION ALL' +
	
	' SELECT 7 AS Kd_Perbedaan, ''DEFAULT TIDAK SAMA'' AS Perbedaan,' +
	' CASE WHEN ISNULL(A.TabName, '''') = '''' THEN B.TabName ELSE A.TabName END AS TabName,' +
	' ISNULL(A.ColName, '''') AS DB1_ColName, A.Def AS DB1_ColType, '''' AS DB1_Nullable, '''' AS DB1_PK,' +
	' ISNULL(B.ColName, '''') AS DB2_ColName, B.Def AS DB2_ColType, '''' AS DB2_Nullable, '''' AS DB2_PK,' +
	' CASE WHEN ISNULL(A.ColID, 0) = 0 THEN B.ColID ELSE A.ColID END AS ColumnID' +
	' FROM' +
	' (' +
	' SELECT B.name AS TabName, A.colid, A.name AS ColName, ISNULL(C.Text, '''') AS Def' +
	' FROM ' + quotename(@DB1) + '..syscolumns A INNER JOIN ' +
	quotename(@DB1) + '..sysobjects B ON A.id = B.id LEFT OUTER JOIN ' +
	quotename(@DB1) + '..syscomments C ON A.cdefault = C.id' +
	' WHERE B.xtype = ''U'' AND B.name <> ''dtproperties''' +
	' ) A FULL OUTER JOIN' +
	' (' +
	' SELECT B.name AS TabName, A.colid, A.name AS ColName, ISNULL(C.Text, '''') AS Def' +
	' FROM ' + quotename(@DB2) + '..syscolumns A INNER JOIN ' +
	quotename(@DB2) + '..sysobjects B ON A.id = B.id LEFT OUTER JOIN ' +
	quotename(@DB2) + '..syscomments C ON A.cdefault = C.id' +
	' WHERE B.xtype = ''U'' AND B.name <> ''dtproperties''' +
	' ) B ON A.TabName = B.TabName AND A.ColName = B.ColName' +
	' WHERE A.Def <> B.Def' +

	' ORDER BY Kd_Perbedaan, TabName, ColumnID'

	--PRINT (@exec_stmt + @exec_stmt2 + @exec_stmt3)
	EXECUTE (@exec_stmt + @exec_stmt2 + @exec_stmt3)





GO
