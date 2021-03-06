/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [TerritoryID]
      ,[Name]
      ,[CountryRegionCode]
      ,[Group]
      ,[SalesYTD]
      ,[SalesLastYear]
      ,[CostYTD]
      ,[CostLastYear]
      ,[rowguid]
      ,[ModifiedDate]
  FROM [AdventureWorks2017].[Sales].[SalesTerritory]

  -- CREATE A VIEW (US COUNTRY REEGION VIEW)
  CREATE VIEW MyCustomUSView
  AS 
  SELECT * FROM [AdventureWorks2017].[Sales].[SalesTerritory]
  WHERE CountryRegionCode like 'US'

  SELECT * FROM MyCustomUSView

  CREATE VIEW NASalseQuota
  AS
  SELECT [Name], [Group], [SalesQuota], [Bonus]
  FROM [AdventureWorks2017].[Sales].[SalesTerritory] A INNER JOIN [Sales].[SalesPerson] B 
  on A.TerritoryID = B.TerritoryID
  WHERE [Group] like 'North America'

  SELECT * FROM NASalseQuota

  ----------------TRIGGERS-----------------------
  --TABLE LEVEL TRIGGER
  SELECT * FROM [HumanResources].[Shift]
  CREATE TRIGGER DemoTrigger
  ON [HumanResources].[Shift]
  AFTER INSERT
  AS
  BEGIN
	PRINT 'INSERT IS NOT ALLOWED. YOU NEED APPROVAL.'
	ROLLBACK TRANSACTION
  END
  GO
  --TEST TRIGGER (by inserting a row)
  INSERT INTO [HumanResources].[Shift]
  ([Name], [StartTime], [EndTime], [ModifiedDate])
  VALUES ('TYLER', '07:00:00.0000000', '08:00:00.0000000', getdate())

  -----DATABASE LEVEL TRIGGER
  CREATE TRIGGER DemoDBTrigger
  ON DATABASE
  AFTER CREATE_TABLE
  AS
  BEGIN
	PRINT 'CREATION OF NEW TABLES NOT ALLOWED.'
	-- can add information here
	ROLLBACK TRANSACTION
  END
  GO
  --TEST TRIGGER (by )
  CREATE TABLE MyDemoTable(col1 varchar(10))

