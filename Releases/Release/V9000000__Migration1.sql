CREATE TABLE dbo.MyTable
(
    id INT IDENTITY(1,1) NOT NULL,
    fullName NVARCHAR(100) NOT NULL
);

INSERT INTO dbo.MyTable
(
    fullName
)
VALUES
('John Doe'),
('Jane Doe');