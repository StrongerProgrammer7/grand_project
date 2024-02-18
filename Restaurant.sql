--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

-- Started on 2024-02-18 06:14:52

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 33899)
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    phone character varying(32) NOT NULL,
    contact character varying(255) NOT NULL,
    last_contact_date timestamp with time zone NOT NULL,
    CONSTRAINT valid_phone_format CHECK (((((phone)::text ~* '^[\+]?[0-9]+$'::text) AND (length((phone)::text) >= 11)) OR (((phone)::text ~* '^[0-9]+$'::text) AND (length((phone)::text) >= 10))))
);


ALTER TABLE public.client OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 33944)
-- Name: client_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client_table (
    id_table integer NOT NULL,
    phone_client character varying(32) NOT NULL,
    order_date timestamp with time zone NOT NULL,
    desired_booking_date timestamp with time zone NOT NULL,
    CONSTRAINT valid_phone_client_format CHECK (((((phone_client)::text ~* '^[\+]?[0-9]+$'::text) AND (length((phone_client)::text) >= 11)) OR (((phone_client)::text ~* '^[0-9]+$'::text) AND (length((phone_client)::text) >= 10))))
);


ALTER TABLE public.client_table OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 33931)
-- Name: food; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food (
    id integer NOT NULL,
    type character varying NOT NULL,
    name character varying NOT NULL,
    weight double precision,
    unit_of_measurement character varying,
    price double precision NOT NULL
);


ALTER TABLE public.food OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 33996)
-- Name: food_composition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_composition (
    id_food integer NOT NULL,
    id_ingredient integer NOT NULL,
    weight double precision
);


ALTER TABLE public.food_composition OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 33930)
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
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 227
-- Name: food_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.food_id_seq OWNED BY public.food.id;


--
-- TOC entry 221 (class 1259 OID 33894)
-- Name: food_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_type (
    type character varying(50) NOT NULL
);


ALTER TABLE public.food_type OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 33877)
-- Name: ingredient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredient (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    measurement character varying(20) NOT NULL,
    price double precision,
    critical_rate integer NOT NULL
);


ALTER TABLE public.ingredient OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 33876)
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
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 217
-- Name: ingredient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ingredient_id_seq OWNED BY public.ingredient.id;


--
-- TOC entry 237 (class 1259 OID 34034)
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
-- TOC entry 236 (class 1259 OID 34033)
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
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 236
-- Name: ingredient_storage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ingredient_storage_id_seq OWNED BY public.ingredient_storage.id;


--
-- TOC entry 220 (class 1259 OID 33889)
-- Name: job_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_role (
    name character varying(50) NOT NULL,
    min_salary double precision NOT NULL,
    max_salary double precision NOT NULL
);


ALTER TABLE public.job_role OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 34012)
-- Name: order_directory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_directory (
    id integer NOT NULL,
    id_worker integer NOT NULL,
    phone_client character varying(32) NOT NULL,
    id_food integer NOT NULL,
    formation_date timestamp with time zone NOT NULL,
    giving_date timestamp with time zone NOT NULL,
    status character varying(50),
    num_of_food integer NOT NULL
);


ALTER TABLE public.order_directory OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 34011)
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
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 234
-- Name: order_directory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_directory_id_seq OWNED BY public.order_directory.id;


--
-- TOC entry 238 (class 1259 OID 34050)
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
-- TOC entry 231 (class 1259 OID 33961)
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
-- TOC entry 230 (class 1259 OID 33960)
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
-- TOC entry 4943 (class 0 OID 0)
-- Dependencies: 230
-- Name: requisition_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.requisition_list_id_seq OWNED BY public.requisition_list.id;


--
-- TOC entry 219 (class 1259 OID 33883)
-- Name: storage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.storage (
    name character varying(50) NOT NULL,
    address character varying(255) NOT NULL,
    phone character varying(20) NOT NULL,
    CONSTRAINT valid_phone_format CHECK (((((phone)::text ~* '^[\+]?[0-9]+$'::text) AND (length((phone)::text) >= 11)) OR (((phone)::text ~* '^[0-9]+$'::text) AND (length((phone)::text) >= 10))))
);


ALTER TABLE public.storage OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 33906)
-- Name: table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."table" (
    id integer NOT NULL,
    human_slots integer NOT NULL
);


ALTER TABLE public."table" OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 33905)
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
-- TOC entry 4944 (class 0 OID 0)
-- Dependencies: 223
-- Name: table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.table_id_seq OWNED BY public."table".id;


