# SQL AutoGenerator Trigger Audit table

Many applications have a need to keep audit information on changes made to objects in the database. Traditionally, this would be done either through log events, stored procedures that implement the logging, or the use of archive/tombstone tables to store the old values before the modification (hopefully enforced through stored procedures). With all of these, there is always a chance that a developer could forget to do those things in a specific section of code, and that changes could be made through the application without logging the change correctly. With SQL Trigger

# Example
1. The Create trigger the Stored Procedure generates :

    * Execute create CreateTriggerAudit.sql

<h3 align="center">
    <img src="https://drive.google.com/uc?export=view&id=1Oxyh6_qx3fy40K0xdYP5bX9YSAibJ6w0" alt="Logo">
</h3>

2. Create table Audit for save log change data

    * Execute create createtableAudit.sql
 
 <h3 align="center">
    <img src="https://drive.google.com/uc?export=view&id=1P0nNGlTBK50yzWrH7onNxzyFv28QNcyD" alt="Logo">
</h3>

3. Create Example table 
```shell
  * Execute create table from sql statement below :
    /****** Object:  Table [dbo].[Invitations]    Script Date: 8/9/2016 3:33:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invitations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RequestingSessionId] [int] NOT NULL,
	[ReceivingMemberId] [int] NOT NULL,
	[CreationDateTime] [datetime2](0) NOT NULL,
	[StatusId] [tinyint] NOT NULL,
	[ResponseDateTime] [datetime2](0) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Invitations] ON 

GO
INSERT [dbo].[Invitations] ([Id], [RequestingSessionId], [ReceivingMemberId], [CreationDateTime], [StatusId], [ResponseDateTime]) VALUES (169, 832759, 35017, CAST(N'2015-01-09 09:23:00.0000000' AS DateTime2), 2, CAST(N'2015-02-21 12:01:48.0000000' AS DateTime2))
GO
INSERT [dbo].[Invitations] ([Id], [RequestingSessionId], [ReceivingMemberId], [CreationDateTime], [StatusId], [ResponseDateTime]) VALUES (431, 924724, 43209, CAST(N'2013-01-18 22:34:40.0000000' AS DateTime2), 1, NULL)
GO
INSERT [dbo].[Invitations] ([Id], [RequestingSessionId], [ReceivingMemberId], [CreationDateTime], [StatusId], [ResponseDateTime]) VALUES (516, 380518, 76866, CAST(N'2014-10-30 04:52:19.0000000' AS DateTime2), 2, CAST(N'2015-11-30 12:19:20.0000000' AS DateTime2))
GO
INSERT [dbo].[Invitations] ([Id], [RequestingSessionId], [ReceivingMemberId], [CreationDateTime], [StatusId], [ResponseDateTime]) VALUES (592, 416546, 85347, CAST(N'2015-12-21 10:34:32.0000000' AS DateTime2), 2, CAST(N'2016-04-25 19:09:42.0000000' AS DateTime2))
GO
INSERT [dbo].[Invitations] ([Id], [RequestingSessionId], [ReceivingMemberId], [CreationDateTime], [StatusId], [ResponseDateTime]) VALUES (614, 960414, 50352, CAST(N'2012-11-01 14:25:26.0000000' AS DateTime2), 1, NULL)
GO
INSERT [dbo].[Invitations] ([Id], [RequestingSessionId], [ReceivingMemberId], [CreationDateTime], [StatusId], [ResponseDateTime]) VALUES (686, 193229, 66413, CAST(N'2013-10-16 17:02:33.0000000' AS DateTime2), 1, NULL)
GO
INSERT [dbo].[Invitations] ([Id], [RequestingSessionId], [ReceivingMemberId], [CreationDateTime], [StatusId], [ResponseDateTime]) VALUES (767, 970969, 28664, CAST(N'2014-12-31 03:17:28.0000000' AS DateTime2), 3, CAST(N'2016-02-13 05:50:49.0000000' AS DateTime2))
GO
INSERT [dbo].[Invitations] ([Id], [RequestingSessionId], [ReceivingMemberId], [CreationDateTime], [StatusId], [ResponseDateTime]) VALUES (863, 535035, 49426, CAST(N'2013-07-20 09:20:53.0000000' AS DateTime2), 3, CAST(N'2016-06-29 21:12:17.0000000' AS DateTime2))
GO
INSERT [dbo].[Invitations] ([Id], [RequestingSessionId], [ReceivingMemberId], [CreationDateTime], [StatusId], [ResponseDateTime]) VALUES (878, 164137, 66218, CAST(N'2016-06-22 12:17:06.0000000' AS DateTime2), 1, NULL)
GO
INSERT [dbo].[Invitations] ([Id], [RequestingSessionId], [ReceivingMemberId], [CreationDateTime], [StatusId], [ResponseDateTime]) VALUES (991, 112725, 15755, CAST(N'2011-06-25 18:20:43.0000000' AS DateTime2), 3, CAST(N'2014-05-05 04:47:16.0000000' AS DateTime2))
GO
SET IDENTITY_INSERT [dbo].[Invitations] OFF
GO
```

