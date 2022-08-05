BEGIN;

CREATE TYPE dtypes_enum_t AS ENUM ( -- Here 'dtypes' is contraction for 'data types'.
    'i1',
    'i2',
    'i3',
    'i4',
    'i5',
    'i6',
    'i7',
    'i8',
    'i16',
    'i24',
    'i32',
    'i64',
    'u1',
    'u2',
    'u3',
    'u4',
    'u5',
    'u6',
    'u7',
    'u8',
    'u16',
    'u24',
    'u32',
    'u64',
    'bool',
    'blittable',
    'ch',
    'ne_str',
    'ipv4',
    'ipv6',

    -- nullable types
    'i1_or_null',
    'i2_or_null',
    'i3_or_null',
    'i4_or_null',
    'i5_or_null',
    'i6_or_null',
    'i7_or_null',
    'i8_or_null',
    'i16_or_null',
    'i24_or_null',
    'i32_or_null',
    'i64_or_null',
    'u1_or_null',
    'u2_or_null',
    'u3_or_null',
    'u4_or_null',
    'u5_or_null',
    'u6_or_null',
    'u7_or_null',
    'u8_or_null',
    'u16_or_null',
    'u24_or_null',
    'u32_or_null',
    'u64_or_null',
    'bool_or_null',
    'blittable_or_null',
    'ch_or_null',
    'ne_str_or_null',
    'ipv4_or_null',
    'ipv6_or_null'
);


CREATE DOMAIN bool_or_null_t AS
    bool;

CREATE DOMAIN blittable_or_null_t AS
    -- Blittable means one contiguous block of bytes.
    -- Non-blittable means many non-adjacent contiguous block of bytes.
    bool;

CREATE DOMAIN ch_or_null_t AS
    -- https://www.postgresql.org/docs/current/datatype-character.html
    --   In fact CHARACTER(n) is usually the slowest of the three because of its additional storage costs.
    --   In most situations TEXT or VARCHAR should be used instead.
    varchar(1) CHECK (char_length(value) > 0);

CREATE DOMAIN ne_str_or_null_t AS  -- '_ne_' means non-empty
    TEXT CHECK (char_length(value) > 0);


-- inet
--   The inet type holds an IPv4 or IPv6 host address, and optionally its subnet, all in one field.
--   The input format for this type is address/y where address is an IPv4 or IPv6 address and y is the number of bits in the netmask.
--   If the /y portion is omitted, the netmask is taken to be 32 for IPv4 or 128 for IPv6, so the value represents just a single host.
--   On display, the /y portion is suppressed if the netmask specifies a single host.
-- cidr
--   The cidr type holds an IPv4 or IPv6 network specification.
--   The format for specifying networks is address/y where address is the network's lowest address represented as an IPv4 or IPv6 address,
--   and y is the number of bits in the netmask.
--   If y is omitted, it is calculated using assumptions from the older classful network numbering system, except it will be at least
--   large enough to include all of the octets written in the input.

CREATE DOMAIN ipv4_or_null_t AS
    inet CHECK ( family(value) = 4);

CREATE DOMAIN ipv6_or_null_t AS
    inet CHECK ( family(value) = 6);

-- i<N> = [ -(2^(N-1)); +(2^(N-1)-1) ]
CREATE DOMAIN i1_or_null_t AS
    int CHECK (value >= -1 AND value <= 0);
CREATE DOMAIN i2_or_null_t AS
    int CHECK (value >= -2 AND value <= 1);
CREATE DOMAIN i3_or_null_t AS
    int CHECK (value >= -4 AND value <= 3);
CREATE DOMAIN i4_or_null_t AS
    int CHECK (value >= -8 AND value <= 7);
CREATE DOMAIN i5_or_null_t AS
    int CHECK (value >= -16 AND value <= 15);
CREATE DOMAIN i6_or_null_t AS
    int CHECK (value >= -32 AND value <= 31);
CREATE DOMAIN i7_or_null_t AS
    int CHECK (value >= -64 AND value <= 63);
CREATE DOMAIN i8_or_null_t AS
    int CHECK (value >= -128 AND value <= 127);

CREATE DOMAIN i16_or_null_t AS
    -- [ 32_768; +32_767 ]
    smallint; -- CHECK (value >= -32768 AND value <= 32767);

CREATE DOMAIN i24_or_null_t AS
    -- [ -8_388_608; +8_388_607 ]
    int CHECK (value >= -8388608 AND value <= 8388607);

CREATE DOMAIN i32_or_null_t AS
    -- [ -2_147_483_648; +2_147_483_647 ]
    int;  -- CHECK (value >= -2147483648 AND value <= 2147483647);

CREATE DOMAIN i64_or_null_t AS
    -- [ -9_223_372_036_854_775_808; +9_223_372_036_854_775_807 ]
    bigint; -- CHECK (value >= -9223372036854775808 AND value <= 9223372036854775807);

-- u<N> = [ 0; +((2^N)-1) ]
CREATE DOMAIN u1_or_null_t AS
    int CHECK (value >= 0 AND value <= 1);
CREATE DOMAIN u2_or_null_t AS
    int CHECK (value >= 0 AND value <= 3);
CREATE DOMAIN u3_or_null_t AS
    int CHECK (value >= 0 AND value <= 7);
CREATE DOMAIN u4_or_null_t AS
    int CHECK (value >= 0 AND value <= 15);
CREATE DOMAIN u5_or_null_t AS
    int CHECK (value >= 0 AND value <= 31);
CREATE DOMAIN u6_or_null_t AS
    int CHECK (value >= 0 AND value <= 63);
CREATE DOMAIN u7_or_null_t AS
    int CHECK (value >= 0 AND value <= 127);
CREATE DOMAIN u8_or_null_t AS
    int CHECK (value >= 0 AND value <= 255);

CREATE DOMAIN u16_or_null_t AS
    -- [0; +65_535]
    int CHECK (value >= 0 AND value <= 65535);

CREATE DOMAIN u24_or_null_t AS
    -- [0; +16_777_215]
    int CHECK (value >= 0 AND value <= 16777215);

CREATE DOMAIN u32_or_null_t AS
    -- [0; +4_294_967_295]
    bigint CHECK (value >= 0 AND value <= 4294967295);

CREATE DOMAIN u63_or_null_t AS
    -- [ 0; +9_223_372_036_854_775_807 ]
    bigint CHECK (value >= 0 AND value <= 9223372036854775807);

-- CREATE DOMAIN u64_or_null_t AS
--   -- Unimplemented in PGSQL
--   -- [ 0; +18_446_744_073_709_551_615 ]
--   -- select (9223372036854775808 * 2) - 1;
--   --        ?column?
--   -- ----------------------
--   --  18446744073709551615
--   -- (1 row)
--   int CHECK (value >= 0 AND value <= 18446744073709551615);

CREATE DOMAIN fk_id15_or_null_t AS
    -- [ 1; +32_767 ]
    id15_t;

CREATE DOMAIN fk_id31_or_null_t AS
    -- [ 1; +2_147_483_647 ]
    id31_t;

CREATE DOMAIN fk_id63_or_null_t AS
    -- [ 1; +9_223_372_036_854_775_807 ]
    id63_t;

CREATE DOMAIN direction_or_null_t AS
    directions_enum_t;


-- -- Create new TYPE or DOMAIN and suppres error if its exists.
-- DO $$ BEGIN
--  -- ...
-- EXCEPTION
--     WHEN duplicate_object THEN NULL;
-- END $$;

COMMIT;