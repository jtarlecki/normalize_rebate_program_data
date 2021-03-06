USE RebatePrograms

DECLARE @me NCHAR(25)
SET @me = 'jtarlecki'

/*
RebaetePrograms_BAK is the original import from the CSV
This procedure normalizes the tables
*/



/*
*******
Begin normalizing Sectors (1:M)
*******
*/


DECLARE @Sectors TABLE
				(
				Id INT IDENTITY(0,1) PRIMARY KEY,
				Name VARCHAR(100),
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)
DECLARE @RebateProgramSectors TABLE
				(
				Id INT IDENTITY(1,1) PRIMARY KEY,
				RebateProgramId INT,
				SectorId INT,
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)


DECLARE @RebateProgramSectorsTemp TABLE
				(
				RebateProgramId INT,
				SectorName VARCHAR(100)
				)

INSERT @RebateProgramSectorsTemp
SELECT Id, LTRIM(x.value('.', 'varchar(100)'))
FROM
(
    SELECT Id, CAST('<x>' + REPLACE([Sector-Name], ',', '</x><x>') + '</x>' as xml) XmlColumn
    FROM RebatePrograms_BAK
)tt
CROSS APPLY
    XmlColumn.nodes('x') as Nodes(x)


INSERT @Sectors
SELECT DISTINCT SectorName
	,@me
	,GETDATE()
	,@me
	,GETDATE()
FROM @RebateProgramSectorsTemp

INSERT @RebateProgramSectors
SELECT rpst.RebateProgramId
	,s.Id
	,@me
	,GETDATE()
	,@me
	,GETDATE()
FROM @RebateProgramSectorsTemp rpst 
    JOIN @Sectors s ON s.Name = rpst.SectorName

SELECT [Id]
		,TempRebateProgramSectorName=[Sector-Name]					--1:M
FROM RebatePrograms_BAK
ORDER BY Id

--SELECT * FROM @Sectors
--SELECT * FROM @RebateProgramSectors

	IF (EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'dbo' 
			AND  TABLE_NAME = 'Sectors'))
		BEGIN
			DROP TABLE [dbo].[Sectors]
		END
	IF (EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'dbo' 
			AND  TABLE_NAME = 'RebateProgramSectors'))
		BEGIN
			DROP TABLE [dbo].[RebateProgramSectors]
		END


CREATE TABLE Sectors
				(
				Id INT IDENTITY(0,1) PRIMARY KEY,
				Name VARCHAR(100),
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)
CREATE TABLE RebateProgramSectors
				(
				Id INT IDENTITY(1,1) PRIMARY KEY,
				RebateProgramId INT,
				SectorId INT,
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)

INSERT INTO Sectors
SELECT  
        Name ,
        CreatedUser ,
        CreatedDate ,
        ModifiedUser ,
        ModifiedDate
FROM @Sectors
ORDER BY Id

INSERT INTO RebateProgramSectors
SELECT  RebateProgramId ,
        SectorId ,
        CreatedUser ,
        CreatedDate ,
        ModifiedUser ,
        ModifiedDate
FROM @RebateProgramSectors
ORDER BY RebateProgramId

SELECT * FROM dbo.Sectors
SELECT * FROM dbo.RebateProgramSectors

/*
*******
Begin normalizing Technologies (1:M)
*******
*/


DECLARE @Technologies TABLE
				(
				Id INT IDENTITY(0,1) PRIMARY KEY,
				Name VARCHAR(100),
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)
DECLARE @RebateProgramTechnologies TABLE
				(
				Id INT IDENTITY(1,1) PRIMARY KEY,
				RebateProgramId INT,
				TechnologyId INT,
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)

DECLARE @RebateProgramTechnologiesTemp TABLE
				(
				RebateProgramId INT,
				TechnologyName VARCHAR(100)
				)

INSERT @RebateProgramTechnologiesTemp
SELECT Id, LTRIM(x.value('.', 'varchar(100)'))
FROM
(
    SELECT Id, CAST('<x>' + REPLACE([Technologies-Name], ',', '</x><x>') + '</x>' as xml) XmlColumn
    FROM RebatePrograms_BAK
)tt
CROSS APPLY
    XmlColumn.nodes('x') as Nodes(x)


INSERT @Technologies
SELECT DISTINCT TechnologyName
	,@me
	,GETDATE()
	,@me
	,GETDATE()
FROM @RebateProgramTechnologiesTemp

INSERT @RebateProgramTechnologies
SELECT rpst.RebateProgramId
	,s.Id
	,@me
	,GETDATE()
	,@me
	,GETDATE()
FROM @RebateProgramTechnologiesTemp rpst 
    JOIN @Technologies s ON s.Name = rpst.TechnologyName

