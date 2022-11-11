CREATE TABLE [dbo].[ShipmentDetails] (
    [Id]          UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
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
    PRIMARY KEY NONCLUSTERED ([Id] ASC),
    FOREIGN KEY ([ShipmentId]) REFERENCES [dbo].[Shipment] ([Id]) ON DELETE CASCADE
);

