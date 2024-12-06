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
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

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
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE = OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [sys].[databases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
    END


GO
PRINT N'Creating Table [dbo].[__EFMigrationsHistory]...';


GO
CREATE TABLE [dbo].[__EFMigrationsHistory] (
    [MigrationId]    NVARCHAR (150) NOT NULL,
    [ProductVersion] NVARCHAR (32)  NOT NULL,
    CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED ([MigrationId] ASC)
);


GO
PRINT N'Creating Table [dbo].[AspNetRoleClaims]...';


GO
CREATE TABLE [dbo].[AspNetRoleClaims] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [RoleId]     NVARCHAR (450) NOT NULL,
    [ClaimType]  NVARCHAR (MAX) NULL,
    [ClaimValue] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[AspNetRoleClaims].[IX_AspNetRoleClaims_RoleId]...';


GO
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId]
    ON [dbo].[AspNetRoleClaims]([RoleId] ASC);


GO
PRINT N'Creating Table [dbo].[AspNetRoles]...';


GO
CREATE TABLE [dbo].[AspNetRoles] (
    [Id]               NVARCHAR (450) NOT NULL,
    [Name]             NVARCHAR (256) NULL,
    [NormalizedName]   NVARCHAR (256) NULL,
    [ConcurrencyStamp] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[AspNetRoles].[RoleNameIndex]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex]
    ON [dbo].[AspNetRoles]([NormalizedName] ASC) WHERE ([NormalizedName] IS NOT NULL);


GO
PRINT N'Creating Table [dbo].[AspNetUserClaims]...';


GO
CREATE TABLE [dbo].[AspNetUserClaims] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [UserId]     NVARCHAR (450) NOT NULL,
    [ClaimType]  NVARCHAR (MAX) NULL,
    [ClaimValue] NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[AspNetUserClaims].[IX_AspNetUserClaims_UserId]...';


GO
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId]
    ON [dbo].[AspNetUserClaims]([UserId] ASC);


GO
PRINT N'Creating Table [dbo].[AspNetUserLogins]...';


GO
CREATE TABLE [dbo].[AspNetUserLogins] (
    [LoginProvider]       NVARCHAR (128) NOT NULL,
    [ProviderKey]         NVARCHAR (128) NOT NULL,
    [ProviderDisplayName] NVARCHAR (MAX) NULL,
    [UserId]              NVARCHAR (450) NOT NULL,
    CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED ([LoginProvider] ASC, [ProviderKey] ASC)
);


GO
PRINT N'Creating Index [dbo].[AspNetUserLogins].[IX_AspNetUserLogins_UserId]...';


GO
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId]
    ON [dbo].[AspNetUserLogins]([UserId] ASC);


GO
PRINT N'Creating Table [dbo].[AspNetUserRoles]...';


GO
CREATE TABLE [dbo].[AspNetUserRoles] (
    [UserId] NVARCHAR (450) NOT NULL,
    [RoleId] NVARCHAR (450) NOT NULL,
    CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC)
);


GO
PRINT N'Creating Index [dbo].[AspNetUserRoles].[IX_AspNetUserRoles_RoleId]...';


GO
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId]
    ON [dbo].[AspNetUserRoles]([RoleId] ASC);


GO
PRINT N'Creating Table [dbo].[AspNetUsers]...';


