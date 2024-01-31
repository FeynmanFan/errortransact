BEGIN TRAN 
	ALTER TABLE Employees ADD salt uniqueidentifier
	ALTER TABLE Employees ALTER COLUMN Password varchar(64)
	GO
	BEGIN TRY
		DECLARE @testFlight bit = 0
	
		UPDATE Employees SET salt = NewId()
		UPDATE Employees SET password = dbo.HashwithSalt(password, salt)

		--SELECT 1/0

		PRINT 'UPDATE SUCCESSFUL'
		IF @testFlight = 1
		BEGIN
			DECLARE @testFlightMessage varchar(255) = 'Returning to prior state after successful test flight'
			PRINT @testFlightMessage;
			THROW 55150, @testFlightMessage, 1
		END
		COMMIT 
	END TRY
	BEGIN CATCH
		ROLLBACK
		IF ERROR_NUMBER() <> 55150 
		BEGIN
			PRINT 'ENCOUNTERED UNEXPECTED ERROR';
			THROW 
		END
	END CATCH