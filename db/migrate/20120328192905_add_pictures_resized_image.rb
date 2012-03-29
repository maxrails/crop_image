class AddPicturesResizedImage < ActiveRecord::Migration
  def up
    add_column :pictures, :resized_image, :string
  end

  def down
    remove_column :pictures, :resized_image
  end
end
