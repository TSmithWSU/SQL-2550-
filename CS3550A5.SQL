-- PurpleBoxDVD create script
-- CS3550 Spring 2016
-- <Tyler Smith>

Use master;
-- drop PurpleBoxDVD database if it exists
If EXISTS (SELECT * from sys.sysdatabases where name = 'PurpleBoxDVD')
	Drop DATABASE PurpleBoxDVD;
--create PurpleBoxDVD database
Create DATABASE [PurpleBoxDVD]
On Primary
( NAME = N'PurpleBoxDVD' , FILENAME = 
N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\PurpleBoxDVD.mdf',
SIZE = 5120KB, FILEGROWTH = 1024KB) 
LOG ON 
( NAME = N'PurpleBoxDVDLog' , FILENAME =
N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\PurpleBoxDVDLog.ldf',
SIZE = 2048KB, FILEGROWTH = 10%);
Go
--Attach to New Database
Use PurpleBoxDVD;
----------------Drop all tables if they exist------------------------
If EXISTS (SELECT * FROM sys.tables WHERE NAME = N'PbMovieActor')
	DROP TABLE PbMovieActor;

If EXISTS (SELECT * FROM sys.tables WHERE NAME = N'PbMovieDirector')
	DROP TABLE PbMovieDirector;

If EXISTS (SELECT * FROM sys.tables WHERE NAME = N'PbMovieGenre')
	DROP TABLE PbMovieGenre;

If EXISTS (SELECT * FROM sys.tables WHERE NAME = N'PbGenre')
	DROP TABLE PbGenre;

If EXISTS (SELECT * FROM sys.tables WHERE NAME = N'PbActor')
	DROP TABLE PbActor;

If EXISTS (SELECT * FROM sys.tables WHERE NAME = N'PbDirector')
	DROP TABLE PbDirector;

If EXISTS (SELECT * FROM sys.tables WHERE NAME = N'PbMovieRequest')
	DROP TABLE PbMovieRequest;

If EXISTS (SELECT * FROM sys.tables WHERE NAME = N'PbRental')
	DROP TABLE PbRental;

If EXISTS (SELECT * FROM sys.tables WHERE NAME = N'PbMovieItem')
	DROP TABLE PbMovieItem;

If EXISTS (SELECT * FROM sys.tables WHERE NAME = N'PbUser')
	DROP TABLE PbUser;

If EXISTS (SELECT * FROM sys.tables WHERE NAME = N'PbMovie')
	DROP TABLE PbMovie;







-- We do this for all tables in the database

------------------------Create ALL TABLES----------------------------
CREATE TABLE PbUser
(
	pbUser_id int IDENTITY(1,1) NOT NULL,
	pbUserID nvarchar(25) NOT NULL,
	userFirstName nvarchar(25) NOT NULL,
	userLastName nvarchar(25) NOT NULL,
	userType nvarchar(1) NOT NULL,
	userPassword nvarchar(20) NOT NULL,
	secQuestion nvarchar(255) NOT NULL,
	secAnswer nvarchar(255) NOT NULL,
	fees smallmoney NULL,
	userStatus nvarchar(1) NOT NULL,
	userPrimaryPhone nvarchar(12) NOT NULL,
	userOtherPhone nvarchar(12) NULL,
	custType nvarchar(1) NOT NULL
);

Create TABLE PbMovie
(
	pbMovie_id int IDENTITY(1,1) NOT NULL,
	MovieID nvarchar(25) NOT NULL,
	movieTitle nvarchar(255) NOT NULL,
	keywords nvarchar(255) NULL,
	lastChangedBy nvarchar(25) NOT NULL,
	lastChangedOn nvarchar(25) NOT NULL
);

Create TABLE PbMovieGenre
(
	pbMovie_id int NOT NULL,
	pbGenre_id int NOT NULL
);

Create TABLE PbGenre
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
	MovieFormat varchar(3) NOT NULL
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

--Primary Key ---------------------
---PbUser Table---
ALTER TABLE PbUser
	ADD CONSTRAINT PK_PbUser
	Primary KEY CLUSTERED (pbUser_id);

----PbRental Table ---
ALTER TABLE PbRental
	ADD CONSTRAINT PK_PbRental
	Primary KEY CLUSTERED (pbRental_id);


---PbMovieItem Table ---

ALTER TABLE PbMovieItem
	ADD CONSTRAINT PK_PbMovieItem
	Primary KEY CLUSTERED (pbMovie_id, pbCopyNum);
	

