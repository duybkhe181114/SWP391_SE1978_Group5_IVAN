-- Make sure you are using the correct database
USE IVAN;
GO

-- Check Organizations table structure
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Organizations'
ORDER BY ORDINAL_POSITION;
