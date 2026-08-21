
-- 2.1 dim_device
INSERT INTO dbo.dim_device (device_id, device_type, os_type, browser, app_version)
VALUES
(1,'Mobile','Android',NULL,'8.7.1'),
(2,'Mobile','iOS',NULL,'8.6.4'),
(3,'Tablet','Android',NULL,'8.5.9'),
(4,'Tablet','iOS',NULL,'8.5.8'),
(5,'Desktop','Windows','Chrome','7.4.2'),
(6,'Desktop','Windows','Edge','7.4.1'),
(7,'Desktop','Web','Chrome','Web-1.0'),
(8,'Desktop','Web','Firefox','Web-1.0'),
(9,'Smart TV','Web',NULL,'TV-2.1'),
(10,'Smart TV','Android',NULL,'TV-2.0'),
(11,'Mobile','Android',NULL,'8.8.0'),
(12,'Mobile','iOS',NULL,'8.8.0'),
(13,'Tablet','Android',NULL,'8.7.0'),
(14,'Desktop','Windows','Chrome','7.5.0'),
(15,'Mobile','Android',NULL,'8.9.0');


-- 2.2 dim_date (2023-01-01 to 2026-12-31)
;WITH n AS (
    SELECT TOP (1461) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
),
d AS (
    SELECT DATEADD(DAY, n, CAST('2023-01-01' AS DATE)) AS dt
    FROM n
)
INSERT INTO dbo.dim_date
(
    date_id, full_date, [day], [month], [year], [quarter],
    month_name, day_name, is_weekend, week_of_year, is_holiday
)
SELECT
    CONVERT(INT, FORMAT(dt,'yyyyMMdd')) AS date_id,
    dt,
    DAY(dt),
    MONTH(dt),
    YEAR(dt),
    DATEPART(QUARTER, dt),
    DATENAME(MONTH, dt),
    DATENAME(WEEKDAY, dt),
    CASE WHEN DATEPART(WEEKDAY, dt) IN (1,7) THEN 1 ELSE 0 END,
    DATEPART(WEEK, dt),
    CASE WHEN MONTH(dt) = 1 AND DAY(dt) IN (1,26) THEN 1 ELSE 0 END
FROM d;



-- 2.3 dim_song (300 songs)
;WITH n AS (
    SELECT TOP (300) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
)
INSERT INTO dbo.dim_song
(
    song_id, song_name, artist_name, album_name, genre,
    language, release_year, duration_sec, is_explicit, label
)
SELECT
    n,
    CONCAT('Song ', RIGHT('000' + CAST(n AS VARCHAR(3)), 3)),
    CASE (n % 5)
        WHEN 0 THEN 'Arijit Singh'
        WHEN 1 THEN 'Shreya Ghoshal'
        WHEN 2 THEN 'AP Dhillon'
        WHEN 3 THEN 'A. R. Rahman'
        ELSE 'Neha Kakkar'
    END,
    CASE (n % 4)
        WHEN 0 THEN 'Love Hits'
        WHEN 1 THEN 'Monsoon Mix'
        WHEN 2 THEN 'Road Trip'
        ELSE 'Chill Vibes'
    END,
    CASE (n % 6)
        WHEN 0 THEN 'Bollywood'
        WHEN 1 THEN 'Pop'
        WHEN 2 THEN 'Rock'
        WHEN 3 THEN 'Classical'
        WHEN 4 THEN 'Devotional'
        ELSE 'Indie'
    END,
    CASE (n % 5)
        WHEN 0 THEN 'Hindi'
        WHEN 1 THEN 'English'
        WHEN 2 THEN 'Punjabi'
        WHEN 3 THEN 'Tamil'
        ELSE 'Telugu'
    END,
    CAST(2014 + (n % 12) AS NVARCHAR(20)),
    120 + (ABS(CHECKSUM(NEWID())) % 220),
    CASE WHEN n % 5 = 0 THEN 1 ELSE 0 END,
    CASE (n % 4)
        WHEN 0 THEN 'T-Series'
        WHEN 1 THEN 'Zee Music'
        WHEN 2 THEN 'Sony Music'
        ELSE 'Universal'
    END
FROM n;


-- 2.4 dim_user (400 users)
;WITH n AS (
    SELECT TOP (400) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
)
INSERT INTO dbo.dim_user
(
    user_id, user_name, age_group, gender, city, state,
    country, subscription_type, device_type, os_type
)
SELECT
    n,
    CONCAT('User ', n),
    CASE (n % 4)
        WHEN 0 THEN '18-24'
        WHEN 1 THEN '25-34'
        WHEN 2 THEN '35-44'
        ELSE '45-54'
    END,
    CASE (n % 4)
        WHEN 0 THEN 'Male'
        WHEN 1 THEN 'Female'
        WHEN 2 THEN 'Other'
        ELSE 'M'
    END,
    CASE (n % 8)
        WHEN 0 THEN 'Indore'
        WHEN 1 THEN 'Bhopal'
        WHEN 2 THEN 'Mumbai'
        WHEN 3 THEN 'Delhi'
        WHEN 4 THEN 'Bangalore'
        WHEN 5 THEN 'Pune'
        WHEN 6 THEN 'Chennai'
        ELSE 'Hyderabad'
    END,
    CASE (n % 8)
        WHEN 0 THEN 'Madhya Pradesh'
        WHEN 1 THEN 'Madhya Pradesh'
        WHEN 2 THEN 'Maharashtra'
        WHEN 3 THEN 'Delhi'
        WHEN 4 THEN 'Karnataka'
        WHEN 5 THEN 'Maharashtra'
        WHEN 6 THEN 'Tamil Nadu'
        ELSE 'Telangana'
    END,
    'India',
    CASE (n % 4)
        WHEN 0 THEN 'Free'
        WHEN 1 THEN 'Premium'
        WHEN 2 THEN 'Family'
        ELSE 'Student'
    END,
    CASE (n % 4)
        WHEN 0 THEN 'Mobile'
        WHEN 1 THEN 'Desktop'
        WHEN 2 THEN 'Tablet'
        ELSE 'Smart TV'
    END,
    CASE (n % 4)
        WHEN 0 THEN 'Android'
        WHEN 1 THEN 'Windows'
        WHEN 2 THEN 'iOS'
        ELSE 'Web'
    END
FROM n;

