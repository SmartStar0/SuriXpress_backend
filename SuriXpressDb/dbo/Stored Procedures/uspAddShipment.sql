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
