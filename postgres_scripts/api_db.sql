CREATE ROLE api_user
    LOGIN
    PASSWORD 'ApiUserPassword123';

CREATE DATABASE api_db;

GRANT ALL PRIVILEGES ON DATABASE api_db TO api_user;


CREATE TABLE api(
    api_id SERIAL PRIMARY KEY,

    -- Identity
    name TEXT NOT NULL,
    provider TEXT NOT NULL,
    description TEXT,

    -- Connection
    base_url TEXT NOT NULL,
    version TEXT,
    connection_id TEXT,

    -- Capabilities
    paginated BOOLEAN NOT NULL DEFAULT FALSE,
    supports_incremental BOOLEAN NOT NULL DEFAULT FALSE,
    supports_bulk BOOLEAN NOT NULL DEFAULT FALSE,

    -- Rate limiting
    rate_limit_requests INTEGER,
    rate_limit_period_seconds INTEGER,
    locked BOOLEAN NOT NULL DEFAULT FALSE,
    locked_until TIMESTAMPTZ,

    -- Usage
    last_accessed TIMESTAMPTZ,
    last_downloaded TIMESTAMPTZ,

    -- Operational state
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    status TEXT NOT NULL DEFAULT 'ACTIVE',
    last_success TIMESTAMPTZ,
    last_failure TIMESTAMPTZ,
    last_error TEXT DEFAULT '',

    -- Audit
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Misc
    additional JSONB, -- configuration not yet represented by a column
    override JSONB -- runtime configuration override
);


CREATE TABLE api_resource(
    resource_id SERIAL PRIMARY KEY,
    api_id INTEGER NOT NULL REFERENCES api(api_id),

    name TEXT NOT NULL,
    endpoint TEXT NOT NULL,
    method TEXT NOT NULL DEFAULT 'GET',

    parameters JSONB,

    api_key_reference TEXT NOT NULL, -- Reference for api key stored in airflow

    pagination_type TEXT,
    pagination_config JSONB,

    incremental_strategy TEXT,
    incremental_field TEXT,
    initial_value TEXT,

    schedule TEXT,

    destination TEXT,
    destination_table TEXT,

    enabled BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    additional JSONB,
    override JSONB,

    UNIQUE (api_id, name)
);


CREATE TABLE resource_state(
    resource_id INTEGER PRIMARY KEY REFERENCES api_resource(resource_id) ON DELETE CASCADE,

    cursor TEXT,

    last_run TIMESTAMPTZ,
    last_success TIMESTAMPTZ,
    next_run TIMESTAMPTZ,

    rows_loaded BIGINT NOT NULL DEFAULT 0,
    bytes_loaded BIGINT NOT NULL DEFAULT 0,

    status TEXT NOT NULL DEFAULT 'PENDING',
    last_error TEXT,

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

GRANT ALL ON SCHEMA public TO api_user;