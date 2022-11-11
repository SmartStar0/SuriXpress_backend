﻿/*
Deployment script for SuriXpress

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "SuriXpress"
:setvar DefaultFilePrefix "SuriXpress"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
The column [dbo].[Shipment].[ShipmentName] is being dropped, data loss could occur.

The column [dbo].[Shipment].[BrancheId] on table [dbo].[Shipment] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column [dbo].[Shipment].[CreatedBy] on table [dbo].[Shipment] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column [dbo].[Shipment].[ReceiverAddressId] on table [dbo].[Shipment] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column [dbo].[Shipment].[SenderAddressId] on table [dbo].[Shipment] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column [dbo].[Shipment].[ShipmentAgent] on table [dbo].[Shipment] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column [dbo].[Shipment].[ShipmentType] on table [dbo].[Shipment] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column CustomerId on table [dbo].[Shipment] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column ShipmentNumber on table [dbo].[Shipment] must be changed from NULL to NOT NULL. If the table contains data, the ALTER script may not work. To avoid this issue, you must add values to this column for all rows or mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
*/

IF EXISTS (select top 1 1 from [dbo].[Shipment])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Dropping Default Constraint unnamed constraint on [dbo].[Shipment]...';


GO
ALTER TABLE [dbo].[Shipment] DROP CONSTRAINT [DF__Shipment__Shipme__14270015];


GO
PRINT N'Dropping Default Constraint unnamed constraint on [dbo].[Shipment]...';


GO
ALTER TABLE [dbo].[Shipment] DROP CONSTRAINT [DF__Shipment__Id__6FE99F9F];


GO
PRINT N'Dropping Foreign Key unnamed constraint on [dbo].[ShipmentDetails]...';


GO
ALTER TABLE [dbo].[ShipmentDetails] DROP CONSTRAINT [FK__ShipmentD__Shipm__08B54D69];


GO
PRINT N'Dropping Unique Constraint [dbo].[AK_ShipmentNumber]...';


GO
ALTER TABLE [dbo].[Shipment] DROP CONSTRAINT [AK_ShipmentNumber];


GO
PRINT N'Starting rebuilding table [dbo].[Shipment]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Shipment] (
    [Id]                 UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [ShipmentNumber]     NVARCHAR (20)    DEFAULT (N'SX' + CONVERT (NVARCHAR (15),  NEXT VALUE FOR [dbo].[shipment_seq])) NOT NULL,
    [ShipmentAgent]      NVARCHAR (20)    NOT NULL,
    [ShipmentType]       NVARCHAR (10)    NOT NULL,
    [ShipmentDate]       DATETIME2 (7)    NULL,
    [SenderAddressId]    UNIQUEIDENTIFIER NOT NULL,
    [ReceiverAddressId]  UNIQUEIDENTIFIER NOT NULL,
    [ShipmentStatusCode] INT              DEFAULT 0 NOT NULL,
    [BrancheId]          UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]         UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]          UNIQUEIDENTIFIER NOT NULL,
    [CreatedAt]          DATETIME2 (7)    DEFAULT GETDATE() NULL,
    [UpdatedBy]          UNIQUEIDENTIFIER NULL,
    [UpdatedAt]          DATETIME2 (7)    NULL,
    PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [tmp_ms_xx_constraint_AK_ShipmentNumber1] UNIQUE CLUSTERED ([ShipmentNumber] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Shipment])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Shipment] ([ShipmentNumber], [Id], [CustomerId])
        SELECT   [ShipmentNumber],
                 [Id],
                 [CustomerId]
        FROM     [dbo].[Shipment]
        ORDER BY [ShipmentNumber] ASC;
    END

DROP TABLE [dbo].[Shipment];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Shipment]', N'Shipment';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_AK_ShipmentNumber1]', N'AK_ShipmentNumber', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating Table [dbo].[StatusCodes]...';


