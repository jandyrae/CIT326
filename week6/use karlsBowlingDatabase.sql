use karlsBowlingDatabase
SELECT t.NAME AS TableName
FROM sys.Tables t
LEFT JOIN sys.sql_expression_dependencies d ON d.referenced_id = t.object_id
WHERE d.referenced_id IS NULL;