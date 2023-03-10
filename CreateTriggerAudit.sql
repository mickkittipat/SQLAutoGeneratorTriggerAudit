USE [aspnet-TwoFactAuth]
GO
/****** Object:  StoredProcedure [dbo].[CreateTrigger]    Script Date: 1/13/2023 1:59:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE
	[dbo].[CreateTrigger]
(
	@SchemaName			AS SYSNAME ,
	@TableName			AS SYSNAME ,
	@TriggerName		AS SYSNAME 
)
AS

DECLARE
	@TriggerAction	AS NVARCHAR(20),
	@Command		AS NVARCHAR(MAX),
	@Command2		AS NVARCHAR(MAX),
	@Command3		AS NVARCHAR(MAX)


IF EXISTS (SELECT 
				t.name, s.name 
			FROM 
				sys.tables AS t 
			INNER JOIN 
				sys.schemas AS s 
			ON t.schema_id = s.schema_id 
			INNER JOIN
				sys.triggers AS tg
			ON
				tg.parent_id = t.object_id
			WHERE 
				object_name(tg.parent_id) = @TableName AND tg.name = @TriggerName
			) 
		SET @TriggerAction = 'ALTER'
	ELSE
		SET @TriggerAction = 'CREATE'


SET @Command =
	N'
		'+@TriggerAction+' TRIGGER
			   ' + QUOTENAME (@SchemaName) + N'.' + QUOTENAME (@TriggerName) + N'
		ON
			   ' + QUOTENAME (@SchemaName) + N'.' + QUOTENAME (@TableName) + N'
		AFTER
			   INSERT , UPDATE , DELETE
		AS
	
		declare
			@sql_operation as varchar(10)
				
       IF
       EXISTS
              (
			   SELECT
					NULL
               FROM
                    inserted
			  )
              BEGIN

                     IF
                           EXISTS
                                  (
									SELECT
                                        NULL
                                    FROM
                                        deleted
                                  )
                     BEGIN

                           SET @sql_operation = ''U'';  -- UPDATE
                     END
                     ELSE   -- No rows in "deleted" table
                     BEGIN

                           SET @sql_operation = ''I'';  -- INSERT
                     END;
              END
       ELSE   -- No rows in "inserted" table
              BEGIN
                     SET @sql_operation = ''D'';  -- DELETE
              END;

        INSERT INTO dbo.Auditing
              (
				DateTime, Action, TableName , NewValue, OriginalValue , ActionBy , MachineName	
			  )
		SELECT
				DateTime			= SYSDATETIME() ,
				Action				= @sql_operation ,
				TableName			= ''' + @TableName + N''',
				Value				= IIF(@sql_operation = ''D'', '''',isnull (CAST (FieldValues.NewValue AS VARCHAR(MAX)),'''')),
				Old_Value			= IIF(@sql_operation = ''I'', '''',isnull (CAST (FieldValues.OriginalValue AS VARCHAR(MAX)),'''')),
			    ActionBy            = suser_name(),
				MachineName         = host_name()
		FROM
			(
				SELECT';
SELECT
	@Command +=
		N'[' + name + N'_Before] = deleted.' + QUOTENAME (name) + N' ,
		[' + name + N'_After] = inserted.' + QUOTENAME (name) + N' ,
		'
FROM
	sys.columns
WHERE
	object_id = OBJECT_ID (QUOTENAME (@SchemaName) + N'.' + QUOTENAME (@TableName))
ORDER BY
	column_id ASC;


SET @Command = LEFT (@Command , LEN (@Command) - 5);

SET @Command +=
	N'
				FROM
					inserted
				FULL OUTER JOIN
					deleted
				ON
					';

SELECT
	@Command +=
		N'inserted.' + QUOTENAME (Columns.name) + N' = deleted.' + QUOTENAME (Columns.name) + N'
		AND
			'
FROM
	sys.indexes AS Indexes
INNER JOIN
	sys.index_columns AS IndexColumns
ON
	Indexes.object_id = IndexColumns.object_id
AND
	Indexes.index_id = IndexColumns.index_id
INNER JOIN
	sys.columns AS Columns
ON
	Indexes.object_id = Columns.object_id
AND
	IndexColumns.column_id = Columns.column_id
WHERE
	Indexes.object_id = OBJECT_ID (QUOTENAME (@SchemaName) + N'.' + QUOTENAME (@TableName))
AND
	Indexes.is_primary_key = 1;
					   
SET @Command = LEFT (@Command , LEN (@Command) - 10);



SET @Command2 =
	N'
			)
			AS
				RawData
		CROSS APPLY
			(
				VALUES
					(
				  N''{
					';

-- add data old
SELECT
	@Command2 +=
	
		'' + name + N' : "''+ISNULL(CAST([' + name + N'_Before] AS NVARCHAR(MAX)),'''')+''" ,
		'
FROM
	sys.columns
WHERE
	object_id = OBJECT_ID (QUOTENAME (@SchemaName) + N'.' + QUOTENAME (@TableName))
ORDER BY
	column_id ASC;

SET @Command2 = LEFT (@Command2 , LEN (@Command2) - 5);

SET @Command2 += '
		}''
		,
		 N''{'


-- add data new
SELECT
	@Command2 +=
	
		'' + name + N' : "''+ISNULL(CAST([' + name + N'_After] AS NVARCHAR(MAX)),'''')+''" ,
		'
FROM
	sys.columns
WHERE
	object_id = OBJECT_ID (QUOTENAME (@SchemaName) + N'.' + QUOTENAME (@TableName))
ORDER BY
	column_id ASC;

SET @Command2 = LEFT (@Command2 , LEN (@Command2) - 5);
SET @Command2 += '
		}''
		)'

SET @Command2 +=
	N'
			)
			AS
				FieldValues (OriginalValue , NewValue);
	';


 PRINT( @Command + @Command2) -- uncomment for debug
EXECUTE (@Command + @Command2)