GO
CREATE TABLE [dbo].[StatusCodes] (
    [Id]         UNIQUEIDENTIFIER NOT NULL,
    [StatusCode] INT              NOT NULL,
    [StatusName] NVARCHAR (30)    NOT NULL,
    [StatusType] NVARCHAR (30)    NOT NULL,
    PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[StatusCodes]...';


GO
ALTER TABLE [dbo].[StatusCodes]
    ADD DEFAULT (newid()) FOR [Id];


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[ShipmentDetails]...';


GO
ALTER TABLE [dbo].[ShipmentDetails] WITH NOCHECK
    ADD FOREIGN KEY ([ShipmentId]) REFERENCES [dbo].[Shipment] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Altering Procedure [dbo].[uspAddShipment]...';


GO
/*
-- =============================================
-- Author:        <Author,,Name>
-- Create date:  <Create Date,,>
-- Description:   <Description,,>
-- =============================================
--Change History
--Date   Changed by      Description
 
*/
ALTER PROCEDURE uspAddShipment


  @ShipmentName nvarchar(20)

AS
BEGIN
    SET NOCOUNT ON;
 
    BEGIN TRY

      BEGIN TRAN

		DECLARE @MyTableVar table(ShipmentId [uniqueidentifier]);
		DECLARE @ShipmentId uniqueidentifier


		INSERT INTO  dbo.Shipment ([ShipmentAgent])
			OUTPUT INSERTED.Id INTO @MyTableVar
		VALUES (@ShipmentName);

SELECT @ShipmentId =   ShipmentId FROM @MyTableVar;

INSERT INTO dbo.ShipmentDetails ([ShipmentId],[LineNo])
  VALUES( @ShipmentId, 1)
       ,(@ShipmentId, 2)
	   ,(@ShipmentId, 3)
	   ,(@ShipmentId, 4)
	   ,(@ShipmentId, 5);
 
      COMMIT TRAN
   END TRY
   
   BEGIN CATCH
      IF @@TRANCOUNT > 0
         ROLLBACK TRAN
      DECLARE @ErrorMessage NVARCHAR(4000);
      DECLARE @ErrorSeverity INT;
      DECLARE @ErrorState INT;
 
      SELECT @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
      RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState );
   END CATCH
END
GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
CREATE TABLE [#__checkStatus] (
    id           INT            IDENTITY (1, 1) PRIMARY KEY CLUSTERED,
    [Schema]     NVARCHAR (256),
    [Table]      NVARCHAR (256),
    [Constraint] NVARCHAR (256)
);

SET NOCOUNT ON;

DECLARE tableconstraintnames CURSOR LOCAL FORWARD_ONLY
    FOR SELECT SCHEMA_NAME([schema_id]),
               OBJECT_NAME([parent_object_id]),
               [name],
               0
        FROM   [sys].[objects]
        WHERE  [parent_object_id] IN (OBJECT_ID(N'dbo.ShipmentDetails'))
               AND [type] IN (N'F', N'C')
                   AND [object_id] IN (SELECT [object_id]
                                       FROM   [sys].[check_constraints]
                                       WHERE  [is_not_trusted] <> 0
                                              AND [is_disabled] = 0
                                       UNION
                                       SELECT [object_id]
                                       FROM   [sys].[foreign_keys]
                                       WHERE  [is_not_trusted] <> 0
                                              AND [is_disabled] = 0);

DECLARE @schemaname AS NVARCHAR (256);

DECLARE @tablename AS NVARCHAR (256);

DECLARE @checkname AS NVARCHAR (256);

DECLARE @is_not_trusted AS INT;

DECLARE @statement AS NVARCHAR (1024);

BEGIN TRY
    OPEN tableconstraintnames;
    FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
    WHILE @@fetch_status = 0
        BEGIN
            PRINT N'Checking constraint: ' + @checkname + N' [' + @schemaname + N'].[' + @tablename + N']';
            SET @statement = N'ALTER TABLE [' + @schemaname + N'].[' + @tablename + N'] WITH ' + CASE @is_not_trusted WHEN 0 THEN N'CHECK' ELSE N'NOCHECK' END + N' CHECK CONSTRAINT [' + @checkname + N']';
            BEGIN TRY
                EXECUTE [sp_executesql] @statement;
            END TRY
            BEGIN CATCH
                INSERT  [#__checkStatus] ([Schema], [Table], [Constraint])
                VALUES                  (@schemaname, @tablename, @checkname);
            END CATCH
            FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
        END
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') >= 0
    CLOSE tableconstraintnames;

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') = -1
    DEALLOCATE tableconstraintnames;

SELECT N'Constraint verification failed:' + [Schema] + N'.' + [Table] + N',' + [Constraint]
FROM   [#__checkStatus];

IF @@ROWCOUNT > 0
    BEGIN
        DROP TABLE [#__checkStatus];
        RAISERROR (N'An error occurred while verifying constraints', 16, 127);
    END

SET NOCOUNT OFF;

DROP TABLE [#__checkStatus];


GO
PRINT N'Update complete.';


GO
