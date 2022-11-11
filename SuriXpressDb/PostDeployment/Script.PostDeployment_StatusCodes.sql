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