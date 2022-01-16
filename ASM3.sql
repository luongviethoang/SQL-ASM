create database asm3
go

use asm3
create table ThongTin(
TenKH nvarchar(100),
SoCMT int primary key,
DiaChi nvarchar(100)
)

insert into ThongTin VALUES
(N'Lương Viết Hoàng', 00123456784, N'Hạ Long')
(N'Nguyễn Bá Khánh', 00123456789, N'Hà Nội'),
(N'Đinh Quang Anh', 00123456788, N'Ninh Bình'),
(N'Tạ Duy Linh', 0012345687, N'Thái Nguyên'),
(N'Nguyễn Mạnh Kiên', 00123456786, N'Nhà Thầy'),
(N'Tạ Văn Minh', 00123456785, N'Thanh Hóa'),

create table GiayDK(
TenKH nvarchar(100),
SoCMT int references ThongTin(SoCMT),
DiaChi nvarchar(100) references ThanhPho(DiaChi),
ThueBao varchar(100) primary key,
LoaiTB nvarchar(40),
NgayDK date
)

insert into GiayDK values 
(N'Lương Viết Hoàng', 00123456784, N'Hạ Long', '0979908276', N'Trả trước', '2021-12-26')
(N'Nguyễn Bá Khánh', 00123456789, N'Hà Nội', '0392652354', N'Trả trước', '2021-12-31'),
(N'Tạ Duy Linh', 0012345687, N'Thái Nguyên', '0912531353', N'Trả trước', '2021-12-31'),
(N'Đinh Quang Anh', 00123456788, N'Ninh Bình', '091242353', N'Trả trước', '2021-12-28'),
(N'Nguyễn Mạnh Kiên', 00123456786, N'Nhà Thầy', '092351543', N'Trả trước', '2021-12-30'),
(N'Tạ Văn Minh', 00123456785, N'Thanh Hóa', '012412453', N'Trả trước', '2021-12-30'),

create table ThanhPho(
MaTP int,
DiaChi nvarchar(100) primary key
)

insert into ThanhPho values 
(1, N'Hà Nội'),
(2, N'Thái Nguyên'),
(3, N'Hạ Long'),
(3, N'Ninh Bình'),
(4, N'Thanh Hóa'),
(5, N'Thái Bình'),
(9999, N'Nhà Thầy')

--Lấy toàn bộ thông tin khách hàng
select * from ThongTin

--Lấy toàn bộ thông tin khách hàng đã đăng kí thuê bao
select * from GiayDK

--Lấy toàn bộ thông tin của thuê bao có số 0987729543
select * from GiayDK where ThueBao = '0979908276'

--Lấy toàn bộ thông tin của khách hàng có số chứng minh thư 0123456789
select * from ThongTin where SoCMT = '00123456789'

--Lấy toàn bộ số thuê bao mà khách hàng có số chứng minh thư 0123456789 đã đăng kí
select ThueBao from GiayDK where SoCMT = '00123456789'

--Lấy toàn bộ số thuê bao được đăng kí vào ngày 31 tháng 12 năm 2021
select ThueBao from GiayDK where NgayDK = '2021-12-31'

--Lấy toàn bộ số thuê bao đăng kí có địa chỉ tại Hà Nội
select ThueBao from GiayDK where DiaChi = N'Hà Nội'

--Đếm tổng số khách hàng đăng kí thue bao
select COUNT(TenKH) from ThongTin 

--Đếm tổng số thuê bao đã đăng kí
select COUNT(ThueBao) from GiayDK

--Đếm tổng số thuê bao đăng kí trong ngày 31 tháng 12 năm 2021
select COUNT(NgayDK) from GiayDK where NgayDK='2021-12-31'

--Hiển thị toàn bộ thông tin thuê bao, khách hàng đã đăng kí thuê bao
select * from GiayDK

--Thêm ràng buộc not null cho trường Ngày đăng kí
alter table GiayDK
alter column NgayDK date not null

--Thêm ràng buộc ngày đăng kí phải nhỏ hơn ngày hiện tại cho trường ngày đăng kí
alter table GiayDK
add constraint check_date check (NgayDK < Getdate())

--Thêm trường điểm thưởng cho bảng giấy đăng kí
alter table GiayDK
add DiemThuong int 

--Tạo index và view
create index IX_TenKhach on ThongTin(TenKH)

create view View_KhachHang as
select TenKH, SoCMT, DiaChi from GiayDK

create view View_KhachHang_ThueBao as 
select ThongTin.TenKH, ThongTin.SoCMT, GiayDK.ThueBao from ThongTin
join GiayDK
on GiayDK.SoCMT = ThongTin.SoCMT

--Tạo procedure
create proc SP_TimKH_ThueBao 
@ThueBao varchar(100)
as
select * from ThongTin
join GiayDK 
on GiayDK.SoCMT = ThongTin.SoCMT 
where GiayDK.ThueBao = @ThueBao 
go
exec SP_TimKH_ThueBao '0979908276'
go

create proc SP_TimTB_KhachHang 
@TenKH nvarchar(100)
as
select * from GiayDK where TenKH = @TenKH
go
exec SP_TimTB_KhachHang N'Lương Viết Hoàng'
go

create proc SP_ThemTB 
as
insert into GiayDK values (N'Lương Viết Hoàng', 00123456789, N'Hà Nội', '0979908276', N'Trả trước', '2021-12-31', '')
go
exec SP_ThemTB
go

create proc SP_HuyTB_MaKH 
@MaKH int
as
delete from GiayDK where GiayDK.SoCMT = @MaKH 
go
exec SP_HuyTB_MaKH 001203025446
go