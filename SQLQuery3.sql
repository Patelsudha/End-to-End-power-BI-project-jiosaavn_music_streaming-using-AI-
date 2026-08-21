
-- =========================================================
-- PART 3: INSERT DATA INTO FACT TABLE
-- =========================================================

;WITH n AS (
    SELECT TOP (10000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
)
INSERT INTO dbo.fact_stream
(
    stream_id, date_id, song_id, user_id, device_id,
    stream_timestamp, stream_duration_sec, is_completed, is_skipped,
    is_shuffle, is_repeat, playlist_id, stream_source
)
SELECT
    n AS stream_id,
    20230101 + (ABS(CHECKSUM(NEWID())) % 1461) AS date_id,
    1 + (ABS(CHECKSUM(NEWID())) % 300) AS song_id,
    1 + (ABS(CHECKSUM(NEWID())) % 400) AS user_id,
    1 + (ABS(CHECKSUM(NEWID())) % 15) AS device_id,
    CONVERT(NVARCHAR(19), DATEADD(MINUTE, n, '2024-01-01T00:00:00'), 120) AS stream_timestamp,
    30 + (ABS(CHECKSUM(NEWID())) % 360) AS stream_duration_sec,
    CASE WHEN n % 3 = 0 THEN 1 ELSE 0 END AS is_completed,
    CASE WHEN n % 5 = 0 THEN 1 ELSE 0 END AS is_skipped,
    CASE WHEN n % 2 = 0 THEN 1 ELSE 0 END AS is_shuffle,
    CASE WHEN n % 7 = 0 THEN 1 ELSE 0 END AS is_repeat,
    CASE WHEN n % 9 = 0 THEN NULL ELSE 1 + (ABS(CHECKSUM(NEWID())) % 250) END AS playlist_id,
    CASE (n % 6)
        WHEN 0 THEN 'Home'
        WHEN 1 THEN 'Search'
        WHEN 2 THEN 'Playlist'
        WHEN 3 THEN 'Radio'
        WHEN 4 THEN 'Artist Page'
        ELSE 'Recommendations'
    END AS stream_source
FROM n;
GO

select * from dbo.fact_stream

select * from [dbo].[dim_date]

select * from [dbo].[dim_device]
select * from [dbo].[dim_user]

select * from [dbo].[dim_song]