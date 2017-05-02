Use master;
-- drop PurpleBoxDVD database if it exists
If EXISTS (SELECT * from sys.sysdatabases where name = 'PurpleBoxDVD')
	Drop DATABASE PurpleBoxDVD;
--create PurpleBoxDVD database
Create [PurpleBoxDVD]
On Primary
(NAME = N'PurpleBoxDVD' , FILENAME = 
N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\PurpleBoxDVD.mdf',
SIZE = 5120KB, FILEGROWTH = 1024KB) 
LOG ON 
(NAME = N'PurpleBoxDVDLog' , FILENAME =
N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\PurpleBoxDVDLog.ldf'
SIZE = 2048KB, FILEGROWTH = 10%);
Go
--Attach to New Database
Use PurpleBoxDVD;
----------------Drop all tables if they exist------------------------
If EXISTS (SELECT * FROM sys.tables WHERE NAME = N'PbUser')
	DROP TABLE PbUser;
-- We do this for all tables in the database

------------------------Create ALL TABLES----------------------------
CREATE TABLE PbUser
(
	pbUser_id int IDENTITY(1,1) NOT NULL
	pbUserID nvarchar(25) NOT NULL,
	userFirstName nvarchar(25) NOT NULL,
	userLastName nvarchar(25) NOT NULL,
	userType nvarchar(1) NOT NULL,
	userPassword nvarchar(20) NOT NULL,
	secQuestion nvarchar(255) NOT NULL,
	secAnswer nvarchar(255) NOT NULL,
	fees double(4,2) NULL,
	userStatus nvarchar(1) NOT NULL,
	userPrimaryPhone nvarchar(12) NOT NULL,
	userOtherPhone nvarchar(12) NULL,
	custType nvarchar(1) NOT NULL
);

Create TABLE PbMovie
(
	pbMovie_id int IDENTITY(1,1) NOT NULL,
	pbMovieID nvarchar(25) NOT NULL,
	movieTitle nvarchar(255) NOT NULL,
	keywords nvarchar(255) NULL,
	genre_id int NOT NULL,
	lastChangedBy nvarchar(25) NOT NULL,
	lastChangedOn nvarchar(25) NOT NULL
);

Create TABLE PbMovieGenre
(
	pbMovie_id int NOT NULL,
	pbGenre_id int NOT NULL
);

Create TABLE PbGenres
(
	pbGenre_id int IDENTITY (1,1) NOT NULL,
	genre nvarchar(20) NOT NULL
);

Create TABLE PbMovieActor
(
	pbMovie_id int NOT NULL,
	pbActor_id int NOT NULL
);

Create TABLE PbMovieDirector
(
	pbMovie_id int NOT NULL,
	pbDirector_id int NOT NULL
);

Create TABLE PbActor
(
	pbActor_id int IDENTITY (1,1) NOT NULL,
	actorFirstName nvarchar (25) NOT NULL,
	actorMiddleName nvarchar (25) NULL,
	actorLastName nvarchar (25) NOT NULL
);

Create TABLE PbDirector
(
	pbDirector_id int IDENTITY (1,1) NOT NULL,
	directorFirstName nvarchar (25) NOT NULL,
	directorMiddleName nvarchar (25) NULL,
	directorLastName nvarchar (25) NOT NULL
);

Create TABLE PbMovieRequest
(
	pbMovieRequest_id int IDENTITY (1,1) NOT NULL,
	pbUser_id int NOT NULL,
	pbMovie_id int NOT NULL,
	MovieRequestDate DateTime NOT NULL,
	MovieFormat varchar(1) NOT NULL
);

Create TABLE PbMovieItem
(
	pbMovie_id int NOT NULL,
	pbCopyNum int IDENTITY (1,1) NOT NULL,
	MovieFormat varchar(1) NOT NULL
);

Create TABLE PbRental
(
	pbRental_id int IDENTITY (1,1) NOT NULL,
	pbUser_id int NOT NULL,
	pbMovie_id int NOT NULL,
	pbCopyNum int NOT NULL,
	rentalDate DateTime NOT NULL,
	returnDate DateTime NULL
);


-----------------SET PK, AK, FK Conctraints---------------------
---PbUser Table---
--Primary Key
ALTER TABLE PbUser
	ADD CONSTRAINT PK_PbUser
	Primary KEY CLUSTERED (pbUser_id);
---Altername Key
ALTER TABLE PbUser
	ADD CONSTRAINT AK_PbUser_pbUserID
	UNIQUE(pbUserID);

----- Foreign Key ----------
ALTER TABLE pbMovieItem
	ADD CONSTRAINT FK_PbMovieItem_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);
