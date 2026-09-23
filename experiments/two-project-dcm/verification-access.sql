-- Harness setup after both deployments; this does not grant object privileges.
-- The CLI caller must pin ACCOUNTADMIN and secondary roles NONE.
GRANT ROLE BLZ_DCMX_4X6_SHARED_CONSUMER TO USER BLZ_DCMX_4X6_CONSUMER_USER;
ALTER USER BLZ_DCMX_4X6_CONSUMER_USER SET DEFAULT_ROLE = BLZ_DCMX_4X6_SHARED_CONSUMER;