SELECT [Id]
		,TempRebateProgramTechnologyName=[Technologies-Name]					--1:M
FROM RebatePrograms_BAK
ORDER BY Id

--SELECT * FROM @Technologies
--SELECT * FROM @RebateProgramTechnologies

	IF (EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'dbo' 
			AND  TABLE_NAME = 'Technologies'))
		BEGIN
			DROP TABLE [dbo].[Technologies]
		END
	IF (EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'dbo' 
			AND  TABLE_NAME = 'RebateProgramTechnologies'))
		BEGIN
			DROP TABLE [dbo].[RebateProgramTechnologies]
		END


CREATE TABLE Technologies
				(
				Id INT IDENTITY(0,1) PRIMARY KEY,
				Name VARCHAR(100),
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)
CREATE TABLE RebateProgramTechnologies
				(
				Id INT IDENTITY(1,1) PRIMARY KEY,
				RebateProgramId INT,
				TechnologyId INT,
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)

INSERT INTO Technologies
SELECT  
        Name ,
        CreatedUser ,
        CreatedDate ,
        ModifiedUser ,
        ModifiedDate
FROM @Technologies
ORDER BY Id

INSERT INTO RebateProgramTechnologies
SELECT  RebateProgramId ,
        TechnologyId ,
        CreatedUser ,
        CreatedDate ,
        ModifiedUser ,
        ModifiedDate
FROM @RebateProgramTechnologies
ORDER BY RebateProgramId

SELECT * FROM dbo.Technologies
SELECT * FROM dbo.RebateProgramTechnologies

/*
*******
Begin normalizing Funding Sources (1:1)
*******
*/


DECLARE @FundingSources TABLE
				(
				Id INT IDENTITY(0,1) PRIMARY KEY,
				Name VARCHAR(100),
				Notes VARCHAR(1000),
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)

INSERT INTO @FundingSources
SELECT DISTINCT [FundingSources-Name]
	,NULL
	,@me
	,GETDATE()
	,@me
	,GETDATE()
FROM RebatePrograms_BAK

--SELECT * FROM @FundingSources

	IF (EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'dbo' 
			AND  TABLE_NAME = 'FundingSources'))
		BEGIN
			DROP TABLE [dbo].[FundingSources]
		END
CREATE TABLE FundingSources
				(
				Id INT IDENTITY(0,1) PRIMARY KEY,
				Name VARCHAR(100),
				Notes VARCHAR(1000),
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)
INSERT INTO FundingSources
SELECT  
        Name ,
        Notes ,
        CreatedUser ,
        CreatedDate ,
        ModifiedUser ,
        ModifiedDate
FROM @FundingSources
ORDER BY Name

SELECT * FROM dbo.FundingSources

/*
*******
Begin normalizing FundingTypes (1:M)
*******
*/



DECLARE @FundingTypes TABLE
				(
				Id INT IDENTITY(0,1) PRIMARY KEY,
				Description VARCHAR(100),
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)
DECLARE @RebateProgramFundingTypes TABLE
				(
				Id INT IDENTITY(1,1) PRIMARY KEY,
				RebateProgramId INT,
				FundingTypeId INT,
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)


DECLARE @RebateProgramFundingTypesTemp TABLE
				(
				RebateProgramId INT,
				FundingTypeDescription VARCHAR(100)
				)

INSERT @RebateProgramFundingTypesTemp
SELECT Id, LTRIM(x.value('.', 'varchar(100)'))
FROM
(
    SELECT Id, CAST('<x>' + REPLACE([FundingTypes-Description], ',', '</x><x>') + '</x>' as xml) XmlColumn
    FROM RebatePrograms_BAK
)tt
CROSS APPLY
    XmlColumn.nodes('x') as Nodes(x)


INSERT @FundingTypes
SELECT DISTINCT FundingTypeDescription
	,@me
	,GETDATE()
	,@me
	,GETDATE()
FROM @RebateProgramFundingTypesTemp

INSERT @RebateProgramFundingTypes
SELECT rpst.RebateProgramId
	,s.Id
	,@me
	,GETDATE()
	,@me
	,GETDATE()
FROM @RebateProgramFundingTypesTemp rpst 
    JOIN @FundingTypes s ON s.Description = rpst.FundingTypeDescription

SELECT [Id]
		,TempRebateProgramSectorName=[FundingTypes-Description]			--1:M
FROM RebatePrograms_BAK
ORDER BY Id