/*  
  EXECUTE msdb.dbo.sysmail_add_account_sp
    @account_name = 'Bartlett DB Admin',
    @description = 'Mail account for administrative e-mail.',
    @email_address = 'bdba@Adventure-Works.com',
    @display_name = 'Automated Mailer',
    @mailserver_name = 'smtp.Adventure-Works.com' ;

  CREATE PROCEDURE p_send_altermail
  AS
  IF EXISTS(SELECT 1 FROM [HumanResources].[Shift])
  BEGIN 
	EXEC msdb..sp_send_dbmail @profile_name='TestProfile',
	@recipients='tbartlett14@mail.wou.edu',
	@subject='Invalid Table Insertion',
	@body='you have tried to insert data in a table that does not allow this',
	@query = ' SELECT * FROM [HumanResources].[Shift]' ,
	@execute_query_database='AdventureWorks2017',
	@attach_query_result_as_file = 1 ;
  END
  EXECUTE p_send_altermail
  */

  ---------STORED PROCEDURES---------------
  CREATE PROCEDURE MyTestProc
  AS
  SET NOCOUNT ON
  SELECT * FROM [HumanResources].[Shift]
  EXECUTE MyTestProc

  CREATE PROCEDURE MyTestProc2
  AS
  SET NOCOUNT OFF
  SELECT * FROM [HumanResources].[Shift]
  EXEC MyTestProc2

  DROP PROC MYTESTPROC
  DROP  PROCEDURE MYTESTPROC2

  CREATE PROC MyFirstParamProc
  @Param_name VARCHAR(50)
  AS 
  SET NOCOUNT ON
  SELECT * FROM [HumanResources].[Shift]
  WHERE name=@Param_name

  EXEC MyFirstParamProc @Param_name='Day'
  EXEC MyFirstParamProc 'Day' --this is the same as above

   CREATE PROC MyFirstParamProc2
  @Param_name VARCHAR(50)='Evening' --this uses the default param if one is not passed in
  AS 
  SET NOCOUNT ON
  SELECT * FROM [HumanResources].[Shift]
  WHERE name=@Param_name

  EXEC MyFirstParamProc2 'Day'
  EXEC MyFirstParamProc2

  --OUTPUT PARAMETER
  CREATE PROC MyOutputSP 
  @TopShift VARCHAR(50) OUTPUT
  AS
  SET @TopShift=(SELECT TOP(1) ShiftID FROM  [HumanResources].[Shift])

  DECLARE @outputResult VARCHAR(50)
  EXEC MyOutputSP @outputResult OUTPUT
  SELECT @outputResult

  DROP PROC MyOutputSP

  --RETURNING VALUES FROM STORED PROCEDURES
  CREATE PROC MyFirstReturningSP
  AS
  RETURN 12

  DECLARE @returnVal INT
  EXEC @returnVal = MyFirstReturningSP
  SELECT @returnVal

  -----------USER DEFINED FUNCTIONS-----------
  SELECT * FROM Sales.SalesTerritory
  ----SCALAR FUNCTION (single type return)
  CREATE FUNCTION YTDSALES()
  RETURNS MONEY
  AS 
  BEGIN 
	DECLARE @YTDSALES MONEY
	SELECT @YTDSALES = SUM(SALESYTD) FROM [Sales].[SalesTerritory]
	RETURN @YTDSALES
  END

  DECLARE @YTDRESULTS AS MONEY
  SELECT @YTDRESULTS = DBO.YTDSALES()
  PRINT @YTDRESULTS

  DROP FUNCTION YTDSALES

  ----PARAMETERIZED FUNCTIONS
  SELECT * FROM Sales.SalesTerritory
  
  CREATE FUNCTION YTD_GROUP(@GROUP VARCHAR(50))
  RETURNS MONEY
  AS
  BEGIN
	DECLARE @YTDSALES AS MONEY
	SELECT @YTDSALES = SUM(SALESYTD) FROM [Sales].[SalesTerritory]
	WHERE [GROUP] = @GROUP
	RETURN @YTDSALES
  END

  DECLARE @RESULTS AS MONEY
  SELECT @RESULTS = DBO.YTD_GROUP('EUROPE')
  PRINT @RESULTS

  DROP FUNCTION YTD_GROUP

  ----FUNCTIONS RETURNING TABLES
  CREATE FUNCTION ST_TABVALUED (@TerroritoryID INT)
  RETURNS TABLE
  AS RETURN
  SELECT [Name], CountryRegionCode, [Group], SalesYTD
  FROM Sales.SalesTerritory
  WHERE TerritoryID = @TerroritoryID

  SELECT * FROM dbo.ST_TABVALUED(7)
  SELECT [Name], [Group] FROM dbo.ST_TABVALUED(7)

------------TRANSACTIONS-----------------
SELECT * FROM Sales.SalesTerritory

BEGIN TRANSACTION
	UPDATE Sales.SalesTerritory
	SET CostYTD = 1.00
	WHERE TerritoryID = 1
COMMIT TRANSACTION 

--@@error 0 no error, > 0 means error
DECLARE @ERRORRESULTS VARCHAR(50)
BEGIN TRANSACTION
	INSERT INTO [Sales].[SalesTerritory]
           ([Name]
           ,[CountryRegionCode]
           ,[Group]
           ,[SalesYTD]
           ,[SalesLastYear]
           ,[CostYTD]
           ,[CostLastYear]
           ,[rowguid]
           ,[ModifiedDate])
     VALUES
           ('ABC'
           ,'US'
           ,'NA'
           ,1.00
           ,1.00
           ,1.00
           ,1.00
           ,'43689A10-E30B-497F-B0DE-11DE20267FF3'
           ,GETDATE())
SET @ERRORRESULTS = @@ERROR
IF (@ERRORRESULTS = 0)
BEGIN
	PRINT 'SUCESS!'
	COMMIT TRANSACTION
END
ELSE
BEGIN
	PRINT 'STATEMENT FAILED!'
	ROLLBACK TRANSACTION
END
