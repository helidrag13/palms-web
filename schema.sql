-- DROP SCHEMA public;

CREATE SCHEMA public AUTHORIZATION uf29k87u983ka6;

COMMENT ON SCHEMA public IS 'standard public schema';
-- public.brands definition

-- Drop table

-- DROP TABLE public.brands;

CREATE TABLE public.brands (
	id int8 NOT NULL,
	"name" varchar NOT NULL,
	CONSTRAINT brands_pk PRIMARY KEY (id)
);


-- public.failure_mechanisms_types definition

-- Drop table

-- DROP TABLE public.failure_mechanisms_types;

CREATE TABLE public.failure_mechanisms_types (
	id int8 NOT NULL,
	parent_id int8 NULL,
	"name" varchar NOT NULL,
	CONSTRAINT failure_mechanisms_types_pk PRIMARY KEY (id),
	CONSTRAINT failure_mechanisms_types_failure_mechanisms_types_fk FOREIGN KEY (parent_id) REFERENCES public.failure_mechanisms_types(id)
);


-- public.locations definition

-- Drop table

-- DROP TABLE public.locations;

CREATE TABLE public.locations (
	id varchar NOT NULL,
	parent_id varchar NULL,
	"name" varchar NOT NULL,
	quantity int8 DEFAULT 0 NOT NULL,
	CONSTRAINT id_format CHECK (((id)::text ~ '^[0-9]+(\.[0-9]+)*$'::text)),
	CONSTRAINT locations_pk PRIMARY KEY (id),
	CONSTRAINT parent_id_fk FOREIGN KEY (parent_id) REFERENCES public.locations(id)
);


-- public.spares_types definition

-- Drop table

-- DROP TABLE public.spares_types;

CREATE TABLE public.spares_types (
	id varchar NOT NULL,
	parent_id varchar NULL,
	"name" varchar NOT NULL,
	function_desc varchar NULL,
	functional_failure_desc varchar NULL,
	CONSTRAINT id_format CHECK (((id)::text ~ '^[0-9]+(\.[0-9]+)*$'::text)),
	CONSTRAINT spare_types_pk PRIMARY KEY (id),
	CONSTRAINT spare_types_parent_fk FOREIGN KEY (parent_id) REFERENCES public.spares_types(id)
);


-- public.failure_mechanisms definition

-- Drop table

-- DROP TABLE public.failure_mechanisms;

CREATE TABLE public.failure_mechanisms (
	id int8 NOT NULL,
	failure_mechanism_type_id int8 NOT NULL,
	"name" varchar NOT NULL,
	CONSTRAINT failure_mechanisms_pk PRIMARY KEY (id),
	CONSTRAINT failure_mechanisms_failure_mechanisms_types_fk FOREIGN KEY (failure_mechanism_type_id) REFERENCES public.failure_mechanisms_types(id)
);


-- public.spares definition

-- Drop table

-- DROP TABLE public.spares;

CREATE TABLE public.spares (
	id varchar NOT NULL,
	spare_type_id varchar NOT NULL,
	brand_id int8 NOT NULL,
	model varchar NULL,
	brand_part_number varchar NOT NULL,
	"desc" varchar NULL,
	CONSTRAINT id_format CHECK (((id)::text ~ '^[0-9]+(\.[0-9]+)*$'::text)),
	CONSTRAINT spare_pk PRIMARY KEY (id),
	CONSTRAINT spare_type_id_fk FOREIGN KEY (spare_type_id) REFERENCES public.spares_types(id),
	CONSTRAINT spares_brands_fk FOREIGN KEY (brand_id) REFERENCES public.brands(id)
);


-- public.spares_parts_locations definition

-- Drop table

-- DROP TABLE public.spares_parts_locations;

