USE [master]
GO

SET NOCOUNT ON
GO

IF DB_ID(N'IVAN') IS NULL
BEGIN
    RAISERROR(N'Database IVAN does not exist. Run ivan_schema_standard.sql first.', 16, 1);
    RETURN;
END
GO

USE [IVAN]
GO

SET NOCOUNT ON;

IF EXISTS (SELECT 1 FROM dbo.Users WHERE Email = N'bulk.admin001@ivan.test')
BEGIN
    PRINT N'Bulk test data already exists. Skipping ivan_bulk_test_data.sql.';
    RETURN;
END;

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO dbo.Skills (SkillName)
    SELECT src.SkillName
    FROM (VALUES
        (N'First Aid'),
        (N'Logistics'),
        (N'Fundraising'),
        (N'Photography'),
        (N'Teaching'),
        (N'Event Planning'),
        (N'Data Entry'),
        (N'Community Outreach'),
        (N'Child Care'),
        (N'Translation'),
        (N'Social Media'),
        (N'Counseling')
    ) AS src(SkillName)
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.Skills s
        WHERE s.SkillName = src.SkillName
    );

    INSERT INTO dbo.SupportCategories (Name)
    SELECT src.Name
    FROM (VALUES
        (N'Food and Essentials'),
        (N'Medical Support'),
        (N'Education'),
        (N'Disaster Relief'),
        (N'Shelter Assistance'),
        (N'Mental Health'),
        (N'Child Support'),
        (N'Transportation')
    ) AS src(Name)
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.SupportCategories c
        WHERE c.Name = src.Name
    );

    DROP TABLE IF EXISTS #Nums;
    ;WITH NumberSeed AS (
        SELECT TOP (500)
               ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
        FROM sys.all_objects a
        CROSS JOIN sys.all_objects b
    )
    SELECT n
    INTO #Nums
    FROM NumberSeed;

    DECLARE @AdminReviewerId INT;
    DECLARE @CoordinatorCount INT;
    DECLARE @SkillCount INT;
    DECLARE @CategoryCount INT;
    DECLARE @ActiveVolunteerCount INT;
    DECLARE @ActiveRequesterCount INT;

    INSERT INTO dbo.Users (Email, PasswordHash, IsActive, CreatedAt)
    SELECT
        CONCAT(N'bulk.admin', RIGHT(CONCAT(N'000', CAST(n AS VARCHAR(3))), 3), N'@ivan.test'),
        CONCAT(N'hash_bulk_admin_', RIGHT(CONCAT(N'000', CAST(n AS VARCHAR(3))), 3)),
        1,
        DATEADD(MINUTE, n, CAST('2026-01-01T08:00:00' AS DATETIME))
    FROM #Nums
    WHERE n <= 2;

    INSERT INTO dbo.Users (Email, PasswordHash, IsActive, CreatedAt)
    SELECT
        CONCAT(N'bulk.coordinator', RIGHT(CONCAT(N'000', CAST(n AS VARCHAR(3))), 3), N'@ivan.test'),
        CONCAT(N'hash_bulk_coordinator_', RIGHT(CONCAT(N'000', CAST(n AS VARCHAR(3))), 3)),
        1,
        DATEADD(MINUTE, n * 3, CAST('2026-01-02T08:00:00' AS DATETIME))
    FROM #Nums
    WHERE n <= 12;

    INSERT INTO dbo.Users (Email, PasswordHash, IsActive, CreatedAt)
    SELECT
        CONCAT(N'bulk.org', RIGHT(CONCAT(N'000', CAST(n AS VARCHAR(3))), 3), N'@ivan.test'),
        CONCAT(N'hash_bulk_org_', RIGHT(CONCAT(N'000', CAST(n AS VARCHAR(3))), 3)),
        CASE WHEN n <= 9 THEN 1 ELSE 0 END,
        DATEADD(MINUTE, n * 5, CAST('2026-01-03T09:00:00' AS DATETIME))
    FROM #Nums
    WHERE n <= 12;

    INSERT INTO dbo.Users (Email, PasswordHash, IsActive, CreatedAt)
    SELECT
        CONCAT(N'bulk.volunteer', RIGHT(CONCAT(N'000', CAST(n AS VARCHAR(3))), 3), N'@ivan.test'),
        CONCAT(N'hash_bulk_volunteer_', RIGHT(CONCAT(N'000', CAST(n AS VARCHAR(3))), 3)),
        CASE WHEN n <= 125 THEN 1 ELSE 0 END,
        DATEADD(MINUTE, n * 2, CAST('2026-01-04T07:30:00' AS DATETIME))
    FROM #Nums
    WHERE n <= 140;

    INSERT INTO dbo.Users (Email, PasswordHash, IsActive, CreatedAt)
    SELECT
        CONCAT(N'bulk.requester', RIGHT(CONCAT(N'000', CAST(n AS VARCHAR(3))), 3), N'@ivan.test'),
        CONCAT(N'hash_bulk_requester_', RIGHT(CONCAT(N'000', CAST(n AS VARCHAR(3))), 3)),
        CASE WHEN n <= 22 THEN 1 ELSE 0 END,
        DATEADD(MINUTE, n * 4, CAST('2026-01-05T10:00:00' AS DATETIME))
    FROM #Nums
    WHERE n <= 25;

    DROP TABLE IF EXISTS #BulkAdmins;
    SELECT
        UserId,
        Email,
        IsActive,
        ROW_NUMBER() OVER (ORDER BY UserId) AS GroupRow
    INTO #BulkAdmins
    FROM dbo.Users
    WHERE Email LIKE N'bulk.admin%@ivan.test';

    DROP TABLE IF EXISTS #BulkCoordinators;
    SELECT
        UserId,
        Email,
        IsActive,
        ROW_NUMBER() OVER (ORDER BY UserId) AS GroupRow
    INTO #BulkCoordinators
    FROM dbo.Users
    WHERE Email LIKE N'bulk.coordinator%@ivan.test';

    DROP TABLE IF EXISTS #BulkOrganizations;
    SELECT
        UserId,
        Email,
        IsActive,
        ROW_NUMBER() OVER (ORDER BY UserId) AS GroupRow
    INTO #BulkOrganizations
    FROM dbo.Users
    WHERE Email LIKE N'bulk.org%@ivan.test';

    DROP TABLE IF EXISTS #BulkVolunteers;
    SELECT
        UserId,
        Email,
        IsActive,
        ROW_NUMBER() OVER (ORDER BY UserId) AS GroupRow
    INTO #BulkVolunteers
    FROM dbo.Users
    WHERE Email LIKE N'bulk.volunteer%@ivan.test';

    DROP TABLE IF EXISTS #BulkSupportRequesters;
    SELECT
        UserId,
        Email,
        IsActive,
        ROW_NUMBER() OVER (ORDER BY UserId) AS GroupRow
    INTO #BulkSupportRequesters
    FROM dbo.Users
    WHERE Email LIKE N'bulk.requester%@ivan.test';

    SELECT @AdminReviewerId = MIN(UserId) FROM #BulkAdmins;
    SELECT @CoordinatorCount = COUNT(*) FROM #BulkCoordinators;

    INSERT INTO dbo.UserRoles (UserId, Role)
    SELECT a.UserId, N'Admin'
    FROM #BulkAdmins a
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.UserRoles ur
        WHERE ur.UserId = a.UserId
          AND ur.Role = N'Admin'
    );

    INSERT INTO dbo.UserRoles (UserId, Role)
    SELECT c.UserId, N'Coordinator'
    FROM #BulkCoordinators c
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.UserRoles ur
        WHERE ur.UserId = c.UserId
          AND ur.Role = N'Coordinator'
    );

    INSERT INTO dbo.UserRoles (UserId, Role)
    SELECT o.UserId, N'Organization'
    FROM #BulkOrganizations o
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.UserRoles ur
        WHERE ur.UserId = o.UserId
          AND ur.Role = N'Organization'
    );

    INSERT INTO dbo.UserRoles (UserId, Role)
    SELECT v.UserId, N'Volunteer'
    FROM #BulkVolunteers v
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.UserRoles ur
        WHERE ur.UserId = v.UserId
          AND ur.Role = N'Volunteer'
    );

    INSERT INTO dbo.UserRoles (UserId, Role)
    SELECT r.UserId, N'SupportRequester'
    FROM #BulkSupportRequesters r
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.UserRoles ur
        WHERE ur.UserId = r.UserId
          AND ur.Role = N'SupportRequester'
    );

    INSERT INTO dbo.UserProfiles (
        UserId,
        FirstName,
        LastName,
        Phone,
        DateOfBirth,
        Gender,
        Avatar,
        Address,
        WardCommune,
        District,
        Province,
        PostalCode,
        EmergencyContactName,
        EmergencyContactPhone,
        CreatedAt,
        UpdatedAt,
        ApprovalStatus,
        Description
    )
    SELECT
        a.UserId,
        N'Admin',
        CONCAT(N'Bulk', RIGHT(CONCAT(N'000', CAST(a.GroupRow AS VARCHAR(3))), 3)),
        CONCAT(N'0901', RIGHT(CONCAT(N'000000', CAST(a.GroupRow AS VARCHAR(6))), 6)),
        DATEADD(YEAR, -(34 + a.GroupRow), CAST('2026-01-01' AS DATE)),
        CASE WHEN a.GroupRow % 2 = 0 THEN N'Female' ELSE N'Male' END,
        CONCAT(N'https://images.ivan.test/avatar/admin-', RIGHT(CONCAT(N'000', CAST(a.GroupRow AS VARCHAR(3))), 3), N'.png'),
        CONCAT(CAST(10 + a.GroupRow AS VARCHAR(10)), N' Admin Street'),
        N'Ward 1',
        N'District 1',
        N'Ho Chi Minh City',
        N'700000',
        CONCAT(N'Admin Backup ', RIGHT(CONCAT(N'000', CAST(a.GroupRow AS VARCHAR(3))), 3)),
        CONCAT(N'0911', RIGHT(CONCAT(N'000000', CAST(a.GroupRow AS VARCHAR(6))), 6)),
        DATEADD(DAY, a.GroupRow, CAST('2026-01-01T08:00:00' AS DATETIME2)),
        DATEADD(DAY, a.GroupRow + 14, CAST('2026-01-01T08:00:00' AS DATETIME2)),
        N'Approved',
        N'Bulk administrator account for dashboard and permission testing.'
    FROM #BulkAdmins a
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.UserProfiles up
        WHERE up.UserId = a.UserId
    );

    INSERT INTO dbo.UserProfiles (
        UserId,
        FirstName,
        LastName,
        Phone,
        DateOfBirth,
        Gender,
        Avatar,
        Address,
        WardCommune,
        District,
        Province,
        PostalCode,
        EmergencyContactName,
        EmergencyContactPhone,
        CreatedAt,
        UpdatedAt,
        ApprovalStatus,
        Description
    )
    SELECT
        c.UserId,
        N'Coordinator',
        RIGHT(CONCAT(N'000', CAST(c.GroupRow AS VARCHAR(3))), 3),
        CONCAT(N'0902', RIGHT(CONCAT(N'000000', CAST(c.GroupRow AS VARCHAR(6))), 6)),
        DATEADD(YEAR, -(24 + (c.GroupRow % 10)), CAST('2026-01-01' AS DATE)),
        CASE WHEN c.GroupRow % 2 = 0 THEN N'Female' ELSE N'Male' END,
        CONCAT(N'https://images.ivan.test/avatar/coordinator-', RIGHT(CONCAT(N'000', CAST(c.GroupRow AS VARCHAR(3))), 3), N'.png'),
        CONCAT(CAST(100 + c.GroupRow AS VARCHAR(10)), N' Coordination Avenue'),
        CONCAT(N'Ward ', CAST(((c.GroupRow - 1) % 8) + 1 AS VARCHAR(10))),
        CONCAT(N'District ', CAST(((c.GroupRow - 1) % 5) + 1 AS VARCHAR(10))),
        CASE ((c.GroupRow - 1) % 4)
            WHEN 0 THEN N'Ho Chi Minh City'
            WHEN 1 THEN N'Ha Noi'
            WHEN 2 THEN N'Da Nang'
            ELSE N'Can Tho'
        END,
        N'700000',
        CONCAT(N'Coordinator Contact ', RIGHT(CONCAT(N'000', CAST(c.GroupRow AS VARCHAR(3))), 3)),
        CONCAT(N'0912', RIGHT(CONCAT(N'000000', CAST(c.GroupRow AS VARCHAR(6))), 6)),
        DATEADD(DAY, c.GroupRow, CAST('2026-01-02T08:00:00' AS DATETIME2)),
        DATEADD(DAY, c.GroupRow + 7, CAST('2026-01-02T08:00:00' AS DATETIME2)),
        N'Approved',
        N'Bulk coordinator profile for event operations and team management testing.'
    FROM #BulkCoordinators c
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.UserProfiles up
        WHERE up.UserId = c.UserId
    );

    INSERT INTO dbo.UserProfiles (
        UserId,
        FirstName,
        LastName,
        Phone,
        DateOfBirth,
        Gender,
        Avatar,
        Address,
        WardCommune,
        District,
        Province,
        PostalCode,
        EmergencyContactName,
        EmergencyContactPhone,
        CreatedAt,
        UpdatedAt,
        ApprovalStatus,
        Description
    )
    SELECT
        v.UserId,
        N'Volunteer',
        RIGHT(CONCAT(N'000', CAST(v.GroupRow AS VARCHAR(3))), 3),
        CONCAT(N'0903', RIGHT(CONCAT(N'000000', CAST(v.GroupRow AS VARCHAR(6))), 6)),
        DATEADD(YEAR, -(19 + (v.GroupRow % 12)), CAST('2026-01-01' AS DATE)),
        CASE WHEN v.GroupRow % 2 = 0 THEN N'Female' ELSE N'Male' END,
        CONCAT(N'https://images.ivan.test/avatar/volunteer-', RIGHT(CONCAT(N'000', CAST(v.GroupRow AS VARCHAR(3))), 3), N'.png'),
        CONCAT(CAST(200 + v.GroupRow AS VARCHAR(10)), N' Volunteer Street'),
        CONCAT(N'Ward ', CAST(((v.GroupRow - 1) % 12) + 1 AS VARCHAR(10))),
        CONCAT(N'District ', CAST(((v.GroupRow - 1) % 8) + 1 AS VARCHAR(10))),
        CASE ((v.GroupRow - 1) % 4)
            WHEN 0 THEN N'Ho Chi Minh City'
            WHEN 1 THEN N'Ha Noi'
            WHEN 2 THEN N'Da Nang'
            ELSE N'Can Tho'
        END,
        N'700000',
        CONCAT(N'Volunteer EC ', RIGHT(CONCAT(N'000', CAST(v.GroupRow AS VARCHAR(3))), 3)),
        CONCAT(N'0913', RIGHT(CONCAT(N'000000', CAST(v.GroupRow AS VARCHAR(6))), 6)),
        DATEADD(DAY, v.GroupRow, CAST('2026-01-04T07:30:00' AS DATETIME2)),
        DATEADD(DAY, v.GroupRow + 5, CAST('2026-01-04T07:30:00' AS DATETIME2)),
        N'Approved',
        N'Bulk volunteer profile for search, assignment, registration, and schedule testing.'
    FROM #BulkVolunteers v
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.UserProfiles up
        WHERE up.UserId = v.UserId
    );

    INSERT INTO dbo.UserProfiles (
        UserId,
        FirstName,
        LastName,
        Phone,
        DateOfBirth,
        Gender,
        Avatar,
        Address,
        WardCommune,
        District,
        Province,
        PostalCode,
        EmergencyContactName,
        EmergencyContactPhone,
        CreatedAt,
        UpdatedAt,
        ApprovalStatus,
        Description
    )
    SELECT
        r.UserId,
        N'Requester',
        RIGHT(CONCAT(N'000', CAST(r.GroupRow AS VARCHAR(3))), 3),
        CONCAT(N'0904', RIGHT(CONCAT(N'000000', CAST(r.GroupRow AS VARCHAR(6))), 6)),
        DATEADD(YEAR, -(23 + (r.GroupRow % 15)), CAST('2026-01-01' AS DATE)),
        CASE WHEN r.GroupRow % 2 = 0 THEN N'Female' ELSE N'Male' END,
        CONCAT(N'https://images.ivan.test/avatar/requester-', RIGHT(CONCAT(N'000', CAST(r.GroupRow AS VARCHAR(3))), 3), N'.png'),
        CONCAT(CAST(400 + r.GroupRow AS VARCHAR(10)), N' Support Avenue'),
        CONCAT(N'Ward ', CAST(((r.GroupRow - 1) % 12) + 1 AS VARCHAR(10))),
        CONCAT(N'District ', CAST(((r.GroupRow - 1) % 8) + 1 AS VARCHAR(10))),
        CASE ((r.GroupRow - 1) % 4)
            WHEN 0 THEN N'Ho Chi Minh City'
            WHEN 1 THEN N'Binh Duong'
            WHEN 2 THEN N'Dong Nai'
            ELSE N'Long An'
        END,
        N'700000',
        CONCAT(N'Requester EC ', RIGHT(CONCAT(N'000', CAST(r.GroupRow AS VARCHAR(3))), 3)),
        CONCAT(N'0914', RIGHT(CONCAT(N'000000', CAST(r.GroupRow AS VARCHAR(6))), 6)),
        DATEADD(DAY, r.GroupRow, CAST('2026-01-05T10:00:00' AS DATETIME2)),
        DATEADD(DAY, r.GroupRow + 3, CAST('2026-01-05T10:00:00' AS DATETIME2)),
        N'Approved',
        N'Bulk support requester profile for support request and admin review testing.'
    FROM #BulkSupportRequesters r
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.UserProfiles up
        WHERE up.UserId = r.UserId
    );

    INSERT INTO dbo.UserProfiles (
        UserId,
        FirstName,
        LastName,
        Phone,
        Gender,
        Address,
        Province,
        CreatedAt,
        UpdatedAt,
        OrganizationName,
        OrganizationType,
        EstablishedYear,
        TaxCode,
        BusinessLicenseNumber,
        RepresentativeName,
        RepresentativePosition,
        FacebookPage,
        ApprovalStatus,
        ReviewNote,
        ReviewedBy,
        ReviewedAt,
        Website,
        Description
    )
    SELECT
        o.UserId,
        N'Representative',
        RIGHT(CONCAT(N'000', CAST(o.GroupRow AS VARCHAR(3))), 3),
        CONCAT(N'02873', RIGHT(CONCAT(N'00000', CAST(o.GroupRow AS VARCHAR(5))), 5)),
        N'Other',
        CONCAT(CAST(500 + o.GroupRow AS VARCHAR(10)), N' Organization Avenue'),
        CASE ((o.GroupRow - 1) % 3)
            WHEN 0 THEN N'Ho Chi Minh City'
            WHEN 1 THEN N'Ha Noi'
            ELSE N'Da Nang'
        END,
        DATEADD(DAY, o.GroupRow, CAST('2026-01-03T09:00:00' AS DATETIME2)),
        DATEADD(DAY, o.GroupRow + 6, CAST('2026-01-03T09:00:00' AS DATETIME2)),
        CONCAT(N'Bulk Organization ', RIGHT(CONCAT(N'000', CAST(o.GroupRow AS VARCHAR(3))), 3)),
        CASE ((o.GroupRow - 1) % 3)
            WHEN 0 THEN N'Nonprofit'
            WHEN 1 THEN N'Foundation'
            ELSE N'Community Group'
        END,
        2010 + o.GroupRow,
        CONCAT(N'TAX-BULK-', RIGHT(CONCAT(N'000', CAST(o.GroupRow AS VARCHAR(3))), 3)),
        CONCAT(N'BL-BULK-', RIGHT(CONCAT(N'000', CAST(o.GroupRow AS VARCHAR(3))), 3)),
        CONCAT(N'Bulk Representative ', RIGHT(CONCAT(N'000', CAST(o.GroupRow AS VARCHAR(3))), 3)),
        CASE WHEN o.GroupRow % 2 = 0 THEN N'Operations Director' ELSE N'Program Lead' END,
        CONCAT(N'https://facebook.com/bulkorg', RIGHT(CONCAT(N'000', CAST(o.GroupRow AS VARCHAR(3))), 3)),
        CASE
            WHEN o.GroupRow <= 9 THEN N'Approved'
            WHEN o.GroupRow <= 11 THEN N'Pending'
            ELSE N'Rejected'
        END,
        CASE
            WHEN o.GroupRow <= 9 THEN N'Bulk organization registration approved.'
            WHEN o.GroupRow <= 11 THEN N'Bulk organization registration is waiting for admin review.'
            ELSE N'Bulk organization registration rejected for policy testing.'
        END,
        CASE
            WHEN o.GroupRow <= 9 THEN @AdminReviewerId
            WHEN o.GroupRow <= 11 THEN NULL
            ELSE @AdminReviewerId
        END,
        CASE
            WHEN o.GroupRow <= 9 THEN DATEADD(DAY, o.GroupRow + 10, CAST('2026-01-03T09:00:00' AS DATETIME))
            WHEN o.GroupRow <= 11 THEN NULL
            ELSE DATEADD(DAY, o.GroupRow + 12, CAST('2026-01-03T09:00:00' AS DATETIME))
        END,
        CONCAT(N'https://bulkorg', RIGHT(CONCAT(N'000', CAST(o.GroupRow AS VARCHAR(3))), 3), N'.ivan.test'),
        N'Bulk organization profile used to test approval, profile review, and event ownership flows.'
    FROM #BulkOrganizations o
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.UserProfiles up
        WHERE up.UserId = o.UserId
    );

    DROP TABLE IF EXISTS #SkillMap;
    SELECT
        SkillId,
        SkillName,
        ROW_NUMBER() OVER (ORDER BY SkillName, SkillId) AS GroupRow
    INTO #SkillMap
    FROM dbo.Skills;

    DROP TABLE IF EXISTS #CategoryMap;
    SELECT
        CategoryId,
        Name,
        ROW_NUMBER() OVER (ORDER BY Name, CategoryId) AS GroupRow
    INTO #CategoryMap
    FROM dbo.SupportCategories;

    SELECT @SkillCount = COUNT(*) FROM #SkillMap;
    SELECT @CategoryCount = COUNT(*) FROM #CategoryMap;

    INSERT INTO dbo.VolunteerSkills (VolunteerId, SkillId)
    SELECT DISTINCT
        v.UserId,
        s.SkillId
    FROM #BulkVolunteers v
    CROSS APPLY (
        VALUES
            (((v.GroupRow - 1) % @SkillCount) + 1),
            (((v.GroupRow + 2) % @SkillCount) + 1),
            (((v.GroupRow + 5) % @SkillCount) + 1)
    ) AS pick(SkillRow)
    JOIN #SkillMap s
      ON s.GroupRow = pick.SkillRow;

    INSERT INTO dbo.VolunteerCoordinators (CoordinatorId, VolunteerId)
    SELECT
        c.UserId,
        v.UserId
    FROM #BulkVolunteers v
    JOIN #BulkCoordinators c
      ON c.GroupRow = ((v.GroupRow - 1) % @CoordinatorCount) + 1;

    INSERT INTO dbo.VolunteerCoordinators (CoordinatorId, VolunteerId)
    SELECT
        c.UserId,
        v.UserId
    FROM #BulkVolunteers v
    JOIN #BulkCoordinators c
      ON c.GroupRow = ((v.GroupRow + 2) % @CoordinatorCount) + 1
    WHERE v.GroupRow % 4 = 0
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.VolunteerCoordinators vc
          WHERE vc.CoordinatorId = c.UserId
            AND vc.VolunteerId = v.UserId
      );

    INSERT INTO dbo.Organizations (
        Name,
        Description,
        Phone,
        Email,
        Address,
        Website,
        CreatedBy,
        CreatedAt,
        UpdatedAt,
        LogoUrl
    )
    SELECT
        up.OrganizationName,
        up.Description,
        up.Phone,
        u.Email,
        up.Address,
        up.Website,
        u.UserId,
        DATEADD(DAY, o.GroupRow, CAST('2026-01-15T09:00:00' AS DATETIME)),
        DATEADD(DAY, o.GroupRow + 7, CAST('2026-01-15T09:00:00' AS DATETIME)),
        CONCAT(N'https://images.ivan.test/logo/bulk-org-', RIGHT(CONCAT(N'000', CAST(o.GroupRow AS VARCHAR(3))), 3), N'.png')
    FROM #BulkOrganizations o
    JOIN dbo.Users u
      ON u.UserId = o.UserId
    JOIN dbo.UserProfiles up
      ON up.UserId = o.UserId
    WHERE o.GroupRow <= 9
      AND NOT EXISTS (
          SELECT 1
          FROM dbo.Organizations org
          WHERE org.CreatedBy = u.UserId
      );

    DROP TABLE IF EXISTS #BulkOrganizationRecords;
    SELECT
        org.OrganizationId,
        org.CreatedBy,
        ROW_NUMBER() OVER (ORDER BY org.OrganizationId) AS GroupRow
    INTO #BulkOrganizationRecords
    FROM dbo.Organizations org
    JOIN #BulkOrganizations o
      ON o.UserId = org.CreatedBy
    WHERE o.GroupRow <= 9;

    DROP TABLE IF EXISTS #BulkEventSeed;
    SELECT
        bor.OrganizationId,
        bor.CreatedBy,
        bor.GroupRow AS OrganizationRow,
        slot.EventSlot,
        ((bor.GroupRow - 1) * 4) + slot.EventSlot AS EventRow
    INTO #BulkEventSeed
    FROM #BulkOrganizationRecords bor
    CROSS JOIN (VALUES (1), (2), (3), (4)) AS slot(EventSlot);

    INSERT INTO dbo.Events (
        OrganizationId,
        Title,
        Description,
        Location,
        MaxVolunteers,
        Status,
        StartDate,
        EndDate,
        CreatedAt,
        UpdatedAt,
        CoverImageUrl
    )
    SELECT
        seed.OrganizationId,
        CASE seed.EventSlot
            WHEN 1 THEN CONCAT(N'Bulk Community Health Day ', RIGHT(CONCAT(N'000', CAST(seed.EventRow AS VARCHAR(3))), 3))
            WHEN 2 THEN CONCAT(N'Bulk Education Outreach ', RIGHT(CONCAT(N'000', CAST(seed.EventRow AS VARCHAR(3))), 3))
            WHEN 3 THEN CONCAT(N'Bulk Relief Packing Drive ', RIGHT(CONCAT(N'000', CAST(seed.EventRow AS VARCHAR(3))), 3))
            ELSE CONCAT(N'Bulk Volunteer Planning Session ', RIGHT(CONCAT(N'000', CAST(seed.EventRow AS VARCHAR(3))), 3))
        END,
        CASE seed.EventSlot
            WHEN 1 THEN N'Bulk health event with check-in, community outreach, and basic medical support.'
            WHEN 2 THEN N'Bulk education event focused on tutoring, school-supply packing, and parent support.'
            WHEN 3 THEN N'Bulk relief packing event for warehouse operations, inventory, and emergency preparation.'
            ELSE N'Bulk planning event used to test pending event management and organization editing flows.'
        END,
        CONCAT(
            N'Community Block ',
            CAST(seed.OrganizationRow AS VARCHAR(10)),
            N' - District ',
            CAST(seed.EventSlot + 1 AS VARCHAR(10))
        ),
        CASE seed.EventSlot
            WHEN 1 THEN 35
            WHEN 2 THEN 50
            WHEN 3 THEN 45
            ELSE 25
        END,
        CASE
            WHEN seed.EventSlot = 1 THEN N'Closed'
            WHEN seed.EventSlot = 4 THEN N'Pending'
            ELSE N'Approved'
        END,
        CASE
            WHEN seed.EventSlot = 1 THEN DATEADD(DAY, seed.OrganizationRow - 1, CAST('2026-01-10' AS DATE))
            ELSE DATEADD(DAY, seed.EventRow * 4, CAST('2026-04-01' AS DATE))
        END,
        CASE seed.EventSlot
            WHEN 1 THEN DATEADD(DAY, 1, DATEADD(DAY, seed.OrganizationRow - 1, CAST('2026-01-10' AS DATE)))
            WHEN 2 THEN DATEADD(DAY, 1, DATEADD(DAY, seed.EventRow * 4, CAST('2026-04-01' AS DATE)))
            WHEN 3 THEN DATEADD(DAY, 2, DATEADD(DAY, seed.EventRow * 4, CAST('2026-04-01' AS DATE)))
            ELSE DATEADD(DAY, seed.EventRow * 4, CAST('2026-04-01' AS DATE))
        END,
        DATEADD(DAY, seed.EventRow, CAST('2026-02-01T09:00:00' AS DATETIME)),
        DATEADD(DAY, seed.EventRow + 6, CAST('2026-02-01T09:00:00' AS DATETIME)),
        CONCAT(N'https://images.ivan.test/events/bulk-event-', RIGHT(CONCAT(N'000', CAST(seed.EventRow AS VARCHAR(3))), 3), N'.jpg')
    FROM #BulkEventSeed seed;

    DROP TABLE IF EXISTS #OperationalBulkEvents;
    SELECT
        e.EventId,
        e.OrganizationId,
        e.Status,
        e.StartDate,
        e.EndDate,
        e.MaxVolunteers,
        ROW_NUMBER() OVER (ORDER BY e.EventId) AS GroupRow
    INTO #OperationalBulkEvents
    FROM dbo.Events e
    JOIN #BulkOrganizationRecords bor
      ON bor.OrganizationId = e.OrganizationId
    WHERE e.Status IN (N'Approved', N'Closed')
      AND e.Title LIKE N'Bulk %';

    DROP TABLE IF EXISTS #ActiveBulkVolunteers;
    SELECT
        UserId,
        Email,
        ROW_NUMBER() OVER (ORDER BY UserId) AS GroupRow
    INTO #ActiveBulkVolunteers
    FROM #BulkVolunteers
    WHERE IsActive = 1;

    DROP TABLE IF EXISTS #ActiveBulkSupportRequesters;
    SELECT
        UserId,
        Email,
        ROW_NUMBER() OVER (ORDER BY UserId) AS GroupRow
    INTO #ActiveBulkSupportRequesters
    FROM #BulkSupportRequesters
    WHERE IsActive = 1;

    SELECT @ActiveVolunteerCount = COUNT(*) FROM #ActiveBulkVolunteers;
    SELECT @ActiveRequesterCount = COUNT(*) FROM #ActiveBulkSupportRequesters;

    INSERT INTO dbo.EventRegistrations (
        EventId,
        VolunteerId,
        RegistrationType,
        Status,
        AppliedAt,
        ApplicationReason,
        RelevantExperience,
        CommitmentLevel,
        AvailabilityNote,
        InvitationMessage,
        InvitedBy,
        ReviewedAt,
        ReviewedBy,
        ReviewNote
    )
    SELECT
        abe.EventId,
        v.UserId,
        CASE
            WHEN abe.Status = N'Closed' THEN N'Application'
            WHEN slot.SlotRow = 12 THEN N'Invitation'
            ELSE N'Application'
        END,
        CASE
            WHEN abe.Status = N'Closed' AND slot.SlotRow <= 8 THEN N'Approved'
            WHEN abe.Status = N'Closed' THEN N'Rejected'
            WHEN slot.SlotRow <= 6 THEN N'Approved'
            WHEN slot.SlotRow <= 9 THEN N'Pending'
            WHEN slot.SlotRow <= 11 THEN N'Rejected'
            ELSE N'Invited'
        END,
        DATEADD(HOUR, slot.SlotRow, DATEADD(DAY, -24, CAST(abe.StartDate AS DATETIME))),
        CASE
            WHEN slot.SlotRow = 12 AND abe.Status <> N'Closed' THEN NULL
            ELSE CONCAT(
                N'I want to join ',
                CASE
                    WHEN abe.Status = N'Closed' THEN N'this completed event follow-up program'
                    ELSE N'this event'
                END,
                N' because I can support operations, follow instructions, and help attendees effectively.'
            )
        END,
        CASE
            WHEN slot.SlotRow = 12 AND abe.Status <> N'Closed' THEN NULL
            ELSE CONCAT(
                N'I have experience with community activities, volunteer coordination, and on-site support for medium to large events. Seed row ',
                CAST(slot.SlotRow AS NVARCHAR(10)),
                N'.'
            )
        END,
        CASE
            WHEN slot.SlotRow IN (1, 2, 3) THEN N'Full event commitment'
            WHEN slot.SlotRow IN (4, 5, 6, 7, 8) THEN N'Most of the event'
            ELSE N'Assigned shifts only'
        END,
        CASE
            WHEN slot.SlotRow = 12 AND abe.Status <> N'Closed' THEN NULL
            ELSE CONCAT(
                N'Available for orientation before the event and for assigned shifts on ',
                CONVERT(NVARCHAR(10), abe.StartDate, 23),
                N'.'
            )
        END,
        CASE
            WHEN slot.SlotRow = 12 AND abe.Status <> N'Closed'
                THEN N'Organization invitation: we think your profile matches this event and would like you to confirm participation.'
            ELSE NULL
        END,
        CASE
            WHEN slot.SlotRow = 12 AND abe.Status <> N'Closed' THEN org.CreatedBy
            ELSE NULL
        END,
        CASE
            WHEN abe.Status = N'Closed' AND slot.SlotRow <= 8 THEN DATEADD(HOUR, 9 + slot.SlotRow, DATEADD(DAY, -20, CAST(abe.StartDate AS DATETIME)))
            WHEN abe.Status = N'Closed' THEN DATEADD(HOUR, 14 + slot.SlotRow, DATEADD(DAY, -19, CAST(abe.StartDate AS DATETIME)))
            WHEN slot.SlotRow <= 6 THEN DATEADD(HOUR, 9 + slot.SlotRow, DATEADD(DAY, -20, CAST(abe.StartDate AS DATETIME)))
            WHEN slot.SlotRow <= 9 THEN NULL
            WHEN slot.SlotRow <= 11 THEN DATEADD(HOUR, 14 + slot.SlotRow, DATEADD(DAY, -19, CAST(abe.StartDate AS DATETIME)))
            ELSE NULL
        END,
        CASE
            WHEN abe.Status = N'Closed' AND slot.SlotRow <= 8 THEN @AdminReviewerId
            WHEN abe.Status = N'Closed' THEN @AdminReviewerId
            WHEN slot.SlotRow <= 6 THEN @AdminReviewerId
            WHEN slot.SlotRow <= 9 THEN NULL
            WHEN slot.SlotRow <= 11 THEN @AdminReviewerId
            ELSE NULL
        END,
        CASE
            WHEN abe.Status = N'Closed' AND slot.SlotRow <= 8 THEN N'Bulk approval for completed event participation.'
            WHEN abe.Status = N'Closed' THEN N'Bulk rejection for historical review testing.'
            WHEN slot.SlotRow <= 6 THEN N'Bulk approval for active event roster testing.'
            WHEN slot.SlotRow <= 9 THEN NULL
            WHEN slot.SlotRow <= 11 THEN N'Bulk rejection to provide review-history test data.'
            ELSE NULL
        END
    FROM #OperationalBulkEvents abe
    JOIN dbo.Organizations org
      ON org.OrganizationId = abe.OrganizationId
    CROSS JOIN (VALUES
        (1), (2), (3), (4), (5), (6),
        (7), (8), (9), (10), (11), (12)
    ) AS slot(SlotRow)
    JOIN #ActiveBulkVolunteers v
      ON v.GroupRow = (((abe.GroupRow - 1) * 13 + slot.SlotRow - 1) % @ActiveVolunteerCount) + 1;

    DROP TABLE IF EXISTS #ApprovedBulkMembers;
    SELECT
        er.EventId,
        er.VolunteerId,
        er.RegistrationId,
        ROW_NUMBER() OVER (PARTITION BY er.EventId ORDER BY er.RegistrationId) AS MemberRow
    INTO #ApprovedBulkMembers
    FROM dbo.EventRegistrations er
    JOIN #OperationalBulkEvents abe
      ON abe.EventId = er.EventId
    WHERE er.Status = N'Approved';

    DROP TABLE IF EXISTS #PrimaryCoordinatorAssignments;
    SELECT
        abe.EventId,
        abe.GroupRow,
        c.UserId AS CoordinatorId
    INTO #PrimaryCoordinatorAssignments
    FROM #OperationalBulkEvents abe
    JOIN #BulkCoordinators c
      ON c.GroupRow = ((abe.GroupRow - 1) % @CoordinatorCount) + 1;

    INSERT INTO dbo.EventCoordinators (
        EventId,
        CoordinatorId,
        PromotedFromVolunteer,
        PromotedAt,
        PromotedBy,
        Status
    )
    SELECT
        pca.EventId,
        pca.CoordinatorId,
        0,
        DATEADD(DAY, -18, CAST(e.StartDate AS DATETIME)),
        org.CreatedBy,
        N'Active'
    FROM #PrimaryCoordinatorAssignments pca
    JOIN dbo.Events e
      ON e.EventId = pca.EventId
    JOIN dbo.Organizations org
      ON org.OrganizationId = e.OrganizationId;

    INSERT INTO dbo.EventCoordinators (
        EventId,
        CoordinatorId,
        PromotedFromVolunteer,
        PromotedAt,
        PromotedBy,
        Status
    )
    SELECT
        abe.EventId,
        abm.VolunteerId,
        1,
        DATEADD(DAY, -12, CAST(e.StartDate AS DATETIME)),
        org.CreatedBy,
        N'Active'
    FROM #OperationalBulkEvents abe
    JOIN #ApprovedBulkMembers abm
      ON abm.EventId = abe.EventId
     AND abm.MemberRow = 1
    JOIN dbo.Events e
      ON e.EventId = abe.EventId
    JOIN dbo.Organizations org
      ON org.OrganizationId = e.OrganizationId;

    INSERT INTO dbo.Tasks (
        EventId,
        CoordinatorId,
        VolunteerId,
        TaskDescription,
        Status,
        AssignedAt,
        CompletedAt,
        ConfirmedAt,
        Note
    )
    SELECT
        abe.EventId,
        pca.CoordinatorId,
        abm.VolunteerId,
        CONCAT(N'Bulk task ', RIGHT(CONCAT(N'0', CAST(abm.MemberRow AS VARCHAR(2))), 2), N' for ', e.Title),
        CASE abm.MemberRow
            WHEN 1 THEN N'Pending'
            WHEN 2 THEN N'In Progress'
            WHEN 3 THEN N'Completed'
            WHEN 4 THEN N'Pending'
            ELSE N'Completed'
        END,
        DATEADD(DAY, -7, CAST(e.StartDate AS DATETIME)),
        CASE WHEN abm.MemberRow IN (3, 5) THEN DATEADD(DAY, 1, CAST(e.StartDate AS DATETIME)) ELSE NULL END,
        CASE WHEN abm.MemberRow = 5 THEN DATEADD(DAY, 2, CAST(e.StartDate AS DATETIME)) ELSE NULL END,
        CASE abm.MemberRow
            WHEN 1 THEN N'Handle attendee check-in and queue guidance.'
            WHEN 2 THEN N'Support supply desk and logistics updates.'
            WHEN 3 THEN N'Coordinate volunteer attendance tracking.'
            WHEN 4 THEN N'Assist the outreach booth and information desk.'
            ELSE N'Prepare closing summary and handover notes.'
        END
    FROM #OperationalBulkEvents abe
    JOIN #PrimaryCoordinatorAssignments pca
      ON pca.EventId = abe.EventId
    JOIN #ApprovedBulkMembers abm
      ON abm.EventId = abe.EventId
     AND abm.MemberRow <= 5
    JOIN dbo.Events e
      ON e.EventId = abe.EventId;

    INSERT INTO dbo.Schedules (
        TaskId,
        WorkDate,
        StartTime,
        EndTime,
        Note,
        CreatedAt
    )
    SELECT
        t.TaskId,
        CASE
            WHEN DATEDIFF(DAY, e.StartDate, e.EndDate) > 0 AND t.TaskId % 2 = 0 THEN DATEADD(DAY, 1, e.StartDate)
            ELSE e.StartDate
        END,
        CASE t.TaskId % 3
            WHEN 0 THEN CAST('07:30:00' AS TIME)
            WHEN 1 THEN CAST('08:00:00' AS TIME)
            ELSE CAST('13:00:00' AS TIME)
        END,
        CASE t.TaskId % 3
            WHEN 0 THEN CAST('11:30:00' AS TIME)
            WHEN 1 THEN CAST('12:00:00' AS TIME)
            ELSE CAST('17:00:00' AS TIME)
        END,
        CONCAT(N'Bulk schedule for ', e.Title),
        DATEADD(MINUTE, 30, ISNULL(t.AssignedAt, GETDATE()))
    FROM dbo.Tasks t
    JOIN #OperationalBulkEvents abe
      ON abe.EventId = t.EventId
    JOIN dbo.Events e
      ON e.EventId = t.EventId
    WHERE t.TaskDescription LIKE N'Bulk task %';

    INSERT INTO dbo.SupportRequests (
        CreatedBy,
        CategoryId,
        Description,
        ProofUrl,
        Status,
        ReviewedBy,
        ReviewedAt,
        RejectReason,
        CreatedAt,
        Title,
        Priority,
        SupportLocation,
        BeneficiaryName,
        AffectedPeople,
        EstimatedAmount,
        ContactEmail,
        ContactPhone,
        AdminNote,
        UpdatedAt,
        IsDeleted
    )
    SELECT
        req.UserId,
        cat.CategoryId,
        CONCAT(
            N'Bulk support case ',
            RIGHT(CONCAT(N'000', CAST(n.n AS VARCHAR(3))), 3),
            N' generated to test approval, filtering, and detail views.'
        ),
        CONCAT(N'https://files.ivan.test/support/bulk-', RIGHT(CONCAT(N'000', CAST(n.n AS VARCHAR(3))), 3), N'.jpg'),
        CASE
            WHEN n.n <= 18 THEN N'Approved'
            WHEN n.n <= 33 THEN N'Pending'
            ELSE N'Rejected'
        END,
        CASE
            WHEN n.n <= 18 THEN @AdminReviewerId
            WHEN n.n <= 33 THEN NULL
            ELSE @AdminReviewerId
        END,
        CASE
            WHEN n.n <= 18 THEN DATEADD(DAY, 2, DATEADD(DAY, n.n, CAST('2026-01-15T09:00:00' AS DATETIME)))
            WHEN n.n <= 33 THEN NULL
            ELSE DATEADD(DAY, 1, DATEADD(DAY, n.n, CAST('2026-01-15T09:00:00' AS DATETIME)))
        END,
        CASE WHEN n.n >= 34 THEN N'Bulk rejection reason for support request review testing.' ELSE NULL END,
        DATEADD(DAY, n.n, CAST('2026-01-15T09:00:00' AS DATETIME)),
        CONCAT(N'Bulk Support Request ', RIGHT(CONCAT(N'000', CAST(n.n AS VARCHAR(3))), 3)),
        CASE n.n % 3
            WHEN 0 THEN N'High'
            WHEN 1 THEN N'Medium'
            ELSE N'Low'
        END,
        CONCAT(
            N'Ward ',
            CAST(((n.n - 1) % 12) + 1 AS VARCHAR(10)),
            N', District ',
            CAST(((n.n - 1) % 8) + 1 AS VARCHAR(10)),
            N', Ho Chi Minh City'
        ),
        CONCAT(N'Community Group ', RIGHT(CONCAT(N'000', CAST(n.n AS VARCHAR(3))), 3)),
        15 + (n.n * 3),
        CAST(5000000 + (n.n * 275000) AS DECIMAL(18, 2)),
        req.Email,
        CONCAT(N'0938', RIGHT(CONCAT(N'000000', CAST(n.n AS VARCHAR(6))), 6)),
        CASE
            WHEN n.n <= 18 THEN N'Bulk approval note for support coordination testing.'
            WHEN n.n <= 33 THEN NULL
            ELSE N'Bulk rejection note for admin review testing.'
        END,
        CASE
            WHEN n.n <= 18 THEN DATEADD(DAY, 2, DATEADD(DAY, n.n, CAST('2026-01-15T09:00:00' AS DATETIME)))
            WHEN n.n <= 33 THEN DATEADD(DAY, n.n, CAST('2026-01-15T09:00:00' AS DATETIME))
            ELSE DATEADD(DAY, 1, DATEADD(DAY, n.n, CAST('2026-01-15T09:00:00' AS DATETIME)))
        END,
        CASE WHEN n.n IN (44, 45) THEN 1 ELSE 0 END
    FROM #Nums n
    JOIN #ActiveBulkSupportRequesters req
      ON req.GroupRow = ((n.n - 1) % @ActiveRequesterCount) + 1
    JOIN #CategoryMap cat
      ON cat.GroupRow = ((n.n - 1) % @CategoryCount) + 1
    WHERE n.n <= 45;

    INSERT INTO dbo.EventComments (
        EventId,
        UserId,
        Comment,
        Rating,
        CreatedAt,
        UpdatedAt,
        IsDeleted
    )
    SELECT
        abe.EventId,
        abm.VolunteerId,
        CASE abm.MemberRow
            WHEN 1 THEN N'Bulk feedback: event instructions were clear and coordination was smooth.'
            ELSE N'Bulk feedback: communication and support on site were strong.'
        END,
        CASE abm.MemberRow
            WHEN 1 THEN 5
            ELSE 4
        END,
        DATEADD(DAY, 1, CAST(abe.EndDate AS DATETIME)),
        DATEADD(DAY, 1, CAST(abe.EndDate AS DATETIME)),
        0
    FROM #OperationalBulkEvents abe
    JOIN #ApprovedBulkMembers abm
      ON abm.EventId = abe.EventId
     AND abm.MemberRow <= 2
    WHERE abe.Status = N'Closed';

    INSERT INTO dbo.Notifications (
        UserId,
        Content,
        Type,
        ReferenceId,
        IsRead,
        CreatedAt
    )
    SELECT
        er.VolunteerId,
        CASE er.Status
            WHEN N'Approved' THEN CONCAT(N'Your application for ', e.Title, N' was approved.')
            WHEN N'Pending' THEN CONCAT(N'Your application for ', e.Title, N' is pending review.')
            WHEN N'Invited' THEN CONCAT(N'You were invited to join ', e.Title, N'.')
            ELSE CONCAT(N'Your application for ', e.Title, N' was rejected.')
        END,
        N'EventRegistration',
        er.RegistrationId,
        CASE WHEN er.Status = N'Approved' THEN 1 ELSE 0 END,
        DATEADD(MINUTE, 10, er.AppliedAt)
    FROM dbo.EventRegistrations er
    JOIN #OperationalBulkEvents abe
      ON abe.EventId = er.EventId
    JOIN dbo.Events e
      ON e.EventId = er.EventId;

    INSERT INTO dbo.Notifications (
        UserId,
        Content,
        Type,
        ReferenceId,
        IsRead,
        CreatedAt
    )
    SELECT
        sr.CreatedBy,
        CONCAT(N'Your support request "', sr.Title, N'" is currently ', LOWER(sr.Status), N'.'),
        N'SupportRequest',
        sr.RequestId,
        CASE WHEN sr.Status = N'Approved' THEN 1 ELSE 0 END,
        DATEADD(MINUTE, 20, sr.CreatedAt)
    FROM dbo.SupportRequests sr
    WHERE sr.Title LIKE N'Bulk Support Request %';

    DROP TABLE IF EXISTS #VolunteerProfileRequestUsers;
    SELECT TOP (18)
        v.UserId,
        v.GroupRow
    INTO #VolunteerProfileRequestUsers
    FROM #ActiveBulkVolunteers v
    ORDER BY v.GroupRow;

    INSERT INTO dbo.ProfileUpdateRequests (
        UserId,
        NewFirstName,
        NewLastName,
        NewPhone,
        NewGender,
        NewDateOfBirth,
        NewProvince,
        NewAddress,
        NewSkillIds,
        Status,
        RequestedAt,
        ReviewedBy,
        ReviewedAt,
        ReviewNote
    )
    SELECT
        v.UserId,
        N'Volunteer',
        CONCAT(N'Updated ', RIGHT(CONCAT(N'000', CAST(v.GroupRow AS VARCHAR(3))), 3)),
        CONCAT(N'0947', RIGHT(CONCAT(N'000000', CAST(v.GroupRow AS VARCHAR(6))), 6)),
        CASE WHEN v.GroupRow % 2 = 0 THEN N'Female' ELSE N'Male' END,
        DATEADD(YEAR, -(20 + (v.GroupRow % 8)), CAST('2026-01-01' AS DATE)),
        CASE ((v.GroupRow - 1) % 4)
            WHEN 0 THEN N'Ho Chi Minh City'
            WHEN 1 THEN N'Ha Noi'
            WHEN 2 THEN N'Da Nang'
            ELSE N'Can Tho'
        END,
        CONCAT(CAST(900 + v.GroupRow AS VARCHAR(10)), N' Updated Volunteer Street'),
        skillset.SkillIds,
        CASE
            WHEN v.GroupRow <= 6 THEN N'Approved'
            WHEN v.GroupRow <= 14 THEN N'Pending'
            ELSE N'Rejected'
        END,
        DATEADD(DAY, v.GroupRow, CAST('2026-02-10T09:00:00' AS DATETIME)),
        CASE WHEN v.GroupRow BETWEEN 7 AND 14 THEN NULL ELSE @AdminReviewerId END,
        CASE
            WHEN v.GroupRow <= 6 THEN DATEADD(DAY, v.GroupRow + 2, CAST('2026-02-10T09:00:00' AS DATETIME))
            WHEN v.GroupRow <= 14 THEN NULL
            ELSE DATEADD(DAY, v.GroupRow + 3, CAST('2026-02-10T09:00:00' AS DATETIME))
        END,
        CASE
            WHEN v.GroupRow <= 6 THEN N'Bulk volunteer profile update approved.'
            WHEN v.GroupRow <= 14 THEN NULL
            ELSE N'Bulk volunteer profile update rejected.'
        END
    FROM #VolunteerProfileRequestUsers v
    CROSS APPLY (
        SELECT STRING_AGG(CAST(sm.SkillId AS VARCHAR(10)), ',') WITHIN GROUP (ORDER BY sm.GroupRow) AS SkillIds
        FROM #SkillMap sm
        WHERE sm.GroupRow IN (
            ((v.GroupRow - 1) % @SkillCount) + 1,
            ((v.GroupRow + 2) % @SkillCount) + 1,
            ((v.GroupRow + 5) % @SkillCount) + 1
        )
    ) AS skillset;

    DROP TABLE IF EXISTS #OrganizationProfileRequestUsers;
    SELECT TOP (8)
        bor.CreatedBy AS UserId,
        bor.GroupRow
    INTO #OrganizationProfileRequestUsers
    FROM #BulkOrganizationRecords bor
    ORDER BY bor.GroupRow;

    INSERT INTO dbo.OrganizationProfileUpdateRequests (
        UserId,
        OrganizationName,
        OrganizationType,
        EstablishedYear,
        TaxCode,
        BusinessLicenseNumber,
        RepresentativeName,
        RepresentativePosition,
        Phone,
        Address,
        Website,
        FacebookPage,
        Description,
        Status,
        RequestedAt,
        ReviewedBy,
        ReviewedAt,
        ReviewNote
    )
    SELECT
        o.UserId,
        CONCAT(N'Bulk Organization ', RIGHT(CONCAT(N'000', CAST(o.GroupRow AS VARCHAR(3))), 3), N' Updated'),
        CASE ((o.GroupRow - 1) % 3)
            WHEN 0 THEN N'Nonprofit'
            WHEN 1 THEN N'Foundation'
            ELSE N'Community Group'
        END,
        2012 + o.GroupRow,
        CONCAT(N'TAX-BULK-UPD-', RIGHT(CONCAT(N'000', CAST(o.GroupRow AS VARCHAR(3))), 3)),
        CONCAT(N'BL-BULK-UPD-', RIGHT(CONCAT(N'000', CAST(o.GroupRow AS VARCHAR(3))), 3)),
        CONCAT(N'Updated Representative ', RIGHT(CONCAT(N'000', CAST(o.GroupRow AS VARCHAR(3))), 3)),
        CASE WHEN o.GroupRow % 2 = 0 THEN N'Executive Director' ELSE N'Operations Lead' END,
        CONCAT(N'02888', RIGHT(CONCAT(N'00000', CAST(o.GroupRow AS VARCHAR(5))), 5)),
        CONCAT(CAST(1200 + o.GroupRow AS VARCHAR(10)), N' Updated Organization Boulevard'),
        CONCAT(N'https://bulk-updated-org', RIGHT(CONCAT(N'000', CAST(o.GroupRow AS VARCHAR(3))), 3), N'.ivan.test'),
        CONCAT(N'https://facebook.com/bulkorgupdated', RIGHT(CONCAT(N'000', CAST(o.GroupRow AS VARCHAR(3))), 3)),
        CONCAT(
            N'Bulk organization profile update request ',
            RIGHT(CONCAT(N'000', CAST(o.GroupRow AS VARCHAR(3))), 3),
            N' for review-center testing.'
        ),
        CASE
            WHEN o.GroupRow <= 4 THEN N'Pending'
            WHEN o.GroupRow <= 6 THEN N'Approved'
            ELSE N'Rejected'
        END,
        DATEADD(DAY, o.GroupRow, CAST('2026-02-20T10:00:00' AS DATETIME)),
        CASE WHEN o.GroupRow <= 4 THEN NULL ELSE @AdminReviewerId END,
        CASE
            WHEN o.GroupRow <= 4 THEN NULL
            WHEN o.GroupRow <= 6 THEN DATEADD(DAY, o.GroupRow + 2, CAST('2026-02-20T10:00:00' AS DATETIME))
            ELSE DATEADD(DAY, o.GroupRow + 3, CAST('2026-02-20T10:00:00' AS DATETIME))
        END,
        CASE
            WHEN o.GroupRow <= 4 THEN NULL
            WHEN o.GroupRow <= 6 THEN N'Bulk organization profile update approved.'
            ELSE N'Bulk organization profile update rejected.'
        END
    FROM #OrganizationProfileRequestUsers o;

    INSERT INTO dbo.Notifications (
        UserId,
        Content,
        Type,
        ReferenceId,
        IsRead,
        CreatedAt
    )
    SELECT
        pr.UserId,
        CASE pr.Status
            WHEN N'Approved' THEN N'Your profile update request was approved.'
            WHEN N'Pending' THEN N'Your profile update request is waiting for admin review.'
            ELSE N'Your profile update request was rejected.'
        END,
        N'ProfileUpdate',
        pr.RequestId,
        CASE WHEN pr.Status = N'Approved' THEN 1 ELSE 0 END,
        DATEADD(MINUTE, 15, pr.RequestedAt)
    FROM dbo.ProfileUpdateRequests pr
    JOIN #VolunteerProfileRequestUsers seed
      ON seed.UserId = pr.UserId;

    INSERT INTO dbo.Notifications (
        UserId,
        Content,
        Type,
        ReferenceId,
        IsRead,
        CreatedAt
    )
    SELECT
        opr.UserId,
        CASE opr.Status
            WHEN N'Approved' THEN N'Your organization profile update request was approved.'
            WHEN N'Pending' THEN N'Your organization profile update request is waiting for admin review.'
            ELSE N'Your organization profile update request was rejected.'
        END,
        N'OrganizationProfileUpdate',
        opr.RequestId,
        CASE WHEN opr.Status = N'Approved' THEN 1 ELSE 0 END,
        DATEADD(MINUTE, 15, opr.RequestedAt)
    FROM dbo.OrganizationProfileUpdateRequests opr
    JOIN #OrganizationProfileRequestUsers seed
      ON seed.UserId = opr.UserId;

    COMMIT TRANSACTION;

    PRINT N'Bulk IVAN test data inserted successfully.';
    PRINT N'Created large test coverage for users, organizations, events, registrations, coordinators, tasks, support requests, comments, notifications, and review queues.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
