USE master
CREATE DATABASE Israel_Real_Estate_Market
USE Israel_Real_Estate_Market

GO
BEGIN TRAN

--DESCRIPTION: A table of cities in Israel with data that may be relevant to the effect on real estate prices
GO
CREATE TABLE Cities 
(CityID INT PRIMARY KEY, 
 CityName VARCHAR(50) NOT NULL, --will be foreign key in Transactions table
 Region VARCHAR(50),
 SocioEconomicIndex INT CHECK (SocioEconomicIndex > 0 AND SocioEconomicIndex < 11),
 TotalPopulation INT CHECK (TotalPopulation >= 0),
 AveragePurchasePrice MONEY CHECK (AveragePurchasePrice >= 0),
 AverageRentalPrice MONEY CHECK (AverageRentalPrice >= 0),
 AnnualReturn MONEY,
 CONSTRAINT City_Name_uk UNIQUE(CityName))


GO
INSERT INTO Cities 
VALUES 
(1,  'Tel Aviv', 'Tel Aviv', 8, 494561, 4580456, 9300, 2.23),
(2,  'Haifa', 'Haifa', 7, 295781, 1474634, 3800, 2.83),
(3,  'Jerusalem', 'Jerusalem', 4, 1039481, 2715856, 6000, 2.43),
(4,  'Beer Sheva', 'South', 5, 218302, 1172675, 2700, 2.53),
(5,  'Eilat', 'South', 5, 57732, 1896555, 4050, 2.35),
(6,  'Mitzpe Ramon', 'South', 4, 5698, 1135016, 3000, 3.17),
(7,  'Bat Yam', 'Tel Aviv', 5, 129360, 2164310, 4700, 2.39),
(8,  'Tirat Hacarmel', 'Haifa', 4, 32394, 1748073, 4300, 2.23),
(9,  'Herzliya', 'Tel Aviv', 8, 109296, 3454284, 8900, 2.71),
(10, 'Ramat Hasharon', 'Tel Aviv', 9, 48795, 4658372, 9500, 2.24),
(11, 'Kfar Saba', 'Center', 8, 99828, 3145719, 6900, 2.41),
(12, 'Hod Hasharon', 'Center', 8, 66208, 3428493, 8000, 2.57),
(13, 'Raanana', 'Center', 8, 83616, 3455373, 7750, 2.47),
(14, 'Kiryat Shmona', 'North', 5, 25002, 1551843, 2800, 1.98),
(15, 'Karmiel', 'North', 5, 48339, 1459189, 3000, 2.26),
(16, 'Tiberias', 'North', 4, 51869, 1104612, 3300, 3.29),
(17, 'Caesarea', 'Haifa', 9, 5818, 2428048, 5800, 2.63),
(18, 'Or Akiva', 'Haifa', 4, 25260, 1990763, 5000, 2.76),
(19, 'Ashdod', 'South', 5, 228931, 1884847, 4900, 2.86),
(20, 'Rishon LeZion', 'Center', 6, 259840, 2288955, 5500, 2.64)



--DESCRIPTION: A table of the property details from each transaction
GO
CREATE TABLE Property_Details
(PropertyID INT PRIMARY KEY, --will be foreign key in Transactions table
 Address VARCHAR(50),
 Type VARCHAR(50),
 Floor INT NOT NULL,
 NumberOfRooms INT CHECK (NumberOfRooms > 0),
 SquareMeter INT CHECK (SquareMeter > 0),
 YearOfConstruction INT)


