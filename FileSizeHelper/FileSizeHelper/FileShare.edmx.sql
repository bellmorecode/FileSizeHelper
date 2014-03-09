
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 02/17/2014 11:46:06
-- Generated from EDMX file: c:\users\gferrie\desktop\FileSizeHelper\FileSizeHelper\FileShare.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [FileSizes_Dev];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_JobFileLog]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[FileLogs] DROP CONSTRAINT [FK_JobFileLog];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FileLogs]', 'U') IS NOT NULL
    DROP TABLE [dbo].[FileLogs];
GO
IF OBJECT_ID(N'[dbo].[Jobs]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Jobs];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'FileLogs'
CREATE TABLE [dbo].[FileLogs] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [FullPath] nvarchar(max)  NOT NULL,
    [Directory] nvarchar(max)  NOT NULL,
    [FileName] nvarchar(max)  NOT NULL,
    [Extension] nvarchar(max)  NOT NULL,
    [Modified] datetime  NULL,
    [FileSize] bigint  NOT NULL,
    [Job_Id] int  NOT NULL
);
GO

-- Creating table 'Jobs'
CREATE TABLE [dbo].[Jobs] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Title] nvarchar(max)  NOT NULL,
    [RunDate] datetime  NULL,
    [IsCompleted] bit  NOT NULL,
    [SearchPath] nvarchar(max)  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'FileLogs'
ALTER TABLE [dbo].[FileLogs]
ADD CONSTRAINT [PK_FileLogs]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Jobs'
ALTER TABLE [dbo].[Jobs]
ADD CONSTRAINT [PK_Jobs]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [Job_Id] in table 'FileLogs'
ALTER TABLE [dbo].[FileLogs]
ADD CONSTRAINT [FK_JobFileLog]
    FOREIGN KEY ([Job_Id])
    REFERENCES [dbo].[Jobs]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_JobFileLog'
CREATE INDEX [IX_FK_JobFileLog]
ON [dbo].[FileLogs]
    ([Job_Id]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------