USE [master]
GO
/****** Object:  Database [Globo-HC]    Script Date: 1/31/2024 5:22:52 PM ******/
CREATE DATABASE [Globo-HC]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Globo-HC', FILENAME = N'/var/opt/mssql/data/Globo-HC.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Globo-HC_log', FILENAME = N'/var/opt/mssql/data/Globo-HC_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Globo-HC] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Globo-HC].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Globo-HC] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Globo-HC] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Globo-HC] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Globo-HC] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Globo-HC] SET ARITHABORT OFF 
GO
ALTER DATABASE [Globo-HC] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Globo-HC] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Globo-HC] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Globo-HC] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Globo-HC] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Globo-HC] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Globo-HC] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Globo-HC] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Globo-HC] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Globo-HC] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Globo-HC] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Globo-HC] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Globo-HC] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Globo-HC] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Globo-HC] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Globo-HC] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Globo-HC] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Globo-HC] SET RECOVERY FULL 
GO
ALTER DATABASE [Globo-HC] SET  MULTI_USER 
GO
ALTER DATABASE [Globo-HC] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Globo-HC] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Globo-HC] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Globo-HC] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Globo-HC] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Globo-HC] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Globo-HC', N'ON'
GO
ALTER DATABASE [Globo-HC] SET QUERY_STORE = ON
GO
ALTER DATABASE [Globo-HC] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Globo-HC]
GO
/****** Object:  UserDefinedFunction [dbo].[HashWithSalt]    Script Date: 1/31/2024 5:22:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[HashWithSalt]
(
    @plainText nvarchar(max), 
	@salt uniqueidentifier
)
RETURNS nvarchar(64) 
AS
BEGIN
    RETURN CONVERT(nvarchar(64), HASHBYTES('SHA2_256', @plainText + CAST(@salt as nvarchar(36))), 2);
END;
GO
/****** Object:  Table [dbo].[Activities]    Script Date: 1/31/2024 5:22:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Activities](
	[activity_id] [tinyint] IDENTITY(1,1) NOT NULL,
	[title] [varchar](50) NOT NULL,
	[start_date] [date] NOT NULL,
	[end_date] [date] NOT NULL,
 CONSTRAINT [PK_Activities] PRIMARY KEY CLUSTERED 
(
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ActivitiesEmployees]    Script Date: 1/31/2024 5:22:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActivitiesEmployees](
	[activity_id] [tinyint] NOT NULL,
	[employee_id] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 1/31/2024 5:22:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[employee_id] [tinyint] NOT NULL,
	[first_name] [varchar](50) NOT NULL,
	[last_name] [varchar](50) NOT NULL,
	[age] [tinyint] NULL,
	[gender] [varchar](50) NOT NULL,
	[department] [varchar](50) NOT NULL,
	[salary] [int] NOT NULL,
	[username] [varchar](50) NULL,
	[password] [varchar](64) NULL,
	[salt] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[employee_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[import]    Script Date: 1/31/2024 5:22:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[import](
	[id] [nvarchar](255) NOT NULL,
	[firstname] [nvarchar](255) NULL,
	[lastname] [nvarchar](255) NULL,
	[age] [nvarchar](255) NULL,
	[gender] [nvarchar](255) NULL,
	[dept] [nvarchar](255) NULL,
	[salary] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patients]    Script Date: 1/31/2024 5:22:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patients](
	[patient_id] [money] NOT NULL,
	[patient_name] [nvarchar](50) NOT NULL,
	[gender] [nvarchar](50) NOT NULL,
	[date_of_birth] [date] NOT NULL,
	[visit_date] [date] NOT NULL,
	[symptoms] [nvarchar](50) NOT NULL,
	[diagnosis] [nvarchar](50) NOT NULL,
	[medication] [nvarchar](50) NOT NULL,
	[dosage] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Patients] PRIMARY KEY CLUSTERED 
(
	[patient_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Employees] ADD  CONSTRAINT [DF_Employees_age]  DEFAULT ((0)) FOR [age]
GO
ALTER TABLE [dbo].[ActivitiesEmployees]  WITH CHECK ADD  CONSTRAINT [FK_ActivitiesEmployees_Activities] FOREIGN KEY([activity_id])
REFERENCES [dbo].[Activities] ([activity_id])
GO
ALTER TABLE [dbo].[ActivitiesEmployees] CHECK CONSTRAINT [FK_ActivitiesEmployees_Activities]
GO
ALTER TABLE [dbo].[ActivitiesEmployees]  WITH CHECK ADD  CONSTRAINT [FK_ActivitiesEmployees_Employees] FOREIGN KEY([employee_id])
REFERENCES [dbo].[Employees] ([employee_id])
GO
ALTER TABLE [dbo].[ActivitiesEmployees] CHECK CONSTRAINT [FK_ActivitiesEmployees_Employees]
GO
/****** Object:  StoredProcedure [dbo].[ExecuteImport]    Script Date: 1/31/2024 5:22:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ExecuteImport] AS
/* Add only new employees */

