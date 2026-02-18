/*
--------------------------------------------------------------------
© 2017 sqlservertutorial.net All Rights Reserved
--------------------------------------------------------------------
Name   : BikeStores
Link   : http://www.sqlservertutorial.net/load-sample-database/
Version: 1.0 (Adaptado para Oracle SQL)
--------------------------------------------------------------------
*/

-- Crear usuarios/schemas (en Oracle, los schemas son usuarios)
-- Nota: Necesitarás ejecutar estos comandos con privilegios de DBA
-- CREATE USER production IDENTIFIED BY password;
-- GRANT CONNECT, RESOURCE TO production;
-- CREATE USER sales IDENTIFIED BY 123;
-- GRANT CONNECT, RESOURCE TO sales;

-- Crear tablas en schema production
CREATE TABLE sales.categories (
	category_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	category_name VARCHAR2(255) NOT NULL
);

CREATE TABLE sales.brands (
	brand_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	brand_name VARCHAR2(255) NOT NULL
);

CREATE TABLE sales.products (
	product_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	product_name VARCHAR2(255) NOT NULL,
	brand_id NUMBER NOT NULL,
	category_id NUMBER NOT NULL,
	model_year NUMBER(4) NOT NULL,
	list_price NUMBER(10, 2) NOT NULL,
	CONSTRAINT fk_products_category FOREIGN KEY (category_id) 
		REFERENCES sales.categories (category_id) ON DELETE CASCADE,
	CONSTRAINT fk_products_brand FOREIGN KEY (brand_id) 
		REFERENCES sales.brands (brand_id) ON DELETE CASCADE
);

-- Crear tablas en schema sales
CREATE TABLE sales.customers (
	customer_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	first_name VARCHAR2(255) NOT NULL,
	last_name VARCHAR2(255) NOT NULL,
	phone VARCHAR2(25),
	email VARCHAR2(255) NOT NULL,
	street VARCHAR2(255),
	city VARCHAR2(50),
	state VARCHAR2(25),
	zip_code VARCHAR2(5)
);

CREATE TABLE sales.stores (
	store_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	store_name VARCHAR2(255) NOT NULL,
	phone VARCHAR2(25),
	email VARCHAR2(255),
	street VARCHAR2(255),
	city VARCHAR2(255),
	state VARCHAR2(10),
	zip_code VARCHAR2(5)
);

CREATE TABLE sales.staffs (
	staff_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	first_name VARCHAR2(50) NOT NULL,
	last_name VARCHAR2(50) NOT NULL,
	email VARCHAR2(255) NOT NULL UNIQUE,
	phone VARCHAR2(25),
	active NUMBER(1) NOT NULL,
	store_id NUMBER NOT NULL,
	manager_id NUMBER,
	CONSTRAINT fk_staffs_store FOREIGN KEY (store_id) 
		REFERENCES sales.stores (store_id) ON DELETE CASCADE,
	CONSTRAINT fk_staffs_manager FOREIGN KEY (manager_id) 
		REFERENCES sales.staffs (staff_id)
);

CREATE TABLE sales.orders (
	order_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	customer_id NUMBER,
	order_status NUMBER(1) NOT NULL,
	-- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
	order_date DATE NOT NULL,
	required_date DATE NOT NULL,
	shipped_date DATE,
	store_id NUMBER NOT NULL,
	staff_id NUMBER NOT NULL,
	CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) 
		REFERENCES sales.customers (customer_id) ON DELETE CASCADE,
	CONSTRAINT fk_orders_store FOREIGN KEY (store_id) 
		REFERENCES sales.stores (store_id) ON DELETE CASCADE,
	CONSTRAINT fk_orders_staff FOREIGN KEY (staff_id) 
		REFERENCES sales.staffs (staff_id)
);

CREATE TABLE sales.order_items (
	order_id NUMBER,
	item_id NUMBER,
	product_id NUMBER NOT NULL,
	quantity NUMBER NOT NULL,
	list_price NUMBER(10, 2) NOT NULL,
	discount NUMBER(4, 2) DEFAULT 0 NOT NULL,
	CONSTRAINT pk_order_items PRIMARY KEY (order_id, item_id),
	CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) 
		REFERENCES sales.orders (order_id) ON DELETE CASCADE,
	CONSTRAINT fk_order_items_product FOREIGN KEY (product_id) 
		REFERENCES sales.products (product_id) ON DELETE CASCADE
);

CREATE TABLE sales.stocks (
	store_id NUMBER,
	product_id NUMBER,
	quantity NUMBER,
	CONSTRAINT pk_stocks PRIMARY KEY (store_id, product_id),
	CONSTRAINT fk_stocks_store FOREIGN KEY (store_id) 
		REFERENCES sales.stores (store_id) ON DELETE CASCADE,
	CONSTRAINT fk_stocks_product FOREIGN KEY (product_id) 
		REFERENCES sales.products (product_id) ON DELETE CASCADE
);