CREATE TABLE public.spares_parts_locations (
	spare_id varchar NOT NULL,
	id varchar NOT NULL,
	parent_spare_id varchar NULL,
	parent_spare_location_id varchar NULL,
	part_spare_id varchar NULL, -- the id of the spare that is a part of the spare referenced by spare_id
	"desc" varchar NOT NULL,
	CONSTRAINT id_format CHECK (((id)::text ~ '^[0-9]+(\.[0-9]+)*$'::text)),
	CONSTRAINT spares_parts_locations_pk PRIMARY KEY (spare_id, id),
	CONSTRAINT spares_parts_locations_part_spare_id_fk FOREIGN KEY (part_spare_id) REFERENCES public.spares(id),
	CONSTRAINT spares_parts_locations_spare_id_fk FOREIGN KEY (spare_id) REFERENCES public.spares(id),
	CONSTRAINT spares_parts_locations_spares_parts_locations_fk FOREIGN KEY (parent_spare_id,parent_spare_location_id) REFERENCES public.spares_parts_locations(spare_id,id)
);

-- Column comments

COMMENT ON COLUMN public.spares_parts_locations.part_spare_id IS 'the id of the spare that is a part of the spare referenced by spare_id';

-- Table Triggers

create trigger trg_prevent_spare_cycle before
insert
    or
update
    on
    public.spares_parts_locations for each row execute function prevent_spare_cycle();


-- public.spares_types_failure_mechanisms definition

-- Drop table

-- DROP TABLE public.spares_types_failure_mechanisms;

CREATE TABLE public.spares_types_failure_mechanisms (
	spare_type_id varchar NOT NULL,
	failure_mechanism_id int8 NOT NULL,
	"index" int8 NOT NULL,
	"desc" varchar NOT NULL,
	CONSTRAINT spares_types_failure_mechanisms_unique UNIQUE (spare_type_id, failure_mechanism_id, index),
	CONSTRAINT spares_types_failure_mechanisms_failure_mechanisms_fk FOREIGN KEY (failure_mechanism_id) REFERENCES public.failure_mechanisms(id),
	CONSTRAINT spares_types_failure_mechanisms_spares_types_fk FOREIGN KEY (spare_type_id) REFERENCES public.spares_types(id)
);


-- public.components definition

-- Drop table

-- DROP TABLE public.components;

CREATE TABLE public.components (
	id varchar NOT NULL,
	location_id varchar NOT NULL,
	"name" varchar NULL,
	spare_id varchar NOT NULL,
	CONSTRAINT components_pk PRIMARY KEY (id),
	CONSTRAINT id_format CHECK (((id)::text ~ '^[0-9]+(\.[0-9]+)*$'::text)),
	CONSTRAINT components_locations_fk FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT components_spare_fk FOREIGN KEY (spare_id) REFERENCES public.spares(id)
);


-- public.pg_stat_statements source

CREATE OR REPLACE VIEW public.pg_stat_statements
AS SELECT userid,
    dbid,
    toplevel,
    queryid,
    query,
    plans,
    total_plan_time,
    min_plan_time,
    max_plan_time,
    mean_plan_time,
    stddev_plan_time,
    calls,
    total_exec_time,
    min_exec_time,
    max_exec_time,
    mean_exec_time,
    stddev_exec_time,
    rows,
    shared_blks_hit,
    shared_blks_read,
    shared_blks_dirtied,
    shared_blks_written,
    local_blks_hit,
    local_blks_read,
    local_blks_dirtied,
    local_blks_written,
    temp_blks_read,
    temp_blks_written,
    blk_read_time,
    blk_write_time,
    temp_blk_read_time,
    temp_blk_write_time,
    wal_records,
    wal_fpi,
    wal_bytes,
    jit_functions,
    jit_generation_time,
    jit_inlining_count,
    jit_inlining_time,
    jit_optimization_count,
    jit_optimization_time,
    jit_emission_count,
    jit_emission_time
   FROM pg_stat_statements(true) pg_stat_statements(userid, dbid, toplevel, queryid, query, plans, total_plan_time, min_plan_time, max_plan_time, mean_plan_time, stddev_plan_time, calls, total_exec_time, min_exec_time, max_exec_time, mean_exec_time, stddev_exec_time, rows, shared_blks_hit, shared_blks_read, shared_blks_dirtied, shared_blks_written, local_blks_hit, local_blks_read, local_blks_dirtied, local_blks_written, temp_blks_read, temp_blks_written, blk_read_time, blk_write_time, temp_blk_read_time, temp_blk_write_time, wal_records, wal_fpi, wal_bytes, jit_functions, jit_generation_time, jit_inlining_count, jit_inlining_time, jit_optimization_count, jit_optimization_time, jit_emission_count, jit_emission_time);


