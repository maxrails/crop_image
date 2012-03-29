require 'RMagick'
require 'rvg/rvg'
include Magick
module ImageCrop

  def get_width_height
    image_magick = Magick::ImageList.new(Rails.root.to_s+'/public'+image.to_s)
    [image_magick.columns,image_magick.rows]
  end

  def process_image_path
    folder_path = "/uploads/picture/image/#{self.id}/"
    new_image_path = Rails.root.to_s+'/public'+folder_path+'temp_test_'+(self.image.to_s.gsub(folder_path,""))
    new_image_path
  end

  def shift(x,h)
    image_magick = ::Magick::Image.read(FileTest.exist?(self.process_image_path) ? self.process_image_path : Rails.root.to_s+'/public'+image.to_s)[0]
    rvg = Magick::RVG.new(image_magick.columns,image_magick.rows) do |canvas|
      canvas.background_fill = 'white'
      canvas.image(image_magick)
      canvas.translate(x,h)
    end
    rvg.draw.write(self.process_image_path)
  end

  def rotate_translate(degree,translatex,translatey,need_scale,height)
    p need_scale
    image_magick = ::Magick::Image.read(FileTest.exist?(self.process_image_path) ? self.process_image_path : Rails.root.to_s+'/public'+image.to_s)[0]
    rvg = Magick::RVG.new(image_magick.columns,image_magick.rows) do |canvas|
      canvas.background_fill = 'white'
      canvas.image(image_magick)
      if need_scale
        canvas.translate(translatex,translatey).scale(height/image_magick.rows.to_f)
        canvas.translate(-translatex,-translatey).rotate(degree,translatex+image_magick.columns/2,translatey+image_magick.rows/2).translate(translatex,translatey)
      else
        canvas.rotate(degree,translatex+image_magick.columns/2,translatey+image_magick.rows/2).translate(translatex,translatey)
      end
    end
    rvg.draw.write(self.process_image_path)
  end

  def crop(x,y,w,h)
    image_magick = Magick::ImageList.new(FileTest.exist?(self.process_image_path) ? self.process_image_path : Rails.root.to_s+'/public'+image.to_s)
    slice = image_magick.crop(x, y, w, h)
    white_bg = Magick::Image.new(image_magick.columns, image_magick.rows)
    image_magick = white_bg.composite(slice, x, y,Magick::OverCompositeOp)
    image_magick.write(self.process_image_path)
  end

  def scale(width,translatex,translatey)
    image_magick = ::Magick::Image.read(FileTest.exist?(self.process_image_path) ? self.process_image_path : Rails.root.to_s+'/public'+image.to_s)[0]
    rvg = Magick::RVG.new(image_magick.columns,image_magick.rows) do |canvas|
      canvas.background_fill = 'white'
      canvas.image(image_magick)
      canvas.translate(translatex,translatey).scale(width/image_magick.columns.to_f)
    end
    rvg.draw.write(self.process_image_path)
  end

end
