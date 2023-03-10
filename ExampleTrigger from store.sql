USE [aspnet-TwoFactAuth]
GO
/****** Object:  Trigger [dbo].[TriggerAspNetUsers]    Script Date: 1/13/2023 2:03:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

		ALTER TRIGGER
			   [dbo].[TriggerAspNetUsers]
		ON
			   [dbo].[AspNetUsers]
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

                           SET @sql_operation = 'U';  -- UPDATE
                     END
                     ELSE   -- No rows in "deleted" table
                     BEGIN

                           SET @sql_operation = 'I';  -- INSERT
                     END;
              END
       ELSE   -- No rows in "inserted" table
              BEGIN
                     SET @sql_operation = 'D';  -- DELETE
              END;

        INSERT INTO dbo.Auditing
              (
				DateTime, Action, TableName , NewValue, OriginalValue , ActionBy , MachineName	
			  )
		SELECT
				DateTime			= SYSDATETIME() ,
				Action				= @sql_operation ,
				TableName			= 'AspNetUsers',
				Value				= IIF(@sql_operation = 'D', '',isnull (CAST (FieldValues.NewValue AS VARCHAR(MAX)),'')),
				Old_Value			= IIF(@sql_operation = 'I', '',isnull (CAST (FieldValues.OriginalValue AS VARCHAR(MAX)),'')),
			    ActionBy            = suser_name(),
				MachineName         = host_name()
		FROM
			(
				SELECT[Id_Before] = deleted.[Id] ,
		[Id_After] = inserted.[Id] ,
		[AccessFailedCount_Before] = deleted.[AccessFailedCount] ,
		[AccessFailedCount_After] = inserted.[AccessFailedCount] ,
		[ConcurrencyStamp_Before] = deleted.[ConcurrencyStamp] ,
		[ConcurrencyStamp_After] = inserted.[ConcurrencyStamp] ,
		[Email_Before] = deleted.[Email] ,
		[Email_After] = inserted.[Email] ,
		[EmailConfirmed_Before] = deleted.[EmailConfirmed] ,
		[EmailConfirmed_After] = inserted.[EmailConfirmed] ,
		[LockoutEnabled_Before] = deleted.[LockoutEnabled] ,
		[LockoutEnabled_After] = inserted.[LockoutEnabled] ,
		[LockoutEnd_Before] = deleted.[LockoutEnd] ,
		[LockoutEnd_After] = inserted.[LockoutEnd] ,
		[NormalizedEmail_Before] = deleted.[NormalizedEmail] ,
		[NormalizedEmail_After] = inserted.[NormalizedEmail] ,
		[NormalizedUserName_Before] = deleted.[NormalizedUserName] ,
		[NormalizedUserName_After] = inserted.[NormalizedUserName] ,
		[PasswordHash_Before] = deleted.[PasswordHash] ,
		[PasswordHash_After] = inserted.[PasswordHash] ,
		[PhoneNumber_Before] = deleted.[PhoneNumber] ,
		[PhoneNumber_After] = inserted.[PhoneNumber] ,
		[PhoneNumberConfirmed_Before] = deleted.[PhoneNumberConfirmed] ,
		[PhoneNumberConfirmed_After] = inserted.[PhoneNumberConfirmed] ,
		[SecurityStamp_Before] = deleted.[SecurityStamp] ,
		[SecurityStamp_After] = inserted.[SecurityStamp] ,
		[TwoFactorEnabled_Before] = deleted.[TwoFactorEnabled] ,
		[TwoFactorEnabled_After] = inserted.[TwoFactorEnabled] ,
		[UserName_Before] = deleted.[UserName] ,
		[UserName_After] = inserted.[UserName] 
				FROM
					inserted
				FULL OUTER JOIN
					deleted
				ON
					inserted.[Id] = deleted.[Id]

			)
			AS
				RawData
		CROSS APPLY
			(
				VALUES
					(
				  N'{
					Id : "'+ISNULL(CAST([Id_Before] AS NVARCHAR(MAX)),'')+'" ,
		AccessFailedCount : "'+ISNULL(CAST([AccessFailedCount_Before] AS NVARCHAR(MAX)),'')+'" ,
		ConcurrencyStamp : "'+ISNULL(CAST([ConcurrencyStamp_Before] AS NVARCHAR(MAX)),'')+'" ,
		Email : "'+ISNULL(CAST([Email_Before] AS NVARCHAR(MAX)),'')+'" ,
		EmailConfirmed : "'+ISNULL(CAST([EmailConfirmed_Before] AS NVARCHAR(MAX)),'')+'" ,
		LockoutEnabled : "'+ISNULL(CAST([LockoutEnabled_Before] AS NVARCHAR(MAX)),'')+'" ,
		LockoutEnd : "'+ISNULL(CAST([LockoutEnd_Before] AS NVARCHAR(MAX)),'')+'" ,
		NormalizedEmail : "'+ISNULL(CAST([NormalizedEmail_Before] AS NVARCHAR(MAX)),'')+'" ,
		NormalizedUserName : "'+ISNULL(CAST([NormalizedUserName_Before] AS NVARCHAR(MAX)),'')+'" ,
		PasswordHash : "'+ISNULL(CAST([PasswordHash_Before] AS NVARCHAR(MAX)),'')+'" ,
		PhoneNumber : "'+ISNULL(CAST([PhoneNumber_Before] AS NVARCHAR(MAX)),'')+'" ,
		PhoneNumberConfirmed : "'+ISNULL(CAST([PhoneNumberConfirmed_Before] AS NVARCHAR(MAX)),'')+'" ,
		SecurityStamp : "'+ISNULL(CAST([SecurityStamp_Before] AS NVARCHAR(MAX)),'')+'" ,
		TwoFactorEnabled : "'+ISNULL(CAST([TwoFactorEnabled_Before] AS NVARCHAR(MAX)),'')+'" ,
		UserName : "'+ISNULL(CAST([UserName_Before] AS NVARCHAR(MAX)),'')+'" 
		}'
		,
		 N'{Id : "'+ISNULL(CAST([Id_After] AS NVARCHAR(MAX)),'')+'" ,
		AccessFailedCount : "'+ISNULL(CAST([AccessFailedCount_After] AS NVARCHAR(MAX)),'')+'" ,
		ConcurrencyStamp : "'+ISNULL(CAST([ConcurrencyStamp_After] AS NVARCHAR(MAX)),'')+'" ,
		Email : "'+ISNULL(CAST([Email_After] AS NVARCHAR(MAX)),'')+'" ,
		EmailConfirmed : "'+ISNULL(CAST([EmailConfirmed_After] AS NVARCHAR(MAX)),'')+'" ,
		LockoutEnabled : "'+ISNULL(CAST([LockoutEnabled_After] AS NVARCHAR(MAX)),'')+'" ,
		LockoutEnd : "'+ISNULL(CAST([LockoutEnd_After] AS NVARCHAR(MAX)),'')+'" ,
		NormalizedEmail : "'+ISNULL(CAST([NormalizedEmail_After] AS NVARCHAR(MAX)),'')+'" ,
		NormalizedUserName : "'+ISNULL(CAST([NormalizedUserName_After] AS NVARCHAR(MAX)),'')+'" ,
		PasswordHash : "'+ISNULL(CAST([PasswordHash_After] AS NVARCHAR(MAX)),'')+'" ,
		PhoneNumber : "'+ISNULL(CAST([PhoneNumber_After] AS NVARCHAR(MAX)),'')+'" ,
		PhoneNumberConfirmed : "'+ISNULL(CAST([PhoneNumberConfirmed_After] AS NVARCHAR(MAX)),'')+'" ,
		SecurityStamp : "'+ISNULL(CAST([SecurityStamp_After] AS NVARCHAR(MAX)),'')+'" ,
		TwoFactorEnabled : "'+ISNULL(CAST([TwoFactorEnabled_After] AS NVARCHAR(MAX)),'')+'" ,
		UserName : "'+ISNULL(CAST([UserName_After] AS NVARCHAR(MAX)),'')+'" 
		}'
		)
			)
			AS
				FieldValues (OriginalValue , NewValue);
	