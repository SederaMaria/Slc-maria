class CreateApplicationIdentifierDatabaseLogic < ActiveRecord::Migration[5.0]
  def up
    ActiveRecord::Base.connection.execute <<-SQL

    CREATE TABLE curr_date (
      value character varying(8)
    );

    INSERT INTO curr_date (value) VALUES ('20170613');
    
    CREATE SEQUENCE next_application_identifier_seq
      START WITH 1
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      CACHE 1;

    CREATE FUNCTION next_application_identifier_func() RETURNS character varying
      LANGUAGE plpgsql
      AS $$
            DECLARE
              current_application_date varchar(8) := (SELECT to_char(clock_timestamp() at time zone 'EST5EDT', 'yyyymmdd'));
              last_application_date varchar(8):= (SELECT value FROM curr_date LIMIT 1)::varchar(8);
              dated_id varchar(12);

            BEGIN
              IF current_application_date != last_application_date THEN
                  ALTER SEQUENCE next_application_identifier_seq RESTART WITH 1;
                  DELETE FROM curr_date;
                  INSERT INTO curr_date (value) VALUES (current_application_date);
              END IF;
              dated_id := (SELECT to_char(clock_timestamp() at time zone 'EST5EDT', 'yyyymmdd')||trim(to_char(nextval('next_application_identifier_seq'),'0999')));
              RETURN dated_id;
            END;
          $$;

    SQL
  end

  def down
    ActiveRecord::Base.connection.execute <<-SQL
      DROP TABLE curr_date;
      DROP FUNCTION next_application_identifier_func();
      DROP SEQUENCE next_application_identifier_seq;
    SQL
  end
end