GO
INSERT INTO Property_Details
VALUES 
(1,  'Yaalom 6', 'Apartment', 4, 5, 125, 2021),
(2,  'Livne 7', 'Private', 0, 4, 106, 2008),
(3,  'Ben Gurion 4', 'Apartment', 1, 4, 98, 2007),
(4,  'Hatzabar 215', 'Apartment', 0, 3, 49, 1989),
(5,  'Shahaf 42', 'Private', 0, 4, 81, 1996),
(6,  'Kloizner 6', 'Apartment', 1, 3, 68, 2019),
(7,  'Nof 23', 'Apartment', 8, 4, 86, 2005),
(8,  'Havered 1', 'Apartment', 9, 5, 173, 2023),
(9,  'Bialik 24', 'Apartment', 2, 5, 122, 2000),
(10, 'Akalton 18', 'Private', 0, 6, 230, 1991),
(11, 'Golda Meir 15', 'Apartment', 2, 4, 92, 2024),
(12, 'Hapalmach 30', 'Apartment', 3, 5, 97, 1980),
(13, 'Pinsker 4', 'Apartment', 3, 3, 76, 2020),
(14, 'Hasolelim 1', 'Apartment', 23, 3, 72, 2024),
(15, 'Yad Harutzim 30', 'Apartment', 7, 3, 71, 2004),
(16, 'Pinsker 13', 'Apartment', 1, 4, 92, 2001),
(17, 'Eilat 67', 'Apartment', 1, 5, 113, 2012),
(18, 'Hakarkom 3', 'Apartment', 2, 3, 78, 2000),
(19, 'Ein Avdat 4', 'Apartment', 3, 4, 77, 1970),
(20, 'Shprinzek 3', 'Apartment', 8, 3, 63, 1970),
(21, 'Brener 121', 'Apartment', 1, 4, 110, 1970),
(22, 'Livne 4', 'Private', 0, 4, 139, 1996),
(23, 'Dekel 1', 'Private', 0, 4, 101, 1998),
(24, 'Mishmar Hayarden 12', 'Apartment', 3, 2, 38, 1970),
(25, 'Hakalanit 2', 'Apartment', 4, 4, 94, 2021),
(26, 'Ein Avdat 10', 'Apartment', 2, 4, 77, 1980),
(27, 'Arlozerov 81', 'Apartment', 2, 3, 61, 1970),
(28, 'Habavli 21', 'Private', 0, 3, 60, 1970),
(29, 'Hashoftim 1', 'Apartment', 2, 3, 64, 1998),
(30, 'Hachshmal 53', 'Apartment', 0, 3.5, 53, 1962),
(31, 'Etzel 9', 'Apartment', 1, 3, 60, 1970),
(32, 'Hazait 3', 'Apartment', 4, 3, 40, 1970),
(33, 'Lamerhav 1', 'Private', 0, 5, 175, 1985),
(34, 'Hayovel 8', 'Private', 0, 4, 120, 1981),
(35, 'Keren Hayesod 2', 'Apartment', 3, 4, 70, 1970),
(36, 'Hachshmal 53', 'Apartment', 2, 3, 54, 1950),
(37, 'Emek Hefer 2', 'Apartment', 4, 5, 118, 2000),
(38, 'Dizengoff 249', 'Apartment', 2, 2, 47, 2023),
(39, 'Ganim 4', 'Apartment', 1, 6, 533, 1992),
(40, 'Shaul Hamelech 4', 'Apartment', 1, 3, 57, 1995)



--DESCRIPTION: A table of the customers who bought each property
GO
CREATE TABLE Customers
(CustomerID INT PRIMARY KEY, --will be foreign key in Transactions table
 FirstName VARCHAR(50) NOT NULL,
 LastName VARCHAR(50) NOT NULL,
 BirthDate DATE,
 Gender VARCHAR(10),
 Profession VARCHAR(50),
 Residence VARCHAR(50),
 Religion VARCHAR(20))


GO
INSERT INTO Customers
VALUES
(1, 'David', 'Levi', '1980-05-12', 'Male', 'Engineer', 'Tel Aviv', 'Jewish'),
(2, 'Maya', 'Cohen', '1985-03-22', 'Female', 'Teacher', 'Haifa', 'Jewish'),
(3, 'Yossi', 'Mizrahi', '1975-11-05', 'Male', 'Doctor', 'Jerusalem', 'Jewish'),
(4, 'Itamar', 'Goldberg', '1983-08-14', 'Male', 'Lawyer', 'Rishon LeZion', 'Jewish'),
(5, 'Rachel', 'Barak', '1994-09-11', 'Female', 'Designer', 'Ashdod', 'Jewish'),
(6, 'Nadav', 'Harari', '1991-12-02', 'Male', 'Photographer', 'Netanya', 'Jewish'),
(7, 'Liora', 'Berman', '1987-06-18', 'Female', 'Scientist', 'Beer Sheva', 'Jewish'),
(8, 'Avi', 'Katz', '1993-04-04', 'Male', 'Architect', 'Eilat', 'Jewish'),
(9, 'Dafna', 'Mandel', '1983-07-23', 'Female', 'Professor', 'Herzliya', 'Jewish'),
(10, 'Oren', 'Pereira', '1978-02-05', 'Male', 'Engineer', 'Kiryat Shmona', 'Jewish'),
(11, 'Erez', 'Ben David', '1986-09-30', 'Male', 'Writer', 'Kfar Saba', 'Jewish'),
(12, 'Tamar', 'Saul', '1992-10-01', 'Female', 'Actor', 'Raanana', 'Jewish'),
(13, 'Moran', 'Friedman', '1989-12-25', 'Female', 'Journalist', 'Haifa', 'Jewish'),
(14, 'Jonathan', 'Moyal', '1993-11-20', 'Male', 'Businessman', 'Jerusalem', 'Jewish'),
(15, 'Esther', 'Davidovich', '1984-04-12', 'Female', 'Consultant', 'Ramat Gan', 'Jewish'),
(16, 'Yona', 'Shimoni', '1991-05-08', 'Male', 'Musician', 'Petah Tikva', 'Jewish'),
(17, 'Vered', 'Cohen', '1994-01-18', 'Female', 'Artist', 'Holon', 'Jewish'),
(18, 'Aviad', 'Nissim', '1985-08-21', 'Male', 'Electrician', 'Modiin', 'Jewish'),
(19, 'Batya', 'Klein', '1982-10-13', 'Female', 'Artist', 'Ashkelon', 'Jewish'),
(20, 'Ahmad', 'Jaber', '1973-12-30', 'Male', 'Businessman', 'Jaffa', 'Muslim'),
(21, 'Layla', 'Hassan', '1991-03-14', 'Female', 'Engineer', 'Haifa', 'Muslim'),
(22, 'Ranya', 'Rashid', '1992-02-25', 'Female', 'Consultant', 'Ramla', 'Muslim'),
(23, 'Omar', 'Al-Masri', '1987-07-19', 'Male', 'Architect', 'Acre', 'Muslim'),
(24, 'Lina', 'Sami', '1990-11-12', 'Female', 'Lawyer', 'Tel Aviv', 'Muslim'),
(25, 'Rami', 'Jaljuli', '1982-06-09', 'Male', 'Doctor', 'Lod', 'Christian'),
(26, 'Nadia', 'Toma', '1977-02-15', 'Female', 'Psychologist', 'Nazareth', 'Christian'),
(27, 'Samir', 'Jadallah', '1986-03-18', 'Male', 'Engineer', 'Haifa', 'Christian'),
(28, 'George', 'Khalil', '1990-05-23', 'Male', 'Scientist', 'Nazareth', 'Christian')



