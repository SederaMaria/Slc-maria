class AddLostLesseeConstraints < ActiveRecord::Migration[5.0]
  def change
    Lessee.connection.execute <<-SQL
      ALTER TABLE ONLY lease_applications
        ADD CONSTRAINT fk_rails_2af1552b0b FOREIGN KEY (lessee_id) REFERENCES lessees(id);

      ALTER TABLE ONLY lease_applications
      ADD CONSTRAINT fk_rails_e391a01d42 FOREIGN KEY (colessee_id) REFERENCES lessees(id);
    SQL
  end
end
