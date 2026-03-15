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
SET XACT_ABORT ON;
GO

IF OBJECT_ID(N'dbo.Users', N'U') IS NULL
   OR OBJECT_ID(N'dbo.UserProfiles', N'U') IS NULL
   OR OBJECT_ID(N'dbo.Organizations', N'U') IS NULL
   OR OBJECT_ID(N'dbo.Events', N'U') IS NULL
   OR OBJECT_ID(N'dbo.EventRegistrations', N'U') IS NULL
BEGIN
    RAISERROR(N'IVAN schema is incomplete. Run ivan_schema_standard.sql successfully before seeding data.', 16, 1);
    RETURN;
END;
GO

IF EXISTS (SELECT 1 FROM dbo.Users WHERE Email = N'admin@ivan.org')
BEGIN
    PRINT N'Sample data already exists. Skipping ivan_bulk_test_data.sql.';
    RETURN;
END;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO dbo.Skills (SkillName)
    SELECT src.SkillName
    FROM (VALUES
        (N'First Aid'),
        (N'Logistics'),
        (N'Teaching'),
        (N'Community Outreach'),
        (N'Child Care'),
        (N'Data Entry'),
        (N'Counseling'),
        (N'Photography'),
        (N'Translation'),
        (N'Fundraising')
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
        (N'Child Support'),
        (N'Transportation')
    ) AS src(Name)
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.SupportCategories c
        WHERE c.Name = src.Name
    );

    DROP TABLE IF EXISTS #UserSeed;
    CREATE TABLE #UserSeed (
        Email NVARCHAR(255) NOT NULL,
        PasswordHash NVARCHAR(255) NOT NULL,
        IsActive BIT NOT NULL,
        CreatedAt DATETIME NOT NULL,
        Role NVARCHAR(50) NOT NULL,
        FirstName NVARCHAR(100) NOT NULL,
        LastName NVARCHAR(100) NOT NULL,
        Phone NVARCHAR(20) NULL,
        DateOfBirth DATE NULL,
        Gender NVARCHAR(10) NULL,
        Address NVARCHAR(500) NULL,
        District NVARCHAR(100) NULL,
        Province NVARCHAR(100) NULL,
        Description NVARCHAR(MAX) NULL
    );

    INSERT INTO #UserSeed (
        Email, PasswordHash, IsActive, CreatedAt, Role,
        FirstName, LastName, Phone, DateOfBirth, Gender,
        Address, District, Province, Description
    )
    VALUES
        (N'admin@ivan.org', N'Admin@123', 1, '2026-01-05T08:00:00', N'Admin', N'Dung', N'Tran', N'0901000001', '1988-04-12', N'Male', N'12 Nguyen Hue', N'District 1', N'Ho Chi Minh City', N'System administrator for IVAN.'),
        (N'coord.nam@ivan.org', N'Coord@123', 1, '2026-01-08T09:00:00', N'Coordinator', N'Nam', N'Pham', N'0902000001', '1994-02-18', N'Male', N'18 Le Loi', N'District 1', N'Ho Chi Minh City', N'Coordinator for health events and onboarding.'),
        (N'coord.linh@ivan.org', N'Coord@123', 1, '2026-01-08T09:30:00', N'Coordinator', N'Linh', N'Nguyen', N'0902000002', '1992-07-11', N'Female', N'55 Tran Hung Dao', N'District 1', N'Ho Chi Minh City', N'Coordinator for logistics and delivery events.'),
        (N'coord.khoa@ivan.org', N'Coord@123', 1, '2026-01-09T10:00:00', N'Coordinator', N'Khoa', N'Le', N'0902000003', '1990-11-04', N'Male', N'102 Bach Dang', N'Hai Chau', N'Da Nang', N'Coordinator for education and family support.'),
        (N'org.sunrise@ivan.org', N'Org@123', 1, '2026-01-10T09:00:00', N'Organization', N'Hong', N'Anh', N'0287300101', NULL, N'Female', N'88 Dien Bien Phu', N'District 1', N'Ho Chi Minh City', N'Sunrise Charity Network account.'),
        (N'org.bluehope@ivan.org', N'Org@123', 1, '2026-01-10T10:00:00', N'Organization', N'Bao', N'Vy', N'0247300202', NULL, N'Female', N'21 Tran Duy Hung', N'Cau Giay', N'Ha Noi', N'Blue Hope Foundation account.'),
        (N'org.citycare@ivan.org', N'Org@123', 1, '2026-01-11T08:45:00', N'Organization', N'Minh', N'Khai', N'0292300303', NULL, N'Male', N'67 Nguyen Trai', N'Ninh Kieu', N'Can Tho', N'CityCare Community account.'),
        (N'org.greenfuture@ivan.org', N'Org@123', 1, '2026-01-12T09:10:00', N'Organization', N'Thu', N'Ha', N'0287300404', NULL, N'Female', N'150 Vo Van Tan', N'District 3', N'Ho Chi Minh City', N'Green Future Volunteers account.'),
        (N'org.warmhome@ivan.org', N'Org@123', 1, '2026-01-12T10:20:00', N'Organization', N'Thanh', N'Lam', N'0287300505', NULL, N'Male', N'45 Hoang Hoa Tham', N'Binh Thanh', N'Ho Chi Minh City', N'Warm Home Relief account.'),
        (N'vol.ha@ivan.org', N'Volunteer@123', 1, '2026-01-15T08:00:00', N'Volunteer', N'Ha', N'Nguyen', N'0903000001', '2000-05-12', N'Female', N'14 Nguyen Thai Hoc', N'District 10', N'Ho Chi Minh City', N'Nursing student and regular community volunteer.'),
        (N'vol.minh@ivan.org', N'Volunteer@123', 1, '2026-01-15T08:15:00', N'Volunteer', N'Minh', N'Le', N'0903000002', '1999-10-20', N'Male', N'75 Cach Mang Thang 8', N'District 3', N'Ho Chi Minh City', N'Volunteer with logistics experience.'),
        (N'vol.quan@ivan.org', N'Volunteer@123', 1, '2026-01-15T08:30:00', N'Volunteer', N'Quan', N'Vo', N'0903000003', '2001-01-08', N'Male', N'33 Hung Vuong', N'District 5', N'Ho Chi Minh City', N'Volunteer comfortable with public-facing support.'),
        (N'vol.thao@ivan.org', N'Volunteer@123', 1, '2026-01-15T09:00:00', N'Volunteer', N'Thao', N'Tran', N'0903000004', '2002-04-22', N'Female', N'118 Nguyen Tri Phuong', N'District 10', N'Ho Chi Minh City', N'Volunteer interested in youth and learning events.'),
        (N'vol.lan@ivan.org', N'Volunteer@123', 1, '2026-01-15T09:15:00', N'Volunteer', N'Lan', N'Pham', N'0903000005', '1998-08-03', N'Female', N'21 Nguyen Trai', N'Ninh Kieu', N'Can Tho', N'Volunteer for packing and household support.'),
        (N'vol.tuan@ivan.org', N'Volunteer@123', 1, '2026-01-15T09:30:00', N'Volunteer', N'Tuan', N'Bui', N'0903000006', '1997-12-17', N'Male', N'9 Le Hong Phong', N'Hai Chau', N'Da Nang', N'Volunteer with field operations experience.'),
        (N'vol.ngoc@ivan.org', N'Volunteer@123', 1, '2026-01-15T09:45:00', N'Volunteer', N'Ngoc', N'Do', N'0903000007', '2001-07-01', N'Female', N'41 Xo Viet Nghe Tinh', N'Binh Thanh', N'Ho Chi Minh City', N'Volunteer active in child support and communication.'),
        (N'vol.hieu@ivan.org', N'Volunteer@123', 1, '2026-01-15T10:00:00', N'Volunteer', N'Hieu', N'Phan', N'0903000008', '1996-03-29', N'Male', N'64 Truong Sa', N'Phu Nhuan', N'Ho Chi Minh City', N'Volunteer experienced in packing and delivery.'),
        (N'vol.phuong@ivan.org', N'Volunteer@123', 1, '2026-01-15T10:15:00', N'Volunteer', N'Phuong', N'Ho', N'0903000009', '1999-09-14', N'Female', N'29 Tran Quoc Toan', N'Hai Chau', N'Da Nang', N'Volunteer with admin support experience.'),
        (N'vol.duc@ivan.org', N'Volunteer@123', 1, '2026-01-15T10:30:00', N'Volunteer', N'Duc', N'Truong', N'0903000010', '1998-06-06', N'Male', N'90 Cach Mang Thang 8', N'District 3', N'Ho Chi Minh City', N'Volunteer for transport and route support.'),
        (N'vol.mai@ivan.org', N'Volunteer@123', 1, '2026-01-15T10:45:00', N'Volunteer', N'Mai', N'Nguyen', N'0903000011', '2000-11-09', N'Female', N'16 Nguyen Van Linh', N'Ninh Kieu', N'Can Tho', N'Volunteer interested in teaching and counseling.'),
        (N'vol.khanh@ivan.org', N'Volunteer@123', 0, '2026-01-15T11:00:00', N'Volunteer', N'Khanh', N'Dang', N'0903000012', '1997-01-25', N'Male', N'48 Nguyen Du', N'District 1', N'Ho Chi Minh City', N'Inactive volunteer account for user management testing.'),
        (N'request.nhi@ivan.org', N'Requester@123', 1, '2026-01-18T08:00:00', N'SupportRequester', N'Nhi', N'Vo', N'0904000001', '1993-05-15', N'Female', N'31 Le Duc Tho', N'Go Vap', N'Ho Chi Minh City', N'Requester for food support cases.'),
        (N'request.long@ivan.org', N'Requester@123', 1, '2026-01-18T08:20:00', N'SupportRequester', N'Long', N'Tran', N'0904000002', '1987-09-09', N'Male', N'22 Truong Cong Dinh', N'Vung Tau', N'Ba Ria - Vung Tau', N'Requester for medical and transport cases.'),
        (N'request.hien@ivan.org', N'Requester@123', 1, '2026-01-18T08:40:00', N'SupportRequester', N'Hien', N'Le', N'0904000003', '1991-03-13', N'Female', N'117 Phan Chu Trinh', N'Hai Chau', N'Da Nang', N'Requester for education support cases.'),
        (N'request.phuc@ivan.org', N'Requester@123', 1, '2026-01-18T09:00:00', N'SupportRequester', N'Phuc', N'Nguyen', N'0904000004', '1989-12-02', N'Male', N'53 Huynh Tan Phat', N'District 7', N'Ho Chi Minh City', N'Requester for housing and emergency support.'),
        (N'request.tram@ivan.org', N'Requester@123', 1, '2026-01-18T09:20:00', N'SupportRequester', N'Tram', N'Pham', N'0904000005', '1994-06-27', N'Female', N'88 Vo Thi Sau', N'District 3', N'Ho Chi Minh City', N'Requester for child support needs.');

    INSERT INTO dbo.Users (Email, PasswordHash, IsActive, CreatedAt)
    SELECT Email, PasswordHash, IsActive, CreatedAt
    FROM #UserSeed;

    DROP TABLE IF EXISTS #UserMap;
    SELECT u.UserId, u.Email
    INTO #UserMap
    FROM dbo.Users u
    JOIN #UserSeed s ON s.Email = u.Email;

    DECLARE @AdminUserId INT;
    SELECT @AdminUserId = UserId FROM #UserMap WHERE Email = N'admin@ivan.org';

    INSERT INTO dbo.UserRoles (UserId, Role)
    SELECT m.UserId, s.Role
    FROM #UserSeed s
    JOIN #UserMap m ON m.Email = s.Email;

    INSERT INTO dbo.UserProfiles (
        UserId, FirstName, LastName, Phone, DateOfBirth, Gender,
        Address, District, Province, CreatedAt, UpdatedAt, ApprovalStatus, Description
    )
    SELECT
        m.UserId, s.FirstName, s.LastName, s.Phone, s.DateOfBirth, s.Gender,
        s.Address, s.District, s.Province,
        CAST(s.CreatedAt AS DATETIME2(7)),
        DATEADD(DAY, 7, CAST(s.CreatedAt AS DATETIME2(7))),
        N'Approved',
        s.Description
    FROM #UserSeed s
    JOIN #UserMap m ON m.Email = s.Email
    WHERE s.Role <> N'Organization';

    DROP TABLE IF EXISTS #OrgProfileSeed;
    CREATE TABLE #OrgProfileSeed (
        Email NVARCHAR(255) NOT NULL,
        OrganizationName NVARCHAR(200) NOT NULL,
        OrganizationType NVARCHAR(50) NOT NULL,
        EstablishedYear INT NOT NULL,
        TaxCode NVARCHAR(50) NOT NULL,
        BusinessLicenseNumber NVARCHAR(100) NOT NULL,
        RepresentativeName NVARCHAR(100) NOT NULL,
        RepresentativePosition NVARCHAR(100) NOT NULL,
        FacebookPage NVARCHAR(255) NULL,
        ApprovalStatus NVARCHAR(20) NOT NULL,
        ReviewNote NVARCHAR(MAX) NULL,
        ReviewedAt DATETIME NULL,
        Website NVARCHAR(255) NULL,
        Description NVARCHAR(MAX) NOT NULL
    );

    INSERT INTO #OrgProfileSeed (
        Email, OrganizationName, OrganizationType, EstablishedYear, TaxCode, BusinessLicenseNumber,
        RepresentativeName, RepresentativePosition, FacebookPage, ApprovalStatus,
        ReviewNote, ReviewedAt, Website, Description
    )
    VALUES
        (N'org.sunrise@ivan.org', N'Sunrise Charity Network', N'Nonprofit', 2015, N'0312345678', N'GP-2015-102', N'Nguyen Hong Anh', N'Program Director', N'https://facebook.com/sunrisecharityvn', N'Approved', N'Approved after legal document review.', '2026-01-15T10:30:00', N'https://sunrisecharity.org', N'Community health, meal delivery, and neighborhood outreach.'),
        (N'org.bluehope@ivan.org', N'Blue Hope Foundation', N'Foundation', 2018, N'0109988776', N'GP-2018-221', N'Tran Bao Vy', N'Executive Director', N'https://facebook.com/bluehopefoundation', N'Approved', N'Approved after verification call.', '2026-01-16T14:15:00', N'https://bluehope.org.vn', N'Education and child support initiatives for underserved communities.'),
        (N'org.citycare@ivan.org', N'CityCare Community', N'Community Group', 2017, N'1805566778', N'GP-2017-334', N'Vo Minh Khai', N'Operations Lead', N'https://facebook.com/citycarecommunity', N'Approved', N'Approved after site visit confirmation.', '2026-01-18T09:30:00', N'https://citycare.vn', N'Relief packing, household support, and local emergency response operations.'),
        (N'org.greenfuture@ivan.org', N'Green Future Volunteers', N'Community Group', 2020, N'0311122233', N'GP-2020-118', N'Tran Thu Ha', N'Founder', N'https://facebook.com/greenfuturevn', N'Pending', N'Waiting for final document verification.', NULL, N'https://greenfuture.vn', N'Applying to run youth environmental and community events.'),
        (N'org.warmhome@ivan.org', N'Warm Home Relief', N'Nonprofit', 2019, N'0315566779', N'GP-2019-509', N'Pham Thanh Lam', N'Operations Manager', N'https://facebook.com/warmhomerelief', N'Rejected', N'Business license image was unreadable. Please resubmit clearer documents.', '2026-01-20T11:00:00', N'https://warmhome.vn', N'Organization profile needs clearer legal documents before approval.');

    INSERT INTO dbo.UserProfiles (
        UserId, FirstName, LastName, Phone, Gender, Address, District, Province,
        CreatedAt, UpdatedAt, OrganizationName, OrganizationType, EstablishedYear,
        TaxCode, BusinessLicenseNumber, RepresentativeName, RepresentativePosition,
        FacebookPage, ApprovalStatus, ReviewNote, ReviewedBy, ReviewedAt, Website, Description
    )
    SELECT
        m.UserId, u.FirstName, u.LastName, u.Phone, u.Gender, u.Address, u.District, u.Province,
        CAST(u.CreatedAt AS DATETIME2(7)),
        DATEADD(DAY, 7, CAST(u.CreatedAt AS DATETIME2(7))),
        o.OrganizationName, o.OrganizationType, o.EstablishedYear, o.TaxCode, o.BusinessLicenseNumber,
        o.RepresentativeName, o.RepresentativePosition, o.FacebookPage, o.ApprovalStatus,
        o.ReviewNote,
        CASE WHEN o.ReviewedAt IS NOT NULL THEN @AdminUserId ELSE NULL END,
        o.ReviewedAt,
        o.Website,
        o.Description
    FROM #OrgProfileSeed o
    JOIN #UserSeed u ON u.Email = o.Email
    JOIN #UserMap m ON m.Email = o.Email;

    DROP TABLE IF EXISTS #VolunteerSkillSeed;
    CREATE TABLE #VolunteerSkillSeed (VolunteerEmail NVARCHAR(255), SkillName NVARCHAR(100));
    INSERT INTO #VolunteerSkillSeed VALUES
        (N'vol.ha@ivan.org', N'First Aid'), (N'vol.ha@ivan.org', N'Community Outreach'),
        (N'vol.minh@ivan.org', N'Logistics'), (N'vol.minh@ivan.org', N'Data Entry'),
        (N'vol.quan@ivan.org', N'Community Outreach'), (N'vol.quan@ivan.org', N'Fundraising'),
        (N'vol.thao@ivan.org', N'Teaching'), (N'vol.thao@ivan.org', N'Child Care'),
        (N'vol.lan@ivan.org', N'Logistics'), (N'vol.lan@ivan.org', N'Community Outreach'),
        (N'vol.tuan@ivan.org', N'Logistics'), (N'vol.tuan@ivan.org', N'Translation'),
        (N'vol.ngoc@ivan.org', N'Child Care'), (N'vol.ngoc@ivan.org', N'Photography'),
        (N'vol.hieu@ivan.org', N'Logistics'), (N'vol.hieu@ivan.org', N'Community Outreach'),
        (N'vol.phuong@ivan.org', N'Data Entry'), (N'vol.phuong@ivan.org', N'Translation'),
        (N'vol.duc@ivan.org', N'Logistics'), (N'vol.mai@ivan.org', N'Counseling');

    INSERT INTO dbo.VolunteerSkills (VolunteerId, SkillId)
    SELECT m.UserId, s.SkillId
    FROM #VolunteerSkillSeed seed
    JOIN #UserMap m ON m.Email = seed.VolunteerEmail
    JOIN dbo.Skills s ON s.SkillName = seed.SkillName;

    DROP TABLE IF EXISTS #VolunteerCoordinatorSeed;
    CREATE TABLE #VolunteerCoordinatorSeed (CoordinatorEmail NVARCHAR(255), VolunteerEmail NVARCHAR(255));
    INSERT INTO #VolunteerCoordinatorSeed VALUES
        (N'coord.nam@ivan.org', N'vol.ha@ivan.org'),
        (N'coord.nam@ivan.org', N'vol.minh@ivan.org'),
        (N'coord.nam@ivan.org', N'vol.quan@ivan.org'),
        (N'coord.nam@ivan.org', N'vol.ngoc@ivan.org'),
        (N'coord.linh@ivan.org', N'vol.lan@ivan.org'),
        (N'coord.linh@ivan.org', N'vol.tuan@ivan.org'),
        (N'coord.linh@ivan.org', N'vol.hieu@ivan.org'),
        (N'coord.linh@ivan.org', N'vol.duc@ivan.org'),
        (N'coord.khoa@ivan.org', N'vol.thao@ivan.org'),
        (N'coord.khoa@ivan.org', N'vol.phuong@ivan.org'),
        (N'coord.khoa@ivan.org', N'vol.mai@ivan.org'),
        (N'coord.khoa@ivan.org', N'vol.khanh@ivan.org');

    INSERT INTO dbo.VolunteerCoordinators (CoordinatorId, VolunteerId)
    SELECT c.UserId, v.UserId
    FROM #VolunteerCoordinatorSeed seed
    JOIN #UserMap c ON c.Email = seed.CoordinatorEmail
    JOIN #UserMap v ON v.Email = seed.VolunteerEmail;

    INSERT INTO dbo.Organizations (
        Name, Description, Phone, Email, Address, Website, CreatedBy, CreatedAt, UpdatedAt, LogoUrl
    )
    SELECT
        o.OrganizationName,
        o.Description,
        u.Phone,
        o.Email,
        u.Address + N', ' + u.District + N', ' + u.Province,
        o.Website,
        m.UserId,
        DATEADD(DAY, 1, u.CreatedAt),
        DATEADD(DAY, 20, u.CreatedAt),
        CONCAT(N'https://images.ivan.demo/org/', LOWER(REPLACE(REPLACE(o.OrganizationName, N' ', N'-'), N'&', N'and')), N'.png')
    FROM #OrgProfileSeed o
    JOIN #UserSeed u ON u.Email = o.Email
    JOIN #UserMap m ON m.Email = o.Email
    WHERE o.ApprovalStatus = N'Approved';

    DROP TABLE IF EXISTS #OrganizationMap;
    SELECT OrganizationId, Name INTO #OrganizationMap FROM dbo.Organizations;

    DROP TABLE IF EXISTS #EventSeed;
    CREATE TABLE #EventSeed (
        Title NVARCHAR(255), OrganizationName NVARCHAR(255), Description NVARCHAR(MAX),
        Location NVARCHAR(500), MaxVolunteers INT, Status NVARCHAR(50),
        StartDate DATE, EndDate DATE, CreatedAt DATETIME, UpdatedAt DATETIME, CoverImageUrl NVARCHAR(500),
        ContactName NVARCHAR(100), ContactEmail NVARCHAR(255), ContactPhone NVARCHAR(20),
        Requirements NVARCHAR(MAX), Benefits NVARCHAR(MAX),
        ReviewNote NVARCHAR(500), ReviewedByEmail NVARCHAR(255), ReviewedAt DATETIME
    );

    INSERT INTO #EventSeed VALUES
        (N'Community Health Day 2026', N'Sunrise Charity Network', N'Health outreach with patient guidance and registration support.', N'Ward 7 Community Hall, District 3, Ho Chi Minh City', 20, N'Approved', '2026-04-10', '2026-04-10', '2026-02-12T09:00:00', '2026-03-05T10:15:00', N'https://images.ivan.demo/event/community-health-day.jpg', N'Nguyen Hong Anh', N'healthday@sunrisecharity.org', N'0287300101', N'Comfortable greeting visitors, guiding patient flow, and staying on-site for most of the day.', N'On-site briefing, lunch, volunteer certificate, and a staffed check-in desk.', N'Approved after reviewing the event flow and volunteer supervision plan.', N'admin@ivan.org', '2026-03-05T10:15:00'),
        (N'Weekend Meal Delivery', N'Sunrise Charity Network', N'Meal packing and neighborhood delivery for elderly households.', N'Sunrise Storage Hub, District 4, Ho Chi Minh City', 15, N'Approved', '2026-03-28', '2026-03-28', '2026-02-14T14:00:00', '2026-03-06T11:00:00', N'https://images.ivan.demo/event/meal-delivery.jpg', N'Nguyen Hong Anh', N'mealdelivery@sunrisecharity.org', N'0287300102', N'Volunteers should be comfortable lifting food boxes, following route instructions, and starting early in the morning.', N'Breakfast, lunch, route briefing, and travel support for delivery teams.', N'Approved with route support confirmed.', N'admin@ivan.org', '2026-03-06T11:00:00'),
        (N'New Volunteer Orientation', N'Sunrise Charity Network', N'Orientation session for newly registered volunteers.', N'Sunrise Office, District 1, Ho Chi Minh City', 30, N'Pending', '2026-04-18', '2026-04-18', '2026-03-01T08:30:00', '2026-03-07T15:00:00', N'https://images.ivan.demo/event/volunteer-orientation.jpg', N'Le Thanh Ngan', N'orientation@sunrisecharity.org', N'0287300103', N'Best for newly approved volunteers who can attend the full onboarding session and workshop activities.', N'Orientation handbook, mentoring session, and networking with coordinators.', NULL, NULL, NULL),
        (N'Back-to-School Support Fair', N'Blue Hope Foundation', N'School supply sorting and family support booths.', N'Thanh Xuan Youth Center, Ha Noi', 18, N'Approved', '2026-04-22', '2026-04-23', '2026-02-18T10:00:00', '2026-03-08T16:10:00', N'https://images.ivan.demo/event/back-to-school-fair.jpg', N'Tran Bao Vy', N'schoolfair@bluehope.org.vn', N'0247300202', N'Volunteers should be comfortable supporting families, handling school supply kits, and following booth assignments across two days.', N'Event shirt, meals during shifts, and a post-event appreciation certificate.', N'Approved after site and staffing review.', N'admin@ivan.org', '2026-03-08T16:10:00'),
        (N'Reading Corner Setup', N'Blue Hope Foundation', N'Completed event to build and organize a community reading corner.', N'Hoa Khanh Community House, Da Nang', 12, N'Approved', '2026-02-20', '2026-02-21', '2026-01-28T09:00:00', '2026-02-22T17:00:00', N'https://images.ivan.demo/event/reading-corner.jpg', N'Tran Bao Vy', N'readingcorner@bluehope.org.vn', N'02367300202', N'Helpful for volunteers who can support shelf setup, book sorting, and light facilitation with children.', N'On-site coaching, meals, and a completion letter for volunteers.', N'Approved after equipment checklist review.', N'admin@ivan.org', '2026-02-02T16:00:00'),
        (N'Flood Relief Packing Day', N'CityCare Community', N'Relief package preparation with sorting, labeling, and loading.', N'Can Tho Logistics Center, Ninh Kieu, Can Tho', 25, N'Approved', '2026-03-25', '2026-03-26', '2026-02-20T13:15:00', '2026-03-10T09:45:00', N'https://images.ivan.demo/event/flood-relief-packing.jpg', N'Vo Minh Khai', N'reliefpacking@citycare.vn', N'02927300303', N'Volunteers should be ready for standing work, repetitive packing tasks, and teamwork in a warehouse setup.', N'Meals, hydration support, a logistics briefing, and volunteer coordinator support on-site.', N'Approved after safety and loading plan review.', N'admin@ivan.org', '2026-03-10T09:45:00'),
        (N'Family Care Pack Distribution', N'CityCare Community', N'Planned event submitted for review but not approved yet.', N'Binh Thuy Community Hall, Can Tho', 20, N'Rejected', '2026-04-30', '2026-04-30', '2026-02-26T11:20:00', '2026-03-09T08:20:00', N'https://images.ivan.demo/event/family-care-pack.jpg', N'Vo Minh Khai', N'familypacks@citycare.vn', N'02927300304', N'Needs volunteers who can manage registration, queue flow, and child-safe distribution procedures.', N'Lunch, on-site support, and a short distribution briefing for all volunteers.', N'Please add a clearer distribution workflow, family check-in plan, and volunteer safety briefing before resubmitting.', N'admin@ivan.org', '2026-03-09T08:20:00');

    INSERT INTO dbo.Events (
        OrganizationId, Title, Description, Location, MaxVolunteers, Status,
        StartDate, EndDate, CreatedAt, UpdatedAt, CoverImageUrl,
        ContactName, ContactEmail, ContactPhone, Requirements, Benefits,
        ReviewNote, ReviewedBy, ReviewedAt
    )
    SELECT om.OrganizationId, e.Title, e.Description, e.Location, e.MaxVolunteers, e.Status,
           e.StartDate, e.EndDate, e.CreatedAt, e.UpdatedAt, e.CoverImageUrl,
           e.ContactName, e.ContactEmail, e.ContactPhone, e.Requirements, e.Benefits,
           e.ReviewNote, reviewer.UserId, e.ReviewedAt
    FROM #EventSeed e
    JOIN #OrganizationMap om ON om.Name = e.OrganizationName
    LEFT JOIN #UserMap reviewer ON reviewer.Email = e.ReviewedByEmail;

    DROP TABLE IF EXISTS #EventMap;
    SELECT EventId, Title INTO #EventMap FROM dbo.Events;

    DROP TABLE IF EXISTS #RegistrationSeed;
    CREATE TABLE #RegistrationSeed (
        EventTitle NVARCHAR(255), VolunteerEmail NVARCHAR(255), RegistrationType NVARCHAR(20), Status NVARCHAR(50),
        AppliedAt DATETIME, ApplicationReason NVARCHAR(MAX), RelevantExperience NVARCHAR(MAX),
        CommitmentLevel NVARCHAR(100), AvailabilityNote NVARCHAR(1000), InvitationMessage NVARCHAR(1000),
        InvitedByEmail NVARCHAR(255), ReviewedAt DATETIME, ReviewedByEmail NVARCHAR(255), ReviewNote NVARCHAR(500)
    );

    INSERT INTO #RegistrationSeed VALUES
        (N'Community Health Day 2026', N'vol.ha@ivan.org', N'Application', N'Approved', '2026-03-01T19:10:00', N'I want to support community health outreach.', N'Joined campus health check days.', N'Full day', N'Available from early morning.', NULL, NULL, '2026-03-03T09:00:00', N'org.sunrise@ivan.org', N'Strong fit for first-aid support.'),
        (N'Community Health Day 2026', N'vol.minh@ivan.org', N'Application', N'Approved', '2026-03-02T08:40:00', N'I can help with setup and logistics.', N'Handled logistics for a food drive.', N'Full day', N'Can arrive early.', NULL, NULL, '2026-03-03T09:10:00', N'org.sunrise@ivan.org', N'Approved for setup and stock handling.'),
        (N'Community Health Day 2026', N'vol.quan@ivan.org', N'Application', N'Approved', '2026-03-02T12:20:00', N'I can guide visitors smoothly.', N'Supported several youth events.', N'Most of the event', N'Available until 4 PM.', NULL, NULL, '2026-03-03T09:25:00', N'org.sunrise@ivan.org', N'Approved for crowd guidance.'),
        (N'Community Health Day 2026', N'vol.thao@ivan.org', N'Application', N'Pending', '2026-03-05T20:15:00', N'I want to support families and children.', N'Helped at reading clubs.', N'Full day', N'Available all day.', NULL, NULL, NULL, NULL, NULL),
        (N'Community Health Day 2026', N'vol.lan@ivan.org', N'Application', N'Pending', '2026-03-06T18:45:00', N'I can help with check-in and supplies.', N'Worked on meal delivery and sorting.', N'Most of the event', N'Available after 7 AM.', NULL, NULL, NULL, NULL, NULL),
        (N'Community Health Day 2026', N'vol.tuan@ivan.org', N'Invitation', N'Invited', '2026-03-07T10:00:00', NULL, NULL, NULL, NULL, N'We need one more volunteer with field delivery experience.', N'org.sunrise@ivan.org', NULL, NULL, NULL),
        (N'Community Health Day 2026', N'vol.ngoc@ivan.org', N'Application', N'Rejected', '2026-03-04T14:30:00', N'I would like to support the check-in desk.', N'Helped manage attendance for a local workshop.', N'Half day', N'Only available in the afternoon.', NULL, NULL, '2026-03-06T09:30:00', N'org.sunrise@ivan.org', N'Current staffing needs require full-day availability.'),
        (N'Community Health Day 2026', N'vol.phuong@ivan.org', N'Invitation', N'Approved', '2026-03-04T09:20:00', NULL, NULL, NULL, NULL, N'Could you support registration records for this event?', N'org.sunrise@ivan.org', '2026-03-05T08:40:00', N'org.sunrise@ivan.org', N'Invitation accepted and confirmed.'),
        (N'Weekend Meal Delivery', N'vol.lan@ivan.org', N'Application', N'Approved', '2026-03-03T19:00:00', N'I regularly help with packing and outreach.', N'Joined neighborhood support runs.', N'Full day', N'Available from 6 AM.', NULL, NULL, '2026-03-04T09:00:00', N'org.sunrise@ivan.org', N'Approved for packing line.'),
        (N'Weekend Meal Delivery', N'vol.tuan@ivan.org', N'Application', N'Approved', '2026-03-03T20:20:00', N'I can support delivery routing.', N'Field operations and loading experience.', N'Full day', N'Have my own motorbike.', NULL, NULL, '2026-03-04T09:10:00', N'org.sunrise@ivan.org', N'Approved for route support.'),
        (N'Weekend Meal Delivery', N'vol.mai@ivan.org', N'Invitation', N'Invited', '2026-03-08T11:00:00', NULL, NULL, NULL, NULL, N'We need one more volunteer to support family handover notes.', N'org.sunrise@ivan.org', NULL, NULL, NULL),
        (N'Weekend Meal Delivery', N'vol.duc@ivan.org', N'Application', N'Pending', '2026-03-08T16:25:00', N'I want to help with transportation and route planning.', N'I often help move donated goods.', N'Most of the event', N'Available from 8 AM onward.', NULL, NULL, NULL, NULL, NULL),
        (N'Back-to-School Support Fair', N'vol.ngoc@ivan.org', N'Application', N'Approved', '2026-03-01T10:10:00', N'I enjoy helping children feel comfortable.', N'Experience with children workshops.', N'Full day', N'Available both event days.', NULL, NULL, '2026-03-03T14:00:00', N'org.bluehope@ivan.org', N'Approved for child activity area.'),
        (N'Back-to-School Support Fair', N'vol.phuong@ivan.org', N'Application', N'Approved', '2026-03-01T10:25:00', N'I can support forms and lists.', N'Strong data entry experience.', N'Full day', N'Available from opening time.', NULL, NULL, '2026-03-03T14:10:00', N'org.bluehope@ivan.org', N'Approved for registration support.'),
        (N'Back-to-School Support Fair', N'vol.duc@ivan.org', N'Application', N'Approved', '2026-03-02T07:50:00', N'I want to help with moving supplies.', N'I support transport and setup at events.', N'Full day', N'Can support setup before 7 AM.', NULL, NULL, '2026-03-03T14:20:00', N'org.bluehope@ivan.org', N'Approved for transport and setup.'),
        (N'Back-to-School Support Fair', N'vol.mai@ivan.org', N'Application', N'Pending', '2026-03-09T20:40:00', N'I want to help children through reading activities.', N'I volunteer with a weekend study group.', N'Full day', N'Available both days.', NULL, NULL, NULL, NULL, NULL),
        (N'Back-to-School Support Fair', N'vol.ha@ivan.org', N'Application', N'Rejected', '2026-03-02T18:10:00', N'I can support a health booth and parent flow.', N'I have healthcare volunteer experience.', N'Half day', N'Only available on the first afternoon.', NULL, NULL, '2026-03-05T10:00:00', N'org.bluehope@ivan.org', N'The current plan needs volunteers available across both days.'),
        (N'Reading Corner Setup', N'vol.ha@ivan.org', N'Application', N'Approved', '2026-02-05T19:00:00', N'I want to support children and reading spaces.', N'I helped organize book donation drives.', N'Full day', N'Available for both days.', NULL, NULL, '2026-02-07T09:00:00', N'org.bluehope@ivan.org', N'Approved for reading corner support.'),
        (N'Reading Corner Setup', N'vol.minh@ivan.org', N'Application', N'Approved', '2026-02-05T20:15:00', N'I can help move shelves and organize books.', N'I have logistics experience with community events.', N'Full day', N'Can support setup early.', NULL, NULL, '2026-02-07T09:10:00', N'org.bluehope@ivan.org', N'Approved for setup and moving materials.'),
        (N'Reading Corner Setup', N'vol.thao@ivan.org', N'Application', N'Approved', '2026-02-06T08:45:00', N'I enjoy supporting children activities.', N'I run a small reading circle for younger students.', N'Full day', N'Available until closing time.', NULL, NULL, '2026-02-07T09:15:00', N'org.bluehope@ivan.org', N'Approved for children support area.'),
        (N'Flood Relief Packing Day', N'vol.lan@ivan.org', N'Application', N'Approved', '2026-03-05T21:00:00', N'I want to help package relief items.', N'I have packing and labeling experience.', N'Full day', N'Available both packing days.', NULL, NULL, '2026-03-07T08:30:00', N'org.citycare@ivan.org', N'Approved for labeling team.'),
        (N'Flood Relief Packing Day', N'vol.tuan@ivan.org', N'Application', N'Approved', '2026-03-05T21:30:00', N'I can support loading heavy boxes.', N'Field operations and delivery experience.', N'Full day', N'Available from 7 AM.', NULL, NULL, '2026-03-07T08:45:00', N'org.citycare@ivan.org', N'Approved for loading team.'),
        (N'Flood Relief Packing Day', N'vol.ngoc@ivan.org', N'Application', N'Pending', '2026-03-11T10:00:00', N'I want to support package checklist and volunteer coordination.', N'I often help at registration desks.', N'Most of the event', N'Available on day one only.', NULL, NULL, NULL, NULL, NULL),
        (N'Flood Relief Packing Day', N'vol.phuong@ivan.org', N'Invitation', N'Invited', '2026-03-11T14:30:00', NULL, NULL, NULL, NULL, N'Could you support stock counting and issue logging?', N'org.citycare@ivan.org', NULL, NULL, NULL),
        (N'Flood Relief Packing Day', N'vol.mai@ivan.org', N'Invitation', N'Declined', '2026-03-10T11:45:00', NULL, NULL, NULL, NULL, N'We would like to invite you to support package labeling.', N'org.citycare@ivan.org', '2026-03-11T08:00:00', NULL, N'I am unavailable that week because of exams.');

    INSERT INTO dbo.EventRegistrations (
        EventId, VolunteerId, RegistrationType, Status, AppliedAt,
        ApplicationReason, RelevantExperience, CommitmentLevel, AvailabilityNote,
        InvitationMessage, InvitedBy, ReviewedAt, ReviewedBy, ReviewNote
    )
    SELECT
        e.EventId, v.UserId, s.RegistrationType, s.Status, s.AppliedAt,
        s.ApplicationReason, s.RelevantExperience, s.CommitmentLevel, s.AvailabilityNote,
        s.InvitationMessage, inviter.UserId, s.ReviewedAt, reviewer.UserId, s.ReviewNote
    FROM #RegistrationSeed s
    JOIN #EventMap e ON e.Title = s.EventTitle
    JOIN #UserMap v ON v.Email = s.VolunteerEmail
    LEFT JOIN #UserMap inviter ON inviter.Email = s.InvitedByEmail
    LEFT JOIN #UserMap reviewer ON reviewer.Email = s.ReviewedByEmail;

    DROP TABLE IF EXISTS #CoordinatorSeed;
    CREATE TABLE #CoordinatorSeed (
        EventTitle NVARCHAR(255), CoordinatorEmail NVARCHAR(255),
        PromotedFromVolunteer BIT, PromotedAt DATETIME, PromotedByEmail NVARCHAR(255), Status NVARCHAR(20)
    );
    INSERT INTO #CoordinatorSeed VALUES
        (N'Community Health Day 2026', N'coord.nam@ivan.org', 0, '2026-03-01T08:00:00', N'org.sunrise@ivan.org', N'Active'),
        (N'Community Health Day 2026', N'coord.khoa@ivan.org', 0, '2026-03-02T08:15:00', N'org.sunrise@ivan.org', N'Active'),
        (N'Weekend Meal Delivery', N'coord.linh@ivan.org', 0, '2026-03-02T07:45:00', N'org.sunrise@ivan.org', N'Active'),
        (N'Back-to-School Support Fair', N'coord.khoa@ivan.org', 0, '2026-03-01T09:30:00', N'org.bluehope@ivan.org', N'Active'),
        (N'Reading Corner Setup', N'coord.nam@ivan.org', 0, '2026-02-06T08:00:00', N'org.bluehope@ivan.org', N'Active'),
        (N'Flood Relief Packing Day', N'coord.linh@ivan.org', 0, '2026-03-06T08:15:00', N'org.citycare@ivan.org', N'Active');

    INSERT INTO dbo.EventCoordinators (
        EventId, CoordinatorId, PromotedFromVolunteer, PromotedAt, PromotedBy, Status
    )
    SELECT e.EventId, c.UserId, s.PromotedFromVolunteer, s.PromotedAt, promoter.UserId, s.Status
    FROM #CoordinatorSeed s
    JOIN #EventMap e ON e.Title = s.EventTitle
    JOIN #UserMap c ON c.Email = s.CoordinatorEmail
    LEFT JOIN #UserMap promoter ON promoter.Email = s.PromotedByEmail;

    DROP TABLE IF EXISTS #TaskSeed;
    CREATE TABLE #TaskSeed (
        EventTitle NVARCHAR(255), CoordinatorEmail NVARCHAR(255), VolunteerEmail NVARCHAR(255),
        TaskDescription NVARCHAR(MAX), Status NVARCHAR(50), AssignedAt DATETIME,
        CompletedAt DATETIME NULL, ConfirmedAt DATETIME NULL, Note NVARCHAR(500)
    );
    INSERT INTO #TaskSeed VALUES
        (N'Community Health Day 2026', N'coord.nam@ivan.org', N'vol.ha@ivan.org', N'Manage the first-aid registration desk.', N'Pending', '2026-04-09T14:00:00', NULL, NULL, N'Arrive 30 minutes before briefing.'),
        (N'Community Health Day 2026', N'coord.khoa@ivan.org', N'vol.minh@ivan.org', N'Set up signs and refill station supplies.', N'Pending', '2026-04-09T14:10:00', NULL, NULL, N'Coordinate with logistics when supplies run low.'),
        (N'Weekend Meal Delivery', N'coord.linh@ivan.org', N'vol.lan@ivan.org', N'Lead the meal packing line and check labels.', N'Pending', '2026-03-27T16:00:00', NULL, NULL, N'Confirm box counts before loading starts.'),
        (N'Weekend Meal Delivery', N'coord.linh@ivan.org', N'vol.tuan@ivan.org', N'Support route loading and delivery handover.', N'Pending', '2026-03-27T16:10:00', NULL, NULL, N'Bring a charged phone for routing.'),
        (N'Back-to-School Support Fair', N'coord.khoa@ivan.org', N'vol.ngoc@ivan.org', N'Support the children activity corner and attendance desk.', N'Pending', '2026-04-21T15:00:00', NULL, NULL, N'Coordinate with the parent guidance booth.'),
        (N'Reading Corner Setup', N'coord.nam@ivan.org', N'vol.thao@ivan.org', N'Facilitate the reading session and help children choose books.', N'Completed', '2026-02-19T14:30:00', '2026-02-21T16:30:00', '2026-02-21T17:00:00', N'Completed well and received good feedback.');

    INSERT INTO dbo.Tasks (
        EventId, CoordinatorId, VolunteerId, TaskDescription, Status, AssignedAt, CompletedAt, ConfirmedAt, Note
    )
    SELECT e.EventId, c.UserId, v.UserId, s.TaskDescription, s.Status, s.AssignedAt, s.CompletedAt, s.ConfirmedAt, s.Note
    FROM #TaskSeed s
    JOIN #EventMap e ON e.Title = s.EventTitle
    JOIN #UserMap c ON c.Email = s.CoordinatorEmail
    JOIN #UserMap v ON v.Email = s.VolunteerEmail;

    DROP TABLE IF EXISTS #TaskMap;
    SELECT TaskId, TaskDescription INTO #TaskMap FROM dbo.Tasks;

    DROP TABLE IF EXISTS #ScheduleSeed;
    CREATE TABLE #ScheduleSeed (
        TaskDescription NVARCHAR(MAX), WorkDate DATE, StartTime TIME(7), EndTime TIME(7), Note NVARCHAR(255)
    );
    INSERT INTO #ScheduleSeed VALUES
        (N'Manage the first-aid registration desk.', '2026-04-10', '07:30:00', '11:30:00', N'Morning registration shift.'),
        (N'Manage the first-aid registration desk.', '2026-04-10', '13:00:00', '16:30:00', N'Afternoon support shift.'),
        (N'Set up signs and refill station supplies.', '2026-04-10', '07:00:00', '12:00:00', N'Setup and morning supply coverage.'),
        (N'Lead the meal packing line and check labels.', '2026-03-28', '06:30:00', '10:30:00', N'Packing line lead shift.'),
        (N'Support route loading and delivery handover.', '2026-03-28', '09:30:00', '13:00:00', N'Loading and dispatch support.'),
        (N'Support the children activity corner and attendance desk.', '2026-04-22', '08:00:00', '16:30:00', N'Event day one support.'),
        (N'Facilitate the reading session and help children choose books.', '2026-02-21', '09:00:00', '11:30:00', N'Morning reading session.');

    INSERT INTO dbo.Schedules (TaskId, WorkDate, StartTime, EndTime, Note)
    SELECT tm.TaskId, s.WorkDate, s.StartTime, s.EndTime, s.Note
    FROM #ScheduleSeed s
    JOIN #TaskMap tm ON tm.TaskDescription = s.TaskDescription;

    DROP TABLE IF EXISTS #SupportRequestSeed;
    CREATE TABLE #SupportRequestSeed (
        CreatedByEmail NVARCHAR(255), CategoryName NVARCHAR(100), Title NVARCHAR(255), Priority NVARCHAR(50),
        SupportLocation NVARCHAR(500), BeneficiaryName NVARCHAR(255), AffectedPeople INT, EstimatedAmount DECIMAL(18,2),
        Description NVARCHAR(MAX), ProofUrl NVARCHAR(255), ContactEmail NVARCHAR(255), ContactPhone NVARCHAR(20),
        Status NVARCHAR(50), ReviewedByEmail NVARCHAR(255), ReviewedAt DATETIME NULL,
        RejectReason NVARCHAR(500) NULL, AdminNote NVARCHAR(MAX) NULL, CreatedAt DATETIME, UpdatedAt DATETIME
    );
    INSERT INTO #SupportRequestSeed VALUES
        (N'request.nhi@ivan.org', N'Food and Essentials', N'Food support for 12 elderly households', N'HIGH', N'Ward 16, Go Vap, Ho Chi Minh City', N'Neighborhood Elderly Group', 12, 9500000.00, N'Rice, oil, and dry food support is needed for elderly residents living alone.', N'https://images.ivan.demo/support/food-support.jpg', N'request.nhi@ivan.org', N'0904000001', N'PENDING', NULL, NULL, NULL, NULL, '2026-03-11T09:20:00', '2026-03-11T09:20:00'),
        (N'request.long@ivan.org', N'Medical Support', N'Basic medicine support for flood-affected families', N'URGENT', N'Long Xuyen, An Giang', N'Flood-Affected Family Group', 24, 18500000.00, N'First-aid supplies and hygiene kits are needed for affected households.', N'https://images.ivan.demo/support/medical-kits.jpg', N'request.long@ivan.org', N'0904000002', N'APPROVED', N'admin@ivan.org', '2026-03-12T10:40:00', NULL, N'Approved with priority coordination for medical kit delivery.', '2026-03-10T14:15:00', '2026-03-12T10:40:00'),
        (N'request.hien@ivan.org', N'Education', N'Study corner materials for after-school class', N'MEDIUM', N'Hai Chau, Da Nang', N'Community Learning Group', 18, 6200000.00, N'The class needs mats, whiteboards, notebooks, and shelves.', N'https://images.ivan.demo/support/study-corner.jpg', N'request.hien@ivan.org', N'0904000003', N'REJECTED', N'admin@ivan.org', '2026-03-12T16:10:00', N'The proposal needs a clearer itemized budget and beneficiary confirmation.', N'Please resubmit with a signed beneficiary list.', '2026-03-09T11:30:00', '2026-03-12T16:10:00'),
        (N'request.phuc@ivan.org', N'Shelter Assistance', N'Temporary housing support for two displaced families', N'HIGH', N'District 7, Ho Chi Minh City', N'Two Riverside Families', 9, 22000000.00, N'Two families need short-term rental support and urgent household essentials.', N'https://images.ivan.demo/support/temporary-housing.jpg', N'request.phuc@ivan.org', N'0904000004', N'PENDING', NULL, NULL, NULL, NULL, '2026-03-13T08:45:00', '2026-03-13T08:45:00'),
        (N'request.tram@ivan.org', N'Child Support', N'Child care kits for 15 low-income students', N'MEDIUM', N'District 3, Ho Chi Minh City', N'Parent Volunteer Group', 15, 7800000.00, N'The group needs backpacks, hygiene kits, and learning materials for children returning to school.', N'https://images.ivan.demo/support/child-care-kits.jpg', N'request.tram@ivan.org', N'0904000005', N'APPROVED', N'admin@ivan.org', '2026-03-13T15:20:00', NULL, N'Approved for the next distribution cycle.', '2026-03-12T09:10:00', '2026-03-13T15:20:00'),
        (N'request.long@ivan.org', N'Transportation', N'Transport support for weekly medical visits', N'LOW', N'Vung Tau City', N'Neighborhood Patient Support Team', 6, 3500000.00, N'The team is asking for travel support to help older patients reach weekly treatment appointments.', N'https://images.ivan.demo/support/transport-support.jpg', N'request.long@ivan.org', N'0904000002', N'COMPLETED', N'admin@ivan.org', '2026-03-08T14:00:00', NULL, N'Completed after local taxi vouchers were delivered.', '2026-03-04T10:00:00', '2026-03-08T14:00:00');

    INSERT INTO dbo.SupportRequests (
        CreatedBy, CategoryId, Description, ProofUrl, Status, ReviewedBy, ReviewedAt, RejectReason,
        CreatedAt, Title, Priority, SupportLocation, BeneficiaryName, AffectedPeople, EstimatedAmount,
        ContactEmail, ContactPhone, AdminNote, UpdatedAt, IsDeleted
    )
    SELECT
        requester.UserId,
        c.CategoryId,
        s.Description,
        s.ProofUrl,
        s.Status,
        reviewer.UserId,
        s.ReviewedAt,
        s.RejectReason,
        s.CreatedAt,
        s.Title,
        s.Priority,
        s.SupportLocation,
        s.BeneficiaryName,
        s.AffectedPeople,
        s.EstimatedAmount,
        s.ContactEmail,
        s.ContactPhone,
        s.AdminNote,
        s.UpdatedAt,
        0
    FROM #SupportRequestSeed s
    JOIN #UserMap requester ON requester.Email = s.CreatedByEmail
    JOIN dbo.SupportCategories c ON c.Name = s.CategoryName
    LEFT JOIN #UserMap reviewer ON reviewer.Email = s.ReviewedByEmail;

    INSERT INTO dbo.EventComments (EventId, UserId, Comment, Rating, CreatedAt, UpdatedAt, IsDeleted)
    SELECT e.EventId, u.UserId, seed.Comment, seed.Rating, seed.CreatedAt, seed.CreatedAt, 0
    FROM (VALUES
        (N'Reading Corner Setup', N'vol.ha@ivan.org', N'The event was organized clearly and the children were very engaged.', 5, CAST('2026-02-22T09:00:00' AS DATETIME)),
        (N'Reading Corner Setup', N'vol.minh@ivan.org', N'Logistics were smooth and the team always knew what to do next.', 4, CAST('2026-02-22T09:15:00' AS DATETIME)),
        (N'Reading Corner Setup', N'vol.thao@ivan.org', N'I appreciated how well the volunteers coordinated with the teachers.', 5, CAST('2026-02-22T09:30:00' AS DATETIME))
    ) AS seed(EventTitle, UserEmail, Comment, Rating, CreatedAt)
    JOIN #EventMap e ON e.Title = seed.EventTitle
    JOIN #UserMap u ON u.Email = seed.UserEmail;

    INSERT INTO dbo.Notifications (UserId, Content, Type, ReferenceId, IsRead, CreatedAt)
    SELECT u.UserId, seed.Content, seed.Type, seed.ReferenceId, seed.IsRead, seed.CreatedAt
    FROM (VALUES
        (N'vol.tuan@ivan.org', N'You have been invited to join Community Health Day 2026.', N'EVENT_INVITE', 1, CAST(0 AS BIT), CAST('2026-03-07T10:05:00' AS DATETIME)),
        (N'vol.mai@ivan.org', N'You have been invited to join Weekend Meal Delivery.', N'EVENT_INVITE', 2, CAST(0 AS BIT), CAST('2026-03-08T11:05:00' AS DATETIME)),
        (N'vol.ngoc@ivan.org', N'Your application for Community Health Day 2026 was not approved this time.', N'EVENT_REJECTED', 1, CAST(0 AS BIT), CAST('2026-03-06T09:35:00' AS DATETIME)),
        (N'request.long@ivan.org', N'Your medical support request has been approved.', N'SUPPORT_APPROVED', 2, CAST(1 AS BIT), CAST('2026-03-12T10:45:00' AS DATETIME)),
        (N'org.sunrise@ivan.org', N'You have a new pending volunteer application for Community Health Day 2026.', N'ORG_EVENT', 1, CAST(0 AS BIT), CAST('2026-03-06T18:50:00' AS DATETIME))
    ) AS seed(UserEmail, Content, Type, ReferenceId, IsRead, CreatedAt)
    JOIN #UserMap u ON u.Email = seed.UserEmail;

    INSERT INTO dbo.ProfileUpdateRequests (
        UserId, NewFirstName, NewLastName, NewPhone, NewGender, NewDateOfBirth,
        NewProvince, NewAddress, NewSkillIds, Status, RequestedAt, ReviewedBy, ReviewedAt, ReviewNote
    )
    SELECT u.UserId, seed.NewFirstName, seed.NewLastName, seed.NewPhone, seed.NewGender, seed.NewDateOfBirth,
           seed.NewProvince, seed.NewAddress, seed.NewSkillIds, seed.Status, seed.RequestedAt, reviewer.UserId, seed.ReviewedAt, seed.ReviewNote
    FROM (VALUES
        (N'vol.ha@ivan.org', N'Ha', N'Nguyen', N'0903555001', N'Female', CAST('2000-05-12' AS DATE), N'Ho Chi Minh City', N'17 Nguyen Thai Hoc, District 10', N'1,4,5', N'Pending', CAST('2026-03-13T19:30:00' AS DATETIME), NULL, NULL, NULL),
        (N'vol.minh@ivan.org', N'Minh', N'Le', N'0903666002', N'Male', CAST('1999-10-20' AS DATE), N'Ho Chi Minh City', N'80 Cach Mang Thang 8, District 3', N'2,6', N'Approved', CAST('2026-03-02T10:00:00' AS DATETIME), N'admin@ivan.org', CAST('2026-03-04T11:20:00' AS DATETIME), N'Approved after reviewing updated contact details.'),
        (N'vol.ngoc@ivan.org', N'Ngoc', N'Do', N'0903777003', N'Female', CAST('2001-07-01' AS DATE), N'Ho Chi Minh City', N'52 Xo Viet Nghe Tinh, Binh Thanh', N'5,8', N'Rejected', CAST('2026-03-03T15:45:00' AS DATETIME), N'admin@ivan.org', CAST('2026-03-05T09:30:00' AS DATETIME), N'Please provide a clearer address update before resubmitting.')
    ) AS seed(UserEmail, NewFirstName, NewLastName, NewPhone, NewGender, NewDateOfBirth, NewProvince, NewAddress, NewSkillIds, Status, RequestedAt, ReviewedByEmail, ReviewedAt, ReviewNote)
    JOIN #UserMap u ON u.Email = seed.UserEmail
    LEFT JOIN #UserMap reviewer ON reviewer.Email = seed.ReviewedByEmail;

    INSERT INTO dbo.OrganizationProfileUpdateRequests (
        UserId, OrganizationName, OrganizationType, EstablishedYear, TaxCode,
        BusinessLicenseNumber, RepresentativeName, RepresentativePosition, Phone, Address,
        Website, FacebookPage, Description, Status, RequestedAt, ReviewedBy, ReviewedAt, ReviewNote
    )
    SELECT u.UserId, seed.OrganizationName, seed.OrganizationType, seed.EstablishedYear, seed.TaxCode,
           seed.BusinessLicenseNumber, seed.RepresentativeName, seed.RepresentativePosition, seed.Phone, seed.Address,
           seed.Website, seed.FacebookPage, seed.Description, seed.Status, seed.RequestedAt, reviewer.UserId, seed.ReviewedAt, seed.ReviewNote
    FROM (VALUES
        (N'org.sunrise@ivan.org', N'Sunrise Charity Network', N'Nonprofit', 2015, N'0312345678', N'GP-2015-102', N'Nguyen Hong Anh', N'Program Director', N'0287300101', N'90 Dien Bien Phu, District 1, Ho Chi Minh City', N'https://sunrisecharity.org', N'https://facebook.com/sunrisecharityvn', N'Sunrise Charity Network wants to update its public address and expand the description for volunteer onboarding.', N'Pending', CAST('2026-03-14T09:15:00' AS DATETIME), NULL, NULL, NULL),
        (N'org.bluehope@ivan.org', N'Blue Hope Foundation', N'Foundation', 2018, N'0109988776', N'GP-2018-221', N'Tran Bao Vy', N'Executive Director', N'0247300202', N'25 Tran Duy Hung, Cau Giay, Ha Noi', N'https://bluehope.org.vn', N'https://facebook.com/bluehopefoundation', N'Blue Hope requested a profile refresh with a shorter public summary and new office address.', N'Rejected', CAST('2026-03-06T13:00:00' AS DATETIME), N'admin@ivan.org', CAST('2026-03-08T10:10:00' AS DATETIME), N'Please keep the updated description focused on community programs instead of fundraising copy.')
    ) AS seed(UserEmail, OrganizationName, OrganizationType, EstablishedYear, TaxCode, BusinessLicenseNumber, RepresentativeName, RepresentativePosition, Phone, Address, Website, FacebookPage, Description, Status, RequestedAt, ReviewedByEmail, ReviewedAt, ReviewNote)
    JOIN #UserMap u ON u.Email = seed.UserEmail
    LEFT JOIN #UserMap reviewer ON reviewer.Email = seed.ReviewedByEmail;

    COMMIT TRANSACTION;

    PRINT N'Realistic IVAN sample data inserted successfully.';
    PRINT N'Logins: admin@ivan.org / Admin@123, org.sunrise@ivan.org / Org@123, coord.nam@ivan.org / Coord@123, vol.ha@ivan.org / Volunteer@123.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorLine INT = ERROR_LINE();

    RAISERROR(N'ivan_bulk_test_data.sql failed at line %d: %s', 16, 1, @ErrorLine, @ErrorMessage);
END CATCH;
GO
