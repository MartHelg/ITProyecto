/****** Scrip example for backup data ******/
declare @myDate nvarchar(255) = format(SYSdatetime(),'yyyyMMdd')
declare @myMonth nvarchar(255) = format(SYSdatetime(),'yyyyMM')
declare @myFolder nvarchar(255) = 'D:\DATA_BACKUP\' + @myMonth + '\'
declare @myFileSuffix nvarchar(255) = '_' + @myDate + '.bak'
declare @myFileName  nvarchar(255)

declare @chkdirectory as nvarchar(4000)
	declare @folder_exists as int
	
	set @chkdirectory = 'D:\DATA_BACKUP\' + @myMonth

	declare @file_results table 
	(file_exists int,
	file_is_a_directory int,
	parent_directory_exists int
	)

	insert into @file_results
	(file_exists, file_is_a_directory, parent_directory_exists)
	exec master.dbo.xp_fileexist @chkdirectory
	
	select @folder_exists = file_is_a_directory
	from @file_results
	
	--script to create directory		
	if @folder_exists = 0
	 begin
		print 'Directory is not exists, creating new one'
		EXECUTE master.dbo.xp_create_subdir @chkdirectory
		print @chkdirectory +  'created on' + @@servername
	 end		
	else
	print 'Directory already exists'

SET @myFileName   = @myFolder + 'RAW_REPAIR_DATA'  +  @myFileSuffix
BACKUP DATABASE [RAW_REPAIR_DATA] TO  DISK = @myFileName  WITH  COPY_ONLY, NOFORMAT, NOINIT,  NAME = N'RAW_REPAIR_DATA-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
SET @myFileName   = @myFolder + 'EXCHANGE'  +  @myFileSuffix
BACKUP DATABASE [EXCHANGE] TO  DISK =  @myFileName  WITH  COPY_ONLY, NOFORMAT, NOINIT,  NAME = N'EXCHANGE-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
SET @myFileName   = @myFolder + 'QR_VIEWS'  +  @myFileSuffix
BACKUP DATABASE [QR_VIEWS] TO  DISK =  @myFileName WITH  COPY_ONLY, NOFORMAT, NOINIT,  NAME = N'QR_VIEWS-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
SET @myFileName   = @myFolder + 'WIZPART'  +  @myFileSuffix
BACKUP DATABASE [WIZPART] TO  DISK =  @myFileName   WITH  COPY_ONLY, NOFORMAT, NOINIT,  NAME = N'WIZPART-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
SET @myFileName   = @myFolder + 'WQ_MIRROR'  +  @myFileSuffix
BACKUP DATABASE [WQ MIRROR] TO  DISK =  @myFileName  WITH  COPY_ONLY, NOFORMAT, NOINIT,  NAME = N'WQ_MIRROR-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
SET @myFileName   = @myFolder + 'REPAIR KPI'  +  @myFileSuffix
BACKUP DATABASE [REPAIR KPI] TO  DISK =  @myFileName WITH  COPY_ONLY, NOFORMAT, NOINIT,  NAME = N'QR_VIEWS-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO