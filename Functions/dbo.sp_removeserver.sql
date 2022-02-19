USE bmd_hst2020
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_removeserver]
WITH ENCRYPTION
AS
	if exists (select * from master.dbo.sysservers where srvname = N'SIM_EXP')
	begin
    	exec sp_dropserver N'SIM_EXP', 'droplogins'
	end



GO
