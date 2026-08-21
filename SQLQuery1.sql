

CREATE DATABASE JioSaavn;

use [JioSaavn]

DROP TABLE IF EXISTS dbo.fact_stream;
DROP TABLE IF EXISTS dbo.dim_date;
DROP TABLE IF EXISTS dbo.dim_song;
DROP TABLE IF EXISTS dbo.dim_user;
DROP TABLE IF EXISTS dbo.dim_device;
GO

CREATE TABLE dbo.dim_date (
    date_id INT NOT NULL PRIMARY KEY,          -- YYYYMMDD
    full_date DATE NULL,                       -- actual date
    [day] TINYINT NULL,                        -- day of month
    [month] TINYINT NULL,                      -- month number
    [year] SMALLINT NULL,                      -- year
    [quarter] TINYINT NULL,                    -- quarter number
    month_name NVARCHAR(20) NULL,              -- month name
    day_name NVARCHAR(20) NULL,                -- weekday name
    is_weekend BIT NULL,                       -- weekend flag
    week_of_year TINYINT NULL,                 -- week number
    is_holiday BIT NULL                        -- holiday flag
);
GO

CREATE TABLE dbo.dim_song (
    song_id INT NOT NULL PRIMARY KEY,
    song_name NVARCHAR(200) NULL,
    artist_name NVARCHAR(150) NULL,
    album_name NVARCHAR(150) NULL,
    genre NVARCHAR(50) NULL,
    language NVARCHAR(50) NULL,
    release_year NVARCHAR(20) NULL,
    duration_sec INT NULL,
    is_explicit BIT NULL,
    label NVARCHAR(100) NULL
);
GO

CREATE TABLE dbo.dim_user (
    user_id INT NOT NULL PRIMARY KEY,
    user_name NVARCHAR(120) NULL,
    age_group NVARCHAR(50) NULL,
    gender NVARCHAR(20) NULL,
    city NVARCHAR(100) NULL,
    state NVARCHAR(100) NULL,
    country NVARCHAR(50) NULL,
    subscription_type NVARCHAR(20) NULL,
    device_type NVARCHAR(20) NULL,
    os_type NVARCHAR(20) NULL
);
GO

CREATE TABLE dbo.dim_device (
    device_id INT NOT NULL PRIMARY KEY,
    device_type NVARCHAR(20) NOT NULL,
    os_type NVARCHAR(20) NOT NULL,
    browser NVARCHAR(50) NULL,
    app_version NVARCHAR(20) NULL
);
GO

CREATE TABLE dbo.fact_stream (
    stream_id BIGINT NOT NULL,
    date_id INT NULL,
    song_id INT NULL,
    user_id INT NULL,
    device_id INT NULL,
    stream_timestamp NVARCHAR(30) NULL,
    stream_duration_sec INT NULL,
    is_completed BIT NULL,
    is_skipped BIT NULL,
    is_shuffle BIT NULL,
    is_repeat BIT NULL,
    playlist_id INT NULL,
    stream_source NVARCHAR(30) NULL,
    CONSTRAINT PK_fact_stream PRIMARY KEY (stream_id)
);

