/*
 Navicat Premium Data Transfer

 Source Server         : LianChuangJie
 Source Server Type    : SQL Server
 Source Server Version : 12002000
 Source Host           : 152.136.120.86:1433
 Source Catalog        : LCJ_SAP360
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 12002000
 File Encoding         : 65001

 Date: 16/11/2022 18:27:16
*/


-- ----------------------------
-- Table structure for U_WebLogin
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[U_WebLogin]') AND type IN ('U'))
	DROP TABLE [dbo].[U_WebLogin]
GO

CREATE TABLE [dbo].[U_WebLogin] (
  [UserSign] bigint  NULL,
  [LoginTime] datetime  NULL,
  [LoginIP] nvarchar(255) COLLATE Chinese_PRC_CI_AS  NULL,
  [DocEntry] bigint  IDENTITY(1,1) NOT NULL
)
GO

ALTER TABLE [dbo].[U_WebLogin] SET (LOCK_ESCALATION = TABLE)
GO

EXEC sp_addextendedproperty
'MS_Description', N'员工编号',
'SCHEMA', N'dbo',
'TABLE', N'U_WebLogin',
'COLUMN', N'UserSign'
GO

EXEC sp_addextendedproperty
'MS_Description', N'登录时间',
'SCHEMA', N'dbo',
'TABLE', N'U_WebLogin',
'COLUMN', N'LoginTime'
GO

EXEC sp_addextendedproperty
'MS_Description', N'登录IP',
'SCHEMA', N'dbo',
'TABLE', N'U_WebLogin',
'COLUMN', N'LoginIP'
GO

EXEC sp_addextendedproperty
'MS_Description', N'自增长主键',
'SCHEMA', N'dbo',
'TABLE', N'U_WebLogin',
'COLUMN', N'DocEntry'
GO


-- ----------------------------
-- Auto increment value for U_WebLogin
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[U_WebLogin]', RESEED, 1)
GO

