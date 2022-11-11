CREATE TABLE [dbo].[Customer] (
    [Id]             UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [CustomerNumber] NVARCHAR (20)    NOT NULL,
    [FirstName]      NVARCHAR (20)    NULL,
    [LastName]       NVARCHAR (20)    NULL
    PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [AK_CustomerNumber] UNIQUE NONCLUSTERED ([CustomerNumber] ASC)
);