--
-- TOC entry 216 (class 1259 OID 31932)
-- Name: tables; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tables (
    id integer NOT NULL,
    human_slots integer NOT NULL
);


ALTER TABLE public.tables OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 31931)
-- Name: tables_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tables_id_seq OWNER TO postgres;

--
-- TOC entry 4945 (class 0 OID 0)
-- Dependencies: 215
-- Name: tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tables_id_seq OWNED BY public.tables.id;


--
-- TOC entry 226 (class 1259 OID 33913)
-- Name: worker; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.worker (
    id integer NOT NULL,
    login character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    test_password character varying(255) NOT NULL,
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
-- TOC entry 232 (class 1259 OID 33977)
-- Name: worker_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.worker_history (
    id_worker integer NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    id_job_role character varying(50) NOT NULL,
    surname character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    patronymic character varying(50),
    email character varying(255),
    phone character varying(20) NOT NULL,
    salary double precision NOT NULL,
    last_changes character varying,
    CONSTRAINT valid_email_format CHECK (((email)::text ~* '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'::text)),
    CONSTRAINT valid_phone_format CHECK (((((phone)::text ~* '^[\+]?[0-9]+$'::text) AND (length((phone)::text) >= 11)) OR (((phone)::text ~* '^[0-9]+$'::text) AND (length((phone)::text) >= 10))))
);


ALTER TABLE public.worker_history OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 33912)
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
-- TOC entry 4946 (class 0 OID 0)
-- Dependencies: 225
-- Name: worker_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.worker_id_seq OWNED BY public.worker.id;


--
-- TOC entry 4705 (class 2604 OID 33934)
-- Name: food id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food ALTER COLUMN id SET DEFAULT nextval('public.food_id_seq'::regclass);


--
-- TOC entry 4702 (class 2604 OID 33880)
-- Name: ingredient id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient ALTER COLUMN id SET DEFAULT nextval('public.ingredient_id_seq'::regclass);


--
-- TOC entry 4708 (class 2604 OID 34037)
-- Name: ingredient_storage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_storage ALTER COLUMN id SET DEFAULT nextval('public.ingredient_storage_id_seq'::regclass);


--
-- TOC entry 4707 (class 2604 OID 34015)
-- Name: order_directory id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_directory ALTER COLUMN id SET DEFAULT nextval('public.order_directory_id_seq'::regclass);


--
-- TOC entry 4706 (class 2604 OID 33964)
-- Name: requisition_list id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_list ALTER COLUMN id SET DEFAULT nextval('public.requisition_list_id_seq'::regclass);


--
-- TOC entry 4703 (class 2604 OID 33909)
-- Name: table id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."table" ALTER COLUMN id SET DEFAULT nextval('public.table_id_seq'::regclass);


--
-- TOC entry 4701 (class 2604 OID 31935)
-- Name: tables id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tables ALTER COLUMN id SET DEFAULT nextval('public.tables_id_seq'::regclass);


--
-- TOC entry 4704 (class 2604 OID 33916)
-- Name: worker id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker ALTER COLUMN id SET DEFAULT nextval('public.worker_id_seq'::regclass);


--
-- TOC entry 4917 (class 0 OID 33899)
-- Dependencies: 222
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.client (phone, contact, last_contact_date) VALUES ('+79389513658', 'Константин', '2024-02-18 02:55:51+03');
INSERT INTO public.client (phone, contact, last_contact_date) VALUES ('+79637259702', 'Валентин', '2024-02-18 02:55:51+03');
INSERT INTO public.client (phone, contact, last_contact_date) VALUES ('+79848718618', 'Анатолий', '2024-02-18 02:55:51+03');
INSERT INTO public.client (phone, contact, last_contact_date) VALUES ('+79330339678', 'Глеб', '2024-02-18 02:55:51+03');


--
-- TOC entry 4924 (class 0 OID 33944)
-- Dependencies: 229
-- Data for Name: client_table; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.client_table (id_table, phone_client, order_date, desired_booking_date) VALUES (1, '+79389513658', '2024-02-18 02:55:51+03', '2024-02-18 02:55:51+03');
INSERT INTO public.client_table (id_table, phone_client, order_date, desired_booking_date) VALUES (2, '+79637259702', '2024-02-18 02:55:51+03', '2024-02-18 02:55:51+03');
INSERT INTO public.client_table (id_table, phone_client, order_date, desired_booking_date) VALUES (3, '+79848718618', '2024-02-18 02:55:51+03', '2024-02-18 02:55:51+03');
INSERT INTO public.client_table (id_table, phone_client, order_date, desired_booking_date) VALUES (4, '+79330339678', '2024-02-18 02:55:51+03', '2024-02-18 02:55:51+03');


