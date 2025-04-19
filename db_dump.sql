--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: brand_clusters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.brand_clusters (
    id integer NOT NULL,
    scrap_id text,
    source text,
    brand text,
    cluster_id integer
);


ALTER TABLE public.brand_clusters OWNER TO postgres;

--
-- Name: brand_clusters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.brand_clusters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.brand_clusters_id_seq OWNER TO postgres;

--
-- Name: brand_clusters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.brand_clusters_id_seq OWNED BY public.brand_clusters.id;


--
-- Name: brand_representatives; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.brand_representatives (
    cluster_id integer NOT NULL,
    representative text
);


ALTER TABLE public.brand_representatives OWNER TO postgres;

--
-- Name: data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data (
    id integer NOT NULL,
    source integer NOT NULL,
    brand text,
    product_name text,
    quantity text,
    raw_title text NOT NULL,
    price numeric(10,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.data OWNER TO postgres;

--
-- Name: data_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.data_id_seq OWNER TO postgres;

--
-- Name: data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.data_id_seq OWNED BY public.data.id;


--
-- Name: scrap_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scrap_data (
    scrap_id bigint NOT NULL,
    source bigint,
    data text,
    price text
);


ALTER TABLE public.scrap_data OWNER TO postgres;

--
-- Name: scrap_data_scrap_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.scrap_data ALTER COLUMN scrap_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.scrap_data_scrap_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: brand_clusters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brand_clusters ALTER COLUMN id SET DEFAULT nextval('public.brand_clusters_id_seq'::regclass);


--
-- Name: data id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data ALTER COLUMN id SET DEFAULT nextval('public.data_id_seq'::regclass);


--
-- Data for Name: brand_clusters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.brand_clusters (id, scrap_id, source, brand, cluster_id) FROM stdin;
1	1139	3		0
2	1143	3		0
3	1147	3		0
4	1151	3		0
5	1155	3		0
6	1159	3		0
7	1163	3		0
8	1167	3		0
9	1171	3		0
10	1175	3		0
11	1140	3		0
12	1144	3		0
13	1148	3		0
14	1152	3		0
15	1156	3		0
16	1160	3		0
17	1164	3		0
18	1168	3		0
19	1172	3		0
20	1176	3		0
21	1141	3		0
22	1145	3		0
23	1149	3		0
24	1153	3		0
25	1157	3		0
26	1161	3		0
27	1165	3		0
28	1169	3		0
29	1173	3		0
30	1138	3		0
31	1142	3		0
32	1146	3		0
33	1150	3		0
34	1154	3		0
35	1158	3		0
36	1162	3		0
37	1166	3		0
38	1170	3		0
39	1174	3		0
40	193	2	biotechusa	1
41	200	2	biotechusa	1
42	2	1	ultimate nutrition	2
43	6	1	ultimate nutrition	2
44	13	1	ultimate nutrition	2
45	14	1	ultimate nutrition	2
46	28	1	ultimate nutrition	2
47	32	1	ultimate nutrition	2
48	36	1	ultimate nutrition	2
49	38	1	ultimate nutrition	2
50	191	2	ultimate nutrition	2
51	196	2	ultimate nutrition	2
52	195	2	ostrovit	3
53	205	2	ostrovit	3
54	1179	4	ostrovit	3
55	1207	4	ostrovit	3
56	198	2	ostrovit	3
57	1208	4	ostrovit	3
58	1177	4	ostrovit	3
59	1178	4	ostrovit	3
60	1214	4	ostrovit	3
61	1180	4	simply	4
62	1192	4	simply	4
63	1198	4	simply	4
64	11	1	sportlab	5
65	29	1	sportlab	5
66	39	1	sportlab	5
67	47	1	sportlab	5
68	1	1	optimum nutrition	6
69	4	1	optimum nutrition	6
70	16	1	optimum nutrition	6
71	18	1	optimum nutrition	6
72	21	1	optimum nutrition	6
73	23	1	optimum nutrition	6
74	60	1	optimum nutrition	6
75	62	1	optimum nutrition	6
76	197	2	optimum nutrition	6
77	192	2	optimum nutrition	6
78	194	2	optimum nutrition	6
79	1197	4	optimum nutrition	6
80	40	1	isopure	7
81	42	1	isopure	7
82	44	1	isopure	7
83	45	1	isopure	7
84	1191	4	finaflex	8
85	1196	4	finaflex	8
86	9	1	quest	9
87	41	1	quest	9
88	50	1	quest	9
89	1195	4	redcon 1	10
90	1209	4	redcon 1	10
91	1181	4	animal	11
92	1193	4	animal	11
93	1182	4	animal	11
94	1194	4	animal	11
95	3	1	winkler	12
96	17	1	winkler	12
97	35	1	winkler	12
98	48	1	winkler	12
99	1199	4	metabolic nutrition	13
100	1200	4	metabolic nutrition	13
101	43	1	syntrax	14
102	49	1	syntrax	14
103	61	1	syntrax	14
104	63	1	syntrax	14
105	65	1	syntrax	14
106	5	1	muscletech	15
107	7	1	muscletech	15
108	15	1	muscletech	15
109	19	1	muscletech	15
110	46	1	muscletech	15
111	199	2	muscletech	15
112	1203	4	muscletech	15
113	202	2	muscletech	15
114	1204	4	muscletech	15
115	1201	4	muscletech	15
116	1205	4	muscletech	15
117	1202	4	muscletech	15
118	1206	4	muscletech	15
119	25	1	integralmedica	16
120	54	1	integralmedica	16
121	55	1	integralmedica	16
122	56	1	integralmedica	16
123	57	1	integralmedica	16
124	58	1	integralmedica	16
125	64	1	integralmedica	16
126	52	1	easybody	17
127	1183	4	cellucor	18
128	10	1	bsn	19
129	24	1	bsn	19
130	201	2	nutrabio	20
131	31	1	mutant	21
132	37	1	mutant	21
133	51	1	mutant	21
134	53	1	mutant	21
135	8	1	myprotein	22
136	26	1	myprotein	22
137	59	1	chef protein	23
138	1189	4	abe	24
139	66	1	qnt	25
140	1211	4	rule 1	26
141	1212	4	rule 1	26
142	1210	4	rule 1	26
143	12	1	dymatize	27
144	30	1	dymatize	27
145	33	1	dymatize	27
146	1187	4	dymatize	27
147	1184	4	dymatize	27
148	204	2	dymatize	27
149	1185	4	dymatize	27
150	1186	4	dymatize	27
151	20	1	nutrex	28
152	22	1	nutrex	28
153	27	1	nutrex	28
154	34	1	nutrex	28
155	67	1	nutrex	28
156	1190	4	nutrex	28
157	1188	4	bpi sports	29
158	1213	4	bpi sports	29
159	203	2	my protein	30
\.


--
-- Data for Name: brand_representatives; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.brand_representatives (cluster_id, representative) FROM stdin;
1	biotechusa
2	ultimate nutrition
3	ostrovit
4	simply
5	sportlab
6	optimum nutrition
7	isopure
8	finaflex
9	quest
10	redcon 1
11	animal
12	winkler
13	metabolic nutrition
14	syntrax
15	muscletech
16	integralmedica
17	easybody
18	cellucor
19	bsn
20	nutrabio
21	mutant
22	myprotein
23	chef protein
24	abe
25	qnt
26	rule 1
27	dymatize
28	nutrex
29	bpi sports
30	my protein
\.


--
-- Data for Name: data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.data (id, source, brand, product_name, quantity, raw_title, price, created_at) FROM stdin;
1	1	optimum nutrition	gold standard 100% whey protein  original	5 lb	optimum nutrition gold standard 100% whey protein 5 lb original	88990.00	2025-04-15 00:43:02.345784
2	1	ultimate nutrition	prostar whey whey protein  original	5 lb	ultimate nutrition prostar whey whey protein 5 lb original	69690.00	2025-04-15 00:43:02.345784
3	1	winkler	whey pro win	44 lb	winkler whey pro win 44 lb	81990.00	2025-04-15 00:43:02.345784
4	1	optimum nutrition	gold standard 100% whey protein  original	2 lb	optimum nutrition gold standard 100% whey protein 2 lb original	53990.00	2025-04-15 00:43:02.345784
5	1	muscletech	nitro tech 100% whey gold  original	5 lb	muscletech nitro tech 100% whey gold 5 lb original	85990.00	2025-04-15 00:43:02.345784
6	1	ultimate nutrition	prostar whey whey protein  original	2 lb	ultimate nutrition prostar whey whey protein 2 lb original	48990.00	2025-04-15 00:43:02.345784
7	1	muscletech	nitro tech whey protein  original	4 lb	muscletech nitro tech whey protein 4 lb original	79990.00	2025-04-15 00:43:02.345784
8	1	myprotein	impact whey protein	2.5 kg	myprotein impact whey protein 2.5 kg	78990.00	2025-04-15 00:43:02.345784
9	1	quest	protein cookie snack proteico r	59 g	quest quest protein cookie snack proteico 59 gr	4190.00	2025-04-15 00:43:02.345784
10	1	bsn	syntha 6 whey protein  original	5 lb	bsn syntha 6 whey protein 5 lb original	77990.00	2025-04-15 00:43:02.345784
11	1	sportlab	whey matrix whey protein  original	5 lb	sportlab whey matrix whey protein 5 lb original	84990.00	2025-04-15 00:43:02.345784
12	1	dymatize	iso 100 isolate protein	5 lb	dymatize iso 100 isolate protein 5 lb	119990.00	2025-04-15 00:43:02.345784
13	1	ultimate nutrition	prostar whey whey protein  original	1 lb	ultimate nutrition prostar whey whey protein 1 lb original	31990.00	2025-04-15 00:43:02.345784
14	1	ultimate nutrition	prostar 100% raw whey protein  original	22 lb	ultimate nutrition prostar 100% raw whey protein 22 lb original	48990.00	2025-04-15 00:43:02.345784
15	1	muscletech	nitro tech whey protein  original	2 lb	muscletech nitro tech whey protein 2 lb original	49990.00	2025-04-15 00:43:02.345784
16	1	optimum nutrition	100% whey protein isolate gold standard  original	5 lb	optimum nutrition 100% whey protein isolate gold standard 5 lb original	110990.00	2025-04-15 00:43:02.345784
17	1	winkler	whey pro win	22 lb	winkler whey pro win 22 lb	54990.00	2025-04-15 00:43:02.345784
18	1	optimum nutrition	gold standard 100% whey protein  original	4.65 lb	optimum nutrition gold standard 100% whey protein 4.65 lb original	88990.00	2025-04-15 00:43:02.345784
19	1	muscletech	nitro tech 100% whey gold  original	2 lb	muscletech nitro tech 100% whey gold 2 lb original	55990.00	2025-04-15 00:43:02.345784
20	1	nutrex	isofit isolate protein  original	5 lb	nutrex isofit isolate protein 5 lb original	103990.00	2025-04-15 00:43:02.345784
21	1	optimum nutrition	100% whey protein isolate gold standard  original	2.91 lb	optimum nutrition 100% whey protein isolate gold standard 2.91 lb original	74990.00	2025-04-15 00:43:02.345784
22	1	nutrex	isofit isolate protein  original	23 lb	nutrex isofit isolate protein 23 lb original	59990.00	2025-04-15 00:43:02.345784
23	1	optimum nutrition	gold standard 100% whey protein  original	1.85 lb	optimum nutrition gold standard 100% whey protein 1.85 lb original	53990.00	2025-04-15 00:43:02.345784
24	1	bsn	syntha 6 whey protein  original	29 lb	bsn syntha 6 whey protein 29 lb original	55990.00	2025-04-15 00:43:02.345784
25	1	integralmedica	whey 100% pure whey protein  original	2 lb	integralmedica whey 100% pure whey protein 2 lb original	38990.00	2025-04-15 00:43:02.345784
26	1	myprotein	impact whey isolate	25 kg	myprotein impact whey isolate 25 kg	103990.00	2025-04-15 00:43:02.345784
27	1	nutrex	isofit isolate protein	5 lb	nutrex isofit isolate protein 5 lb	103990.00	2025-04-15 00:43:02.345784
28	1	ultimate nutrition	whey gold whey protein  original	5 lb	ultimate nutrition whey gold whey protein 5 lb original	74990.00	2025-04-15 00:43:02.345784
29	1	sportlab	isolate matrix isolate protein  original	2 lb	sportlab isolate matrix isolate protein 2 lb original	61990.00	2025-04-15 00:43:02.345784
30	1	dymatize	iso 100 hydrolized  dm	1.43 lb	dymatize iso 100 hydrolized 1.43 lb dm	60990.00	2025-04-15 00:43:02.345784
31	1	mutant	whey	5 lb	mutant whey 5 lb mutant	55990.00	2025-04-15 00:43:02.345784
32	1	ultimate nutrition	iso cool isolate protein  original	2 lb	ultimate nutrition iso cool isolate protein 2 lb original	59990.00	2025-04-15 00:43:02.345784
33	1	dymatize	iso 100 hydrolized  dm	1.36 lb	dymatize iso 100 hydrolized 1.36 lb dm	60990.00	2025-04-15 00:43:02.345784
34	1	nutrex	isofit  vainilla cream	21 lb	nutrex isofit 21 lb vainilla cream	59990.00	2025-04-15 00:43:02.345784
35	1	winkler	prote muscle 500 cc	\N	winkler prote muscle 500 cc winkler	2990.00	2025-04-15 00:43:02.345784
36	1	ultimate nutrition	whey gold whey protein  original	2 lb	ultimate nutrition whey gold whey protein 2 lb original	46990.00	2025-04-15 00:43:02.345784
37	1	mutant	iso surge	5lb	mutant iso surge 5lb mutant	80740.00	2025-04-15 00:43:02.345784
38	1	ultimate nutrition	iso cool isolate protein  original	5 lb	ultimate nutrition iso cool isolate protein 5 lb original	103990.00	2025-04-15 00:43:02.345784
39	1	sportlab	whey matrix woman chocolate berries s	2 lb	sportlab whey matrix woman chocolate berries 2 lbs sportlab	31190.00	2025-04-15 00:43:02.345784
40	1	isopure	zero carb protein	3 lb	isopure isopure zero carb protein 3 lb	64990.00	2025-04-15 00:43:02.345784
41	1	quest	protein bar mini	\N	quest protein bar mini quest	2990.00	2025-04-15 00:43:02.345784
42	1	isopure	zero carb protein	4.5 lb	isopure isopure zero carb protein 4.5 lb	90990.00	2025-04-15 00:43:02.345784
43	1	syntrax	nect  syn	2lb	syntrax nect 2lb syn	62990.00	2025-04-15 00:43:02.345784
44	1	isopure	zero carb protein  unflavored	1 lb	isopure isopure zero carb protein 1 lb unflavored	29990.00	2025-04-15 00:43:02.345784
45	1	isopure	low carb protein  chocolate	1 lb	isopure isopure low carb protein 1 lb chocolate	29990.00	2025-04-15 00:43:02.345784
46	1	muscletech	grassfed 100% whey protein  mtech	1.8 lb	muscletech grassfed 100% whey protein 1.8 lb mtech	49990.00	2025-04-15 00:43:02.345784
47	1	sportlab	whey matrix whey protein  original	2 lb	sportlab whey matrix whey protein 2 lb original	50990.00	2025-04-15 00:43:02.345784
48	1	winkler	whey pro win sachet rs wkl	33 g	winkler whey pro win sachet 33 grs wkl	2990.00	2025-04-15 00:43:02.345784
49	1	syntrax	nectar grab n go isolate protein r original	31 g	syntrax nectar grab n go isolate protein 31 gr original	4190.00	2025-04-15 00:43:02.345784
50	1	quest	frosted cookies	\N	quest frosted cookies quest	3390.00	2025-04-15 00:43:02.345784
51	1	mutant	100% whey dual  triple chocolate/vanilla ice cream mtant	4 lb	mutant 100% whey dual 4 lb triple chocolate/vanilla ice cream mtant	56790.00	2025-04-15 00:43:02.345784
52	1	easybody	skinny protein  easy	450g	easybody skinny protein 450g easy	23790.00	2025-04-15 00:43:02.345784
53	1	mutant	whey	10 lb	mutant whey 10 lb mutant	93490.00	2025-04-15 00:43:02.345784
54	1	integralmedica	whey 100% pure whey protein  original	4 lb	integralmedica whey 100% pure whey protein 4 lb original	61990.00	2025-04-15 00:43:02.345784
55	1	integralmedica	my whey protein pouch r im	900g	integralmedica my whey protein pouch 900gr im	50990.00	2025-04-15 00:43:02.345784
56	1	integralmedica	nutri whey protein  original	4 lb	integralmedica nutri whey protein 4 lb original	44990.00	2025-04-15 00:43:02.345784
57	1	integralmedica	nutri whey protein  original	2 lb	integralmedica nutri whey protein 2 lb original	25990.00	2025-04-15 00:43:02.345784
58	1	integralmedica	protein whey bar vo2 im	\N	integralmedica protein whey bar vo2 im	1490.00	2025-04-15 00:43:02.345784
59	1	chef protein	sin sabor	2.8lb	chef protein chef protein 2.8lb sin sabor	54990.00	2025-04-15 00:43:02.345784
60	1	optimum nutrition	gold standard 100% isolate chocolate bliss gf  on	1.64 lb	optimum nutrition gold standard 100% isolate chocolate bliss gf 1.64 lb on	46990.00	2025-04-15 00:43:02.345784
61	1	syntrax	nectar isolate proteína  sin cafeína	2 lb	syntrax nectar isolate proteína 2 lb sin cafeína	53990.00	2025-04-15 00:43:02.345784
62	1	optimum nutrition	gold standard 100% isolate vainilla gf  on	1.58 lb	optimum nutrition gold standard 100% isolate vainilla gf 1.58 lb on	46990.00	2025-04-15 00:43:02.345784
63	1	syntrax	nect latte  syn	2lb	syntrax nect latte 2lb syn	62990.00	2025-04-15 00:43:02.345784
64	1	integralmedica	my whey protein rtd 250ml im	\N	integralmedica my whey protein rtd 250ml im	3990.00	2025-04-15 00:43:02.345784
65	1	syntrax	nect medical  unflavored syn	2lb	syntrax nect medical 2lb unflavored syn	62990.00	2025-04-15 00:43:02.345784
66	1	qnt	light digest whey pro	11 lb	qnt light digest whey pro 11 lb	28990.00	2025-04-15 00:43:02.345784
67	1	nutrex	whey protein 100% whey	5lb	nutrex whey protein 100% whey 5lb	78990.00	2025-04-15 00:43:02.345784
191	2	ultimate nutrition	prostar	5 lb	ultimate nutrition ultimate nutrition prostar 5 lb	66990.00	2025-04-15 01:02:04.995391
193	2	biotechusa	biotech 100% pure whey 1 servicio	\N	biotechusa biotech 100% pure whey 1 servicio	2000.00	2025-04-15 01:02:05.060575
195	2	ostrovit	whey protein wpc80  sin sabor	700 gr	ostrovit ostrovit whey protein wpc80 700 gr sin sabor	21990.00	2025-04-15 01:02:05.127878
197	2	optimum nutrition	on whey gold standard	2 lb	optimum nutrition on whey gold standard 2 lb	46990.00	2025-04-15 01:02:05.192653
199	2	muscletech	nitrotech	4 lb	muscletech muscletech nitrotech 4 lb	59990.00	2025-04-15 01:02:05.256735
201	2	nutrabio	classic whey protein	5 lb	nutrabio nutrabio classic whey protein 5 lb	64990.00	2025-04-15 01:02:05.428381
203	2	my protein	myprotein impact whey	5.5 lb	my protein myprotein impact whey 5.5 lb	69990.00	2025-04-15 01:02:05.491021
205	2	ostrovit	100% whey protein	700 gr	ostrovit ostrovit 100% whey protein 700 gr	19990.00	2025-04-15 01:02:05.555003
1139	3		gold standard creatina 300gr nutrex shaker fire	5lb	gold standard 5lb creatina 300gr nutrex shaker fire	92.98	2025-04-15 01:41:20.306303
1143	3		prostar whey creatina 300gr ultimate nutrition	5lb	prostar whey 5lb creatina 300gr ultimate nutrition	86.98	2025-04-15 01:41:20.432596
1147	3		nitro tech muscletech	4lb	nitro tech 4lb muscletech	61.99	2025-04-15 01:41:20.564292
1151	3		impact whey phedracut	5lb	impact whey 5lb phedracut	69.99	2025-04-15 01:41:20.815239
1155	3		elite whey dymatize phedracut	5lb	elite whey 5lb dymatize phedracut	66.99	2025-04-15 01:41:21.059102
1159	3		whey protein ostrovit quemador phedracut usn	2 kg	whey 2 kg protein ostrovit quemador phedracut usn	44.99	2025-04-15 01:41:21.191368
1163	3		protein shake 330 ml qnt	\N	protein shake 330 ml qnt	2.99	2025-04-15 01:41:21.321648
1167	3		your protein whey	1.28 kg	your protein whey 1.28 kg	46.99	2025-04-15 01:41:21.449294
1171	3		whey protein 100% nutrex quemador phedracut usn	5lb	whey protein 100% 5lb nutrex quemador phedracut usn	54.99	2025-04-15 01:41:21.575293
1175	3		elite whey creatina 300gr ostrovit shaker fire	5lb	elite whey 5lb creatina 300gr ostrovit shaker fire	74.98	2025-04-15 01:41:21.698418
1179	4	ostrovit	ostrovit 100% whey protein ostrovit	4.4 lbs	ostrovit 100% whey protein 4.4 lbs ostrovit	56990.00	2025-04-15 01:41:59.019819
1183	4	cellucor	cellucor c4 whey protein hersheys reeses	\N	cellucor c4 whey protein hersheys reeses	71990.00	2025-04-15 01:41:59.148815
1187	4	dymatize	dymatize iso 100	5 lbs	dymatize iso 100 5 lbs	99990.00	2025-04-15 01:41:59.394566
1191	4	finaflex	finaflex isolate protein finaflex	55 lb	finaflex isolate protein finaflex 55 lb	89990.00	2025-04-15 01:41:59.523518
1195	4	redcon 1	redcon 1 isotope	5 lbs	redcon 1 isotope 5 lbs	74990.00	2025-04-15 01:42:06.60155
1199	4	metabolic nutrition	metabolic nutrition musclean	2.5 lbs	metabolic nutrition musclean 2.5 lbs	44990.00	2025-04-15 01:42:06.84233
1203	4	muscletech	muscletech nitro tech 100% whey gold	5 lbs	muscletech nitro tech 100% whey gold 5 lbs	79990.00	2025-04-15 01:42:06.976113
1207	4	ostrovit	ostrovit protein coffee proteina cafeina	\N	ostrovit protein coffee proteina cafeina	19990.00	2025-04-15 01:42:14.196581
1211	4	rule 1	rule 1 rule1 whey protein blend	5 lbs	rule 1 rule1 whey protein blend 5 lbs	64990.00	2025-04-15 01:42:14.32367
192	2	optimum nutrition	on whey gold standard	5 lb	optimum nutrition on whey gold standard 5 lb	76990.00	2025-04-15 01:02:05.0282
194	2	optimum nutrition	on whey gold standard 1 servicio	\N	optimum nutrition on whey gold standard 1 servicio	2500.00	2025-04-15 01:02:05.093394
196	2	ultimate nutrition	prostar	2 lb	ultimate nutrition ultimate nutrition prostar 2 lb	38990.00	2025-04-15 01:02:05.158347
198	2	ostrovit	100% whey protein	2000 gr	ostrovit ostrovit 100% whey protein 2000 gr	46990.00	2025-04-15 01:02:05.22652
200	2	biotechusa	biotech 100% pure whey	5 lb	biotechusa biotech 100% pure whey 5 lb	62990.00	2025-04-15 01:02:05.396318
202	2	muscletech	nitrotech whey gold	5 lb	muscletech muscletech nitrotech whey gold 5 lb	67990.00	2025-04-15 01:02:05.460393
1140	3		iso 100 dymatize	5lb	iso 100 5lb dymatize	91.99	2025-04-15 01:41:20.337968
1144	3		prostar whey creatina nutrex 300gr shaker fire	5lb	prostar whey 5lb creatina nutrex 300gr shaker fire	82.98	2025-04-15 01:41:20.465307
1148	3		prostar whey ultimate nutrition	5lb	prostar 5lb whey ultimate nutrition	66.99	2025-04-15 01:41:20.598068
1152	3		ration whey redcon1 shaker fire	\N	ration whey redcon1 shaker fire	54.99	2025-04-15 01:41:20.849571
1156	3		protein bite your goal	55gr	protein bite 55gr your goal	2.49	2025-04-15 01:41:21.091798
1160	3		proteína metapure whey isolate 500 ml qnt	\N	proteína metapure whey isolate 500 ml qnt	2.79	2025-04-15 01:41:21.22468
1164	3		twentys your goal	60gr	twentys 60gr your goal	2.69	2025-04-15 01:41:21.354219
1168	3		your protein bar	\N	your protein bar	1.59	2025-04-15 01:41:21.48013
1172	3		c4 whey protein cellucor quemador phedracut usn	\N	c4 whey protein cellucor quemador phedracut usn	69.99	2025-04-15 01:41:21.60697
1176	3		prostar whey creatina 300gr ultimate nutrition	5lb	prostar whey 5lb creatina 300gr ultimate nutrition	86.98	2025-04-15 01:41:21.728255
1180	4	simply	simply 100% whey protein simply	5 lb	simply 100% whey protein simply 5 lb	69990.00	2025-04-15 01:41:59.052676
1184	4	dymatize	dymatize elite 100% whey	5 lbs	dymatize elite 100% whey 5 lbs	72990.00	2025-04-15 01:41:59.194227
1188	4	bpi sports	bpi sports iso hd	5 lbs	bpi sports iso hd 5 lbs	79990.00	2025-04-15 01:41:59.427002
1192	4	simply	simply isolate protein simply	5 lb	simply isolate protein simply 5 lb	89990.00	2025-04-15 01:42:06.503951
1196	4	finaflex	finaflex muestra clear protein finaflex	\N	finaflex muestra clear protein finaflex	1990.00	2025-04-15 01:42:06.633258
1200	4	metabolic nutrition	metabolic nutrition musclean	5 lbs	metabolic nutrition musclean 5 lbs	74990.00	2025-04-15 01:42:06.876725
1204	4	muscletech	muscletech nitro tech 100% whey gold edición limitada	5 lbs	muscletech nitro tech 100% whey gold edición limitada 5 lbs	79990.00	2025-04-15 01:42:07.010108
1208	4	ostrovit	ostrovit protein shake sabores	1.5 lbs	ostrovit protein shake 1.5 lbs sabores	19990.00	2025-04-15 01:42:14.229948
1212	4	rule 1	rule 1 rule1 whey protein isolate hydrolyzed	5 lb	rule 1 rule1 whey protein isolate hydrolyzed 5 lb	89990.00	2025-04-15 01:42:14.359459
204	2	dymatize	elite 100% whey protein	5 lb	dymatize dymatize elite 100% whey protein 5 lb	69990.00	2025-04-15 01:02:05.522544
1141	3		impact whey isolate my protein	25 kg	impact whey isolate 25 kg my protein	89.99	2025-04-15 01:41:20.369262
1145	3		isolate kiffer	5lb	isolate 5lb kiffer	79.99	2025-04-15 01:41:20.498269
1149	3		nitro whey gold phedracut	5lb	nitro whey gold 5lb phedracut	64.99	2025-04-15 01:41:20.632435
1153	3		whey performance kiffer phedracut	5lb	whey 5lb performance kiffer phedracut	56.99	2025-04-15 01:41:20.882315
1157	3		platinium 8hour protein muscletech	4.6 lb	platinium 8hour protein muscletech 4.6 lb	66.99	2025-04-15 01:41:21.124248
1161	3		crunchy bar qnt	65gr	crunchy bar 65gr qnt	2.99	2025-04-15 01:41:21.258083
1165	3		whey gold pvl	6 lb	whey gold 6 lb pvl	59.99	2025-04-15 01:41:21.38646
1169	3		protein crisp bar integralmedica	45 gr	protein crisp bar 45 gr integralmedica	1.70	2025-04-15 01:41:21.511972
1173	3		gold standard creatina 300gr nutrex shaker fire	5lb	gold standard 5lb creatina 300gr nutrex shaker fire	92.98	2025-04-15 01:41:21.637811
1177	4	ostrovit	ostrovit 100% whey isolate ostrovit	4 lbs	ostrovit 100% whey isolate 4 lbs ostrovit	69990.00	2025-04-15 01:41:58.951838
1181	4	animal	animal animal 100% whey protein	4 lbs	animal animal 100% whey protein 4 lbs	54990.00	2025-04-15 01:41:59.083742
1185	4	dymatize	dymatize iso 100	1.4 lbs	dymatize iso 100 1.4 lbs	49990.00	2025-04-15 01:41:59.33022
1189	4	abe	abe iso whey abe	2 lbs	abe iso whey abe 2 lbs	47990.00	2025-04-15 01:41:59.459041
1193	4	animal	animal isolate whey protein animal	10 lb	animal isolate whey protein animal 10 lb	129990.00	2025-04-15 01:42:06.536501
1197	4	optimum nutrition	optimum nutrition muestra gold standard 100% whey	\N	optimum nutrition muestra gold standard 100% whey	1990.00	2025-04-15 01:42:06.664256
1201	4	muscletech	muscletech nitro tech	10 lbs	muscletech nitro tech 10 lbs	129990.00	2025-04-15 01:42:06.909889
1205	4	muscletech	muscletech nitro tech	2.2 lbs	muscletech nitro tech 2.2 lbs	44990.00	2025-04-15 01:42:07.041317
1209	4	redcon 1	redcon 1 ration redcon1	5 lbs	redcon 1 ration 5 lbs redcon1	59990.00	2025-04-15 01:42:14.26056
1213	4	bpi sports	bpi sports whey hd	4 lbs	bpi sports whey hd 4 lbs	59990.00	2025-04-15 01:42:14.394185
1138	3		100% whey protein isolate gold standard on	5lb	100% whey protein isolate gold standard 5lb on	99.99	2025-04-15 01:41:20.273427
1142	3		iso hd 90 cfm amix	4.4 lb	iso hd 90 cfm 4.4 lb amix	86.99	2025-04-15 01:41:20.401488
1146	3		gold standard on	5lb	gold standard 5lb on	76.99	2025-04-15 01:41:20.532067
1150	3		whey mutant phedracut	5 lb	whey 5 lb mutant phedracut	56.99	2025-04-15 01:41:20.781149
1154	3		whey hd bpi phedracut	4.1lb	whey hd 4.1lb bpi phedracut	46.99	2025-04-15 01:41:21.027256
1158	3		whey protein inner armour phedracut	5lb	whey protein 5lb inner armour phedracut	51.99	2025-04-15 01:41:21.157265
1162	3		wafer bar qnt	35 gr	wafer bar 35 gr qnt	1.99	2025-04-15 01:41:21.289255
1166	3		protein coffee ostrovit	\N	protein coffee ostrovit	14.99	2025-04-15 01:41:21.418092
1170	3		dark bar integralmedica	90gr	dark bar 90gr integralmedica	2.69	2025-04-15 01:41:21.544027
1174	3		prostar whey creatina nutrex 300gr shaker fire	5lb	prostar whey 5lb creatina nutrex 300gr shaker fire	82.98	2025-04-15 01:41:21.668191
1178	4	ostrovit	ostrovit 100% whey ostrovit	1.5 lbs	ostrovit 100% whey ostrovit 1.5 lbs	19990.00	2025-04-15 01:41:58.987499
1182	4	animal	animal animal whey isolate	2 lbs	animal animal whey isolate 2 lbs	47990.00	2025-04-15 01:41:59.116582
1186	4	dymatize	dymatize iso 100	3 lbs	dymatize iso 100 3 lbs	69990.00	2025-04-15 01:41:59.362799
1190	4	nutrex	nutrex isofit	5.1 lbs	nutrex isofit 5.1 lbs	89990.00	2025-04-15 01:41:59.49135
1194	4	animal	animal isolate whey protein animal	4 lb	animal isolate whey protein animal 4 lb	61990.00	2025-04-15 01:42:06.570154
1198	4	simply	simply muestra simply whey protein	\N	simply muestra simply whey protein	1990.00	2025-04-15 01:42:06.695899
1202	4	muscletech	muscletech nitro tech 100% whey gold	2.5 lbs	muscletech nitro tech 100% whey gold 2.5 lbs	41990.00	2025-04-15 01:42:06.941446
1206	4	muscletech	muscletech nitro tech	4 lbs	muscletech nitro tech 4 lbs	61990.00	2025-04-15 01:42:07.183115
1210	4	rule 1	rule 1 rule1 whey protein blend	2 lbs	rule 1 rule1 whey protein blend 2 lbs	34990.00	2025-04-15 01:42:14.291306
1214	4	ostrovit	ostrovit whey protein sin sabor wpc80	15 lb	ostrovit whey protein sin sabor wpc80 15 lb	21990.00	2025-04-15 01:42:14.540565
\.


--
-- Data for Name: scrap_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scrap_data (scrap_id, source, data, price) FROM stdin;
1	1	optimum nutrition gold standard 100% whey protein 5 lb original	$88.990$90.990
2	1	ultimate nutrition prostar whey whey protein 5 lb original	$69.690$81.990
3	1	winkler whey pro win 44 lb	$81.990
4	1	optimum nutrition gold standard 100% whey protein 2 lb original	$53.990$55.990
5	1	muscletech nitro tech 100% whey gold 5 lb original	$85.990$89.990
6	1	ultimate nutrition prostar whey whey protein 2 lb original	$48.990$51.990
7	1	muscletech nitro tech whey protein 4 lb original	$79.990
8	1	myprotein impact whey protein 2.5 kg	$78.990$81.990
9	1	quest quest protein cookie snack proteico 59 gr	$4.190
10	1	bsn syntha 6 whey protein 5 lb original	$77.990
11	1	sportlab whey matrix whey protein 5 lb original	$84.990$86.990
12	1	dymatize iso 100 isolate protein 5 lb	$119.990
13	1	ultimate nutrition prostar whey whey protein 1 lb original	$31.990$32.990
14	1	ultimate nutrition prostar 100% raw whey protein 22 lb original	$48.990$51.990
15	1	muscletech nitro tech whey protein 2 lb original	$49.990
16	1	optimum nutrition 100% whey protein isolate gold standard 5 lb original	$110.990$112.990
17	1	winkler whey pro win 22 lb	$54.990
18	1	optimum nutrition gold standard 100% whey protein 4.65 lb original	$88.990$90.990
19	1	muscletech nitro tech 100% whey gold 2 lb original	$55.990
20	1	nutrex isofit isolate protein 5 lb original	$103.990$105.990
21	1	optimum nutrition 100% whey protein isolate gold standard 2.91 lb original	$74.990$75.990
22	1	nutrex isofit isolate protein 23 lb original	$59.990$61.990
23	1	optimum nutrition gold standard 100% whey protein 1.85 lb original	$53.990$55.990
24	1	bsn syntha 6 whey protein 29 lb original	$55.990
25	1	integralmedica whey 100% pure whey protein 2 lb original	$38.990
26	1	myprotein impact whey isolate 25 kg	$103.990$105.990
27	1	nutrex isofit isolate protein 5 lb	$103.990$105.990
28	1	ultimate nutrition whey gold whey protein 5 lb original	$74.990
29	1	sportlab isolate matrix isolate protein 2 lb original	$61.990
30	1	dymatize iso 100 hydrolized 1.43 lb dm	$60.990
31	1	mutant whey 5 lb mutant	$55.990$69.990
32	1	ultimate nutrition iso cool isolate protein 2 lb original	$59.990
33	1	dymatize iso 100 hydrolized 1.36 lb dm	$60.990
34	1	nutrex isofit 21 lb vainilla cream	$59.990$61.990
35	1	winkler prote muscle 500 cc winkler	$2.990
36	1	ultimate nutrition whey gold whey protein 2 lb original	$46.990
37	1	mutant iso surge 5lb mutant	$80.740$94.990
38	1	ultimate nutrition iso cool isolate protein 5 lb original	$103.990$105.990
39	1	sportlab whey matrix woman chocolate berries 2 lbs sportlab	$31.190$47.990
40	1	isopure isopure zero carb protein 3 lb	$64.990
41	1	quest protein bar mini quest	$2.990
42	1	isopure isopure zero carb protein 4.5 lb	$90.990
43	1	syntrax nect 2lb syn	$62.990
44	1	isopure isopure zero carb protein 1 lb unflavored	$29.990
45	1	isopure isopure low carb protein 1 lb chocolate	$29.990
46	1	muscletech grassfed 100% whey protein 1.8 lb mtech	$49.990
47	1	sportlab whey matrix whey protein 2 lb original	$50.990
48	1	winkler whey pro win sachet 33 grs wkl	$2.990
49	1	syntrax nectar grab n go isolate protein 31 gr original	$4.190
50	1	quest frosted cookies quest	$3.390
51	1	easybody skinny protein 450g easy	$23.790$33.990
52	1	mutant whey 10 lb mutant	$93.490$109.990
53	1	mutant 100% whey dual 4 lb triple chocolate/vanilla ice cream mtant	$56.790$70.990
54	1	integralmedica whey 100% pure whey protein 4 lb original	$61.990
55	1	integralmedica my whey protein pouch 900gr im	$50.990
56	1	integralmedica nutri whey protein 4 lb original	$44.990
57	1	integralmedica nutri whey protein 2 lb original	$25.990
58	1	integralmedica protein whey bar vo2 im	$1.490
59	1	chef protein chef protein 2.8lb sin sabor	$54.990
60	1	optimum nutrition gold standard 100% isolate chocolate bliss gf 1.64 lb on	$46.990
61	1	syntrax nectar isolate proteína 2 lb sin cafeína	$53.990
62	1	optimum nutrition gold standard 100% isolate vainilla gf 1.58 lb on	$46.990
63	1	syntrax nect latte 2lb syn	$62.990
64	1	integralmedica my whey protein rtd 250ml im	$3.990
65	1	syntrax nect medical 2lb unflavored syn	$62.990
66	1	qnt light digest whey pro 11 lb	$28.990
67	1	nutrex whey protein 100% whey 5lb	$78.990
98	2	ultimate nutrition ultimate nutrition prostar 5 lb	$ 66.990
99	2	optimum nutrition on whey gold standard 5 lb	$ 76.990
100	2	biotechusa biotech 100% pure whey 1 servicio	$ 2.000
101	2	optimum nutrition on whey gold standard 1 servicio	$ 2.500
102	2	ostrovit ostrovit whey protein wpc80 700 gr sin sabor	$ 21.990
103	2	ultimate nutrition ultimate nutrition prostar 2 lb	$ 38.990
104	2	optimum nutrition on whey gold standard 2 lb	$ 46.990
105	2	ostrovit ostrovit 100% whey protein 2000 gr	$ 46.990
106	2	muscletech muscletech nitrotech 4 lb	$ 59.990
107	2	biotechusa biotech 100% pure whey 5 lb	$ 62.990
108	2	nutrabio nutrabio classic whey protein 5 lb	$ 64.990
109	2	muscletech muscletech nitrotech whey gold 5 lb	$ 67.990
110	2	my protein myprotein impact whey 5.5 lb	$ 69.990
111	2	dymatize dymatize elite 100% whey protein 5 lb	$ 69.990
112	2	ostrovit ostrovit 100% whey protein 700 gr	$ 19.990
113	3	100% whey protein isolate gold standard 5lb on	$ 99.990
115	3	iso 100 5lb dymatize phedracut	$ 91.990
116	3	impact whey isolate 25 kg my protein	$ 89.990
117	3	iso hd 90 cfm 4.4 lb amix	$ 86.990
120	3	isolate 5lb kiffer	$ 79.990
121	3	gold standard 5lb on phedracut	$ 76.990
122	3	nitro tech 4lb muscletech	$ 61.990
123	3	prostar 5lb whey phedracut	$ 66.990
124	3	nitro whey gold 5lb phedracut	$ 64.990
125	3	whey 5 lb mutant phedracut	$ 56.990
126	3	impact whey 5lb phedracut	$ 69.990
127	3	ration whey redcon1 shaker fire	$ 54.990
128	3	whey 5lb performance kiffer phedracut	$ 56.990
129	3	whey hd 4.1lb bpi phedracut	$ 46.990
130	3	elite whey 5lb dymatize phedracut	$ 66.990
131	3	protein bite 55gr your goal	$ 2.490
132	3	platinium 8hour protein muscletech 4.6 lb	$ 66.990
133	3	whey protein 5lb inner armour phedracut	$ 51.990
134	3	whey 2 kg protein ostrovit quemador phedracut usn	$ 44.990
135	3	proteína metapure whey isolate 500 ml qnt	$ 2.790
136	3	crunchy bar 65gr qnt	$ 2.990
137	3	wafer bar 35 gr qnt	$ 1.990
138	3	protein shake 330 ml qnt	$ 2.990
139	3	twentys 60gr your goal	$ 2.690
140	3	whey gold 6 lb pvl	$ 59.990
141	3	protein coffee ostrovit	$ 14.990
142	3	your protein whey 1.28 kg	$ 46.990
143	3	your protein bar	$ 1.590
144	3	protein crisp bar 45 gr integralmedica	$ 1.701
145	3	dark bar 90gr integralmedica	$ 2.691
146	3	whey protein 100% 5lb nutrex quemador phedracut usn	$ 54.990
147	3	c4 whey protein cellucor quemador phedracut usn	$ 69.990
152	4	ostrovit 100% whey isolate 4 lbs ostrovit	$69.990
153	4	ostrovit 100% whey ostrovit 1.5 lbs	$19.990
154	4	ostrovit 100% whey protein 4.4 lbs ostrovit	$56.990
155	4	simply 100% whey protein simply 5 lb	$69.990
156	4	animal animal 100% whey protein 4 lbs	$54.990
157	4	animal animal whey isolate 2 lbs	$47.990
158	4	cellucor c4 whey protein hersheys reeses	$71.990
159	4	dymatize elite 100% whey 5 lbs	$72.990
160	4	dymatize iso 100 1.4 lbs	$49.990
161	4	dymatize iso 100 3 lbs	$69.990
162	4	dymatize iso 100 5 lbs	$99.990
163	4	bpi sports iso hd 5 lbs	$79.990
164	4	abe iso whey abe 2 lbs	$47.990
165	4	nutrex isofit 5.1 lbs	$89.990
166	4	finaflex isolate protein finaflex 55 lb	$89.990
167	4	finaflex isolate protein finaflex 55 lb polera finaflex	$89.990
168	4	simply isolate protein simply 5 lb	$89.990
169	4	animal isolate whey protein animal 10 lb	$129.990
170	4	animal isolate whey protein animal 4 lb	$61.990
171	4	redcon 1 isotope 5 lbs	$74.990
172	4	finaflex muestra clear protein finaflex	$1.990
173	4	optimum nutrition muestra gold standard 100% whey	$1.990
174	4	simply muestra simply whey protein	$1.990
175	4	muscletech nitro tech 10 lbs	$129.990
176	4	muscletech nitro tech 100% whey gold 2.5 lbs	$41.990
177	4	muscletech nitro tech 100% whey gold 5 lbs	$79.990
178	4	muscletech nitro tech 100% whey gold edición limitada 5 lbs	$79.990
179	4	muscletech nitro tech 2.2 lbs	$44.990
180	4	muscletech nitro tech 4 lbs	$61.990
181	4	ostrovit protein coffee proteina cafeina	$19.990
182	4	ostrovit protein shake 1.5 lbs sabores	$19.990
183	4	redcon 1 ration 5 lbs redcon1	$59.990
184	4	rule 1 rule1 whey protein blend 2 lbs	$34.990
185	4	rule 1 rule1 whey protein blend 5 lbs	$64.990
186	4	rule 1 rule1 whey protein isolate hydrolyzed 5 lb	$89.990
187	4	bpi sports whey hd 4 lbs	$59.990
188	4	ostrovit whey protein sin sabor wpc80 15 lb	$21.990
189	4	ostrovit 100% whey isolate 4 lbs ostrovit	$69.990
190	4	ostrovit 100% whey ostrovit 1.5 lbs	$19.990
191	4	ostrovit 100% whey protein 4.4 lbs ostrovit	$56.990
192	4	simply 100% whey protein simply	$69.990
193	4	animal animal 100% whey protein 4 lbs	$54.990
194	4	animal animal whey isolate 2 lbs	$47.990
195	4	cellucor c4 whey protein hersheys reeses	$71.990
196	4	dymatize elite 100% whey 5 lbs	$72.990
197	4	dymatize iso 100 1.4 lbs	$49.990
198	4	dymatize iso 100 3 lbs	$69.990
199	4	dymatize iso 100 5 lbs	$99.990
200	4	bpi sports iso hd 5 lbs	$79.990
201	4	abe iso whey abe 2 lbs	$47.990
202	4	nutrex isofit 5.1 lbs	$89.990
203	4	finaflex isolate protein finaflex 5	$89.990
204	4	simply isolate protein simply	$89.990
205	4	animal isolate whey protein animal	$129.990
206	4	animal isolate whey protein animal	$61.990
207	4	redcon 1 isotope 5 lbs	$74.990
208	4	finaflex muestra clear protein finaflex	$1.990
209	4	optimum nutrition muestra gold standard 100% whey	$1.990
210	4	simply muestra simply whey protein	$1.990
211	4	metabolic nutrition musclean 2.5 lbs	$44.990
212	4	metabolic nutrition musclean 5 lbs	$74.990
213	4	muscletech nitro tech 10 lbs	$129.990
214	4	muscletech nitro tech 100% whey gold 2.5 lbs	$41.990
215	4	muscletech nitro tech 100% whey gold 5 lbs	$79.990
216	4	muscletech nitro tech 100% whey gold edición limitada 5 lbs	$79.990
217	4	muscletech nitro tech 2.2 lbs	$44.990
218	4	muscletech nitro tech 4 lbs	$61.990
219	4	ostrovit protein coffee proteina cafeina	$19.990
220	4	ostrovit protein shake 1.5 lbs sabores	$19.990
221	4	redcon 1 ration 5 lbs redcon1	$59.990
222	4	rule 1 rule1 whey protein blend 2 lbs	$34.990
223	4	rule 1 rule1 whey protein blend 5 lbs	$64.990
224	4	rule 1 rule1 whey protein isolate hydrolyzed	$89.990
225	4	bpi sports whey hd 4 lbs	$59.990
226	4	ostrovit whey protein sin sabor wpc80 1	$21.990
\.


--
-- Name: brand_clusters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.brand_clusters_id_seq', 159, true);


--
-- Name: data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.data_id_seq', 1214, true);


--
-- Name: scrap_data_scrap_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.scrap_data_scrap_id_seq', 226, true);


--
-- Name: brand_clusters brand_clusters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brand_clusters
    ADD CONSTRAINT brand_clusters_pkey PRIMARY KEY (id);


--
-- Name: brand_representatives brand_representatives_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brand_representatives
    ADD CONSTRAINT brand_representatives_pkey PRIMARY KEY (cluster_id);


--
-- Name: data data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data
    ADD CONSTRAINT data_pkey PRIMARY KEY (id);


--
-- Name: scrap_data scrap_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scrap_data
    ADD CONSTRAINT scrap_data_pkey PRIMARY KEY (scrap_id);


--
-- PostgreSQL database dump complete
--

