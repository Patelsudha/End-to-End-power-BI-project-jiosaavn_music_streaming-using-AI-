
select * from INFORMATION_SCHEMA.COLUMNS where table_name like 'dbo.dim_date'

select * from INFORMATION_SCHEMA.COLUMNS where table_name like 'dbo.dim_song'

select * from INFORMATION_SCHEMA.COLUMNS where table_name like 'dbo.dim_User '

select * from INFORMATION_SCHEMA.COLUMNS where table_name like 'dbo.fact_stream'


SELECT
    fs.stream_id,
    fs.date_id,
    dd.full_date,
    dd.[day],
    dd.[month],
    dd.[year],
    dd.[quarter],
    dd.month_name,
    dd.day_name,
    dd.is_weekend,
    dd.week_of_year,
    dd.is_holiday,

    fs.song_id,
    ds.song_name,
    ds.artist_name,
    ds.album_name,
    ds.genre,
    ds.language,
    ds.release_year,
    ds.duration_sec,
    ds.is_explicit,
    ds.label,

    fs.user_id,
    du.user_name,
    du.age_group,
    du.gender,
    du.city,
    du.state,
    du.country,
    du.subscription_type,
    du.device_type AS user_device_type,
    du.os_type AS user_os_type,

    fs.device_id,
    dv.device_type AS device_type_from_dim,
    dv.os_type AS os_type_from_dim,
    dv.browser,
    dv.app_version,

    fs.stream_timestamp,
    fs.stream_duration_sec,
    fs.is_completed,
    fs.is_skipped,
    fs.is_shuffle,
    fs.is_repeat,
    fs.playlist_id,
    fs.stream_source

INTO dbo.stream_combined
FROM dbo.fact_stream fs
LEFT JOIN dbo.dim_date dd
    ON fs.date_id = dd.date_id
LEFT JOIN dbo.dim_song ds
    ON fs.song_id = ds.song_id
LEFT JOIN dbo.dim_user du
    ON fs.user_id = du.user_id
LEFT JOIN dbo.dim_device dv
    ON fs.device_id = dv.device_id;

select * from dbo.stream_combined;