--
-- TOC entry 4923 (class 0 OID 33931)
-- Dependencies: 228
-- Data for Name: food; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (1, 'Напитки', 'Бурбон', 200, 'Грамм', 300);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (2, 'Пицца', 'Карбонара', 800, 'Грамм', 800);
INSERT INTO public.food (id, type, name, weight, unit_of_measurement, price) VALUES (3, 'Салаты', 'Цезарь', 400, 'Грамм', 600);


--
-- TOC entry 4928 (class 0 OID 33996)
-- Dependencies: 233
-- Data for Name: food_composition; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (1, 2, 300);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (2, 3, 500);
INSERT INTO public.food_composition (id_food, id_ingredient, weight) VALUES (3, 1, 700);


--
-- TOC entry 4916 (class 0 OID 33894)
-- Dependencies: 221
-- Data for Name: food_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.food_type (type) VALUES ('Пицца');
INSERT INTO public.food_type (type) VALUES ('Суши');
INSERT INTO public.food_type (type) VALUES ('Салаты');
INSERT INTO public.food_type (type) VALUES ('Напитки');


--
-- TOC entry 4913 (class 0 OID 33877)
-- Dependencies: 218
-- Data for Name: ingredient; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (1, 'Помидоры', 'кг', 200, 5);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (2, 'Огурцы', 'кг', 100, 3);
INSERT INTO public.ingredient (id, name, measurement, price, critical_rate) VALUES (3, 'Мука', 'кг', 50, 5);


--
-- TOC entry 4932 (class 0 OID 34034)
-- Dependencies: 237
-- Data for Name: ingredient_storage; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ingredient_storage (id, id_ingredient, delivery_date, id_request, valid_until, weight, quantity) VALUES (1, 1, '2024-02-18 02:55:51+03', 1, '2024-02-18 02:55:51+03', 10, 300);
INSERT INTO public.ingredient_storage (id, id_ingredient, delivery_date, id_request, valid_until, weight, quantity) VALUES (2, 2, '2024-02-18 02:55:51+03', 2, '2024-02-18 02:55:51+03', 1, 654);
INSERT INTO public.ingredient_storage (id, id_ingredient, delivery_date, id_request, valid_until, weight, quantity) VALUES (3, 3, '2024-02-18 02:55:51+03', 3, '2024-02-18 02:55:51+03', 3, 700);


--
-- TOC entry 4915 (class 0 OID 33889)
-- Dependencies: 220
-- Data for Name: job_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.job_role (name, min_salary, max_salary) VALUES ('Старший Повар', 70000, 80000);
INSERT INTO public.job_role (name, min_salary, max_salary) VALUES ('Младший Повар', 40000, 60000);
INSERT INTO public.job_role (name, min_salary, max_salary) VALUES ('Шеф-Повар', 2000000, 5000000);
INSERT INTO public.job_role (name, min_salary, max_salary) VALUES ('Официант', 30000, 40000);


--
-- TOC entry 4930 (class 0 OID 34012)
-- Dependencies: 235
-- Data for Name: order_directory; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_directory (id, id_worker, phone_client, id_food, formation_date, giving_date, status, num_of_food) VALUES (1, 1, '+79389513658', 1, '2024-02-18 02:55:51+03', '2024-02-18 02:55:51+03', 'Готовится', 2);
INSERT INTO public.order_directory (id, id_worker, phone_client, id_food, formation_date, giving_date, status, num_of_food) VALUES (2, 2, '+79637259702', 2, '2024-02-18 02:55:51+03', '2024-02-18 02:55:51+03', 'Подано', 1);
INSERT INTO public.order_directory (id, id_worker, phone_client, id_food, formation_date, giving_date, status, num_of_food) VALUES (3, 3, '+79848718618', 3, '2024-02-18 02:55:51+03', '2024-02-18 02:55:51+03', 'Готовится', 4);


