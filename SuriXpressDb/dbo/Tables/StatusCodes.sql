CREATE TABLE [dbo].[StatusCodes] (
 [Id]             UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
 [StatusCode] INT NOT NULL,
 [StatusName] NVARCHAR(30) NOT NULL,
 [StatusType] NVARCHAR(30) NOT NULL, 
    PRIMARY KEY NONCLUSTERED ([Id] ASC),
 )