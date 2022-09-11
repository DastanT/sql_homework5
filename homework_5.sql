/*
 *	Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»
 *
 *	1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
	2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое 
	время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
	3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, 
	если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, 
	чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.
	4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка 
	английских названий (may, august).
	5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2);
	Отсортируйте записи в порядке, заданном в списке IN.

 * 
 * */

USE shop;
-- 1.
UPDATE shop.users
SET 
	created_at=CURRENT_TIMESTAMP, 
	updated_at=CURRENT_TIMESTAMP;

SELECT * FROM users;

-- 2.
ALTER TABLE shop.users 
CHANGE 
	created_at created_at DATETIME,
CHANGE
	updated_at updated_at DATETIME;

SELECT 
	id,
	name,
	birthday_at,
	DATE_FORMAT(created_at, '%d.%m.%y %H:%m') AS created_at,
	DATE_FORMAT(updated_at, '%d.%m.%y %H:%m') AS updated_at
FROM shop.users;

-- 3.
SELECT * FROM shop.products;
SELECT * FROM storehouses_products;

INSERT IGNORE INTO storehouses_products 
	(id, storehouse_id, product_id, value, created_at, updated_at)
VALUES
	(1, 1, 1, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	(2, 2, 2, 5, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	(3, 3, 3, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	(4, 4, 4, 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	(5, 5, 5, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	(6, 6, 6, 17, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
	(7, 7, 7, 20, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

SELECT 
	id, 
	storehouse_id, 
	product_id, 
	value,
	created_at, 
	updated_at
FROM shop.storehouses_products
ORDER BY CASE WHEN value = 0 then 1 else 0 end, value

-- 4.
SELECT 
	id, 
	name, 
	DATE_FORMAT(birthday_at, '%Y-%M-%d') as birthday_at, -- если я правильно понял, то месяц надо отобразить в списке английских названий
	created_at, 
	updated_at
FROM shop.users
WHERE DATE_FORMAT(birthday_at, '%M') in ('May', 'August'); 

-- 5.
SELECT * FROM catalogs WHERE id IN (5, 1, 2) -- не много не понял задания, но сделал так. 
ORDER BY CASE WHEN id = 2 then 1 else 0 end, name

------------------------------------------------------------------

/*
 * 1. Подсчитайте средний возраст пользователей в таблице users.
   2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
   Следует учесть, что необходимы дни недели текущего года, а не года рождения.
   3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.
 */

-- 1.
SELECT 
	round(avg((to_days(now()) - to_days(birthday_at)) / 365.25)) AS avg_age -- средний возраст
FROM shop.users;

-- 2. 
SELECT
    DAYNAME(CONCAT(YEAR(NOW()), '-', SUBSTRING(birthday_at, 6, 10))) AS week_day_of_birthday_in_this_Year,
    COUNT(*) AS amount_of_birthday
FROM shop.users
GROUP BY week_day_of_birthday_in_this_Year
ORDER BY amount_of_birthday DESC;

-- 3.
-- не понял задания