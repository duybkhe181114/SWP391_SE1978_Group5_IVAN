USE [IVAN]
GO

IF OBJECT_ID(N'dbo.OrganizationProfileUpdateRequests', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[OrganizationProfileUpdateRequests](
        [RequestId] [int] IDENTITY(1,1) NOT NULL,
        [UserId] [int] NOT NULL,
        [OrganizationName] [nvarchar](200) NOT NULL,
        [OrganizationType] [nvarchar](50) NULL,
        [EstablishedYear] [int] NULL,
        [TaxCode] [nvarchar](50) NULL,
        [BusinessLicenseNumber] [nvarchar](100) NULL,
        [RepresentativeName] [nvarchar](100) NOT NULL,
        [RepresentativePosition] [nvarchar](100) NOT NULL,
        [Phone] [nvarchar](20) NOT NULL,
        [Address] [nvarchar](500) NOT NULL,
        [Website] [nvarchar](255) NULL,
        [FacebookPage] [nvarchar](255) NULL,
        [Description] [nvarchar](max) NOT NULL,
        [Status] [nvarchar](50) NULL CONSTRAINT [DF_OrgProfileUpdateReq_Status] DEFAULT ('Pending'),
        [RequestedAt] [datetime] NULL CONSTRAINT [DF_OrgProfileUpdateReq_RequestedAt] DEFAULT (getdate()),
        [ReviewedBy] [int] NULL,
        [ReviewedAt] [datetime] NULL,
        [ReviewNote] [nvarchar](500) NULL,
        CONSTRAINT [PK_OrganizationProfileUpdateRequests] PRIMARY KEY CLUSTERED ([RequestId] ASC),
        CONSTRAINT [FK_OrgProfileUpdateReq_Reviewer] FOREIGN KEY([ReviewedBy]) REFERENCES [dbo].[Users] ([UserId]),
        CONSTRAINT [FK_OrgProfileUpdateReq_Users] FOREIGN KEY([UserId]) REFERENCES [dbo].[Users] ([UserId])
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
END
GO
