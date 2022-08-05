BEGIN;

CREATE TABLE IF NOT EXISTS nodes (
    -- Columns --
    id BIGSERIAL,
    content ne_str_t,

    -- Constraints --
    PRIMARY KEY (id),
    UNIQUE(content)
);

CREATE TABLE IF NOT EXISTS edges (
    -- Columns --
    id BIGSERIAL,
    lid fk_id63_t,
    rid fk_id63_t,
    direction direction_t,

    -- Constraints --
    PRIMARY KEY (id),
    UNIQUE(lid, rid, direction)
);

CREATE TABLE IF NOT EXISTS labels (
    -- Columns --
    id BIGSERIAL,
    label ne_str_t,

    -- Constraints --
    PRIMARY KEY (id),
    UNIQUE(label)
);

CREATE TABLE IF NOT EXISTS walks ( 
    -- Traversing a graph forms a walk. A walk is a sequence of adjacent edges.
    -- Vertices and edges in a walk can be repeated.

    -- Columns --
    id BIGSERIAL,

    -- Constraints --
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS w2e ( -- 'w2e' means 'walks to edges'
    -- Columns --
    id BIGSERIAL,
    walk_id fk_id63_t,
    edge_id fk_id63_t,

    -- Constraints --
    PRIMARY KEY (id),
    FOREIGN KEY (walk_id) REFERENCES walks (id),
    FOREIGN KEY (edge_id) REFERENCES edges (id)
);

CREATE TABLE IF NOT EXISTS l2n ( -- 'l2n' means 'labels to nodes'
    -- Columns --
    id BIGSERIAL,
    label_id fk_id63_t,
    node_id fk_id63_t,

    -- Constraints --
    PRIMARY KEY (id),
    FOREIGN KEY (label_id) REFERENCES labels (id),
    FOREIGN KEY (node_id) REFERENCES nodes (id),
    UNIQUE(label_id, node_id)
);

CREATE TABLE IF NOT EXISTS l2w ( -- 'l2w' means 'labels to walks'
    -- Columns --
    id BIGSERIAL,
    label_id fk_id63_t,
    walk_id fk_id63_t,

    -- Constraints --
    PRIMARY KEY (id),
    FOREIGN KEY (label_id) REFERENCES labels (id),
    FOREIGN KEY (walk_id) REFERENCES walks (id),
    UNIQUE(label_id, walk_id)
);

COMMIT;