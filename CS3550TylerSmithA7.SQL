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







-- We do this for all tables in the database--

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
	userPrimaryPhone nvarchar(10) NOT NULL,
	userOtherPhone nvarchar(10) NULL,
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
	pbMovieItem_id int IDENTITY(1,1) NOT NULL,
	pbMovie_id int NOT NULL,
	pbCopyNum int NOT NULL,
	MovieFormat varchar(3) NOT NULL
);

Create TABLE PbRental
(
	pbRental_id int IDENTITY (1,1) NOT NULL,
	pbMovieItem_id int NOT NULL,
	pbUser_id int NOT NULL,
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
	Primary KEY CLUSTERED (pbMovieItem_id);
	

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

-----PbMovieActor-----------------
ALTER TABLE PbMovieActor
	ADD CONSTRAINT PK_PbMovieActor
	Primary KEY CLUSTERED (pbMovie_id, pbActor_id);

ALTER TABLE PbMovieDirector
	ADD CONSTRAINT PK_PbMovieDirector
	Primary KEY CLUSTERED (pbMovie_id, pbDirector_id);

ALTER TABLE PbMovieGenre
	ADD CONSTRAINT PK_PbMovieGenre
	Primary KEY CLUSTERED (pbMovie_id, pbGenre_id);



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
	UNIQUE(ActorFirstName, ActorLastName);

---Alter Table PbActor
---	ADD CONSTRAINT AK_PbActor_ActorLastName
---	UNIQUE(ActorLastName);

Alter Table PbDirector
	ADD CONSTRAINT AK_PbDirector_DirectorFirstName
	UNIQUE(DirectorFirstName, DirectorLastName);

---Alter Table PbDirector
---	ADD CONSTRAINT AK_PbDirector_DirectorLastName
---	UNIQUE(DirectorLastName);

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

ALTER TABLE PbRental
	ADD CONSTRAINT FK_PbRental_pbMovieItem_id
	FOREIGN KEY (pbMovieItem_id) REFERENCES PbMovieItem(pbMovieItem_id);



--- Create a Check Constraint --------

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

Alter Table PbUser
	Add Constraint CK_PbUser_userPrimaryPhone
	CHECK (userPrimaryPhone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

Alter Table PbUser
	Add Constraint CK_PbUser_userOtherPhone
	CHECK (userOtherPhone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')


-----------Insert Data into database -------------

----PbUser----------
Insert Into PbUser (pbUserID, userFirstName, userLastName, userPassword, secQuestion, secAnswer, userPrimaryPhone, userOtherPhone, custType, userType, fees, userStatus)
Values ('233594215', 'Joe', 'Schmo', 'B994vn7T', 'Where were you born?', 'Las Vegas', '8854216695', '6548823361', 'R', 'A', '2.50', 'G'); 

Insert Into PbUser (pbUserID, userFirstName, userLastName, userPassword, secQuestion, secAnswer, userPrimaryPhone, userOtherPhone, custType, userType, fees, userStatus)
Values ('11266842', 'April', 'Showers', 'v99K3Zbnk', 'What is the name of your fist pet?', 'Cat', '6659214456', '2247756120', 'P', 'C', '0.00', 'G'); 


-----PbMovie-----------
Insert Into PbMovie (MovieID, movieTitle, keywords, lastChangedBy, lastChangedOn)
Values ('JW20001', 'John Wick: Chapter 2', 'Crime Thriller Gun', 'TSmith', GETDATE());

Insert Into PbMovie (MovieID, movieTitle, keywords, lastChangedBy, lastChangedOn)
Values ('LOG0001', 'Logan', 'Marvel Super Hero', 'TSmith', GETDATE());

Insert Into PbMovie (MovieID, movieTitle, keywords, lastChangedBy, lastChangedOn)
Values ('TTS0001', 'The Truman Show', ' hidden camera  controlled environment', 'TSmith', GETDATE());

Insert Into PbMovie (MovieID, movieTitle, keywords, lastChangedBy, lastChangedOn)
Values ('KSI0001', 'Kong: Skull Island', 'monster king', 'TSmith', GETDATE());

---------PbGenre----------
Insert Into PbGenre (genre)
Values ('Action');

Insert Into PbGenre (genre)
Values ('Comedy');

Insert Into PbGenre (genre)
Values ('Sci-Fi');

Insert Into PbGenre (genre)
Values ('Adventure');

----------PbMovieGenre--------------
Insert Into PbMovieGenre (pbMovie_id , pbGenre_id)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'LOG0001'), (SELECT pbGenre_id FROM PbGenre WHERE genre = 'Sci-Fi')); 

Insert Into PbMovieGenre (pbMovie_id , pbGenre_id)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'JW20001'), (SELECT pbGenre_id FROM PbGenre WHERE genre = 'Action')); 

