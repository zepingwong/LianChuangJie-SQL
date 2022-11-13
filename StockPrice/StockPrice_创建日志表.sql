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

 Date: 13/11/2022 00:08:33
*/


-- ----------------------------
-- Table structure for U_SPAL
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[U_SPAL]') AND type IN ('U'))
	DROP TABLE [dbo].[U_SPAL]
GO

CREATE TABLE [dbo].[U_SPAL] (
  [DocEntry] bigint  IDENTITY(1,1) NOT NULL,
  [TriggerType] varchar(50) COLLATE Chinese_PRC_CI_AS  NULL,
  [StartTime] datetime  NULL,
  [EndTime] datetime  NULL,
  [Result] int  NULL,
  [TriggerName] varchar(255) COLLATE Chinese_PRC_CI_AS  NULL
)
GO

ALTER TABLE [dbo].[U_SPAL] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Auto increment value for U_SPAL
-- ----------------------------
DBCC CHECKIDENT ('[dbo].[U_SPAL]', RESEED, 35)
GO


-- ----------------------------
-- Primary Key structure for table U_SPAL
-- ----------------------------
ALTER TABLE [dbo].[U_SPAL] ADD CONSTRAINT [PK__U_SPAL__F4D96FAE45102188] PRIMARY KEY CLUSTERED ([DocEntry])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON [PRIMARY]
GO

