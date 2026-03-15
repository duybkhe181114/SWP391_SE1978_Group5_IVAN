/*
    Canonical IVAN schema.

    Use this file for a clean database setup.
    It replaces the older export-style scripts such as merged.sql and IVAN_Data.sql,
    and already includes the newer schema pieces:
    - Events.CoverImageUrl
    - EventCoordinators
    - OrganizationProfileUpdateRequests
*/

SET NOCOUNT ON;
GO

IF DB_ID(N'IVAN') IS NULL
BEGIN
    CREATE DATABASE [IVAN];
END
GO

USE [IVAN];
GO

IF OBJECT_ID(N'dbo.Users', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Users (
        UserId INT IDENTITY(1,1) NOT NULL,
        Email NVARCHAR(255) NOT NULL,
        PasswordHash NVARCHAR(255) NOT NULL,
        IsActive BIT NOT NULL CONSTRAINT DF_Users_IsActive DEFAULT ((1)),
        CreatedAt DATETIME NULL CONSTRAINT DF_Users_CreatedAt DEFAULT (GETDATE()),
        CONSTRAINT PK_Users PRIMARY KEY CLUSTERED (UserId ASC),
        CONSTRAINT UQ_Users_Email UNIQUE (Email)
    );
END
GO

IF OBJECT_ID(N'dbo.UserRoles', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.UserRoles (
        UserRoleId INT IDENTITY(1,1) NOT NULL,
        UserId INT NOT NULL,
        Role NVARCHAR(50) NOT NULL,
        CONSTRAINT PK_UserRoles PRIMARY KEY CLUSTERED (UserRoleId ASC),
        CONSTRAINT FK_UserRoles_Users FOREIGN KEY (UserId) REFERENCES dbo.Users (UserId)
    );
END
GO

IF OBJECT_ID(N'dbo.Skills', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Skills (
        SkillId INT IDENTITY(1,1) NOT NULL,
        SkillName NVARCHAR(100) NOT NULL,
        CONSTRAINT PK_Skills PRIMARY KEY CLUSTERED (SkillId ASC),
        CONSTRAINT UQ_Skills_SkillName UNIQUE (SkillName)
    );
END
GO

IF OBJECT_ID(N'dbo.SupportCategories', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.SupportCategories (
        CategoryId INT IDENTITY(1,1) NOT NULL,
        Name NVARCHAR(100) NOT NULL,
        CONSTRAINT PK_SupportCategories PRIMARY KEY CLUSTERED (CategoryId ASC),
        CONSTRAINT UQ_SupportCategories_Name UNIQUE (Name)
    );
END
GO

IF OBJECT_ID(N'dbo.Organizations', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Organizations (
        OrganizationId INT IDENTITY(1,1) NOT NULL,
        Name NVARCHAR(255) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        Phone NVARCHAR(20) NULL,
        Email NVARCHAR(255) NULL,
        Address NVARCHAR(500) NULL,
        Website NVARCHAR(255) NULL,
        CreatedBy INT NOT NULL,
        CreatedAt DATETIME NULL CONSTRAINT DF_Organizations_CreatedAt DEFAULT (GETDATE()),
        UpdatedAt DATETIME NULL,
        LogoUrl NVARCHAR(MAX) NULL,
        CONSTRAINT PK_Organizations PRIMARY KEY CLUSTERED (OrganizationId ASC),
        CONSTRAINT FK_Organizations_Users FOREIGN KEY (CreatedBy) REFERENCES dbo.Users (UserId)
    );
END
GO

IF OBJECT_ID(N'dbo.UserProfiles', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.UserProfiles (
        UserId INT NOT NULL,
        FirstName NVARCHAR(100) NOT NULL,
        LastName NVARCHAR(100) NOT NULL,
        FullName AS (([FirstName] + ' ') + [LastName]) PERSISTED,
        Phone NVARCHAR(20) NULL,
        DateOfBirth DATE NULL,
        Gender NVARCHAR(10) NULL,
        Avatar NVARCHAR(500) NULL,
        Address NVARCHAR(500) NULL,
        WardCommune NVARCHAR(100) NULL,
        District NVARCHAR(100) NULL,
        Province NVARCHAR(100) NULL,
        PostalCode NVARCHAR(10) NULL,
        EmergencyContactName NVARCHAR(200) NULL,
        EmergencyContactPhone NVARCHAR(20) NULL,
        CreatedAt DATETIME2(7) NULL CONSTRAINT DF_UserProfiles_CreatedAt DEFAULT (SYSDATETIME()),
        UpdatedAt DATETIME2(7) NULL,
        OrganizationName NVARCHAR(200) NULL,
        OrganizationType NVARCHAR(50) NULL,
        EstablishedYear INT NULL,
        TaxCode NVARCHAR(50) NULL,
        BusinessLicenseNumber NVARCHAR(100) NULL,
        RepresentativeName NVARCHAR(100) NULL,
        RepresentativePosition NVARCHAR(100) NULL,
        FacebookPage NVARCHAR(255) NULL,
        ApprovalStatus NVARCHAR(20) NULL CONSTRAINT DF_UserProfiles_ApprovalStatus DEFAULT ('Approved'),
        ReviewNote NVARCHAR(MAX) NULL,
        ReviewedBy INT NULL,
        ReviewedAt DATETIME NULL,
        Website NVARCHAR(255) NULL,
        Description NVARCHAR(MAX) NULL,
        CONSTRAINT PK_UserProfiles PRIMARY KEY CLUSTERED (UserId ASC),
        CONSTRAINT FK_UserProfiles_Users FOREIGN KEY (UserId) REFERENCES dbo.Users (UserId)
    );
END
GO

IF OBJECT_ID(N'dbo.VolunteerSkills', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.VolunteerSkills (
        VolunteerId INT NOT NULL,
        SkillId INT NOT NULL,
        CONSTRAINT PK_VolunteerSkills PRIMARY KEY CLUSTERED (VolunteerId ASC, SkillId ASC),
        CONSTRAINT FK_VolunteerSkills_Users FOREIGN KEY (VolunteerId) REFERENCES dbo.Users (UserId),
        CONSTRAINT FK_VolunteerSkills_Skills FOREIGN KEY (SkillId) REFERENCES dbo.Skills (SkillId)
    );
END
GO

IF OBJECT_ID(N'dbo.VolunteerCoordinators', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.VolunteerCoordinators (
        CoordinatorId INT NOT NULL,
        VolunteerId INT NOT NULL,
        CONSTRAINT PK_VolunteerCoordinators PRIMARY KEY CLUSTERED (CoordinatorId ASC, VolunteerId ASC),
        CONSTRAINT FK_VolunteerCoordinators_Coordinator FOREIGN KEY (CoordinatorId) REFERENCES dbo.Users (UserId),
        CONSTRAINT FK_VolunteerCoordinators_Volunteer FOREIGN KEY (VolunteerId) REFERENCES dbo.Users (UserId)
    );
END
GO

IF OBJECT_ID(N'dbo.Events', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Events (
        EventId INT IDENTITY(1,1) NOT NULL,
        OrganizationId INT NOT NULL,
        Title NVARCHAR(255) NOT NULL,
        Description NVARCHAR(MAX) NULL,
        Location NVARCHAR(500) NULL,
        MaxVolunteers INT NULL,
        Status NVARCHAR(50) NOT NULL,
        StartDate DATE NULL,
        EndDate DATE NULL,
        CreatedAt DATETIME NULL CONSTRAINT DF_Events_CreatedAt DEFAULT (GETDATE()),
        UpdatedAt DATETIME NULL,
        CoverImageUrl NVARCHAR(500) NULL,
        CONSTRAINT PK_Events PRIMARY KEY CLUSTERED (EventId ASC),
        CONSTRAINT FK_Events_Organizations FOREIGN KEY (OrganizationId) REFERENCES dbo.Organizations (OrganizationId)
    );
END
GO

IF OBJECT_ID(N'dbo.EventCoordinators', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.EventCoordinators (
        EventId INT NOT NULL,
        CoordinatorId INT NOT NULL,
        PromotedFromVolunteer BIT NULL CONSTRAINT DF_EventCoordinators_PromotedFromVolunteer DEFAULT ((1)),
        PromotedAt DATETIME NULL CONSTRAINT DF_EventCoordinators_PromotedAt DEFAULT (GETDATE()),
        PromotedBy INT NULL,
        Status NVARCHAR(20) NULL CONSTRAINT DF_EventCoordinators_Status DEFAULT ('Active'),
        CONSTRAINT PK_EventCoordinators PRIMARY KEY CLUSTERED (EventId ASC, CoordinatorId ASC),
        CONSTRAINT FK_EventCoordinators_Event FOREIGN KEY (EventId) REFERENCES dbo.Events (EventId),
        CONSTRAINT FK_EventCoordinators_Coordinator FOREIGN KEY (CoordinatorId) REFERENCES dbo.Users (UserId),
        CONSTRAINT FK_EventCoordinators_PromotedBy FOREIGN KEY (PromotedBy) REFERENCES dbo.Users (UserId)
    );
END
GO

IF OBJECT_ID(N'dbo.EventRegistrations', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.EventRegistrations (
        RegistrationId INT IDENTITY(1,1) NOT NULL,
        EventId INT NOT NULL,
        VolunteerId INT NOT NULL,
        Status NVARCHAR(50) NOT NULL,
        AppliedAt DATETIME NULL CONSTRAINT DF_EventRegistrations_AppliedAt DEFAULT (GETDATE()),
        ReviewedAt DATETIME NULL,
        ReviewedBy INT NULL,
        ReviewNote NVARCHAR(500) NULL,
        CONSTRAINT PK_EventRegistrations PRIMARY KEY CLUSTERED (RegistrationId ASC),
        CONSTRAINT FK_EventRegistrations_Events FOREIGN KEY (EventId) REFERENCES dbo.Events (EventId),
        CONSTRAINT FK_EventRegistrations_Users FOREIGN KEY (VolunteerId) REFERENCES dbo.Users (UserId),
        CONSTRAINT FK_EventRegistrations_Reviewer FOREIGN KEY (ReviewedBy) REFERENCES dbo.Users (UserId)
    );
END
GO

IF OBJECT_ID(N'dbo.Tasks', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Tasks (
        TaskId INT IDENTITY(1,1) NOT NULL,
        EventId INT NOT NULL,
        CoordinatorId INT NOT NULL,
        VolunteerId INT NOT NULL,
        TaskDescription NVARCHAR(MAX) NOT NULL,
        Status NVARCHAR(50) NOT NULL,
        AssignedAt DATETIME NULL CONSTRAINT DF_Tasks_AssignedAt DEFAULT (GETDATE()),
        CompletedAt DATETIME NULL,
        ConfirmedAt DATETIME NULL,
        Note NVARCHAR(500) NULL,
        CONSTRAINT PK_Tasks PRIMARY KEY CLUSTERED (TaskId ASC),
        CONSTRAINT FK_Tasks_Events FOREIGN KEY (EventId) REFERENCES dbo.Events (EventId),
        CONSTRAINT FK_Tasks_Coordinator FOREIGN KEY (CoordinatorId) REFERENCES dbo.Users (UserId),
        CONSTRAINT FK_Tasks_Volunteer FOREIGN KEY (VolunteerId) REFERENCES dbo.Users (UserId)
    );
END
GO

IF OBJECT_ID(N'dbo.Schedules', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Schedules (
        ScheduleId INT IDENTITY(1,1) NOT NULL,
        TaskId INT NOT NULL,
        WorkDate DATE NOT NULL,
        StartTime TIME(7) NULL,
        EndTime TIME(7) NULL,
        Note NVARCHAR(255) NULL,
        CreatedAt DATETIME NULL CONSTRAINT DF_Schedules_CreatedAt DEFAULT (GETDATE()),
        CONSTRAINT PK_Schedules PRIMARY KEY CLUSTERED (ScheduleId ASC),
        CONSTRAINT FK_Schedules_Tasks FOREIGN KEY (TaskId) REFERENCES dbo.Tasks (TaskId)
    );
END
GO

IF OBJECT_ID(N'dbo.SupportRequests', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.SupportRequests (
        RequestId INT IDENTITY(1,1) NOT NULL,
        CreatedBy INT NOT NULL,
        CategoryId INT NOT NULL,
        Description NVARCHAR(MAX) NOT NULL,
        ProofUrl NVARCHAR(255) NULL,
        Status NVARCHAR(50) NOT NULL,
        ReviewedBy INT NULL,
        ReviewedAt DATETIME NULL,
        RejectReason NVARCHAR(500) NULL,
        CreatedAt DATETIME NULL CONSTRAINT DF_SupportRequests_CreatedAt DEFAULT (GETDATE()),
        Title NVARCHAR(255) NOT NULL CONSTRAINT DF_SupportRequests_Title DEFAULT (''),
        Priority NVARCHAR(50) NOT NULL CONSTRAINT DF_SupportRequests_Priority DEFAULT ('MEDIUM'),
        SupportLocation NVARCHAR(500) NOT NULL CONSTRAINT DF_SupportRequests_SupportLocation DEFAULT (''),
        BeneficiaryName NVARCHAR(255) NOT NULL CONSTRAINT DF_SupportRequests_BeneficiaryName DEFAULT (''),
        AffectedPeople INT NULL,
        EstimatedAmount DECIMAL(18, 2) NULL,
        ContactEmail NVARCHAR(255) NULL,
        ContactPhone NVARCHAR(20) NULL,
        AdminNote NVARCHAR(MAX) NULL,
        UpdatedAt DATETIME NULL,
        IsDeleted BIT NULL CONSTRAINT DF_SupportRequests_IsDeleted DEFAULT ((0)),
        CONSTRAINT PK_SupportRequests PRIMARY KEY CLUSTERED (RequestId ASC),
        CONSTRAINT FK_SupportRequests_Users FOREIGN KEY (CreatedBy) REFERENCES dbo.Users (UserId),
        CONSTRAINT FK_SupportRequests_Categories FOREIGN KEY (CategoryId) REFERENCES dbo.SupportCategories (CategoryId),
        CONSTRAINT FK_SupportRequests_Reviewer FOREIGN KEY (ReviewedBy) REFERENCES dbo.Users (UserId)
    );
END
GO

IF OBJECT_ID(N'dbo.EventComments', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.EventComments (
        CommentId INT IDENTITY(1,1) NOT NULL,
        EventId INT NOT NULL,
        UserId INT NOT NULL,
        Comment NVARCHAR(1000) NULL,
        Rating INT NULL,
        CreatedAt DATETIME NULL CONSTRAINT DF_EventComments_CreatedAt DEFAULT (GETDATE()),
        UpdatedAt DATETIME NULL,
        IsDeleted BIT NULL CONSTRAINT DF_EventComments_IsDeleted DEFAULT ((0)),
        CONSTRAINT PK_EventComments PRIMARY KEY CLUSTERED (CommentId ASC),
        CONSTRAINT FK_EventComments_Events FOREIGN KEY (EventId) REFERENCES dbo.Events (EventId),
        CONSTRAINT FK_EventComments_Users FOREIGN KEY (UserId) REFERENCES dbo.Users (UserId),
        CONSTRAINT CHK_EventComments_Rating CHECK (Rating IS NULL OR (Rating >= 1 AND Rating <= 5))
    );
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_EventComments_EventId'
      AND object_id = OBJECT_ID(N'dbo.EventComments')
)
BEGIN
    CREATE INDEX IX_EventComments_EventId ON dbo.EventComments (EventId);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_EventComments_UserId'
      AND object_id = OBJECT_ID(N'dbo.EventComments')
)
BEGIN
    CREATE INDEX IX_EventComments_UserId ON dbo.EventComments (UserId);
END
GO

IF OBJECT_ID(N'dbo.Notifications', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Notifications (
        NotificationId INT IDENTITY(1,1) NOT NULL,
        UserId INT NOT NULL,
        Content NVARCHAR(MAX) NOT NULL,
        Type NVARCHAR(50) NULL,
        ReferenceId INT NULL,
        IsRead BIT NULL CONSTRAINT DF_Notifications_IsRead DEFAULT ((0)),
        CreatedAt DATETIME NULL CONSTRAINT DF_Notifications_CreatedAt DEFAULT (GETDATE()),
        CONSTRAINT PK_Notifications PRIMARY KEY CLUSTERED (NotificationId ASC),
        CONSTRAINT FK_Notifications_Users FOREIGN KEY (UserId) REFERENCES dbo.Users (UserId)
    );
END
GO

IF OBJECT_ID(N'dbo.ProfileUpdateRequests', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ProfileUpdateRequests (
        RequestId INT IDENTITY(1,1) NOT NULL,
        UserId INT NOT NULL,
        NewFirstName NVARCHAR(100) NULL,
        NewLastName NVARCHAR(100) NULL,
        NewPhone NVARCHAR(20) NULL,
        NewGender NVARCHAR(10) NULL,
        NewDateOfBirth DATE NULL,
        NewProvince NVARCHAR(100) NULL,
        NewAddress NVARCHAR(500) NULL,
        NewSkillIds NVARCHAR(255) NULL,
        Status NVARCHAR(50) NULL CONSTRAINT DF_ProfileUpdateRequests_Status DEFAULT ('Pending'),
        RequestedAt DATETIME NULL CONSTRAINT DF_ProfileUpdateRequests_RequestedAt DEFAULT (GETDATE()),
        ReviewedBy INT NULL,
        ReviewedAt DATETIME NULL,
        ReviewNote NVARCHAR(500) NULL,
        CONSTRAINT PK_ProfileUpdateRequests PRIMARY KEY CLUSTERED (RequestId ASC),
        CONSTRAINT FK_ProfileUpdateRequests_Users FOREIGN KEY (UserId) REFERENCES dbo.Users (UserId),
        CONSTRAINT FK_ProfileUpdateRequests_Reviewer FOREIGN KEY (ReviewedBy) REFERENCES dbo.Users (UserId)
    );
END
GO

IF OBJECT_ID(N'dbo.OrganizationProfileUpdateRequests', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.OrganizationProfileUpdateRequests (
        RequestId INT IDENTITY(1,1) NOT NULL,
        UserId INT NOT NULL,
        OrganizationName NVARCHAR(200) NOT NULL,
        OrganizationType NVARCHAR(50) NULL,
        EstablishedYear INT NULL,
        TaxCode NVARCHAR(50) NULL,
        BusinessLicenseNumber NVARCHAR(100) NULL,
        RepresentativeName NVARCHAR(100) NOT NULL,
        RepresentativePosition NVARCHAR(100) NOT NULL,
        Phone NVARCHAR(20) NOT NULL,
        Address NVARCHAR(500) NOT NULL,
        Website NVARCHAR(255) NULL,
        FacebookPage NVARCHAR(255) NULL,
        Description NVARCHAR(MAX) NOT NULL,
        Status NVARCHAR(50) NULL CONSTRAINT DF_OrganizationProfileUpdateRequests_Status DEFAULT ('Pending'),
        RequestedAt DATETIME NULL CONSTRAINT DF_OrganizationProfileUpdateRequests_RequestedAt DEFAULT (GETDATE()),
        ReviewedBy INT NULL,
        ReviewedAt DATETIME NULL,
        ReviewNote NVARCHAR(500) NULL,
        CONSTRAINT PK_OrganizationProfileUpdateRequests PRIMARY KEY CLUSTERED (RequestId ASC),
        CONSTRAINT FK_OrganizationProfileUpdateRequests_Users FOREIGN KEY (UserId) REFERENCES dbo.Users (UserId),
        CONSTRAINT FK_OrganizationProfileUpdateRequests_Reviewer FOREIGN KEY (ReviewedBy) REFERENCES dbo.Users (UserId)
    );
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_UserRoles_UserId'
      AND object_id = OBJECT_ID(N'dbo.UserRoles')
)
BEGIN
    CREATE INDEX IX_UserRoles_UserId ON dbo.UserRoles (UserId);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_UserProfiles_ApprovalStatus'
      AND object_id = OBJECT_ID(N'dbo.UserProfiles')
)
BEGIN
    CREATE INDEX IX_UserProfiles_ApprovalStatus ON dbo.UserProfiles (ApprovalStatus);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Organizations_CreatedBy'
      AND object_id = OBJECT_ID(N'dbo.Organizations')
)
BEGIN
    CREATE INDEX IX_Organizations_CreatedBy ON dbo.Organizations (CreatedBy);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Events_OrganizationId_Status'
      AND object_id = OBJECT_ID(N'dbo.Events')
)
BEGIN
    CREATE INDEX IX_Events_OrganizationId_Status ON dbo.Events (OrganizationId, Status);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_EventRegistrations_EventId_Status'
      AND object_id = OBJECT_ID(N'dbo.EventRegistrations')
)
BEGIN
    CREATE INDEX IX_EventRegistrations_EventId_Status ON dbo.EventRegistrations (EventId, Status);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_EventRegistrations_VolunteerId_Status'
      AND object_id = OBJECT_ID(N'dbo.EventRegistrations')
)
BEGIN
    CREATE INDEX IX_EventRegistrations_VolunteerId_Status ON dbo.EventRegistrations (VolunteerId, Status);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_EventCoordinators_CoordinatorId_Status'
      AND object_id = OBJECT_ID(N'dbo.EventCoordinators')
)
BEGIN
    CREATE INDEX IX_EventCoordinators_CoordinatorId_Status ON dbo.EventCoordinators (CoordinatorId, Status);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Tasks_EventId'
      AND object_id = OBJECT_ID(N'dbo.Tasks')
)
BEGIN
    CREATE INDEX IX_Tasks_EventId ON dbo.Tasks (EventId);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Tasks_CoordinatorId'
      AND object_id = OBJECT_ID(N'dbo.Tasks')
)
BEGIN
    CREATE INDEX IX_Tasks_CoordinatorId ON dbo.Tasks (CoordinatorId);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_SupportRequests_Status_CreatedAt'
      AND object_id = OBJECT_ID(N'dbo.SupportRequests')
)
BEGIN
    CREATE INDEX IX_SupportRequests_Status_CreatedAt ON dbo.SupportRequests (Status, CreatedAt);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_ProfileUpdateRequests_UserId_Status'
      AND object_id = OBJECT_ID(N'dbo.ProfileUpdateRequests')
)
BEGIN
    CREATE INDEX IX_ProfileUpdateRequests_UserId_Status ON dbo.ProfileUpdateRequests (UserId, Status);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_OrganizationProfileUpdateRequests_UserId_Status'
      AND object_id = OBJECT_ID(N'dbo.OrganizationProfileUpdateRequests')
)
BEGIN
    CREATE INDEX IX_OrganizationProfileUpdateRequests_UserId_Status
        ON dbo.OrganizationProfileUpdateRequests (UserId, Status);
END
GO

PRINT N'IVAN schema is ready. Run ivan_bulk_test_data.sql if you want a large test dataset.';
GO
