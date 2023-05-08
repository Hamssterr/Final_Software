create database saleManagement
go
use saleManagement

create table item
(
	id varchar(20) primary key,
	name nvarchar(50),
	inventory int
)

create table accountant
(
	id varchar(20) primary key,
	name varchar(50),
	phone varchar(50),
	account varchar(50),
	password varchar(50)
)

create table agent
(
	id varchar(20) primary key,
	name varchar(50),
	phone varchar(50),
	account varchar(50),
	password varchar(50)
)

create table receipt
(
	id varchar(20) primary key,
	foundDate date,
	idAccountant varchar(20),
	totalPrice int,
	foreign key(idAccountant) references accountant(id)
)

create table detailReceipt
(
	idReceipt varchar(20),
	idItem varchar(20),
	price int,
	quantity int,
	primary key(idReceipt, idItem),
	foreign key(idReceipt) references receipt(id),
	foreign key(idItem) references item(id),
)

-- Cannot name 'Order'
create table orders
(
	id varchar(20) primary key,
	foundDate date,
	idAgent varchar(20),
	totalPrice int,
	paymentMethod nvarchar(50)
	foreign key (idAgent) references agent(id)
)

create table detailOrder
(
	idOrder varchar(20),
	idItem varchar(20),
	price int,
	quantity int,
	primary key(idOrder, idItem),
	foreign key(idOrder) references Orders(id),
	foreign key(idItem) references item(id),
)

create table Bill
(
	id varchar(20) primary key,
	foundDate date,
	idOrder varchar(20),
	idAccountant varchar(20),
	deliveryStatus bit,
	paymentStatus bit,
	foreign key(idOrder) references orders(id),
	foreign key(idAccountant) references accountant(id)
)

--item
insert into item values('it1', N'Áo dài', 0)
insert into item values('it2', N'Quần dài', 0)
insert into item values('it3', N'Mũ', 0)
insert into item values('it4', N'Áo khoác', 0)
insert into item values('it5', N'Dép', 0)
insert into item values('it6', N'Giày', 0)
insert into item values('it7', N'Kính mát', 0)
insert into item values('it8', N'Đồng hồ', 0)
insert into item values('it9', N'Dây chuyền', 0)
insert into item values('it10', N'Nhẫn', 0)

--accountant
insert into accountant values('ac1', 'Quan Tri Vien', '123', 'admin', '123456')
insert into accountant values('ac2', 'Thanh Tuan', '456', 'tuan', '123456')
insert into accountant values('ac3', 'Nam Phat', '789', 'phat', '123456')

--agent
insert into agent values('ag1', 'Công ty TNHH Tuan Phat', '123', 'admin', '123456')
insert into agent values('ag2', 'Công ty A', '456', 'agent2', '123456')
insert into agent values('ag3', 'Công ty B', '789', 'agent3', '123456')

--receipt
insert into receipt values('re1', '2022-11-07', 'ac1', 0)
insert into receipt values('re2', '2023-02-24', 'ac1', 0)
insert into receipt values('re3', '2023-03-15', 'ac2', 0)

--detail receipt
insert into detailReceipt values('re1', 'it1', 500000, 10)
insert into detailReceipt values('re1', 'it2', 600000, 20)
insert into detailReceipt values('re1', 'it5', 400000, 30)
insert into detailReceipt values('re1', 'it7', 350000, 10)
insert into detailReceipt values('re2', 'it2', 700000, 40)
insert into detailReceipt values('re2', 'it3', 800000, 20)
insert into detailReceipt values('re2', 'it5', 950000, 30)
insert into detailReceipt values('re3', 'it2', 100000, 50)
insert into detailReceipt values('re3', 'it4', 200000, 20)
insert into detailReceipt values('re3', 'it9', 10000, 10)

--order
insert into orders values('or1', '2023-01-24', 'ag1', 0, N'Momo')
insert into orders values('or2', '2023-02-10', 'ag2', 0, N'Tiền mặt')
insert into orders values('or3', '2023-03-07', 'ag2', 0, N'Chuyển khoản')

--detail order
insert into detailOrder values('or1', 'it1', 700000, 10)
insert into detailOrder values('or1', 'it2', 550000, 20)
insert into detailOrder values('or1', 'it4', 120000, 15)
insert into detailOrder values('or1', 'it9', 100000, 10)
insert into detailOrder values('or2', 'it2', 200000, 30)
insert into detailOrder values('or2', 'it4', 400000, 20)
insert into detailOrder values('or2', 'it7', 700000, 20)
insert into detailOrder values('or3', 'it3', 350000, 50)
insert into detailOrder values('or3', 'it5', 200000, 20)
insert into detailOrder values('or3', 'it9', 150000, 15)

--update total price of receipt
UPDATE receipt
	SET totalPrice = COALESCE(T.total, 0)
	FROM receipt LEFT JOIN (
		SELECT r.id, sum(d.price * d.quantity) as total
		FROM receipt r JOIN detailReceipt d ON r.id = d.idReceipt
		GROUP BY r.id
	) T
	ON receipt.id = T.id

--update total price of order
UPDATE orders
	SET totalPrice = COALESCE(T.total, 0)
	FROM orders LEFT JOIN (
		SELECT o.id, sum(d.price * d.quantity) as total
		FROM orders o JOIN detailOrder d ON o.id = d.idOrder
		GROUP BY o.id
	) T
	ON orders.id = T.id

select * from receipt
select * from orders