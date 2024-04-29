CREATE DATABASE BlogDB
USE BlogDB
CREATE TABLE Categories(
Id int PRIMARY KEY IDENTITY,
Name nvarchar(30) UNIQUE NOT NULL
)
CREATE TABLE Tags (
Id int PRIMARY KEY IDENTITY,
Name nvarchar(30) UNIQUE NOT NULL
)
CREATE TABLE Users (
Id int PRIMARY KEY IDENTITY,
UserName nvarchar(30) UNIQUE NOT NULL,
FullName nvarchar(30) NOT NULL,
Age int
CHECK(Age>0 AND Age<150)
)
CREATE TABLE Comments (
Id int PRIMARY KEY IDENTITY,
UsersId int,
BlogsId int,
FOREIGN KEY (UsersId) REFERENCES Users(Id),
FOREIGN KEY (BlogsId) REFERENCES Blogs(Id),
Content NVARCHAR(250) NOT NULL
)
CREATE TABLE Blogs (
Id int PRIMARY KEY IDENTITY,
UsersId int,
CategoriesId int,
FOREIGN KEY (UsersId) REFERENCES Users(Id),
FOREIGN KEY (CategoriesId) REFERENCES Categories(Id),
Title NVARCHAR(50) NOT NULL,
Description NVARCHAR(200) NOT NULL
)
CREATE TABLE Blog_Tags (
BlogId INT,
TagId INT,
FOREIGN KEY (BlogId) REFERENCES Blogs(Id),
FOREIGN KEY (TagId) REFERENCES Tags(Id),
PRIMARY KEY (BlogId, TagId)
)
CREATE VIEW VW_RGETFULLDATA
AS
SELECT Title AS 'Blog Title' FROM BLOGS
select * from VW_RGETFULLDATA

CREATE VIEW VW_RGETFULLDATA_2
AS
SELECT UserName, FullName  FROM USERS
select * from VW_RGETFULLDATA_2
CREATE PROCEDURE SP_GetUserComments @userId int
AS
BEGIN
SELECT * FROM Comments c
JOIN Blogs b 
ON c.BlogsId = b.Id
WHERE c.UsersId = @userId;
END
CREATE PROCEDURE SP_GetUserBlogs @userId int
AS
BEGIN
SELECT * FROM Blogs b
JOIN Categories c 
ON b.CategoriesId = c.Id
WHERE b.UsersId = @userId;
END
 exec sp_GetUserBlogs 1
CREATE FUNCTION UFN_GETALL1(@categoryId INT)
RETURNS INT
BEGIN
DECLARE @count INT
SELECT @count = COUNT(*)
FROM Blogs
WHERE CategoriesId = @categoryId
RETURN @COUNT
END
SELECT dbo.UFN_GETALL1(1)
CREATE FUNCTION UFN_GETALL2
    (@userId INT)
RETURNS @UserBlogs TABLE
(
    BlogId INT,
    Title NVARCHAR(50),
    Description NVARCHAR(200),
    CategoryName NVARCHAR(50)
)
AS
BEGIN
INSERT INTO @UserBlogs (BlogId, Title, Description, CategoryName)
SELECT b.Id, b.Title, b.Description, c.Name AS CategoryName FROM Blogs b
JOIN Categories c ON b.CategoriesId = c.Id
WHERE b.UsersId = @userId
RETURN
END
SELECT * FROM dbo.UFN_GETALL2(1)

