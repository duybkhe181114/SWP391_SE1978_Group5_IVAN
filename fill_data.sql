USE [master]
GO

SET NOCOUNT ON
GO

IF DB_ID(N'IVAN') IS NULL
BEGIN
    RAISERROR(N'Database IVAN does not exist. Run merged.sql first.', 16, 1)
    RETURN
END
GO

USE [IVAN]
GO

IF EXISTS (SELECT 1 FROM dbo.Users)
BEGIN
    PRINT N'Seed data skipped because dbo.Users already contains data.'
    RETURN
END
GO

BEGIN TRANSACTION

BEGIN TRY
    -- Base users
    INSERT INTO dbo.Users (Email, PasswordHash, IsActive, CreatedAt)
    VALUES
        (N'admin@ivan.org', N'hash_admin_001', 1, '2026-03-01T08:00:00'),
        (N'coord.nam@ivan.org', N'hash_coord_002', 1, '2026-03-01T08:05:00'),
        (N'coord.linh@ivan.org', N'hash_coord_003', 1, '2026-03-01T08:10:00'),
        (N'org.sunrise@ivan.org', N'hash_org_004', 1, '2026-03-01T08:15:00'),
        (N'vol.minh@ivan.org', N'hash_vol_005', 1, '2026-03-01T08:20:00'),
        (N'vol.ha@ivan.org', N'hash_vol_006', 1, '2026-03-01T08:25:00'),
        (N'vol.quan@ivan.org', N'hash_vol_007', 1, '2026-03-01T08:30:00'),
        (N'support.thao@ivan.org', N'hash_support_008', 1, '2026-03-01T08:35:00')

    INSERT INTO dbo.UserRoles (UserId, Role)
    VALUES
        (1, N'Admin'),
        (2, N'Coordinator'),
        (3, N'Coordinator'),
        (4, N'Organization'),
        (5, N'Volunteer'),
        (6, N'Volunteer'),
        (7, N'Volunteer'),
        (8, N'SupportRequester')

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
    VALUES
        (1, N'Admin', N'IVAN', N'0901000001', '1990-05-12', N'Male', N'https://example.com/avatar/admin.png', N'1 Nguyen Hue', N'Ben Nghe', N'Quan 1', N'Ho Chi Minh', N'700000', N'Tran Thi Mai', N'0901999999', '2026-03-01T08:00:00', '2026-03-10T09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Approved', NULL, NULL, NULL, NULL, N'System administrator account'),
        (2, N'Nam', N'Pham', N'0901000002', '1994-02-18', N'Male', N'https://example.com/avatar/nam.png', N'12 Le Loi', N'Ben Thanh', N'Quan 1', N'Ho Chi Minh', N'700000', N'Pham Thi Lan', N'0901888888', '2026-03-01T08:05:00', '2026-03-10T09:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Approved', NULL, NULL, NULL, NULL, N'Volunteer coordinator for urban events'),
        (3, N'Linh', N'Tran', N'0901000003', '1995-09-03', N'Female', N'https://example.com/avatar/linh.png', N'25 Tran Hung Dao', N'Ward 3', N'Go Vap', N'Ho Chi Minh', N'714000', N'Tran Van Duc', N'0901777777', '2026-03-01T08:10:00', '2026-03-10T09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Approved', NULL, NULL, NULL, NULL, N'Field coordinator focused on relief operations'),
        (4, N'Sunrise', N'Org', N'0901000004', NULL, N'Other', N'https://example.com/avatar/sunrise.png', N'88 Dien Bien Phu', N'Ward 21', N'Binh Thanh', N'Ho Chi Minh', N'723000', N'Nguyen Hong Anh', N'0901666666', '2026-03-01T08:15:00', '2026-03-10T09:15:00', N'Sunrise Charity Network', N'Nonprofit', 2018, N'TAX-998877', N'BLN-2026-001', N'Nguyen Hong Anh', N'Director', N'https://facebook.com/sunrisecharity', N'Approved', N'Organization profile reviewed and approved.', 1, '2026-03-05T14:00:00', N'https://sunrisecharity.org', N'Community nonprofit supporting health and emergency aid programs'),
        (5, N'Minh', N'Le', N'0901000005', '2000-01-20', N'Male', N'https://example.com/avatar/minh.png', N'7 Vo Van Tan', N'Ward 6', N'Quan 3', N'Ho Chi Minh', N'724000', N'Le Thi Hoa', N'0901555555', '2026-03-01T08:20:00', '2026-03-10T09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Approved', NULL, NULL, NULL, NULL, N'Volunteer with first aid background'),
        (6, N'Ha', N'Nguyen', N'0901000006', '2001-07-09', N'Female', N'https://example.com/avatar/ha.png', N'42 Phan Xich Long', N'Ward 2', N'Phu Nhuan', N'Ho Chi Minh', N'725000', N'Nguyen Thi Thu', N'0901444444', '2026-03-01T08:25:00', '2026-03-10T09:25:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Approved', NULL, NULL, NULL, NULL, N'Volunteer supporting logistics and media'),
        (7, N'Quan', N'Vo', N'0901000007', '1999-11-11', N'Male', N'https://example.com/avatar/quan.png', N'60 Cach Mang Thang 8', N'Ward 11', N'Quan 10', N'Ho Chi Minh', N'726000', N'Vo Thi Hanh', N'0901333333', '2026-03-01T08:30:00', '2026-03-10T09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Approved', NULL, NULL, NULL, NULL, N'Volunteer experienced in fundraising and tutoring'),
        (8, N'Thao', N'Bui', N'0901000008', '1992-04-25', N'Female', N'https://example.com/avatar/thao.png', N'15 Nguyen Van Cu', N'Ward 4', N'Quan 5', N'Ho Chi Minh', N'727000', N'Bui Van Son', N'0901222222', '2026-03-01T08:35:00', '2026-03-10T09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Approved', NULL, NULL, NULL, NULL, N'Citizen submitting support requests for local communities')

    INSERT INTO dbo.Skills (SkillName)
    VALUES
        (N'First Aid'),
        (N'Logistics'),
        (N'Fundraising'),
        (N'Photography'),
        (N'Teaching')

    INSERT INTO dbo.SupportCategories (Name)
    VALUES
        (N'Food and Essentials'),
        (N'Medical Support'),
        (N'Education'),
        (N'Disaster Relief')

    INSERT INTO dbo.VolunteerSkills (VolunteerId, SkillId)
    VALUES
        (5, 1),
        (5, 2),
        (6, 2),
        (6, 4),
        (7, 3),
        (7, 5)

    INSERT INTO dbo.VolunteerCoordinators (CoordinatorId, VolunteerId)
    VALUES
        (2, 5),
        (2, 6),
        (3, 7)

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
    VALUES
        (N'Sunrise Charity Network', N'Nonprofit organizing health outreach and emergency response campaigns.', N'02873000001', N'contact@sunrisecharity.org', N'88 Dien Bien Phu, Binh Thanh, Ho Chi Minh', N'https://sunrisecharity.org', 4, '2026-03-02T09:00:00', '2026-03-10T09:00:00', N'https://example.com/logo/sunrise.png'),
        (N'City Youth Volunteers', N'Volunteer group supporting education drives and donation events.', N'02873000002', N'hello@cityyouth.vn', N'120 Hai Ba Trung, Quan 1, Ho Chi Minh', N'https://cityyouth.vn', 1, '2026-03-02T09:15:00', '2026-03-10T09:15:00', N'https://example.com/logo/cityyouth.png')

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
    VALUES
        (1, N'Community Health Day', N'Free health checkups, medicine distribution, and community consultation.', N'Ward 21 Community House, Binh Thanh', 30, N'Published', '2026-04-05', '2026-04-05', '2026-03-05T10:00:00', '2026-03-10T10:00:00', N'https://example.com/event/health-day.jpg'),
        (2, N'Flood Relief Packing Drive', N'Prepare food boxes and emergency kits for flood-affected families.', N'City Youth Warehouse, Quan 7', 40, N'Open', '2026-04-12', '2026-04-13', '2026-03-06T11:00:00', '2026-03-10T11:00:00', N'https://example.com/event/flood-relief.jpg')

    INSERT INTO dbo.EventCoordinators (
        EventId,
        CoordinatorId,
        PromotedFromVolunteer,
        PromotedAt,
        PromotedBy,
        Status
    )
    VALUES
        (1, 2, 0, '2026-03-06T09:30:00', 4, N'Active'),
        (2, 2, 0, '2026-03-06T10:30:00', 1, N'Active'),
        (2, 3, 0, '2026-03-06T10:35:00', 1, N'Active')

    INSERT INTO dbo.EventRegistrations (
        EventId,
        VolunteerId,
        Status,
        AppliedAt,
        ReviewedAt,
        ReviewedBy,
        ReviewNote
    )
    VALUES
        (1, 5, N'Approved', '2026-03-07T09:00:00', '2026-03-08T10:00:00', 2, N'Strong first aid skillset, approved for onsite support.'),
        (2, 6, N'Pending', '2026-03-07T09:30:00', NULL, NULL, NULL),
        (2, 7, N'Approved', '2026-03-07T10:00:00', '2026-03-08T11:00:00', 3, N'Assigned to packing and donor communication team.')

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
    VALUES
        (1, 2, 5, N'Assist nurses with queue guidance and basic first-aid support.', N'Assigned', '2026-03-09T08:00:00', NULL, NULL, N'Report to the medical tent at 07:30.'),
        (2, 2, 6, N'Coordinate inbound supplies, labels, and transport checklists.', N'Assigned', '2026-03-09T08:30:00', NULL, NULL, N'Bring a laptop for stock tracking.'),
        (2, 3, 7, N'Support donation calls and package handoff logging.', N'Completed', '2026-03-09T09:00:00', '2026-04-13T17:30:00', '2026-04-13T18:00:00', N'Completed with high accuracy and good teamwork.')

    INSERT INTO dbo.Schedules (
        TaskId,
        WorkDate,
        StartTime,
        EndTime,
        Note,
        CreatedAt
    )
    VALUES
        (1, '2026-04-05', '07:30:00', '12:00:00', N'Morning medical support shift.', '2026-03-09T08:05:00'),
        (2, '2026-04-12', '08:00:00', '17:00:00', N'Warehouse packing preparation.', '2026-03-09T08:35:00'),
        (3, '2026-04-13', '08:00:00', '18:00:00', N'Final packing and distribution handoff.', '2026-03-09T09:05:00')

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
    VALUES
        (8, 1, N'Requesting food packages and basic living supplies for low-income households after factory shutdowns.', N'https://example.com/proof/support-001.jpg', N'Approved', 1, '2026-03-11T10:00:00', NULL, '2026-03-08T13:00:00', N'Essential food support for workers', N'High', N'Ward 4, District 5, Ho Chi Minh City', N'120 affected workers and families', 120, 35000000.00, N'support.thao@ivan.org', N'0901000008', N'Verified with local ward contact. Prioritize rice, milk, and dry foods.', '2026-03-11T10:15:00', 0),
        (8, 2, N'Need mobile health screening support for elderly residents with chronic illnesses.', N'https://example.com/proof/support-002.jpg', N'Pending', NULL, NULL, NULL, '2026-03-09T14:30:00', N'Mobile medical checkup session', N'Medium', N'Ward 11, District 10, Ho Chi Minh City', N'Elderly residents in neighborhood group 6', 45, 18000000.00, N'support.thao@ivan.org', N'0901000008', NULL, '2026-03-09T14:30:00', 0)

    INSERT INTO dbo.EventComments (
        EventId,
        UserId,
        Comment,
        Rating,
        CreatedAt,
        UpdatedAt,
        IsDeleted
    )
    VALUES
        (1, 5, N'Well organized event. The medical team and check-in flow were both very smooth.', 5, '2026-04-05T13:30:00', '2026-04-05T13:30:00', 0),
        (2, 7, N'Packing workflow was clear and the coordinators responded quickly when supplies changed.', 4, '2026-04-13T19:00:00', '2026-04-13T19:10:00', 0)

    INSERT INTO dbo.Notifications (
        UserId,
        Content,
        Type,
        ReferenceId,
        IsRead,
        CreatedAt
    )
    VALUES
        (5, N'Your registration for Community Health Day has been approved.', N'EventRegistration', 1, 1, '2026-03-08T10:05:00'),
        (6, N'Your application for Flood Relief Packing Drive is pending review.', N'EventRegistration', 2, 0, '2026-03-07T09:35:00'),
        (8, N'Your support request "Essential food support for workers" has been approved.', N'SupportRequest', 1, 0, '2026-03-11T10:20:00')

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
    VALUES
        (6, N'Ha', N'Nguyen', N'0901888006', N'Female', '2001-07-09', N'Ho Chi Minh', N'105 Nguyen Kiem, Phu Nhuan', N'2,4', N'Approved', '2026-03-10T16:00:00', 1, '2026-03-11T09:00:00', N'Phone number and address updated successfully.')

    COMMIT TRANSACTION
    PRINT N'Seed data inserted successfully into IVAN.'
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    THROW
END CATCH
GO
