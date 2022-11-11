CREATE TABLE [dbo].[Shipment] (
    [Id]             UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [ShipmentNumber] NVARCHAR (20)    DEFAULT (N'SX'+CONVERT([nvarchar](15),NEXT VALUE FOR [dbo].[shipment_seq])) NOT NULL,
    [ShipmentAgent]   NVARCHAR (20)   NOT NULL,
    [ShipmentType]    NVARCHAR(10) NOT NULL ,
    [ShipmentDate]      DATETIME2(7) NULL, 
    [SenderAddressId] UNIQUEIDENTIFIER NOT NULL, 
    [ReceiverAddressId]   UNIQUEIDENTIFIER NOT NULL,
    [ShipmentStatusCode]    INT NOT NULL DEFAULT 0,
    [BrancheId]         UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]        UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]         UNIQUEIDENTIFIER NOT NULL, 
    [CreatedAt]         DATETIME2(7) DEFAULT GETDATE(), 
    [UpdatedBy]         UNIQUEIDENTIFIER  NULL, 
    [UpdatedAt]         DATETIME2(7) NULL, 
    PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [AK_ShipmentNumber] UNIQUE CLUSTERED ([ShipmentNumber] ASC)
);