4. Exam auto generates trigger audit from Invitations table
  * Execute stored procedure CreateTrigger : 
  
  Exam parameter : @SchemaName = dbo , @TableName	= Invitations , @TriggerName = TriggerInvitations
  
   <h3 align="center">
    <img src="https://drive.google.com/uc?export=view&id=1P2EAGHbe3tTJA_vCaYzpIVIBQyOVsNqv" alt="Logo">
</h3>

 * Results : 
    <h3 align="center">
    <img src="https://drive.google.com/uc?export=view&id=1P7bj7uVVotHsvkLTSQWERI7MHevdJcRn" alt="Logo">
</h3>

5. Test changes data in in Invitations table 
  * Insert , Update , Delete in Invitations log to Audit table
    <h3 align="center">
    <img src="https://drive.google.com/uc?export=view&id=1PFjx_lcjoM6oObiOFKJcDM4zQ5GG63r7" alt="Logo">
</h3>
 * Results : 
 
<table border="1">
    <tr>
        <th>DateTime</th>
        <th>Action</th>
        <th>TableName</th>
        <th>NewValue</th>
        <th>OriginalValue</th>
        <th>ActionBy</th>
        <th>MachineName</th>
    </tr>
    <tr xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <td>2023-01-13 15:06:57.1738</td>
        <td>I</td>
        <td>Invitations</td>
        <td>{Id : "1010" ,&#x0D; RequestingSessionId : "2" ,&#x0D; ReceivingMemberId : "2" ,&#x0D; CreationDateTime : "2011-06-25 18:30:43" ,&#x0D; StatusId : "1" ,&#x0D; ResponseDateTime : "2011-06-25 18:30:43" &#x0D; }</td>
        <td></td>
        <td>DESKTOP-8F7UHRL\User</td>
        <td>DESKTOP-8F7UHRL</td>
    </tr>
    <tr xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <td>2023-01-13 15:07:00.9541</td>
        <td>U</td>
        <td>Invitations</td>
        <td>{Id : "1010" ,&#x0D; RequestingSessionId : "2" ,&#x0D; ReceivingMemberId : "1" ,&#x0D; CreationDateTime : "2011-06-25 18:30:43" ,&#x0D; StatusId : "1" ,&#x0D; ResponseDateTime : "2011-06-25 18:30:43" &#x0D; }</td>
        <td>{&#x0D; Id : "1010" ,&#x0D; RequestingSessionId : "2" ,&#x0D; ReceivingMemberId : "2" ,&#x0D; CreationDateTime : "2011-06-25 18:30:43" ,&#x0D; StatusId : "1" ,&#x0D; ResponseDateTime : "2011-06-25 18:30:43" &#x0D; }</td>
        <td>DESKTOP-8F7UHRL\User</td>
        <td>DESKTOP-8F7UHRL</td>
    </tr>
    <tr xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <td>2023-01-13 15:07:03.4543</td>
        <td>D</td>
        <td>Invitations</td>
        <td></td>
        <td>{&#x0D; Id : "1010" ,&#x0D; RequestingSessionId : "2" ,&#x0D; ReceivingMemberId : "1" ,&#x0D; CreationDateTime : "2011-06-25 18:30:43" ,&#x0D; StatusId : "1" ,&#x0D; ResponseDateTime : "2011-06-25 18:30:43" &#x0D; }</td>
        <td>DESKTOP-8F7UHRL\User</td>
        <td>DESKTOP-8F7UHRL</td>
    </tr>
</table>

  