Insert Into PbMovieGenre (pbMovie_id , pbGenre_id)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'TTS0001'), (SELECT pbGenre_id FROM PbGenre WHERE genre = 'Comedy')); 

-------------PbActor-------------------
Insert Into PbActor( actorFirstName, actorLastName)
Values ('Keanu','Reeves');

Insert Into PbActor( actorFirstName, actorLastName)
Values ('Ian','McShane');

Insert Into PbActor( actorFirstName, actorLastName)
Values ('Hugh','Jackman');

Insert Into PbActor( actorFirstName, actorLastName)
Values ('Patrick','Stewart');

Insert Into PbActor( actorFirstName, actorLastName)
Values ('Jim','Carrey');

Insert Into PbActor( actorFirstName, actorLastName)
Values ('Noah','Emmerich');

Insert Into PbActor( actorFirstName, actorLastName)
Values ('Samuel','Jackson');

Insert Into PbActor( actorFirstName, actorLastName)
Values ('Brie','Larson');

--------------pbDirector-------------------

Insert Into PbDirector( directorFirstName, directorLastName)
Values ('Peter','Weir');

Insert Into PbDirector( directorFirstName, directorLastName)
Values ('James','Mangold');

Insert Into PbDirector( directorFirstName, directorLastName)
Values ('Chad','Stahelski');

Insert Into PbDirector( directorFirstName, directorLastName)
Values ('Jordan','Vogt-Roberts');

------------PbMovieActor ---------------
Insert Into PbMovieActor(pbMovie_id , pbActor_id)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'JW20001'), (SELECT pbActor_id FROM PbActor WHERE actorFirstName = 'Keanu')); 

Insert Into PbMovieActor(pbMovie_id , pbActor_id)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'JW20001'), (SELECT pbActor_id FROM PbActor WHERE actorFirstName = 'Ian')); 

Insert Into PbMovieActor(pbMovie_id , pbActor_id)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'LOG0001'), (SELECT pbActor_id FROM PbActor WHERE actorFirstName = 'Hugh')); 

Insert Into PbMovieActor(pbMovie_id , pbActor_id)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'LOG0001'), (SELECT pbActor_id FROM PbActor WHERE actorFirstName = 'Patrick')); 

Insert Into PbMovieActor(pbMovie_id , pbActor_id)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'TTS0001'), (SELECT pbActor_id FROM PbActor WHERE actorFirstName = 'Jim')); 

Insert Into PbMovieActor(pbMovie_id , pbActor_id)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'TTS0001'), (SELECT pbActor_id FROM PbActor WHERE actorFirstName = 'Noah')); 

--------------PbMovieDirector------------
Insert Into PbMovieDirector(pbMovie_id , pbDirector_id)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'JW20001'), (SELECT pbDirector_id FROM PbDirector WHERE directorFirstName = 'Chad')); 

Insert Into PbMovieDirector(pbMovie_id , pbDirector_id)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'LOG0001'), (SELECT pbDirector_id FROM PbDirector WHERE directorFirstName = 'James')); 

Insert Into PbMovieDirector(pbMovie_id , pbDirector_id)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'TTS0001'), (SELECT pbDirector_id FROM PbDirector WHERE directorFirstName = 'Peter')); 

----------------PbMovieItem---------------

Insert Into PbMovieItem(pbMovie_id , pbCopyNum, MovieFormat)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'TTS0001'), '1', 'BLU'); 
Insert Into PbMovieItem(pbMovie_id , pbCopyNum, MovieFormat)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'TTS0001'), '2', 'DVD'); 

Insert Into PbMovieItem(pbMovie_id , pbCopyNum, MovieFormat)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'LOG0001'), '1', 'BLU'); 
Insert Into PbMovieItem(pbMovie_id , pbCopyNum, MovieFormat)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'LOG0001'), '2', 'DVD'); 

Insert Into PbMovieItem(pbMovie_id , pbCopyNum, MovieFormat)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'JW20001'), '1', 'BLU'); 
Insert Into PbMovieItem(pbMovie_id , pbCopyNum, MovieFormat)
Values ((SELECT pbMovie_id FROM PbMovie WHERE MovieID = 'JW20001'), '2', 'DVD'); 




USE PurpleBoxDVD;
GO

------------------ Stored Procedures ---------------------------

