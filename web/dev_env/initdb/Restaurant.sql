--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

-- Started on 2024-03-21 15:16:43

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

CREATE DATABASE "Restaurant" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'ru_RU.utf8';


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
-- TOC entry 273 (class 1255 OID 58852)
-- Name: add_client(character varying, character varying, timestamp with time zone, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_client(IN _phone character varying, IN _name character varying, IN _last_contact_date timestamp with time zone, IN _email character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO client
		(phone, "name", last_contact_date, email)
	VALUES
		(_phone, _name, date_trunc('second', now()), _email);
END
$$;


ALTER PROCEDURE public.add_client(IN _phone character varying, IN _name character varying, IN _last_contact_date timestamp with time zone, IN _email character varying) OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 67143)
-- Name: add_client_order(integer, integer[], integer[], timestamp with time zone, timestamp with time zone, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_client_order(IN _worker_id integer, IN _food_ids integer[], IN _quantities integer[], IN _formation_date timestamp with time zone, IN _issue_date timestamp with time zone, IN _status character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    order_id INT;
    ingredient_row RECORD;
BEGIN
    -- Добавляем заказ в таблицу order_directory
    INSERT INTO order_directory (id_worker, formation_date, issue_date, status)
    VALUES (_worker_id, _formation_date, _issue_date, _status)
    RETURNING id INTO order_id;

    -- Для каждого блюда в заказе
    FOR i IN 1..array_length(_food_ids, 1) LOOP
        -- Проверяем существование блюда
        IF EXISTS (SELECT 1 FROM food WHERE id = _food_ids[i]) THEN
            -- Добавляем запись о блюде в таблицу order_food
            INSERT INTO order_food (id_order, id_food, quantity)
            VALUES (order_id, _food_ids[i], _quantities[i]);

            -- Для каждого ингредиента в блюде
            FOR ingredient_row IN
                SELECT fc.id_ingredient, fc.weight * _quantities[i] AS total_weight
                FROM food_composition fc
                WHERE fc.id_food = _food_ids[i]
            LOOP
                -- Обновляем количество ингредиента в ingredient_storage
                UPDATE ingredient_storage
                SET weight = weight - ingredient_row.total_weight
                WHERE id_ingredient = ingredient_row.id_ingredient;
            END LOOP;
        ELSE
            RAISE EXCEPTION 'Блюдо с ID % не найдено', _food_ids[i];
        END IF;
    END LOOP;

    COMMIT;
END;
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
-- TOC entry 262 (class 1255 OID 67127)
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

	-- Проверка, найден ли ингредиент
	IF _ingredient_id IS NULL THEN
		RAISE EXCEPTION 'Ингредиент с именем % не найден', _ingredient_name;
	END IF;

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
-- TOC entry 263 (class 1255 OID 42263)
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
-- TOC entry 267 (class 1255 OID 58725)
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
-- TOC entry 274 (class 1255 OID 67044)
-- Name: book_table(integer, integer, character varying, timestamp with time zone, timestamp with time zone, timestamp with time zone); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.book_table(IN _id_table integer, IN _id_worker integer, IN _client_phone character varying, IN _order_date timestamp with time zone, IN _start_booking_date timestamp with time zone, IN _end_booking_date timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Существует ли таблица
    IF NOT EXISTS (SELECT 1 FROM public."table" WHERE id = _id_table) THEN
        RAISE EXCEPTION 'Table with id % does not exist', _id_table;
    END IF;

    -- Существует ли рабочий
    IF NOT EXISTS (SELECT 1 FROM public.worker WHERE id = _id_worker) THEN
        RAISE EXCEPTION 'Worker with id % does not exist', _id_worker;
    END IF;

    -- Существует ли клиент
    IF NOT EXISTS (SELECT 1 FROM public.client WHERE phone = _client_phone) THEN
        RAISE EXCEPTION 'Client with phone number % does not exist', _client_phone;
    END IF;

    INSERT INTO public.client_table
        (id_table, order_date, id_worker, client_phone, start_booking_date, end_booking_date)
    VALUES
        (_id_table, _order_date, _id_worker, _client_phone, _start_booking_date, _end_booking_date);

END
$$;


ALTER PROCEDURE public.book_table(IN _id_table integer, IN _id_worker integer, IN _client_phone character varying, IN _order_date timestamp with time zone, IN _start_booking_date timestamp with time zone, IN _end_booking_date timestamp with time zone) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 67046)
-- Name: book_table_from_web(integer, character varying, timestamp with time zone, timestamp with time zone, timestamp with time zone); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.book_table_from_web(IN _id_table integer, IN _client_phone character varying, IN _order_date timestamp with time zone, IN _start_booking_date timestamp with time zone, IN _end_booking_date timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Существует ли таблица
    IF NOT EXISTS (SELECT 1 FROM public."table" WHERE id = _id_table) THEN
        RAISE EXCEPTION 'Table with id % does not exist', _id_table;
    END IF;

    -- Существует ли клиент
    IF NOT EXISTS (SELECT 1 FROM public.client WHERE phone = _client_phone) THEN
        RAISE EXCEPTION 'Client with phone number % does not exist', _client_phone;
    END IF;

    INSERT INTO public.client_table
        (id_table, order_date, client_phone, start_booking_date, end_booking_date)
    VALUES
        (_id_table, _order_date, _client_phone, _start_booking_date, _end_booking_date);

END
$$;


ALTER PROCEDURE public.book_table_from_web(IN _id_table integer, IN _client_phone character varying, IN _order_date timestamp with time zone, IN _start_booking_date timestamp with time zone, IN _end_booking_date timestamp with time zone) OWNER TO postgres;

--
-- TOC entry 261 (class 1255 OID 58717)
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
-- TOC entry 264 (class 1255 OID 50536)
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
-- TOC entry 271 (class 1255 OID 58808)
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
-- TOC entry 269 (class 1255 OID 58735)
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
-- TOC entry 279 (class 1255 OID 58848)
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
-- TOC entry 280 (class 1255 OID 67047)
-- Name: get_booked_tables_on_date(timestamp with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_booked_tables_on_date(input_date timestamp with time zone) RETURNS TABLE(id integer, human_slots integer, start_booking_date timestamp with time zone, end_booking_date timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT t.id, t.human_slots, ct.start_booking_date, ct.end_booking_date
    FROM public.client_table ct
    INNER JOIN public."table" t ON ct.id_table = t.id
    WHERE ct.start_booking_date::date = input_date::date;
END;
$$;


ALTER FUNCTION public.get_booked_tables_on_date(input_date timestamp with time zone) OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 58854)
-- Name: get_count_place_all_tables(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_count_place_all_tables() RETURNS TABLE(id integer, human_slots integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT public."table".id, public."table".human_slots
    FROM public."table";
END;
$$;


ALTER FUNCTION public.get_count_place_all_tables() OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 67130)
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
            od.status <> 'Отдано' -- Фильтрация по текущему статусу заказа
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
-- TOC entry 245 (class 1255 OID 58727)
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
-- TOC entry 281 (class 1255 OID 67050)
-- Name: get_time_for_booked_table_on_date(integer, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_time_for_booked_table_on_date(id_table integer, input_date timestamp with time zone) RETURNS TABLE(id integer, human_slots integer, start_booking_date timestamp with time zone, end_booking_date timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT t.id, t.human_slots, ct.start_booking_date, ct.end_booking_date
    FROM public.client_table ct
    INNER JOIN public."table" t ON ct.id_table = t.id
    WHERE ct.start_booking_date::date = input_date::date
    AND t.id = ct.id_table;
END;
$$;


ALTER FUNCTION public.get_time_for_booked_table_on_date(id_table integer, input_date timestamp with time zone) OWNER TO postgres;

--
-- TOC entry 244 (class 1255 OID 58723)
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
-- TOC entry 283 (class 1255 OID 67134)
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
    INSERT INTO requisition (id, id_ingredient, weight, quantity)
    VALUES (request_id, ingredient_id, ingredient_weight, ingredient_quantity);

    -- Проверяем, есть ли ингредиент в таблице ingredient_storage
    PERFORM id_ingredient FROM ingredient_storage WHERE id_ingredient = ingredient_id;

    -- Если ингредиент уже существует в таблице ingredient_storage, обновляем его вес
    IF FOUND THEN
        UPDATE ingredient_storage
        SET weight = weight + supplied_weight,
            quantity = quantity + supplied_quantity
        WHERE id_ingredient = ingredient_id;
    ELSE
        -- Добавляем запись о поступлении ингредиента на склад
        INSERT INTO ingredient_storage (id_ingredient, delivery_date, id_request, valid_until, weight, quantity)
        VALUES (ingredient_id, supplied_date, request_id, ingredient_expiry_date, supplied_weight, supplied_quantity);
    END IF;

    -- Обновляем статус заявки на "В процессе"
    UPDATE requisition_list
    SET status = 'Ожидание'
    WHERE id = request_id;

    COMMIT;
END;
$$;


ALTER PROCEDURE public.order_ingredient(IN worker_id integer, IN storage_name character varying, IN ingredient_id integer, IN ingredient_quantity integer, IN ingredient_weight double precision, IN ingredient_expiry_date timestamp with time zone, IN supplied_date timestamp with time zone, IN supplied_weight double precision, IN supplied_quantity integer) OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 50537)
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
-- TOC entry 268 (class 1255 OID 58731)
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
-- TOC entry 270 (class 1255 OID 58809)
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
-- TOC entry 278 (class 1255 OID 58831)
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
-- TOC entry 257 (class 1255 OID 67056)
-- Name: update_quantity_of_ingredient(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.update_quantity_of_ingredient(IN p_ingredient_id integer, IN p_quantity integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Обновляем количество ингредиентов на складе
    UPDATE ingredient_storage
    SET quantity = quantity + p_quantity
    WHERE id_ingredient = p_ingredient_id;
END;
$$;


ALTER PROCEDURE public.update_quantity_of_ingredient(IN p_ingredient_id integer, IN p_quantity integer) OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 58724)
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
-- TOC entry 258 (class 1255 OID 50548)
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
-- TOC entry 260 (class 1255 OID 50553)
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
-- TOC entry 259 (class 1255 OID 50551)
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
-- TOC entry 275 (class 1255 OID 58828)
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
-- TOC entry 272 (class 1255 OID 58844)
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
    name character varying(255) NOT NULL,
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
    id_worker integer,
    client_phone character varying(32) NOT NULL,
    start_booking_date timestamp with time zone DEFAULT date_trunc('second'::text, now()),
    end_booking_date timestamp with time zone NOT NULL
);


ALTER TABLE public.client_table OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 33931)
-- Name: food; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food (
    id integer NOT NULL,
    type character varying,
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
-- TOC entry 4740 (class 2604 OID 33934)
-- Name: food id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food ALTER COLUMN id SET DEFAULT nextval('public.food_id_seq'::regclass);


--
-- TOC entry 4736 (class 2604 OID 33880)
-- Name: ingredient id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient ALTER COLUMN id SET DEFAULT nextval('public.ingredient_id_seq'::regclass);


--
-- TOC entry 4744 (class 2604 OID 34037)
-- Name: ingredient_storage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_storage ALTER COLUMN id SET DEFAULT nextval('public.ingredient_storage_id_seq'::regclass);


--
-- TOC entry 4745 (class 2604 OID 50461)
-- Name: order_directory id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_directory ALTER COLUMN id SET DEFAULT nextval('public.order_directory_id_seq'::regclass);


--
-- TOC entry 4742 (class 2604 OID 33964)
-- Name: requisition_list id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_list ALTER COLUMN id SET DEFAULT nextval('public.requisition_list_id_seq'::regclass);


--
-- TOC entry 4738 (class 2604 OID 33909)
-- Name: table id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."table" ALTER COLUMN id SET DEFAULT nextval('public.table_id_seq'::regclass);


--
-- TOC entry 4739 (class 2604 OID 33916)
-- Name: worker id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker ALTER COLUMN id SET DEFAULT nextval('public.worker_id_seq'::regclass);


--
-- TOC entry 4963 (class 0 OID 33899)
-- Dependencies: 220
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.client (phone, name, last_contact_date, email) VALUES ('+79389513678', 'Максим', '2024-03-17 15:42:22+03', 'maks123@example.com');
INSERT INTO public.client (phone, name, last_contact_date, email) VALUES ('+79848718618', 'Анатолий', '2024-02-18 02:55:51+03', 'anatol@example.com');
INSERT INTO public.client (phone, name, last_contact_date, email) VALUES ('+79330339678', 'Глеб', '2024-02-18 02:55:51+03', 'glebus@example.com');
INSERT INTO public.client (phone, name, last_contact_date, email) VALUES ('+79637259702', 'Валентин', '2024-02-18 02:55:51+03', 'valya@example.com');
INSERT INTO public.client (phone, name, last_contact_date, email) VALUES ('+79389513658', 'Константин', '2024-02-18 02:55:51+03', 'konstantinus@example.com');


--
-- TOC entry 4979 (class 0 OID 50497)
-- Dependencies: 236
-- Data for Name: client_table; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.client_table (id_table, order_date, id_worker, client_phone, start_booking_date, end_booking_date) VALUES (1, '2024-03-18 10:00:00+03', 1, '+79389513678', '2024-03-23 10:00:00+03', '2024-03-23 12:00:00+03');
INSERT INTO public.client_table (id_table, order_date, id_worker, client_phone, start_booking_date, end_booking_date) VALUES (1, '2024-03-18 12:00:00+03', 3, '+79848718618', '2024-03-23 13:00:00+03', '2024-03-23 15:00:00+03');
INSERT INTO public.client_table (id_table, order_date, id_worker, client_phone, start_booking_date, end_booking_date) VALUES (1, '2024-03-17 14:00:00+03', 2, '+79330339678', '2024-03-23 17:00:00+03', '2024-03-23 19:00:00+03');
INSERT INTO public.client_table (id_table, order_date, id_worker, client_phone, start_booking_date, end_booking_date) VALUES (2, '2024-03-19 11:00:00+03', 4, '+79637259702', '2024-03-24 18:00:00+03', '2024-03-24 19:00:00+03');
INSERT INTO public.client_table (id_table, order_date, id_worker, client_phone, start_booking_date, end_booking_date) VALUES (3, '2024-03-20 14:00:00+03', 5, '+79389513658', '2024-03-25 10:00:00+03', '2024-03-25 19:00:00+03');


--
-- TOC entry 4969 (class 0 OID 33931)
-- Dependencies: 226
-- Data for Name: food; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (1, 'Супы', 'Борщ', 500, 'грамм', 350);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (2, 'Супы', 'Гороховый', 500, 'грамм', 299);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (3, 'Супы', 'Харчо', 500, 'грамм', 399);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (4, 'Супы', 'Куриный суп с домашней лапшой', 500, 'грамм', 399);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (5, 'Супы', 'Грибной', 500, 'грамм', 399);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (6, 'Домашнее', 'Пюре с котлетой', 400, 'грамм', 299);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (7, 'Домашнее', 'Пельмени', 500, 'грамм', 499);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (9, 'Блины', 'Блины с красной икрой', 300, 'грамм', 299);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (10, 'Блины', 'Блины с говядиной', 300, 'грамм', 299);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (11, 'Блины', 'Блины с черной икрой', 300, 'грамм', 600);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (12, 'Гарниры', 'Макароны стандартные', 400, 'грамм', 199);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (13, 'Гарниры', 'Рис длиннозерный', 300, 'грамм', 199);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (14, 'Гарниры', 'Печеный картофель', 400, 'грамм', 299);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (15, 'Салаты', 'Салат крабовый', 400, 'грамм', 399);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (16, 'Салаты', 'Салат оливье', 400, 'грамм', 399);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (17, 'Салаты', 'Сельдь под шубой', 400, 'грамм', 499);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (18, 'Десерты', 'Печеные яблоки', 200, 'грамм', 299);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (19, 'Десерты', 'Ватрушки', 200, 'грамм', 199);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (20, 'Десерты', 'Сырники', 200, 'грамм', 199);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (21, 'Каши', 'Рисовая молочная каша', 200, 'грамм', 199);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (22, 'Каши', 'Овсяная каша', 200, 'грамм', 199);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (23, 'Каши', 'Манная каша', 200, 'грамм', 199);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (40, 'Опционально', 'Хлеб', 200, 'грамм', 59);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (41, 'Опционально', 'Простая вода', 200, 'грамм', 59);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (35, 'Напитки', 'Квас', 200, 'грамм', 79);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (36, 'Напитки', 'Добрый кола', 200, 'грамм', 119);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (37, 'Напитки', 'Фрустайл апельсин', 200, 'грамм', 119);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (38, 'Напитки', 'Липтон зеленый', 200, 'грамм', 119);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (39, 'Напитки', 'Липтон черный', 200, 'грамм', 119);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (30, 'Напитки', 'Черный чай', 200, 'грамм', 99);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (27, 'Мясо', 'Нежная тушеная говядина', 400, 'грамм', 399);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (28, 'Мясо', 'Шашлык из баранины', 400, 'грамм', 599);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (29, 'Мясо', 'Свинина в духовке', 400, 'грамм', 499);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (31, 'Напитки', 'Зеленый чай', 200, 'грамм', 99);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (32, 'Напитки', 'Латте', 300, 'грамм', 99);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (33, 'Напитки', 'Капучино', 300, 'грамм', 99);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (34, 'Напитки', 'Глинтвейн', 300, 'грамм', 99);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (24, 'Рыба', 'Щука, тушеная в сметане с луком', 400, 'грамм', 499);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (25, 'Рыба', 'Запеченный осетр', 400, 'грамм', 499);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (26, 'Рыба', 'Лещ с капустой в духовке', 400, 'грамм', 399);


--
-- TOC entry 4973 (class 0 OID 33996)
-- Dependencies: 230
-- Data for Name: food_composition; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (1, 1, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (1, 2, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (1, 3, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (1, 4, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (1, 5, 30);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (1, 6, 30);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (2, 1, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (2, 4, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (2, 7, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (3, 8, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (3, 9, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (3, 10, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (3, 11, 10);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (4, 12, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (4, 5, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (4, 13, 20);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (4, 14, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (5, 15, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (5, 4, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (5, 5, 40);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (5, 13, 20);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (6, 16, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (6, 4, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (6, 13, 20);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (7, 17, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (7, 18, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (7, 19, 20);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (7, 20, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (10, 21, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (10, 16, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (10, 19, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (10, 13, 20);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (9, 21, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (9, 22, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (9, 13, 20);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (11, 21, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (11, 23, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (11, 13, 20);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (12, 24, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (13, 25, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (14, 4, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (15, 26, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (15, 27, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (15, 28, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (15, 29, 20);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (15, 13, 20);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (16, 4, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (16, 5, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (16, 26, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (16, 30, 20);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (16, 7, 20);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (16, 28, 30);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (16, 31, 30);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (16, 8, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (17, 2, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (17, 26, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (17, 28, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (17, 19, 20);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (17, 4, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (17, 32, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (17, 5, 30);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (18, 33, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (18, 34, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (19, 35, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (19, 36, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (19, 37, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (19, 34, 20);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (19, 26, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (20, 35, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (20, 37, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (20, 34, 20);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (20, 26, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (21, 9, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (21, 36, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (21, 59, 20);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (21, 34, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (21, 38, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (22, 39, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (22, 36, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (22, 34, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (22, 38, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (23, 40, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (23, 59, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (23, 34, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (23, 38, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (23, 31, 30);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (24, 41, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (24, 20, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (24, 19, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (24, 31, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (24, 42, 30);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (24, 43, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (25, 44, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (25, 45, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (25, 19, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (25, 31, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (25, 28, 30);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (25, 43, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (26, 46, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (26, 3, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (26, 5, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (26, 19, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (26, 13, 30);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (26, 45, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (26, 42, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (26, 31, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (27, 8, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (27, 19, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (27, 38, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (27, 36, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (27, 31, 30);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (27, 34, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (27, 48, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (27, 47, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (28, 49, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (28, 19, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (28, 31, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (28, 42, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (29, 1, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (29, 43, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (29, 31, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (29, 42, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (30, 50, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (30, 36, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (30, 34, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (31, 51, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (31, 36, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (31, 34, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (32, 59, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (32, 36, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (32, 34, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (32, 52, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (33, 59, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (33, 36, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (33, 34, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (33, 52, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (34, 45, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (34, 36, 100);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (34, 34, 50);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (35, 53, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (36, 54, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (37, 55, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (38, 56, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (39, 57, 200);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (40, 58, 300);


--
-- TOC entry 4962 (class 0 OID 33894)
-- Dependencies: 219
-- Data for Name: food_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.food_type (type) VALUES ('Супы');
INSERT INTO public.food_type (type) VALUES ('Домашнее');
INSERT INTO public.food_type (type) VALUES ('Блины');
INSERT INTO public.food_type (type) VALUES ('Гарниры');
INSERT INTO public.food_type (type) VALUES ('Салаты');
INSERT INTO public.food_type (type) VALUES ('Десерты');
INSERT INTO public.food_type (type) VALUES ('Каши');
INSERT INTO public.food_type (type) VALUES ('Опционально');
INSERT INTO public.food_type (type) VALUES ('Мясо');
INSERT INTO public.food_type (type) VALUES ('Рыба');
INSERT INTO public.food_type (type) VALUES ('Напитки');


--
-- TOC entry 4959 (class 0 OID 33877)
-- Dependencies: 216
-- Data for Name: ingredient; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (1, 'Свинина', 'грамм', 499, 10000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (2, 'Свекла', 'грамм', 299, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (3, 'Капуста', 'грамм', 299, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (4, 'Картофель', 'грамм', 299, 10000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (5, 'Морковь', 'грамм', 299, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (6, 'Чеснок', 'грамм', 299, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (7, 'Горох', 'грамм', 199, 3000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (8, 'Говядина', 'грамм', 499, 10000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (9, 'Рис', 'грамм', 299, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (10, 'Помидоры', 'грамм', 299, 10000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (11, 'Специи', 'грамм', 199, 2000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (12, 'Курица', 'грамм', 299, 10000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (13, 'Зелень', 'грамм', 199, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (14, 'Лапша', 'грамм', 199, 3000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (15, 'Шампиньоны', 'грамм', 399, 2000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (16, 'Говяжий фарш', 'грамм', 399, 7000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (17, 'Тесто', 'грамм', 199, 10000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (18, 'Свиной фарш', 'грамм', 399, 10000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (19, 'Лук', 'грамм', 199, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (20, 'Сметана', 'грамм', 299, 3000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (21, 'Блины', 'грамм', 199, 6000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (22, 'Икра кета', 'грамм', 599, 6000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (23, 'Черная осетровая икра', 'грамм', 799, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (24, 'Макароны стандартные', 'грамм', 199, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (25, 'Рис длиннозерный', 'грамм', 199, 10000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (26, 'Куриное яйцо', 'грамм', 299, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (27, 'Крабовые палочки', 'грамм', 299, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (28, 'Майонез', 'грамм', 399, 4000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (29, 'Кукуруза', 'грамм', 199, 6000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (30, 'Соленые огурцы', 'грамм', 199, 6000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (31, 'Соль', 'грамм', 99, 3000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (32, 'Сельдь', 'грамм', 399, 4000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (33, 'Яблоки', 'грамм', 199, 4000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (34, 'Сахар', 'грамм', 159, 6000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (35, 'Мука пшеничная', 'грамм', 159, 7000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (36, 'Вода', 'грамм', 59, 7000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (37, 'Творог', 'грамм', 159, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (38, 'Сливочное масло', 'грамм', 159, 6000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (39, 'Овсяные хлопья', 'грамм', 99, 4000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (40, 'Манная крупа', 'грамм', 99, 4000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (41, 'Щука', 'грамм', 99, 6000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (42, 'Перец', 'грамм', 99, 3000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (43, 'Подсолнечное масло', 'грамм', 99, 7000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (44, 'Осетр', 'грамм', 399, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (45, 'Лимон', 'грамм', 199, 4000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (46, 'Лещ', 'грамм', 399, 6000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (47, 'Лавровый лист', 'грамм', 99, 4000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (48, 'Уксус', 'грамм', 99, 4000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (49, 'Баранина', 'грамм', 499, 10000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (50, 'Черный чай', 'грамм', 199, 2000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (51, 'Зеленый чай', 'грамм', 199, 2000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (52, 'Кофейные зерна', 'грамм', 399, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (53, 'Квас', 'грамм', 99, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (54, 'Добрый кола', 'грамм', 199, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (55, 'Фрустайл апельсин', 'грамм', 199, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (56, 'Липтон зеленый', 'грамм', 199, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (57, 'Липтон черный', 'грамм', 199, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (58, 'Хлеб', 'грамм', 99, 5000);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (59, 'Молоко', 'грамм', 500, 6000);


--
-- TOC entry 4975 (class 0 OID 34034)
-- Dependencies: 232
-- Data for Name: ingredient_storage; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ingredient_storage (id, id_ingredient, delivery_date, id_request, valid_until, weight, quantity) VALUES (3, 2, '2024-03-28 13:57:44.339475+03', 5, '2024-04-20 13:57:44.339475+03', 6000, 6);
INSERT INTO public.ingredient_storage (id, id_ingredient, delivery_date, id_request, valid_until, weight, quantity) VALUES (4, 54, '2024-03-28 14:12:48.84737+03', 7, '2024-04-20 14:12:48.84737+03', 2600, 3);
INSERT INTO public.ingredient_storage (id, id_ingredient, delivery_date, id_request, valid_until, weight, quantity) VALUES (2, 1, '2024-03-28 13:50:04.458523+03', 3, '2024-04-20 13:50:04.458523+03', 17600, 9);
INSERT INTO public.ingredient_storage (id, id_ingredient, delivery_date, id_request, valid_until, weight, quantity) VALUES (5, 4, '2024-03-28 14:25:10.330282+03', 9, '2024-04-20 14:25:10.330282+03', 11800, 3);
INSERT INTO public.ingredient_storage (id, id_ingredient, delivery_date, id_request, valid_until, weight, quantity) VALUES (6, 7, '2024-03-28 14:25:20.310606+03', 10, '2024-04-20 14:25:20.310606+03', 11900, 3);


--
-- TOC entry 4961 (class 0 OID 33889)
-- Dependencies: 218
-- Data for Name: job_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.job_role (name, min_salary, max_salary) VALUES ('Главный повар', 50000, 60000);
INSERT INTO public.job_role (name, min_salary, max_salary) VALUES ('Повар', 40000, 50000);
INSERT INTO public.job_role (name, min_salary, max_salary) VALUES ('Официант', 30000, 40000);
INSERT INTO public.job_role (name, min_salary, max_salary) VALUES ('Менеджер', 40000, 50000);


--
-- TOC entry 4978 (class 0 OID 50458)
-- Dependencies: 235
-- Data for Name: order_directory; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_directory (id, id_worker, formation_date, issue_date, status) VALUES (1, 2, '2024-03-17 10:00:00+03', '2024-03-17 12:00:00+03', 'Ожидание');
INSERT INTO public.order_directory (id, id_worker, formation_date, issue_date, status) VALUES (2, 5, '2024-03-17 11:00:00+03', '2024-03-17 12:00:00+03', 'Ожидание');
INSERT INTO public.order_directory (id, id_worker, formation_date, issue_date, status) VALUES (3, 6, '2024-03-17 11:00:00+03', '2024-03-17 12:00:00+03', 'Отдано');
INSERT INTO public.order_directory (id, id_worker, formation_date, issue_date, status) VALUES (4, 6, '2024-03-17 13:00:00+03', '2024-03-17 13:30:00+03', 'Отдано');
INSERT INTO public.order_directory (id, id_worker, formation_date, issue_date, status) VALUES (8, 5, '2024-03-17 10:00:00+03', '2024-03-17 12:00:00+03', 'Рассматривается');
INSERT INTO public.order_directory (id, id_worker, formation_date, issue_date, status) VALUES (9, 5, '2024-03-17 10:00:00+03', '2024-03-17 12:00:00+03', 'Рассматривается');
INSERT INTO public.order_directory (id, id_worker, formation_date, issue_date, status) VALUES (10, 5, '2024-03-18 11:00:00+03', '2024-03-18 13:00:00+03', 'Рассматривается');


--
-- TOC entry 4980 (class 0 OID 58811)
-- Dependencies: 237
-- Data for Name: order_food; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (1, 1, 2);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (1, 2, 1);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (1, 3, 3);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (2, 4, 3);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (2, 5, 2);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (2, 7, 1);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (3, 11, 3);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (3, 2, 2);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (3, 6, 3);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (4, 13, 5);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (4, 4, 1);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (4, 5, 1);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (8, 36, 1);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (9, 36, 1);
INSERT INTO public.order_food (id_order, id_food, quantity) VALUES (10, 2, 2);


--
-- TOC entry 4976 (class 0 OID 34050)
-- Dependencies: 233
-- Data for Name: requisition; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.requisition (id, id_ingredient, weight, quantity) VALUES (3, 1, 3000, 3);
INSERT INTO public.requisition (id, id_ingredient, weight, quantity) VALUES (4, 1, 3000, 3);
INSERT INTO public.requisition (id, id_ingredient, weight, quantity) VALUES (5, 2, 3000, 3);
INSERT INTO public.requisition (id, id_ingredient, weight, quantity) VALUES (6, 2, 3000, 3);
INSERT INTO public.requisition (id, id_ingredient, weight, quantity) VALUES (7, 54, 3000, 3);
INSERT INTO public.requisition (id, id_ingredient, weight, quantity) VALUES (8, 1, 12000, 3);
INSERT INTO public.requisition (id, id_ingredient, weight, quantity) VALUES (9, 4, 12000, 3);
INSERT INTO public.requisition (id, id_ingredient, weight, quantity) VALUES (10, 7, 12000, 3);


--
-- TOC entry 4971 (class 0 OID 33961)
-- Dependencies: 228
-- Data for Name: requisition_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.requisition_list (id, id_worker, storage_name, date, status) VALUES (3, 1, 'Рундук', '2024-03-21 13:50:04+03', 'Ожидание');
INSERT INTO public.requisition_list (id, id_worker, storage_name, date, status) VALUES (4, 1, 'Рундук', '2024-03-21 13:57:12+03', 'Ожидание');
INSERT INTO public.requisition_list (id, id_worker, storage_name, date, status) VALUES (5, 1, 'Рундук', '2024-03-21 13:57:44+03', 'Ожидание');
INSERT INTO public.requisition_list (id, id_worker, storage_name, date, status) VALUES (6, 1, 'Рундук', '2024-03-21 13:57:53+03', 'Ожидание');
INSERT INTO public.requisition_list (id, id_worker, storage_name, date, status) VALUES (7, 1, 'Рундук', '2024-03-21 14:12:48+03', 'Ожидание');
INSERT INTO public.requisition_list (id, id_worker, storage_name, date, status) VALUES (8, 1, 'Рундук', '2024-03-21 14:24:51+03', 'Ожидание');
INSERT INTO public.requisition_list (id, id_worker, storage_name, date, status) VALUES (9, 1, 'Рундук', '2024-03-21 14:25:10+03', 'Ожидание');
INSERT INTO public.requisition_list (id, id_worker, storage_name, date, status) VALUES (10, 1, 'Рундук', '2024-03-21 14:25:20+03', 'Ожидание');


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
INSERT INTO public."table" (id, human_slots) VALUES (5, 2);
INSERT INTO public."table" (id, human_slots) VALUES (6, 4);
INSERT INTO public."table" (id, human_slots) VALUES (7, 6);
INSERT INTO public."table" (id, human_slots) VALUES (8, 2);
INSERT INTO public."table" (id, human_slots) VALUES (9, 4);
INSERT INTO public."table" (id, human_slots) VALUES (10, 6);
INSERT INTO public."table" (id, human_slots) VALUES (11, 2);
INSERT INTO public."table" (id, human_slots) VALUES (12, 4);
INSERT INTO public."table" (id, human_slots) VALUES (13, 6);
INSERT INTO public."table" (id, human_slots) VALUES (14, 2);
INSERT INTO public."table" (id, human_slots) VALUES (15, 4);
INSERT INTO public."table" (id, human_slots) VALUES (16, 6);
INSERT INTO public."table" (id, human_slots) VALUES (17, 2);
INSERT INTO public."table" (id, human_slots) VALUES (18, 4);
INSERT INTO public."table" (id, human_slots) VALUES (19, 6);
INSERT INTO public."table" (id, human_slots) VALUES (20, 8);


--
-- TOC entry 4967 (class 0 OID 33913)
-- Dependencies: 224
-- Data for Name: worker; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.worker (id, login, password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (2, 'gerar_pero', 'b9c950640e1b3740e98acb93e669c65766f6670dd1609ba91ff41052ba48c6f3', 'Повар', 'Герасимов', 'Глеб', 'Константинович', 'gera@mail.ru', '+79707551380', 45000, 5);
INSERT INTO public.worker (id, login, password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (3, 'ivanova_ivanova', 'b9c950640e1b3740e98acb93e669c65766f6670dd1609ba91ff41052ba48c6f3', 'Повар', 'Иванова Виктория Артёмовна', 'Виктория', 'Артёмовна', 'ivanova@mail.ru', '+79718551380', 46000, 5);
INSERT INTO public.worker (id, login, password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (4, 'pastux133', 'b9c950640e1b3740e98acb93e669c65766f6670dd1609ba91ff41052ba48c6f3', 'Менеджер', 'Пастухова', 'Александра', 'Максимовна', 'pastuxova@mail.ru', '+79718552580', 56000, 5);
INSERT INTO public.worker (id, login, password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (5, 'popova424', 'b9c950640e1b3740e98acb93e669c65766f6670dd1609ba91ff41052ba48c6f3', 'Официант', 'Попова', 'Дарья', 'Данииловна', 'popova@mail.ru', '+79848552580', 56000, 5);
INSERT INTO public.worker (id, login, password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (6, 'boriska', 'b9c950640e1b3740e98acb93e669c65766f6670dd1609ba91ff41052ba48c6f3', 'Официант', 'Борисов', 'Никита', 'Павлович', 'borisiris@mail.ru', '+79846552580', 56000, 5);
INSERT INTO public.worker (id, login, password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (1, 'alex_kol', 'b9c950640e1b3740e98acb93e669c65766f6670dd1609ba91ff41052ba48c6f3', 'Главный повар', 'Баженов', 'Данила', 'Филиппович', 'bajenov@mail.ru', '+79807551380', 56000, 5);


--
-- TOC entry 4972 (class 0 OID 33977)
-- Dependencies: 229
-- Data for Name: worker_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (2, '2024-03-21 13:18:49+03', '2024-03-21 13:18:49+03', 'Повар', 'Герасимов', 'Глеб', 'Константинович', 'gera@mail.ru', '+79707551380', 45000, NULL);
INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (3, '2024-03-21 13:19:05+03', '2024-03-21 13:19:05+03', 'Повар', 'Иванова Виктория Артёмовна', 'Виктория', 'Артёмовна', 'ivanova@mail.ru', '+79718551380', 46000, NULL);
INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (4, '2024-03-21 13:19:08+03', '2024-03-21 13:19:08+03', 'Менеджер', 'Пастухова', 'Александра', 'Максимовна', 'pastuxova@mail.ru', '+79718552580', 56000, NULL);
INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (5, '2024-03-21 13:19:10+03', '2024-03-21 13:19:10+03', 'Официант', 'Попова', 'Дарья', 'Данииловна', 'popova@mail.ru', '+79848552580', 56000, NULL);
INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (6, '2024-03-21 13:19:13+03', '2024-03-21 13:19:13+03', 'Официант', 'Борисов', 'Никита', 'Павлович', 'borisiris@mail.ru', '+79846552580', 56000, NULL);
INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (1, '2024-03-21 13:11:27+03', '2024-03-21 13:11:27+03', 'Главный повар', 'Баженов', 'Данила', 'Филиппович', 'bajenov@mail.ru', '+79807551380', 56000, '{"new": {"id": 1, "email": "bajenov@mail.ru", "login": "alex_kol", "phone": "+79807551380", "salary": 56000, "surname": "Баженов", "job_rate": 5, "job_role": "Главный повар", "password": "b9c950640e1b3740e98acb93e669c65766f6670dd1609ba91ff41052ba48c6f3", "first_name": "Данила", "patronymic": "Филиппович"}, "old": {"id": 1, "email": "bajenov@mail.ru", "login": "alex_kol", "phone": "+79807551380", "salary": 55000, "surname": "Баженов", "job_rate": 5, "job_role": "Главный повар", "password": "b9c950640e1b3740e98acb93e669c65766f6670dd1609ba91ff41052ba48c6f3", "first_name": "Данила", "patronymic": "Филиппович"}}');


--
-- TOC entry 4994 (class 0 OID 0)
-- Dependencies: 225
-- Name: food_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.food_id_seq', 41, true);


--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 215
-- Name: ingredient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredient_id_seq', 59, true);


--
-- TOC entry 4996 (class 0 OID 0)
-- Dependencies: 231
-- Name: ingredient_storage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredient_storage_id_seq', 6, true);


--
-- TOC entry 4997 (class 0 OID 0)
-- Dependencies: 234
-- Name: order_directory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_directory_id_seq', 10, true);


--
-- TOC entry 4998 (class 0 OID 0)
-- Dependencies: 227
-- Name: requisition_list_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.requisition_list_id_seq', 10, true);


--
-- TOC entry 4999 (class 0 OID 0)
-- Dependencies: 221
-- Name: table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.table_id_seq', 20, true);


--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 223
-- Name: worker_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.worker_id_seq', 6, true);


--
-- TOC entry 4769 (class 2606 OID 50532)
-- Name: client client_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_email_key UNIQUE (email);


--
-- TOC entry 4771 (class 2606 OID 33904)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (phone);


--
-- TOC entry 4793 (class 2606 OID 50504)
-- Name: client_table client_table_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_table
    ADD CONSTRAINT client_table_pkey PRIMARY KEY (id_table, order_date);


--
-- TOC entry 4785 (class 2606 OID 34000)
-- Name: food_composition food_composition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_composition
    ADD CONSTRAINT food_composition_pkey PRIMARY KEY (id_food, id_ingredient);


--
-- TOC entry 4779 (class 2606 OID 33938)
-- Name: food food_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food
    ADD CONSTRAINT food_pkey PRIMARY KEY (id);


--
-- TOC entry 4767 (class 2606 OID 33898)
-- Name: food_type food_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_type
    ADD CONSTRAINT food_type_pkey PRIMARY KEY (type);


--
-- TOC entry 4759 (class 2606 OID 42261)
-- Name: ingredient ingredient_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient
    ADD CONSTRAINT ingredient_name_unique UNIQUE (name);


--
-- TOC entry 4761 (class 2606 OID 33882)
-- Name: ingredient ingredient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient
    ADD CONSTRAINT ingredient_pkey PRIMARY KEY (id);


--
-- TOC entry 4787 (class 2606 OID 34039)
-- Name: ingredient_storage ingredient_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_storage
    ADD CONSTRAINT ingredient_storage_pkey PRIMARY KEY (id);


--
-- TOC entry 4765 (class 2606 OID 33893)
-- Name: job_role job_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_role
    ADD CONSTRAINT job_role_pkey PRIMARY KEY (name);


--
-- TOC entry 4791 (class 2606 OID 50466)
-- Name: order_directory order_directory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_directory
    ADD CONSTRAINT order_directory_pkey PRIMARY KEY (id);


--
-- TOC entry 4795 (class 2606 OID 58815)
-- Name: order_food order_food_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_food
    ADD CONSTRAINT order_food_pk PRIMARY KEY (id_order, id_food);


--
-- TOC entry 4781 (class 2606 OID 33966)
-- Name: requisition_list requisition_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_list
    ADD CONSTRAINT requisition_list_pkey PRIMARY KEY (id);


--
-- TOC entry 4789 (class 2606 OID 34054)
-- Name: requisition requisition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition
    ADD CONSTRAINT requisition_pkey PRIMARY KEY (id, id_ingredient);


--
-- TOC entry 4763 (class 2606 OID 33888)
-- Name: storehouse storage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storehouse
    ADD CONSTRAINT storage_pkey PRIMARY KEY (name);


--
-- TOC entry 4773 (class 2606 OID 33911)
-- Name: table table_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."table"
    ADD CONSTRAINT table_pkey PRIMARY KEY (id);


--
-- TOC entry 4783 (class 2606 OID 33985)
-- Name: worker_history worker_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_history
    ADD CONSTRAINT worker_history_pkey PRIMARY KEY (id_worker, start_date);


--
-- TOC entry 4775 (class 2606 OID 33924)
-- Name: worker worker_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_login_key UNIQUE (login);


--
-- TOC entry 4777 (class 2606 OID 33922)
-- Name: worker worker_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_pkey PRIMARY KEY (id);


--
-- TOC entry 4814 (class 2620 OID 58810)
-- Name: order_directory update_issue_date_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_issue_date_trigger BEFORE UPDATE ON public.order_directory FOR EACH ROW EXECUTE FUNCTION public.update_issue_date();


--
-- TOC entry 4813 (class 2620 OID 58845)
-- Name: worker worker_history_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER worker_history_trigger AFTER UPDATE ON public.worker FOR EACH ROW EXECUTE FUNCTION public.worker_history_trigger_function();


--
-- TOC entry 4808 (class 2606 OID 50515)
-- Name: client_table client_table_client_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_table
    ADD CONSTRAINT client_table_client_phone_fkey FOREIGN KEY (client_phone) REFERENCES public.client(phone);


--
-- TOC entry 4809 (class 2606 OID 50505)
-- Name: client_table client_table_id_table_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_table
    ADD CONSTRAINT client_table_id_table_fkey FOREIGN KEY (id_table) REFERENCES public."table"(id);


--
-- TOC entry 4810 (class 2606 OID 50510)
-- Name: client_table client_table_id_worker_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_table
    ADD CONSTRAINT client_table_id_worker_fkey FOREIGN KEY (id_worker) REFERENCES public.worker(id);


--
-- TOC entry 4801 (class 2606 OID 34001)
-- Name: food_composition food_composition_id_food_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_composition
    ADD CONSTRAINT food_composition_id_food_fkey FOREIGN KEY (id_food) REFERENCES public.food(id);


--
-- TOC entry 4802 (class 2606 OID 34006)
-- Name: food_composition food_composition_id_ingredient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_composition
    ADD CONSTRAINT food_composition_id_ingredient_fkey FOREIGN KEY (id_ingredient) REFERENCES public.ingredient(id);


--
-- TOC entry 4797 (class 2606 OID 33939)
-- Name: food food_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food
    ADD CONSTRAINT food_type_fkey FOREIGN KEY (type) REFERENCES public.food_type(type);


--
-- TOC entry 4803 (class 2606 OID 34040)
-- Name: ingredient_storage ingredient_storage_id_ingredient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_storage
    ADD CONSTRAINT ingredient_storage_id_ingredient_fkey FOREIGN KEY (id_ingredient) REFERENCES public.ingredient(id);


--
-- TOC entry 4804 (class 2606 OID 34045)
-- Name: ingredient_storage ingredient_storage_id_request_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_storage
    ADD CONSTRAINT ingredient_storage_id_request_fkey FOREIGN KEY (id_request) REFERENCES public.requisition_list(id);


--
-- TOC entry 4807 (class 2606 OID 50467)
-- Name: order_directory order_directory_id_worker_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_directory
    ADD CONSTRAINT order_directory_id_worker_fkey FOREIGN KEY (id_worker) REFERENCES public.worker(id);


--
-- TOC entry 4811 (class 2606 OID 58821)
-- Name: order_food order_food_fk_food; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_food
    ADD CONSTRAINT order_food_fk_food FOREIGN KEY (id_food) REFERENCES public.food(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4812 (class 2606 OID 58816)
-- Name: order_food order_food_fk_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_food
    ADD CONSTRAINT order_food_fk_order FOREIGN KEY (id_order) REFERENCES public.order_directory(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4805 (class 2606 OID 34055)
-- Name: requisition requisition_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition
    ADD CONSTRAINT requisition_id_fkey FOREIGN KEY (id) REFERENCES public.requisition_list(id);


--
-- TOC entry 4806 (class 2606 OID 34060)
-- Name: requisition requisition_id_ingredient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition
    ADD CONSTRAINT requisition_id_ingredient_fkey FOREIGN KEY (id_ingredient) REFERENCES public.ingredient(id);


--
-- TOC entry 4798 (class 2606 OID 33967)
-- Name: requisition_list requisition_list_id_worker_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_list
    ADD CONSTRAINT requisition_list_id_worker_fkey FOREIGN KEY (id_worker) REFERENCES public.worker(id);


--
-- TOC entry 4799 (class 2606 OID 33972)
-- Name: requisition_list requisition_list_storage_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_list
    ADD CONSTRAINT requisition_list_storage_name_fkey FOREIGN KEY (storage_name) REFERENCES public.storehouse(name);


--
-- TOC entry 4800 (class 2606 OID 33991)
-- Name: worker_history worker_history_id_job_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_history
    ADD CONSTRAINT worker_history_id_job_role_fkey FOREIGN KEY (id_job_role) REFERENCES public.job_role(name);


--
-- TOC entry 4796 (class 2606 OID 33925)
-- Name: worker worker_job_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_job_role_fkey FOREIGN KEY (job_role) REFERENCES public.job_role(name);


-- Completed on 2024-03-21 15:16:43

--
-- PostgreSQL database dump complete
--

