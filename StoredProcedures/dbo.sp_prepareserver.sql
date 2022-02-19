USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_prepareserver] @file nvarchar(4000)
WITH ENCRYPTION
AS
	if exists (select * from master.dbo.sysservers where srvname = N'SIM_EXP')
	begin
		exec sp_dropserver N'SIM_EXP', 'droplogins'
	end

	exec sp_addlinkedserver 
		@server = 'SIM_EXP', 
		@provider = 'Microsoft.Jet.OLEDB.4.0', 
		@srvproduct = 'OLE DB Provider for Jet',
		@datasrc = @file
	
	exec sp_addlinkedsrvlogin 'SIM_EXP', 'false', NULL, NULL, NULL





GO
