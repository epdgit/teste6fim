class CreateSorteios < ActiveRecord::Migration[6.0]
  def change
    create_table :sorteios do |t|
      t.integer :concurso
      t.string :data
      t.string :numeros

      t.timestamps
    end
  end
end