GO
CREATE TABLE [dbo].[AspNetUsers] (
    [Id]                   NVARCHAR (450)     NOT NULL,
    [UserName]             NVARCHAR (256)     NULL,
    [NormalizedUserName]   NVARCHAR (256)     NULL,
    [Email]                NVARCHAR (256)     NULL,
    [NormalizedEmail]      NVARCHAR (256)     NULL,
    [EmailConfirmed]       BIT                NOT NULL,
    [PasswordHash]         NVARCHAR (MAX)     NULL,
    [SecurityStamp]        NVARCHAR (MAX)     NULL,
    [ConcurrencyStamp]     NVARCHAR (MAX)     NULL,
    [PhoneNumber]          NVARCHAR (MAX)     NULL,
    [PhoneNumberConfirmed] BIT                NOT NULL,
    [TwoFactorEnabled]     BIT                NOT NULL,
    [LockoutEnd]           DATETIMEOFFSET (7) NULL,
    [LockoutEnabled]       BIT                NOT NULL,
    [AccessFailedCount]    INT                NOT NULL,
    CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Index [dbo].[AspNetUsers].[EmailIndex]...';


GO
CREATE NONCLUSTERED INDEX [EmailIndex]
    ON [dbo].[AspNetUsers]([NormalizedEmail] ASC);


GO
PRINT N'Creating Index [dbo].[AspNetUsers].[UserNameIndex]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex]
    ON [dbo].[AspNetUsers]([NormalizedUserName] ASC) WHERE ([NormalizedUserName] IS NOT NULL);


GO
PRINT N'Creating Table [dbo].[AspNetUserTokens]...';


GO
CREATE TABLE [dbo].[AspNetUserTokens] (
    [UserId]        NVARCHAR (450) NOT NULL,
    [LoginProvider] NVARCHAR (128) NOT NULL,
    [Name]          NVARCHAR (128) NOT NULL,
    [Value]         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED ([UserId] ASC, [LoginProvider] ASC, [Name] ASC)
);


GO
PRINT N'Creating Table [dbo].[Customer]...';


GO
CREATE TABLE [dbo].[Customer] (
    [Id]             UNIQUEIDENTIFIER NOT NULL,
    [CustomerNumber] NVARCHAR (20)    NOT NULL,
    [FirstName]      NVARCHAR (20)    NULL,
    [LastName]       NVARCHAR (20)    NULL,
    PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [AK_CustomerNumber] UNIQUE NONCLUSTERED ([CustomerNumber] ASC)
);


GO
PRINT N'Creating Table [dbo].[Product]...';


GO
CREATE TABLE [dbo].[Product] (
    [Id]            UNIQUEIDENTIFIER NOT NULL,
    [Name]          NVARCHAR (20)    NULL,
    [Description]   NVARCHAR (20)    NULL,
    [Lenght]        TINYINT          NULL,
    [Width]         TINYINT          NULL,
    [Height]        TINYINT          NULL,
    [Capacity]      INT              NULL,
    [Price_to_buy]  DECIMAL (10, 2)  NULL,
    [Price_to_ship] DECIMAL (10, 2)  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating Table [dbo].[Shipment]...';


GO
CREATE TABLE [dbo].[Shipment] (
    [Id]                 UNIQUEIDENTIFIER NOT NULL,
    [ShipmentNumber]     NVARCHAR (20)    NOT NULL,
    [ShipmentAgent]      NVARCHAR (20)    NOT NULL,
    [ShipmentType]       NVARCHAR (10)    NOT NULL,
    [ShipmentDate]       DATETIME2 (7)    NULL,
    [SenderAddressId]    UNIQUEIDENTIFIER NOT NULL,
    [ReceiverAddressId]  UNIQUEIDENTIFIER NOT NULL,
    [ShipmentStatusCode] INT              NOT NULL,
    [BrancheId]          UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]         UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]          UNIQUEIDENTIFIER NOT NULL,
    [CreatedAt]          DATETIME2 (7)    NULL,
    [UpdatedBy]          UNIQUEIDENTIFIER NULL,
    [UpdatedAt]          DATETIME2 (7)    NULL,
    PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [AK_ShipmentNumber] UNIQUE CLUSTERED ([ShipmentNumber] ASC)
);


GO
PRINT N'Creating Table [dbo].[ShipmentDetails]...';


GO
CREATE TABLE [dbo].[ShipmentDetails] (
    [Id]          UNIQUEIDENTIFIER NOT NULL,
    [ShipmentId]  UNIQUEIDENTIFIER NOT NULL,
    [LineNo]      SMALLINT         NULL,
    [Weight]      FLOAT (53)       NULL,
    [Length]      FLOAT (53)       NULL,
    [Width]       FLOAT (53)       NULL,
    [Height]      FLOAT (53)       NULL,
    [VolWeight]   FLOAT (53)       NULL,
    [Description] NVARCHAR (MAX)   NULL,
    [Quantity]    INT              NULL,
    [EachCost]    FLOAT (53)       NULL,
    [TrackingId]  NVARCHAR (MAX)   NULL,
    PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


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
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Customer]...';


