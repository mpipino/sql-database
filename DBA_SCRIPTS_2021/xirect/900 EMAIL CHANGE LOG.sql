BEGIN TRANSACTION
GO
ALTER TABLE dbo.EmailCampaign ADD CONSTRAINT
	PK_EmailCampaign_EmailCampaignId PRIMARY KEY CLUSTERED 
	(
	EmailCampaignId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.EmailCampaign SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
-- bodylogic_test: ok
-- xirectexpress: ok
-- naturana:ok

BEGIN TRANSACTION
GO
ALTER TABLE dbo.EmailTemplate ADD CONSTRAINT
	PK_EmailTemplate_EmailTemplateId PRIMARY KEY CLUSTERED 
	(
	EmailTemplateId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.EmailTemplate SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
-- bodylogic_test: ok
-- xirectexpress: ok
-- naturana:ok

BEGIN TRANSACTION
GO
ALTER TABLE dbo.EmailTemplates_Languages ADD CONSTRAINT
	PK_EmailTemplates_Languages_EmailTemplateLanguageDetailId PRIMARY KEY CLUSTERED 
	(
	EmailTemplateLanguageDetailId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.EmailTemplates_Languages SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
-- bodylogic_test: ok
-- xirectexpress: ok
-- naturana:ok

BEGIN TRANSACTION
--fks
ALTER TABLE dbo.EmailTemplate WITH NOCHECK
   ADD CONSTRAINT FK_EmailCampaign_EmailCampaignId FOREIGN KEY (EmailCampaignId)
      REFERENCES  dbo.EmailCampaign (EmailCampaignId)

ALTER TABLE dbo.EmailTemplates_Languages WITH NOCHECK
   ADD CONSTRAINT FK_EmailTemplate_EmailTemplateId FOREIGN KEY (EmailTemplateId)
      REFERENCES  dbo.EmailTemplate (EmailTemplateId)

ALTER TABLE dbo.EmailTemplates_Languages WITH NOCHECK
   ADD CONSTRAINT FK_Languages_LanguageId FOREIGN KEY (LanguageId)
      REFERENCES  dbo.tbl_Languages (ID)

ALTER TABLE dbo.EmailCampaign WITH NOCHECK
   ADD CONSTRAINT FK_EmailCampaign_EmailCampaignType FOREIGN KEY (EmailCampaignType)
      REFERENCES  dbo.EmailType (EmailTypeId)
COMMIT
-- bodylogic_test: Foreign key 'FK_EmailCampaign_EmailCampaignType' references invalid table 'dbo.EmailType'.
-- bodylogic_test: ok
-- xirectexpress: Foreign key 'FK_Languages_LanguageId' references invalid table 'dbo.tbl_Languages'.
-- naturana: Foreign key 'FK_Languages_LanguageId' references invalid table 'dbo.tbl_Languages'.

/*
Data inconsistente:
Msg 547, Level 16, State 0, Line 42
The ALTER TABLE statement conflicted with the FOREIGN KEY constraint "FK_EmailCampaign_EmailCampaignId". The conflict occurred in database "Express_Test", table "dbo.EmailCampaign", column 'EmailCampaignId'.

Falta tabla en express.
Msg 1767, Level 16, State 0, Line 50
Foreign key 'FK_Languages_LanguageId' references invalid table 'dbo.tbl_Languages'.
Msg 1750, Level 16, State 1, Line 50
Could not create constraint or index. See previous errors.
*/


BEGIN TRANSACTION
/****** Object:  Table [dbo].[EmailType]    Script Date: 3/8/2021 7:46:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailType](
	[EmailTypeId] [int] NOT NULL,
	[EmailTypeDescription] [nvarchar](150) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_EmailType] PRIMARY KEY CLUSTERED 
(
	[EmailTypeId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[EmailType] ([EmailTypeId], [EmailTypeDescription], [Status], [CreatedBy], [CreatedDate]) VALUES (1, N'EmailTemplates', 1, 99, CAST(N'2021-01-01T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[EmailType] ([EmailTypeId], [EmailTypeDescription], [Status], [CreatedBy], [CreatedDate]) VALUES (2, N'OrderInvoiceTemplates', 1, 99, CAST(N'2021-01-01T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[EmailType] ([EmailTypeId], [EmailTypeDescription], [Status], [CreatedBy], [CreatedDate]) VALUES (3, N'CommissionINvoiceTemplates', 1, 99, CAST(N'2021-01-01T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[EmailType] ([EmailTypeId], [EmailTypeDescription], [Status], [CreatedBy], [CreatedDate]) VALUES (4, N'EmailTemplatesExternal', 1, 99, CAST(N'2021-01-01T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[EmailType] ([EmailTypeId], [EmailTypeDescription], [Status], [CreatedBy], [CreatedDate]) VALUES (5, N'OrderInvoiceTemplateExternal', 1, 99, CAST(N'2021-01-01T00:00:00.000' AS DateTime))
GO
COMMIT
-- bodylogic_test:ok
-- xirectexpress: ok
