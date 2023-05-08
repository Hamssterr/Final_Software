create database saleManagement
go
use saleManagement

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

create table item
(
	id varchar(20) primary key,
	name nvarchar(50),
	price int,
	soldQuantity int
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

insert into accountant values('ac1', 'Quan Tri Vien', '123', 'admin', '123456')
insert into accountant values('ac2', 'Thanh Tuan', '456', 'tuan', '123456')
insert into accountant values('ac3', 'Nam Phat', '789', 'phat', '123456')

insert into agent values('ag1', 'Công ty TNHH Tuan Phat', '123', 'admin', '123456')
insert into agent values('ag2', 'Công ty A', '456', 'agent2', '123456')
insert into agent values('ag3', 'Công ty B', '789', 'agent3', '123456')

insert into item values('it1', N'Áo dài', 100000, 100)
insert into item values('it2', N'Quần dài', 100000, 100)
insert into item values('it3', N'Mũ', 10000, 200)
insert into item values('it4', N'Áo khoác', 200000, 150)
insert into item values('it5', N'Dép', 30000, 180)
insert into item values('it6', N'Giày', 250000, 190)
insert into item values('it7', N'Kính mát', 50000, 250)
insert into item values('it8', N'Đồng hồ', 1000000, 210)
insert into item values('it9', N'Dây chuyền', 500000, 200)
insert into item values('it10', N'Nhẫn', 300000, 300)

insert into receipt values('re1', '2023-02-24', 'ac1', 0)
insert into receipt values('re2', '2023-03-15', 'ac1', 0)
insert into receipt values('re3', '2023-11-07', 'ac2', 0)

insert into detailReceipt values('re1', 'it1', 10)
insert into detailReceipt values('re1', 'it2', 20)
insert into detailReceipt values('re1', 'it5', 30)
insert into detailReceipt values('re1', 'it7', 10)
insert into detailReceipt values('re2', 'it2', 40)
insert into detailReceipt values('re2', 'it3', 20)
insert into detailReceipt values('re2', 'it5', 30)
insert into detailReceipt values('re3', 'it2', 50)
insert into detailReceipt values('re3', 'it4', 20)
insert into detailReceipt values('re3', 'it9', 10)

insert into orders values('or1', '2023-02-24', 'ag1', 0, N'Momo')
insert into orders values('or2', '2023-03-15', 'ag2', 0, N'Tiền mặt')
insert into orders values('or3', '2023-11-07', 'ag3', 0, N'Chuyển khoản')

insert into detailOrder values('or1', 'it1', 10)
insert into detailOrder values('or1', 'it2', 20)
insert into detailOrder values('or1', 'it5', 30)
insert into detailOrder values('or1', 'it7', 10)
insert into detailOrder values('or2', 'it2', 40)
insert into detailOrder values('or2', 'it3', 20)
insert into detailOrder values('or2', 'it5', 30)
insert into detailOrder values('or3', 'it2', 50)
insert into detailOrder values('or3', 'it4', 20)
insert into detailOrder values('or3', 'it9', 10)

UPDATE receipt
	SET totalPrice = COALESCE(T.total, 0)
	FROM receipt LEFT JOIN (
		SELECT r.id, sum(i.price * d.quantity) as total
		FROM receipt r, detailReceipt d, item i
		WHERE r.id = d.idReceipt and d.idItem = i.id
		GROUP BY r.id
	) T
	ON receipt.id = T.id

UPDATE orders
	SET totalPrice = COALESCE(T.total, 0)
	FROM orders LEFT JOIN (
		SELECT o.id, sum(i.price * d.quantity) as total
		FROM orders o, detailOrder d, item i
		WHERE o.id = d.idOrder and d.idItem = i.id
		GROUP BY o.id
	) T
	ON orders.id = T.id

select * from receipt
select * from orders