USE [IVAN]
GO

IF OBJECT_ID(N'dbo.EventCoordinators', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[EventCoordinators](
        [EventId] [int] NOT NULL,
        [CoordinatorId] [int] NOT NULL,
        [PromotedFromVolunteer] [bit] NULL CONSTRAINT [DF_EventCoordinators_PromotedFromVolunteer] DEFAULT ((1)),
        [PromotedAt] [datetime] NULL CONSTRAINT [DF_EventCoordinators_PromotedAt] DEFAULT (getdate()),
        [PromotedBy] [int] NULL,
        [Status] [nvarchar](20) NULL CONSTRAINT [DF_EventCoordinators_Status] DEFAULT ('Active'),
        CONSTRAINT [PK_EventCoordinators] PRIMARY KEY CLUSTERED ([EventId] ASC, [CoordinatorId] ASC),
        CONSTRAINT [FK_EventCoordinators_Event] FOREIGN KEY([EventId]) REFERENCES [dbo].[Events] ([EventId]),
        CONSTRAINT [FK_EventCoordinators_Coordinator] FOREIGN KEY([CoordinatorId]) REFERENCES [dbo].[Users] ([UserId]),
        CONSTRAINT [FK_EventCoordinators_PromotedBy] FOREIGN KEY([PromotedBy]) REFERENCES [dbo].[Users] ([UserId])
    ) ON [PRIMARY];
END
GO

;WITH CoordinatorSeed AS (
    SELECT
        t.EventId,
        t.CoordinatorId,
        MIN(t.AssignedAt) AS PromotedAt
    FROM dbo.Tasks t
    WHERE t.CoordinatorId IS NOT NULL
    GROUP BY t.EventId, t.CoordinatorId
)
INSERT INTO dbo.EventCoordinators (
    EventId,
    CoordinatorId,
    PromotedFromVolunteer,
    PromotedAt,
    PromotedBy,
    Status
)
SELECT
    seed.EventId,
    seed.CoordinatorId,
    0,
    ISNULL(seed.PromotedAt, GETDATE()),
    NULL,
    N'Active'
FROM CoordinatorSeed seed
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.EventCoordinators ec
    WHERE ec.EventId = seed.EventId
      AND ec.CoordinatorId = seed.CoordinatorId
);
GO