--SELECT * FROM @FundingTypes
--SELECT * FROM @RebateProgramFundingTypes

	IF (EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'dbo' 
			AND  TABLE_NAME = 'FundingTypes'))
		BEGIN
			DROP TABLE [dbo].[FundingTypes]
		END
	IF (EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'dbo' 
			AND  TABLE_NAME = 'RebateProgramFundingTypes'))
		BEGIN
			DROP TABLE [dbo].[RebateProgramFundingTypes]
		END


CREATE TABLE FundingTypes
				(
				Id INT IDENTITY(0,1) PRIMARY KEY,
				Description VARCHAR(100),
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)
CREATE TABLE RebateProgramFundingTypes
				(
				Id INT IDENTITY(1,1) PRIMARY KEY,
				RebateProgramId INT,
				FundingTypeId INT,
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)

INSERT INTO FundingTypes
SELECT  
        Description ,
        CreatedUser ,
        CreatedDate ,
        ModifiedUser ,
        ModifiedDate
FROM @FundingTypes
ORDER BY Id

INSERT INTO RebateProgramFundingTypes
SELECT  RebateProgramId ,
        FundingTypeId ,
        CreatedUser ,
        CreatedDate ,
        ModifiedUser ,
        ModifiedDate
FROM @RebateProgramFundingTypes
ORDER BY RebateProgramId

--SELECT * FROM dbo.FundingTypes
--SELECT * FROM dbo.RebateProgramFundingTypes

/*
*******
Begin normalizing ProgramAdmins (1:1)
*******
*/



DECLARE @ProgramAdmins TABLE
				(
				Id INT IDENTITY(0,1) PRIMARY KEY,
				Name VARCHAR(MAX),
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)

INSERT INTO @ProgramAdmins
SELECT DISTINCT [ProgramAdmins-Name]
	,@me
	,GETDATE()
	,@me
	,GETDATE()
FROM RebatePrograms_BAK

SELECT * FROM @ProgramAdmins

	IF (EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'dbo' 
			AND  TABLE_NAME = 'ProgramAdmins'))
		BEGIN
			DROP TABLE [dbo].[ProgramAdmins]
		END
CREATE TABLE ProgramAdmins
				(
				Id INT IDENTITY(0,1) PRIMARY KEY,
				Name VARCHAR(MAX),
				CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
				ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
				ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()) 
				)
INSERT INTO ProgramAdmins
SELECT  
        Name ,
        CreatedUser ,
        CreatedDate ,
        ModifiedUser ,
        ModifiedDate
FROM @ProgramAdmins
ORDER BY Name

SELECT * FROM dbo.ProgramAdmins

/*
|||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||
Final
|||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||
*/



SELECT t.[Id]
		,[RebatePrograms-Name]
		,[StateId]=s.Id						--For New Table
		--,[Sector-Name]					--1:M, seperate tables
		--,[Technologies-Name]				--1:M, seperate tables
		,[ProgramStatusId]	=	CASE [ProgramStatuses-Description]
									WHEN 'TRUE' THEN 1		--OK
									WHEN 'FALSE' THEN 3		--Out of Money
									ELSE NULL
								END
		,[ProgramYearEndDate] = CASE WHEN [RebatePrograms-ProgramYearEndDate]='' THEN NULL ELSE convert(datetime, REPLACE([RebatePrograms-ProgramYearEndDate],'-',' '), 106) END-- dd mon yyyy
		,[FundingSourcesId] = f.Id
		,[RebatePrograms-TempPayoutSting]
		,[RebatePrograms-TempSizeString]
		,[RebatePrograms-TempRequirementsString]
		,[RebatePrograms-ProgramStartDateString]
		,[RebatePrograms-ProgramEndDateString]
		,[RebatePrograms-ProgramCaveats]
		,[RebatePrograms-ProgramBudget]
		,[ProgramAdminId]=p.Id
		,[RebatePrograms-Website]
		,RecordStatusId = 7				--CURRENT RECORD
FROM RebatePrograms_BAK t
	LEFT OUTER JOIN States s ON LTRIM(RTRIM([mhfncStringTokenizedValue] ([States-Name],',',2))) = s.Name COLLATE Latin1_General_CI_AS 
	LEFT OUTER JOIN @FundingSources f ON t.[FundingSources-Name] = f.Name COLLATE Latin1_General_CI_AS 
	LEFT OUTER JOIN @ProgramAdmins p ON t.[ProgramAdmins-Name] = p.Name COLLATE Latin1_General_CI_AS 
ORDER BY t.Id


	IF (EXISTS (SELECT * 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_SCHEMA = 'dbo' 
			AND  TABLE_NAME = 'RebatePrograms'))
		BEGIN
			DROP TABLE [dbo].[RebatePrograms]
		END


