CREATE TABLE [dbo].[U_SRAL] (
  [DocEntry] bigint  IDENTITY(1,1) NOT NULL,
  [TriggerType] varchar(50) COLLATE Chinese_PRC_CI_AS  NULL,
  [StartTime] datetime  NULL,
  [EndTime] datetime  NULL,
  [Result] int  NULL,
  [TriggerName] varchar(255) COLLATE Chinese_PRC_CI_AS  NULL
)