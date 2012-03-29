class Picture < ActiveRecord::Base
  include ImageCrop

  mount_uploader :image, ImageUploader
  mount_uploader :resized_image, ImageUploader


  def create_resized
    if FileTest.exists?( self.process_image_path )
      update_attributes( :resized_image=>File.open(self.process_image_path) )
      FileUtils.rm_rf( self.process_image_path )
    else
      update_attributes( :resized_image=>File.open(Rails.root.to_s+'/public'+image.to_s) )
    end
  end
end
