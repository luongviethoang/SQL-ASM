create database ASM4
go

use ASM4
create table Nguoi(
Ten nvarchar(100),
MaNguoi int primary key
)

insert into Nguoi VALUES
(N'Lương Viết hoàng', 81106)
(N'Nguyễn Bá Khánh', 81103),
(N'Đinh Quang Anh', 81102),
(N'Vũ Viết Quý', 81101),
(N'Tạ Duy Linh', 81100),
(N'Nguyễn Mạnh Kiên', 81104),
(N'Tạ Văn Minh', 81105),

create table LoaiSP(
MaLoai varchar(100) primary key,
TenLoai nvarchar(100)
)

insert into LoaiSP values
('X1', N'Máy tính xách tay'),
('X2', N'Điện thoại để bàn'),
('X3', N'Điện thoại di động'),
('X4', N'Máy tính để bàn')

create table SanPham(
NgaySX date,
TenSP nvarchar(100),
MaSP varchar(100) primary key
)

insert into SanPham values 
('2018-12-23', N'Máy tính xách tay X1000', 'X1000'),
('2018-6-30', N'Điện thoại để bàn X200', 'X200'),
('2019-5-23', N'Điện thoại để bàn X212', 'X212')

create table Phieu(
MaSP varchar(100) references SanPham(MaSP),
TenSP nvarchar(100),
NgaySX date,
TenLoai nvarchar(100), 
MaLoai varchar(100) references LoaiSP(MaLoai),
Ten nvarchar(100),
MaNguoi int references Nguoi(MaNguoi)
)

insert into Phieu values 
('X1000', N'Máy tính xách tay X1000', '2018-12-23', N'Máy tính xách tay', 'X1', N'Nguyễn Bá Khánh', 81103),
('X200', N'Điện thoại để bàn X200', '2018-6-30', N'Điện thoại để bàn', 'X2', N'Vũ Viết Quý', 81101),
('X212', N'Điện thoại để bàn X212', '2019-5-23', N'Điện thoại để bàn', 'X2', N'Đinh Quang Anh', 81102)

--Hiển thị tất cả loại sản phẩm
select * from LoaiSP

--Hiển thị tên tất cả sản phẩm
select * from SanPham

--Hiển thị tất cả tên, mã người chịu trách nhiệm
select * from Nguoi

--Hiển thị tên loại sản phẩm theo thứ tự bảng chữ cái alphabet
select * from LoaiSP order by TenLoai ASC

--Hiển thị tên người chịu trách nhiệm theo thứ tự bảng chữ cái alphabet
select * from Nguoi order by Ten ASC

--Hiển thị tất cả sản phẩm có mã loại bằng X1
select TenLoai from LoaiSP where MaLoai='X1'

--Hiển thị tất cả thông tin về sản phẩm do Lương Viết Hoàng chịu trách nhiệm theo thứu tự bảng chữ cái alphabet
select TenSP from Phieu where Ten = N'Lương Viết Hoàng' order by Ten ASC

--Đếm số lượng sản phẩm của loại có mã là X1
select count(MaLoai) from Phieu where MaLoai = 'X1' -- thay đổi mã loại để đếm số lượng sản phẩm của các loại khác

--Hiển thị toàn bộ thông tin của sản phẩm và loại sản phẩm hiện có
select * from LoaiSP
select * from SanPham

--Hiển thị toàn bộ thông tin sản phẩm, loại sản phẩm, người chịu trách nhiệm, ...
select * from Phieu

--Thêm điều kiện ngày sản xuất phải nhỏ hơn ngày hiện tại
alter table SanPham
add constraint check_date check (NgaySX<=getdate())

--Thêm một trường phiên bản cho bảng Sản Phẩm
alter table SanPham
add PhienBan varchar(100)

--Tạo index và view 
create index IX_PerSon on Nguoi(Ten)

create view View_SanPham_NCTN as 
select MaSP, NgaySX, Ten from Phieu

create view View_SanPham as
select MaSP, NgaySX, TenLoai from Phieu

create view View_SanPham_Top as
select MaSP, TenLoai, NgaySX from Phieu

create proc SP_Them_LoaiSP
as
insert into LoaiSP values ('X5', N'Máy tính bảng')
go
exec SP_Them_LoaiSP
go

create proc SP_Them_NCTN
as
insert into Nguoi values (N'Lương Viết Hoàng', 81104)
go
exec SP_ThemNCTN
go