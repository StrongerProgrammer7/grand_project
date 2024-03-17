--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

-- Started on 2024-03-17 07:43:22

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS "Restaurant";
--
-- TOC entry 4986 (class 1262 OID 24576)
-- Name: Restaurant; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "Restaurant" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


ALTER DATABASE "Restaurant" OWNER TO postgres;

\connect "Restaurant"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 245 (class 1255 OID 58714)
-- Name: add_client(character varying, character varying, timestamp with time zone); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_client(IN _phone character varying, IN _how_to_appeal character varying, IN _last_contact_date timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO client
		(phone, how_to_appeal, last_contact_date)
	VALUES
		(_name, _how_to_appeal, date_trunc('second', now()));
END
$$;


ALTER PROCEDURE public.add_client(IN _phone character varying, IN _how_to_appeal character varying, IN _last_contact_date timestamp with time zone) OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 58826)
-- Name: add_client_order(integer, integer[], integer[], timestamp with time zone, timestamp with time zone, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_client_order(IN _worker_id integer, IN _food_ids integer[], IN _quantities integer[], IN _formation_date timestamp with time zone, IN _issue_date timestamp with time zone, IN _status character varying DEFAULT NULL::character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    order_id INTEGER;
    i INTEGER;
BEGIN
    -- Вставка записи в таблицу order_directory
    INSERT INTO order_directory
        (id_worker, formation_date, issue_date, status)
    VALUES
        (_worker_id, _formation_date, _issue_date, _status)
    RETURNING id INTO order_id;

    -- Вставка записей в таблицу order_food для каждого блюда в заказе
    FOR i IN 1..array_length(_food_ids, 1) LOOP
        INSERT INTO order_food
            (id_order, id_food, quantity)
        VALUES
            (order_id, _food_ids[i], _quantities[i]);
    END LOOP;
END
$$;


ALTER PROCEDURE public.add_client_order(IN _worker_id integer, IN _food_ids integer[], IN _quantities integer[], IN _formation_date timestamp with time zone, IN _issue_date timestamp with time zone, IN _status character varying) OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 50452)
-- Name: add_food(character varying, character varying, character varying, double precision, double precision); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_food(IN _food_type character varying, IN _name character varying, IN _unit_of_measurement character varying, IN _price double precision, IN _weight double precision DEFAULT NULL::double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO food
		("type", "name", unit_of_measurement, price, weight)
	VALUES
		(_food_type, _name, _unit_of_measurement, _price, _weight);
END
$$;


ALTER PROCEDURE public.add_food(IN _food_type character varying, IN _name character varying, IN _unit_of_measurement character varying, IN _price double precision, IN _weight double precision) OWNER TO postgres;

--
-- TOC entry 244 (class 1255 OID 50453)
-- Name: add_food_composition(character varying, character varying, double precision); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_food_composition(IN _food_name character varying, IN _ingredient_name character varying, IN _ingredient_weight double precision)
    LANGUAGE plpgsql
    AS $$
DECLARE
	_food_id INTEGER;
	_ingredient_id INTEGER;
BEGIN

	SELECT "id" INTO _food_id FROM food WHERE "name" = _food_name;

	SELECT "id" INTO _ingredient_id FROM ingredient WHERE "name" = _ingredient_name;

	INSERT INTO food_composition
		(id_food, id_ingredient, weight)
	VALUES
		(_food_id, _ingredient_id, _ingredient_weight);
END
$$;


ALTER PROCEDURE public.add_food_composition(IN _food_name character varying, IN _ingredient_name character varying, IN _ingredient_weight double precision) OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 42265)
-- Name: add_food_type(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_food_type(IN _type character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO food_type
		("type")
	VALUES
		(_type);
END
$$;


ALTER PROCEDURE public.add_food_type(IN _type character varying) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 42263)
-- Name: add_ingredient(character varying, character varying, integer, double precision); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_ingredient(IN _name character varying, IN _measurement character varying, IN _critical_rate integer, IN _price double precision DEFAULT NULL::double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO ingredient
		("name", measurement, critical_rate, price)
	VALUES
		(_name, _measurement, _critical_rate, _price);
END
$$;


ALTER PROCEDURE public.add_ingredient(IN _name character varying, IN _measurement character varying, IN _critical_rate integer, IN _price double precision) OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 42267)
-- Name: add_job_role(character varying, double precision, double precision); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_job_role(IN _name character varying, IN _min_salary double precision, IN _max_salary double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO job_role
		("name", min_salary, max_salary)
	VALUES
		(_name, _min_salary, _max_salary);
END
$$;


ALTER PROCEDURE public.add_job_role(IN _name character varying, IN _min_salary double precision, IN _max_salary double precision) OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 58712)
-- Name: add_storehouse(character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_storehouse(IN _name character varying, IN _address character varying, IN _phone character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO storehouse
		("name", address, phone)
	VALUES
		(_name, _address, _phone);
END
$$;


ALTER PROCEDURE public.add_storehouse(IN _name character varying, IN _address character varying, IN _phone character varying) OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 42266)
-- Name: add_table(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_table(IN _human_slots integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO "table"
		(human_slots)
	VALUES
		(_human_slots);
END
$$;


ALTER PROCEDURE public.add_table(IN _human_slots integer) OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 58725)
-- Name: add_worker(character varying, character varying, character varying, character varying, character varying, double precision, character varying, character varying, character varying, double precision); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_worker(IN _login character varying, IN _password character varying, IN _job_role character varying, IN _surname character varying, IN _first_name character varying, IN _salary double precision, IN _patronymic character varying DEFAULT NULL::character varying, IN _email character varying DEFAULT NULL::character varying, IN _phone character varying DEFAULT NULL::character varying, IN _job_rate double precision DEFAULT NULL::double precision)
    LANGUAGE plpgsql
    AS $$
DECLARE
    worker_id INTEGER;
BEGIN
    -- Вставка записи в таблицу worker
    INSERT INTO worker
        (login, "password", job_role, surname, first_name, patronymic, email, phone, salary, job_rate)
    VALUES
        (_login, _password, _job_role, _surname, _first_name, _patronymic, _email, _phone, _salary, _job_rate)
    RETURNING id INTO worker_id;

    -- Вставка записи в таблицу worker_history
    INSERT INTO worker_history
        (start_date, end_date, id_worker, id_job_role, surname, "name", patronymic, email, phone, salary)
    VALUES
        (date_trunc('second', now()), date_trunc('second', now()), worker_id, _job_role, _surname, _first_name, _patronymic, _email, _phone, _salary);
END
$$;


ALTER PROCEDURE public.add_worker(IN _login character varying, IN _password character varying, IN _job_role character varying, IN _surname character varying, IN _first_name character varying, IN _salary double precision, IN _patronymic character varying, IN _email character varying, IN _phone character varying, IN _job_rate double precision) OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 58784)
-- Name: book_table(integer, integer, character varying, timestamp with time zone, timestamp with time zone, interval); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.book_table(IN _id_table integer, IN _id_worker integer, IN _client_phone character varying, IN _order_date timestamp with time zone, IN _desired_booking_date timestamp with time zone, IN _booking_interval interval)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_booking_start TIMESTAMP WITH TIME ZONE;
    v_booking_end TIMESTAMP WITH TIME ZONE;
BEGIN
    -- Check if the table exists
    IF NOT EXISTS (SELECT 1 FROM public."table" WHERE id = _id_table) THEN
        RAISE EXCEPTION 'Table with id % does not exist', _id_table;
    END IF;

    -- Check if the worker exists
    IF NOT EXISTS (SELECT 1 FROM public.worker WHERE id = _id_worker) THEN
        RAISE EXCEPTION 'Worker with id % does not exist', _id_worker;
    END IF;

    -- Check if the client exists
    IF NOT EXISTS (SELECT 1 FROM public.client WHERE phone = _client_phone) THEN
        RAISE EXCEPTION 'Client with phone number % does not exist', _client_phone;
    END IF;

    -- Insert the booking into the client_table
    INSERT INTO public.client_table
        (id_table, order_date, id_worker, client_phone, desired_booking_date, booking_interval)
    VALUES
        (_id_table, _order_date, _id_worker, _client_phone, _desired_booking_date, _booking_interval);

END
$$;


ALTER PROCEDURE public.book_table(IN _id_table integer, IN _id_worker integer, IN _client_phone character varying, IN _order_date timestamp with time zone, IN _desired_booking_date timestamp with time zone, IN _booking_interval interval) OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 58717)
-- Name: cancel_booking(integer, timestamp with time zone); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.cancel_booking(IN _table_id integer, IN _desired_booking_date timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Проверяем существование записи с указанным ID и датой бронирования
    IF EXISTS (SELECT 1 FROM client_table WHERE id_table = _table_id AND desired_booking_date = _desired_booking_date) THEN
        DELETE FROM client_table
        WHERE id_table = _table_id AND desired_booking_date = _desired_booking_date;
    ELSE
        RAISE EXCEPTION 'Booking with id % and desired_booking_date % does not exist', _table_id, _desired_booking_date;
    END IF;
END;
$$;


ALTER PROCEDURE public.cancel_booking(IN _table_id integer, IN _desired_booking_date timestamp with time zone) OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 50536)
-- Name: change_order_status(integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.change_order_status(IN _order_id integer, IN _new_status character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE order_directory
    SET status = _new_status
    WHERE id = _order_id;
END
$$;


ALTER PROCEDURE public.change_order_status(IN _order_id integer, IN _new_status character varying) OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 50563)
-- Name: check_ingredient_amount(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_ingredient_amount() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.quantity < NEW.critical_rate THEN
        PERFORM public.get_reorder_ingredients_list();
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_ingredient_amount() OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 58808)
-- Name: delete_ingredient(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_ingredient(IN ingredient_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	-- Удаление записей из связанной таблицы requisition
    DELETE FROM requisition WHERE id_ingredient = ingredient_id;

    -- Удаление записей из связанной таблицы food_composition
    DELETE FROM food_composition WHERE id_ingredient = ingredient_id;

    -- Удаление самого ингредиента
    DELETE FROM ingredient WHERE id = ingredient_id;
END;
$$;


ALTER PROCEDURE public.delete_ingredient(IN ingredient_id integer) OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 58735)
-- Name: delete_order(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_order(IN order_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM order_directory
    WHERE id = order_id;
END;
$$;


ALTER PROCEDURE public.delete_order(IN order_id integer) OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 58848)
-- Name: delete_worker(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_worker(IN worker_id integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    end_date_value timestamp with time zone := date_trunc('second', now());
BEGIN
    -- Удаление записей из связанных таблиц
    DELETE FROM client_table WHERE id_worker = worker_id;
    DELETE FROM order_directory WHERE id_worker = worker_id;
    DELETE FROM ingredient_storage WHERE id_request IN (SELECT id FROM requisition_list WHERE id_worker = worker_id);
    DELETE FROM requisition WHERE id IN (SELECT id FROM requisition_list WHERE id_worker = worker_id);
    DELETE FROM requisition_list WHERE id_worker = worker_id;

    -- Установка end_date для записи в worker_history
    UPDATE public.worker_history
    SET end_date = end_date_value
    WHERE id_worker = worker_id;

    -- Удаление самой записи работника
    DELETE FROM worker WHERE id = worker_id;
END;
$$;


ALTER PROCEDURE public.delete_worker(IN worker_id integer) OWNER TO postgres;

--
-- TOC entry 271 (class 1255 OID 58799)
-- Name: get_all_tables_on_date(timestamp with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_tables_on_date(input_date timestamp with time zone) RETURNS TABLE(id integer, human_slots integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT public."table".id, public."table".human_slots
    FROM public."table";
END;
$$;


ALTER FUNCTION public.get_all_tables_on_date(input_date timestamp with time zone) OWNER TO postgres;

--
-- TOC entry 272 (class 1255 OID 58801)
-- Name: get_booked_tables_on_date(timestamp with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_booked_tables_on_date(input_date timestamp with time zone) RETURNS TABLE(id integer, human_slots integer, desired_booking_date timestamp with time zone, booking_interval interval)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT t.id, t.human_slots, ct.desired_booking_date, ct.booking_interval
    FROM public.client_table ct
    INNER JOIN public."table" t ON ct.id_table = t.id
    WHERE ct.desired_booking_date::date = input_date::date;
END;
$$;


ALTER FUNCTION public.get_booked_tables_on_date(input_date timestamp with time zone) OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 58827)
-- Name: get_current_orders(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_current_orders() RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    order_record RECORD;
    order_data JSON;
    dish_data JSON;
    result JSON := '[]'::JSON;
BEGIN
    FOR order_record IN
        SELECT
            od.id AS id_order,
            od.id_worker,
            json_object_agg(ofd.id_food::TEXT, ofd.quantity) AS dishes,
            od.formation_date,
            od.issue_date AS giving_date,
            od.status
        FROM
            order_directory od
        JOIN
            order_food ofd ON od.id = ofd.id_order
        WHERE
            od.status <> 'Выполнен' -- Фильтрация по текущему статусу заказа
        GROUP BY
            od.id
    LOOP
        dish_data := json_build_object(
            'id_order', order_record.id_order,
            'id_worker', order_record.id_worker,
            'dishes', order_record.dishes,
            'formation_date', order_record.formation_date,
            'giving_date', order_record.giving_date,
            'status', order_record.status
        );
        result := json_agg(dish_data);
    END LOOP;

    RETURN result;
END;
$$;


ALTER FUNCTION public.get_current_orders() OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 58727)
-- Name: get_ingredients_info(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_ingredients_info() RETURNS TABLE(name character varying, measurement character varying, price double precision, critical_rate integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT i.name, i.measurement, i.price, i.critical_rate
    FROM ingredient i;
END;
$$;


ALTER FUNCTION public.get_ingredients_info() OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 42264)
-- Name: get_reorder_ingredients_list(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_reorder_ingredients_list() RETURNS TABLE(_name character varying, _quantity integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN QUERY
	SELECT i.name AS _name, (i.critical_rate - s.quantity) AS _quantity
	FROM ingredient_storage s
	JOIN ingredient i ON s.id_ingredient = i.id
	WHERE s.quantity < i.critical_rate;
END
$$;


ALTER FUNCTION public.get_reorder_ingredients_list() OWNER TO postgres;

--
-- TOC entry 246 (class 1255 OID 58723)
-- Name: get_worker_list(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_worker_list() RETURNS TABLE(job_role character varying, surname character varying, first_name character varying, patronymic character varying, phone character varying, salary double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT w.job_role, w.surname, w.first_name, w.patronymic, w.phone, w.salary
    FROM worker w
	ORDER BY job_role;
END;
$$;


ALTER FUNCTION public.get_worker_list() OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 58719)
-- Name: order_ingredient(integer, character varying, integer, integer, double precision, timestamp with time zone, timestamp with time zone, double precision, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.order_ingredient(IN worker_id integer, IN storage_name character varying, IN ingredient_id integer, IN ingredient_quantity integer, IN ingredient_weight double precision, IN ingredient_expiry_date timestamp with time zone, IN supplied_date timestamp with time zone, IN supplied_weight double precision, IN supplied_quantity integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    request_id INT;
	current_request_date TIMESTAMP WITH TIME ZONE;
BEGIN
	-- Получаем текущую дату с округлением до секунд
    current_request_date := date_trunc('second', NOW());

    -- Добавляем запись о заявке в таблицу списка заявок
    INSERT INTO requisition_list (id_worker, storage_name, "date", status)
    VALUES (worker_id, storage_name, current_request_date, 'Обрабатывается')
    RETURNING id INTO request_id;

    -- Добавляем запись о заявленных ингредиентах в таблицу ингредиент_заявка
    INSERT INTO requisition (id_request, id_ingredient, weight, quantity)
    VALUES (request_id, ingredient_id, ingredient_weight, ingredient_quantity);

    -- Добавляем запись о поступлении ингредиента на склад
    INSERT INTO ingredient_storage (id_ingredient, delivery_date, id_request, valid_until, weight, quantity)
    VALUES (ingredient_id, supplied_date, request_id, ingredient_expiry_date, supplied_weight, supplied_quantity);

    -- Обновляем статус заявки на "В процессе"
    UPDATE requests
    SET status = 'В процессе'
    WHERE id = request_id;

    COMMIT;
END;
$$;


ALTER PROCEDURE public.order_ingredient(IN worker_id integer, IN storage_name character varying, IN ingredient_id integer, IN ingredient_quantity integer, IN ingredient_weight double precision, IN ingredient_expiry_date timestamp with time zone, IN supplied_date timestamp with time zone, IN supplied_weight double precision, IN supplied_quantity integer) OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 50537)
-- Name: record_giving_time(integer, timestamp with time zone); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.record_giving_time(IN _order_id integer, IN _giving_time timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE order_directory
    SET issue_date = _giving_time
    WHERE id = _order_id;
END
$$;


ALTER PROCEDURE public.record_giving_time(IN _order_id integer, IN _giving_time timestamp with time zone) OWNER TO postgres;

--
-- TOC entry 270 (class 1255 OID 58731)
-- Name: update_ingredient(integer, double precision, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_ingredient(IN p_ingredient_id integer, IN p_price double precision, IN p_critical_rate integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Обновляем информацию об ингредиенте, если он уже существует
    UPDATE ingredient i
    SET price = p_price, critical_rate = p_critical_rate
    WHERE "id" = p_ingredient_id;
END;
$$;


ALTER PROCEDURE public.update_ingredient(IN p_ingredient_id integer, IN p_price double precision, IN p_critical_rate integer) OWNER TO postgres;

--
-- TOC entry 274 (class 1255 OID 58809)
-- Name: update_issue_date(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_issue_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.status = 'Выполнен' AND OLD.status <> 'Выполнен' THEN
        NEW.issue_date := NOW();
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_issue_date() OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 58831)
-- Name: update_order(integer, integer[], integer[], character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_order(IN _order_id integer, IN _food_id integer[], IN _quantities integer[], IN _new_status character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    i INTEGER;
BEGIN
    -- Обновление статуса заказа
    IF _new_status IS NOT NULL THEN
        UPDATE order_directory
        SET status = _new_status
        WHERE id = _order_id;
    END IF;

    -- Добавление новых блюд или изменение количества существующих блюд
    IF _food_id IS NOT NULL AND _quantities IS NOT NULL THEN
        FOR i IN 1..array_length(_food_id, 1) LOOP
            -- Проверка, существует ли блюдо с таким id в заказе
            IF EXISTS (SELECT 1 FROM order_food WHERE id_order = _order_id AND id_food = _food_id[i]) THEN
                -- Если блюдо уже есть в заказе, обновляем количество
                UPDATE order_food
                SET quantity = quantity + _quantities[i]
                WHERE id_order = _order_id AND id_food = _food_id[i];
            ELSE
                -- Если блюда нет в заказе, добавляем его
                INSERT INTO order_food (id_order, id_food, quantity)
                VALUES (_order_id, _food_id[i], _quantities[i]);
            END IF;
        END LOOP;
    END IF;
END;
$$;


ALTER PROCEDURE public.update_order(IN _order_id integer, IN _food_id integer[], IN _quantities integer[], IN _new_status character varying) OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 58724)
-- Name: update_worker_salary_and_rate(integer, double precision, double precision); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_worker_salary_and_rate(IN worker_id integer, IN new_salary double precision, IN new_job_rate double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE worker
    SET salary = new_salary,
        job_rate = new_job_rate
    WHERE id = worker_id;
END;
$$;


ALTER PROCEDURE public.update_worker_salary_and_rate(IN worker_id integer, IN new_salary double precision, IN new_job_rate double precision) OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 50548)
-- Name: view_all_booked_tables(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.view_all_booked_tables() RETURNS TABLE(table_id integer, booking_date timestamp with time zone, worker_id integer, client_number character varying, desired_date timestamp with time zone, booking_interval interval)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT ct.id_table, ct.order_date, ct.id_worker, ct.client_phone, ct.desired_booking_date, ct.booking_interval
    FROM client_table ct;
END
$$;


ALTER FUNCTION public.view_all_booked_tables() OWNER TO postgres;

--
-- TOC entry 261 (class 1255 OID 50553)
-- Name: view_food_with_composition(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.view_food_with_composition(_food_id integer) RETURNS TABLE(ingredient_id integer, ingredient_name character varying, ingredient_measurement character varying, ingredient_quantity double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT c.id_ingredient, i.name, i.measurement, c.weight
    FROM food_composition c
    INNER JOIN ingredient i ON c.id_ingredient = i.id
    WHERE c.id_food = _food_id;
END
$$;


ALTER FUNCTION public.view_food_with_composition(_food_id integer) OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 50551)
-- Name: view_menu_sorted_by_type(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.view_menu_sorted_by_type() RETURNS TABLE(food_id integer, food_type character varying, food_name character varying, weight double precision, unit_of_measurement character varying, price double precision)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT f.id, t.type, f.name, f.weight, f.unit_of_measurement, f.price
    FROM food f
    INNER JOIN food_type t ON f.type = t.type
    ORDER BY t.type; -- Сортировка по типу блюда
END
$$;


ALTER FUNCTION public.view_menu_sorted_by_type() OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 58828)
-- Name: view_order_history(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.view_order_history() RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    order_record RECORD;
    order_data JSON;
    dish_data JSON;
    result JSON := '[]'::JSON;
BEGIN
    FOR order_record IN
        SELECT
            od.id AS id_order,
            od.id_worker,
            json_object_agg(ofd.id_food::TEXT, ofd.quantity) AS dishes,
            od.formation_date,
            od.issue_date AS giving_date,
            od.status
        FROM
            order_directory od
        LEFT JOIN
            order_food ofd ON od.id = ofd.id_order
        GROUP BY
            od.id
    LOOP
        dish_data := json_build_object(
            'id_order', order_record.id_order,
            'id_worker', order_record.id_worker,
            'dishes', order_record.dishes,
            'formation_date', order_record.formation_date,
            'giving_date', order_record.giving_date,
            'status', order_record.status
        );
        result := json_agg(dish_data);
    END LOOP;

    RETURN result;
END;
$$;


ALTER FUNCTION public.view_order_history() OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 58844)
-- Name: worker_history_trigger_function(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.worker_history_trigger_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    old_data jsonb;
    new_data jsonb;
    start_date timestamp with time zone;
    end_date timestamp with time zone;
BEGIN
    -- Получаем старые и новые данные
    old_data := to_jsonb(OLD) - 'start_date' - 'id_worker';
    new_data := to_jsonb(NEW) - 'start_date' - 'id_worker';

    -- Получаем start_date и end_date по id_worker
    SELECT public.worker_history.start_date, public.worker_history.end_date INTO start_date, end_date FROM public.worker_history WHERE id_worker = NEW.id;

    -- Проверяем, существует ли уже запись с таким id_worker и start_date
    IF EXISTS (SELECT 1 FROM public.worker_history WHERE id_worker = NEW.id) THEN
        -- Обновляем существующую запись в worker_history
        UPDATE public.worker_history
        SET end_date = public.worker_history.end_date,
            id_job_role = NEW.job_role,
            surname = NEW.surname,
            name = NEW.first_name,
            patronymic = NEW.patronymic,
            email = NEW.email,
            phone = NEW.phone,
            salary = NEW.salary,
            last_changes = jsonb_build_object(
                'old', jsonb_strip_nulls(old_data),
                'new', jsonb_strip_nulls(new_data)
            )
        WHERE id_worker = NEW.id;
    ELSE
        -- Вставляем новую запись в worker_history
        INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes)
        VALUES (NEW.id, NEW.start_date, NEW.end_date, NEW.job_role, NEW.surname, NEW.first_name, NEW.patronymic, NEW.email, NEW.phone, NEW.salary, jsonb_build_object(
            'old', jsonb_strip_nulls(old_data),
            'new', jsonb_strip_nulls(new_data)
        ));
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.worker_history_trigger_function() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 33899)
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    phone character varying(32) NOT NULL,
    how_to_appeal character varying(255) NOT NULL,
    last_contact_date timestamp with time zone NOT NULL,
    email character varying(255) NOT NULL,
    CONSTRAINT valid_email_format CHECK (((email)::text ~* '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'::text)),
    CONSTRAINT valid_phone_format CHECK (((((phone)::text ~* '^[\+]?[0-9]+$'::text) AND (length((phone)::text) >= 11)) OR (((phone)::text ~* '^[0-9]+$'::text) AND (length((phone)::text) >= 10))))
);


ALTER TABLE public.client OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 50497)
-- Name: client_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_table (
    id_table integer NOT NULL,
    order_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id_worker integer NOT NULL,
    client_phone character varying(32) NOT NULL,
    desired_booking_date timestamp with time zone DEFAULT date_trunc('second'::text, now()),
    booking_interval interval DEFAULT '03:00:00'::interval NOT NULL
);


ALTER TABLE public.client_table OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 33931)
-- Name: food; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food (
    id integer NOT NULL,
    type character varying NOT NULL,
    name character varying NOT NULL,
    weight double precision,
    unit_of_measurement character varying DEFAULT 'грамм'::character varying,
    price double precision NOT NULL
);


ALTER TABLE public.food OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 33996)
-- Name: food_composition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_composition (
    id_food integer NOT NULL,
    id_ingredient integer NOT NULL,
    weight double precision
);


ALTER TABLE public.food_composition OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 33930)
-- Name: food_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.food_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.food_id_seq OWNER TO postgres;

--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 225
-- Name: food_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.food_id_seq OWNED BY public.food.id;


--
-- TOC entry 219 (class 1259 OID 33894)
-- Name: food_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_type (
    type character varying(50) NOT NULL
);


ALTER TABLE public.food_type OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 33877)
-- Name: ingredient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredient (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    measurement character varying(20) DEFAULT 'грамм'::character varying NOT NULL,
    price double precision,
    critical_rate integer NOT NULL
);


ALTER TABLE public.ingredient OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 33876)
-- Name: ingredient_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ingredient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ingredient_id_seq OWNER TO postgres;

--
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 215
-- Name: ingredient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ingredient_id_seq OWNED BY public.ingredient.id;


--
-- TOC entry 232 (class 1259 OID 34034)
-- Name: ingredient_storage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredient_storage (
    id integer NOT NULL,
    id_ingredient integer NOT NULL,
    delivery_date timestamp with time zone NOT NULL,
    id_request integer NOT NULL,
    valid_until timestamp with time zone NOT NULL,
    weight double precision,
    quantity integer NOT NULL
);


ALTER TABLE public.ingredient_storage OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 34033)
-- Name: ingredient_storage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ingredient_storage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ingredient_storage_id_seq OWNER TO postgres;

--
-- TOC entry 4989 (class 0 OID 0)
-- Dependencies: 231
-- Name: ingredient_storage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ingredient_storage_id_seq OWNED BY public.ingredient_storage.id;


--
-- TOC entry 218 (class 1259 OID 33889)
-- Name: job_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_role (
    name character varying(50) NOT NULL,
    min_salary double precision NOT NULL,
    max_salary double precision NOT NULL
);


ALTER TABLE public.job_role OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 50458)
-- Name: order_directory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_directory (
    id integer NOT NULL,
    id_worker integer NOT NULL,
    formation_date timestamp with time zone DEFAULT date_trunc('second'::text, now()),
    issue_date timestamp with time zone DEFAULT date_trunc('second'::text, now()),
    status character varying(50) DEFAULT 'Рассматривается'::character varying NOT NULL
);


ALTER TABLE public.order_directory OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 50457)
-- Name: order_directory_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_directory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_directory_id_seq OWNER TO postgres;

--
-- TOC entry 4990 (class 0 OID 0)
-- Dependencies: 234
-- Name: order_directory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_directory_id_seq OWNED BY public.order_directory.id;


--
-- TOC entry 237 (class 1259 OID 58811)
-- Name: order_food; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_food (
    id_order integer NOT NULL,
    id_food integer NOT NULL,
    quantity integer NOT NULL
);


ALTER TABLE public.order_food OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 34050)
-- Name: requisition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.requisition (
    id integer NOT NULL,
    id_ingredient integer NOT NULL,
    weight double precision,
    quantity integer NOT NULL
);


ALTER TABLE public.requisition OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 33961)
-- Name: requisition_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.requisition_list (
    id integer NOT NULL,
    id_worker integer NOT NULL,
    storage_name character varying(50) NOT NULL,
    date timestamp with time zone NOT NULL,
    status character varying(30) NOT NULL
);


ALTER TABLE public.requisition_list OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 33960)
-- Name: requisition_list_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.requisition_list_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.requisition_list_id_seq OWNER TO postgres;

--
-- TOC entry 4991 (class 0 OID 0)
-- Dependencies: 227
-- Name: requisition_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.requisition_list_id_seq OWNED BY public.requisition_list.id;


--
-- TOC entry 217 (class 1259 OID 33883)
-- Name: storehouse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.storehouse (
    name character varying(50) NOT NULL,
    address character varying(255) NOT NULL,
    phone character varying(20) NOT NULL,
    CONSTRAINT valid_phone_format CHECK (((((phone)::text ~* '^[\+]?[0-9]+$'::text) AND (length((phone)::text) >= 11)) OR (((phone)::text ~* '^[0-9]+$'::text) AND (length((phone)::text) >= 10))))
);


ALTER TABLE public.storehouse OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 33906)
-- Name: table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."table" (
    id integer NOT NULL,
    human_slots integer NOT NULL
);


ALTER TABLE public."table" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 33905)
-- Name: table_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.table_id_seq OWNER TO postgres;

--
-- TOC entry 4992 (class 0 OID 0)
-- Dependencies: 221
-- Name: table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.table_id_seq OWNED BY public."table".id;


--
-- TOC entry 224 (class 1259 OID 33913)
-- Name: worker; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.worker (
    id integer NOT NULL,
    login character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    job_role character varying NOT NULL,
    surname character varying(50) NOT NULL,
    first_name character varying(50) NOT NULL,
    patronymic character varying(50),
    email character varying(255),
    phone character varying(20),
    salary double precision NOT NULL,
    job_rate double precision,
    CONSTRAINT valid_email_format CHECK (((email)::text ~* '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'::text)),
    CONSTRAINT valid_phone_format CHECK (((((phone)::text ~* '^[\+]?[0-9]+$'::text) AND (length((phone)::text) >= 11)) OR (((phone)::text ~* '^[0-9]+$'::text) AND (length((phone)::text) >= 10))))
);


ALTER TABLE public.worker OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 33977)
-- Name: worker_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.worker_history (
    id_worker integer NOT NULL,
    start_date timestamp with time zone DEFAULT date_trunc('second'::text, now()) NOT NULL,
    end_date timestamp with time zone NOT NULL,
    id_job_role character varying(50) NOT NULL,
    surname character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    patronymic character varying(50),
    email character varying(255),
    phone character varying(20) NOT NULL,
    salary double precision NOT NULL,
    last_changes jsonb,
    CONSTRAINT valid_email_format CHECK (((email)::text ~* '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'::text)),
    CONSTRAINT valid_phone_format CHECK (((((phone)::text ~* '^[\+]?[0-9]+$'::text) AND (length((phone)::text) >= 11)) OR (((phone)::text ~* '^[0-9]+$'::text) AND (length((phone)::text) >= 10))))
);


ALTER TABLE public.worker_history OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 33912)
-- Name: worker_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.worker_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.worker_id_seq OWNER TO postgres;

--
-- TOC entry 4993 (class 0 OID 0)
-- Dependencies: 223
-- Name: worker_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.worker_id_seq OWNED BY public.worker.id;


--
-- TOC entry 4738 (class 2604 OID 33934)
-- Name: food id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food ALTER COLUMN id SET DEFAULT nextval('public.food_id_seq'::regclass);


--
-- TOC entry 4734 (class 2604 OID 33880)
-- Name: ingredient id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient ALTER COLUMN id SET DEFAULT nextval('public.ingredient_id_seq'::regclass);


--
-- TOC entry 4742 (class 2604 OID 34037)
-- Name: ingredient_storage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_storage ALTER COLUMN id SET DEFAULT nextval('public.ingredient_storage_id_seq'::regclass);


--
-- TOC entry 4743 (class 2604 OID 50461)
-- Name: order_directory id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_directory ALTER COLUMN id SET DEFAULT nextval('public.order_directory_id_seq'::regclass);


--
-- TOC entry 4740 (class 2604 OID 33964)
-- Name: requisition_list id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_list ALTER COLUMN id SET DEFAULT nextval('public.requisition_list_id_seq'::regclass);


--
-- TOC entry 4736 (class 2604 OID 33909)
-- Name: table id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."table" ALTER COLUMN id SET DEFAULT nextval('public.table_id_seq'::regclass);


--
-- TOC entry 4737 (class 2604 OID 33916)
-- Name: worker id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker ALTER COLUMN id SET DEFAULT nextval('public.worker_id_seq'::regclass);


--
-- TOC entry 4963 (class 0 OID 33899)
-- Dependencies: 220
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.client (phone, how_to_appeal, last_contact_date, email) VALUES ('+79389513658', 'Константин', '2024-02-18 02:55:51+03', 'john@example.com');
INSERT INTO public.client (phone, how_to_appeal, last_contact_date, email) VALUES ('+79637259702', 'Валентин', '2024-02-18 02:55:51+03', 'john1@example.com');
INSERT INTO public.client (phone, how_to_appeal, last_contact_date, email) VALUES ('+79330339678', 'Глеб', '2024-02-18 02:55:51+03', 'john12@example.com');
INSERT INTO public.client (phone, how_to_appeal, last_contact_date, email) VALUES ('+79848718618', 'Анатолий', '2024-02-18 02:55:51+03', 'john123@example.com');


--
-- TOC entry 4979 (class 0 OID 50497)
-- Dependencies: 236
-- Data for Name: client_table; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.client_table (id_table, order_date, id_worker, client_phone, desired_booking_date, booking_interval) VALUES (3, '2024-03-04 13:11:31.718063+03', 6, '+79637259702', '2024-03-04 13:11:31.718063+03', '03:00:00');
INSERT INTO public.client_table (id_table, order_date, id_worker, client_phone, desired_booking_date, booking_interval) VALUES (1, '2024-03-18 12:00:00+03', 3, '+79389513658', '2024-03-23 10:00:00+03', '05:00:00');
INSERT INTO public.client_table (id_table, order_date, id_worker, client_phone, desired_booking_date, booking_interval) VALUES (1, '2024-03-18 13:00:00+03', 3, '+79389513658', '2024-03-23 16:00:00+03', '02:00:00');
INSERT INTO public.client_table (id_table, order_date, id_worker, client_phone, desired_booking_date, booking_interval) VALUES (1, '2024-03-18 15:00:00+03', 3, '+79389513658', '2024-03-23 17:00:00+03', '02:00:00');
INSERT INTO public.client_table (id_table, order_date, id_worker, client_phone, desired_booking_date, booking_interval) VALUES (1, '2024-03-18 14:00:00+03', 3, '+79389513658', '2024-03-23 17:00:00+03', '02:00:00');


--
-- TOC entry 4969 (class 0 OID 33931)
-- Dependencies: 226
-- Data for Name: food; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (1, 'Напитки', 'Бурбон', 200, 'Грамм', 300);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (2, 'Пицца', 'Карбонара', 800, 'Грамм', 800);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (3, 'Салаты', 'Цезарь', 400, 'Грамм', 600);


--
-- TOC entry 4973 (class 0 OID 33996)
-- Dependencies: 230
-- Data for Name: food_composition; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (1, 2, 300);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (2, 3, 500);


--
-- TOC entry 4962 (class 0 OID 33894)
-- Dependencies: 219
-- Data for Name: food_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.food_type (type) VALUES ('Пицца');
INSERT INTO public.food_type (type) VALUES ('Суши');
INSERT INTO public.food_type (type) VALUES ('Салаты');
INSERT INTO public.food_type (type) VALUES ('Напитки');
INSERT INTO public.food_type (type) VALUES ('Спиртные напитки');
INSERT INTO public.food_type (type) VALUES ('Соусы');


--
-- TOC entry 4959 (class 0 OID 33877)
-- Dependencies: 216
-- Data for Name: ingredient; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (2, 'Огурцы', 'кг', 100, 3);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (3, 'Мука', 'кг', 50, 5);


--
-- TOC entry 4975 (class 0 OID 34034)
-- Dependencies: 232
-- Data for Name: ingredient_storage; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ingredient_storage (id, id_ingredient, delivery_date, id_request, valid_until, weight, quantity) VALUES (2, 2, '2024-02-18 02:55:51+03', 2, '2024-02-18 02:55:51+03', 1, 654);
INSERT INTO public.ingredient_storage (id, id_ingredient, delivery_date, id_request, valid_until, weight, quantity) VALUES (3, 3, '2024-02-18 02:55:51+03', 3, '2024-02-18 02:55:51+03', 3, 700);


--
-- TOC entry 4961 (class 0 OID 33889)
-- Dependencies: 218
-- Data for Name: job_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.job_role (name, min_salary, max_salary) VALUES ('Старший Повар', 70000, 80000);
INSERT INTO public.job_role (name, min_salary, max_salary) VALUES ('Младший Повар', 40000, 60000);
INSERT INTO public.job_role (name, min_salary, max_salary) VALUES ('Шеф-Повар', 2000000, 5000000);
INSERT INTO public.job_role (name, min_salary, max_salary) VALUES ('Официант', 30000, 40000);


--
-- TOC entry 4978 (class 0 OID 50458)
-- Dependencies: 235
-- Data for Name: order_directory; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_directory (id, id_worker, formation_date, issue_date, status) VALUES (7, 2, '2024-03-17 10:00:00+03', '2024-03-17 12:00:00+03', 'Готовится');


--
-- TOC entry 4980 (class 0 OID 58811)
-- Dependencies: 237
-- Data for Name: order_food; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (7, 1, 2);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (7, 3, 5);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (7, 2, 7);


--
-- TOC entry 4976 (class 0 OID 34050)
-- Dependencies: 233
-- Data for Name: requisition; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.requisition (id, id_ingredient, weight, quantity) VALUES (3, 3, 10, 50);


--
-- TOC entry 4971 (class 0 OID 33961)
-- Dependencies: 228
-- Data for Name: requisition_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.requisition_list (id, id_worker, storage_name, date, status) VALUES (2, 2, 'Рундук', '2024-02-18 02:55:51+03', 'Выполнено');
INSERT INTO public.requisition_list (id, id_worker, storage_name, date, status) VALUES (3, 3, 'Ларец', '2024-02-18 02:55:51+03', 'В процессе');


--
-- TOC entry 4960 (class 0 OID 33883)
-- Dependencies: 217
-- Data for Name: storehouse; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.storehouse (name, address, phone) VALUES ('Сундук', 'Краснодар', '+79057474162');
INSERT INTO public.storehouse (name, address, phone) VALUES ('Рундук', 'Ростов', '+79943211287');
INSERT INTO public.storehouse (name, address, phone) VALUES ('Ларец', 'Москва', '+79279675440');


--
-- TOC entry 4965 (class 0 OID 33906)
-- Dependencies: 222
-- Data for Name: table; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."table" (id, human_slots) VALUES (1, 4);
INSERT INTO public."table" (id, human_slots) VALUES (2, 3);
INSERT INTO public."table" (id, human_slots) VALUES (3, 2);
INSERT INTO public."table" (id, human_slots) VALUES (4, 5);


--
-- TOC entry 4967 (class 0 OID 33913)
-- Dependencies: 224
-- Data for Name: worker; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.worker (id, login, password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (2, 'alexxxanders_basket', '$pbkdf2-sha256$29000$TMm5dw4hhDAGIGRMae39nw$nmTEpKSwzg2LCnn3SC23PziGvP1G9QDisQKJVi4TXbs', 'Младший Повар', 'Александров', 'Олег', '', NULL, '+79028759088', 50000, NULL);
INSERT INTO public.worker (id, login, password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (3, 'x_vasya_x', '$pbkdf2-sha256$29000$h5ASYkzpvZeSEqJU6h3jnA$sByoqbnOyttRGUfRdU63Qse/vz4SQ7Yhmcy75VeuPAw', 'Шеф-Повар', 'Васильев', 'Михаил', '', NULL, '+79028759088', 50000, NULL);
INSERT INTO public.worker (id, login, password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (4, 'zufar_eto_ne_prochitaet', '$pbkdf2-sha256$29000$6h2D0HovpdR6j1Eq5TyHcA$SYPAkLWb3RNyox7wD/YQEFoWOeKMe3hozhT/3SR9Ux4', 'Официант', 'Иванов', 'Олег', '', NULL, '+79028759088', 50000, NULL);
INSERT INTO public.worker (id, login, password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (6, 'john_doe', 'password123', 'Младший Повар', 'Дуйэн', 'Джонсон', 'Патрикович', 'john@example.com', '+79028759087', 50000, 1);
INSERT INTO public.worker (id, login, password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (9, 'john_does', 'password123', 'Младший Повар', 'Дуйэн', 'Джонсон', 'Патрикович', 'john@example.com', '+79028759087', 50000, 1);
INSERT INTO public.worker (id, login, password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (11, 'john_doesss', 'password123', 'Младший Повар', 'Дуйэн', 'Джонсон', 'Патрикович', 'john@example.com', '+79028759087', 50000, 1);
INSERT INTO public.worker (id, login, password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (12, 'john_doessss', 'password123', 'Младший Повар', 'Дуйэн', 'Джонсон', 'Патрикович', 'john@example.com', '+79028759087', 50000, 1);
INSERT INTO public.worker (id, login, password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (13, 'john_doessssz', 'password123', 'Младший Повар', 'Дуйэн', 'Джонсон', 'Патрикович', 'john@example.com', '+79028759087', 50000, 1);


--
-- TOC entry 4972 (class 0 OID 33977)
-- Dependencies: 229
-- Data for Name: worker_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (1, '2024-02-18 02:55:51+03', '2024-02-18 02:55:51+03', 'Шеф-Повар', 'Александров', 'Олег', NULL, NULL, '+79637259702', 50000, NULL);
INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (2, '2024-02-18 02:55:51+03', '2024-02-18 02:55:51+03', 'Младший Повар', 'Васильев', 'Олег', NULL, NULL, '+79637259702', 30000, NULL);
INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (3, '2024-02-18 02:55:51+03', '2024-02-18 02:55:51+03', 'Младший Повар', 'Иванов', 'Михаил', NULL, NULL, '+79637259702', 60000, NULL);
INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (9, '2024-02-28 07:43:54.652174+03', '2024-02-28 07:43:54.652174+03', 'Младший Повар', 'Дуйэн', 'Джонсон', 'Патрикович', 'john@example.com', '+79028759087', 50000, NULL);
INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (11, '2024-02-28 07:46:19.819254+03', '2024-02-28 07:46:19.819254+03', 'Младший Повар', 'Дуйэн', 'Джонсон', 'Патрикович', 'john@example.com', '+79028759087', 50000, NULL);
INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (12, '2024-02-28 07:49:40+03', '2024-02-28 07:49:40+03', 'Младший Повар', 'Дуйэн', 'Джонсон', 'Патрикович', 'john@example.com', '+79028759087', 50000, NULL);
INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (13, '2024-02-28 08:10:17+03', '2024-02-28 08:10:17+03', 'Младший Повар', 'Дуйэн', 'Джонсон', 'Патрикович', 'john@example.com', '+79028759087', 50000, NULL);
INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (15, '2024-03-16 16:37:12+03', '2024-03-16 16:37:12+03', 'Младший Повар', 'Дуйэн', 'Джонсон', 'Патрикович', 'john@example.com', '+79028759087', 50000, '{"new": {"id": 15, "email": "john@example.com", "login": "john_does123", "phone": "+79028759087", "salary": 50000, "surname": "Дуйэн", "job_rate": 3, "job_role": "Младший Повар", "password": "password123", "first_name": "Джонсон", "patronymic": "Патрикович"}, "old": {"id": 15, "email": "john@example.com", "login": "john_does123", "phone": "+79028759087", "salary": 60000, "surname": "Дуйэн", "job_rate": 5, "job_role": "Младший Повар", "password": "password123", "first_name": "Джонсон", "patronymic": "Патрикович"}}');
INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (18, '2024-03-16 20:30:46+03', '2024-03-17 07:15:51+03', 'Старший Повар', 'Чехов', 'Андрей', 'Павлович', 'chehow@gmail.com', '+79028888888', 30000, '{"new": {"id": 18, "email": "chehow@gmail.com", "login": "aufff", "phone": "+79028888888", "salary": 30000, "surname": "Чехов", "job_rate": 5, "job_role": "Старший Повар", "password": "password123", "first_name": "Андрей", "patronymic": "Павлович"}, "old": {"id": 18, "email": "chehow@gmail.com", "login": "aufff", "phone": "+79028888888", "salary": 60000, "surname": "Чехов", "job_rate": 3, "job_role": "Старший Повар", "password": "password123", "first_name": "Андрей", "patronymic": "Павлович"}}');


--
-- TOC entry 4994 (class 0 OID 0)
-- Dependencies: 225
-- Name: food_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.food_id_seq', 3, true);


--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 215
-- Name: ingredient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredient_id_seq', 3, true);


--
-- TOC entry 4996 (class 0 OID 0)
-- Dependencies: 231
-- Name: ingredient_storage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredient_storage_id_seq', 3, true);


--
-- TOC entry 4997 (class 0 OID 0)
-- Dependencies: 234
-- Name: order_directory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_directory_id_seq', 8, true);


--
-- TOC entry 4998 (class 0 OID 0)
-- Dependencies: 227
-- Name: requisition_list_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.requisition_list_id_seq', 3, true);


--
-- TOC entry 4999 (class 0 OID 0)
-- Dependencies: 221
-- Name: table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.table_id_seq', 4, true);


--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 223
-- Name: worker_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.worker_id_seq', 18, true);


--
-- TOC entry 4768 (class 2606 OID 50532)
-- Name: client client_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_email_key UNIQUE (email);


--
-- TOC entry 4770 (class 2606 OID 33904)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (phone);


--
-- TOC entry 4792 (class 2606 OID 50504)
-- Name: client_table client_table_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_table
    ADD CONSTRAINT client_table_pkey PRIMARY KEY (id_table, order_date);


--
-- TOC entry 4784 (class 2606 OID 34000)
-- Name: food_composition food_composition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_composition
    ADD CONSTRAINT food_composition_pkey PRIMARY KEY (id_food, id_ingredient);


--
-- TOC entry 4778 (class 2606 OID 33938)
-- Name: food food_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food
    ADD CONSTRAINT food_pkey PRIMARY KEY (id);


--
-- TOC entry 4766 (class 2606 OID 33898)
-- Name: food_type food_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_type
    ADD CONSTRAINT food_type_pkey PRIMARY KEY (type);


--
-- TOC entry 4758 (class 2606 OID 42261)
-- Name: ingredient ingredient_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient
    ADD CONSTRAINT ingredient_name_unique UNIQUE (name);


--
-- TOC entry 4760 (class 2606 OID 33882)
-- Name: ingredient ingredient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient
    ADD CONSTRAINT ingredient_pkey PRIMARY KEY (id);


--
-- TOC entry 4786 (class 2606 OID 34039)
-- Name: ingredient_storage ingredient_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_storage
    ADD CONSTRAINT ingredient_storage_pkey PRIMARY KEY (id);


--
-- TOC entry 4764 (class 2606 OID 33893)
-- Name: job_role job_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_role
    ADD CONSTRAINT job_role_pkey PRIMARY KEY (name);


--
-- TOC entry 4790 (class 2606 OID 50466)
-- Name: order_directory order_directory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_directory
    ADD CONSTRAINT order_directory_pkey PRIMARY KEY (id);


--
-- TOC entry 4794 (class 2606 OID 58815)
-- Name: order_food order_food_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_food
    ADD CONSTRAINT order_food_pk PRIMARY KEY (id_order, id_food);


--
-- TOC entry 4780 (class 2606 OID 33966)
-- Name: requisition_list requisition_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_list
    ADD CONSTRAINT requisition_list_pkey PRIMARY KEY (id);


--
-- TOC entry 4788 (class 2606 OID 34054)
-- Name: requisition requisition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition
    ADD CONSTRAINT requisition_pkey PRIMARY KEY (id, id_ingredient);


--
-- TOC entry 4762 (class 2606 OID 33888)
-- Name: storehouse storage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storehouse
    ADD CONSTRAINT storage_pkey PRIMARY KEY (name);


--
-- TOC entry 4772 (class 2606 OID 33911)
-- Name: table table_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."table"
    ADD CONSTRAINT table_pkey PRIMARY KEY (id);


--
-- TOC entry 4782 (class 2606 OID 33985)
-- Name: worker_history worker_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_history
    ADD CONSTRAINT worker_history_pkey PRIMARY KEY (id_worker, start_date);


--
-- TOC entry 4774 (class 2606 OID 33924)
-- Name: worker worker_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_login_key UNIQUE (login);


--
-- TOC entry 4776 (class 2606 OID 33922)
-- Name: worker worker_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_pkey PRIMARY KEY (id);


--
-- TOC entry 4813 (class 2620 OID 50564)
-- Name: ingredient_storage critical_amount_ingredient_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER critical_amount_ingredient_trigger AFTER INSERT OR UPDATE ON public.ingredient_storage FOR EACH ROW EXECUTE FUNCTION public.check_ingredient_amount();


--
-- TOC entry 4814 (class 2620 OID 58810)
-- Name: order_directory update_issue_date_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_issue_date_trigger BEFORE UPDATE ON public.order_directory FOR EACH ROW EXECUTE FUNCTION public.update_issue_date();


--
-- TOC entry 4812 (class 2620 OID 58845)
-- Name: worker worker_history_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER worker_history_trigger AFTER UPDATE ON public.worker FOR EACH ROW EXECUTE FUNCTION public.worker_history_trigger_function();


--
-- TOC entry 4807 (class 2606 OID 50515)
-- Name: client_table client_table_client_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_table
    ADD CONSTRAINT client_table_client_phone_fkey FOREIGN KEY (client_phone) REFERENCES public.client(phone);


--
-- TOC entry 4808 (class 2606 OID 50505)
-- Name: client_table client_table_id_table_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_table
    ADD CONSTRAINT client_table_id_table_fkey FOREIGN KEY (id_table) REFERENCES public."table"(id);


--
-- TOC entry 4809 (class 2606 OID 50510)
-- Name: client_table client_table_id_worker_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_table
    ADD CONSTRAINT client_table_id_worker_fkey FOREIGN KEY (id_worker) REFERENCES public.worker(id);


--
-- TOC entry 4800 (class 2606 OID 34001)
-- Name: food_composition food_composition_id_food_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_composition
    ADD CONSTRAINT food_composition_id_food_fkey FOREIGN KEY (id_food) REFERENCES public.food(id);


--
-- TOC entry 4801 (class 2606 OID 34006)
-- Name: food_composition food_composition_id_ingredient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_composition
    ADD CONSTRAINT food_composition_id_ingredient_fkey FOREIGN KEY (id_ingredient) REFERENCES public.ingredient(id);


--
-- TOC entry 4796 (class 2606 OID 33939)
-- Name: food food_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food
    ADD CONSTRAINT food_type_fkey FOREIGN KEY (type) REFERENCES public.food_type(type);


--
-- TOC entry 4802 (class 2606 OID 34040)
-- Name: ingredient_storage ingredient_storage_id_ingredient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_storage
    ADD CONSTRAINT ingredient_storage_id_ingredient_fkey FOREIGN KEY (id_ingredient) REFERENCES public.ingredient(id);


--
-- TOC entry 4803 (class 2606 OID 34045)
-- Name: ingredient_storage ingredient_storage_id_request_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_storage
    ADD CONSTRAINT ingredient_storage_id_request_fkey FOREIGN KEY (id_request) REFERENCES public.requisition_list(id);


--
-- TOC entry 4806 (class 2606 OID 50467)
-- Name: order_directory order_directory_id_worker_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_directory
    ADD CONSTRAINT order_directory_id_worker_fkey FOREIGN KEY (id_worker) REFERENCES public.worker(id);


--
-- TOC entry 4810 (class 2606 OID 58821)
-- Name: order_food order_food_fk_food; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_food
    ADD CONSTRAINT order_food_fk_food FOREIGN KEY (id_food) REFERENCES public.food(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4811 (class 2606 OID 58816)
-- Name: order_food order_food_fk_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_food
    ADD CONSTRAINT order_food_fk_order FOREIGN KEY (id_order) REFERENCES public.order_directory(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4804 (class 2606 OID 34055)
-- Name: requisition requisition_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition
    ADD CONSTRAINT requisition_id_fkey FOREIGN KEY (id) REFERENCES public.requisition_list(id);


--
-- TOC entry 4805 (class 2606 OID 34060)
-- Name: requisition requisition_id_ingredient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition
    ADD CONSTRAINT requisition_id_ingredient_fkey FOREIGN KEY (id_ingredient) REFERENCES public.ingredient(id);


--
-- TOC entry 4797 (class 2606 OID 33967)
-- Name: requisition_list requisition_list_id_worker_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_list
    ADD CONSTRAINT requisition_list_id_worker_fkey FOREIGN KEY (id_worker) REFERENCES public.worker(id);


--
-- TOC entry 4798 (class 2606 OID 33972)
-- Name: requisition_list requisition_list_storage_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_list
    ADD CONSTRAINT requisition_list_storage_name_fkey FOREIGN KEY (storage_name) REFERENCES public.storehouse(name);


--
-- TOC entry 4799 (class 2606 OID 33991)
-- Name: worker_history worker_history_id_job_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_history
    ADD CONSTRAINT worker_history_id_job_role_fkey FOREIGN KEY (id_job_role) REFERENCES public.job_role(name);


--
-- TOC entry 4795 (class 2606 OID 33925)
-- Name: worker worker_job_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_job_role_fkey FOREIGN KEY (job_role) REFERENCES public.job_role(name);


-- Completed on 2024-03-17 07:43:22

--
-- PostgreSQL database dump complete
--

