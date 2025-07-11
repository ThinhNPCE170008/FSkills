IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'TestResult' AND COLUMN_NAME = 'DateTaken')
BEGIN
    ALTER TABLE [dbo].[TestResult]
    ADD [DateTaken] [datetime2](7) NULL DEFAULT GETDATE();
END

UPDATE [dbo].[TestResult]
SET [DateTaken] = GETDATE()
WHERE [DateTaken] IS NULL; 