--------------------Edit a phone# -------------------------
IF EXISTS(
	SELECT *
	FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addPhone')

	DROP PROCEDURE usp_addPhone;
GO



CREATE PROCEDURE usp_addPhone
	@userPrimaryPhone nvarchar(10),
	@pbUserID nvarchar(25)
AS 
BEGIN 
	Update PbUser set userPrimaryPhone = @userPrimaryPhone
	WHERE pbUserID = @pbUserID;
END

GO

EXECUTE usp_addPhone '8015554969', '233594215';

----EDIT QUESTION------------

IF EXISTS(
	SELECT *
	FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addQuestion')

	DROP PROCEDURE usp_addQuestion;
GO


CREATE PROCEDURE usp_addQuestion
	@secQuestion nvarchar(255),
	@pbUserID nvarchar(25)
AS 
BEGIN 
	Update PbUser set secQuestion = @secQuestion
	WHERE pbUserID = @pbUserID;
END

GO

EXECUTE usp_addQuestion 'What is your favorite color?', '233594215';




------------ADD To pbMovieGenre ------------
IF EXISTS(
	SELECT *
	FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addMovieGenre')

	DROP PROCEDURE usp_addMovieGenre;
GO


CREATE PROCEDURE usp_addMovieGenre

	@Genre nvarchar(20),
	@MovieID nvarchar(25)

AS
BEGIN
DECLARE @pbMovie_id int;
DECLARE @pbGenre_id int;

SELECT @pbMovie_id = pbMovie_id
FROM pbMovie WHERE MovieID = @MovieID;

SELECT @pbGenre_id = pbGenre_id
FROM pbGenre WHERE Genre = @Genre;

if(@pbMovie_id IS NULL) PRINT 'INVALID MOVIE';

BEGIN

TRY
	INSERT INTO pbMovieGenre (pbMovie_id, pbGenre_id)
	VALUES (@pbMovie_id, @pbGenre_id);
END TRY

BEGIN CATCH
PRINT 'INSERT DOES NOT WORK!'
END CATCH

END
GO

EXECUTE usp_addMovieGenre 'Adventure', 'KSI0001';
---------------------Add to pbMovieActor----------------
IF EXISTS(
	SELECT *
	FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addMovieActor')

	DROP PROCEDURE usp_addMovieActor;
GO


CREATE PROCEDURE usp_addMovieActor

	@ActorFirstName nvarchar(25),
	@ActorLastName nvarchar(25),
	@MovieID nvarchar(25)

AS
BEGIN
DECLARE @pbMovie_id int;
DECLARE @pbActor_id int;

SELECT @pbMovie_id = pbMovie_id
FROM pbMovie WHERE MovieID = @MovieID;

SELECT @pbActor_id = pbActor_id
FROM pbActor WHERE actorFirstName = @ActorFirstName AND actorLastName = @ActorLastName;

if(@pbActor_id IS NULL) PRINT 'INVALID Actor';

BEGIN

TRY
	INSERT INTO pbMovieActor (pbMovie_id, pbActor_id)
	VALUES (@pbMovie_id, @pbActor_id);
END TRY

BEGIN CATCH
PRINT 'INSERT DOES NOT WORK!'
END CATCH

END
GO

EXECUTE usp_addMovieActor 'Samuel', 'Jackson', 'KSI0001';

-----------pbMovieDirector-------------

IF EXISTS(
	SELECT *
	FROM INFORMATION_SCHEMA.ROUTINES
	WHERE SPECIFIC_NAME = 'usp_addMovieDirector')

	DROP PROCEDURE usp_addMovieDirector;
GO


USE PurpleBoxDVD;
GO 

CREATE PROCEDURE usp_addMovieDirector

	@DirectorFirstName nvarchar(25),
	@DirectorLastName nvarchar(25),
	@MovieID nvarchar(25)

AS
BEGIN
DECLARE @pbMovie_id int;
DECLARE @pbDirector_id int;

SELECT @pbMovie_id = pbMovie_id
FROM pbMovie WHERE MovieID = @MovieID;

SELECT @pbDirector_id = pbDirector_id
FROM PbDirector WHERE directorFirstName = @DirectorFirstName AND directorLastName = @DirectorLastName;

if(@pbDirector_id IS NULL) PRINT 'INVALID Director';

BEGIN

TRY
	INSERT INTO pbMovieDirector(pbMovie_id, pbDirector_id)
	VALUES (@pbMovie_id, @pbDirector_id);
END TRY

BEGIN CATCH
PRINT 'INSERT DOES NOT WORK!'
END CATCH

END
GO

EXECUTE usp_addMovieDirector 'Jordan', 'Vogt-Roberts', 'KSI0001';

SELECT * FROM PbUser;
SELECT * FROM PbMovieGenre;
SELECT * FROM PbMovieDirector;
SELECT * FROM PbMovieActor;

DELETE PbMovieGenre
WHERE pbMovie_id = (Select pbMovie_id From PbMovie Where MovieID = 'KSI0001');
DELETE PbMovieActor
WHERE pbMovie_id = (Select pbMovie_id From PbMovie Where MovieID = 'KSI0001');
DELETE PbMovieDirector
WHERE pbMovie_id = (Select pbMovie_id From PbMovie Where MovieID = 'KSI0001');
