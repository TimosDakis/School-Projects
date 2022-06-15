/*
    Template for Creating Table
    Note: You will have to properly add all constraints, defaults, etc. after via UI
    Note2: There are 3 columns you change by default, add/remove those as needed
    Note3: Do not remove columns that are not generically written (e.g. the UserAuthorizationKey column line)
    Note4: the "[sdKeyNumeric].[SurrogateKeyInt] IDENTITY(1,1) NOT NULL" is the column for the primary key
    Note5: MAKE SURE TO REPLACE EVERYTHING PROPERLY
        • Worst case scenario, drop table and then remake it
*/

CREATE TABLE [Data].[TableName](
	[PrimaryKeyName] [sdKeyNumeric].[SurrogateKeyInt] IDENTITY(1,1) NOT NULL,
	[Column1] [UDTsSchema].[UDTName] NOT NULL,
    [Column2] [UDTsSchema].[UDTName] NOT NULL,
    [Column3] [UDTsSchema].[UDTName] NOT NULL,
	[UserAuthorizationKey] [sdKeyNumeric].[SurrogateKeyInt] NOT NULL,
	[DateAdded] [dDateTime].[DateYYYYMMDD] NOT NULL,
	[DateOfLastUpdate] [dDateTime].[DateYYYYMMDD] NOT NULL
 CONSTRAINT [PK_TableName] PRIMARY KEY CLUSTERED 
(
	[PrimaryKeyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/*
    Template for adding UNIQUE Constraints
*/
ALTER TABLE [SchemaName].[TableName]
ADD CONSTRAINT AK_ColumnName UNIQUE (ColumnName)
GO

/*
    Template for adding FOREIGN KEYS
*/
ALTER TABLE [ChildSchemaName].[ChildTableName]
ADD CONSTRAINT FK_ChildTableName_ParentTableName
    FOREIGN KEY (ChildColumnName)
    REFERENCES [ParentSchemaName].[ParentTableName] (ParentColumnName);