--
-- TOC entry 4933 (class 0 OID 34050)
-- Dependencies: 238
-- Data for Name: requisition; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.requisition (id, id_ingredient, weight, quantity) VALUES (1, 2, 2, 30);
INSERT INTO public.requisition (id, id_ingredient, weight, quantity) VALUES (2, 1, 3, 40);
INSERT INTO public.requisition (id, id_ingredient, weight, quantity) VALUES (3, 3, 10, 50);


--
-- TOC entry 4926 (class 0 OID 33961)
-- Dependencies: 231
-- Data for Name: requisition_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.requisition_list (id, id_worker, storage_name, date, status) VALUES (1, 1, 'Сундук', '2024-02-18 02:55:51+03', 'В процессе');
INSERT INTO public.requisition_list (id, id_worker, storage_name, date, status) VALUES (2, 2, 'Рундук', '2024-02-18 02:55:51+03', 'Выполнено');
INSERT INTO public.requisition_list (id, id_worker, storage_name, date, status) VALUES (3, 3, 'Ларец', '2024-02-18 02:55:51+03', 'В процессе');


--
-- TOC entry 4914 (class 0 OID 33883)
-- Dependencies: 219
-- Data for Name: storage; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.storage (name, address, phone) VALUES ('Сундук', 'Краснодар', '+79057474162');
INSERT INTO public.storage (name, address, phone) VALUES ('Рундук', 'Ростов', '+79943211287');
INSERT INTO public.storage (name, address, phone) VALUES ('Ларец', 'Москва', '+79279675440');


--
-- TOC entry 4919 (class 0 OID 33906)
-- Dependencies: 224
-- Data for Name: table; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."table" (id, human_slots) VALUES (1, 4);
INSERT INTO public."table" (id, human_slots) VALUES (2, 3);
INSERT INTO public."table" (id, human_slots) VALUES (3, 2);
INSERT INTO public."table" (id, human_slots) VALUES (4, 5);


--
-- TOC entry 4911 (class 0 OID 31932)
-- Dependencies: 216
-- Data for Name: tables; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tables (id, human_slots) VALUES (1, 4);
INSERT INTO public.tables (id, human_slots) VALUES (2, 3);
INSERT INTO public.tables (id, human_slots) VALUES (3, 2);
INSERT INTO public.tables (id, human_slots) VALUES (4, 5);