BEGIN TRANSACTION
	BEGIN TRY 
		INSERT INTO Employees (employee_id, first_name, last_name, age, gender, department, salary)
		SELECT CONVERT(tinyint, I.id) as employee_id, 
			I.firstname as first_name,
			I.lastname as last_name, 
			convert(tinyint, i.age) as age,
			i.gender,
			i.dept as department, 
			convert(int, i.salary) as salary
		FROM import I LEFT JOIN Employees E ON CONVERT(tinyint, I.id) = E.employee_id WHERE e.employee_id IS NULL

		DECLARE @nullAgeCount int

		SELECT @nullAgeCount = COUNT(*) FROM Import WHERE Age IS NULL

		IF (@nullAgeCount > 0)
		BEGIN 
			DECLARE @errorMessage nvarchar(255)

			SET @errorMessage = N'There are ' + CONVERT(varchar(5), @nullAgeCount) + ' rows with null ages';

			THROW 52112, @errorMessage, 1
		END

		SAVE TRAN InsertsComplete
	END TRY
	BEGIN CATCH
		DECLARE @localErrorMessage nvarchar(255),  @errorSeverity int, @errorState int, @ErrorNumber int
		SELECT @localErrorMessage = ERROR_MESSAGE(), @errorSeverity = ERROR_SEVERITY(), @errorState = ERROR_STATE(), @ErrorNumber = ERROR_NUMBER()

		If (@ErrorNumber = 52112)
		BEGIN
			-- perform whatever actions we want to handle the null ages
			PRINT 'NULL AGES'
			SAVE TRAN InsertsComplete
		END
		ELSE
		BEGIN
			ROLLBACK;
			THROW
		END
	END CATCH;

	/* Delete fired employees */
	DELETE FROM Employees WHERE employee_id in (SELECT employee_id FROM Employees E LEFT JOIN Import I ON (employee_id = CONVERT(tinyint, I.id)) WHERE I.id IS NULL)

	--SAVE TRAN DeletesComplete

	UPDATE Employees  SET
	first_name = i.firstname, 
	last_name = i.lastname, 
	age = convert(tinyint, i.age),
	gender = i.gender,
	department = i.dept, 
	salary = convert(int, i.salary)
	FROM Employees E JOIN import i ON e.employee_id = Convert(tinyint, i.id)
	WHERE 
	E.first_name <> i.firstname OR 
	E.last_name <> i.lastname OR
	E.age <> convert(tinyint, i.age) OR
	E.gender <> i.gender OR
	E.department <> i.dept OR
	E.salary <> convert(int, i.salary)

	--SAVE TRAN UpdatesComplete

COMMIT;
GO
USE [master]
GO
ALTER DATABASE [Globo-HC] SET  READ_WRITE 
GO