GO
ALTER TABLE [dbo].[Customer]
    ADD DEFAULT (newid()) FOR [Id];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Product]...';


GO
ALTER TABLE [dbo].[Product]
    ADD DEFAULT (newid()) FOR [Id];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Shipment]...';


GO
ALTER TABLE [dbo].[Shipment]
    ADD DEFAULT (newid()) FOR [Id];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Shipment]...';


GO
ALTER TABLE [dbo].[Shipment]
    ADD DEFAULT 0 FOR [ShipmentStatusCode];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Shipment]...';


GO
ALTER TABLE [dbo].[Shipment]
    ADD DEFAULT GETDATE() FOR [CreatedAt];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[ShipmentDetails]...';


GO
ALTER TABLE [dbo].[ShipmentDetails]
    ADD DEFAULT (newid()) FOR [Id];


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[StatusCodes]...';


GO
ALTER TABLE [dbo].[StatusCodes]
    ADD DEFAULT (newid()) FOR [Id];


GO
PRINT N'Creating Sequence [dbo].[shipment_seq]...';


GO
CREATE SEQUENCE [dbo].[shipment_seq]
    AS BIGINT
    START WITH 1293846
    INCREMENT BY 1
    CACHE 10;


GO
PRINT N'Creating Default Constraint unnamed constraint on [dbo].[Shipment]...';


GO
ALTER TABLE [dbo].[Shipment]
    ADD DEFAULT (N'SX'+CONVERT([nvarchar](15),NEXT VALUE FOR [dbo].[shipment_seq])) FOR [ShipmentNumber];


GO
PRINT N'Creating Foreign Key [dbo].[FK_AspNetRoleClaims_AspNetRoles_RoleId]...';


GO
ALTER TABLE [dbo].[AspNetRoleClaims] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_AspNetUserClaims_AspNetUsers_UserId]...';


GO
ALTER TABLE [dbo].[AspNetUserClaims] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_AspNetUserLogins_AspNetUsers_UserId]...';


GO
ALTER TABLE [dbo].[AspNetUserLogins] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_AspNetUserRoles_AspNetRoles_RoleId]...';


GO
ALTER TABLE [dbo].[AspNetUserRoles] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_AspNetUserRoles_AspNetUsers_UserId]...';


GO
ALTER TABLE [dbo].[AspNetUserRoles] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key [dbo].[FK_AspNetUserTokens_AspNetUsers_UserId]...';


GO
ALTER TABLE [dbo].[AspNetUserTokens] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Creating Foreign Key unnamed constraint on [dbo].[ShipmentDetails]...';


GO
ALTER TABLE [dbo].[ShipmentDetails] WITH NOCHECK
    ADD FOREIGN KEY ([ShipmentId]) REFERENCES [dbo].[Shipment] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Creating Procedure [dbo].[uspAddShipment]...';


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
CREATE PROCEDURE uspAddShipment


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
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

MERGE INTO dbo.StatusCodes AS TARGET
USING (
	VALUES (0,'Created','Shipment')
		  ,(1,'Approved','Shipment')
		  ,(2,'In Progress', 'Shipment')
		  ,(3,'Delivered','Shipment')
		  ,(4,'Completed', 'Shipment')
	) AS SOURCE([StatusCode], [StatusName], [StatusType])
	ON TARGET.StatusCode = Source.StatusCode
		AND TARGET.StatusName = Source.StatusName
		AND TARGET.StatusType = SOURCE.StatusType
WHEN MATCHED
	THEN
		UPDATE
		SET StatusCode = SOURCE.StatusCode
			,StatusName = SOURCE.StatusName
			,StatusType = SOURCE.StatusType
WHEN NOT MATCHED BY TARGET
	THEN
		INSERT (
			[StatusCode]
			,[StatusName]
			,[StatusType]
			)
		VALUES (
			[StatusCode]
			,[StatusName]
			,[StatusType]
			);
GO

GO
