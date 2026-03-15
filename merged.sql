USE [master]
GO
/****** Object:  Database [IVAN]    Script Date: 3/14/2026 10:56:14 PM ******/
CREATE DATABASE [IVAN]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'IVAN', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\IVAN.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'IVAN_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\IVAN_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [IVAN] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [IVAN].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [IVAN] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [IVAN] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [IVAN] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [IVAN] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [IVAN] SET ARITHABORT OFF 
GO
ALTER DATABASE [IVAN] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [IVAN] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [IVAN] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [IVAN] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [IVAN] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [IVAN] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [IVAN] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [IVAN] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [IVAN] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [IVAN] SET  ENABLE_BROKER 
GO
ALTER DATABASE [IVAN] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [IVAN] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [IVAN] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [IVAN] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [IVAN] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [IVAN] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [IVAN] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [IVAN] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [IVAN] SET  MULTI_USER 
GO
ALTER DATABASE [IVAN] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [IVAN] SET DB_CHAINING OFF 
GO
ALTER DATABASE [IVAN] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [IVAN] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [IVAN] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [IVAN] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [IVAN] SET QUERY_STORE = ON
GO
ALTER DATABASE [IVAN] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [IVAN]
GO
/****** Object:  Table [dbo].[EventComments]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventComments](
	[CommentId] [int] IDENTITY(1,1) NOT NULL,
	[EventId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[Comment] [nvarchar](1000) NULL,
	[Rating] [int] NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
	[IsDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[CommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventCoordinators]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventCoordinators](
	[EventId] [int] NOT NULL,
	[CoordinatorId] [int] NOT NULL,
	[PromotedFromVolunteer] [bit] NULL,
	[PromotedAt] [datetime] NULL,
	[PromotedBy] [int] NULL,
	[Status] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[EventId] ASC,
	[CoordinatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventRegistrations]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventRegistrations](
	[RegistrationId] [int] IDENTITY(1,1) NOT NULL,
	[EventId] [int] NOT NULL,
	[VolunteerId] [int] NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[AppliedAt] [datetime] NULL,
	[ReviewedAt] [datetime] NULL,
	[ReviewedBy] [int] NULL,
	[ReviewNote] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[RegistrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Events]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Events](
	[EventId] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Location] [nvarchar](500) NULL,
	[MaxVolunteers] [int] NULL,
	[Status] [nvarchar](50) NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
	[CoverImageUrl] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Notifications]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notifications](
	[NotificationId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Content] [nvarchar](max) NOT NULL,
	[Type] [nvarchar](50) NULL,
	[ReferenceId] [int] NULL,
	[IsRead] [bit] NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[NotificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Organizations]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organizations](
	[OrganizationId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Phone] [nvarchar](20) NULL,
	[Email] [nvarchar](255) NULL,
	[Address] [nvarchar](500) NULL,
	[Website] [nvarchar](255) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
	[LogoUrl] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[OrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProfileUpdateRequests]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProfileUpdateRequests](
	[RequestId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[NewFirstName] [nvarchar](100) NULL,
	[NewLastName] [nvarchar](100) NULL,
	[NewPhone] [nvarchar](20) NULL,
	[NewGender] [nvarchar](10) NULL,
	[NewDateOfBirth] [date] NULL,
	[NewProvince] [nvarchar](100) NULL,
	[NewAddress] [nvarchar](500) NULL,
	[NewSkillIds] [nvarchar](255) NULL,
	[Status] [nvarchar](50) NULL,
	[RequestedAt] [datetime] NULL,
	[ReviewedBy] [int] NULL,
	[ReviewedAt] [datetime] NULL,
	[ReviewNote] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrganizationProfileUpdateRequests]    Script Date: 3/15/2026 12:00:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	[Status] [nvarchar](50) NULL,
	[RequestedAt] [datetime] NULL,
	[ReviewedBy] [int] NULL,
	[ReviewedAt] [datetime] NULL,
	[ReviewNote] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Schedules]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Schedules](
	[ScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[TaskId] [int] NOT NULL,
	[WorkDate] [date] NOT NULL,
	[StartTime] [time](7) NULL,
	[EndTime] [time](7) NULL,
	[Note] [nvarchar](255) NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Skills]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Skills](
	[SkillId] [int] IDENTITY(1,1) NOT NULL,
	[SkillName] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SkillId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SkillName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SupportCategories]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupportCategories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SupportRequests]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupportRequests](
	[RequestId] [int] IDENTITY(1,1) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[ProofUrl] [nvarchar](255) NULL,
	[Status] [nvarchar](50) NOT NULL,
	[ReviewedBy] [int] NULL,
	[ReviewedAt] [datetime] NULL,
	[RejectReason] [nvarchar](500) NULL,
	[CreatedAt] [datetime] NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Priority] [nvarchar](50) NOT NULL,
	[SupportLocation] [nvarchar](500) NOT NULL,
	[BeneficiaryName] [nvarchar](255) NOT NULL,
	[AffectedPeople] [int] NULL,
	[EstimatedAmount] [decimal](18, 2) NULL,
	[ContactEmail] [nvarchar](255) NULL,
	[ContactPhone] [nvarchar](20) NULL,
	[AdminNote] [nvarchar](max) NULL,
	[UpdatedAt] [datetime] NULL,
	[IsDeleted] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[RequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tasks]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tasks](
	[TaskId] [int] IDENTITY(1,1) NOT NULL,
	[EventId] [int] NOT NULL,
	[CoordinatorId] [int] NOT NULL,
	[VolunteerId] [int] NOT NULL,
	[TaskDescription] [nvarchar](max) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[AssignedAt] [datetime] NULL,
	[CompletedAt] [datetime] NULL,
	[ConfirmedAt] [datetime] NULL,
	[Note] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[TaskId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserProfiles]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserProfiles](
	[UserId] [int] NOT NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[FullName]  AS (([FirstName]+' ')+[LastName]) PERSISTED NOT NULL,
	[Phone] [nvarchar](20) NULL,
	[DateOfBirth] [date] NULL,
	[Gender] [nvarchar](10) NULL,
	[Avatar] [nvarchar](500) NULL,
	[Address] [nvarchar](500) NULL,
	[WardCommune] [nvarchar](100) NULL,
	[District] [nvarchar](100) NULL,
	[Province] [nvarchar](100) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[EmergencyContactName] [nvarchar](200) NULL,
	[EmergencyContactPhone] [nvarchar](20) NULL,
	[CreatedAt] [datetime2](7) NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[OrganizationName] [nvarchar](200) NULL,
	[OrganizationType] [nvarchar](50) NULL,
	[EstablishedYear] [int] NULL,
	[TaxCode] [nvarchar](50) NULL,
	[BusinessLicenseNumber] [nvarchar](100) NULL,
	[RepresentativeName] [nvarchar](100) NULL,
	[RepresentativePosition] [nvarchar](100) NULL,
	[FacebookPage] [nvarchar](255) NULL,
	[ApprovalStatus] [nvarchar](20) NULL,
	[ReviewNote] [nvarchar](max) NULL,
	[ReviewedBy] [int] NULL,
	[ReviewedAt] [datetime] NULL,
	[Website] [nvarchar](255) NULL,
	[Description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRoles]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoles](
	[UserRoleId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[Role] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[PasswordHash] [nvarchar](255) NOT NULL,
	[IsActive] [bit] NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VolunteerCoordinators]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VolunteerCoordinators](
	[CoordinatorId] [int] NOT NULL,
	[VolunteerId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CoordinatorId] ASC,
	[VolunteerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VolunteerSkills]    Script Date: 3/14/2026 10:56:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VolunteerSkills](
	[VolunteerId] [int] NOT NULL,
	[SkillId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[VolunteerId] ASC,
	[SkillId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EventComments] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[EventComments] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[EventCoordinators] ADD  DEFAULT ((1)) FOR [PromotedFromVolunteer]
GO
ALTER TABLE [dbo].[EventCoordinators] ADD  DEFAULT (getdate()) FOR [PromotedAt]
GO
ALTER TABLE [dbo].[EventCoordinators] ADD  DEFAULT ('Active') FOR [Status]
GO
ALTER TABLE [dbo].[EventRegistrations] ADD  DEFAULT (getdate()) FOR [AppliedAt]
GO
ALTER TABLE [dbo].[Events] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Notifications] ADD  DEFAULT ((0)) FOR [IsRead]
GO
ALTER TABLE [dbo].[Notifications] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Organizations] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[OrganizationProfileUpdateRequests] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[OrganizationProfileUpdateRequests] ADD  DEFAULT (getdate()) FOR [RequestedAt]
GO
ALTER TABLE [dbo].[ProfileUpdateRequests] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[ProfileUpdateRequests] ADD  DEFAULT (getdate()) FOR [RequestedAt]
GO
ALTER TABLE [dbo].[Schedules] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[SupportRequests] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[SupportRequests] ADD  DEFAULT ('') FOR [Title]
GO
ALTER TABLE [dbo].[SupportRequests] ADD  DEFAULT ('MEDIUM') FOR [Priority]
GO
ALTER TABLE [dbo].[SupportRequests] ADD  DEFAULT ('') FOR [SupportLocation]
GO
ALTER TABLE [dbo].[SupportRequests] ADD  DEFAULT ('') FOR [BeneficiaryName]
GO
ALTER TABLE [dbo].[SupportRequests] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Tasks] ADD  DEFAULT (getdate()) FOR [AssignedAt]
GO
ALTER TABLE [dbo].[UserProfiles] ADD  DEFAULT (sysdatetime()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[UserProfiles] ADD  DEFAULT ('Approved') FOR [ApprovalStatus]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[EventComments]  WITH CHECK ADD  CONSTRAINT [FK_EventComments_Events] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[EventComments] CHECK CONSTRAINT [FK_EventComments_Events]
GO
ALTER TABLE [dbo].[EventComments]  WITH CHECK ADD  CONSTRAINT [FK_EventComments_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[EventComments] CHECK CONSTRAINT [FK_EventComments_Users]
GO
ALTER TABLE [dbo].[EventCoordinators]  WITH CHECK ADD  CONSTRAINT [FK_EventCoordinators_Event] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[EventCoordinators] CHECK CONSTRAINT [FK_EventCoordinators_Event]
GO
ALTER TABLE [dbo].[EventCoordinators]  WITH CHECK ADD  CONSTRAINT [FK_EventCoordinators_Coordinator] FOREIGN KEY([CoordinatorId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[EventCoordinators] CHECK CONSTRAINT [FK_EventCoordinators_Coordinator]
GO
ALTER TABLE [dbo].[EventCoordinators]  WITH CHECK ADD  CONSTRAINT [FK_EventCoordinators_PromotedBy] FOREIGN KEY([PromotedBy])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[EventCoordinators] CHECK CONSTRAINT [FK_EventCoordinators_PromotedBy]
GO
ALTER TABLE [dbo].[EventRegistrations]  WITH CHECK ADD  CONSTRAINT [FK_EventRegistrations_Events] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[EventRegistrations] CHECK CONSTRAINT [FK_EventRegistrations_Events]
GO
ALTER TABLE [dbo].[EventRegistrations]  WITH CHECK ADD  CONSTRAINT [FK_EventRegistrations_Reviewer] FOREIGN KEY([ReviewedBy])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[EventRegistrations] CHECK CONSTRAINT [FK_EventRegistrations_Reviewer]
GO
ALTER TABLE [dbo].[EventRegistrations]  WITH CHECK ADD  CONSTRAINT [FK_EventRegistrations_Users] FOREIGN KEY([VolunteerId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[EventRegistrations] CHECK CONSTRAINT [FK_EventRegistrations_Users]
GO
ALTER TABLE [dbo].[Events]  WITH CHECK ADD  CONSTRAINT [FK_Events_Organizations] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organizations] ([OrganizationId])
GO
ALTER TABLE [dbo].[Events] CHECK CONSTRAINT [FK_Events_Organizations]
GO
ALTER TABLE [dbo].[Notifications]  WITH CHECK ADD  CONSTRAINT [FK_Notifications_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Notifications] CHECK CONSTRAINT [FK_Notifications_Users]
GO
ALTER TABLE [dbo].[Organizations]  WITH CHECK ADD  CONSTRAINT [FK_Organizations_Users] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Organizations] CHECK CONSTRAINT [FK_Organizations_Users]
GO
ALTER TABLE [dbo].[OrganizationProfileUpdateRequests]  WITH CHECK ADD  CONSTRAINT [FK_OrgProfileUpdateReq_Reviewer] FOREIGN KEY([ReviewedBy])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[OrganizationProfileUpdateRequests] CHECK CONSTRAINT [FK_OrgProfileUpdateReq_Reviewer]
GO
ALTER TABLE [dbo].[OrganizationProfileUpdateRequests]  WITH CHECK ADD  CONSTRAINT [FK_OrgProfileUpdateReq_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[OrganizationProfileUpdateRequests] CHECK CONSTRAINT [FK_OrgProfileUpdateReq_Users]
GO
ALTER TABLE [dbo].[ProfileUpdateRequests]  WITH CHECK ADD  CONSTRAINT [FK_ProfileUpdateReq_Reviewer] FOREIGN KEY([ReviewedBy])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[ProfileUpdateRequests] CHECK CONSTRAINT [FK_ProfileUpdateReq_Reviewer]
GO
ALTER TABLE [dbo].[ProfileUpdateRequests]  WITH CHECK ADD  CONSTRAINT [FK_ProfileUpdateReq_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[ProfileUpdateRequests] CHECK CONSTRAINT [FK_ProfileUpdateReq_Users]
GO
ALTER TABLE [dbo].[Schedules]  WITH CHECK ADD  CONSTRAINT [FK_Schedules_Tasks] FOREIGN KEY([TaskId])
REFERENCES [dbo].[Tasks] ([TaskId])
GO
ALTER TABLE [dbo].[Schedules] CHECK CONSTRAINT [FK_Schedules_Tasks]
GO
ALTER TABLE [dbo].[SupportRequests]  WITH CHECK ADD  CONSTRAINT [FK_SupportRequests_Categories] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[SupportCategories] ([CategoryId])
GO
ALTER TABLE [dbo].[SupportRequests] CHECK CONSTRAINT [FK_SupportRequests_Categories]
GO
ALTER TABLE [dbo].[SupportRequests]  WITH CHECK ADD  CONSTRAINT [FK_SupportRequests_Reviewer] FOREIGN KEY([ReviewedBy])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[SupportRequests] CHECK CONSTRAINT [FK_SupportRequests_Reviewer]
GO
ALTER TABLE [dbo].[SupportRequests]  WITH CHECK ADD  CONSTRAINT [FK_SupportRequests_Users] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[SupportRequests] CHECK CONSTRAINT [FK_SupportRequests_Users]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_Coordinator] FOREIGN KEY([CoordinatorId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_Coordinator]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_Events] FOREIGN KEY([EventId])
REFERENCES [dbo].[Events] ([EventId])
GO
ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_Events]
GO
ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_Volunteer] FOREIGN KEY([VolunteerId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_Volunteer]
GO
ALTER TABLE [dbo].[UserProfiles]  WITH CHECK ADD  CONSTRAINT [FK_UserProfiles_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[UserProfiles] CHECK CONSTRAINT [FK_UserProfiles_Users]
GO
ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_Users]
GO
ALTER TABLE [dbo].[VolunteerCoordinators]  WITH CHECK ADD  CONSTRAINT [FK_VC_Coordinator] FOREIGN KEY([CoordinatorId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[VolunteerCoordinators] CHECK CONSTRAINT [FK_VC_Coordinator]
GO
ALTER TABLE [dbo].[VolunteerCoordinators]  WITH CHECK ADD  CONSTRAINT [FK_VC_Volunteer] FOREIGN KEY([VolunteerId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[VolunteerCoordinators] CHECK CONSTRAINT [FK_VC_Volunteer]
GO
ALTER TABLE [dbo].[VolunteerSkills]  WITH CHECK ADD  CONSTRAINT [FK_VolunteerSkills_Skills] FOREIGN KEY([SkillId])
REFERENCES [dbo].[Skills] ([SkillId])
GO
ALTER TABLE [dbo].[VolunteerSkills] CHECK CONSTRAINT [FK_VolunteerSkills_Skills]
GO
ALTER TABLE [dbo].[VolunteerSkills]  WITH CHECK ADD  CONSTRAINT [FK_VolunteerSkills_Users] FOREIGN KEY([VolunteerId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[VolunteerSkills] CHECK CONSTRAINT [FK_VolunteerSkills_Users]
GO
ALTER TABLE [dbo].[EventComments]  WITH CHECK ADD  CONSTRAINT [CHK_Rating] CHECK  (([Rating]>=(1) AND [Rating]<=(5)))
GO
ALTER TABLE [dbo].[EventComments] CHECK CONSTRAINT [CHK_Rating]
GO
CREATE INDEX [IX_EventComments_EventId] ON [dbo].[EventComments] ([EventId])
GO
CREATE INDEX [IX_EventComments_UserId] ON [dbo].[EventComments] ([UserId])
GO
USE [master]
GO
ALTER DATABASE [IVAN] SET  READ_WRITE 
GO

