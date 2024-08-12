use master
go

CREATE DATABASE Pets4life
GO

-- Use the new database
USE Pets4life;
GO

-- Create a table to store information about pet owners
CREATE TABLE [User] (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FullName VARCHAR(50),
    Phone VARCHAR(10),
	DateOfBirth Date,
	Gender BIT,
	Email VARCHAR(100),
	Password VARCHAR(255),
	Address VARCHAR(255),
	CreatedDate DATETIME,
	UpdatedDate DATETIME,
	AuthCode INT,
	Status BIT,
	IsStaff BIT
);
GO

-- Create a table to store information about pets
CREATE TABLE [Pet] (
    PetID INT PRIMARY KEY IDENTITY(1,1),
    PetName VARCHAR(50),
	PetType VARCHAR(50),
    Breed VARCHAR(50),
    Gender BIT,
    DateOfBirth Date,
	Weight Float,
	CurrentDiet VARCHAR(50),
	Note TEXT,
	ImageProfile VARCHAR(3000),
	CreatedDate DATETIME,
	UpdatedDate DATETIME,
	UserID INT FOREIGN KEY REFERENCES [User](UserID),
	Diabetes INT,
	Arthritis INT,
	Vaccine INT
);
GO



-- Create a table to store information about veterinarians
CREATE TABLE [Veterinarian] (
    VetID INT PRIMARY KEY IDENTITY(1,1),
    FullName VARCHAR(50),
    Phone VARCHAR(10),
    Email VARCHAR(100)
);
GO

-- Create a table to store appointment information
CREATE TABLE [Appointment] (
    AppointmentID INT PRIMARY KEY IDENTITY(1,1),
    PetID INT FOREIGN KEY REFERENCES Pet(PetID),
    VetID INT FOREIGN KEY REFERENCES Veterinarian(VetID),
    AppointmentDate DATETIME,
	TimeSlot VARCHAR(100),
    Purpose VARCHAR(200),
    Notes TEXT
);
GO

-- Create a table to store services offered by the pet care center
CREATE TABLE [Service] (
    ServiceID INT PRIMARY KEY IDENTITY(1,1),
    ServiceName VARCHAR(100) NOT NULL,
	Image VARCHAR(3000),
    Description TEXT,
    Price DECIMAL(10, 2),
	CreatedDate DATETIME,
	UpdatedDate DATETIME,
);
GO

-- Create a table to link services to appointments
CREATE TABLE [AppointmentService] (
    AppointmentServiceID INT PRIMARY KEY IDENTITY(1,1),
    AppointmentID INT FOREIGN KEY REFERENCES Appointment(AppointmentID),
    ServiceID INT FOREIGN KEY REFERENCES Service(ServiceID)
);
GO

-- Create a table delivery
CREATE TABLE [Delivery](
	DeliveryID INT PRIMARY KEY IDENTITY(1,1),
	Name VARCHAR(50),
	Cost DECIMAL(10,2)
)

-- Create a table product
CREATE TABLE [Product] (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100),
	Image VARCHAR(3000),
	Brand VARCHAR(50),
	Price DECIMAL(10, 2),
	Description TEXT,
	Quantity INT,
	CreatedDate DATETIME,
	UpdatedDate DATETIME,
	DeliveryID INT FOREIGN KEY REFERENCES Delivery(DeliveryID),
);
GO

-- Create a table rating
CREATE TABLE [Rating] (
    RatingID INT PRIMARY KEY IDENTITY(1,1),
	ServiceID INT FOREIGN KEY REFERENCES Service(ServiceID),
	ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
	UserID INT FOREIGN KEY REFERENCES [User](UserID),
	Star FLOAT,
    Comment VARCHAR(200)
);
GO

-- Create a table cart
CREATE TABLE [Cart] (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES [User](UserID),
    CreatedDate DATETIME
);
GO

-- Create a table cart item
CREATE TABLE [CartItem] (
    CartItemID INT PRIMARY KEY IDENTITY(1,1),
    CartID INT FOREIGN KEY REFERENCES Cart(CartID),
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),-- Foreign key to reference products (add this)
    ServiceID INT FOREIGN KEY REFERENCES Service(ServiceID), -- Foreign key to reference services (add this)
    Quantity INT,
    Price DECIMAL(10, 2),
);
GO

-- Create a table order
CREATE TABLE [Order] (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES [User](UserID),
    OrderDate DATETIME,
    TotalAmount DECIMAL(10, 2),
	IsPaid BIT,
	ImagePayment VARCHAR(3000)
);
GO

-- Create a table order detail
CREATE TABLE [OrderDetail] (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES [Order](OrderID),
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),-- Foreign key to reference products (add this)
    ServiceID INT FOREIGN KEY REFERENCES Service(ServiceID), -- Foreign key to reference services (add this)
    Quantity INT,
    Price DECIMAL(10, 2),
);
GO