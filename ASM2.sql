create database asm02
go

use asm02
create table Hang(
MaHang int NOT NULL primary key,
TenHang nvarchar(40),
DiaChi nvarchar(100),
DienThoai int
)

insert into Hang values
(123, N'ASUS', N'USA', 0981256),
(124, N'DELL', N'USA', 0912571),
(125, N'LENOVO', N'Malaysia', 09125125),
(126, N'APPLE', N'USA', 0912512),
(127, N'MSI', N'ThaiLand', 0912512),
(128, N'ROG', N'USA', 09125125),
(220, N'NOKIA', N'USA', 0912512),
(221, N'SAMSUNG', N'Malaysia', 0912357),
(222, N'OPPO', N'USA', 09123587),
(223, N'XIAOMI', N'China', 0912457)


create table Kho(
MaSP varchar(40) primary key,
TenSP nvarchar(100),
MaHang int references Hang(MaHang),
MoTa nvarchar(100),
DonVi nvarchar (40),
Gia int,
SoLuong int
)

insert into Kho values 
('123X2', N'LapTop', 123, N'Còn mới', N'Chiếc', 25000, 10),
('123X3', N'LapTop', 123, N'Còn mới', N'Chiếc', 24000, 20),
('124Y6', N'LapTop', 124, N'Còn mới', N'Chiếc', 25500, 11),
('124Y7', N'LapTop', 124, N'Còn mới', N'Chiếc', 23300, 8),
('125R8', N'LapTop', 125, N'Còn mới', N'Chiếc', 24000, 3),
('125R9', N'Điện thoại', 125, N'Còn mới', N'Chiếc', 8000, 9),
('126A10', N'Điện thoại', 126, N'Còn mới', N'Chiếc', 9500, 12),
('126A13', N'Điện thoại', 126, N'Còn mới', N'Chiếc', 9500, 15),
('127C9', N'Điện thoại', 127, N'Còn mới', N'Chiếc', 8500, 9999),
('127C2', N'Điện thoại', 127, N'99%', N'Chiếc', 6500, 25),
('127C12', N'LapTop', 127, N'99%', N'Chiếc', 16000, 9999),
('220T1', N'LapTop', 220, N'99%', N'Chiếc', 15500, 12),
('220T12', N'LapTop', 220, N'99%', N'Chiếc', 18000, 4),
('220T13', N'Điện thoại', 220, N'99%', N'Chiếc', 5500, 9999)

create table Loai(
MaLoai varchar(40),
LoaiSP nvarchar(100)
)

insert into Loai values 
('X', N'Điện thoại'),
('Y', N'LapTop')

--Hiển thị tên các hãng 
select TenHang from Hang

--Hiển thị tên các sản phẩn bán
select TenSP from Kho

--Sắp xếp tên sản phẩm theo bảng chữ cái alphabet
select TenSP from Kho order by TenSP ASC

--Sắp xếp tên sản phẩm theo giá giảm dần
select TenSP, Gia from Kho order by Gia DESC

--Hiển thị thông tin của hãng ASUS
select * from Hang where TenHang = 'ASUS'

--Hiển thị các mặt hàng có số lượng hàng ít hơn 11 trong kho
select * from Kho where SoLuong < 11

--Hiển thị các sản phẩm của hãng ASUS
select * from Kho where MaHang = 123

--Đếm số hãng mà cửa hàng bán
select count(MaHang) from Hang 

--Đếm số mặt hàng có trong kho
select count(TenSP) from Kho

--Đếm số lượng sản phẩm của từng hãng
select count(TenSP) from Kho where MaHang = '123' --Thay đổi mã hãng để đếm số lượng sản phẩm của các hãng còn lại

--Đếm số đầu sản phẩm có bán tại cửa hàng
select count (LoaiSP) from Loai

--Cập nhật yêu cầu giá luôn dương (lớn hơn 0)
alter table Kho 
add constraint price check (Gia>0)

--Cập nhật yêu cầu số điện thoại phải bắt đầu bằng số 0 -> chuyển kiểu dữ liệu sang nvarchar hoặc varchar
alter table Hang
alter column DienThoai nvarchar(100)

--Tạo View và Index 
create index IX_TenHang on Hang(TenHang)
create index IX_MoTa on Kho(MoTa)

create view View_SanPham as
select MaSP, TenSP, Gia from Kho

select * from View_SanPham_Hang

create view View_SanPham_Hang as
select Kho.MaSP, Kho.TenSP, Hang.TenHang from Kho
join Hang
on Kho.MaHang = Hang.MaHang

--Ex8
create proc SP_SanPham_TenHang as
select * from Hang 
go

create proc SP_SanPham_Gia as
select * from Kho where Kho.Gia > 10000
go

create proc SP_SanPham_HetHang as
select * from Kho where Kho.SoLuong = 0
go

create trigger TG_Xoa_Hang 
on Hang
for delete
as
	begin
	rollback transaction;
	print N'Không được phép xóa hãng'
end

create trigger TG_Xoa_SanPham
on Kho
for delete
as
	declare @SL int
	select @SL = deleted.SoLuong from deleted 
	where deleted.SoLuong = 0
	if @SL is null
	begin
	rollback transaction;
	print N'Không thể xóa'
end
go

delete from Kho where SoLuong = 3

update Kho
set SoLuong = 0
where MaHang = 124
go

select * from Kho