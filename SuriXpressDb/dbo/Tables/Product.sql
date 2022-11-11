CREATE TABLE [dbo].[Product] (
    [Id]            UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
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

