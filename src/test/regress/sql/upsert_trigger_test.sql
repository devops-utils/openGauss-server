\c upsert
SET CURRENT_SCHEMA TO upsert_test;
-- enable_upsert_to_merge must be off, or upsert will be translated to merge.
SET enable_upsert_to_merge TO OFF;
SHOW enable_upsert_to_merge;

CREATE FUNCTION upsert_before_func()
  RETURNS TRIGGER language plpgsql AS
$$
BEGIN
  IF (TG_OP = 'UPDATE') THEN
    RAISE warning 'before update (old): %', old.*::TEXT;
    RAISE warning 'before update (new): %', new.*::TEXT;
  elsIF (TG_OP = 'INSERT') THEN
    RAISE warning 'before insert (new): %', new.*::TEXT;
    IF NEW.key % 2 = 0 THEN
      NEW.color := NEW.color || ' trig modified';
      RAISE warning 'before insert (new, modified): %', new.*::TEXT;
    END IF;
  END IF;
  RETURN new;
END;
$$;
CREATE TRIGGER upsert_before_trig BEFORE INSERT OR UPDATE ON t_trigger
  FOR EACH ROW EXECUTE procedure upsert_before_func();

CREATE FUNCTION upsert_after_func()
  RETURNS TRIGGER language plpgsql AS
$$
BEGIN
  IF (TG_OP = 'UPDATE') THEN
    RAISE warning 'after update (old): %', old.*::TEXT;
    RAISE warning 'after update (new): %', new.*::TEXT;
  elsIF (TG_OP = 'INSERT') THEN
    RAISE warning 'after insert (new): %', new.*::TEXT;
  END IF;
  RETURN null;
END;
$$;
CREATE TRIGGER upsert_after_trig AFTER INSERT OR UPDATE ON t_trigger
  FOR EACH ROW EXECUTE procedure upsert_after_func();

INSERT INTO t_trigger values(1, 'black') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;
INSERT INTO t_trigger values(2, 'red') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;
INSERT INTO t_trigger values(3, 'orange') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;
INSERT INTO t_trigger values(4, 'green') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;
INSERT INTO t_trigger values(5, 'purple') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;
INSERT INTO t_trigger values(6, 'white') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;
INSERT INTO t_trigger values(7, 'pink') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;
INSERT INTO t_trigger values(8, 'yellow') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;

SELECT * FROM t_trigger ORDER BY key;

INSERT INTO t_trigger values(2, 'black') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;
INSERT INTO t_trigger values(3, 'red') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;
INSERT INTO t_trigger values(4, 'orange') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;
INSERT INTO t_trigger values(5, 'green') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;
INSERT INTO t_trigger values(6, 'purple') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;
INSERT INTO t_trigger values(7, 'white') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;
INSERT INTO t_trigger values(8, 'pink') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;
INSERT INTO t_trigger values(9, 'yellow') ON DUPLICATE KEY UPDATE color = 'updated ' || t_trigger.color;

SELECT * FROM t_trigger ORDER BY key;