--
-- TOC entry 4921 (class 0 OID 33913)
-- Dependencies: 226
-- Data for Name: worker; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.worker (id, login, password, test_password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (1, 'mikhail_prohvostin', '$pbkdf2-sha256$29000$Qeid8z4HAMD435tzDsEYQw$pQnulmZs1JcXU81PAk292IaVM2HfYOr1ArcVGqIpw/0', 'miha1337', 'Старший Повар', 'Прохвостин', 'Михаил', '', NULL, '+79028759088', 50000, NULL);
INSERT INTO public.worker (id, login, password, test_password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (2, 'alexxxanders_basket', '$pbkdf2-sha256$29000$TMm5dw4hhDAGIGRMae39nw$nmTEpKSwzg2LCnn3SC23PziGvP1G9QDisQKJVi4TXbs', 'zergi_rulyat', 'Младший Повар', 'Александров', 'Олег', '', NULL, '+79028759088', 50000, NULL);
INSERT INTO public.worker (id, login, password, test_password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (3, 'x_vasya_x', '$pbkdf2-sha256$29000$h5ASYkzpvZeSEqJU6h3jnA$sByoqbnOyttRGUfRdU63Qse/vz4SQ7Yhmcy75VeuPAw', 'protosi_one_love', 'Шеф-Повар', 'Васильев', 'Михаил', '', NULL, '+79028759088', 50000, NULL);
INSERT INTO public.worker (id, login, password, test_password, job_role, surname, first_name, patronymic, email, phone, salary, job_rate) VALUES (4, 'zufar_eto_ne_prochitaet', '$pbkdf2-sha256$29000$6h2D0HovpdR6j1Eq5TyHcA$SYPAkLWb3RNyox7wD/YQEFoWOeKMe3hozhT/3SR9Ux4', 'kerrigan_zZzerg', 'Официант', 'Иванов', 'Олег', '', NULL, '+79028759088', 50000, NULL);


--
-- TOC entry 4927 (class 0 OID 33977)
-- Dependencies: 232
-- Data for Name: worker_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (1, '2024-02-18 02:55:51+03', '2024-02-18 02:55:51+03', 'Шеф-Повар', 'Александров', 'Олег', NULL, NULL, '+79637259702', 50000, NULL);
INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (2, '2024-02-18 02:55:51+03', '2024-02-18 02:55:51+03', 'Младший Повар', 'Васильев', 'Олег', NULL, NULL, '+79637259702', 30000, NULL);
INSERT INTO public.worker_history (id_worker, start_date, end_date, id_job_role, surname, name, patronymic, email, phone, salary, last_changes) VALUES (3, '2024-02-18 02:55:51+03', '2024-02-18 02:55:51+03', 'Младший Повар', 'Иванов', 'Михаил', NULL, NULL, '+79637259702', 60000, NULL);


--
-- TOC entry 4947 (class 0 OID 0)
-- Dependencies: 227
-- Name: food_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.food_id_seq', 3, true);


--
-- TOC entry 4948 (class 0 OID 0)
-- Dependencies: 217
-- Name: ingredient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredient_id_seq', 3, true);


--
-- TOC entry 4949 (class 0 OID 0)
-- Dependencies: 236
-- Name: ingredient_storage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredient_storage_id_seq', 3, true);


--
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 234
-- Name: order_directory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_directory_id_seq', 3, true);


--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 230
-- Name: requisition_list_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.requisition_list_id_seq', 3, true);


--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 223
-- Name: table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.table_id_seq', 4, true);


--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 215
-- Name: tables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tables_id_seq', 4, true);


--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 225
-- Name: worker_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.worker_id_seq', 4, true);


--
-- TOC entry 4727 (class 2606 OID 33904)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (phone);


--
-- TOC entry 4737 (class 2606 OID 33949)
-- Name: client_table client_table_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_table
    ADD CONSTRAINT client_table_pkey PRIMARY KEY (id_table, phone_client);


--
-- TOC entry 4743 (class 2606 OID 34000)
-- Name: food_composition food_composition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_composition
    ADD CONSTRAINT food_composition_pkey PRIMARY KEY (id_food, id_ingredient);


--
-- TOC entry 4735 (class 2606 OID 33938)
-- Name: food food_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food
    ADD CONSTRAINT food_pkey PRIMARY KEY (id);


--
-- TOC entry 4725 (class 2606 OID 33898)
-- Name: food_type food_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_type
    ADD CONSTRAINT food_type_pkey PRIMARY KEY (type);


--
-- TOC entry 4719 (class 2606 OID 33882)
-- Name: ingredient ingredient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient
    ADD CONSTRAINT ingredient_pkey PRIMARY KEY (id);


--
-- TOC entry 4747 (class 2606 OID 34039)
-- Name: ingredient_storage ingredient_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_storage
    ADD CONSTRAINT ingredient_storage_pkey PRIMARY KEY (id);


--
-- TOC entry 4723 (class 2606 OID 33893)
-- Name: job_role job_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_role
    ADD CONSTRAINT job_role_pkey PRIMARY KEY (name);


--
-- TOC entry 4745 (class 2606 OID 34017)
-- Name: order_directory order_directory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_directory
    ADD CONSTRAINT order_directory_pkey PRIMARY KEY (id);


--
-- TOC entry 4739 (class 2606 OID 33966)
-- Name: requisition_list requisition_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_list
    ADD CONSTRAINT requisition_list_pkey PRIMARY KEY (id);


--
-- TOC entry 4749 (class 2606 OID 34054)
-- Name: requisition requisition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition
    ADD CONSTRAINT requisition_pkey PRIMARY KEY (id, id_ingredient);


--
-- TOC entry 4721 (class 2606 OID 33888)
-- Name: storage storage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storage
    ADD CONSTRAINT storage_pkey PRIMARY KEY (name);


--
-- TOC entry 4729 (class 2606 OID 33911)
-- Name: table table_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."table"
    ADD CONSTRAINT table_pkey PRIMARY KEY (id);


--
-- TOC entry 4717 (class 2606 OID 31937)
-- Name: tables tables_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tables
    ADD CONSTRAINT tables_pkey PRIMARY KEY (id);


--
-- TOC entry 4741 (class 2606 OID 33985)
-- Name: worker_history worker_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_history
    ADD CONSTRAINT worker_history_pkey PRIMARY KEY (id_worker, start_date);


--
-- TOC entry 4731 (class 2606 OID 33924)
-- Name: worker worker_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_login_key UNIQUE (login);


--
-- TOC entry 4733 (class 2606 OID 33922)
-- Name: worker worker_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_pkey PRIMARY KEY (id);


--
-- TOC entry 4752 (class 2606 OID 33950)
-- Name: client_table client_table_id_table_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_table
    ADD CONSTRAINT client_table_id_table_fkey FOREIGN KEY (id_table) REFERENCES public."table"(id);


--
-- TOC entry 4753 (class 2606 OID 33955)
-- Name: client_table client_table_phone_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client_table
    ADD CONSTRAINT client_table_phone_client_fkey FOREIGN KEY (phone_client) REFERENCES public.client(phone);


--
-- TOC entry 4758 (class 2606 OID 34001)
-- Name: food_composition food_composition_id_food_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_composition
    ADD CONSTRAINT food_composition_id_food_fkey FOREIGN KEY (id_food) REFERENCES public.food(id);


--
-- TOC entry 4759 (class 2606 OID 34006)
-- Name: food_composition food_composition_id_ingredient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_composition
    ADD CONSTRAINT food_composition_id_ingredient_fkey FOREIGN KEY (id_ingredient) REFERENCES public.ingredient(id);


--
-- TOC entry 4751 (class 2606 OID 33939)
-- Name: food food_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food
    ADD CONSTRAINT food_type_fkey FOREIGN KEY (type) REFERENCES public.food_type(type);


--
-- TOC entry 4763 (class 2606 OID 34040)
-- Name: ingredient_storage ingredient_storage_id_ingredient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_storage
    ADD CONSTRAINT ingredient_storage_id_ingredient_fkey FOREIGN KEY (id_ingredient) REFERENCES public.ingredient(id);


--
-- TOC entry 4764 (class 2606 OID 34045)
-- Name: ingredient_storage ingredient_storage_id_request_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient_storage
    ADD CONSTRAINT ingredient_storage_id_request_fkey FOREIGN KEY (id_request) REFERENCES public.requisition_list(id);


--
-- TOC entry 4760 (class 2606 OID 34028)
-- Name: order_directory order_directory_id_food_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_directory
    ADD CONSTRAINT order_directory_id_food_fkey FOREIGN KEY (id_food) REFERENCES public.food(id);


--
-- TOC entry 4761 (class 2606 OID 34018)
-- Name: order_directory order_directory_id_worker_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_directory
    ADD CONSTRAINT order_directory_id_worker_fkey FOREIGN KEY (id_worker) REFERENCES public.worker(id);


--
-- TOC entry 4762 (class 2606 OID 34023)
-- Name: order_directory order_directory_phone_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_directory
    ADD CONSTRAINT order_directory_phone_client_fkey FOREIGN KEY (phone_client) REFERENCES public.client(phone);


--
-- TOC entry 4765 (class 2606 OID 34055)
-- Name: requisition requisition_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition
    ADD CONSTRAINT requisition_id_fkey FOREIGN KEY (id) REFERENCES public.requisition_list(id);


--
-- TOC entry 4766 (class 2606 OID 34060)
-- Name: requisition requisition_id_ingredient_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition
    ADD CONSTRAINT requisition_id_ingredient_fkey FOREIGN KEY (id_ingredient) REFERENCES public.ingredient(id);


--
-- TOC entry 4754 (class 2606 OID 33967)
-- Name: requisition_list requisition_list_id_worker_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_list
    ADD CONSTRAINT requisition_list_id_worker_fkey FOREIGN KEY (id_worker) REFERENCES public.worker(id);


--
-- TOC entry 4755 (class 2606 OID 33972)
-- Name: requisition_list requisition_list_storage_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requisition_list
    ADD CONSTRAINT requisition_list_storage_name_fkey FOREIGN KEY (storage_name) REFERENCES public.storage(name);


--
-- TOC entry 4756 (class 2606 OID 33991)
-- Name: worker_history worker_history_id_job_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_history
    ADD CONSTRAINT worker_history_id_job_role_fkey FOREIGN KEY (id_job_role) REFERENCES public.job_role(name);


--
-- TOC entry 4757 (class 2606 OID 33986)
-- Name: worker_history worker_history_id_worker_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_history
    ADD CONSTRAINT worker_history_id_worker_fkey FOREIGN KEY (id_worker) REFERENCES public.worker(id);


--
-- TOC entry 4750 (class 2606 OID 33925)
-- Name: worker worker_job_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_job_role_fkey FOREIGN KEY (job_role) REFERENCES public.job_role(name);


-- Completed on 2024-02-18 06:14:52

--
-- PostgreSQL database dump complete
--

