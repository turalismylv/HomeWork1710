USE MoviesApp

CREATE TABLE Directors(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(50) NOT NULL,
	Surname nvarchar(50) NOT NULL
)

CREATE TABLE Languages(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(50) NOT NULL UNIQUE
)

CREATE TABLE Movies(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(50) NOT NULL,
	Description nvarchar(255) NOT NULL,
	CoverPhoto nvarchar(255) NOT NULL,
	DirectorId int FOREIGN KEY REFERENCES Directors(Id),
	LanguageId int FOREIGN KEY REFERENCES Languages(Id),
)

CREATE TABLE Actors(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(50) NOT NULL,
	Surname nvarchar(50) NOT NULL
)


CREATE TABLE Genres(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(50) NOT NULL UNIQUE
	
)

CREATE TABLE MoviesAndActors(
	Id int PRIMARY KEY IDENTITY,
	MovieId int FOREIGN KEY REFERENCES Movies(Id),
	ActorId int FOREIGN KEY REFERENCES Actors(id)

)

CREATE TABLE MoviesAndGenres(
	Id int PRIMARY KEY IDENTITY,
	MovieId int FOREIGN KEY REFERENCES Movies(Id),
	GenreId int FOREIGN KEY REFERENCES Genres(id)

)



INSERT INTO Directors
VALUES('Tural','Ismayilov'),
('Emil','Guluzade'),
('Faig','Resulzade')

INSERT INTO Languages
VALUES('AZE'),('ENG'),('TUR'),('RUS')

INSERT INTO Movies
VALUES('FIGHT CLUB','Dövüş Kulübü (orijinal adı: Fight Club), Chuck Palahniuk tarafından yazılmış aynı isimli romandan uyarlanan kült filmdir',
'fightclubphoto',1,2),
('TEHMINE','Filmdə əsərin baş qəhramanları olan Zaur (Fəxrəddin Manafov) və Təhminənin (Meral Konrat) melodram həyatından bəhs edir.',
'tehminephoto',2,1),
('DAG','Unudulmuş Əsgərlər olaraq da bilinən Dağ, rejissoru Alper Çağların 2012-ci il Türk drama filmidir',
'dagphoto',3,3),


INSERT INTO Movies
VALUES('MATRIX-2','MATRIXTESTTESTTESTESTESTESTESTEST','matrixphoto2',1,2)

INSERT INTO Actors
VALUES('TEST','TESTOV'),
('CAGLAR','ERTUGRUL'),
('FEXREDDIN','MANAFOV'),
('MERAL','KONRAT'),
('BREDD','PITT'),
('EDVARD','NORTON')

INSERT INTO Genres
VALUES('DRAM'),('FIGHT'),('MELODRAM'),('ACTION'),('ROMANTIKA')

INSERT INTO MoviesAndActors
VALUES(4,5),(1,6),(2,3),(2,4),(3,1),(3,2)

INSERT INTO MoviesAndGenres
VALUES(6,4),(1,2),(2,3),(2,5),(3,4),(3,2)


SELECT * FROM Directors

SELECT * FROM Languages

SELECT * FROM Movies
SELECT * FROM MoviesAndGenres
SELECT * FROM Genres
SELECT *FROM MoviesAndActors

SELECT * FROM Actors

--1

CREATE OR ALTER PROCEDURE usp_GetFilmsAndLanguage @directorId int
AS
SELECT m.Id,m.Name,l.Name FROM Movies AS m
INNER JOIN Languages AS l ON m.LanguageId= l.Id
WHERE m.DirectorId=@directorId




EXEC usp_GetFilmsAndLanguage @directorId=1

--2
 
CREATE FUNCTION GetLanguageMoviesCount (@languageId int)
RETURNS int
AS
BEGIN
     DECLARE @CountMovie int
	 SELECT @CountMovie=COUNT(*) FROM Movies WHERE Movies.LanguageId=@languageId
	 RETURN @CountMovie
END

SELECT  dbo.GetLanguageMoviesCount(2)

--3

CREATE OR ALTER PROCEDURE usp_GenreFilmsAndDirector @genreId int
AS
SELECT m.Name,d.Name FROM MoviesAndGenres AS mg
INNER JOIN Movies AS m ON mg.MovieId=m.Id
INNER JOIN Directors AS d ON m.DirectorId=d.Id
WHERE mg.GenreId=@genreId

EXEC usp_GenreFilmsAndDirector @genreId=4

--4

CREATE OR ALTER FUNCTION GetBoolActor(@actorId int)
RETURNS bit
AS
BEGIN
	DECLARE @BOOLING bit =0
	
	DECLARE @FILMCOUNT int
	SELECT @FILMCOUNT= COUNT(*) FROM  MoviesAndActors WHERE MoviesAndActors.ActorId=@actorId
	IF @FILMCOUNT>3 SELECT @BOOLING=1
	RETURN @BOOLING
END


SELECT  dbo.GetBoolActor(5)

--5
CREATE TRIGGER GetAllMoviesAfterInsert ON Movies
AFTER INSERT
AS
BEGIN
	SELECT m.Name,m.Description,d.Name,d.Surname,l.Name FROM Movies AS m
	INNER JOIN Directors AS d ON m.DirectorId=d.Id
	INNER JOIN Languages AS l ON m.LanguageId=l.Id
END


INSERT INTO Movies
VALUES('TESTFILM','TESTFILM DESCRIPTION','TESTPHOTO',1,2)
--