--DESCRIPTION: The main table with the transaction details
GO
CREATE TABLE Transactions
(TransactionID INT PRIMARY KEY,
 CustomerID INT NOT NULL,
 PropertyID INT NOT NULL,
 CityName VARCHAR(50),
 TransactionDate DATE,
 Price MONEY CHECK(Price >= 0),
 --Definition of the foreign keys:
 FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
 FOREIGN KEY (PropertyID) REFERENCES Property_Details(PropertyID),
 FOREIGN KEY (CityName) REFERENCES Cities(CityName))


 GO
 INSERT INTO Transactions
 VALUES
(1,  27, 36, 'Haifa', '2022-07-10', 720000),
(2,  11, 27, 'Bat Yam', '2024-06-09', 2050000),
(3,  9,  16, 'Herzliya', '2024-11-11', 3170000),
(4,  4,  40, 'Beer Sheva', '2024-11-18', 825000),
(5,  12, 3,  'Ramat Hasharon', '2024-11-10', 4000000),
(6,  4,  20, 'Rishon LeZion', '2024-04-02', 1960000),
(7,  11, 13, 'Herzliya', '2023-11-15', 1100000),
(8,  16, 6,  'Bat Yam', '2024-09-22', 2110000),
(9,  7,  19, 'Mitzpe Ramon', '2024-09-26', 825000),
(10, 14, 25, 'Raanana', '2024-10-29', 3230000),
(11, 13, 31, 'Tirat Hacarmel', '2023-03-27', 1280000),
(12, 10, 29, 'Kiryat Shmona', '2024-08-04', 450000),
(13, 1,  38, 'Tel Aviv', '2024-07-18', 3200000),
(14, 26, 32, 'Karmiel', '2022-12-27', 750000),
(15, 1,  10, 'Hod Hasharon', '2022-06-23', 7150000),
(16, 5,  12, 'Ashdod', '2024-04-17', 2060000),
(17, 20, 1,  'Kfar Saba', '2024-11-13', 3750000),
(18, 6,  7,  'Tirat Hacarmel', '2024-10-15', 1650000),
(19, 3,  22, 'Caesarea', '2024-01-15', 5150000),
(20, 21, 30, 'Haifa', '2016-11-28', 530000),
(21, 3,  4,  'Jerusalem', '2024-08-15', 1790000),
(22, 27, 23, 'Or Akiva', '2024-05-21', 2650000),
(23, 19, 39, 'Eilat', '2022-08-19', 3650000),
(24, 23, 11, 'Tiberias', '2024-10-10', 1650000),
(25, 17, 26, 'Mitzpe Ramon', '2019-11-07', 625000),
(26, 14, 2,  'Caesarea', '2008-12-10', 2030000),
(27, 28, 5,  'Karmiel', '2023-12-27', 2000000),
(28, 18, 18, 'Rishon LeZion', '2024-09-27', 1700000),
(29, 10, 35, 'Kiryat Shmona', '2023-04-02', 680000),
(30, 20, 14, 'Tel Aviv', '2024-11-06', 3990000),
(31, 22, 9,  'Beer Sheva', '2024-07-08', 1220000),
(32, 15, 33, 'Ramat Hasharon', '2022-11-06', 7400000),
(33, 24, 37, 'Kfar Saba', '2023-02-15', 2850000),
(34, 25, 24, 'Ashdod', '2024-11-13', 1320000),
(35, 12, 34, 'Raanana', '2023-08-09', 3800000),
(36, 14, 15, 'Jerusalem', '2024-11-11', 2790000),
(37, 1,  8,  'Or Akiva', '2022-10-25', 6300000),
(38, 9,  28, 'Hod Hasharon', '2024-06-13', 2400000),
(39, 8,  17, 'Eilat', '2024-10-13', 1850000),
(40, 2,  21, 'Tiberias', '2024-09-26', 899000)


COMMIT



