

create database Task04
go
use Task04
go
create table Customer(
	CustomerID int primary key,
	CustomerName nvarchar(150),
	CustomerAddress nvarchar(300),
	Tel varchar(40)
)
go
create table Product(
	ProductID varchar(40) primary key,
	ProductName nvarchar(200),
	Unit nvarchar(40),
	Price money,
	Quantity int,
	ProductStatus nvarchar(300)
)
go
create table Orders(
	OrderID varchar(40) primary key,
	CustomerID int foreign key references Customer(CustomerID),
	OrderDate date
)
go
create table OrderDetails(
	OrderID varchar(40) foreign key references Orders(OrderID),
	ProductID varchar(40) foreign key references Product(ProductID),
	OrderStatus nvarchar(300),
	Price money,
	Quantity int
)
go
insert into Customer(CustomerID, CustomerName, CustomerAddress, Tel)
	values
		(123, N'Lương Viết Hoàng', N'Hà Nội', '25785757'),
		(124, N'Hoàng hoa Thám', N'Thái Nguyên', '245242425'),
		(125, N'Hứa Viết Hoàng', N'Tây Nguyên', '5244545')
go
insert into Product(ProductID, ProductName, ProductStatus, Unit, Price, Quantity)
	values
		('LAP1', N'Laptop apple', N'Hàng tồn', N'Chiếc', 23999000, 50),
		('LAP2', N'Laptop Lenovo', N'Hàng tồn kho', N'Chiếc', 13499000, 10),
		('SMP1', N'SmartPhone SamSung A22', N'Điện thoại tồn', N'Chiếc', 69999000, 20)
go
insert into Orders (OrderID, CustomerID, OrderDate)
	values
		('ord1', 123, '20211224'),
		('ord2', 124, '20211225'),
		('ord3', 125, '20211226'),
		('ord4', 123, '20211224')
go
insert into OrderDetails(OrderID, ProductID, OrderStatus, Price, Quantity)
	values
		('ord1', 'LAP1', N'Đã nhận đơn', 23999000, 2),
		('ord1', 'LAP2', N'Đã nhận đơn', 13499000, 3),
		('ord2', 'LAP1', N'Đang Kiểm Tra', 13499000, 3),
		('ord3', 'SMP1', N'Đang giao hàng', 6999000, 10),
		('ord4', 'SMP1', N'Đang giao hàng', 6999000, 10)
	select CustomerName from Customer 
	where CustomerID in (
		select CustomerID from Orders
	)
	select ProductName from Product
	select OrderID from Orders
	select CustomerName from Customer
	order by CustomerName 
	select ProductName,Price from Product
	order by Price DESC
	select ProductName from Product
	where ProductID in (
		select ProductID from OrderDetails
		where OrderID in (
			select OrderID from Orders
			where CustomerID = 123
		)
	)
	select COUNT (Distinct CustomerID) from Orders
	select count (ProductID) from Product
	select OrderID, sum(Price*Quantity) as 'TotalAmount' from OrderDetails
	group by OrderID 
	alter table Product
		add constraint Ck_Product_Price Check(Price > 0) 
	alter table OrderDetails
		add constraint Ck_OrdDetails_Price Check(Price > 0)
	alter table Orders
		add constraint Ck_Ord_Date Check (OrderDate < getDate())
	alter table Product
		add PublicDate date		