USE [aspnet-TwoFactAuth]
GO
/****** Object:  Table [dbo].[Auditing]    Script Date: 1/13/2023 2:03:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Auditing](
	[DateTime] [varchar](24) NOT NULL,
	[Action] [varchar](21) NOT NULL,
	[TableName] [varchar](90) NOT NULL,
	[NewValue] [varchar](max) NOT NULL,
	[OriginalValue] [varchar](max) NOT NULL,
	[ActionBy] [varchar](50) NULL,
	[MachineName] [varchar](150) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