CREATE TABLE RebatePrograms
		(
		Id INT IDENTITY(0,1) PRIMARY KEY,
		Name VARCHAR(500),
		StateId INT NOT NULL DEFAULT (0),
		CustomerUsageMinKW FLOAT,
		CustomerUsageMinKWH FLOAT, 
		CustomerUsageMaxKW FLOAT,
		CustomerUsageMaxKWH FLOAT,
		ProjectEnergySavingsMinKW FLOAT,
		ProjectEnergySavingsMinKWH FLOAT,
		ProjectEnergySavingsMaxKW FLOAT,
		ProjectEnergySavingsMaxKWH FLOAT,
		BuildingSizeMinSqft INT,
		BuildingSizeMaxSqft INT,
		RebatorId INT NOT NULL DEFAULT (0),
		FundingSourceId INT NOT NULL DEFAULT (0),
		ProgramYearStartDate DATETIME DEFAULT(NULL),
		ProgramYearEndDate DATETIME DEFAULT(NULL),
		ProgramStartDateString VARCHAR(1000),
		ProgramEndDateString VARCHAR(1000),
		RecordStatusId INT NOT NULL DEFAULT (0),
		ProgramStatusId INT NOT NULL DEFAULT (0),
		ProgramAdminId INT NOT NULL DEFAULT (0),
		Website NVARCHAR(500) NULL,
		TempPayoutString VARCHAR(MAX),
		TempProjectSizeString VARCHAR(1000),
		TempRequirementsString VARCHAR(1500),
		ProgramCaveats VARCHAR(1000),
		ProgramBudget VARCHAR(255),
		CreatedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()), 
		CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()), 
		ModifiedUser NCHAR(25) NOT NULL DEFAULT (USER_NAME()),
		ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE())
		)
	
INSERT INTO dbo.RebatePrograms (Name)
VALUES ('NA')

INSERT INTO dbo.RebatePrograms
        ( Name , --x
          StateId , --x
          --CustomerUsageMinKW ,
          --CustomerUsageMinKWH ,
          --CustomerUsageMaxKW ,
          --CustomerUsageMaxKWH ,
          --ProjectEnergySavingsMinKW ,
          --ProjectEnergySavingsMinKWH ,
          --ProjectEnergySavingsMaxKW ,
          --ProjectEnergySavingsMaxKWH ,
          --BuildingSizeMinSqft ,
          --BuildingSizeMaxSqft ,
          --RebatorId ,
          FundingSourceId , --x
          --ProgramYearStartDate ,
          ProgramYearEndDate , --x
          ProgramStartDateString , --x
          ProgramEndDateString , --x
          RecordStatusId , --x
          ProgramStatusId , --x
          ProgramAdminId , --x
          Website , --x
          TempPayoutString , --x
          TempProjectSizeString , --x
          TempRequirementsString , --x
          ProgramCaveats , --x
          ProgramBudget , --x
          CreatedUser ,
          CreatedDate ,
          ModifiedUser ,
          ModifiedDate
        )
SELECT 
		[RebatePrograms-Name]
		,ISNULL(s.Id,0)						--For New Table
		,f.Id
		,CASE WHEN [RebatePrograms-ProgramYearEndDate]='' THEN NULL ELSE convert(datetime, REPLACE([RebatePrograms-ProgramYearEndDate],'-',' '), 106) END-- dd mon yyyy
		,[RebatePrograms-ProgramStartDateString]
		,[RebatePrograms-ProgramEndDateString]
		,7 --CURRENT RECORD	
		,CASE [ProgramStatuses-Description]
									WHEN 'TRUE' THEN 1		--OK
									WHEN 'FALSE' THEN 3		--Out of Money
									ELSE 0
								END

		,p.Id
		,[RebatePrograms-Website]
		,[RebatePrograms-TempPayoutSting]
		,[RebatePrograms-TempSizeString]
		,[RebatePrograms-TempRequirementsString]
		,[RebatePrograms-ProgramCaveats]
		,[RebatePrograms-ProgramBudget]
		,@me
		,GETDATE()
		,@me
		,GETDATE()
FROM RebatePrograms_BAK t
	LEFT OUTER JOIN States s ON LTRIM(RTRIM([mhfncStringTokenizedValue] ([States-Name],',',2))) = s.Name COLLATE Latin1_General_CI_AS 
	LEFT OUTER JOIN FundingSources f ON t.[FundingSources-Name] = f.Name COLLATE Latin1_General_CI_AS 
	LEFT OUTER JOIN ProgramAdmins p ON t.[ProgramAdmins-Name] = p.Name COLLATE Latin1_General_CI_AS 
--WHERE [RebatePrograms-ProgramYearEndDate] !=''
ORDER BY t.Id