-- public.pg_stat_statements_info source

CREATE OR REPLACE VIEW public.pg_stat_statements_info
AS SELECT dealloc,
    stats_reset
   FROM pg_stat_statements_info() pg_stat_statements_info(dealloc, stats_reset);



-- DROP FUNCTION public.pg_stat_statements(in bool, out oid, out oid, out bool, out int8, out text, out int8, out float8, out float8, out float8, out float8, out float8, out int8, out float8, out float8, out float8, out float8, out float8, out int8, out int8, out int8, out int8, out int8, out int8, out int8, out int8, out int8, out int8, out int8, out float8, out float8, out float8, out float8, out int8, out int8, out numeric, out int8, out float8, out int8, out float8, out int8, out float8, out int8, out float8);

CREATE OR REPLACE FUNCTION public.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision)
 RETURNS SETOF record
 LANGUAGE c
 PARALLEL SAFE STRICT
AS '$libdir/pg_stat_statements', $function$pg_stat_statements_1_10$function$
;

-- DROP FUNCTION public.pg_stat_statements_info(out int8, out timestamptz);

CREATE OR REPLACE FUNCTION public.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone)
 RETURNS record
 LANGUAGE c
 PARALLEL SAFE STRICT
AS '$libdir/pg_stat_statements', $function$pg_stat_statements_info$function$
;

-- DROP FUNCTION public.pg_stat_statements_reset(oid, oid, int8);

CREATE OR REPLACE FUNCTION public.pg_stat_statements_reset(userid oid DEFAULT 0, dbid oid DEFAULT 0, queryid bigint DEFAULT 0)
 RETURNS void
 LANGUAGE c
 PARALLEL SAFE STRICT
AS '$libdir/pg_stat_statements', $function$pg_stat_statements_reset_1_7$function$
;

-- DROP FUNCTION public.prevent_spare_cycle();

CREATE OR REPLACE FUNCTION public.prevent_spare_cycle()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  -- Solo nos interesa cuando haya un part_spare_id no nulo
  IF NEW.part_spare_id IS NOT NULL THEN

    -- Caso trivial: el mismo spare como parte directa de sí mismo
    IF NEW.part_spare_id = NEW.spare_id THEN
      RAISE EXCEPTION 'Ciclo detectado: el spare % no puede contenerse a sí mismo.', NEW.spare_id;
    END IF;

    -- Caso indirecto: recorremos recursivamente todos los part_spare_id
    IF EXISTS (
      WITH RECURSIVE subparts(id) AS (
        -- punto de partida: el repuesto que se está añadiendo como parte
        SELECT NEW.part_spare_id
      UNION
        -- para cada repuesto en la cadena, buscamos sus partes
        SELECT spl.part_spare_id
        FROM public.spares_parts_locations AS spl
        JOIN subparts AS sp ON spl.spare_id = sp.id
        WHERE spl.part_spare_id IS NOT NULL
      )
      -- si en el recorrido aparece el spare original, hay ciclo
      SELECT 1
      FROM subparts
      WHERE id = NEW.spare_id
    ) THEN
      RAISE EXCEPTION
        'Ciclo detectado: al asignar % como parte de % se formaría una recursión.',
        NEW.part_spare_id, NEW.spare_id;
    END IF;
  END IF;

  RETURN NEW;
END;
$function$
;