---PbMovie Table ---
ALTER TABLE PbMovie
	ADD CONSTRAINT PK_PbMovie
	Primary KEY CLUSTERED (pbMovie_id);


---PbActor Table ----

ALTER TABLE PbActor
	ADD CONSTRAINT PK_PbActor
	Primary KEY CLUSTERED (pbActor_id);

--- PbDirector Table ----

ALTER TABLE PbDirector
	ADD CONSTRAINT PK_PbDirector
	Primary KEY CLUSTERED (pbDirector_id);


--- PbGenre Table ----

ALTER TABLE PbGenre
	ADD CONSTRAINT PK_PbGenre
	Primary KEY CLUSTERED (pbGenre_id);

--- PbMovieRequest Table ---

ALTER TABLE PbMovieRequest
	ADD CONSTRAINT PK_PbMovieRequest
	Primary KEY CLUSTERED (pbMovieRequest_id);

---Altername Key --------------------
ALTER TABLE PbUser
	ADD CONSTRAINT AK_PbUser_pbUserID
	UNIQUE(pbUserID);

ALTER TABLE PbGenre
	ADD CONSTRAINT AK_PbGenre_pbGenre
	UNIQUE(Genre);

ALTER TABLE PbMovie
	ADD CONSTRAINT AK_PbMovie_MovieID
	UNIQUE(MovieID);

Alter Table PbActor
	ADD CONSTRAINT AK_PbActor_ActorFirstName
	UNIQUE(ActorFirstName);

Alter Table PbActor
	ADD CONSTRAINT AK_PbActor_ActorLastName
	UNIQUE(ActorLastName);

Alter Table PbDirector
	ADD CONSTRAINT AK_PbDirector_DirectorFirstName
	UNIQUE(DirectorFirstName);

Alter Table PbDirector
	ADD CONSTRAINT AK_PbDirector_DirectorLastName
	UNIQUE(DirectorLastName);

----- Foreign Key ----------
ALTER TABLE PbMovieItem
	ADD CONSTRAINT FK_PbMovieItem_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbRental
	ADD CONSTRAINT FK_PbRental_pbUser_id
	FOREIGN KEY (pbUser_id) REFERENCES PbUser(pbUser_id);



ALTER TABLE PbMovieRequest
	ADD CONSTRAINT FK_PbMovieRequest_pbUser_id
	FOREIGN KEY (pbUser_id) REFERENCES PbUser(pbUser_id);

ALTER TABLE PbMovieRequest
	ADD CONSTRAINT FK_PbMovieRequest_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieActor
	ADD CONSTRAINT FK_PbMovieActor_pbActor_id
	FOREIGN KEY (pbActor_id) REFERENCES PbActor(pbActor_id);

ALTER TABLE PbMovieActor
	ADD CONSTRAINT FK_PbMovieActor_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieDirector
	ADD CONSTRAINT FK_PbMovieDirector_pbDirector_id
	FOREIGN KEY (pbDirector_id) REFERENCES PbDirector(pbDirector_id);

ALTER TABLE PbMovieDirector
	ADD CONSTRAINT FK_PbMovieDirector_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieGenre
	ADD CONSTRAINT FK_PbMovieGenre_pbMovie_id
	FOREIGN KEY (pbMovie_id) REFERENCES PbMovie(pbMovie_id);

ALTER TABLE PbMovieGenre
	ADD CONSTRAINT FK_PbMovieGenre_pbGenre_id
	FOREIGN KEY (pbGenre_id) REFERENCES PbGenre(pbGenre_id);



--- Create a Check Constraint

-- DVD or BluRay

Alter Table PbMovieItem
	Add Constraint CK_PbMovieItem_movieFormat
	Check (movieFormat = 'DVD' or movieFormat = 'BLU');

Alter Table PbUser
	Add Constraint CK_PbUser_userType
	Check (userType = 'A' or userType = 'C');

Alter Table PbUser
	Add Constraint CK_PbUser_custType
	Check (custType = 'R' or custType = 'P');

Alter Table PbUser
	Add Constraint CK_PbUser_userStatus
	Check (userStatus = 'B' or userStatus = 'G');

Alter Table PbMovieRequest
	Add Constraint CK_PbMovieRequest_movieFormat
	Check (movieFormat = 'DVD' or movieFormat = 'BLU');