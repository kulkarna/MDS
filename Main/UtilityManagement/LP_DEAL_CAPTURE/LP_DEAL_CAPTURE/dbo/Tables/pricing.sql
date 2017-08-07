CREATE TABLE [dbo].[pricing] (
    [pricing_id]        INT           IDENTITY (1, 1) NOT NULL,
    [retail_mkt_id]     CHAR (2)      CONSTRAINT [DF_pricing_retail_mkt_id] DEFAULT ('') NOT NULL,
    [utility_id]        VARCHAR (20)  CONSTRAINT [DF_pricing_utility_id] DEFAULT ('') NOT NULL,
    [display_name]      VARCHAR (100) CONSTRAINT [DF_Table_1_file_name] DEFAULT ('') NOT NULL,
    [file_name]         VARCHAR (200) CONSTRAINT [DF_pricing_file_name] DEFAULT ('') NOT NULL,
    [file_path]         VARCHAR (200) CONSTRAINT [DF_pricing_files_file_path] DEFAULT ('') NOT NULL,
    [link]              VARCHAR (200) CONSTRAINT [DF_pricing_files_link] DEFAULT ('') NOT NULL,
    [file_type]         INT           CONSTRAINT [DF_pricing_file_type] DEFAULT ((0)) NOT NULL,
    [has_sub_menu]      TINYINT       CONSTRAINT [DF_pricing_has_sub_menu] DEFAULT ((0)) NOT NULL,
    [menu_level]        INT           CONSTRAINT [DF_pricing_menu_level] DEFAULT ((0)) NOT NULL,
    [pricing_id_parent] INT           CONSTRAINT [DF_pricing_file_is_node] DEFAULT ((0)) NOT NULL
);

