CREATE TABLE ProductGroup (
    GroupID INT PRIMARY KEY,
    GroupName NVARCHAR(100) NOT NULL,
    ProductType NVARCHAR(50) NOT NULL
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    GroupID INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Units NVARCHAR(50) NOT NULL,
    PricePerUnit DECIMAL(10,2) NOT NULL CHECK (PricePerUnit >= 0),
    FOREIGN KEY (GroupID) REFERENCES ProductGroup(GroupID)
);

CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY,
    SupplierName NVARCHAR(100) NOT NULL,
    ContactInfo NVARCHAR(100) NOT NULL
);

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    IDCardNumber NVARCHAR(20) UNIQUE NOT NULL,
    ContactNumber NVARCHAR(20) NOT NULL,
    Role NVARCHAR(50) NOT NULL,
    EmploymentType NVARCHAR(50) NOT NULL
);

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    ContactNumber NVARCHAR(20) NOT NULL
);

CREATE TABLE CustomerCard (
    CardID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    Balance DECIMAL(10,2) NOT NULL CHECK (Balance >= 0),
    Tickets INT NOT NULL CHECK (Tickets >= 0),
    IssueDate DATE NOT NULL,
    ExpiryDate DATE NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE StockReceipt (
    ReceiptID INT PRIMARY KEY,
    StaffID INT NOT NULL,
    SupplierID INT NOT NULL,
    ReceiptDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL CHECK (TotalAmount >= 0),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

CREATE TABLE StockReceiptDetail (
    DetailID INT PRIMARY KEY,
    ProductID INT NOT NULL,
    ReceiptID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    SubTotal AS (Quantity * UnitPrice) PERSISTED,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (ReceiptID) REFERENCES StockReceipt(ReceiptID)
);

CREATE TABLE GameMachine (
    GameMachineID INT PRIMARY KEY,
    GameType NVARCHAR(50) NOT NULL,
    GameName NVARCHAR(100) NOT NULL,
    CostPerPlay DECIMAL(10,2) NOT NULL CHECK (CostPerPlay >= 0),
    GameLocation NVARCHAR(100) NOT NULL,
    Status NVARCHAR(50) NOT NULL
);

CREATE TABLE StockCompensationReceipt (
    CompensationID INT PRIMARY KEY,
    IssuedBy INT NOT NULL,
    ApprovedBy INT NOT NULL,
    GameMachineID INT NOT NULL,
    TimeIssued TIME NOT NULL,
    DateIssued DATE NOT NULL,
    Reason NVARCHAR(255),
    FOREIGN KEY (IssuedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (ApprovedBy) REFERENCES Staff(StaffID),
    FOREIGN KEY (GameMachineID) REFERENCES GameMachine(GameMachineID)
);

CREATE TABLE PaymentReceipt (
    PaymentID INT PRIMARY KEY,
    SupplierID INT NOT NULL,
    StaffID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount > 0),
    PaymentTime TIME NOT NULL,
    PaymentDate DATE NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

CREATE TABLE Maintenance (
    MaintenanceID INT PRIMARY KEY,
    GameMachineID INT NOT NULL,
    StaffID INT NOT NULL,
    Time TIME NOT NULL,
    Date DATE NOT NULL,
    TotalCost DECIMAL(10,2) NOT NULL CHECK (TotalCost >= 0),
    FOREIGN KEY (GameMachineID) REFERENCES GameMachine(GameMachineID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

CREATE TABLE MaintenanceDetail (
    DetailID INT PRIMARY KEY,
    MaintenanceID INT NOT NULL,
    Description NVARCHAR(255) NOT NULL,
    DetailedCost DECIMAL(10,2) NOT NULL CHECK (DetailedCost >= 0),
    FOREIGN KEY (MaintenanceID) REFERENCES Maintenance(MaintenanceID)
);

CREATE TABLE Gift (
    GiftID INT PRIMARY KEY,
    GiftName NVARCHAR(100) NOT NULL,
    TicketsCost INT NOT NULL CHECK (TicketsCost >= 0),
    Stock INT NOT NULL CHECK (Stock >= 0)
);

CREATE TABLE GiftRedemption (
    RedemptionID INT PRIMARY KEY,
    GiftID INT NOT NULL,
    CardID INT NOT NULL,
    StaffID INT NOT NULL,
    TicketsDeducted INT NOT NULL CHECK (TicketsDeducted >= 0),
    Time TIME NOT NULL,
    Date DATE NOT NULL,
    FOREIGN KEY (GiftID) REFERENCES Gift(GiftID),
    FOREIGN KEY (CardID) REFERENCES CustomerCard(CardID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

CREATE TABLE DepositTransaction (
    DepositID INT PRIMARY KEY,
    CustomerCardID INT NOT NULL,
    CashierID INT NOT NULL,
    AmountDeposited DECIMAL(10,2) NOT NULL CHECK (AmountDeposited > 0),
    Time TIME NOT NULL,
    Date DATE NOT NULL,
    FOREIGN KEY (CustomerCardID) REFERENCES CustomerCard(CardID),
    FOREIGN KEY (CashierID) REFERENCES Staff(StaffID)
);

CREATE TABLE GameTransaction (
    GameTransactionID INT PRIMARY KEY,
    GameMachineID INT NOT NULL,
    CardID INT NOT NULL,
    AmountDeducted DECIMAL(10,2) NOT NULL CHECK (AmountDeducted >= 0),
    TicketsEarned INT NOT NULL CHECK (TicketsEarned >= 0),
    DiscountApplied DECIMAL(5,2) DEFAULT 0 CHECK (DiscountApplied >= 0 AND DiscountApplied <= 100),
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Date DATE NOT NULL,
    FOREIGN KEY (GameMachineID) REFERENCES GameMachine(GameMachineID),
    FOREIGN KEY (CardID) REFERENCES CustomerCard(CardID)
);

CREATE TABLE CardDiscount (
    CardTypeID INT PRIMARY KEY,
    CardID INT NOT NULL,
    CardName NVARCHAR(50) NOT NULL,
    DiscountPercentage DECIMAL(5,2) NOT NULL CHECK (DiscountPercentage >= 0 AND DiscountPercentage <= 100),
    FOREIGN KEY (CardID) REFERENCES CustomerCard(CardID)
);
